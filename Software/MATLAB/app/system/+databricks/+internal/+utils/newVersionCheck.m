function tf = newVersionCheck(varargin)
    % newVersionCheck displays a prompt to download a newer version if available
    % Applies semantic versioning based sorting see: https://semver.org
    %
    % Example:
    %   tf = databricks.internal.utils.newVersionCheck();
    %
    % Returns true if a newer version is available and false otherwise.
    % If a downloadable version cannot be determined false is returned.

    % Copyright 2023-2026 The MathWorks, Inc.
    tf = databricks.internal.utils.newVersionCheckImpl(varargin{:});  
end


