function funcName = plain_PythonWrapper(file)
    % plain_PythonWrapper Generate plain function
    %

    % Copyright 2023 The MathWorks, Inc.

    arguments
        file (1,1) compiler.build.spark.File
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
    outElems = file.getOutputElements();
    outNames = "retVal[" + (0:(file.nArgOut-1)) + "]";
    N_OUT = length(outNames);
    newNames(N_OUT) = "";
    for k=1:N_OUT
        newNames(k) = convertMWValueForPython(outElems(k), outNames(k)); 
    end

    if isequal(outNames, newNames)
        SW.pf("return retVal\n\n");
    else
        % SW.pf("return (%s)\n\n", newNames.join(", "));
        if N_OUT == 1 %#ok<ISCL>
            SW.pf("return %s\n", newNames);
        else
            SW.pf("return (\n");
            comma = ",";
            SW.indent();
            for k=1:N_OUT
                if k == N_OUT
                    comma = "";
                end
                SW.pf("%s%s\n", newNames(k), comma);
            end
            SW.unindent();
            SW.pf(")\n\n");
        end
    end

    SW.unindent();

    PyW.addMethod(SW);

    % If this is not a table method, add some helper functions for plain udfs
    if N_OUT > 0
        if ~file.TableInterface
            % Plain UDF, for use in SQL
            SW = PyW.newMethod();
            regUDFPlain = sprintf("%s_reg_udf", funcName);
            file.API.regUDF = regUDFPlain;
            SW.pf("def %s(spark, name='%s_udf'):\n", regUDFPlain, funcName);
            SW.indent();
            SW.pf('""" Register the function %s as a UDF\n', funcName)
            SW.pf('A second argument can be used to specify the name to be used."""\n')


            if N_OUT == 1 %#ok<ISCL>
                PyW.addImport(sprintf("from pyspark.sql.types import %s, ArrayType", file.OutTypes.SparkType));
                outSchema = file.OutTypes.getSparkTypeConstructor();
                % SW.pf("from pyspark.sql.types import %s\n", file.OutTypes.SparkType);
            else
                outSchema = file.API.outputSchema;
            end

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

            % outSchema already defined in other UDF

            SW.pf('return udf(%s, %s)\n', funcName, outSchema);

            SW.unindent();
            PyW.addMethod(SW);


        end
    end
end
