classdef State < JSONEnum
    % STATE Current state of the instance pool

    % (c) 2025 The MathWorks Inc.

    enumeration
        ACTIVE ("ACTIVE")
        STOPPED ("STOPPED")
        DELETED ("DELETED")
    end
end

