function [name, valid] = getAccountName()
    % GETACCOUNTNAME Returns the user's login account name
    % Uses environment variables (USERNAME on Windows, USER on Unix).
    % Falls back to whoami if the environment variable is not set.
    %
    % On Windows a domain name is not included.
    %
    % Example:
    %   [name, valid] = matlab.utils.getAccountName();

    % Copyright 2025-2026 MathWorks, Inc.

    if ispc
        name = getenv("USERNAME");
    else
        name = getenv("USER");
    end

    if strlength(name) == 0
        [status, cmdOut] = system("whoami");
        if status ~= 0
            error("MATLAB:UTILS:GETACCOUNTNAME", "Could not determine user's account name");
        end

        if ispc
            cmdOut = strtrim(string(cmdOut));
            if cmdOut.contains("\")
                name = extractAfter(cmdOut, '\');
            else
                name = cmdOut;
            end
        else
            name = strtrim(string(cmdOut));
        end
    end

    if nargout > 1
        valid = matlab.utils.isValidUnixUserName(name);
    end
end