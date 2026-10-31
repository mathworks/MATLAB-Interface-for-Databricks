function tf = checkCompilerSDK(options)
    % checkCompilerSDK Tests for MATLAB Compiler SDK & advises of potential limitations
    % A logical true is returned if MATLAB Compiler SDK is installed otherwise false
    % is returned.
    % If a logical true silent value is provided a message regarding the need for
    % MATLAB Compiler SDK will not be displayed.

    %  (c) 2023-2024 MathWorks, Inc.

    arguments
        options.verbose (1,1) logical = true
    end
    
    if isempty(ver('compiler_sdk'))
        tf = false;
        if options.verbose
            fprintf(2, "Warning:\n");
            fprintf("  MATLAB Compiler SDK is not installed.\n");
            fprintf("  Deployed/compiled workflows will not be supported.\n");
            fprintf("  i.e. MATLAB code cannot be compiled to run on a Databricks cluster.\n");
            fprintf("\n");
        end
    else
        tf = true;
    end
end