classdef ResultType < JSONEnum
    % Status ResultType of the Status
    %
    % Enumeration Values:
    %   "error" "image" "images" "table" "text"

    % Copyright 2023 The MathWorks, Inc.

    enumeration
        error ("error")
        image ("image")
        images ("images")
        table ("table")
        text ("text")
    end
end
