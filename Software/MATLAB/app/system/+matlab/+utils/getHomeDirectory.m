function homeDir = getHomeDirectory()
    % getHomeDirectory Gets the home directory of the current user
    % On Windows the environment variable %USERPROFILE% is used.
    % On Linux and macOS the environment variable $HOME is used.
    % If the variable is not defined or the directory is not a directory
    % and empty character vector is returned.
    %
    % Example:
    %    myHome = matlab.utils.getHomeDirectory()
    %
    % Copyright 2024-2026 MathWorks, Inc.

    homeDir = matlab.internal.utils.getHomeDirectory();

end