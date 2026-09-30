classdef ErrorResponse < JSONMapper
    % ErrorResponse Error response body
    %
    % databricks.datastructures.unitycatalog.ErrorResponse Properties:
    %   error_code - error code
    %   message - error message
    %   details - error details

    % Copyright 2022-2024 The MathWorks, Inc.

    properties
        error_code string
        message string
        details {JSONMapper.JSONArray}
    end

    methods
        function obj = ErrorResponse(s, inputs)
            arguments
                s {JSONMapper.ConstructorArgument} = []
                inputs.?databricks.datastructures.unitycatalog.ErrorResponse
            end
            obj@JSONMapper(s, inputs);
        end

        function throw(obj)
            if isprop(obj, "message") && ~isempty(obj.message) && (ischar(obj.message) || isStringScalar(obj.message))
                me = MException("databricks:unitycatalog:" + obj.error_code, obj.message);
            else
                me = MException("databricks:unitycatalog:" + obj.error_code, "");
            end
            throwAsCaller(me);
        end
    end
end