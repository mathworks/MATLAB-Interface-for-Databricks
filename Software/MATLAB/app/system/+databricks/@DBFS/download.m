function outFile = download(obj, pathStr, varargin)
    % DOWNLOAD Method to download a file from DBFS
    % This method will download an entire file from DBFS. The reading of the
    % file from DBFS is performed in approximately 1MB chunks.
    %
    % For example:
    %
    %   db = databricks.DBFS;
    %   localFilename = db.download('/example/sample.mat');
    %
    % The download method can recursively download entire folders of files.
    %
    %   db.download('/example/logs','recurse',true);

    %   (c) 2019-2023 MathWorks, Inc.

    % Validate the inputs
    validNumber =  @(x) validateattributes(x, {'numeric'}, {'nonempty', 'scalar'});
    validBoolean = @(x) validateattributes(x, {'numeric', 'logical'}, {'nonempty', 'scalar'});
    validString  = @(x) (ischar(x) || isstring(x) || iscellstr(x) || istable(x)) && ~isempty(x);

    % Created an input parser
    p = inputParser;
    p.addRequired('path', validString);
    p.addParameter('offset', 0, validNumber);       % Start at the beginning 0
    p.addParameter('length', 1000000, validNumber); % c. 1MB default
    p.addParameter('recurse', false, validBoolean); % false default
    p.addParameter('outfolder', '.', validString);  % Current directory as default
    p.addParameter('silent', false, validBoolean);  % false default

    % Parse and setup the parameters
    p.parse(pathStr,varargin{:});
    pathStr = p.Results.path;
    offset = p.Results.offset;
    length = p.Results.length;
    recurse = p.Results.recurse;
    outfolder = p.Results.outfolder;
    silent = p.Results.silent;

    % Go to outfolder, return to startfolder at end of function
    if ~strcmp(outfolder, '.')
        if ~exist(outfolder, 'dir')
            status = mkdir(outfolder);
            if status ~= 1
                error('DATABRICKS:ERROR', 'Unable to create directory: %s', char(outfolder));
            end
        end
    end

    oldFolder = cd(outfolder);
    goBack = onCleanup(@() cd(oldFolder));

    % Vectorization
    switch class(pathStr)
        case 'cell'
            if ~iscellstr(pathStr) %#ok<ISCLSTR>
                error('DATABRICKS:INVALIDERROR','Invalid input cell array');
            end
            outFile = {};
            for cCount=1:numel(pathStr)
                % Loop and find each pathstr
                if validString(pathStr{cCount})
                    % Attempt to download
                    of = obj.download(pathStr{cCount}, 'offset', offset, ...
                        'length', length, 'recurse', recurse);
                    outFile = [outFile, of]; %#ok<AGROW>
                end
            end
        case 'table'
            if any(strcmp(pathStr.Properties.VariableNames,'path'))
                % Found valid table
                N = height(pathStr);
                outFile = {};
                for k=1:N
                    P = uncell(pathStr{k,'path'});
                    of = obj.download(P, 'offset', offset, ...
                        'length', length, 'recurse', recurse);
                    outFile = [outFile, of]; %#ok<AGROW>
                end
            else
                error('DATABRICKS:INVALIDERROR','Invalid input table');
            end
        otherwise
            % Single file download
            if recurse
                outFolderFix = adaptOutputFolderName(pathStr, outfolder, obj);
                if ~exist(outFolderFix, 'dir')
                    status = mkdir(outFolderFix);
                    if status ~= 1
                        error('DATABRICKS:ERROR', 'Unable to create directory: %s', char(outFolderFix));
                    end
                    cd(outFolderFix);
                end
                outFile = i_recursive_download(pathStr, offset, length, silent, obj);
            else
                outFile = i_single_file_download(pathStr, offset, length, silent, obj);
            end

    end % switch

end %function

