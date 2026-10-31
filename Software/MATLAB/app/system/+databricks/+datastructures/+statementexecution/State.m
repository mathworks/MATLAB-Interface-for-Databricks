classdef State < JSONEnum
    % STATE Statement execution state
    %
    % Possible values:
    %   PENDING: waiting for warehouse
    %   RUNNING: running
    %   SUCCEEDED: execution was successful, result data available for fetch
    %   FAILED: execution failed; reason for failure described in accompanying error message
    %   CANCELED: user canceled; can come from explicit cancel call, or timeout with on_wait_timeout=CANCEL
    %   CLOSED: execution successful, and statement closed; result no longer available for fetch

    % (c) 2023-2026, MathWorks Inc.

    enumeration
        STATE_UNSPECIFIED ("STATE_UNSPECIFIED")
        PENDING ("PENDING")
        RUNNING ("RUNNING")
        SUCCEEDED ("SUCCEEDED")
        FAILED ("FAILED")
        CANCELED ("CANCELED")
        CLOSED ("CLOSED")
    end
end
