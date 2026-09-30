classdef DeploymentState < JSONEnum
    % DeploymentState State of the deployment
    %
    % Example:
    %   state = databricks.datastructures.apps.DeploymentState.SUCCEEDED

    % Copyright 2026 The MathWorks, Inc.

    enumeration
        SUCCEEDED ("SUCCEEDED")
        FAILED ("FAILED")
        IN_PROGRESS ("IN_PROGRESS")
        CANCELLED ("CANCELLED")
    end
end