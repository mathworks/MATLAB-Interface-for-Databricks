function latest = getLatestDBCVersion(matchStr, allVersions)
    % getLatestDBCVersion Returns the version string for the latest Databricks Connect release
    % If no version value is found an empty string is returned.
    % A base version can be specified as a string.
    %
    % A second argument, allVersions, can be passed in to reduce REST calls
    % to web service. This makes sense mostly when looping through
    % different versions.
    %
    % Example:
    %     v = databricks.internal.databricksConnect.getLatestDBCVersion
    %       v = "14.3.1"
    %
    %     v = databricks.internal.databricksConnect.getLatestDBCVersion("13")
    %       v = "13.3.1"
    %
    %     allVersions = databricks.internal.databricksConnect.getDBCVersions();
    %     v = databricks.internal.databricksConnect.getLatestDBCVersion("12.2", allVersions)
    %       v = "12.2.22"

    %  Copyright 2023-2024 MathWorks, Inc.

    arguments
        matchStr string = string.empty
        allVersions string = string.empty
    end

    matchStr = trimMatchStr(matchStr);

    % Get all the versions
    if isempty(allVersions)
        allVersions = databricks.internal.databricksConnect.getDBCVersions();
    end

    if isempty(matchStr)
        versions = databricks.internal.databricksConnect.sortDBVersions(allVersions);
    else
        matchesTF = startsWith(allVersions, matchStr);
        versions = string.empty;
        matchedVersions = string.empty;
        if sum(matchesTF) > 0
            for n = 1:numel(matchesTF)
                if matchesTF(n)
                    matchedVersions(end+1) = allVersions(n); %#ok<AGROW>
                end
            end
            versions = databricks.internal.databricksConnect.sortDBVersions(matchedVersions);
        end
    end

    if numel(versions) >= 1
        latest = versions(end);
    else
        if ~isempty(matchStr)
            fprintf('No latest Databricks Connect version found for: %s\n', matchStr);
        else
            fprintf('No latest Databricks Connect version found\n');
        end
        latest = string.empty;
    end

    %% Temporary work around to avoid issue with 14.3.4 Scala library:
    %  Scala signature package has wrong version
    %     expected: 5.0
    %     found: 5.2 in package.class
    % Cap 14.3 at 14.3 pending further investigation
    if strcmp(matchStr, "14.3.")
        if any(contains(versions, "14.3.3")) % okay up to 14.3.30 which should never happen
            % Hard code max to known good value of 14.3.3 for now
            fprintf(2, "Temporary Spark Utility build work around\n");
            fprintf(2, "Using version: 14.3.3 instead of: %s\n", latest);
            latest = "14.3.3";
        else
            fprintf(2, "Version 14.3.3 not found in databricks.internal.databricksConnect.getDBCVersions results\n");
            fprintf(2, "Using: %s\n", latest);
            fprintf(2, "A resulting Spark Utility build failure is expected\n");
        end
    end
end


function S = trimMatchStr(S)

    if isempty(S) || strlength(S) == 0
        S = string.empty;
        return;
    end
    
    fields = S.split(".");
    nFields = numel(fields);
    if nFields < 2
        S = fields(1) + ".";
    else
        S = join(fields(1:2), ".") + ".";
    end
end