classdef UCSecurablePermission < JSONEnum
    % UCSecurablePermission
    %
    % Example:
    %   ucSecurablePermission = databricks.datastructures.apps.UCSecurablePermission.READ_VOLUME

    % Copyright 2026 The MathWorks, Inc.

    enumeration
        READ_VOLUME     ("READ_VOLUME")
        WRITE_VOLUME    ("WRITE_VOLUME")
        SELECT          ("SELECT")
        EXECUTE         ("EXECUTE")
        USE_CONNECTION  ("USE_CONNECTION")
        MODIFY          ("MODIFY")
    end
end