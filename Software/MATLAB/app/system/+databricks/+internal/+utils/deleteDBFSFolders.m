function deleteDBFSFolders(folder, startWith, options)
    % deleteDBFSFolders Delete folder starting with a certain name

    %  Copyright 2023-2024 MathWorks, Inc.

    arguments
        folder (1,1) string
        startWith (1,1) string
        options.authMethod string {mustBeTextScalar, mustBeNonzeroLengthText}
        options.profileName string {mustBeTextScalar, mustBeNonzeroLengthText} = databricks.internal.configurationprofile.ConfigFile.getDefaultProfileName
    end

    args = matlab.utils.addArgs(options, ["authMethod", "profileName"]);
    db = databricks.DBFS(args{:});
    
    candidates = db.ls(folder);

    names = string(candidates.path);
    pattern = folder + "/" + startWith;

    matchingFolders = names(names.startsWith(pattern));
    NUM = length(matchingFolders);
    for k=1:NUM
        F = matchingFolders(k);
        fprintf('Deleting DBFS #%d/%d -- %s ...\n',k, NUM, F);
        db.rm(F, true)
    end

end