classdef ChunkedStructArrayConverter < matlab.internal.arrow.ChunkedArrayConverter
%CHUNKEDSTRUCTARRAYCONVERTER Class for converting arrow ChunkedArrays of
% StructArrays to MATLAB struct arrays.

% Copyright 2026 The MathWorks, Inc.

    properties
        FieldNames(1, :) string
        FieldConverters(1, :) matlab.internal.arrow.ChunkedArrayConverter
    end

    methods
        function obj = ChunkedStructArrayConverter(fieldNames, fieldConverters)
            [fieldNames, modified1] = matlab.lang.makeValidName(fieldNames);
            [obj.FieldNames, modified2] = matlab.lang.makeUniqueStrings(fieldNames, ...
                {}, namelengthmax);
            obj.FieldConverters = fieldConverters;

            if any(modified1 | modified2) 
                id = "sparkapi:ModifiedStructFieldNames";
                msg = "Modified field names to be valid struct field names.";
                warning(id, msg);
            end
        end
    end

    methods (Access = protected)
        function data = convertImpl(obj, chunkedArray)
            fieldConverterFcn = obj.getFieldConverterFcn(chunkedArray);
            data = obj.createStruct(fieldConverterFcn);
            data = obj.setNullElements(chunkedArray, data);
            data = reshape(data, [], 1);
        end
    end

    methods (Access = private)
        
        function data = createStruct(obj, structFieldGeneratorFcn)
            numFields = numel(obj.FieldNames);
            c = cell([1 numFields * 2]);
            for ii = 1:numFields
                c{ii*2 - 1} = obj.FieldNames(ii);
                fieldValues = structFieldGeneratorFcn(ii);
                if ~iscell(fieldValues)
                    c{ii*2} = num2cell(fieldValues);
                else
                    c{ii*2} = fieldValues;
                end
            end
            data = struct(c{:});
        end

        function fcn = getFieldConverterFcn(obj, chunkedArray)
            numArrayElements = int64(py.len(chunkedArray));
            if numArrayElements > 0
                fcn = @(index) obj.convertField(chunkedArray, index);
            else
                % Return an empty cell array if the number of array
                % elements is zero to construct a 0x1 struct array instead
                % of a 1x1 struct array.
                fcn = @ (~) {};
            end
        end

        function fieldData = convertField(obj, chunkedArray, index)
            fieldIndex = int32(index) - 1;
            fieldType = chunkedArray.type.field(fieldIndex).type;
            getFieldArrayFcn = @(chunk) chunk.field(fieldIndex);
            fieldData = getChildValues(chunkedArray, getFieldArrayFcn, fieldType, obj.FieldConverters(index));
        end

        function data = setNullElements(obj, chunkedArray, data)
            nullIndices = getNullIndices(chunkedArray, true);
            if any(nullIndices)
                missingStruct = obj.createStruct(@(~) missing);
                data(nullIndices) = missingStruct;
            end
        end
    end
end