function funcName = map_PythonWrapper(file)
    % map_PythonWrapper Generate map function
    %

    % Copyright 2023-2024 The MathWorks, Inc.

    arguments
        file (1,1) compiler.build.spark.PythonFileV2
    end

    funcName = sprintf("%s_map", file.funcName);
    fieldName = "map";
    
    if isfield(file.API, fieldName)
        return % This was already generated, don't bother
    end

    PSB = file.Parent;
    % Setup local variables
    PyW = PSB.PyW;

    % =========== Call function on a row ===========
    file.API.(fieldName) = funcName;
    SW = PyW.newMethod();

    SW.pf("def %s(row):\n", file.API.map);
    SW.indent();
    SW.pf('""" A call to the MATLAB function %s\n', file.funcName);
    SW.pf('The input argument in this case is a Spark row\n');
    SW.pf('The row should have the same number of entries as arguments to the function. """\n');
    SW.pf("result = %s(%s)\n", ...
        file.API.plainMATLAB, ...
        file.generatePythonRowInputArgs("row"));

    outputElems = file.getOutputElements(useData=true);
    outputNames = file.getOutputNames();
    numOut = numel(outputElems);

    if file.nArgOut == 1
        SW.pf("return (result,)\n");
    else
        SW.pf("return result\n");
    end
    % 
    % if file.nArgOut == 1
    %     SW.pf("return (%s, )\n", col_IMML_to_IMPY(outputElems, "result"));
    % else
    %     outParts = strings(1, numOut);
    %     for k=1:numOut
    %         outParts(k) = col_IMML_to_IMPY(outputElems(k), sprintf("result[%d]", k-1));
    %     end
    %     SW.pf("return (%s,)\n", join(outParts, ", "));
    % end
    % end
    SW.pf("\n")
    SW.unindent();

    PyW.addMethod(SW);

end
