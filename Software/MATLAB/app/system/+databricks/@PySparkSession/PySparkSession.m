classdef PySparkSession < matlab.pyspark.sql.session.SparkSession & matlab.mixin.CustomDisplay
    % PYSPARKSESSION Class to create a PySpark session

    % Copyright 2024-2026 The MathWorks, Inc.

    properties (SetAccess = protected)
        % Id of the cluster the session corresponds to
        ClusterId string
        % Spark session object
        % sparkSession defined in matlab.pyspark.sql.session.SparkSession
        % Databricks Runtime Version
        RuntimeVersion string
        % Is the session using serverless compute
        Serverless (1,1) logical = false
    end

    methods
        function obj = PySparkSession(options)
            % PYSPARKSESSION Constructor for PySparkSession class
            %
            % This constructor is designed to be called from getDatabricksSession()
            % or a similar wrapper function.
            %
            % Named arguments:
            %              platform : While Databricks is the primary target platform
            %                         for this class it may support other platforms
            %                         in the future, like plain Apache Spark.
            %                         Currently "databricks" is the default and
            %                         only supported value.
            %
            %                  mode : Serverless mode is supported. Set the optional
            %                         named argument mode to "serverless" or "classic"
            %                         (default).
            %
            %               cluster : A cluster can be given using the named argument
            %                         cluster of type databricks.Cluster object.
            %                         The cluster must be in a running state. If using
            %                         serverless mode a cluster argument should not
            %                         be given.
            %
            %          dependencies : Can be used to provided a list of Python packages
            %                         that should be installed in the Python environment
            %                         before creating the Spark session. This is useful
            %                         when additional libraries% are required.
            %
            %            authMethod : Used to specify a specific authentication method.
            %
            %           profileName : Used to specify a specific profile.
            %
            %     skipVersionChecks : Set to true to skip version checks for:
            %                           * Client Python version support.
            %                           * Client Python serverless support.
            %                           * MATLAB Python version support.
            %                           * Client Python version matches the cluster
            %                             Python version.
            %                           * Databricks Connect service disabled.
            %                         The use of this argument is not recommended
            %                         and is likely to result in errors.
            %                         However, it may sometimes be useful for testing
            %                         purposes. Default: false.
            %
            % clusterRuntimeVersion : Required if using Databricks, e.g. 16.4
            %
            %               verbose : Flag is used to control the verbosity of the output.
            %                         Default: true.
            %
            %       forceNewSession : When set to true this will create a new Spark
            %                         Session. If set to false or omitted, it will
            %                         reuse an existing Spark Session, if available.
            %                         This is especially useful in development workflows,
            %                         where a new version of an artifact is uploaded
            %                         with the addArtifact method. If an old session
            %                         is reused, the artifact cannot be reused.
            %                         Default: false.
            %
            % The timeout when creating a session is 5 minutes.
            %
            % If the HTTP_PROXY or HTTPS_PROXY environment variables are
            % set in the MATLAB process context but the MATLAB proxy is
            % setting/preference is not set a warning is produced as this
            % is possible source of error for other interfaces. If the
            % setting/preference is set a the HTTP(S)_PROXY variable is
            % configured in the Python environment context used by the
            % Databricks Connect library.
            %
            % This class only supports Databricks Connect v2, v1 is not supported.
            %
            % See also Databricks session creation code:
            %   site-packages\databricks\connect\session.py

            arguments
                options.platform string {mustBeTextScalar, mustBeNonzeroLengthText, mustBeMember(options.platform,["databricks"])} = "databricks"
                options.mode string {mustBeTextScalar, mustBeNonzeroLengthText, mustBeMember(options.mode,["classic","serverless"])} = "classic"
                options.cluster (1,1) databricks.Cluster
                options.dependencies string {mustBeNonzeroLengthText}
                options.authMethod (1,1) matlab.databricks.AuthMethod
                options.profileName string {mustBeTextScalar, mustBeNonzeroLengthText}
                options.clusterRuntimeVersion string {mustBeTextScalar, mustBeNonzeroLengthText}
                options.skipVersionChecks (1,1) logical = false
                options.verbose (1,1) logical = true
                options.forceNewSession (1,1) logical = false
            end

            % Validate options structure for getDatabricksSession, sanity checking
            if options.platform == "databricks"
                % Not clear that this would apply in the apache case
                DBCClientVersion = databricks.internal.databricksConnect.getDBCClientVersion();
                if ~options.skipVersionChecks
                    checkArguments(options.mode, DBCClientVersion, options);
                end
            end

            % Checks and applies the http(s) proxy configuration for Databricks Connect
            % Runs before the DatabricksSession is created
            proxyTf = setHTTPProxy();

            if options.platform == "databricks"
                DatabricksSession = py.databricks.connect.DatabricksSession();
                builder = DatabricksSession.builder;

                args = matlab.utils.addArgs(options, ["authMethod", "profileName"]);
                kwargsMap = databricks.internal.sdk.core.Config.getAuthCfgMap(args{:});

                if kwargsMap("auth_type") == "external-browser"
                    if proxyTf
                        fprintf(2, "HTTP(S) Proxy support is not currently supported for external-browser/OauthU2M\n");
                    end
                else
                    % timeout does not seem to apply for external-browser/OauthU2M
                    kwargsMap("http_timeout_seconds") = int32(30);
                end

                if options.mode == "serverless"
                    obj.Serverless = true;
                    kwargsMap("serverless_compute_id") = "auto";
                    % Token, host, etc. has already been populated. Unset
                    % `profile` here to avoid conflict between serverless
                    % and classic.
                    kwargsMap("profile") = "";
                    % In serverless check the client runtime version
                    obj.RuntimeVersion = DBCClientVersion;
                else
                    obj.RuntimeVersion = options.clusterRuntimeVersion; % Must be set for databricks
                    obj.ClusterId = options.cluster.cluster_id;
                    kwargsMap("cluster_id") = obj.ClusterId;
                end

                sdkConfig = databricks.internal.sdk.core.Config(kwargsMap);

                builder = builder.sdkConfig(sdkConfig.toPy);
                builder = builder.userAgent(databricks.Object.getUserAgent());

                if isfield(options, "dependencies") && ge(matlab.utils.SemVer(obj.RuntimeVersion), "16.4")
                    builder = builder.withEnvironment(DatabricksSession.DatabricksEnv().withDependencies(options.dependencies));
                end

                if ge(matlab.utils.SemVer(obj.RuntimeVersion), "14.3")                    
                    if databricks.internal.isOnDatabricks()
                        % Don't do validation when running on Databricks
                        builder = builder.validateSession(false);
                        if ~strcmpi(getenv('SPARK_CONNECT_MODE_ENABLED'), '1')
                            if options.verbose
                                fprintf(2, "MATLAB is running on a Databricks cluster, " + ...
                                    "and so the SPARK_CONNECT_MODE_ENABLED environment variable must be set to '1'.\n" + ...
                                    "Without this, full Databricks Connect functionality is not supported.\n");
                            end
                        end
                        
                    else
                        builder = builder.validateSession(true);
                    end
                end
                
                if options.forceNewSession
                    obj.sparkSession = builder.create();
                else
                    obj.sparkSession = builder.getOrCreate();
                end

                if options.mode == "serverless"
                    obj.ClusterId = obj.toPy.conf.get('spark.databricks.clusterUsageTags.clusterId');
                end

            else
                % platform is "apachespark"
                checkSparkRemoteEnv();
                DatabricksSession = py.databricks.connect.DatabricksSession();
                obj.sparkSession = DatabricksSession.builder.userAgent(databricks.Object.getUserAgent()).getOrCreate();
            end
        end
    end

    methods(Access = protected)
        function groups = getPropertyGroups(obj)
            if isscalar(obj)
                groups = getPropertyGroups@matlab.mixin.CustomDisplay(obj);
                groups.PropertyList.Serverless = string(groups.PropertyList.Serverless);
            else
                % Nonscalar case: call superclass method
                groups = getPropertyGroups@matlab.mixin.CustomDisplay(obj);
            end
        end %function
    end %methods
