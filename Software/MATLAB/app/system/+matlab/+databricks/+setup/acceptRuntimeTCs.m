function tf = acceptRuntimeTCs(options)
    % ACCEPTRUNTIMETCS Accepts or not the MATLAB runtime license terms
    % true is returned if accepted otherwise false.
    % The agreeToLicense= value is updated to yes or no in the init script.
    % The default script path is Software/MATLAB/script/runtime_install.sh
    % The init script must be uploaded to Databricks for this to take effect.

    % Copyright 2024-2026 The MathWorks, Inc.

    arguments (Input)
        options.acceptRuntimeLicense (1,1) logical
        options.initscript string {mustBeTextScalar, mustBeNonzeroLengthText} = databricksRoot("script", "runtime_install.sh")
        options.verbose (1,1) logical = true
    end
    arguments (Output)
        tf (1,1) logical
    end

    runtimeLink = matlab.utils.URL2Link("https://www.mathworks.com/products/compiler/matlab-runtime.html");

    if isfield(options, "acceptRuntimeLicense")
        tf = options.acceptRuntimeLicense;
        if options.verbose
            if options.acceptRuntimeLicense
                fprintf("\nMATLAB runtime license terms accepted.\n");
            else
                fprintf("\nMATLAB runtime license has not been accepted, it should not be used.\n");
            end
            fprintf("The MATLAB runtime license can be found in runtime .zip files.\n");
            fprintf("Downloaded from: %s\n", runtimeLink);
        end
    else
        fprintf("\n");
        fprintf("The MATLAB runtime license can be found in runtime .zip files.\n");
        fprintf("Downloaded from: %s\n", runtimeLink);
        reply = strip(input('Agree to the MATLAB runtime license(s)? Y/N [Y]: ','s'));
        if strcmpi(reply,'y') || strlength(reply) == 0
            tf = true;
        else
            fprintf(2, "MATLAB runtime license has not been accepted, it should not be used.\n");
            tf = false;
        end
    end
end
