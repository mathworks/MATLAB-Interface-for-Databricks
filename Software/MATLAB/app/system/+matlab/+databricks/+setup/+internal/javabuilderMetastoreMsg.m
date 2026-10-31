function javabuilderMetastoreMsg(options)
    % JAVABUILDERMETASTOREMSG Shows a message and link to update the allowlist
    %
    % Example:
    %   matlab.databricks.setup.internal.javabuilderMetastoreMsg(path="/Volumes/main/default/myvolume/MathWorks/runtimes/javabuilder")

    % Copyright 2024 The MathWorks, Inc.

    arguments
        options.path string {mustBeTextScalar, mustBeNonzeroLengthText}
        options.profileName string {mustBeTextScalar, mustBeNonzeroLengthText}
    end

    args = matlab.utils.addArgs(options, "profileName");
    metastoreURL = matlab.databricks.internal.getMetastoreURL(args{:});
    metastoreLink = matlab.utils.URL2Link(metastoreURL);
    if isfield(options, "path")
        fprintf("If using Shared Access Mode clusters, the javabuilder jar file(s) should be added to the allowed list:\n  %s\n", options.path);
    else
        fprintf("If using Shared Access Mode clusters, the javabuilder jar file(s) be added to the allowlist,\n");
    end
    fprintf("via: %s\n", metastoreLink);
end
