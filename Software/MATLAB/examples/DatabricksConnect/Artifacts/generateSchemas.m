function generateSchemas()
    % generateSchemas Generate schema files for all compiled MATLAB functions with sample input

    sigFile = "plusPi.schema";
    if ~isfile(sigFile)
        generateFunctionSchema("plusPi", {33});
    end

    sigFile = "doMath.schema";
    if ~isfile(sigFile)
        generateFunctionSchema("doMath", {3, 4.5});
    end

    sigFile = "addStringCol.schema";
    if ~isfile(sigFile)
        id = int64(1:10)';
        did = (1:10)';
        DF_T = table(id, did);
        generateFunctionSchema("addStringCol", {DF_T});
    end

    sigFile = "myArr.schema";
    if ~isfile(sigFile)
        generateFunctionSchema("myArr", {5, 1:5});
    end

    sigFile = "tblPlus.schema";
    if ~isfile(sigFile)
        A = int64(1:10)';
        B = double(A + 10);
        C = string(B + 10);
        T = table(A,B,C);
        generateFunctionSchema("tblPlus", {T, int64(3), double(5), "hello"});
    end
end
