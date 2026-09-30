function releases = askForReleaseList()
    % ASKFORRELEASELIST Ask the user for a list or MATLAB releases to support
    
    %  (c) 2024 MathWorks, Inc.

    fprintf("\nSelect release(s) of MATLAB to support on the server side.\n");
    pkgSettings = matlab.databricks.internal.pkgsettings.getPkgSettings;
    supportedReleases = [pkgSettings.supportedMATLABReleases.release];

    currentRelease = matlabRelease().Release;

    releases = string.empty;
    if numel(numel(supportedReleases)) > 0
        fprintf("The following release(s) may be selected: %s\n", join(supportedReleases, ", "));
    end
    for n = 1:numel(supportedReleases)
        prompt = sprintf("Support %s", supportedReleases(n));
        if matlab.utils.ynQuestion(prompt, "Y")
            releases(end+1) = supportedReleases(n); %#ok<AGROW>
        end
    end
    if numel(releases) == 0
        fprintf("No release(s) selected using: %s\n", currentRelease);
        releases = currentRelease;
    end
    fprintf("Supporting: %s\n", join(releases, ", "))
end