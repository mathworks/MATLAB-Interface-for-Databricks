classdef ErrorResponse < JSONMapper
    % ErrorResponse Error response body

    % Copyright 2025 The MathWorks, Inc.

    properties
        schemas string { JSONMapper.JSONArray, JSONMapper.fieldName(schemas,"schemas")}
        status string {JSONMapper.fieldName(status,"status")}
        detail string {JSONMapper.fieldName(detail,"detail")}
    end

    methods
        function obj = ErrorResponse(s, inputs)
            arguments
                s {JSONMapper.ConstructorArgument} = []
                inputs.?databricks.datastructures.currentuser.ErrorResponse
            end
            obj@JSONMapper(s, inputs);
        end

        function throw(obj)
            if isempty(obj.detail) || ~isStringScalar(obj.detail)
                obj.message = "";
            end
            if isempty(obj.status) || ~isStringScalar(obj.status)
                obj.errorCode = "";
            end
            me = MException("databricks:ErrorResponse","Error: %s, %s", obj.status, obj.detail);
            throwAsCaller(me);
        end
    end
end