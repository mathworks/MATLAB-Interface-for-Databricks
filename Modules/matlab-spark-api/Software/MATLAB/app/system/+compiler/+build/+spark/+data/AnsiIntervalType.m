classdef (Abstract) AnsiIntervalType < compiler.build.spark.data.AtomicType
    % AnsiIntervalType Implementation for types in Compiler workflow

    % Copyright 2025 The MathWorks, Inc.

    methods
        function obj = AnsiIntervalType(varargin)
            obj@compiler.build.spark.data.AtomicType(varargin{:});
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
                obj (1,1) compiler.build.spark.data.AnsiIntervalType
            end

            file = obj.getFileParent;
            lt=compiler.build.spark.data.LongType();
            lt.Parent = file;

            funcName = lt.array_IMML_to_IMPY();

        end

 
    end

end