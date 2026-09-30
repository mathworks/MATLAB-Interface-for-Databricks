function opts = getHTTPOptions(varargin)
    % GETHTTPOPTIONS Return HTTP communication options
    % Modify the <package>-http.json file to override the settings that the package uses
    % for REST based communication. This file must be on the MATLAB path, by default
    % it is found in the /Software/MATLAB/config directory.
    % If a databricks-http.json file is found on the path it will used in preference
    % to a mlflow-http.json file. If no file is found then MATLAB's default
    % matlab.net.http.HTTPOptions will be used.
    %
    % By default, the object sends the following options:
    %
    %            MaxRedirects: 20
    %          ConnectTimeout: 10
    %                UseProxy: 1
    %                ProxyURI: []
    %            Authenticate: 1
    %             Credentials: [1x1 matlab.net.http.Credentials]
    %      UseProgressMonitor: 0
    %             SavePayload: 0
    %         ConvertResponse: 1
    %          DecodeResponse: 1
    %      ProgressMonitorFcn: []
    %     CertificateFilename: "default"
    %        VerifyServerName: 1
    %             DataTimeout: Inf
    %         ResponseTimeout: Inf
    %        KeepAliveTimeout: Inf
    %
    % A ConvertResponse argument can optionally be used to prevent results being
    % automatically converted e.g. from JSON to a struct.  If this argument is used
    % it will override a ConvertResponse setting in JSON file. The argument is case
    % sensitive.
    %
    % Example:
    %
    %    opts = getHTTPOptions('ConvertResponse', false)

    %  (c) 2019-2022 MathWorks, Inc.

    p = inputParser;
    p.CaseSensitive = true;
    % True is the ConvertResponse field normal default value
    p.addParameter('ConvertResponse',true);
    % Parse & Retrieve default & input values
    p.parse(varargin{:});

    % Start with the default options
    opts = matlab.net.http.HTTPOptions;

    % Read the config file favour the databricks case
    if isfile(which('databricks-http.json'))
        % If the databricks config file is on the path favour it over the mlflow one
        overrideOptsPath = which('databricks-http.json');
    else
        overrideOptsPath = which('mlflow-http.json');
    end

    % If there is a http options override file apply it
    % otherwise use the MATLAB defaults
    if isfile(overrideOptsPath)
        overrideOpts = jsondecode(fileread(which(overrideOptsPath)));

        % Override the default values
        optFields = fieldnames(overrideOpts);
        for fCount = 1:numel(optFields)
            opts.(optFields{fCount})=overrideOpts.(optFields{fCount});
        end
    end

    % Arguments override the file settings, but only if set
    if ~any(contains(p.UsingDefaults, 'ConvertResponse'))
        % ConvertResponse needs to be set to false if int64 values need to
        % be extracted from returned JSON
        opts.ConvertResponse = p.Results.ConvertResponse;
    end

end %function
