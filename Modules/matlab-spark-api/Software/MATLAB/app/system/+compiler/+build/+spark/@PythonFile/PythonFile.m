classdef PythonFile < compiler.build.spark.File
    % PythonFile Helper class for Python code generation
    %
    % This class is used for generating MATLAB and Python code, as well as
    % examples.
    % The class caters to the _signature.json workflow (see corresponding
    % documentation), which has been overhauled by the .schema workflow. 
    % The former wll be deprecated in a later release.

    % Copyright 2021-2025 The MathWorks, Inc.

    properties
        InTypes compiler.build.spark.types.ArgType
        OutTypes compiler.build.spark.types.ArgType
    end

    methods
        function obj = PythonFile(fileName, varargin)

            obj@compiler.build.spark.File(fileName);
            if nargin == 3
                % Old style initialization
                obj.initWithCellArgs(varargin{:});
            elseif nargin == 2 && isa(varargin{1}, 'compiler.build.spark.schema.mathworks.CompilerType')
                obj.Schema = varargin{1};
                initFromSchema(obj);
            else
                error("SPARKAPI:pythonfile_bad_arguments", ...
                    "This constructor was called with bad arguments.");
            end
        end

        function names = getInputNameArray(obj)
            names = string.empty;
            if isempty(obj.InTypes)
                return;
            end
            if isempty(obj.InTypes(1).Name)
                return;
            end
            names = [obj.InTypes.Name];
        end

        function names = getOutputNameArray(obj)
            names = string.empty;
            if isempty(obj.OutTypes)
                return;
            end
            if isa(obj.OutTypes(1), 'compiler.build.spark.types.Table')
                names = [obj.OutTypes(1).TableCols.Name];
                return;
            end
            if isempty(obj.OutTypes(1).Name)
                return;
            end
            names = [obj.OutTypes.Name];
        end
        
        function schema = generatePythonPandasSchema(obj)
            otArray = obj.getOutputElements();
            numEntries = length(otArray);
            strArr(numEntries) = "";
            for k=1:numEntries
                ote = otArray(k);
                if ote.isScalarData
                    strArr(k) = sprintf("%s %s", ote.Name, ote.pythonSchemaType);
                else
                    strArr(k) = sprintf("%s array<%s>", ote.Name, ote.pythonSchemaType);
                end
            end
            schema = strArr.join(", ");
        end


    end
    methods (Access=protected)
        function initFromSchema(obj)

            obj.nArgIn = numel(obj.Schema.Inputs);
            obj.nArgOut = numel(obj.Schema.Outputs);
            for k=1:obj.nArgIn
                arg = compiler.build.spark.types.ArgType.fromSchema(obj.Schema.Inputs(k));
                arg.setParent(obj);
            end


        end
    end
end