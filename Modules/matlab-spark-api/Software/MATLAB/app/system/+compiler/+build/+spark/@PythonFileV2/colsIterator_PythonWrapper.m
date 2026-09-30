function funcName = colsIterator_PythonWrapper(file)
    % colsIterator_PythonWrapper Generate colsIterator function
    %

    % Copyright 2023-2024 The MathWorks, Inc.

    arguments
        file (1,1) compiler.build.spark.PythonFileV2
    end

    funcName = sprintf("__%s_iterator_columns", file.funcName);
    fieldName = "colsIterator";

    if isfield(file.API, fieldName)
        return % This was already generated, don't bother
    end

    PSB = file.Parent;
    % Setup local variables
    PyW = PSB.PyW;

    usePartialTables = PSB.PartialTables;

    % Change context
    changeBack = PSB.setScopedCallContext('TableDataFrame'); %#ok<NASGU>

    file.API.(fieldName) = funcName;
    SW = PyW.newMethod();
    SW.pf("def %s(iterator):\n", funcName);
    SW.indent();
    SW.pf('""" A helper function to convert an iterator to a tuple of lists for %s"""\n', file.funcName);

    ARGS = file.getInputElements(main=true, useData=true);

    N_ARGS = numel(ARGS);
    SW.pf("### List initializations\n");
    for k=1:N_ARGS
        ARG = ARGS(k);
        SW.insertLines(ARG.colsIteratorInit());
    end

    SW.pf("\n");
    SW.pf("### Spark_to_IMPY\n");
    if usePartialTables
        useColNames = "use_" + ARGS.colName;
        SW.pf("r0 = iterator.__next__()\n")
        SW.pf("d0 = r0.asDict()\n")
        SW.pf("keys = list(d0.keys())\n")
        SW.pf("num_keys = len(keys)\n")
        SW.pf("num_potential_args = %d\n", N_ARGS);
        SW.pf("names_potential_args = ['%s']\n", join([ARGS.Name], "', '"));
        SW.pf("names_potential_cols = ['%s']\n", join(ARGS.colName, "', '"));
        SW.pf("COLS = []\n")
        for an = 1:N_ARGS
            ARG = ARGS(an);
            SW.pf("# Column '%s'\n", ARG.Name);
            SW.pf("%s = '%s' in keys\n", useColNames(an), ARG.Name);
            SW.pf("if %d < num_keys:\n", an-1);
            SW.indent();
            SW.pf("COLS.append([r0[%d]])\n", an-1)
            SW.unindent();
            SW.pf("\n")
        end
        SW.pf('for row in iterator:\n')
        SW.indent();
        SW.pf("for idx in range(num_keys):\n");
        SW.indent();
        SW.pf("COLS[idx].append(row[idx])\n");
        SW.unindent();
        SW.unindent();
        SW.pf("\n")

        SW.pf("# The columns now must be set to the real column variables\n")
        SW.pf("for kc in range(num_keys):\n")
        SW.indent()
        SW.pf("key = keys[kc]\n")
        SW.pf("idx = names_potential_args.index(key)\n")
        SW.pf("# The following checks should only hit once for every kc\n")
        for cn = 1:N_ARGS
            SW.pf("if idx == %d:\n", cn-1);
            SW.indent()
            SW.pf("%s = COLS[kc]\n", ARGS(cn).colName)
            SW.unindent()
        end
        SW.unindent()

    else
        SW.pf('for row in iterator:\n')
        SW.indent();

        for k=1:N_ARGS
            rowStr = sprintf("row[%d]", k-1);

            codeLines = addIteratorRow(ARGS(k), rowStr);
            SW.insertLines(codeLines);
        end
        SW.unindent();
    end

    SW.pf("\n");
    
    SW.pf("### IMPY_to_IMML\n");
    if usePartialTables
        for k=1:N_ARGS
            ARG = ARGS(k);
            colName = ARG.colName;
            SW.pf("# Column '%s'\n", ARG.Name);
            SW.pf("if %s:\n", useColNames(k))
            SW.indent();          
            codeLines = ARG.col_IMPY_to_IMML(colName);
            SW.insertLines(codeLines);
            SW.unindent();
            SW.pf("\n");
        end
    else
        for k=1:N_ARGS
            ARG = ARGS(k);
            colName = ARG.colName;
            codeLines = ARG.col_IMPY_to_IMML(colName);
            SW.insertLines(codeLines);
        end
    end
    if N_ARGS==1
        % Always return a tuple
        SW.pf("return (%s,)\n", ARGS.colName);
    else
        SW.pf('return (%s)\n', join(ARGS.colName, ", "));
    end

    SW.unindent();

    PyW.addMethod(SW);

end
