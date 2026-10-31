function data = readSampleData(ReadLocation, FilePath, ClusterId)
    % READSAMPLEDATA Helper function to load sample data for Machine Learning example

    % Copyright 2026 MathWorks Inc.

    arguments
        ReadLocation string {mustBeTextScalar, mustBeNonzeroLengthText}
        FilePath (1,1) string
        ClusterId string {mustBeTextScalar, mustBeNonzeroLengthText}
    end

    % Decide if the data are local or remote
    switch lower(ReadLocation)

        case "local"
            % Read .csv file from local hard drive
            data = utils.readDiabetesFile(FilePath);


        case "volumes"
            % Check first to see if a cluster is available. If not this does not work.
            cl = databricks.Cluster.findById(ClusterId);
            if isempty(cl)
                data = [];
                return
            else
                % Create a Spark session
                spark = getDatabricksSession(); 
                % Create a DataFrame to read the .csv from DBFS
                df_PatientData = spark.read.format("csv") ...
                    .option("inferSchema", "true") ...
                    .option("delimiter", ";") ...
                    .option("header", "true") ...
                    .load(FilePath);
                % Read the DataFrame and convert it into a MATLAB table
                data = df_PatientData.table();
            end

        otherwise
            assert( ...
                false, ...
                "ReadLocation must be ""Local"" or ""Volumes"", %s is not supported.", ...
                ReadLocation);
    end
end