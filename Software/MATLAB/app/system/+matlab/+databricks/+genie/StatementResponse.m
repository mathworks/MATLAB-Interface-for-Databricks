classdef StatementResponse < handle
    % genie StatementResponse helper class

    % Copyright 2025 The MathWorks, Inc.

    properties (Hidden)
        StatementResponse_ (1,1) databricks.datastructures.genie.StatementResponse
    end
    properties (Dependent, SetAccess=private)
        State  databricks.datastructures.genie.State
    end

    methods
        function obj = StatementResponse(statementResponse)
            obj.StatementResponse_ = statementResponse;
        end


        function state = get.State(obj)
            state = obj.StatementResponse_.status.state;
        end
    end
end
