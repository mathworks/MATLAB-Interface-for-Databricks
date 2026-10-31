classdef ProvisioningState < JSONEnum
    % ProvisioningState The provisioning state of the resource.
    %
    % Enumeration Values:
    %   PROVISIONING
    %   ACTIVE
    %   FAILED
    %   DELETING
    %   UPDATING
    %   DEGRADED

    % Copyright 2026 The MathWorks, Inc.

    enumeration
        PROVISIONING ("PROVISIONING")
        ACTIVE ("ACTIVE")
        FAILED ("FAILED")
        DELETING ("DELETING")
        UPDATING ("UPDATING")
        DEGRADED ("DEGRADED")
    end
end
