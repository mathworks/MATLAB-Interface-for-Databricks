function newCol = transform(col, func)
    % transform Transforms column into new column
    %
    % The transformation that is applied is done by an operation that can
    % already be applied to a column, e.g. col * 2
    %
    % Example for using transforms. 
    %
    % function DF = test2_transform(spark)
    %
    %     import matlab.pyspark.sql.functions.transform
    %     DF = spark.range(10);
    %     DF = DF ...
    %         .withColumn('doubled', transform(DF.('id'), @tf1)) ...
    %         .withColumn('stringed', transform(DF.('id'), @(x) x.cast('string')));
    %     % DF = DF ...
    %     %     .withColumn("add_3", transform(DF.('id'), tf2(3)));
    % end
    %
    % function new_col = tf1(col)
    %     % tf1 - Double a column in MATLAB code
    %     new_col = col * 2;
    % end
    %
    % function pyTransform = tf2(num)
    %     % tf2 Add num to a column in Python code
    %
    %     funcDef = ...
    %         "def adder(col):" + ...
    %         "    return (col + " + string(num) + ")";
    %         % "    return (col + 2.5)";
    %     funcReturn = "a = adder";
    %
    %     pyTransform = pyrun([funcDef, funcReturn], "a");
    %
    % end

    % Copyright 2025 MathWorks, Inc.

    arguments (Input)
        col {matlab.pyspark.internal.mustBeColType}
        func
    end

    arguments (Output)
        newCol (1,1) matlab.pyspark.sql.column.Column
    end

    funcClazz = class(func);
    switch funcClazz
        case {'py.function', 'py.builtin_function_or_method'}
            if isa(col, "matlab.pyspark.sql.column.Column")
                col = col.toPy;
            end
            newCol = matlab.pyspark.sql.column.Column(py.pyspark.sql.functions.transform(col, func));
        case 'function_handle'
            newCol = feval(func, col);
    end


end