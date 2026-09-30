classdef ListDeploymentResult < JSONMapper
    % ListDeploymentResult Class to represent app deployment list results

    % Copyright 2026 The MathWorks, Inc.

    properties
        % Deployment history of the app.
        appDeployments databricks.datastructures.apps.AppDeployment { JSONMapper.fieldName(appDeployments, "app_deployments"), JSONMapper.JSONArray }
        % Token to return next page of jobs
        nextPageToken string { JSONMapper.fieldName(nextPageToken, "next_page_token")}
    end


    methods
        function obj = ListDeploymentResult(s, inputs)
            arguments
                s {JSONMapper.ConstructorArgument} = []
                inputs.?databricks.datastructures.apps.ListDeploymentResult
            end
            obj@JSONMapper(s, inputs);
        end
    end
end