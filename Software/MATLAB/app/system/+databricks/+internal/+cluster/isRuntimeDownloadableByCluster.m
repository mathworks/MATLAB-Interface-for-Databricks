function tf = isRuntimeDownloadableByCluster(options)
    % isRuntimeDownloadable returns true if accessing the runtime returns 200
    % Unless specified the current release is checked, using the cluster_install.json
    % file for URLs.
    % An alternative release Value in the form "R2023b" can optionally be used.
    % By default the clusterId set via credentials is used, an alternative value
    % can optionally be specified.

    %  Copyright 2023 MathWorks, Inc.

    arguments
        options.runtimeURL string {mustBeTextScalar, mustBeNonzeroLengthText}
        options.clusterId string {mustBeTextScalar, mustBeNonzeroLengthText}
        options.release string {mustBeTextScalar, mustBeNonzeroLengthText}
        options.timeout int32 {mustBeInteger, mustBeFinite, mustBeReal, mustBeNonnegative} = 30
        options.silent (1,1) logical = false
        options.authMethod (1,1) matlab.databricks.AuthMethod
        options.profileName string {mustBeTextScalar, mustBeNonzeroLengthText} = databricks.internal.configurationprofile.ConfigFile.getDefaultProfileName
    end

    if isfield(options, 'runtimeURL')
        runtimeURL = options.runtimeURL;
    else
        args = matlab.utils.addArgs(options, ["release", "silent"]);
        runtimeURL = databricks.internal.mlRuntime.getMATLABRuntimeDownloadURL(args{:});
    end

    if isempty(runtimeURL) || strlength(runtimeURL) == 0
        if ~options.silent
            fprintf("A MATLAB runtime URL could not be determined\n");
        end
        tf = false;
        % Return at this point not URL to test on the cluster
        return;
    end
  
    if ~options.silent
        fprintf("Checking MATLAB runtime download connectivity:\n  %s\n", runtimeURL);
    end

    pyStr = sprintf('import urllib; print(urllib.request.urlopen("%s").getcode())', runtimeURL);
    
    % fprintf("Executing: %s\n", pyStr);
    args = matlab.utils.addArgs(options, ["authMethod", "profileName", "clusterId", "timeout"]);
    httpCode = databricks.internal.commandexecution.executePythonCommand(pyStr, args{:});

    % 200 is the return value from getcode in: 'import urllib; print(urllib.request.urlopen("%s").getcode())'
    if strcmp(strip(httpCode), "200")
        if ~options.silent
            fprintf("MATLAB Runtime is downloadable by the cluster\n");
        end
        tf = true;
    else
        tf = false;
        if ~options.silent
            fprintf("MATLAB Runtime is not downloadable by the cluster\n");
        end
    end
end
