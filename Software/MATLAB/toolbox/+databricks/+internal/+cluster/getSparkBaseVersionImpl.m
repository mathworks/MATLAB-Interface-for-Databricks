function baseVersion = getSparkBaseVersionImpl(fullVersion)
    % getSparkBaseVersionImpl Returns the first 2 fields of a Spark Version separated by a "."
    % The result is returned as a string.
    %
    % Example:
    %   baseVersion = databricks.internal.cluster.getSparkBaseVersionImpl("10.4.x-scala2.12");

    % Copyright 2025-2026 The MathWorks, Inc.

    arguments (Input)
        fullVersion string {mustBeTextScalar, mustBeNonzeroLengthText}
    end
    arguments (Output)
        baseVersion string {mustBeTextScalar, mustBeNonzeroLengthText}
    end

    verFields = split(fullVersion, ".");
    if numel(verFields) >= 2
        baseVersion = string(verFields(1)) + "." + string(verFields(2));
    else
        error("DATABRICKS:INTERNAL:CLUSTER:getSparkBaseVersion", "fullVersion argument must contain at least 2 '.' separated version fields");
    end
end
