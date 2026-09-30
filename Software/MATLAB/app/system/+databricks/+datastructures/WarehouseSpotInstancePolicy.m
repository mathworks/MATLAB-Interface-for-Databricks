classdef WarehouseSpotInstancePolicy
    % WarehouseSpotInstancePolicy Databricks WarehouseSpotInstancePolicy Data
    % Structure.

    % Copyright 2022-2023 The MathWorks, Inc.
    enumeration
        % Use an on-demand instance for the cluster driver and spot
        % instances for cluster executors. The maximum spot price is 100%
        % of the on-demand price. This is the default policy.
        COST_OPTIMIZED
        % Use on-demand instances for all cluster nodes.
        RELIABILITY_OPTIMIZED
        POLICY_UNSPECIFIED
    end
end