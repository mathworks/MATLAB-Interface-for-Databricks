classdef RunStatus
    % RUNSTATUS Status of a run
    % Possible values:
    %     RUNNING  Run has been initiated
    %   SCHEDULED  Run is scheduled to run at a later time
    %    FINISHED  Run has completed
    %      FAILED  Run execution failed
    %      KILLED  Run killed by user

    %  (c) 2021 MathWorks, Inc.

    enumeration
        RUNNING    % Run has been initiated
        SCHEDULED  % Run is scheduled to run at a later time
        FINISHED   % Run has completed
        FAILED     % Run execution failed
        KILLED     % Run killed by user
    end

end %class