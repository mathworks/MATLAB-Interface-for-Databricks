function funcName = inputsTransformer_PythonWrapper(file)
    % inputsTransformer_PythonWrapper Generate inputs transformer function
    %

    % Copyright 2023 The MathWorks, Inc.

    arguments
        file (1,1) compiler.build.spark.File
    end

    funcName = sprintf("__%s_inputs_transformer", file.funcName);
    fieldName = "inputsTransformer";
    
    if isfield(file.API, fieldName)
        return % This was already generated, don't bother
    end

    PSB = file.Parent;
    % Setup local variables
    PyW = PSB.PyW;

    file.API.(fieldName) = funcName;
    SW = PyW.newMethod();

    SW.pf("def %s(rows):\n", file.API.inputsTransformer);
    SW.indent();
    SW.pf('""" If there are arrays in the input to MATLAB,\n');
    SW.pf('this cannot be translated automatically. These arrays\n');
    SW.pf('may have to be transformed first. """\n');

    SW.pf("# First check row 0, to determine conversions\n");
    SW.pf("row0 = rows[0]\n");

    if isa(file.InTypes(1), 'compiler.build.spark.types.Table')
        inTypes = file.InTypes(1).TableCols;
    else
        inTypes = file.InTypes;
    end

    newElems = string.empty;
    checks =  string.empty;
    conversionCalls = string.empty;
    for iti = 1:length(inTypes)
        rowStr = "row[" + (iti-1) + "]";
        if (inTypes(iti).isScalarData)
            newElems(iti) = rowStr;
        else
            check = "c" + (iti-1);
            SW.pf("%s = __getConversionIndex(row0[%d])\n", check, iti-1);
            checks(end+1) = check; %#ok<AGROW>
            elemName = sprintf('row_%d', iti-1);
            conversionCalls(end+1) = ...
                sprintf("%s = __convertWithIndex(%s, %s)", ...
                elemName, rowStr, check); %#ok<AGROW>
            newElems(iti) = elemName;
        end
    end
    elemStr = join(newElems, ", ");

    SW.pf('\n');
    SW.pf("def innerMap(row):\n");
    SW.indent();
    for ci = 1:length(checks)
        SW.pf("nonlocal %s\n", checks(ci))
    end
    for ci = 1:length(conversionCalls)
        SW.pf("%s\n", conversionCalls(ci))
    end
    SW.pf("return [%s]\n\n", elemStr);
    SW.unindent();

    SW.pf("return list(map(innerMap, rows))\n")

    SW.unindent();
    SW.pf('\n\n');
    PyW.addMethod(SW);
end
