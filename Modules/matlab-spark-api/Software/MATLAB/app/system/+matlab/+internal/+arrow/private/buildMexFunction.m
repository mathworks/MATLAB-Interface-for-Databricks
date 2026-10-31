function buildMexFunction()
%BUILDMEXFUNCTION Builds convertUTF8StringArray mex function.

% Copyright 2026 The MathWorks, Inc.


    currFolder = fileparts(mfilename("fullpath"));

    repoFolder = fullfile(tempdir, "simdutf");
    if isfolder(repoFolder)
        rmdir(repoFolder, "s");
    end
    repoURL = "https://github.com/simdutf/simdutf";
    gitclone(repoURL, repoFolder);
    runCommand(compose("git -C %s checkout v8.0.0", repoFolder));

    pyFile = fullfile(repoFolder, "singleheader", "amalgamate.py");
    pyArgs = "--with-utf8 --with-utf16";
    cmd = compose("%s %s", pyFile, pyArgs);
    pyrunfile(cmd);

    cppFile = fullfile(repoFolder, "singleheader", "simdutf.cpp");
    hFile = fullfile(repoFolder, "singleheader", "simdutf.h");

    copyfile(cppFile, currFolder);
    copyfile(hFile, currFolder);

    if isunix
        if ismac
            mex("convertUTF8StringArray.cpp", "CXXFLAGS=$CXXFLAGS -std=c++17");
        else
            mex("convertUTF8StringArray.cpp", "-v", "CXXFLAGS=$CXXFLAGS -std=c++17", "LDFLAGS=$LDFLAGS -Wl,-z,noexecstack")
        end
    else
        mex("convertUTF8StringArray.cpp", "COMPFLAGS=$COMPFLAGS /std:c++17");
    end
end

function runCommand(cmd)    
    [status, msg] = system(cmd);
    if status
        formatSpec = "Command '%s' failed with message:\n%s";
        errorMessage = compose(formatSpec, cmd, msg);
        error("sparkapi:BuildMexFailed", errorMessage);
    end
end