function funcName = plain_PythonWrapper(file)
    % plain_PythonWrapper Generate plain function
    %

    % Copyright 2024 The MathWorks, Inc.

    arguments
        file (1,1) compiler.build.spark.PythonFileV2
    end

    funcName = file.funcName;
    fieldName = "plainMATLAB";

    if isfield(file.API, fieldName)
        return % This was already generated, don't bother
    end

    PSB = file.Parent;
    % Setup local variables
    PyW = PSB.PyW;

    file.API.(fieldName) = funcName;
    SW = PyW.newMethod();
    SW.pf("def %s(%s):\n", funcName, file.generatePythonInputArgs());
    SW.indent();
    SW.pf('""" A plain call to the MATLAB function %s """\n', funcName);
    SW.pf("instance = %s.getInstance()\n", PSB.WrapperClassName);
    SW.pf("retVal = instance.RT.%s_plain(%s)\n\n", ...
        file.funcName, ...
        file.generatePythonInputArgs(withNargout=true, convertArgs=true));

    SW.pf("%s.releaseInstance(instance)\n", PSB.WrapperClassName);

    % Convert output values if necessary
    outElems = file.getOutputElements(useData=true);
    outSchemaElems = file.getOutputElements();
    N_OUT = length(outElems);
    if N_OUT == 1
        outNames = "retVal";
    else
        outNames = "retVal[" + (0:(file.nArgOut-1)) + "]";
    end

    for k=1:N_OUT
        curElem = outElems(k);
        colName = curElem.colName;
        SW.pf("%s = %s(%s)\n", colName, val_IMML_to_IMPY(curElem), outNames(k));

        outConv = val_IMPY_to_Spark(curElem);
        if ~isempty(outConv)
            SW.pf("%s = %s(%s)\n", colName, outConv, colName);
        end
    end

    if N_OUT == 1
        SW.pf("return %s\n", outElems.colName);
    else
        SW.pf("return (%s)\n", join(outElems.colName, ", "));
    end
    SW.unindent();
    SW.pf("\n");

    PyW.addMethod(SW);

    % If this is not a table method, add some helper functions for plain udfs
    if N_OUT > 0
        if ~file.TableInterface

            % The same outSchema should be used for both UDFs
            if N_OUT == 1
                sparkType = join(outSchemaElems.getPythonImports, ",");
                sparkInitType = outSchemaElems.pythonInitCode();
                PyW.addImport(sprintf("from pyspark.sql.types import %s", sparkType));
                % SW.pf("from pyspark.sql.types import %s\n", file.OutTypes.SparkType);
                outSchema = sparkInitType;
            else
                outSchema = file.API.outputSchema;
                % outSchema = "'" + ...
                %     join(arrayfun(@pythonSchemaType, [file.Schema.Outputs.SparkType]), ", ") ...
                %     + "'";
            end

            % Plain UDF, for use in SQL
            SW = PyW.newMethod();
            regUDFPlain = sprintf("%s_reg_udf", funcName);
            file.API.regUDF = regUDFPlain;
            SW.pf("def %s(spark, name='%s_udf'):\n", regUDFPlain, funcName);
            SW.indent();
            SW.pf('""" Register the function %s as a UDF\n', funcName)
            SW.pf('A second argument can be used to specify the name to be used."""\n')

            SW.pf('spark.udf.register(name, %s, %s)\n', funcName, outSchema);
            SW.unindent();
            PyW.addMethod(SW);

            % -------------------------------------------------------
            % Plain UDF, for use in Dataframe
            SW = PyW.newMethod();
            regUDFPlainDF = sprintf("%s_reg_udf_dataframe", funcName);
            file.API.regUDFDataframe = regUDFPlainDF;
            SW.pf("def %s():\n", regUDFPlainDF);
            SW.indent();
                

            SW.pf('""" Returns a UDF function for use with Dataframes."""\n')
            SW.pf('return udf(%s, %s)\n', funcName, outSchema);

            SW.unindent();
            PyW.addMethod(SW);


        end
    end
end
