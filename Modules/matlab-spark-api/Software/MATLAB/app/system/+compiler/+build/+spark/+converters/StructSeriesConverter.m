classdef StructSeriesConverter < compiler.build.spark.converters.SeriesConverter
%STRUCTSERIES   Constructs a Nx1 MATLAB struct array from a MATLAB cell 
% array representing a Pandas Series of objects, in which the objects are
% dictionaries with identical key names. In addition, key values have
% identical datatypes across rows.

% Copyright 2026 The MathWorks, Inc.

    properties (GetAccess = public)
        StructFields (1, :) compiler.build.spark.converters.StructField
    end

    properties (SetAccess=private)
        Cellify = false
    end

    methods
        function obj = StructSeriesConverter(structFields)
            arguments
                structFields(1, :) compiler.build.spark.converters.StructField
            end

            obj.StructFields = structFields;
        end

        function output = toMATLAB(obj, data)
            numFields = numel(obj.StructFields);
            args = cell([1 numFields * 2]);
            for ii = 1:numFields
                args{(ii * 2) - 1} = obj.StructFields(ii).Name;
                fieldData = obj.StructFields(ii).Converter.toMATLAB(data{ii});
                 if ~iscell(fieldData)
                    fieldData = num2cell(fieldData);
                end
                args{ii * 2} = fieldData;
            end

            output = struct(args{:});
            reshape(output, [], 1);
        end

        function output = fromMATLAB(obj, data)
            numFields = numel(obj.StructFields);
            
            output = cell(1, numFields);
            for ii = 1:numFields
                fieldConverter = obj.StructFields(ii);
                name = fieldConverter.Name;
                if fieldConverter.Converter.Cellify
                    % Concatenate each field element into a cell array.
                    % We need to use cell array concatentation when the 
                    % field values are either dictionaries or
                    % possibly nonscalar arrays.
                    fieldData = {data.(name)};
                else
                    fieldData = [data.(name)];
                end
                output{ii} = fieldConverter.Converter.fromMATLAB(fieldData);
            end
        end
    end
end