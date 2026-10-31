function funcName = map_PythonWrapper(file)
    % map_PythonWrapper Generate map function
    %

    % Copyright 2023 The MathWorks, Inc.

    arguments
        file (1,1) compiler.build.spark.File
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
    % rList = list(result)
    % rList[0] = rList[0].tomemoryview().tolist()[0]
    % rList[1] = rList[1].tomemoryview().tolist()[0]
    % return tuple(rList)
    % if file.hasOutputArrays()
    %     SW.pf("# Handle array output\n")
    %     if file.nArgOut > 1
    %         % The output is a tuple
    %         SW.pf("resultList = list(result)\n")
    %         for k=1:file.nArgOut
    %             OO = file.OutTypes(k);
    %             if ~OO.isScalarData
    %                 % Only arrays must be changed
    %                 elemName = sprintf("resultList[%d]", k-1);
    %                 SW.pf("%s = %s\n", elemName, file.convertPythonArrayOutput(elemName));
    %             end
    %         end
    %         SW.pf("return tuple(resultList)\n");
    %     else
    %         SW.pf("convertedResult = [%s]\n", file.convertPythonArrayOutput("result"));
    %         SW.pf("return convertedResult\n");
    %     end
    % else
    if file.nArgOut == 1
        SW.pf("return (result, )\n");
    else
        SW.pf("return result\n");
    end
    % end
    SW.pf("\n")
    SW.unindent();

    PyW.addMethod(SW);

end
