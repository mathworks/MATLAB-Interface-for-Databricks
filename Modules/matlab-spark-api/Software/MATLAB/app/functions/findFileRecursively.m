function filesFound = findFileRecursively(startDir, rxName)
    % findFileRecursively Search directories recursively for a file
    %
    % filesFound = findFileRecursively(startDir, rxName)
    % will recursively search for a file with name 'rxName' in the
    % directory 'startDir'. The 'rxName' is a regular expression.

    % Copyright 2021 The MathWorks, Inc.

    filesFound = examineDirectory(startDir, rxName)';
    
end

function filesFound = examineDirectory(startDir, rxName)
    dirOutput = dir(startDir);
    
    dirIndex = [dirOutput.isdir];
    dirs = dirOutput(dirIndex);
    files = dirOutput(~dirIndex);
    
    fileNames = string({files.name});
    if isempty(fileNames)
        filesFound = string.empty;
    else
        filesFound = examineFiles(startDir, fileNames, rxName);
    end
    
    for k=1:length(dirs)
        D = string(dirs(k).name);
        if D == "." || D == ".."
            continue;
        end
        filesFound = [filesFound, examineDirectory(fullfile(startDir, D), rxName)]; %#ok<AGROW>
    end

end

function filesFound = examineFiles(startDir, fileNames, rxName)
    fileHits = regexp(fileNames, rxName);
    
    if isempty(fileHits)
        filesFound = string.empty;
    else
        hitIdx = ~cellfun(@isempty, fileHits, 'UniformOutput', true);
        
        filesFound = fileNames(hitIdx);
        if isempty(filesFound)
            filesFound = string.empty;
        else
            filesFound = arrayfun(@(x) fullfile(startDir, x), filesFound, 'UniformOutput', true);
        end
    end
    
end