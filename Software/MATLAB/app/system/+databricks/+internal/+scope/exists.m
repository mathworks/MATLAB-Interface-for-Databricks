function tf = exists(name, options)
    % EXISTS Returns true if a scope exists otherwise false

    % Copyright (c) 2024, The MathWorks, Inc.

    arguments
        name string {mustBeTextScalar, mustBeNonzeroLengthText}
        options.authMethod (1,1) matlab.databricks.AuthMethod
        options.profileName string = databricks.internal.configurationprofile.ConfigFile.getDefaultProfileName
    end

    args = matlab.utils.addArgs(options, ["authMethod", "profileName"]);
    scopeObj = databricks.Scope(args{:});
    list = scopeObj.list;
    tf = any(matches(list.name, name));
end
