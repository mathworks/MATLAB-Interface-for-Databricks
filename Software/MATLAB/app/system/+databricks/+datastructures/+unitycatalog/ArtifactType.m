classdef ArtifactType < JSONEnum
    % ArtifactType Enumeration of the artifact type of the allowlist
    %
    % Enumeration Values:
    %   INIT_SCRIPT
    %   LIBRARY_JAR
    %   LIBRARY_MAVEN

    % Copyright 2023 The MathWorks, Inc.

    enumeration
        INIT_SCRIPT ("INIT_SCRIPT")
        LIBRARY_JAR ("LIBRARY_JAR")
        LIBRARY_MAVEN ("LIBRARY_MAVEN")
    end
end
