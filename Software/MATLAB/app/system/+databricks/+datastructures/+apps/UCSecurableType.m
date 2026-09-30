classdef UCSecurableType < JSONEnum
    % UCSecurableType
    %
    % Example:
    %   ucSecurableType = databricks.datastructures.apps.UCSecurableType.VOLUME

    % Copyright 2026 The MathWorks, Inc.

    enumeration
        VOLUME     ("VOLUME")
        TABLE      ("TABLE")
        FUNCTION   ("FUNCTION")
        CONNECTION ("CONNECTION")
    end
end