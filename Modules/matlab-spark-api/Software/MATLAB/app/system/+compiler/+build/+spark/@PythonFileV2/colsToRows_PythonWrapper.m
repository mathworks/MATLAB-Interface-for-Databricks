function funcName = colsToRows_PythonWrapper(file)
    % colsToRows_PythonWrapper Generate rows iterators for result columns
    %
    % This method deals with results from mapPartitions functions.

    % Copyright 2025 The MathWorks, Inc.

    arguments
        file (1,1) compiler.build.spark.PythonFileV2
    end

    funcName = sprintf("__%s_intermediateColsToRows", file.funcName);
    fieldName = "colsToRows";

    if isfield(file.API, fieldName)
        return % This was already generated, don't bother
    end

    PSB = file.Parent;
    % Setup local variables
    PyW = PSB.PyW;

    % Change context
    changeBack = PSB.setScopedCallContext('TableDataFrame'); %#ok<NASGU>

    file.API.(fieldName) = funcName;
    SW = PyW.newMethod();
    SW.pf("def %s(colResults):\n", funcName);
    SW.indent();
    SW.pf('""" A helper function to convert result columns to a row iterator for %s"""\n', file.funcName);

    outputElems = file.getOutputElements(useData=true);
    numOut = numel(outputElems);

    SW.pf("# IMML_to_IMPY\n");
    for k=1:numOut
        curElem = outputElems(k);
        srcData = sprintf("colResults[%d]", k-1);  
        
        colConversion = curElem.col_IMML_to_IMPY(srcData);
        SW.pf("%s = %s\n", curElem.colName, colConversion);        
    end
    SW.pf("\n");
    SW.pf("# IMPY_to_Spark\n");
    for k=1:numOut
        curElem = outputElems(k);
        outConv = col_IMPY_to_Spark(curElem, curElem.colName);
        if outConv ~= curElem.colName
            SW.pf("%s = %s\n", curElem.colName, outConv);
        end
    end

    SW.pf("num_rows = colResults[%d]\n", numOut);
    SW.pf("for x in range(num_rows):\n");
    SW.indent();
    SW.pf("yield [%s]\n", join(outputElems.colName + "[x]", ", "));
    SW.unindent();

    SW.unindent();

    PyW.addMethod(SW);

end
