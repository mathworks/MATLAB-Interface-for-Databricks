classdef PythonFileV2 < compiler.build.spark.File
    % PythonFileV2 Helper class for Python code generation

    % Copyright 2021-2026 The MathWorks, Inc.

    properties (SetAccess=private)
        Schema (1,1) compiler.build.spark.schema.mathworks.CompilerType
        InData compiler.build.spark.data.DataType
        OutData compiler.build.spark.data.DataType
    end

    methods
        function obj = PythonFileV2(schema)
            arguments
                schema (1,1) compiler.build.spark.schema.mathworks.CompilerType
            end

            % obj@compiler.build.spark.File(fileName, varargin{:});
            obj@compiler.build.spark.File(schema.FullFileName);
            obj.Schema = schema;

            obj.init();
        end

        function names = getOutputNames(obj)
            if isempty(obj.OutData)
                names = string.empty;
            elseif obj.TableInterface
                names = obj.OutData.names;
            else
                names = [obj.Schema.Outputs.Name];
            end

        end

        function [schema, ioNames] = generatePythonPandasSchema(obj, options)
            % generatePythonPandasSchema Return schema and names
            %
            % This is used for different helper functions
            arguments
                obj (1,1) compiler.build.spark.PythonFileV2
                options.isOut (1,1) logical = true
            end
            if options.isOut
                ioArray = obj.getOutputElements();
                ioNames = obj.getOutputNames();
            else
                ioArray = obj.getInputElements(main=true);
                ioNames = obj.getInputNames(main=true);
            end
            numEntries = length(ioArray);
            strArr(numEntries) = "";
            for k=1:numEntries
                ote = ioArray(k);
                strArr(k) = sprintf("`%s` %s", ioNames(k), ote.pythonSchemaType);
            end
            schema = strArr.join(", ");
        end

        function C = genExampleInputs(file, options)
            % genExampleInputs Debug function
            % This function generates inputs in MATLAB in column format,
            % that can be used as input to the helper functions for
            % testing.
            arguments
                file (1,1) compiler.build.spark.PythonFileV2
                options.N (1,1) double = 10 % Number of rows
            end
            inTypes = file.getInputElements(main=true, useData=true);
            inTypeNames = file.getInputNames(main=true);
            nCol = numel(inTypes);
            C = cell(1, nCol);
            for k=1:nCol
                elem = inTypes(k);
                name = inTypeNames(k);
                for r=1:options.N
                    tmpVal = elem.instantiateMATLABExampleValue((k-1)*10 + r, doEval=true);
                    if ismember(elem.type, ["array"]) %, "struct"])
                        if r==1
                            VAL = {tmpVal};
                        else
                            VAL{r} = tmpVal;
                        end
                    else
                        if r==1
                            VAL = tmpVal;
                        else
                            VAL(r) = tmpVal;
                        end
                    end
                end
                if elem.type == "struct"
                    FN = string(fieldnames(VAL));
                    NFN = numel(FN);
                    VAL2 = cell(1, NFN);
                    for fi =1:NFN
                        VAL2{fi} = [VAL.(FN(fi))];
                    end
                    VAL = VAL2;
                end
                C{k} = VAL;
            end
        end
    end
    methods (Access=protected)
        function init(obj)

            obj.nArgIn = numel(obj.Schema.Inputs);
            obj.nArgOut = numel(obj.Schema.Outputs);
            for k=1:obj.nArgIn
                S = obj.Schema.Inputs(k).SparkType;
                D = compiler.build.spark.data.fromSchema(S, parent=obj);
                if strlength(D.Name)==0
                    D.Name = obj.Schema.Inputs(k).Name;
                end
                obj.InData(k) = D;
            end
            for k=1:obj.nArgOut
                S = obj.Schema.Outputs(k).SparkType;
                D = compiler.build.spark.data.fromSchema(S, parent=obj);
                if strlength(D.Name)==0
                    D.Name = obj.Schema.Outputs(k).Name;
                end
                obj.OutData(k) = D;
            end

            obj.TableInterface = obj.Schema.Inputs(1).Table;
            obj.ScopedTables = obj.TableInterface && (obj.nArgIn > 1);
            obj.PandaSeries = obj.TableInterface && (obj.nArgOut == 1);

        end

        function groupByArg = chooseGroupbyColumn(file)
            % chooseGroupbyColumn
            % Helper function when generating examples
            % Not meant for serious work, as grouping shouldn't be haphazardous
            args = file.getInputElements(main=true, useData=true);
            argNames = file.getInputNames(main=true);
            argTypes = [args.MATLABType];
            colIdx = find("int64" == argTypes, 1);
            if isempty(colIdx)
                colIdx = find("int32" == argTypes, 1);
            end
            if isempty(colIdx)
                colIdx = find("string" == argTypes, 1);
            end
            if isempty(colIdx)
                colIdx = 1;
            end
            groupByArg = argNames(colIdx);

        end
    end

    methods (Hidden)
        function tf = ioSchemasAlign(file)
            % ioSchemasAlign Return true if in and out schema are equal
            %
            % This is used mainly for generating example code.

            arguments
                file (1,1) compiler.build.spark.PythonFileV2
            end
            if file.TableInterface
                tf = isequal(file.Schema.Inputs(1).SparkType.json(), file.Schema.Outputs(1).SparkType.json());
            else
                tf = true;
                if file.nArgIn == file.nArgOut
                    for k=1:file.nArgIn
                        if ~isequal(file.Schema.Inputs(k).SparkType.json(), file.Schema.Outputs(k).SparkType.json())
                            tf = false;
                            break;
                        end
                    end
                    % If all were equal, return true
                else
                    tf = false;
                end
            end
        end
    end
end