function downloadFileName = i_single_file_download(pathStr, offset, length, silent, obj)
    % Get the name of the download file, resolve the absolute file for clarity
    [~, fileName, ext] = fileparts(pathStr);
    downloadFileName = strcat(fileName, ext);
    [status, info] = fileattrib(downloadFileName);
    if status
        % Return the full path if fileattrib found the file.
        downloadFileName = info.Name;
    else
        if isfile(downloadFileName) % expect fileattrib to fail if the file does not exist already
            error('DATABRICKS:ERROR', 'Error calling fileattrib on: %s ',downloadFileName);
        end
    end
    if ~silent
        % Get the size to allow a percent calculation
        fileSize = getFileSize(pathStr, obj);
        % fprintf(1, 'Downloading: %s\n',pathStr); % No need to report the src string in general
        fprintf(1, 'Downloading to: %s Size: %d bytes\n', downloadFileName, fileSize);
    end

    % Initial offset may not be 0
    initOffset = offset;

    % Attempt to read the first block of the file, may fail and error e.g. if the file does not exist
    [rawBytes, numBytes] = readFileSection(obj, pathStr, offset, length);

    % Only after it is known that the remote file exists and can be read open the file locally
    % i.e. do not leave an empty file behind if there is no remote data to populate it
    [fid, errmsg] = fopen(downloadFileName,'w');
    if fid < 3
        error('DATABRICKS:ERROR', 'Unable to write to file: %s\nMessage: %s', downloadFileName, errmsg);
    end
    closeAfter = onCleanup(@() fclose(fid));

    % Write out first block of the file the file
    fwrite(fid,rawBytes);
    %overwritePercent = false;
    previousFraction = 0;
    percentStr = '';
    while numBytes~=0
        % Continue to read
        offset = offset+numBytes;
        % Create the request to read the file
        [rawBytes, numBytes] = readFileSection(obj, pathStr, offset, length);
        fwrite(fid,rawBytes);
        % Offset tracks the amount downloaded so far
        % normally this starts at 0 assuming you want the whole file
        if ~silent
            fractionComplete = double(offset-initOffset)/double(fileSize-initOffset);
            [percentStr, previousFraction] = printPercent(fractionComplete, previousFraction, percentStr);
        end
    end
    if ~silent % When done display 100%
        fractionComplete = 1;
        [~, ~] = printPercent(fractionComplete, previousFraction, percentStr);
        fprintf(1,'\n');
    end
end


function [percentStr, previousFraction] = printPercent(fractionComplete, previousFraction, previousStr)
    % If the reported percent string is not updated the value returned should be the same
    % as the previous value
    percentStr = previousStr;

    % For less than 1% values report a few increments to show starting rate
    % thereafter report every roughly 1% at most to limit output yet provide useful
    %  feedback

    % Less than 1 % report every 0.1%
    if fractionComplete < 0.01 && (fractionComplete - previousFraction) < 0.001
        return;
    end

    % >= 1% report every %
    if fractionComplete >= 0.01 && (fractionComplete - previousFraction) < 0.01 && fractionComplete < 1
        return;
    end

    % Update the previously reported fraction with the new completions fraction
    previousFraction = fractionComplete;

    % Cap at 100% if offset exceeds length, which should not happen in
    % correct usage
    if fractionComplete > 1
        fractionComplete = 1;
    end
    % TODO MATLAB Online handling
    % Pad the string for consistency
    percentStr = sprintf('%3.2f%%',fractionComplete*100);
    percentStr = pad(percentStr, 7, 'left');
    
    % Backspace over the previously reported percent string
    specials = "";
    for n = 1:strlength(previousStr)
        specials = specials + sprintf("\b");
    end
    fprintf(1,"%s%s", specials, percentStr);
end


function fileSize = getFileSize(pathStr, obj)
    status = obj.getStatus(pathStr);
    if ~isempty(status)
        fileSize = status.file_size;
    else
        % File not found so emulate the error that would have previously happened in 
        % readFileSection()
        error('DATABRICKS:ERROR', 'Failed to read data: %s\n  error_code: %s\n  message: %s',...
                       char(pathStr), 'RESOURCE_DOES_NOT_EXIST',...
                       ['No file or directory exists on path ', char(pathStr)]);
    end
end

function outFiles = i_recursive_download(pathStr, offset, length, silent, obj)
    outFiles = {};
    files = obj.ls(pathStr);
    for k=1:height(files)
        if files{k,'is_dir'}
            FD = uncell(files{k, 'path'});
            [~,DN, EXT] = fileparts(FD);
            DN = strcat(DN, EXT);
            fullLocalName = fullfile(pwd, DN);
            if ~exist(fullLocalName, 'dir')
                status = mkdir(fullLocalName);
                if status ~= 1
                    error('DATABRICKS:ERROR', 'Unable to create directory: %s', char(DN));
                end
            end
            cd(DN);
            of = i_recursive_download(FD, offset, length, silent, obj);
            cd('..');
        else
            FN = uncell(files{k,'path'});
            % i_single_file_download reports the filename if not silent
            % fprintf('Downloading %s ...\n', FN);
            of = i_single_file_download(FN, offset, length, silent, obj);
        end
        outFiles = [outFiles, of]; %#ok<AGROW>
    end
end

function outFolder = adaptOutputFolderName(dbFolder, outFolder, obj)
    files = obj.ls(dbFolder);
    if height(files)==1 && ~files{1,'is_dir'}
        % This is just a file, and we shouldn't change anything of the
        % output folder
    else
        [dbf2, lastName] = fileparts(dbFolder);
        if isempty(lastName)
            [~, lastName] = fileparts(dbf2);
        end
        outFolder = lastName;
    end
end

function v = uncell(v)
    if iscell(v)
        if isscalar(v)
            v = v{1};
        else
            error('DATABRICKS:ERROR','Trying to uncell a non-scalar-value');
        end
    end
end