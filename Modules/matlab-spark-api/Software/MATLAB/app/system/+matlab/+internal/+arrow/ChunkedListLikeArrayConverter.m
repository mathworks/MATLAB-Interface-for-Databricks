classdef (Abstract) ChunkedListLikeArrayConverter < matlab.internal.arrow.ChunkedArrayConverter
%CHUNKEDLISTLIKEARRAYCONVERTER Abstract class that defines the interface
% for converting list-like arrow arrays to MATLAB cell arrays.

% Copyright 2026 The MathWorks, Inc.

    properties (SetAccess = private)
        OffsetConverter
    end

    methods 
        function obj = ChunkedListLikeArrayConverter(offsetType)
            offsetType = validatestring(offsetType, ["int32", "int64"]);
            obj.OffsetConverter = matlab.internal.arrow.ChunkedIntegerArrayConverter(offsetType, false);
        end
    end

    methods (Access = protected)
         function data = convertImpl(obj, chunkedArray)
            offsets = obj.getOffsets(chunkedArray);
            values = obj.getValues(chunkedArray);
            values = reshape(values, 1, []);

            numElements = numel(offsets) - 1;
            data = cell([numElements 1]);

            for ii = 1:numElements
                data{ii} = values(offsets(ii):offsets(ii + 1) - 1);
            end

            nullIndices = getNullIndices(chunkedArray, true);
            data(nullIndices) = {missing};
         end
    end

    methods (Access = private)
        function offsets = getOffsets(obj, chunkedArray)
            getOffsetsArrayFcn = @(chunk) obj.getOffsetArray(chunk);

            getNumChildValuesFcn = @(chunk) obj.getNumChildValues(chunk);

            offsets = getOffsetValues(chunkedArray, obj.OffsetConverter, ...
                getOffsetsArrayFcn, getNumChildValuesFcn);
        end
    end

    methods (Abstract, Access = protected)
        % Return the number of values in this chunk's child array.
        numValues = getNumChildValues(obj, chunk);

        % Return this chunk's offset array.
        offsetArray = getOffsetArray(obj, chunk);

        % Return a MATLAB array that corresponds to the child/values 
        % array of this chunkedArray.
        values = getValues(obj, chunkedArray);
    end
end