function mask = unpackBitPackedBuffer(buffer, arrayOffset, arrayLength)
%UNPACKBITPACKEDBUFFER Converts a bitpacked Arrow buffer into a logical
% MATLAB array.
%
%   buffer      - An Arrow buffer that is bitpacked.
%   arrayOffset - The offset of array to which this buffer belongs. Used to
%                 calculate the buffer offset.
%   arrayLength - The length of the array to which this buffer belongs.
%                 Used to calculate the buffer length.

% Copyright 2026 The MathWorks, Inc.
    arguments
        buffer,
        arrayOffset(1, 1) int64
        arrayLength(1, 1) int64
    end

    if arrayLength == 0
        mask = logical.empty(0, 1);
        return;
    end
    % bufferOffset is the offset of the first relevant byte in the buffer.
    bufferOffset = idivide(arrayOffset, int64(8));

    % numBitsToDiscard is the number of bits in the first relevant byte
    % that need to be ignored. For example, suppose arrayOffset is 10. 
    % In this case, bufferOffset would be 1, but the first 2 bits in
    % this byte would need to be ignored.
    numBitsToDiscard = mod(arrayOffset, 8);
    numBitsInPrefixByte = int64(8) - numBitsToDiscard;

    % Calculate the length of the bitpacked buffer, assuming there is at
    % least 1 byte. In general, the number of bytes needed in a bit-packed
    % buffer is equal to ceil(arrayLength / 8). 
    % 
    % However, if bufferOffset is not a multiple of 8, then the formula 
    % for calculating bufferOffset, is 
    % ceil((arrayLength - numBitsInPrefixByte) / 8) + 1.
    bufferLength = idivide(max(arrayLength - numBitsInPrefixByte, 0), int64(8), "ceil") + int64(1);

    slicedBuffer = buffer.slice(int64(bufferOffset), bufferLength);
    bitmap = typecast(int8(slicedBuffer), "uint8");

    % uint8Mask(N) is 1 if the Nth bit in the buffer is set.
    % Otherwise, uint8Mask(N) is 0.
    powers = uint8(2) .^ uint8(0:7)';
    mask = mod(bsxfun(@idivide, bitmap, powers), 2);
    mask = reshape(mask, [], 1);

    % Remove the values at the beginning of the array that correspond to
    % the non-relevant bits in the first byte of the bit-packed buffer.
    mask(1:numBitsToDiscard) = []; 
    % Remove the values at the end of the array that correspond to the
    % non-revelant bits in the last byte of the bit-packed buffer.
    mask(arrayLength + 1:end) = [];
    mask = typecast(mask, "logical");
end
