classdef ContextsStatus < JSONEnum
    % ContextsStatus Enumeration of the Status
    %
    % Enumeration Values:
    %   Running
    %   Pending
    %   Error

    % Copyright 2023 The MathWorks, Inc.

    enumeration
        Running ("Running")
        Pending ("Pending")
        Error ("Error")
    end
end
