classdef (Abstract) DateTimeStampType < compiler.build.spark.data.AtomicType
    % DateTimeStampType Implementation for types in Compiler workflow
    %
    % This is an abstract base class, common to both timestamps and durations.
    % The reason is that the classes inheriting from this one shares some features,
    % like their underlying intermediate representation.

    % Copyright 2025 The MathWorks, Inc.

    methods
        function obj = DateTimeStampType(varargin)
            obj@compiler.build.spark.data.AtomicType(varargin{:});
            obj.MATLABType = "datetime";
            obj.type = "date";
        end

        function funcName = arrayElemConverter(obj)
            % arrayElemConverter Convert one element in array
            %
            % Returns the name of a function. If the function name is
            % empty, no conversion is necessary.

            arguments
                obj (1,1) compiler.build.spark.data.DateTimeStampType
            end

            % Get or create converter for indermediate element type
            file = obj.getFileParent;
            lt=compiler.build.spark.data.LongType();
            lt.Parent = file;
            imTypeConverter = lt.arrayElemConverter();
            funcName = imTypeConverter();

        end

        function funcName = array_IMML_to_IMPY(obj)
            % array_IMML_to_IMPY Ensure the results are an array
            %
            % A table with 1 row will be returned as scalars from MATLAB
            % Runtime.
            %
            % Returns the name of a function. If the function name is
            % empty, no conversion is necessary.

            arguments
                obj (1,1) compiler.build.spark.data.DateTimeStampType
            end

            file = obj.getFileParent;
            lt=compiler.build.spark.data.LongType();
            lt.Parent = file;

            funcName = lt.array_IMML_to_IMPY();

        end

        function funcName = array_IMPY_to_IMML(obj)
            % array_IMPY_to_IMML Convert array value to intermediate MATLAB
            arguments
                obj (1,1) compiler.build.spark.data.DateTimeStampType
            end

            file = obj.getFileParent;
            lt=compiler.build.spark.data.LongType();
            lt.Parent = file;

            funcName = lt.array_IMPY_to_IMML();

        end


        function codeOut = col_IMML_to_IMPY(obj, codeIn)
            % col_IMML_to_IMPY Convert a column to python
            % Converts from intermediate MATLAB (e.g. matlab.int64([]) to
            % intermediate python, e.g. [1,2,3]
            arguments
                obj (1,1) compiler.build.spark.data.DateTimeStampType
                codeIn (1,1) string
            end

            file = obj.getFileParent;
            lt=compiler.build.spark.data.LongType();
            lt.Parent = file;

            codeOut = lt.col_IMML_to_IMPY(codeIn);

            convFunc = obj.val_IMML_to_IMPY();
            if ~isempty(convFunc)
                codeOut = sprintf("[%s(x) for x in %s]", convFunc, codeOut);
            end
        end

        function codeOut = col_IMPY_to_IMML(obj, codeIn)
            % col_IMPY_to_IMML  Convert Spark to intermediate py
            arguments
                obj (1,1) compiler.build.spark.data.DateTimeStampType
                codeIn (1,1) string
            end

            convFunc = sprintf("matlab.%s", obj.IntermediaryMATLABType);
            codeOut = sprintf("%s = %s(%s)", obj.colName, convFunc, codeIn);
        end


        function funcName = val_IMPY_to_IMML(obj)
            % val_IMPY_to_IMML Convert a value to intermediate MATLAB
            arguments
                obj (1,1) compiler.build.spark.data.DateTimeStampType
            end

            funcName = "matlab." + obj.IntermediaryMATLABType;

        end


    end

end