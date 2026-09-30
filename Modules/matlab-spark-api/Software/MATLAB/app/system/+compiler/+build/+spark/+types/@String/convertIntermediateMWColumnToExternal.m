function code = convertIntermediateMWColumnToExternal(obj, srcData, varName, idx)
    % convertIntermediateMWColumnToExternal Convert MW Column to external type
    %
    % See compiler.build.spark.types.ArgType/convertIntermediateMWColumnToExternal

    % Copyright 2023 The MathWorks, Inc.

    SW = matlab.sparkutils.StringWriter();

    if obj.isScalarData
        SW.pf("%s %s = ((MWCharArray)%s.getCell(%s)).toString();\n", ...
            obj.getReturnType, varName, srcData, idx);
    else
        % Arrays
        cName = "ret_c_" + obj.Name;
        nName = "N_" + obj.Name;
        SW.pf("MWCellArray %s = (MWCellArray)%s.getCell(%s);\n", cName, srcData, idx);
        SW.pf("int %s = %s.numberOfElements();\n", nName, cName);
        SW.pf("%s %s = new String[%s];\n", obj.getReturnType, varName, nName);
        SW.pf("for (int ni=0; ni<%s; ++ni) {\n", nName);
        SW.indent();
        SW.pf("MWCharArray ca = (MWCharArray) %s.getCell(ni+1);\n", cName)
        SW.pf("%s[ni] = ca.toString();\n", varName)
        SW.unindent();
        SW.pf("}\n");
    end

    code = SW.getString();
end