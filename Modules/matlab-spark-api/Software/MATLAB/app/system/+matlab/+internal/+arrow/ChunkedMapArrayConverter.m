classdef ChunkedMapArrayConverter < matlab.internal.arrow.ChunkedArrayConverter
%CHUNKEDMAPARRAYCONVERTER Class for converting ChunkedArrays of MapArrays
% to a MATLAB cell array of dictionaries.

% Copyright 2026 The MathWorks, Inc.

    properties (SetAccess = private)
        KeyConverter
        ItemConverter
    end

    properties (Constant)
        OffsetConverter = matlab.internal.arrow.ChunkedIntegerArrayConverter("int32", false)
    end

    methods
        function obj = ChunkedMapArrayConverter(keyConverter, itemConverter)
            arguments
                keyConverter(1, 1) matlab.internal.arrow.ChunkedArrayConverter
                itemConverter(1, 1) matlab.internal.arrow.ChunkedArrayConverter
            end
            obj.KeyConverter = keyConverter;
            obj.ItemConverter = itemConverter;
        end
    end

    methods (Access = protected)
        function data = convertImpl(obj, chunkedArray)
            offsets = obj.getOffsets(chunkedArray);
            
            keys = obj.getKeys(chunkedArray);
            items = obj.getItems(chunkedArray);
            
            numElements = numel(offsets) - 1;
            data = cell([numElements 1]);

            for ii = 1:numElements
                startIdx = offsets(ii);
                endIdx = offsets(ii + 1) - 1;
                data{ii} = dictionary(keys(startIdx:endIdx), items(startIdx:endIdx));
            end

            nullIndices = getNullIndices(chunkedArray, true);
            data(nullIndices) = {missing};
        end
    end

    methods (Access = private)
        function offsets = getOffsets(obj, chunkedArray)
            getOffsetsArrayFcn = @(chunk) chunk.offsets;
            getNumChildValuesFcn =  @(chunk) int64(py.len(chunk.values));
            offsets = getOffsetValues(chunkedArray, obj.OffsetConverter,...
                getOffsetsArrayFcn, getNumChildValuesFcn);
            offsets = reshape(offsets, [], 1);
        end

        function items = getKeys(obj, chunkedArray)
            getKeyArrayFcn = @(chunk) chunk.keys;
            items = getChildValues(chunkedArray, getKeyArrayFcn, ...
                chunkedArray.type.key_type, obj.KeyConverter);
            items = reshape(items, [], 1);
        end

         function items = getItems(obj, chunkedArray)
            getItemArrayFcn = @(chunk) chunk.items;
            items = getChildValues(chunkedArray, getItemArrayFcn, ...
                chunkedArray.type.item_type, obj.ItemConverter);
            items = reshape(items, [], 1);
        end
    end
end