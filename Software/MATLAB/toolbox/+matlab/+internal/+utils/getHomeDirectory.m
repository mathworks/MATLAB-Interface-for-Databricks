function homeDir = getHomeDirectory()
    % getHomeDirectory Gets the home directory of the current user
    % On Windows the environment variable %USERPROFILE% is used.
    % On Linux and macOS the environment variable $HOME is used.
    % If the variable is not defined or the directory is not a directory
    % and empty character vector is returned.
    %
    % Example:
    %    myHome = matlab.internal.utils.getHomeDirectory()
    %
    % This function provides a Java free alternative to:
    % java.lang.System.getProperty('user.home')), it is not a direct replacement.

    % Copyright 2024-2026 The MathWorks, Inc.

    if ispc
        homeDir = getenv("USERPROFILE");
        if isempty(homeDir)
            warning("mathworks:internal:utils:getHomeDirectory","Could not determine home directory USERPROFILE environment variable not set");
        end
    elseif isunix
        homeDir = getenv("HOME");
        if isempty(homeDir)
            warning("mathworks:internal:utils:getHomeDirectory","Could not determine home directory USERPROFILE environment variable not set");
        end
    else
        error("mathworks:internal:utils:getHomeDirectory","Unexpected platform");
    end

    if ~isempty(homeDir)
        if ~isfolder(homeDir)
            warning("mathworks:internal:utils:getHomeDirectory","Invalid home directory: %s, is not a directory, returning empty", homeDir);
            homeDir = char.empty;
        end
    end
end
