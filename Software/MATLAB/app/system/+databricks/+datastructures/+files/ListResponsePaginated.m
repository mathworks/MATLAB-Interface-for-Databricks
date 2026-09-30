classdef ListResponsePaginated < JSONMapper
    % LISTRESPONSEPAGINATED Paginated response to file list query

    % Copyright 2024 The MathWorks, Inc.

    properties
        % An array of DirectoryEntry for the contents of the directory
        contents databricks.datastructures.files.DirectoryEntry { JSONMapper.JSONArray }
        % A token, which can be sent as page_token to retrieve the next page
        % If next_page_token is set, there may be more entries in the directory.
        nextPageToken string { JSONMapper.fieldName(nextPageToken, "next_page_token") }
    end

    methods
        function obj = ListResponsePaginated(s, inputs)
            arguments
                s {JSONMapper.ConstructorArgument} = []
                inputs.?databricks.datastructures.files.ListResponsePaginated
            end
            obj@JSONMapper(s, inputs);
        end
    end
end
