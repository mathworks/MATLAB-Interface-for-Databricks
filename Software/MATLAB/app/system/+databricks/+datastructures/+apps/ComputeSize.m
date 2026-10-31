classdef ComputeSize < JSONEnum
    % ComputeSize The mode of which the deployment will manage the source code
    %
    % Example:
    %   computeSize = databricks.datastructures.apps.ComputeSize.LARGE

    % Copyright 2026 The MathWorks, Inc.

    enumeration
        MEDIUM ("MEDIUM")
        LARGE ("LARGE")
    end
end