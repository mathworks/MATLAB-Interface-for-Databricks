function runtimeURL = getMATLABRuntimeDownloadURL(options)
    % getMATLABRuntimeDownloadURL Get a download URL for the MATLAB runtime
    % The runtime is returned as a string.
    % If it cannot be determined and empty string is returned.
    % Only the Linux URL is returned.
    % If a specific MATLAB release is provided and a value cannot be found in the
    % cluster_install.json file an empty string will be returned.
    % If a release is not specified the current release will be used. If it cannot
    % be found in the cluster_install.json file a dynamically determined value will
    % be used. If this is not possible an empty string is returned.
    %
    % Optional arguments:
    %           release: A string of the form: R2023b
    %                    The default is the currently running release
    %
    %            silent: A logical to reduce output
    %                    The default value is false
    %
    %   useSettingsFile: A logical to use the cluster_install.json if possible
    %                    The default value is true
    %                    Using false can useful in certain debug scenarios
    %                    to get a more recent update
    %
    % See also: https://www.mathworks.com/products/compiler/matlab-runtime.html

    %  Copyright 2023 MathWorks, Inc.

    arguments
        options.release string {mustBeTextScalar, mustBeNonzeroLengthText}
        options.silent (1,1) logical = false
        options.useSettingsFile (1,1) logical = true
    end

    if isMATLABReleaseOlderThan('R2022b')
        error('MATLAB release 2022b or later is required');
    end

    cfgFile = "cluster_install.json";

    % Shorten name
    silent = options.silent;

    % Only use a dynamic version
    if ~options.useSettingsFile
        try
            runtimeURL = string(compiler.internal.runtime.utils.getMCRInstallerDownloadURL());
            runtimeURL = strrep(runtimeURL,computer('arch'),'glnxa64');
        catch ME
            if ~silent
                fprintf("Could not determine runtime URL dynamically\nMessage: %s\n",ME.message);
            end
            runtimeURL = string.empty;
        end
        return;
    end

    % Get the release of the running MATLAB
    runningRelease = matlabRelease().Release;

    % A specific MATLAB release may be provided
    if isfield(options, 'release')
        release = options.release;
    else
        release = runningRelease;
    end

    try
        runtimeURL = string.empty;
        jsonFile = databricksRoot('config', cfgFile);
        if ~isfile(jsonFile)
            if ~silent
                fprintf("Could not determine runtime URL, cluster_install file not found: %s\n", jsonFile);
            end
        else
            versions = jsondecode(fileread(jsonFile));
            if ~isfield(versions, 'releases')
                if ~silent; fprintf("Could not determine runtime URL, versions.releases field not found\n"); end
            else
                if ~isfield(versions.releases, release)
                    if ~silent; fprintf("Could not determine runtime URL, versions.releases.<release> field not found for: %s\n", release); end
                else
                    if ~isfield(versions.releases.(release), 'download')
                        if ~silent; fprintf("Could not determine runtime URL, versions.releases.<release>.download field not found\n"); end
                    else
                        if (ischar(versions.releases.(release).download) || isStringScalar(versions.releases.(release).download)) && strlength(versions.releases.(release).download) > 0
                            runtimeURL = string(versions.releases.(release).download);
                        else
                            if ~silent; fprintf("Could not determine runtime URL, versions.releases.<release>.download not of correct type\n"); end
                        end
                    end
                end
            end
        end
    catch ME
        if ~silent; fprintf("Could not determine runtime URL from: %s\nMessage: %s\n", cfgFile, ME.message); end
        runtimeURL = string.empty;
    end

    if isempty(runtimeURL) && strcmpi(release, runningRelease)        
        try
            if ~silent
                fprintf("Could not determine the MATLAB runtime URL from: %s\n", jsonFile);
                fprintf("Getting runtime URL dynamically for release: %s\n", runningRelease);
            end
            runtimeURL = string(compiler.internal.runtime.utils.getMCRInstallerDownloadURL());
            % Ensure URL is for glnxa64 i.e. we only want the linux one
            if ismac || ispc
                runtimeURL = strrep(runtimeURL, ['/',computer('arch'),'/'], '/glnxa64/');
            end
            if ~silent
                fprintf("Runtime URL: %s\n", runtimeURL);
            end
        catch ME
            if ~silent
                fprintf("Could not determine runtime URL dynamically\nMessage: %s\n", ME.message);
            end
            runtimeURL = string.empty;
        end
    end
end