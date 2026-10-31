classdef Maven
    % MAVEN Class to support working with Maven
    % Supports 3 value numeric versions only e.g.: 1.2.3
    % The assumed default minimum version is 3.6.1
    % A non default version can be provided.
    % If a version cannot be determined 0.0.0 is assumed.

    % Copyright 2022-2023 The MathWorks, Inc.

    % TODO Add support for label strings e.g. 1.2.3-beta etc see
    % matlab.utils.SemVer

    properties(Dependent, Hidden)
        version 
        minimumVersion 
    end

    properties(SetAccess = private, Hidden)
        mavenImpl matlab.internal.utils.Maven;
    end

    methods
        function val = get.version(obj)
            val = matlab.utils.SemVer(obj.mavenImpl.version);
        end

        function obj = set.version(obj, val)
            if isa(val, 'matlab.utils.SemVer')
                obj.mavenImpl.version = matlab.internal.utils.SemVer(string(val));
            else
                obj.mavenImpl.version = val;
            end
        end

        function val = get.minimumVersion(obj)
            val = matlab.utils.SemVer(obj.mavenImpl.minimumVersion);
        end

        function obj = set.minimumVersion(obj, val)
            if isa(val, 'matlab.utils.SemVer')
                obj.mavenImpl.minimumVersion = matlab.internal.utils.SemVer(string(val));
            else
                obj.mavenImpl.minimumVersion = val;
            end
        end

        function obj = Maven(varargin)
            % Maven Construct an instance of this class
            obj.mavenImpl = matlab.internal.utils.Maven();
        end
    end

    methods(Static)
        function tf = isProxySet(varargin)
            % isProxySet Returns true if a proxy is set in a Maven settings file
            % A non default repository can be optionally provided.
           tf = matlab.internal.utils.Maven.isProxySet(varargin{:});
        end


        function proxyWarning(varargin)
            % proxyWarning displays a warning if a proxy is likely to be needed but is not set
            % A non default repository can be optionally provided.
            matlab.internal.utils.Maven.proxyWarning(varargin{:});      
        end


        function tf = isInstalled()
            % isInstalled Returns true if Maven is installed and on the path otherwise false
            % Does not check the version
            tf = matlab.internal.utils.Maven.isInstalled();
        end


        function tf = checkInstallPlugin()
            % checkInstallPlugin Check if the Install plugin is available triggering its installation if possible
            tf = matlab.internal.utils.Maven.checkInstallPlugin();
        end


        function tf = installMPSJavaClient(varargin)
            % installMPSJavaClient
            tf = matlab.internal.utils.Maven.installMPSJavaClient(varargin{:});
        end


        function tf = installFileToRepo(varargin)
            % installFileToRepo Installs a local file in a Maven repo
            tf = matlab.internal.utils.Maven.installFileToRepo(varargin{:})
          
        end


        function errorIfNotInstalled()
            % errorIfNotInstalled Errors if Maven is not installed and JAVA_HOME is not set
            matlab.internal.utils.Maven.errorIfNotInstalled();
        end


        function tf = checkJavaHome()
            % checkJavaHome Returns true if JAVA_HOME is set and the directory exists
            tf = matlab.internal.utils.Maven.checkJavaHome();
        end


        function ver = getVersionString()
            % getVersion Returns the Maven version as a string
            ver = matlab.internal.utils.Maven.getVersionString();
        end


        function ver = getVersion()
            % getVersion Returns the Maven version as a matlab.utils.SemVer object
            ver = matlab.utils.SemVer(matlab.internal.utils.Maven.getVersion());
        end


        function v = getPomProjectVersion(varargin)
            % GETPOMPROJECTVERSION Retrieve version from pom-file
            % Returns the version as a scalar string.
            % Returns an empty string if the file is not found or the version is not found.
            v = matlab.internal.utils.getPomProjectVersion(varargin{:})
        end
    end % methods Static
end % class
