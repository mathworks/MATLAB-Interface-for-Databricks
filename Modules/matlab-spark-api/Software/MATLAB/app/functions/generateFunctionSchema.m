function schemaFileName = generateFunctionSchema(funcName, IN, OUT, options)
    % generateFunctionSchema Generate schema file for a function
    %
    % This function creates a schema file that provides the SparkBuilder
    % with additional information when compiling functions that should run
    % on Spark clusters.
    %
    % This function acts as a convenience functions for:
    %   compiler.build.spark.schema.mathworks.generateFunctionSchema
    %
    % For help see: compiler.build.spark.schema.mathworks.generateFunctionSchema

    % Copyright 2024-2026 The MathWorks, Inc.

    arguments (Input)
        funcName {mustBeA(funcName, ["function_handle", "string", "char"])}
        IN (1,:) cell
        OUT cell = {}
        options.verbose (1,1) logical = false
    end
    arguments (Output)
        schemaFileName string {mustBeFile}
    end

    if ~isempty(OUT)
        schemaFileName = compiler.build.spark.schema.mathworks.generateFunctionSchema(funcName, IN, OUT, verbose=options.verbose);
    else
        schemaFileName = compiler.build.spark.schema.mathworks.generateFunctionSchema(funcName, IN, verbose=options.verbose);
    end
end