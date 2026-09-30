classdef ReleaseConfig < handle
    % ReleaseConfig Helper class for MATLAB and Databricks releases
    %
    % Examples:
    %   cfg = matlab.databricks.ReleaseConfig.defaultConfig();
    %
    %   matlabReleases = matlab.databricks.ReleaseConfig.adaptMATLABReleases("all", cfg);
    %   There is an exception for R2025a, which will only be returned if explicitly
    %   mentioned.
    %
    %   databricksRuntimes = matlab.databricks.ReleaseConfig.adaptDatabricksRuntimes("all", "R2025b", cfg);
    %
    %   tf = matlab.databricks.ReleaseConfig.matlabDatabricksCombinationSupported("R2024b", "17.3", cfg);
    %
    %   ubuntuVersion = matlab.databricks.ReleaseConfig.getUbuntuVersion("17.3");
    
    % Copyright 2025-2026 MathWorks, Inc.

    methods (Static)
        function cfg = defaultConfig()
            % defaultConfig Return the normal runtime-info configuration
            infoPath = databricksRoot('config', 'runtime-info.json');
            if isfile(infoPath)
                cfg = jsondecode(fileread(infoPath));
            else
                error("DATBARICKS:RELEASECONFIG:NOINFO", ...
                "Runtime configuration file not found: %s", infoPath);
            end
        end

        function matlabReleases = adaptMATLABReleases(matlabReleases, runtimeConfig)
            % adaptMATLABReleases Allow the keyword "all" for all supported releases
            %
            % There is an exception for R2025a, which will only be returned if explicitly
            % mentioned.
            arguments
                matlabReleases string {mustBeNonzeroLengthText}
                runtimeConfig (1,1) struct = matlab.databricks.ReleaseConfig.defaultConfig()
            end
        
            if isStringScalar(matlabReleases) && strcmpi(matlabReleases, "all")
                matlabReleases = string(fieldnames(runtimeConfig));
                % Ignore R2025a, unless explicitly added
                matlabReleases(matlabReleases=="R2025a")=[];
            end
        end

        function databricksRuntimes = adaptDatabricksRuntimes(databricksRuntimes, matlabRel, runtimeConfig)
            % adaptDatabricksRuntimes Allow the keyword "all" for databricks runtimes

            arguments
                databricksRuntimes string {mustBeNonzeroLengthText}
                matlabRel string {mustBeTextScalar, mustBeNonzeroLengthText}
                runtimeConfig (1,1) struct = matlab.databricks.ReleaseConfig.defaultConfig()
            end

            if isStringScalar(databricksRuntimes) && strcmpi(databricksRuntimes, "all")
                dbxRTs = string(fieldnames(runtimeConfig.(matlabRel).deps));
                databricksRuntimes = dbxRTs.extractAfter("dbx").replace("_", ".");
            end
        end

        function tf = matlabDatabricksCombinationSupported(matlabRel, dbxRT, runtimeConfig)
            % matlabDatabricksCombinationSupported Check if release combination is ok

            arguments
                matlabRel string {mustBeTextScalar, mustBeNonzeroLengthText}
                dbxRT string {mustBeTextScalar, mustBeNonzeroLengthText}
                runtimeConfig (1,1) struct = matlab.databricks.ReleaseConfig.defaultConfig()
            end

            % Remove a trailing update number if present e.g R2024bU8, retains R2024b
            matlabRel = extractBefore(matlabRel, 7);

            dbxRTs = string(fieldnames(runtimeConfig.(matlabRel).deps));
            dbxCandidate = "dbx" + replace(dbxRT, ".", "_");
            tf = any(dbxCandidate == dbxRTs);
        end

        function ubuntuVersion = getUbuntuVersion(dbRuntime)
            % getUbuntuVersion Return Ubuntu version for Databricks Runtime
            arguments
                dbRuntime string {mustBeTextScalar, mustBeNonzeroLengthText}
            end

            f = split(dbRuntime, ".");
            
            switch f(1)
                case {"13", "14", "15"}
                    ubuntuVersion = "22.04";
                case {"16", "17", "18"}
                    ubuntuVersion = "24.04";
                otherwise
                    error("DATABRICKS:MATLABDATABRICKSCOMBINATIONSUPPORTED", ...
                        "Unimplemented Databricks runtime, %s", dbRuntime);
            end
        end
    end
end