classdef Format < JSONEnum
    % Format Statement execution formats
    % Supported values:
    %   JSON_ARRAY
    %   ARROW_STREAM
    %   FORMAT_UNSPECIFIED
    %   CSV
    
    % Copyright 2023-2026, MathWorks Inc.

    enumeration
        FORMAT_UNSPECIFIED ("FORMAT_UNSPECIFIED")
        JSON_ARRAY ("JSON_ARRAY")
        ARROW_STREAM ("ARROW_STREAM")
        CSV ("CSV")
    end
end