function funcName = outputsTransformer_PythonWrapper(file)
    % outputsTransformer_PythonWrapper Generate outputs transformer function
    %

    % Copyright 2023 The MathWorks, Inc.

    arguments
        file (1,1) compiler.build.spark.File
    end

    funcName = sprintf("__%s_results_transformer", file.funcName);
    fieldName = "outputsTransformer";
    
    if isfield(file.API, fieldName)
        return % This was already generated, don't bother
    end

    PSB = file.Parent;
    % Setup local variables
    PyW = PSB.PyW;

    file.API.(fieldName) = funcName;
    SW = PyW.newMethod();

    if isa(file.OutTypes(1), 'compiler.build.spark.types.Table')
        outTypes = file.OutTypes(1).TableCols;
    else
        outTypes = file.OutTypes;
    end

    SW.pf("def %s(iterator):\n", funcName);
    SW.indent();
    SW.pf('""" If there are arrays in the output from MATLAB,\n');
    SW.pf('this cannot be translated automatically. The results\n');
    SW.pf('must be iterated and converted accordingly. """\n');
    SW.pf("for row in iterator:\n")
    SW.indent();
    newElems = string.empty;
    for oti = 1:length(outTypes)
        rowStr = "row[" + (oti-1) + "]";
        if (outTypes(oti).isScalarData)
            newElems(oti) = rowStr;
        else
            newElems(oti) = sprintf("%s[0].toarray().tolist()", rowStr);
        end
    end
    elemStr = join(newElems, ", ");

    SW.pf("yield [%s]\n\n", elemStr);
    SW.unindent();
    SW.unindent();
    SW.pf('\n');

    PyW.addMethod(SW);

end
