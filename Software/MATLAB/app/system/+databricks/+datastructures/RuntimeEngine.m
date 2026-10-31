classdef RuntimeEngine 
    % RUNTIMEENGINE Databricks RuntimeEngine Data Structure
    % Decides which runtime engine to be use, e.g. Standard vs. Photon.
    % If unspecified, the runtime engine is inferred from spark_version.

    % Copyright 2023 The MathWorks, Inc.

    enumeration
        NULL
        STANDARD
        PHOTON
    end
end