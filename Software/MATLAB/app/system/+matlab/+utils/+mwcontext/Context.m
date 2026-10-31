classdef Context < JSONMapper
    % Context Class for context of mw_context
    %
    % This class is the top-leve class containing information about the
    % startup/shutdown feature, which decides which operations a user
    % wants to be run at startup/shutdown.

    % Copyright 2026 The MathWorks, Inc.

    properties
        type  string 
        %{JSONMapper.fieldName(type, "type")}
        username string
        operations matlab.utils.mwcontext.Operation {JSONMapper.JSONArray}
    end

    methods
        function obj = Context(s, inputs)
            arguments
                s {JSONMapper.ConstructorArgument} = []
                inputs.?matlab.utils.mwcontext.Context
            end
            obj = obj.initialize(s,inputs);
        end

        function startup(obj)
            fprintf("Running startup for Context.\n")
            for k=1:numel(obj.operations)
                op = obj.operations(k);
                fprintf("Running startup for op #%d\n", k);
                op.startup();
            end
        end
        function shutdown(obj)
            fprintf("Running shutdown for Context.\n")
            for k=1:numel(obj.operations)
                op = obj.operations(k);
                fprintf("Running shutdown for op #%d\n", k);
                op.shutdown();
            end
        end
    end
end