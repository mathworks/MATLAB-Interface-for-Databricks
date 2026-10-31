classdef CommandsStatusStatus < JSONEnum
    % Status CommandsStatusStatus of the Status
    %
    % Enumeration Values:
    %   "Cancelled" "Cancelling" "Error" "Finished" "Queued" "Running"

    % Copyright 2023 The MathWorks, Inc.

    enumeration
        Cancelled ("Cancelled")
        Cancelling ("Cancelling")
        Error ("Error")
        Finished ("Finished")
        Queued ("Queued")
        Running ("Running")
    end
end
