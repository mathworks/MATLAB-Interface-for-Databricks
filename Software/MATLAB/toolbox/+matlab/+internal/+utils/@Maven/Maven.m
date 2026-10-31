classdef Maven
    % MAVEN Class to support working with Maven
    % Supports 3 value numeric versions only e.g.: 1.2.3
    % The assumed default minimum version is 3.6.1
    % A non default version can be provided.
    % If a version cannot be determined 0.0.0 is assumed.

    % Copyright 2022-2026 The MathWorks, Inc.
    % TODO Add support for label strings e.g. 1.2.3-beta etc see
    % matlab.utils.SemVer

    properties
        version (1,1) matlab.internal.utils.SemVer
        minimumVersion = "3.6.1"
    end

    methods
        function obj = Maven(varargin)
            % Maven Construct an instance of this class
            obj.version = matlab.internal.utils.Maven.getVersion();
        end
    end

    methods(Static)
        function tf = isProxySet(options)
            % isProxySet Returns true if a proxy is set in a Maven settings file
            % A non default repository can be optionally provided.

            arguments
                options.repo (1,1) string = ""
            end

            if strlength(options.repo) == 0
                settingsFile = fullfile(char(java.lang.System.getProperty('user.home')), '.m2', 'repository', 'settings.xml');
            else
                if isfolder(options.repo)
                    settingsFile = fullfile(options.repo, 'repository', 'settings.xml');
                else
                    error('MATLAB:UTILS:MAVEN', 'Repository directory not found: %s', options.repo);
                end
            end

            tf = false;
            if isfile(settingsFile)
                s = readstruct(settingsFile,'FileType','xml');
                if isfield(s, 'proxies')
                    if isfield(s.proxies, 'proxy')
                        if isfield(s.proxies.proxy(1), 'host')
                            if ischar(s.proxies.proxy(1).host) || isStringScalar(s.proxies.proxy(1).host)
                                if strlength(s.proxies.proxy(1).host) > 0
                                    tf = true;
                                end
                            end
                        end
                    end
                end
            end
        end


        function proxyWarning(options)
            % proxyWarning displays a warning if a proxy is likely to be needed but is not set
            % A non default repository can be optionally provided.

            arguments
                options.repo (1,1) string = ""
            end

            if isDatabricksEnvironment
                % Check if MATLAB has a proxy set
                [detectedTf, proxyUri] = matlab.internal.databricks.detectProxy();
                % Check if Maven has a proxy set
                if strlength(options.repo) > 0
                    hostTf = matlab.internal.utils.Maven.isProxySet('repo', options.repo);
                else
                    hostTf = matlab.internal.utils.Maven.isProxySet();
                end
                if ~hostTf && detectedTf
                    mvnProxyHelp = "https://maven.apache.org/guides/mini/guide-proxies.html";
                    warning('MATLAB:UTILS:MAVEN',...
                        "A HTTP proxy has been detected: %s\nEnsure Maven has been configured to use the proxy if necessary: %s",...
                        proxyUri.EncodedURI, mvnProxyHelp);
                end
            else
                warning('MATLAB:UTILS:MAVEN', 'Proxy detection requires the MATLAB interface for Databricks');
            end
        end


        function tf = isInstalled()
            % isInstalled Returns true if Maven is installed and on the path otherwise false
            % Does not check the version
            [status, cmdout] = system('mvn --version');

            if status == 0
                tf = true;
            else
                if isunix
                    if contains(cmdout, 'command not found')
                        % Expected Unix not found on path error
                        % Tested on macOS and Linux
                        tf = false;
                    else
                        error('MATLAB:UTILS:MAVEN', 'Error checking for Maven using: mvn --version');
                    end
                elseif ispc
                    if contains(cmdout, 'is not recognized as an internal or external command')
                        % Expected Windows not found on path error
                        tf = false;
                    else
                        error('MATLAB:UTILS:MAVEN', 'Error checking for Maven using: mvn --version');
                    end
                else
                    error('MATLAB:UTILS:MAVEN', 'Unsupported Operating System');
                end
            end
        end


        function tf = checkInstallPlugin()
            % checkInstallPlugin Check if the Install plugin is available triggering its installation if possible
            if matlab.internal.utils.Maven.isInstalled()
                [status, cmdout] = system('mvn -B -Dplugin=org.apache.maven.plugins:maven-install-plugin help:describe');
                if status == 0
                    tf = true;
                else
                    warning('MATLAB:UTILS:MAVEN','Problem checking Maven install plugin:\n%s', cmdout);
                    tf = false;
                end
            else
                tf = false;
            end
        end


        function tf = installMPSJavaClient(options)
            % installMPSJavaClient

            arguments
                options.version string {mustBeNonzeroLengthText, mustBeTextScalar} = "R2023b"
                options.echo (1,1) logical = false
            end

            groupId = "com.mathworks.prodserver";
            artifactId = "artifactId";
            packaging = "jar";
            installPlugin = "org.apache.maven.plugins:maven-install-plugin";

            if ~matlab.internal.utils.Maven.checkInstallPlugin
                warning('MATLAB:UTILS:MAVEN', 'Error checking Maven install plugin');
                tf = false;
                return;
            end

            cmdStr = sprintf('mvn -B %s:install -DgroupId="%s" -DartifactId="%s" -Dversion="%s" -Dpackaging="%s" -DgeneratePom="true"',...
                              installPlugin, groupId, artifactId, options.version, packaging);

            if options.echo
                [status, cmdout] = system(cmdStr, "-echo");
            else
                [status, cmdout] = system(cmdStr);
            end

            if status == 0
                tf = true;
            else
                warning('MATLAB:UTILS:MAVEN','Error installing MPS Java Client\n%s', cmdout)
                tf = false;
            end
        end


        function tf = installFileToRepo(file, groupId, artifactId, version, options)
            % installFileToRepo Installs a local file in a Maven repo

            arguments
                file (1,1) string
                groupId (1,1) string
                artifactId (1,1) string
                version (1,1) string
                options.packaging (1,1) string = "jar"
                options.repo (1,1) string = ""
                options.echo (1,1) logical = false
            end

            if ~matlab.internal.utils.Maven.checkInstallPlugin
                warning('MATLAB:UTILS:MAVEN', 'Error checking Maven install plugin');
                tf = false;
            else
                installPlugin = "org.apache.maven.plugins:maven-install-plugin";
                cmdStr = sprintf('mvn -B %s:install-file -Dfile="%s" -DgroupId="%s" -DartifactId="%s" -Dversion="%s" -Dpackaging="%s"',...
                    installPlugin, file, groupId, artifactId, version, options.packaging);

                if strlength(options.repo) > 0
                    cmdStr = cmdStr + " -DlocalRepositoryPath=""" + string(options.repo) + """";
                end

                if options.echo
                    [status, cmdout] = system(cmdStr, "-echo");
                else
                    [status, cmdout] = system(cmdStr);
                end

                if status == 0
                    tf = true;
                else
                    warning('MATLAB:UTILS:MAVEN','Error installing file:\n%s', cmdout)
                    tf = false;
                end
            end
        end


        function errorIfNotInstalled()
            % errorIfNotInstalled Errors if Maven is not installed and JAVA_HOME is not set

            if ~(matlab.internal.utils.Maven.isInstalled && matlab.internal.utils.Maven.checkJavaHome)
                error('MATLAB:UTILS:MAVEN',...
                    'Apache Maven (mvn) is not installed, not on the path or the JAVA_HOME environment variable is not configured, see: https://maven.apache.org');
            else
                matlab.internal.utils.Maven.proxyWarning();
            end
        end


        function tf = checkJavaHome()
            % checkJavaHome Returns true if JAVA_HOME is set and the directory exists

            jh = getenv('JAVA_HOME');
            if isempty(jh)
                tf = false;
            else
                if isfolder(jh)
                    tf = true;
                else
                    tf = false;
                    warning('MATLAB:UTILS:MAVEN', 'The JAVA_HOME environment variable is set but the directory does not exist: %s', jh);
                end
            end
        end


        function ver = getVersionString()
            % getVersion Returns the Maven version as a string
            if ~matlab.internal.utils.Maven.isInstalled
                ver = string.empty;
            else
                [status, cmdout] = system('mvn --version');

                if status == 0
                    expressionLine = 'Apache Maven\s+\d.\d.\d';
                    verLine = regexp(cmdout, expressionLine, 'match');
                    if isempty(verLine)
                        error('MATLAB:UTILS:MAVEN', 'Error getting Maven version');
                    else
                        expressionValue = '\d.\d.\d';
                        ver = regexp(verLine{1}, expressionValue, 'match');
                        if length(ver) == 0 %#ok<ISMT>
                            error('MATLAB:UTILS:MAVEN', 'Error getting Maven version from: %s', verLine{1});
                        elseif length(ver) == 1
                            ver = string(ver{1});
                        else
                            ver = string(ver{1});
                            warning('MATLAB:UTILS:MAVEN', 'Possible problem getting Maven version, found: %s', ver);
                        end
                    end
                else
                    error('MATLAB:UTILS:MAVEN', 'Error getting Maven version: %f', status);
                end
            end
        end


        function ver = getVersion()
            % getVersion Returns the Maven version as a matlab.internal.utils.SemVer object
            verStr = matlab.internal.utils.Maven.getVersionString;
            if isempty(verStr) || strlength(verStr) == 0
                ver = matlab.internal.utils.SemVer("0.0.0");
            else
                ver = matlab.internal.utils.SemVer(matlab.internal.utils.Maven.getVersionString);
            end
        end


        function v = getPomProjectVersion(pomFile)
            % GETPOMPROJECTVERSION Retrieve version from pom-file
            % Returns the version as a scalar string.
            % Returns an empty string if the file is not found or the version is not found.

            arguments
                pomFile string {mustBeTextScalar, mustBeNonzeroLengthText}
            end

            v = string.empty();

            if ~isfile(pomFile)
                return;
            end

            X = xmlread(pomFile);
            if isempty(X)
                return;
            end

            projNode = X.getElementsByTagName('project').item(0);
            if isempty(projNode)
                return;
            end

            versionElement = projNode.getElementsByTagName('version').item(0);
            if isempty(versionElement)
                return;
            end

            templateVersion = string(versionElement.getTextContent());
            if isempty(templateVersion) || strlength(templateVersion) == 0
                return;
            else
                v = templateVersion;
            end
        end
    end % methods Static
end % class
