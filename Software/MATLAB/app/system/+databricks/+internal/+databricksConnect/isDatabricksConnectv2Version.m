function tf = isDatabricksConnectv2Version(version)
    % isDatabricksConnectv2Version Returns true if version should use Databricks Connect v2 otherwise false
    %
    % Example
    %   tf = databricks.internal.databricksConnect.isDatabricksConnectv2Version("13.3")
    
    %  Copyright 2023-2024 MathWorks, Inc.

    arguments
        version string {mustBeTextScalar, mustBeNonzeroLengthText}
    end

    fields = split(version, '.');
    major = double(string(fields(1)));
    if numel(fields) > 1
        minor = double(string(fields(2)));
    else
        minor = 0;
    end
    if major == 13 && minor >=3  % Strictly 13.2 was v2 also but not UC and no longer support from v5
        tf = true;
    elseif major > 13
        tf = true;
    else
        tf = false;
    end
end

