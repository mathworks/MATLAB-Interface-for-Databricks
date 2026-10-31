function DS = loadFires(options)
    % loadFires Helper function to load Databricks demo data
    %
    % This function assumes the corresponding example dataset is available
    % on the Databricks cluster used.

    % Copyright 2022-2025 The MathWorks, Inc.

    arguments
        options.convertTypes (1,1) logical = false
        options.spark (1,1) matlab.pyspark.sql.session.SparkSession
        options.cluster {databricks.internal.cluster.mustBeScalarClusterOrId}
        options.profileName string {mustBeTextScalar, mustBeNonzeroLengthText} = databricks.internal.configurationprofile.ConfigFile.getDefaultProfileName
        options.authMethod (1,1) matlab.databricks.AuthMethod
    end

    if isfield(options, 'spark')
        spark = options.spark;
    else
        args = matlab.utils.addArgs(options, ["profileName", "cluster", "authMethod"]);
        spark = getDatabricksSession(args{:});
    end

    firesSrc = '/databricks-datasets/timeseries/Fires/Fire_Department_Calls_for_Service.csv';

    DS = spark ...
        .read ...
        .format("csv") ...
        .option("header", "true") ...
        .option("inferSchema", "true") ...
        .load(firesSrc);

    if options.convertTypes
        import matlab.pyspark.sql.functions.to_timestamp
        DS2 = DS ...
            .withColumn("Received DtTm", to_timestamp(DS.col("Received DtTm"), "M/d/y h:m:s a")) ...
            .withColumn("Entry DtTm", to_timestamp(DS.col("Entry DtTm"), "M/d/y h:m:s a")) ...
            .withColumn("Dispatch DtTm", to_timestamp(DS.col("Dispatch DtTm"), "M/d/y h:m:s a")) ...
            .withColumn("Response DtTm", to_timestamp(DS.col("Response DtTm"), "M/d/y h:m:s a")) ...
            .withColumn("On Scene DtTm", to_timestamp(DS.col("On Scene DtTm"), "M/d/y h:m:s a")) ...
            .withColumn("Transport DtTm", to_timestamp(DS.col("Transport DtTm"), "M/d/y h:m:s a")) ...
            .withColumn("Hospital DtTm", to_timestamp(DS.col("Hospital DtTm"), "M/d/y h:m:s a")) ...
            .withColumn("Available DtTm", to_timestamp(DS.col("Available DtTm"), "M/d/y h:m:s a")) ...
            ;
        DS = DS2;
    end

end