function checkJavaUserHome()
    % checkJavaUserHome Checks that java returns a home directory value

    %  (c) 2023-2026 MathWorks, Inc.

    userDir = matlab.utils.getHomeDirectory();

    if strlength(userDir) < 1
        error('DATABRICKS:INSTALL', "Could not determine user's home directory");
    end
end
