function tf = newVersionCheckImpl(options)
    % newVersionCheckImpl displays a prompt to download a newer version if available
    % Applies semantic versioning based sorting see: https://semver.org
    %
    % Example:
    %   tf = databricks.internal.utils.newVersionCheck();
    %
    % Returns true if a newer version is available and false otherwise.
    % If a downloadable version cannot be determined false is returned.

    % Copyright 2023-2026 The MathWorks, Inc.

    arguments (Input)
        options.settingsFile string {mustBeTextScalar, mustBeNonzeroLengthText} = databricks.internal.settings.Settings.getSettingsFileWritePath
        options.pkgUrl string {mustBeTextScalar, mustBeNonzeroLengthText} = "https://www.mathworks.com/solutions/partners/databricks.html";
        options.forceCheck (1,1) logical = false
        options.verbose (1,1) logical = true
    end
    arguments (Output)
        tf (1,1) logical
    end

    tf = false; % Assume there is no new version

    try % Don't fail in startup if there is a problem with the URL etc.
        % Don't check if it has been checked in the last day unless forcing
        if ~options.forceCheck

            % Unless forced don't check for a new version in batch mode this is likely
            % to be a job and so don't wanted repeated messages in logs where there is no
            % persistent settings json file.
            if batchStartupOptionUsed
                tf = false; % Assume there is no new version
                return;
            end

            if ~updateCheckTimeElapsed(options.settingsFile)
                tf = false;
                return;
            end
        end

        currVersion = string(matlab.internal.databricks.databricksPackageVersion);
        dbUrl = matlab.net.URI(options.pkgUrl);
        webOpts = weboptions('Timeout', 7);
        pageText = webread(dbUrl, webOpts);

        if contains(pageText, "<h2>Download MATLAB Interface for Databricks</h2>") &&...
                contains(pageText, "<p>Release", 'IgnoreCase', true)

            expression1 = '<p>[Rr]elease\s+(\d+\.\d+\.\d+)</p>';
            matchStr1 = regexp(pageText, expression1, 'match');
            expression2 = '(\d+\.\d+\.\d+)';
            matchStr2 = regexp(matchStr1{1}, expression2, 'match');
            downloadVersion = string(matchStr2{1});

            if matlab.internal.utils.SemVer(downloadVersion) > matlab.internal.utils.SemVer(currVersion)
                tf = true;
                if options.verbose
                    fprintf("A new version of the MATLAB Interface for Databricks package is available: %s\n", downloadVersion);
                    fprintf('It can be downloaded from: %s\n', matlab.internal.utils.URL2Link(options.pkgUrl));
                end
            else
                tf = false;
            end
        end
    catch
        if options.verbose
            fprintf(2, 'Unable to check for updates, see: %s\n', matlab.internal.utils.URL2Link(options.pkgUrl));
        end
    end

    try
        % Update the check time
        iso8601Str = string(datetime('now','TimeZone','UTC','Format','yyyy-MM-dd''T''HH:mm:ssXXX'));
        if ~databricks.internal.settings.Settings.writeDatabricksSettingsFields(...
            "newVersionCheckTime", iso8601Str, settingsFile=options.settingsFile, verbose=false)
            if options.verbose
                fprintf(2, 'Unable to write package version check time.\n');
                tf = false;
            end
        end
    catch
        if options.verbose
            fprintf(2, 'Unable to update package version check time.\n');
        end
    end
end


function tf = updateCheckTimeElapsed(settingsFile)
    % UPDATECHECKTIMEELAPSED Determine if enough time has passed since last version check
    arguments (Input)
        settingsFile string {mustBeTextScalar, mustBeNonzeroLengthText}
    end
    arguments (Output)
        tf (1,1) logical
    end

    newVersionCheckTime = databricks.internal.settings.Settings.getSettingsField("newVersionCheckTime", settingsFile=settingsFile);
    if isempty(newVersionCheckTime) || strlength(newVersionCheckTime) == 0
        tf = true;
        return;
    end

    currentDatetime = datetime('now', 'TimeZone','UTC');
    lastCheckDatetime = datetime(newVersionCheckTime, 'InputFormat','yyyy-MM-dd''T''HH:mm:ssXXX', 'TimeZone','UTC');
    if currentDatetime - lastCheckDatetime > days(1)
        tf = true;
    else
        tf = false;
    end
end
