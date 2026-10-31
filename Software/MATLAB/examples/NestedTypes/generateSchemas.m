function generateSchemas()
    % generateSchemas Generate schemas for example code
    % Sample input is created.

    T = makeDeeplyData();
    generateFunctionSchema("deeply", {T});
end
