classdef Resource < JSONMapper
    % RESOURCE
    %
    % App API 2.0

    % Copyright 2026 The MathWorks, Inc.

    properties
        app databricks.datastructures.apps.App { JSONMapper.fieldName(app, "app"), JSONMapper.JSONArray}
        database databricks.datastructures.apps.Database { JSONMapper.fieldName(database, "database")}
        description string { JSONMapper.fieldName(description, "description")}
        experiment databricks.datastructures.apps.Experiment { JSONMapper.fieldName(experiment, "experiment")}
        genieSpace databricks.datastructures.apps.GenieSpace { JSONMapper.fieldName(genieSpace, "genie_space")}
        job databricks.datastructures.apps.Job { JSONMapper.fieldName(job, "job")}
        name string { JSONMapper.fieldName(name, "name")}
        postgres databricks.datastructures.apps.Postgres { JSONMapper.fieldName(postgres, "postgres")}
        secret databricks.datastructures.apps.Secret { JSONMapper.fieldName(secret, "secret")}
        servingEndpoint databricks.datastructures.apps.ServingEndpoint { JSONMapper.fieldName(servingEndpoint, "serving_endpoint")}
        sqlWarehouse databricks.datastructures.apps.SQLWarehouse { JSONMapper.fieldName(sqlWarehouse, "sql_warehouse")}
        ucSecurable databricks.datastructures.apps.UCSecurable { JSONMapper.fieldName(ucSecurable, "uc_securable")}
    end

    methods
        function obj = Resource(s, inputs)
            arguments
                s {JSONMapper.ConstructorArgument} = []
                inputs.?databricks.datastructures.apps.Resource
            end
            obj@JSONMapper(s, inputs);
        end
    end
end
