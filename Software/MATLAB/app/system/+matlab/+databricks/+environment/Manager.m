classdef Manager < handle
    % MANAGER Manage files and serialization

    % Copyright 2025-2026 MathWorks, Inc


    methods (Static)
        function pd = getPrefDir(options)

            arguments
                options.createDir (1,1) logical = true
                options.databricksLocation (1,1) string
                options.accountName string {mustBeTextScalar, mustBeNonzeroLengthText} = matlab.utils.getAccountName
                options.authMethod (1,1) matlab.databricks.AuthMethod
                options.profileName string {mustBeTextScalar, mustBeNonzeroLengthText} = databricks.internal.configurationprofile.ConfigFile.getDefaultProfileName
            end

            isDBX = databricks.internal.isOnDatabricks();
            args = matlab.utils.addArgs(options, ["authMethod", "profileName"]);
            ws = databricks.Workspace(args{:});

            if ~matlab.utils.isValidUnixUserName(options.accountName)
                error("MANAGER:INVALIDUSER", "Invalid user account name: %s", options.accountName);
            end

            if isfield(options, 'databricksLocation')
                dbxDir = options.databricksLocation;
            else
                dbxDir = sprintf("/Users/%s/MathWorks/PrefDir", ws.username);
                if isDBX
                    dbxDir = "/Workspace" + dbxDir;
                end
            end

            if options.createDir
                if isDBX
                    if ~isfolder(dbxDir)
                        mkdir(dbxDir);
                    end
                else
                    args = matlab.utils.addArgs(options, ["authMethod", "profileName"]);
                    io = databricks.internal.io.IO(args{:});
                    io.mkdir(dbxDir);
                end
            end

            if isDBX
                tmpFolder = tempname("/local_disk0/" + options.accountName);
            else
                tmpFolder = tempname;
            end

            mr = matlabRelease;
            prefsName = sprintf("%s_prefs.tar.gz", mr.Release);
            pd = struct(...
                "IsOnDatabricks", isDBX, ...
                "DatabricksDirectory", dbxDir, ...
                "PrefsName", prefsName, ...
                "LocalPrefDir", prefdir, ...
                "TempDir", tmpFolder, ...
                "CompressedArchive", fullfile(tmpFolder, prefsName), ...
                "OutputName", sprintf("%s/%s", dbxDir, prefsName));
        end

        function writePrefs(options)
            arguments
                options.createDir (1,1) logical = true
                options.databricksLocation (1,1) string
                options.authMethod (1,1) matlab.databricks.AuthMethod
                options.profileName string {mustBeTextScalar, mustBeNonzeroLengthText} = databricks.internal.configurationprofile.ConfigFile.getDefaultProfileName
            end

            args = matlab.utils.addArgs(options, ["createDir", "databricksLocation", "authMethod", "profileName"]);
            pd = matlab.databricks.environment.Manager.getPrefDir(args{:});

            mkdir(pd.TempDir);
            deleteAfter = onCleanup(@() rmdir(pd.TempDir, 's'));

            tar(pd.CompressedArchive, pd.LocalPrefDir);

            if pd.IsOnDatabricks
                if startsWith(pd.OutputName, "/Workspace/") && dir(pd.CompressedArchive).bytes > 524288000
                    fprintf(2, "The archive of the preferences directory exceeds the 500MB limit for /Workspaces, skipping saving preferences.\n")
                else
                    copyfile(pd.CompressedArchive, pd.OutputName, 'f');
                end
            else
                args = matlab.utils.addArgs(options, ["authMethod", "profileName"]);
                io = databricks.internal.io.IO(args{:});
                io.upload(pd.CompressedArchive, pd.OutputName);
            end
        end
    end
end