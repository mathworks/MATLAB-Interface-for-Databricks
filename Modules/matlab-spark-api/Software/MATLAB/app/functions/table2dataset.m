function ds = table2dataset( T, spark, options )
    % TABLE2DATASET Function to create Spark dataset from MATLAB table
    %
    % For help, please refer to matlab.sparkutils.table2dataset
    
    % Copyright 2020-2025 MathWorks, Inc.


    arguments
        T table
        spark (1,1) matlab.pyspark.sql.session.SparkSession
        options.schema
    end

    msg = "This function, table2dataset, is shadowing a shipping function with the same name, " + ...
        "from the Statistics and Machine Learning Toolbox. " + ...
        "This function, for use with Spark/Databricks, has moved to: " + ...
        "'matlab.sparkutils.table2dataset'. Please change any code to use this " + ...
        "full name, as the function called here as been deprecated, and will be " + ...
        "removed in a future release.";

    warning("sparkapi:table2dataset_moved", msg);

    if isfield(options, 'schema')
        ds = matlab.sparkutils.table2dataset(T, spark, schema=options.schema);
    else
        ds = matlab.sparkutils.table2dataset(T, spark);
    end

end
