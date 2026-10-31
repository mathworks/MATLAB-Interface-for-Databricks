function deleteAuthTokens(options)
    % DELETEAUTHTOKENS Deletes default OauthM2M & OauthU2M token caches and any specified cache files
    %
    % Example:
    %    matlab.databricks.setup.deleteAuthTokens();

    arguments
        options.cachedTokenPaths string {mustBeNonzeroLengthText}
        options.verbose (1,1) logical = true
    end

    if options.verbose
        disp("Deleting cached authentication tokens");
    end

    if isfield(options, "cachedTokenPaths")
        cacheFiles = options.cachedTokenPaths;
    else
        cacheFiles = string.empty;
    end

    % Delete legacy files if they exist
    cacheFiles(end+1) = string(fullfile(matlab.utils.getHomeDirectory(), '.databricksOauthU2MTokenCache'));
    cacheFiles(end+1) = string(fullfile(matlab.utils.getHomeDirectory(), '.databricksOauthM2MTokenCache'));

    % Delete the default file ignoring not honouring DATABRICKS_TOKEN_CACHE_FILE
    cacheFiles(end+1) = string(fullfile(matlab.utils.getHomeDirectory(), '.databricksOauthTokenCache'));

    % Delete the default file honouring DATABRICKS_TOKEN_CACHE_FILE
    % AuthMethod argument can be OauthU2M or OauthM2M
    cacheFiles(end+1) = databricks.internal.unifiedauthentication.Oauth.getDefaultCacheFilePath(matlab.databricks.AuthMethod.OauthM2M);
    
    for n = 1:numel(cacheFiles)
        if isfile(cacheFiles(n))
            if options.verbose
                fprintf("  %s\n", cacheFiles(n));
            end
            delete(cacheFiles(n));
        end
    end
end