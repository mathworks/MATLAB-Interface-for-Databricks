classdef DeltaSharingScope < JSONEnum
    % DeltaSharingScope Enumeration of the delta_sharing_scope field within
    % MetastoreInfo
    %
    % Enumeration Values:
    %   INTERNAL
    %   INTERNAL_AND_EXTERNAL
    

    % Copyright 2022 The MathWorks, Inc.

    enumeration
        % Internal Delta Sharing enabled on metastore
        INTERNAL ("INTERNAL")
        % Internal and External Delta Sharing enabled on metastore
        INTERNAL_AND_EXTERNAL ("INTERNAL_AND_EXTERNAL")
    end
end
