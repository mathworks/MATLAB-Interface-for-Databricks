function D = fromSchema(S, options)
    % fromSchema Create Data from Schema
 
    % Copyright 2024 The MathWorks, Inc.

    arguments
        S (1,1) compiler.build.spark.schema.DataType
        options.parent 
    end
    schemaClazz = string(class(S));
    schemaParts = split(schemaClazz, ".");
    schemaName = schemaParts(end);

    dataClazz = "compiler.build.spark.data." + schemaName;

    if isfield(options, 'parent')
        D = feval(dataClazz, S, options.parent);
    else
        D = feval(dataClazz, S);
    end
    % Cross reference +schema and +data for easy reference
    D.schema_ = S;
    S.data_ = D;
end