end


function [tf, proxyURI]= setHTTPProxy()
    % SETHTTPPROXY Sets HTTP proxy environment variables for Python
    [tf, proxyURI] = matlab.databricks.detectProxy();
    if tf
        fprintf("Configuring HTTP(S) proxy environment variable.\n");
        if lower(proxyURI.Scheme) == "http"
            varName = "HTTP_PROXY";
        elseif lower(proxyURI.Scheme) == "https"
            varName = "HTTPS_PROXY";
        else
            fprintf(2, "Unsupported proxy scheme: %s\nSkipping HTTP(S) proxy configuration.\n", proxyURI.Scheme);
            return;
        end

        setPyEnvVar(varName, proxyURI.EncodedURI);
        varValue = getPyEnvVar(varName);
        if isempty(varValue) || ~strcmpi(proxyURI.EncodedURI, varValue)
            warning('DATABRICKS:PYSPARKSESSION:SETHTTPPROXY', ...
                "Failed to set HTTP proxy environment variable. Expected: %s, got: %s", proxyURI.EncodedURI, varValue);
        end
    else
        varValue = getPyEnvVar("HTTP_PROXY");
        if ~isempty(varValue) && strlength(varValue) > 0
            fprintf(2, "The HTTP_PROXY environment variable: %s is defined in the Python environment but not in the MATLAB/system settings.", varValue);
        end
        varValue = getPyEnvVar("HTTPS_PROXY");
        if ~isempty(varValue) && strlength(varValue) > 0
            fprintf(2, "The HTTPS_PROXY environment variable: %s is defined in the Python environment but not in the MATLAB/system settings.", varValue);
        end
    end
end


