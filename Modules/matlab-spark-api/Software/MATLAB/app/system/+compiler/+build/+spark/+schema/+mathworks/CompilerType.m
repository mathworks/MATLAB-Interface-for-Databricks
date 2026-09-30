classdef CompilerType < compiler.build.spark.schema.mathworks.NonSparkType
    % Copyright 2024 The MathWorks, Inc.

    properties
        Inputs compiler.build.spark.schema.mathworks.IOType
        Outputs compiler.build.spark.schema.mathworks.IOType
        FuncName (1,1) string
        FullFileName (1,1) string
    end

    methods
        function obj = CompilerType(funcName)
            arguments
                funcName (1,1) string = "<unknown>"
            end
            obj@compiler.build.spark.schema.mathworks.NonSparkType();
            obj.type = "compiler";
            obj.FuncName = funcName;
            if ~strcmp(obj.FuncName, "<unknown>")
                init(obj);
            end
        end
        function addInput(obj, name, type, isTable)
            arguments
                obj (1,1) compiler.build.spark.schema.mathworks.CompilerType
                name (1,1) string
                type (1,1) compiler.build.spark.schema.DataType
                isTable (1,1) logical = false
            end
            obj.Inputs(end+1) = compiler.build.spark.schema.mathworks.IOType(name, "in", type, isTable);
        end
        function addOutput(obj, name, type, isTable)
            arguments
                obj (1,1) compiler.build.spark.schema.mathworks.CompilerType
                name (1,1) string
                type (1,1) compiler.build.spark.schema.DataType
                isTable (1,1) logical = false
            end
            obj.Outputs(end+1) = compiler.build.spark.schema.mathworks.IOType(name, "out", type, isTable);
        end

         function val = toStruct(obj)
            % toStruct Create struct object suitable for JSON conversion
            % Default implementation for atomic types is a string of the type

             nIn = numel(obj.Inputs);
             inputs = cell(nIn,1);
             for k=1:nIn
                 inputs{k} = obj.Inputs(k).toStruct();
             end

             nOut = numel(obj.Outputs);
             outputs = cell(nOut,1);
             for k=1:nOut
                 outputs{k} = obj.Outputs(k).toStruct();
             end
             

             val = struct(...
                 "type", obj.type, ...
                 "funcname", obj.FuncName, ...
                 "fullFilename", obj.FullFileName, ...
                 "inputs", {inputs}, ...
                 "outputs", {outputs} ...
                 );
         end

         function obj = fromVal(obj, val)
             obj.FuncName = val.funcname;
             obj.FullFileName = val.fullFilename;
             init(obj);
             for k=1:numel(val.inputs)
                 I_val = val.inputs(k);
                 elemType = compiler.build.spark.schema.mathworks.CommonBase.instanceFromVal(I_val.SparkType);
                 obj.addInput(I_val.Name, elemType, I_val.Table);
             end
             for k=1:numel(val.outputs)
                 O_val = val.outputs(k);
                 elemType = compiler.build.spark.schema.mathworks.CommonBase.instanceFromVal(O_val.SparkType);
                 obj.addOutput(O_val.Name, elemType, O_val.Table);
             end
         end

        %  function str = getPythonCode(obj, options)
        %      arguments
        %          obj (1,1) compiler.build.spark.schema.DataType
        %          options.pretty (1,1) logical = false
        %          options.indentation (1,1) string = ""
        %      end
        %      str = "from pyspark.sql.types import *" + newline;
        %      str = str + "% Input types" + newline;
        %      for k=1:numel(obj.Inputs);
        %          IO = obj.Inputs(k);
        %          str = str + getPythonCode(IO, pretty=options.pretty, indentation=options.indentation);
        %      end
        %      str = str + "% Output types" + newline;
        %      for k=1:numel(obj.Outputs);
        %          IO = obj.Outputs(k);
        %          str = str + getPythonCode(IO, pretty=options.pretty, indentation=options.indentation);
        %      end
        %  end


        function checkTypeCompliance(CT)
            arguments
                CT (1,1) compiler.build.spark.schema.mathworks.CompilerType
            end
            tblIdxIn = find([CT.Inputs.Table]);
            tblidxOut = find([CT.Outputs.Table]);
            if numel(tblIdxIn) > 1
                error('MATLAB_SPARK_API:bad_table_arguments', ...
                    'There can only be one input argument of table type in a function.');
            end

            if ~isempty(tblIdxIn) && tblIdxIn(1) > 1
                error('MATLAB_SPARK_API:bad_table_arguments', ...
                    'If a table input argument is used, it must be the first argument.');
            end

            if ~isempty(tblidxOut)
                if numel(CT.Outputs) > 1
                    error('MATLAB_SPARK_API:bad_table_arguments', ...
                        'If a table is the output from a function, that must be the only output.');
                end
            end


        end

    end
    methods (Access=private)
        function init(obj)
            if strlength(obj.FullFileName) == 0
                % Don't try this if the data is from serialized schema.
                FIS = compiler.build.spark.internal.getFcnFileName(obj.FuncName);
                obj.FullFileName = FIS.FullFileName;
            end
        end
    end


end