function DF = alias(obj, alias)
    % alias Returns a new DataFrame with an alias set.
    %
    % Example:
    % import matlab.pyspark.sql.functions.col
    % import matlab.pyspark.sql.functions.desc
    %
    % spark = getDatabricksSession;
    % df = spark.createDataFrame(py.str('[(14, "Tom"), (23, "Alice"), (16, "Bob")]'), schema={'age', 'name'});
    % df_as1 = df.alias("df_as1");
    % df_as2 = df.alias("df_as2");
    % joined_df = df_as1.join(df_as2, on=col("df_as1.name") == col("df_as2.name"), how='inner');
    % df2 = joined_df.select("df_as1.name", "df_as2.name", "df_as2.age").sort(desc("df_as1.name"));
    % df2.show();
    %   +-----+-----+---+
    %   | name| name|age|
    %   +-----+-----+---+
    %   |  Tom|  Tom| 14|
    %   |  Bob|  Bob| 16|
    %   |Alice|Alice| 23|
    %   +-----+-----+---+
    % 
    % t2 = table(df2)
    % t2 =
    %  3×3 table
    %   name      name_1     age
    %  _______    _______    ___
    %  "Tom"      "Tom"      14 
    %  "Bob"      "Bob"      16 
    %  "Alice"    "Alice"    23 
    
    % Copyright 2025-2026 MathWorks, Inc.

    arguments (Input)
        obj (1,1) matlab.pyspark.sql.dataframe.Dataframe
        alias string {mustBeTextScalar}
    end
    arguments (Output)
        DF (1,1) matlab.pyspark.sql.dataframe.Dataframe
    end

    DF = matlab.pyspark.sql.dataframe.Dataframe(obj.toPy.alias(alias));
end