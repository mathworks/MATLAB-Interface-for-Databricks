function funcName = rowIterator_PythonWrapper(file)
    % rowIterator_PythonWrapper Generate rowIterator function
    %

    % Copyright 2023 The MathWorks, Inc.

    arguments
        file (1,1) compiler.build.spark.PythonFile
    end

    funcName = sprintf("__%s_iterator_rows", file.funcName);
    fieldName = "rowsIterator";
    
    if isfield(file.API, fieldName)
        return % This was already generated, don't bother
    end

    PSB = file.Parent;
    % Setup local variables
    PyW = PSB.PyW;

    file.API.(fieldName) = funcName;

    SW = PyW.newMethod();
    SW.pf("def %s(iterator):\n", file.API.rowsIterator);
    SW.indent();
    SW.pf('""" A helper function to convert an iterator to a list for %s"""\n', file.funcName);
    SW.pf("for row in iterator:\n")
    SW.indent();

    if file.TableInterface
        ARGS = file.InTypes(1).TableCols;
    else
        ARGS = file.InTypes;
    end
    N = length(ARGS);
    rowElems(N) = "";
    preCode = matlab.sparkutils.StringWriter();
    for k=1:N
        varName = sprintf("row[%d]", k-1);
        [rowElems(k), preCodeRow] = convertExternalToIntermediate(ARGS(k), varName);
        if strlength(preCodeRow) > 0
            SW.pf('%s', preCodeRow);
        end
    end
    rowIteratorArray = "[" + join(rowElems, ", ") + "]";

    preCode = preCode.getString();
    if strlength(preCode) > 0
        SW.insertLines(preCode);
    end

    SW.pf("yield %s\n\n", rowIteratorArray);
    SW.pf("# yield %s\n\n", file.generatePythonRowIteratorArgs());
    SW.unindent();
    SW.unindent();

    PyW.addMethod(SW);

end
