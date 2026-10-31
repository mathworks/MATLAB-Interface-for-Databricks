function tf = isPythonVersionSupported(pythonVersion, options)
    % ISPYTHONVERSIONSUPPORTED Returns true if MATLAB supports a given Python version
    % At least the first 2 version fields should be provided, e.g.: 3.11
    %
    % Supports MATLAB R2022b and later.
    %
    % Example:
    %   tf = matlab.internal.utils.isPythonVersionSupported("3.11.3");

    % Copyright 2025-2026 The MathWorks, Inc.

    arguments (Input)
        pythonVersion string {mustBeTextScalar, mustBeNonzeroLengthText}
        options.release string {mustBeTextScalar, mustBeNonzeroLengthText}
    end

    % R2023a is the cut off for Python 2.x
    if isMATLABReleaseOlderThan("R2022b")
        error("MATLAB:UTILS:ISPYTHONVERSIONSUPPORTED:R2022bGE",...
            "isPythonVersionSupported requires MATLAB R2022b or later.");
    end

    if isfield(options, "release")
        release = options.release;
    else
        release = matlabRelease().Release;
    end

    tf = false;

    % Allow for 3.11 to be converted to 3.11.
    if ~endsWith(pythonVersion, ".")
        pythonVersion = pythonVersion + ".";
    end

    switch release
        case "R2026b"
            if startsWith(pythonVersion, "3.10.") || startsWith(pythonVersion, "3.11.") || startsWith(pythonVersion, "3.12.") || startsWith(pythonVersion, "3.13.") || startsWith(pythonVersion, "3.14.")
                tf = true;
            end

        case {"R2026a", "R2025b", "R2025a", "R2024b"}
            if startsWith(pythonVersion, "3.9.") || startsWith(pythonVersion, "3.10.") || startsWith(pythonVersion, "3.11.") || startsWith(pythonVersion, "3.12.")
                tf = true;
            end

        case {"R2024a", "R2023b"}
            if startsWith(pythonVersion, "3.9.") || startsWith(pythonVersion, "3.10.") || startsWith(pythonVersion, "3.11.")
                tf = true;
            end

        case {"R2023a"}
            if startsWith(pythonVersion, "3.8.") || startsWith(pythonVersion, "3.9.") || startsWith(pythonVersion, "3.10.")
                tf = true;
            end

        case {"R2022b"}
            if startsWith(pythonVersion, "2.7.") || startsWith(pythonVersion, "3.7.") || startsWith(pythonVersion, "3.8.") || startsWith(pythonVersion, "3.9.") || startsWith(pythonVersion, "3.10.")
                tf = true;
            end

        otherwise
            error("MATLAB:UTILS:ISPYTHONVERSIONSUPPORTED:UNSUPPORTED",...
                "MATLAB Release not supported: %s", release)
    end
end
