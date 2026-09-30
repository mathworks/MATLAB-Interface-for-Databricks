// Copyright 2026 The MathWorks, Inc.

#include "mex.hpp"
#include "mexAdapter.hpp"

#include "simdutf.cpp"
#include "simdutf.h"

#include <thread>
#include <vector>
#include <unordered_map>

using namespace matlab::data;
using matlab::mex::ArgumentList;

namespace {
    
    // Thin wrapper around std::thread that calls join() in its destructor.
    struct SafeThread {
        std::thread thread;

        template <class F, class... Args>
        SafeThread(F&& f, Args&&... args) 
            : thread{std::forward<F>(f), std::forward<Args>(args)...} {}

        SafeThread(SafeThread&& st) = default;

        ~SafeThread() {
            if (thread.joinable()) {
                thread.join();
            }
        }
    };

    size_t get_expected_byte_sequence_length(uint8_t start) {
        const static std::unordered_map<uint8_t, size_t> sequence_length{
            {0b11110000, 4},
            {0b11100000, 3},
            {0b11000000, 2},
        };
        return sequence_length.at(start & 0b11110000);
    }

    struct ErrorInfo {
        // Number of bytes in the error sequence.
        size_t num_error_bytes;
        // Number of times to insert the replacement character (0xFFFD).
        size_t num_replacement_characters;
    };

    // Returns the number of continuation bytes that the string begins with.
    size_t num_continuation_bytes_up_to(const char* utf8, size_t length) {
        size_t num_cont_bytes = 0;
        while (num_cont_bytes < length) {
            if ((*utf8++ & 0b11000000) != 0b10000000) {
                break;
            }
            ++num_cont_bytes;
        }
        return num_cont_bytes;
    }

    ErrorInfo handle_too_short_error(const char* utf8, size_t length) {
        // Assumes utf8[0] is a leading byte!
        size_t expected_num_cont_bytes = get_expected_byte_sequence_length(*utf8) - 1;
        size_t substring_length = length > expected_num_cont_bytes ? expected_num_cont_bytes : length;        
        size_t num_cont_bytes = num_continuation_bytes_up_to(++utf8, substring_length);
        return {num_cont_bytes + 1, 1};
    }

    ErrorInfo handle_too_long_error(const char* utf8, size_t length) {
        // Assumes utf8[0] is a continuation byte!
        size_t num_cont_bytes = num_continuation_bytes_up_to(utf8, length);
        return {num_cont_bytes, num_cont_bytes};
    }

    ErrorInfo handle_overlong_error(const char utf8) {
        // Assumes utf8[0] is a leading byte!
        const auto seq_length = get_expected_byte_sequence_length(utf8);
        return {seq_length, seq_length};
    }

    ErrorInfo get_error_info(const char* utf8, size_t length, const simdutf::result& result) {
        switch (result.error) {
            case simdutf::error_code::TOO_SHORT:
                return handle_too_short_error(utf8 + result.count, length - result.count);
            case simdutf::error_code::TOO_LONG:
                return handle_too_long_error(utf8 + result.count, length - result.count);
            case simdutf::error_code::OVERLONG:
                return handle_overlong_error(*(utf8 + result.count));
            case simdutf::error_code::TOO_LARGE:
                return {4, 4};
            case simdutf::error_code::SURROGATE:
                return {3, 3};
            default:
                return {1, 1};
        }
    }

    std::basic_string<char16_t> convert_utf8_with_invalid(const char* utf8, size_t length) {
        std::basic_string<char16_t> utf16;

        size_t utf16_length = 0;
        size_t start_offset = 0;

        while (start_offset < length) {
            
            auto curr = utf8 + start_offset;
            auto curr_length = length - start_offset;
            // Compute the number of uchars needed to encode the string, starting at curr, in UTF-16.
            const size_t num_uchars = simdutf::utf16_length_from_utf8(curr, curr_length);
            utf16.resize(utf16_length + num_uchars);
            auto dest = &utf16[0] + utf16_length;
            auto result = simdutf::convert_utf8_to_utf16le_with_errors(curr, curr_length, dest);
            if (result.error == simdutf::error_code::SUCCESS) {
                // Conversion succeeded! 
                utf16_length += result.count;
                start_offset += curr_length;
            } else {
                // Conversion Failed!

                // result.count is the position of the first bad byte in the original string. 
                // Transcode the substring that starts at curr and ends before the first bad byte 
                // (i.e. [curr, curr + result.count).)
                auto count = simdutf::convert_utf8_to_utf16le(curr, result.count, dest);
                // error_info contains the number of bytes in the error sequence
                // and the number of times to append the Unicode replacement 
                // character (U+FFFD) to the UTF-16 string.
                auto error_info = get_error_info(curr, curr_length, result);

                utf16_length += count;
                utf16.resize(utf16_length);
                utf16.append(error_info.num_replacement_characters, 0xFFFD);

                utf16_length += error_info.num_replacement_characters;
                start_offset += result.count + error_info.num_error_bytes;
            }
        }
        return utf16;
    }

