function tf = checkCompiler(options)
    % checkCompiler Tests for MATLAB Compiler, warns if not present
    % If Compiler is not present Compiler SDK will also not be present.
    % The check for Compiler SDK will be more serious and will offer to abort the install.

    %  (c) 2023-2024 MathWorks, Inc.
    
    arguments
        options.verbose (1,1) logical = true
    end

    if isempty(ver('compiler'))
        tf = false;
        if options.verbose
            fprintf(2, "Warning:\n");
            fprintf("  MATLAB Compiler is not installed.\n");
            fprintf("  Deployment/compiled workflows will not be supported.\n");
            fprintf("  i.e. MATLAB code cannot be compiled to run on a Databricks cluster.\n");
            fprintf("  Other workflows may be used.\n");
            fprintf("\n");
        end
    else
        tf = true;
    end
end

