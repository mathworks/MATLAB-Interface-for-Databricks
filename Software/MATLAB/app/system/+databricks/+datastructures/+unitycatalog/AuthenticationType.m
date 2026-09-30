classdef AuthenticationType < JSONEnum
    % AuthenticationType Enumeration of the authentication_type field within TableInfo
    %
    % Enumeration Values:
    %   TOKEN
    %   DATABRICKS

    % Copyright 2023 The MathWorks, Inc.

    enumeration
        TOKEN ("TOKEN")
        DATABRICKS ("DATABRICKS")
    end
end
