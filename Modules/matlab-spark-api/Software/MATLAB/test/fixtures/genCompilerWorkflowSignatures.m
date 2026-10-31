function T = genCompilerWorkflowSignatures(N)
    % genCompilerWorkflowTable Create data for tests

    % Copyright 2023-2025 MathWorks, Inc.

    T = parquetread("compiler_workflows.parquet");
    T2 = genCompilerWorkflowTableArrays(100);

    T3 = table(...
        (datetime('now') + hours(1:3))', ...
        {["what", "a", "day"], ["short"], ["more", "elements", "yet"]}', ...
        {int32(1:5), int32(10:2:25), int32(4)}', ...
        'VariableNames', {'ts', 'a', 'b'});
    compiler.build.spark.types.generateFunctionSignature("fValues", {T{1,1}, T{1,2}, T{1,3}, T{1,4}, T{1,5}, T{1,6}, T{1,7}, T{1,8}, T{1,9}});
    compiler.build.spark.types.generateFunctionSignature("fTable", {T});
    compiler.build.spark.types.generateFunctionSignature("fTablePlus", {T, T{1,1}, T{1,2}, T{1,3}, T{1,4}, T{1,5}, T{1,6}, T{1,7}, T{1,8}, T{1,9}});
    compiler.build.spark.types.generateFunctionSignature("fBad_1", {T, T});
    compiler.build.spark.types.generateFunctionSignature("fBad_2", {T});
    compiler.build.spark.types.generateFunctionSignature("fBad_3", {T});

    compiler.build.spark.types.generateFunctionSignature("fValues_Arrays", {T2{1,1}, T2{1,2}, T2{1,3}, T2{1,4}, T2{1,5}, T2{1,6}, T2{1,7}, T2{1,8}, T2{1,9}});
    compiler.build.spark.types.generateFunctionSignature("fValues_Arrays2", {"good", "bad"});
    compiler.build.spark.types.generateFunctionSignature("fValues_Arrays3", {"good"});
    compiler.build.spark.types.generateFunctionSignature("fValues_Arrays4", {"good"});
    compiler.build.spark.types.generateFunctionSignature("fValues_Arrays5", {"good", "bad"});
    compiler.build.spark.types.generateFunctionSignature("fValues_Arrays6", {datetime('now') + minutes(1:5), "bad"});

    generateFunctionSchema("fFilter1", {int64(33), "hello", int32(60)});
    generateFunctionSchema("fVarArrSize1", {datetime('now'), int32(3), int32(6)});
    generateFunctionSchema("fVarArrSize2", {T2(:, ["id", "ts"])});
    generateFunctionSchema("fVarArrSize3", {datetime('now'), ["a", "b", "c"], int32(1:5)});
    generateFunctionSchema("fVarArrSize4", {T3});

    compiler.build.spark.types.generateFunctionSignature("fSISO", {int16(5)});

    % New code, for generating schemas
    generateFunctionSchema("fValues_Arrays2", {"good", "bad"});
    generateFunctionSchema("fValues_Arrays3", {"good"});
    generateFunctionSchema("fValues_Arrays4", {"good"});
    generateFunctionSchema("fValues_Arrays5", {"good", "bad"});
    generateFunctionSchema("fValues_Arrays6", {datetime('now') + minutes(1:5), "bad"});

    generateFunctionSchema("fValues", {T{1,1}, T{1,2}, T{1,3}, T{1,4}, T{1,5}, T{1,6}, T{1,7}, T{1,8}, T{1,9}});
    generateFunctionSchema("fTable", {T});
    generateFunctionSchema("fSISO", {int16(5)});
    generateFunctionSchema("fTablePlus", {T, T{1,1}, T{1,2}, T{1,3}, T{1,4}, T{1,5}, T{1,6}, T{1,7}, T{1,8}, T{1,9}});

end
