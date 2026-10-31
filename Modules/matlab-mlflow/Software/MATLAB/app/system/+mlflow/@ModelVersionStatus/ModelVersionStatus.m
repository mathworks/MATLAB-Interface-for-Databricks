classdef ModelVersionStatus
    % MODELVERSIONSTATUS Status of a Model Version registration
    % Possible values:
    %   PENDING_REGISTRATION  Request to register a new model version is pending
    %                         as server performs background tasks
    %
    %    FAILED_REGISTRATION  Request to register a new model version has failed
    %
    %                  READY  Model version is ready for use

    %  (c) 2021 MathWorks, Inc.

    enumeration
        PENDING_REGISTRATION    % Request to register a new model version is pending
                                % as server performs background tasks
        FAILED_REGISTRATION     % Request to register a new model version has failed
        READY                   % Model version is ready for use
    end

end %class