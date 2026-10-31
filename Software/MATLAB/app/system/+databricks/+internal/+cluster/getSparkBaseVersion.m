function baseVersion = getSparkBaseVersion(fullVersion)
    % getSparkBaseVersion Returns the first 2 fields of a Spark Version separated by a "." or a "-"
    % The result is returned as a string.
    %
    % Example:
    %   baseVersion = databricks.internal.cluster.getSparkBaseVersion("17.4.x-scala2.13");

    %  Copyright 2025-2026 MathWorks, Inc.

    arguments (Input)
        fullVersion string {mustBeTextScalar, mustBeNonzeroLengthText}
    end
    arguments (Output)
        baseVersion string {mustBeTextScalar, mustBeNonzeroLengthText}
    end

    if contains(fullVersion, ".x")
        baseVersion = extractBefore(fullVersion, ".x");
    else
        error("DATABRICKS:INTERNAL:CLUSTER:getSparkBaseVersion", 'fullVersion argument must contain a version followed by ".x".');
    end
end