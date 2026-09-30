function printSchema(obj)
    % printSchema Display the Dataset's underlying schema in the console
    %
    % Example:
    %
    %     DS.printSchema()

    % Copyright 2024 The MathWorks, Inc.
    arguments
        obj (1,1) matlab.pyspark.sql.dataframe.Dataframe
    end
    obj.toPy.printSchema();

end
