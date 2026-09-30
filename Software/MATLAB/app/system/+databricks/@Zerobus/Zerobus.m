classdef Zerobus < databricks.Object
    % Zerobus REST API client
    % Only JSON payloads are currently supported.
    %
    % Required Named Arguments:
    %        catalog - Databricks catalog name
    %         schema - Databricks schema name
    %          table - Databricks table name
    %       clientId - Service principal OAuth client ID
    %   clientSecret - Service principal OAuth client secret
    %
    % Optional Named Arguments:
    %       endpoint - Override for the ingest endpoint URL
    %    profileName - Name of the Databricks configuration profile
    %        verbose - Display verbose output (default: true)
    %
    % Example:
    %   % First create a table created in this case using SQL in a Notebook
    %   %sql
    %   CREATE TABLE main.default.air_quality (device_name STRING, temp INT, humidity LONG);
    %   
    %   % Create a service principal and enable permissions for the table.
    %   % See: databricks Documentation linked below.
    %
    %   % Create a Zerobus object that will authenticate as the service principal.
    %   % All of the named arguments shown are required.
    %   z = databricks.Zerobus(catalog="main", schema="default", table="air_quality", clientId="a<REDACTED>1", clientSecret="d<REDACTED>5")
    %
    %   % Create a JSON payload array of 2 sets values, corresponding to 2 table rows
    %   payload = ['[{ "device_name": "device_num_1", "temp": 28, "humidity": 60 },', newline ...
    %               '{ "device_name": "device_num_2", "temp": 25, "humidity": 55 }]'];
    %
    %   % Insert the data into the table
    %   [result, errorResponse] = z.insert(payload);
    %
    % See also:
    %   https://www.databricks.com/product/data-engineering/lakeflow-connect/zerobus-ingest
    %   https://docs.databricks.com/aws/en/ingestion/zerobus-ingest?language=REST%C2%A0API

    % Copyright MathWorks 2026

    properties
        endpoint string
        catalog string
        schema string
        table string
    end

    properties (Hidden)
        HTTPOptions matlab.net.http.HTTPOptions
        accessToken string
        accessTokenExpiryTime datetime
        clientId string
        clientSecret string
    end

    methods
        % Constructor
        function obj = Zerobus(options)
            arguments (Input)
                options.catalog string {mustBeTextScalar, mustBeNonzeroLengthText}
                options.schema string {mustBeTextScalar, mustBeNonzeroLengthText}
                options.table string {mustBeTextScalar, mustBeNonzeroLengthText}
                options.endpoint string {mustBeTextScalar, mustBeNonzeroLengthText}
                options.profileName string {mustBeTextScalar, mustBeNonzeroLengthText} = databricks.internal.configurationprofile.ConfigFile.getDefaultProfileName
                options.clientId string {mustBeTextScalar, mustBeNonzeroLengthText}
                options.clientSecret string {mustBeTextScalar, mustBeNonzeroLengthText}
                options.verbose (1,1) logical = true
            end

            requireNamedArg(obj, options, "catalog");
            requireNamedArg(obj, options, "schema");
            requireNamedArg(obj, options, "table");
            requireNamedArg(obj, options, "clientId");
            requireNamedArg(obj, options, "clientSecret");

            obj.HTTPOptions = databricks.internal.getHTTPOptions(convertResponse=false);
            obj.getAuth(profileName=options.profileName);

            if isfield(options, "endpoint")
                obj.endpoint = options.endpoint;
            else
                if isempty(obj.Org_id) || strlength(obj.Org_id) == 0
                    orgId = databricks.internal.configurationprofile.ConfigFile.getProfileField("org_id", profileName=options.profileName);
                    if isempty(orgId) || strlength(orgId) == 0
                        error("DATABRICKS:ZEROBUS:NOORGID",...
                            "Could not determine an org_id, cannot create a Zerobus ingestion URL.");
                    else
                        obj.Org_id = orgId;
                    end
                else
                    orgId = obj.Org_id;
                end

                uc = databricks.UnityCatalog(profileName=options.profileName);
                metastoreInfo = uc.metastoreSummary();
                if isa(metastoreInfo, "databricks.datastructures.unitycatalog.ErrorResponse")
                    disp(metastoreInfo);
                    error("DATABRICKS:ZEROBUS:METASTOREINFO",...
                          "Could not get metastore summary from Unity Catalog, cannot create a Zerobus ingestion URL.");
                end
                if isprop(metastoreInfo, 'region') && ~isempty(metastoreInfo.region) && strlength(metastoreInfo.region) > 0
                    region = metastoreInfo.region;
                else
                    error("DATABRICKS:ZEROBUS:NOREGION",...
                          "Could not determine a region from the Unity Catalog metastore summary, cannot create a Zerobus ingestion URL.");
                end

                if matlab.databricks.vendor.getVendor == matlab.databricks.vendor.Vendor.AZURE
                    obj.endpoint = sprintf("https://%s.zerobus.%s.azuredatabricks.net", orgId, region);
                else
                    obj.endpoint = sprintf("https://%s.zerobus.%s.cloud.databricks.com", orgId, region);
                end
            end

            [accessToken, expiryTime, errorResponse] = obj.getAccessToken(options.catalog, options.schema, options.table, options.clientId, options.clientSecret, verbose=options.verbose);
            if isempty(accessToken) || isempty(expiryTime)
                disp(errorResponse);
                error('Authentication failed, cannot create Zerobus object.');
            else
                obj.accessToken = accessToken;
                obj.accessTokenExpiryTime = expiryTime;
            end
        end
    end

    methods (Hidden)
        function requireNamedArg(obj, options, name)
            arguments (Input)
                obj
                options struct
                name string {mustBeTextScalar, mustBeNonzeroLengthText}
            end
            if ~isfield(options, name)
                errStr = "DATABRICKS:ZEROBUS:NO" + upper(name);
                error(errStr,"A named argument must be provided for: %s", name);
            else
                obj.(name) = options.(name);
            end
        end
    

        function [accessToken, expiryTime, errorResponse] = getAccessToken(obj, catalog, schema, table, clientId, clientSecret, options)
            arguments (Input)
                obj
                catalog string {mustBeTextScalar, mustBeNonzeroLengthText}
                schema string {mustBeTextScalar, mustBeNonzeroLengthText}
                table string {mustBeTextScalar, mustBeNonzeroLengthText}
                clientId string {mustBeTextScalar, mustBeNonzeroLengthText}
                clientSecret string {mustBeTextScalar, mustBeNonzeroLengthText}
                options.forceUpdate (1,1) logical = false 
                options.verbose (1,1) logical = true
            end
            arguments (Output)
                accessToken string
                expiryTime datetime
                errorResponse databricks.datastructures.ErrorResponse
            end

            if ~options.forceUpdate && ...
               ~isempty(obj.accessToken) && strlength(obj.accessToken) > 0 && ...
               ~isempty(obj.accessTokenExpiryTime) && datetime("now") < obj.accessTokenExpiryTime - minutes(1)
                accessToken = obj.accessToken;
                expiryTime = obj.accessTokenExpiryTime;
                if options.verbose
                    fprintf("Using existing access token.\n");
                    errorResponse = databricks.datastructures.ErrorResponse.empty;
                    return;
                else
                    if options.verbose
                        if isempty(obj.accessTokenExpiryTime)
                            fprintf("Getting access token.\n");
                        else
                            if datetime("now") < obj.accessTokenExpiryTime - minutes(1)
                                fprintf("Using existing access token.\n");
                            else
                                fprintf("Access token expired, refreshing token.\n");
                            end
                        end
                    end
                end
            end

            str = ['[{', newline, ...
                  '   "type": "unity_catalog_privileges",', newline, ...
                  '   "privileges": ["USE CATALOG"],', newline, ...
                  '   "object_type": "CATALOG",', newline, ...
                  '   "object_full_path": "$CATALOG"', newline, ...
                  '},', newline, ...
                  '{', newline, ...
                  '    "type": "unity_catalog_privileges",', newline ...
                  '    "privileges": ["USE SCHEMA"],', newline ...
                  '    "object_type": "SCHEMA",', newline ...
                  '    "object_full_path": "$CATALOG.$SCHEMA"', newline ...
                  '},', newline ...
                  '{', newline ...
                  '    "type": "unity_catalog_privileges",', newline ...
                  '    "privileges": ["SELECT", "MODIFY"],', newline ...
                  '    "object_type": "TABLE",', newline ...
                  '    "object_full_path": "$CATALOG.$SCHEMA.$TABLE"', newline ...
                  '}]'];
            str = string(str);
            str = strrep(str, "$CATALOG", catalog);
            str = strrep(str, "$SCHEMA", schema);
            str = strrep(str, "$TABLE", table);
            
            URI = matlab.net.URI(obj.Host);
            URI.Path = {'oidc', 'v1', 'token'};
            request = matlab.net.http.RequestMessage;
            request.Method = matlab.net.http.RequestMethod("POST");
            request.Header(end+1) = matlab.net.http.field.ContentTypeField('application/x-www-form-urlencoded');
            request.Header(end+1) = matlab.net.http.HeaderField("User-Agent", obj.UserAgent);
            authValB64 = matlab.net.base64encode(clientId + ":" + clientSecret);
            request.Header(end+1) = matlab.net.http.HeaderField("Authorization", "Basic " + authValB64);

            % Assign the body data using params 
            uriq = matlab.net.URI(obj.Host);
            uriq.Query(end+1) = matlab.net.QueryParameter("grant_type","client_credentials");
            uriq.Query(end+1) = matlab.net.QueryParameter("scope", "all-apis");
            uriq.Query(end+1) = matlab.net.QueryParameter("resource", sprintf("api://databricks/workspaces/%s/zerobusDirectWriteApi", obj.Org_id));
            uriq.Query(end+1) = matlab.net.QueryParameter("authorization_details", str); % This will & must be urlencoded
            request.Body = matlab.net.http.MessageBody;
            request.Body.Payload = uriq.EncodedQuery;

            [response, request, history] = request.send(URI, obj.HTTPOptions); %#ok<ASGLU> 

            if response.StatusCode == matlab.net.http.StatusCode.OK
                [accessToken, expiryTime] = extractToken(response.Body.Data);
                errorResponse = databricks.datastructures.ErrorResponse.empty;
            else
                accessToken = string.empty;
                expiryTime = datetime.empty;
                errorResponse = databricks.datastructures.ErrorResponse().fromJSON(response.Body.Data);
            end
        end
    end
end


function [accessToken, expiryTime] = extractToken(data)
    arguments (Input)
        data string {mustBeTextScalar, mustBeNonzeroLengthText}
    end
    arguments (Output)
        accessToken string
        expiryTime datetime
    end

    jData = jsondecode(data);
    assert(isfield(jData, "access_token"));
    assert(isa(jData.access_token, "char"));
    assert(strlength(jData.access_token) > 0);
    accessToken = jData.access_token;
    
    assert(isfield(jData, "token_type"));
    assert(isa(jData.token_type, "char"));
    assert(strlength(jData.token_type) > 0);
    assert(strcmpi(jData.token_type, "bearer"));

    assert(isfield(jData, "expires_in"));
    assert(isa(jData.expires_in, "double"));
    assert(gt(jData.expires_in, 0));
    expiryTime = datetime("now") + seconds(jData.expires_in);
end