function tf = testCredentialsClusterList(options)
    % TESTCREDENTIALSCLUSTERLIST Check if credentials can be used by listing clusters

    %  (c) 2024 MathWorks, Inc.

    arguments
        options.authMethod (1,1) matlab.databricks.AuthMethod
        options.profileName string {mustBeTextScalar, mustBeNonzeroLengthText}
        options.verbose (1,1) logical = true 
    end

    try
        if options.verbose
            disp("Checking the credentials by using the Databricks REST API to list clusters.")
        end
        args = matlab.utils.addArgs(options, ["authMethod", "profileName"]);
        c = databricks.Cluster(args{:});
        list = c.list();
        if isempty(list) || isa(list, 'databricks.Cluster')
            if options.verbose
                disp("Listing clusters credentials check succeeded.");
            end
            tf = true;
        else
            if options.verbose
                fprintf("Listing clusters credentials failed, recheck credentials, returned: %s\n", class(list));
            end
            tf = false;
        end
    catch ME
        if options.verbose
            fprintf("Listing clusters credentials failed, recheck credentials: %s\n", ME.message);
        end
        tf = false;
    end
end