classdef ListAppsResult < JSONMapper
    % ListAppsResult Class to represent app list results

    % (c) 2026 MathWorks, Inc.

    properties
        % List of apps.
        apps databricks.datastructures.apps.ListAppsResponse { JSONMapper.fieldName(apps, "apps"), JSONMapper.JSONArray }
        % Token to return next page of apps
        nextPageToken string { JSONMapper.fieldName(nextPageToken, "next_page_token")}
    end

    methods
        function obj = ListAppsResult(s, inputs)
            arguments
                s {JSONMapper.ConstructorArgument} = []
                inputs.?databricks.datastructures.apps.ListAppsResult
            end
            obj@JSONMapper(s, inputs);
        end
    end
end
