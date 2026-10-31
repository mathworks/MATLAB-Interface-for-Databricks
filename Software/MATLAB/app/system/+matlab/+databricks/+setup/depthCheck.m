function tf = depthCheck(options)
    % DEPTHCHECK
    %
    % See also: https://learn.microsoft.com/en-us/windows/win32/fileio/maximum-file-path-limitation

    %  Copyright 2024-2026 MathWorks, Inc.

    arguments
        % See: matlab.databricks.setup.internal.depthReport
        % 182 "/Software/MATLAB/Connect/13.3/venv/lib/python3.10/site-packages/pyspark/examples/src/main/python/sql/streaming/__pycache__/structured_network_wordcount_session_window.cpython-310.pyc"    longestPath = 
        options.longestReportPath = 182
        options.verbose (1,1) logical = true
    end
    
    % Only Windows has a limit that matters
    if ~ispc
        tf = true;
        return;
    end

    pkgBaseDirLength = strlength(databricksRoot(-2));

    totalPathLength = pkgBaseDirLength + options.longestReportPath;

    if totalPathLength >= 260 % allow for nul termination
        if options.verbose
            fprintf(2, "Windows path length limitation\n");
            fprintf(2, "==============================\n");
            fprintf("When fully configured this package contains paths of lengths up to %d characters.\n", options.longestReportPath);
            fprintf("The chosen installation directory is %d characters in length: %s\n", pkgBaseDirLength, databricksRoot(-2));
            fprintf("Windows can have a total path length limit of 260 characters.\n");
            winUrl = "https://learn.microsoft.com/en-us/windows/win32/fileio/maximum-file-path-limitation";
            fprintf("See: %s\n", matlab.utils.URL2Link(winUrl));
            fprintf("This can result in the .zip file not being extracted correctly, without notice.\n");
            fprintf(2, "\nChoose a shorter installation directory to extract the zip file into.\n");
        end
        tf = false;
    else
        tf = true;
    end
end