function setPyEnvVar(varName, varValue)
    % SETPYENVVAR Sets a Python environment variable
    arguments (Input)
        varName string {mustBeTextScalar, mustBeNonzeroLengthText}
        varValue string {mustBeTextScalar, mustBeNonzeroLengthText}
    end
    pyrun(["import os", sprintf("os.environ['%s'] = '%s'", varName, varValue)]);
end


function value = getPyEnvVar(varName)
    % GETPYENVVAR Gets a Python environment variable
    arguments (Input)
        varName string {mustBeTextScalar, mustBeNonzeroLengthText}
    end
    arguments (Output)
        value string
    end

    resultPy = pyrun(["import os", sprintf("val = os.environ.get('%s')", varName)], "val");
    if isa(resultPy, "py.NoneType")
        value = string.empty;
    elseif isa(resultPy, "py.str")
        value = string(resultPy);
    elseif isa(resultPy, "string")
        value = resultPy;
    else
        error("DATABERICKS:PYSPARKSESSION:getPyEnvVar", "Unexpected environment variable class type: %s", class(resultPy));
    end
end


function checkPlatform(platform)
    % CHECKPLATFORM Validates that the platform argument is either "databricks" or "apachespark"
    arguments
        platform string {mustBeTextScalar, mustBeNonzeroLengthText}
    end

    if platform ~= "databricks" && platform ~= "apachespark"
        error("DATABRICKS:PYSPARKSESSION:CHECKPLATFORM", ...
            "Platform argument must be either 'databricks' or 'apachespark', not: %s", platform);
    end
end


function checkArguments(mode, DBCClientVersion, options)
    % CHECKARGUMENTS Validates options structure for getDatabricksSession
    arguments
        mode string {mustBeTextScalar, mustBeNonzeroLengthText}
        DBCClientVersion string {mustBeTextScalar, mustBeNonzeroLengthText}
        options struct
    end

    errBase = "DATABRICKS:PYSPARKSESSION:CHECKARGUMENTS";

    if mode ~= "serverless" && mode ~= "classic"
        error(errBase+":INVALIDMODE", 'Mode argument must be either "serverless" or "classic", not: %s', mode);
    end

    % Validate that the platform argument
    checkPlatform(options.platform);

    if mode == "classic" && ~isfield(options, "cluster")
        error(errBase+":NOCLUSTER", "In classic mode a named cluster argument must be provided.");
    end
    if options.platform == "databricks" && mode == "classic" && ~isfield(options, "clusterRuntimeVersion")
        error(errBase+":NOCLUSTERRUNTIME", "In classic mode a cluster runtime version must be provided, e.g. 16.4.");
    end
    if mode == "serverless" && isfield(options, "cluster")
        fprintf(2,"In serverless mode the provided cluster argument will be ignored.\n");
    end
    if mode == "serverless" && lower(options.platform) ~= "databricks"
        error(errBase+":SRVLESSDBX", "Serverless mode is only available on Databricks.");
    end
    if options.platform ~= "databricks" && isfield(options, "dependencies")
        fprintf(2,"Dependencies will be ignored on non Databricks platforms.\n");
    end
    if ~options.skipVersionChecks && options.platform == "databricks" && mode == "classic" && lt(matlab.utils.SemVer(options.clusterRuntimeVersion), "16.4") && isfield(options, "dependencies")
        error(errBase+":CLASSICDEPS", ...
            "Dependencies are only supported with Databricks Connect >= 16.4.\n" + ...
            "To skip this check use the argument: skipVersionChecks=true");
    end
    % Checks the client version <= 16.4 assumes this will create an
    % equivalent or greater server runtime version
    if ~options.skipVersionChecks && options.platform == "databricks" && mode == "serverless" && lt(matlab.utils.SemVer(DBCClientVersion), "16.4") && isfield(options, "dependencies")
        error(errBase+":SERVERLESSDEPS", ...
            "Dependencies are only supported with Databricks Connect >= 16.4.\n" + ...
            "To skip this check use the argument: skipVersionChecks=true");
    end
end


function checkSparkRemoteEnv()
    % CHECKSPARKREMOTEENV Validates SPARK_REMOTE environment variable for Databricks Connect

    errBase = "DATABRICKS:GETDATABRICKSSESSION:CHECKSPARKREMOTEENV";
    envVal = getenv("SPARK_REMOTE");
    if isempty(envVal) || strlength(envVal) == 0
        error(errBase+":NOVAR", "SPARK_REMOTE environment variable not set.\n" +...
            "See: %s", matlab.utils.URL2Link("https://docs.databricks.com/aws/en/dev-tools/databricks-connect/advanced"));
    else
        if ~startsWith(lower(envVal), "sc://")
            error(errBase+":INVALIDFORMAT", "SPARK_REMOTE environment variable expected to start with 'sc://', found: %s\n" +...
                "See: %s", envVal, "See: %s", matlab.utils.URL2Link("https://docs.databricks.com/aws/en/dev-tools/databricks-connect/advanced"));
        end
    end
end