    std::basic_string<char16_t> convert_valid_utf8(const char* utf8, size_t length) {
        const size_t num_uchars = simdutf::utf16_length_from_utf8(utf8, length);
        std::basic_string<char16_t> utf16(num_uchars, u'\0');
        std::ignore = simdutf::convert_utf8_to_utf16le(utf8, length, &utf16[0]);
        return utf16;
    }

    std::basic_string<char16_t> convert_utf8_to_utf16le(const char* utf8, size_t length) {    
        if (simdutf::validate_utf8(utf8, length)) {
            return convert_valid_utf8(utf8, length);
        } else {
            return convert_utf8_with_invalid(utf8, length);
        }
    }
}

class MexFunction : public matlab::mex::Function {
private:

    template <typename OffsetType>
    void convert_range(const OffsetType* offsets,
                       const uint8_t* values,
                       TypedArray<matlab::data::MATLABString>& stringArray,
                       const size_t start_offset,
                       const size_t end_offset) {
        for (size_t i = start_offset; i < end_offset; ++i) {
            auto utf8 = reinterpret_cast<const char*>(values + offsets[i]);
            const auto utf8_str_length = offsets[i + 1] - offsets[i];
            auto utf16 = convert_utf8_to_utf16le(utf8, utf8_str_length);
            stringArray[i] = std::move(utf16);
        }
    }

    template <typename OffsetType>
    TypedArray<matlab::data::MATLABString> convert(const TypedArray<OffsetType>& offsetArray,
                                                   const TypedArray<uint8_t>& utf8DataArray,
                                                   const uint64_t maxNumCompThreads) {
        ArrayFactory factory;
        const auto numStrings = offsetArray.getNumberOfElements() - 1;
        auto stringArray = factory.createArray<matlab::data::MATLABString>({numStrings, 1});

        // Extract a raw pointer to the utf8 values
        auto it1(utf8DataArray.cbegin());
        auto dt1 = it1.operator->();
        auto utf8Data = reinterpret_cast<const uint8_t*>(dt1);

        // Extract a raw pointer to the offset values
        auto it2(offsetArray.cbegin());
        auto dt2 = it2.operator->();
        auto offsets = reinterpret_cast<const OffsetType*>(dt2);

        if (maxNumCompThreads < 2 || numStrings < static_cast<size_t>(100000)) {
            // No need to create another thread. Just run the algorithm.
            convert_range(offsets, utf8Data, stringArray, 0, numStrings);
            return stringArray;
        }

        std::vector<SafeThread> threads{};
        threads.reserve(maxNumCompThreads);
        // Number of strings to transcode per thread.
        const size_t block_size = numStrings / maxNumCompThreads;

        for (size_t i = 0; i < maxNumCompThreads; ++i) {

            const size_t start_offset = i * block_size;
            size_t end_offset = (i+1) * block_size;

            if (i == (maxNumCompThreads - 1)) {
                end_offset = numStrings;
            }

            const auto range_fcn = [&, start_offset, end_offset]() {
                convert_range(offsets, utf8Data, stringArray, start_offset, end_offset);
            };

            threads.emplace_back(range_fcn);
        }
        return stringArray;
    }

public:
    void operator()(ArgumentList outputs, ArgumentList inputs) {

        const TypedArray<uint8_t>& utf8DataArray = inputs[1];
        const uint64_t maxNumCompThreads = inputs[2][0];

        if (inputs[0].getType() == ArrayType::INT64) {
            const TypedArray<int64_t>& offsetArray = inputs[0];
            outputs[0] = convert(offsetArray, utf8DataArray, maxNumCompThreads);
        } else {
            const TypedArray<int32_t>& offsetArray = inputs[0];
            outputs[0] = convert(offsetArray, utf8DataArray, maxNumCompThreads);
        }
    }
};
