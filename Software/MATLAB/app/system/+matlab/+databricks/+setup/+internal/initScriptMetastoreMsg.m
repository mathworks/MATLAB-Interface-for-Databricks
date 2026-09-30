function initScriptMetastoreMsg(options)
    % INITSCRIPTMETASTOREMSG Shows a message and link to update the allowlist
    %
    % Example:
    %   matlab.databricks.setup.internal.initScriptMetastoreMsg(path="/Volumes/main/default/myvolume/MathWorks/runtimes/runtime_install.sh")

    % Copyright 2024 The MathWorks, Inc.

    arguments
        options.path string {mustBeTextScalar, mustBeNonzeroLengthText}
        options.profileName string {mustBeTextScalar, mustBeNonzeroLengthText}
    end

    args = matlab.utils.addArgs(options, "profileName");
    metastoreURL = matlab.databricks.internal.getMetastoreURL(args{:});
    metastoreLink = matlab.utils.URL2Link(metastoreURL);
    if isfield(options, "path")
        fprintf("If using Shared Access Mode clusters, the init script should be added to the allowlist:\n  %s\n", options.path);
    else
        fprintf("If using Shared Access Mode clusters, the init script should be added to the allowlist,\n");
    end
    fprintf("via: %s\n", metastoreLink);
end