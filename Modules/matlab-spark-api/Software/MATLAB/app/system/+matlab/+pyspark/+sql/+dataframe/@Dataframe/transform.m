function newDF = transform(DF, func)
    % transform Returns a new DataFrame. Concise syntax for chaining custom transformations.
    %
    % Here's a simple example on how the transform function can be used on
    % Dataframes, either with MATLAB functions, or with Python functions.
    %
    %     function DF_new = tf1(DF)
    %         import matlab.pyspark.sql.functions.lit
    %         DF_new = DF.withColumn("hello", lit("Hello"));
    %     end
    %    
    %     function pyTransform = tf2()
    %         funcDef = ...
    %             "def myfunc(DF):" + ...
    %             "    return DF.withColumn('doubled', DF['id'] * 2)";
    %         funcReturn = "a = myfunc";
    %         pyTransform = pyrun([funcDef, funcReturn], "a");
    %     end
    %
    %     R = spark.range(5);
    %     DF = R.transform(@tf1).transform(tf2());
    %     DF.show()
    %     +---+-----+-------+
    %     | id|hello|doubled|
    %     +---+-----+-------+
    %     |  0|Hello|      0|
    %     |  1|Hello|      2|
    %     |  2|Hello|      4|
    %     |  3|Hello|      6|
    %     |  4|Hello|      8|
    %     +---+-----+-------+

    % Copyright 2025 MathWorks, Inc.

    arguments (Input)
        DF (1,1) matlab.pyspark.sql.dataframe.Dataframe
        func
    end

    arguments (Output)
        newDF (1,1) matlab.pyspark.sql.dataframe.Dataframe
    end

    funcClazz = class(func);
    switch funcClazz
        case {'py.function', 'py.builtin_function_or_method'}
            newDF = matlab.pyspark.sql.dataframe.Dataframe(DF.toPy.transform(func));
        case 'function_handle'
            newDF = feval(func, DF);
    end

end