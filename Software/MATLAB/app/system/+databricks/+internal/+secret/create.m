function create(secret, scope, key, options)
    % CREATE Create a secret value, e.g. auth tokens
    % The Scope and Secret are persistent and do not need to be recreated unless deleted.
    % or the token expires. If the scope does not exist it is created.
    % If the secret exists it is overwritten.
    % The scope's initialManagePrincipal can be optionally specified and defaults
    % to "users".

    % Copyright (c) 2024, The MathWorks, Inc.

    arguments
        secret string {mustBeTextScalar, mustBeNonzeroLengthText}
        scope string {mustBeTextScalar, mustBeNonzeroLengthText}
        key string {mustBeTextScalar, mustBeNonzeroLengthText}
        options.initialManagePrincipal string {mustBeTextScalar, mustBeNonzeroLengthText} = "users"
        options.authMethod (1,1) matlab.databricks.AuthMethod
        options.profileName string = databricks.internal.configurationprofile.ConfigFile.getDefaultProfileName
    end

    args = matlab.utils.addArgs(options, ["authMethod", "profileName"]);
    if ~databricks.internal.scope.exists(scope)
        scopeObj = databricks.Scope(args{:});
        scopeObj.scope = scope;
        scopeObj.initial_manage_principal = char(options.initialManagePrincipal);
        scopeObj.create
    end

    secretObj = databricks.Secret(args{:});
    secretObj.scope = scope;
    secretObj.key = key;
    secretObj.setValue(secret);
    secretObj.put
end
