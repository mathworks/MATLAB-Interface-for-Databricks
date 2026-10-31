function deleteWorkspaces(folder, startWith, options)
    % deleteWorkspaces Delete workspaces starting with a certain name

    %  Copyright 2023-2024 MathWorks, Inc.

    arguments
        folder (1,1) string
        startWith (1,1) string
        options.authMethod string {mustBeTextScalar, mustBeNonzeroLengthText}
        options.profileName string {mustBeTextScalar, mustBeNonzeroLengthText} = databricks.internal.configurationprofile.ConfigFile.getDefaultProfileName
    end

    args = matlab.utils.addArgs(options, ["authMethod", "profileName"]);
    ws = databricks.Workspace(args{:});
    
    candidates = ws.ls(folder);

    names = candidates.path;
    pattern = folder + "/" + startWith;

    matchingFolders = names(names.startsWith(pattern));
    NUM = length(matchingFolders);
    for k=1:NUM
        F = matchingFolders(k);
        fprintf('Deleting workspace #%d/%d -- %s ...\n', k, NUM, F);
        ws.delete(F, true)
    end

end