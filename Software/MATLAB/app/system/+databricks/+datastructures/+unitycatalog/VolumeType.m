classdef VolumeType < JSONEnum
    % VolumeType Enumeration of the volume_type field within VolumeInfo
    %
    % Enumeration Values:
    %   MANAGED
    %   EXTERNAL

    % Copyright 2024 The MathWorks, Inc.

    enumeration
        MANAGED ("MANAGED")
        EXTERNAL ("EXTERNAL")
    end
end
