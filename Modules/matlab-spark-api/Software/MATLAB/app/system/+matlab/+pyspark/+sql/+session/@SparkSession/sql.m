function df = sql(obj, sqlStr)
    % sql - Execute a SQL statement
    %
    % This version doesn't support additional arguments for binding special
    % variables. When applicable, this can be achieved by formatting the
    % string correspondingly instead, e.g. using sprintf statements.

    % (c) 2024 MathWorks, Inc.

    arguments (Input)
        obj (1,1) matlab.pyspark.sql.session.SparkSession
        sqlStr (1,1) string
    end
    arguments (Output)
        df (1,1) matlab.pyspark.sql.dataframe.Dataframe
    end

    df = matlab.pyspark.sql.dataframe.Dataframe(obj.sparkSession.sql(sqlStr));

end