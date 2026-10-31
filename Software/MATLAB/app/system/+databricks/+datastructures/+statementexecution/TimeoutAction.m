classdef TimeoutAction < JSONEnum
    % TimeoutAction Action taken when wait_timeout expires
    % CONTINUE returns the statement ID while execution continues
    % asynchronously. CANCEL cancels the statement when the wait timeout is
    % reached.

    % Copyright 2023-2026, MathWorks Inc.

    enumeration
        TIMEOUT_ACTION_UNSPECIFIED ("TIMEOUT_ACTION_UNSPECIFIED")
        CONTINUE ("CONTINUE")
        CANCEL ("CANCEL")
    end
end
