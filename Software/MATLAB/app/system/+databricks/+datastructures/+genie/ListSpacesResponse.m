classdef ListSpacesResponse < JSONMapper
    % LISTSPACESRESPONSE Class to represent a page Genie list space responses

    % Copyright 2025 The MathWorks, Inc.

    properties
        nextPageToken string { JSONMapper.fieldName(nextPageToken, "next_page_token") }
        spaces databricks.datastructures.genie.Space { JSONMapper.fieldName(spaces, "spaces"), JSONMapper.JSONArray }
    end

    methods
        function obj = ListSpacesResponse(s, inputs)
            arguments
                s {JSONMapper.ConstructorArgument} = []
                inputs.?databricks.datastructures.genie.ListSpacesResponse
            end
            obj@JSONMapper(s, inputs);
        end
    end
end