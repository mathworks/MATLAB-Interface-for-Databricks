function startup(options)
    % STARTUP - Script to add paths to MATLAB path
    % This script will add the paths below the root directory into the MATLAB
    % path. It will omit the SVN and other crud. You may modify undesired path
    % filter to your desire.
    %
    % Optional arguments:
    %   runDiagnostics: Run diagnostics.
    %
    %          verbose: Logical to enable additional output, default is true.

    %  (c) 2019-2026 MathWorks, Inc.

    arguments
        options.runDiagnostics (1,1) logical = false 
        options.verbose (1,1) logical = true
        options.forceAddPaths (1,1) logical = false
    end

    if isdeployed
        fprintf(2, "Exiting startup, startup should not be called in deployed mode.\n");
        return;
    end
    
    if options.verbose
        fprintf("Running Startup\n");
        fprintf("---------------\n");
    end
    
    % Get the Software/MATLAB directory without using databricksRoot, not yet on path
    thisDir = pwd;
    cleanUp = onCleanup(@() cd(thisDir));
    cd(fullfile(fileparts(mfilename('fullpath')), "app", "functions"));
    addDatabricksPaths(verbose=options.verbose, forceAddPaths=options.forceAddPaths);

    if options.runDiagnostics
        matlab.databricks.databricksDiagnostics(verbose=options.verbose)
    end
end
