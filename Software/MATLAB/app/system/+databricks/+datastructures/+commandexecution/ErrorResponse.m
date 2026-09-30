classdef ErrorResponse < JSONMapper
    % ErrorResponse Error response body
    %
    % databricks.datastructures.commandexecution.ErrorResponse Properties:
    %   error - error message

    % Copyright 2023 The MathWorks, Inc.

    properties
        error string = string.empty
    end

    methods
        function obj = ErrorResponse(s, inputs)
            arguments
                s {JSONMapper.ConstructorArgument} = []
                inputs.?databricks.datastructures.commandexecution.ErrorResponse
            end
            obj@JSONMapper(s, inputs);
        end
    
        function throw(obj)
            if isempty(obj.error) || ~isStringScalar(obj.error)
                obj.error = "";
            end
            me = MException("databricks:commandexecution","error: %s", obj.error);
            throwAsCaller(me);
        end
    end
end