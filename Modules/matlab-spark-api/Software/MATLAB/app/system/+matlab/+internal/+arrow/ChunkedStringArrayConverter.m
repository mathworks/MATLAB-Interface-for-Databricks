classdef ChunkedStringArrayConverter < matlab.internal.arrow.ChunkedPrimitiveArrayConverter
%CHUNKEDSTRINGARRAYCONVERTER Converter for converting ChunkedArrays of arrow
% string arrays to MATLAB string arrays.

% Copyright 2026 The MathWorks, Inc.

    properties (SetAccess = private)
        %OFFSETTYPE     Data type of the values in the offset buffer. Must
        %be "int32" or "int64".
        OffsetType(1, 1) string
        %OFFSETSIZE    Size in bytes of the values in the offset buffer.
        OffsetSize(1, 1) double
    end

    methods
        function obj = ChunkedStringArrayConverter(offsetType)
            obj.OffsetType = validatestring(offsetType, ["int32" "int64"]);
            obj.OffsetSize = numel(typecast(zeros([1 1], obj.OffsetType), "uint8"));
        end
    end

    methods (Access = protected)
        function data = allocateTypedVector(~, numElements)
            data = repmat(string(missing), [numElements 1]);
        end

        function data = convertRawData(obj, array)
            
            offsets = obj.getOffsets(array);
            utf8Data = getUT8FData(array, offsets(1), offsets(end) - offsets(1));
            % Subtract the first offset value from each element in the
            % array to make the offsets zero-based since convertUTF8StringArray
            % assumes the first value in the offsets array is 0.
            offsets = offsets - offsets(1);
            data = convertUTF8StringArray(offsets, utf8Data, uint64(maxNumCompThreads));
        end
    
    
        function data = setNullElements(~, data, nullIndices)
            data(nullIndices) = string(missing);
        end
    end

    methods (Access = private)
        function offsets = getOffsets(obj, array)
            numStrs = int64(py.len(array));
            arrayOffset  = int64(array.offset);

            offsetBuffer = getBuffer(array, 1);
            offsetBuffer = offsetBuffer.slice(arrayOffset * obj.OffsetSize,...
                (numStrs + 1) * obj.OffsetSize);

            offsets = typecast(int8(offsetBuffer), obj.OffsetType);
        end
    end
end

function utf8Data = getUT8FData(array, bufferOffset, bufferLength)
    dataBuffer = getBuffer(array, 2);
    utf8Data  = int8(dataBuffer.slice(bufferOffset, bufferLength));
    utf8Data  = typecast(utf8Data, "uint8");
end