classdef TableSummariesResp < JSONMapper
    % TableSummariesResp Databricks Data Structure
    %
    % databricks.datastructures.unitycatalog.TableSummariesResp Properties:
    %   tables - List of Table Summaries
    %   next_page_token - Opaque token to use to retrieve the next page of results

    % Copyright 2022-2024 The MathWorks, Inc.

    properties
        % List of Table Summaries
        tables databricks.datastructures.unitycatalog.TableSummary {JSONMapper.JSONArray}
        % Opaque token to use to retrieve the next page of results
        next_page_token string
    end

    methods
        function obj = TableSummariesResp(s, inputs)
            arguments
                s {JSONMapper.ConstructorArgument} = []
                inputs.?databricks.datastructures.unitycatalog.TableSummariesResp
            end
            obj@JSONMapper(s, inputs);
        end
    end
end