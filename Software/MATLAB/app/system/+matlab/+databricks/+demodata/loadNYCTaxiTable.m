function DS = loadNYCTaxiTable(options)
    % loadNYCTaxiTable Helper function to load Databricks demo data
    %
    % This function assumes the corresponding example dataset is available
    % on the Databricks cluster used.

    % Copyright 2022-2025 The MathWorks, Inc.

    arguments
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

    nycYellowSrc = '/databricks-datasets/nyctaxi/tables/nyctaxi_yellow';

    DS = spark ...
        .read ...
        .format("delta") ...
        .load(nycYellowSrc);

end