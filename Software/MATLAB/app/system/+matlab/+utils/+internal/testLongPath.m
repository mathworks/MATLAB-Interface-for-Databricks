function result = testLongPath(options)
    % TESTLONGPATH Tests if a long path can be created
    % See: https://learn.microsoft.com/en-us/windows/win32/fileio/maximum-file-path-limitation?tabs=registry

    % Copyright 2025 MATLAB Inc
    
    arguments
        options.verbose (1,1) logical = true
    end

    if ~ispc
        error("%s is intended for use on Windows only.\n", mfilename);
    end

    fPath = createLongPath();
    if isfile(fPath)
        error("Long path test file already exists: %s, delete to proceed.", fPath)
    end

    % Create the long path test file
    fid = fopen(fPath, 'w');
    if fid == -1
        if options.verbose
            fprintf("Failed to create the long path test file:\n  %s", fPath);
        end
        result = false;
        if options.verbose
            regTf = getLongPathsEnabledRegKey();
            fprintf("LongPathsEnabled registry entry: %s\n", string(regTf));
        end
    else
        fclose(fid);
        whenDone = onCleanup(@() delete(fPath));
        result = true;
    end
end


function fPath = createLongPath(length)
    arguments
        % Windows short limit is 256 (x:\<256>NUL)
        length (1,1) int32 = 270
    end

    tDir = tempdir();
    tDirlen = strlength(tDir);

    if length < tDirlen + 1
        error("The minimum supported length is: %d, %sx", tDirlen + 1, tDir);
    else
        genLength = length - tDirlen;
        tFile = repmat('x', 1, genLength);
        fPath = fullfile(tDir, tFile);
    end
end


function tf = getLongPathsEnabledRegKey()

    cmd = "powershell -command $val = Get-ItemProperty -Path HKLM:\SYSTEM\CurrentControlSet\Control\FileSystem -Name LongPathsEnabled; echo $val.LongPathsEnabled";
    [status,cmdout] = system(cmd);

    if status ~= 0
        error("Checking LongPathsEnabled registry key via powershell failed:\n%s", strip(cmdout));
    end
    cmdout = strip(cmdout);
    if strcmp(cmdout, '1')
        tf = true;
    elseif strcmp(cmdout, '0')
        tf = false;
    else
        error("Unexpected value for LongPathsEnabled registry key: %s", cmdout);
    end
end