classdef ViewType
    % VIEWTYPE View type for ListExperiments query
    % Possible values:
    %
    %    ACTIVE_ONLY  Default, Return only active experiments
    %   DELETED_ONLY  Return only deleted experiments
    %            ALL  Get all experiments

    %  (c) 2021 MathWorks, Inc.

    enumeration
        ACTIVE_ONLY     % Default, Return only active experiments
    	DELETED_ONLY    % Return only deleted experiments
        ALL             % Get all experiments
    end

end %class