classdef SecretPermission < JSONEnum
    % SecretPermission
    %
    % Example:
    %   secretPermission = databricks.datastructures.apps.SecretPermission.READ

    % Copyright 2026 The MathWorks, Inc.

    enumeration
        READ    ("READ")
        WRITE   ("WRITE")
        MANAGE  ("MANAGE")
    end
end