function FIS = getFcnFileName(funcName)
    % getFcnFileName Get information from a function/file
    %
    % This is a helper function to disambiguate parts of a
    % function/filename/functionHandle. 
    % In particular, it will help with user functions that take the name of
    % a function, or its file name. It can sometimes be unclear, as when
    % calling the compiler, if the function name or the file name should be
    % used. This takes one of both, and returns all information in a
    % consistent structure.

    % Copyright 2024-2025 The MathWorks, Inc.

    arguments (Input)
        funcName
    end

    if isa(funcName, 'function_handle')
        funcHandle = funcName;
        funcName = func2str(funcHandle);
        fullFuncName = which(funcName);
        if isempty(fullFuncName)
            % An absolute path will give an empty result
            if isfile(funcName)
                fullFuncName = funcName;
            else
                error("SPARKAPI:file_does_not_exist", ...
                    "Couldn't find file %s", funcName);
            end
        end
        [p, n, e] = fileparts(fullFuncName);
    else
        fullFuncName = which(funcName);
        if isempty(fullFuncName)
            % An absolute path will give an empty result
            if isfile(funcName)
                fullFuncName = funcName;
            else
                error("SPARKAPI:file_does_not_exist", ...
                    "Couldn't find file %s", funcName);
            end
        end
        [p, n, e] = fileparts(fullFuncName);
        funcHandle = str2func(n);
    end

    FIS = struct(...
        "FuncHandle", funcHandle, ...
        "FuncName", string(n), ...
        "FileName", string(n) + string(e), ...
        "FullFileName", string(fullFuncName), ...
        "FullPath", string(p));
end