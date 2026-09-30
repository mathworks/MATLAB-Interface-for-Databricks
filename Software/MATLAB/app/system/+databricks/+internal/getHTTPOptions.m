function opts = getHTTPOptions(varargin)
    % GETHTTPOPTIONS Return HTTP communication options
    % Modify the <package>-http.json file to override the settings that the package uses
    % for REST based communication. This file must be on the MATLAB path, by default
    % it is found in the /Software/MATLAB/config directory.
    % If a databricks-http.json file is found on the path it will used.
    % If no file is found then MATLAB's default matlab.net.http.HTTPOptions
    % will be used.
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
    %    opts = databricks.internal.getHTTPOptions(convertResponse=false);

    %  (c) 2026 MathWorks, Inc.
    opts = databricks.internal.getHTTPOptionsImpl(varargin{:});
end