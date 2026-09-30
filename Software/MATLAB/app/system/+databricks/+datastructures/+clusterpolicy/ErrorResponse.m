classdef ErrorResponse < JSONMapper
    % ErrorResponse Error response body
    %
    % databricks.datastructures.clusterpolicy.ErrorResponse Properties:
    %   errorCode
    %   message
    
    % Copyright 2024 The MathWorks, Inc.

    properties
        errorCode string {JSONMapper.fieldName(errorCode,"error_code")}
        message string = string.empty
    end

    methods
        function obj = ErrorResponse(s, inputs)
            arguments
                s {JSONMapper.ConstructorArgument} = []
                inputs.?databricks.datastructures.clusterpolicy.ErrorResponse
            end
            obj@JSONMapper(s, inputs);
        end


        function throw(obj)
            if isempty(obj.message) || ~isStringScalar(obj.message)
                obj.message = "";
            end
            if isempty(obj.errorCode) || ~isStringScalar(obj.errorCode)
                obj.errorCode = "";
            end
            me = MException("databricks:clusterpolicy","Error: %s, %s", obj.errorCode, obj.message);
            throwAsCaller(me);
        end
    end
end