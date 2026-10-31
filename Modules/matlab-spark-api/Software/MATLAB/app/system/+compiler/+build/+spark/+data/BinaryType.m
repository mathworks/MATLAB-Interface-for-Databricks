classdef BinaryType < compiler.build.spark.data.AtomicType
    % BinaryType Implementation for types in Compiler workflow

    % Copyright 2025 The MathWorks, Inc.

    methods
        function obj = BinaryType(varargin)
            obj@compiler.build.spark.data.AtomicType(varargin{:});
            obj.MATLABType = "uint8";
            obj.PythonType = "bytes";
            obj.type = "binary";
        end

        function col = col_MATLABTable(obj, col)
            % col_MATLABTable Convert column to MATLAB Table
            %
            % This is a helper function, that may be needed in case the normal
            % MATLAB conversion from Pandas Dataframe to a MATLAB table doesn't
            % convert everything from python values to MATLAB

            arguments
                obj (1,1) compiler.build.spark.data.BinaryType %#ok<INUSA>
                col
            end

            % The base case is to just return the column
            col = cellfun(@uint8, col, 'UniformOutput', false);
        end

        function codeOut = col_IMML_to_IMPY(obj, codeIn)
            % col_IMML_to_IMPY Convert a column to python
            % Converts from intermediate MATLAB (e.g. matlab.int64([]) to
            % intermediate python, e.g. [1,2,3]
            arguments
                obj (1,1) compiler.build.spark.data.BinaryType
                codeIn (1,1) string
            end
            % codeOut = sprintf("%s.tomemoryview().tolist()[0]", codeIn);
            codeOut = codeIn;
            % convFunc = obj.colIntermediateMATLABToPython();
            convFunc = obj.val_IMML_to_IMPY();
            if ~isempty(convFunc)
                codeOut = sprintf("[%s(x) for x in %s]", convFunc, codeOut);
            end
        end

        function funcName = val_IMML_to_IMPY(obj)
            % val_IMML_to_IMPY Convert a value to python
            % Converts from intermediate MATLAB (e.g. matlab.int64([]) to
            % intermediate python, e.g. [1,2,3]
            arguments
                obj (1,1) compiler.build.spark.data.BinaryType
            end

            % Use similar code for actual conversions

            file = obj.getFileParent;
            PyW = file.Parent.PyW;

            UT = obj.UniqueTypeName;
            funcName = sprintf("__%s_%s_IMMLtoIMPY", file.funcName, UT);
            fieldName = sprintf("IMMLtoIMPY_%s", UT);

            if isfield(file.API, fieldName)
                % This was already generated, don't bother
                return
            end

            file.API.(fieldName) = funcName;

            SW = PyW.newMethod();
            convType = sprintf("matlab.%s", obj.MATLABType);
            SW.pf("def %s(elem):\n", funcName);
            SW.indent();
            SW.pf("if isinstance(elem, int):\n");
            SW.indent();
            SW.pf("return bytearray([elem])\n")
            SW.unindent();
            SW.pf("elif isinstance(elem, %s):\n", convType);
            SW.indent();
            SW.pf("return bytearray(elem.tomemoryview().tolist()[0])\n")
            SW.unindent();
            SW.pf("\n")
            SW.pf("# Default case\n")
            SW.pf("return bytearray(elem)\n")

            SW.unindent();


            PyW.addMethod(SW);

        end


        function ret = instantiatePythonExampleValue(obj, num, count)
            % instantiatePythonExampleValue Create example value for Python
            %
            % This method is used to create example files with values
            % Many types can use the standard Python conversions (float(),
            % str(), etc.), and types with special requirements must
            % subclass this method.
            arguments
                obj (1,1) compiler.build.spark.data.BinaryType %#ok<INUSA>
                num (1,1) double
                count (1,1) double = 3 %#ok<INUSA>
            end
            N = randi(5);
            uuid = matlab.lang.internal.uuid();
            str = string(num) + extractBefore(uuid, N);
            ret = sprintf("b'%s'", str);
        end

        function funcName = genPythonExampleFunction(obj)
            % genPythonExampleFunction Example values helper function
            %
            % This function generates a function that will generate a
            % helper value
            % This must be overridden.
            arguments
                obj (1,1) compiler.build.spark.data.DataType
            end

            file = obj.getFileParent();
            PSB = file.Parent;
            PyW = PSB.PyW;

            SW = PyW.newMethod();

            funcName = sprintf("%s_ex", obj.colName);
            SW.pf("def %s(num):\n", funcName);
            SW.indent();
            SW.pf("ri = random.randrange(1,100)\n")
            SW.pf("retVal = (ri + num).to_bytes()\n")
            SW.pf("return retVal\n")
            SW.unindent();

            PyW.addMethod(SW);
        end

        function str = PandasSeriesType(obj) %#ok<MANU>
            % PandasSeriesType The series type to be used in Pandas
            arguments
                obj (1,1) compiler.build.spark.data.DataType
            end
            str = 'object';
        end

       function codeOut = getPyPandasSeriesConverterCtor(~)
            codeOut = "BinarySeriesConverter()";
        end

        function codeOut = getMLPandasSeriesConverterCtor(~)
            codeOut = compose("BinarySeriesConverter()");
        end
    end



end