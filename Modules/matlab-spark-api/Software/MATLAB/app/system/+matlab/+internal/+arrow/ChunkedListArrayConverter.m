classdef ChunkedListArrayConverter < matlab.internal.arrow.ChunkedListLikeArrayConverter
%CHUNKEDLISTARRAYCONVERTER Class for converting ChunkedArrays of ListArrays
% to MATLAB cell arrays.

% Copyright 2026, The MathWorks, Inc.

    properties (SetAccess = private)
        ChildConverter
    end

    methods
        function obj = ChunkedListArrayConverter(offsetType, childConverter)
            obj@matlab.internal.arrow.ChunkedListLikeArrayConverter(offsetType);
            obj.ChildConverter = childConverter;
        end
    end

    methods (Access = protected)
        function numValues = getNumChildValues(~, chunk)
            numValues = int64(py.len(chunk.values));
        end

        function offsetArray = getOffsetArray(~, chunk)
            offsetArray = chunk.offsets;
        end

        function values = getValues(obj, chunkedArray)
            getChildArrayFcn = @(chunk) chunk.values;
            values = getChildValues(chunkedArray, getChildArrayFcn, ...
                chunkedArray.type.value_type, obj.ChildConverter);
        end
    end
end