classdef State < JSONEnum
    % STATE Statement execution state

    % (c) 2025 The MathWorks Inc.

    enumeration
        % waiting for warehouse
        PENDING ("PENDING")
        % Running
        RUNNING ("RUNNING")
        % Execution was successful, result data available for fetch
        SUCCEEDED ("SUCCEEDED")
        % Execution failed; reason for failure described in accompanying error message
        FAILED ("FAILED")
        % User canceled; can come from explicit cancel call, or timeout with on_wait_timeout=CANCEL
        CANCELED ("CANCELED")
        % Execution successful, and statement closed; result no longer available for fetch
        CLOSED ("CLOSED")
    end
end