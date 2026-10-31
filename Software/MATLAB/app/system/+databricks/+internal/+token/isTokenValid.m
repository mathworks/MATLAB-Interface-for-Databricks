function tf = isTokenValid(options)
    % isTokenValid Returns true if the REST API can do Cluster.list

    % Copyright 2023-2024 MathWorks Inc.

    arguments
        options.silent (1,1) logical = false
        options.authMethod (1,1) matlab.databricks.AuthMethod
        options.profileName string {mustBeTextScalar, mustBeNonzeroLengthText} = databricks.internal.configurationprofile.ConfigFile.getDefaultProfileName
    end

    try
        args = matlab.utils.addArgs(options, ["authMethod", "profileName"]);
        databricks.Cluster.list(args{:});
        tf = true;
    catch ME
        if ~options.silent
            if contains(ME.message, "databricks-reason-phrase: Invalid access token")
                fprintf("Token is invalid, if using a Personal Access Token use the\n");
                fprintf("Databricks Workspace User Settings to create a new token and\n");
                fprintf("update it in the <HOME>%s.databrickscfg file.\n", filesep);
                fprintf("Message:\n%s\n", ME.message);
            else
                fprintf("Unexpected error checking authentication using the REST API\nMessage:\n%s", ME.message);
            end
        end
        tf = false;
    end
end