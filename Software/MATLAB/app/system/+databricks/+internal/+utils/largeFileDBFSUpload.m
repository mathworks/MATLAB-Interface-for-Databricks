function [tf, md5sum] = largeFileDBFSUpload(fileToUpload, destinationDir, options)
    % LARGEFILEDBFSUPLOAD Upload large files to DBFS using retries and file splitting
    % Each upload attempt either for a file or part of a file will be attempted
    % 3 times.
    %
    % Optional named parameter:
    %         split: Split the file to be uploaded into parts, default is true
    %
    %     clusterId: Specific cluster ID to use for command execution
    %
    %    authMethod: A matlab.databricks.AuthMethod
    %
    %   profileName: A configuration file profileName value
    %
    % A logical true is returned if the upload succeeds otherwise false is returned.

    %  Copyright 2023-2024 MathWorks, Inc.

    arguments
        fileToUpload string {mustBeTextScalar, mustBeNonzeroLengthText}
        destinationDir string {mustBeTextScalar, mustBeNonzeroLengthText}
        options.split (1,1) logical = true
        options.clusterId string {mustBeTextScalar, mustBeNonzeroLengthText}
        options.authMethod (1,1) matlab.databricks.AuthMethod
        options.profileName string {mustBeTextScalar, mustBeNonzeroLengthText} = databricks.internal.configurationprofile.ConfigFile.getDefaultProfileName
    end

    md5sum = string.empty;

    if ~isfile(fileToUpload)
        fprintf("File not found: %s\n", fileToUpload)
        tf = false;
        return;
    end

    % Test cluster command execution before slower IO
    if isfield(options, "clusterId")
        clusterId = options.clusterId;
    else
        args = matlab.utils.addArgs(options, ["verbose", "profileName"]);
        clusterId = databricks.internal.configurationprofile.ConfigFile.getProfileField("cluster_id", args{:});
        if isempty(clusterId) || strlength(clusterId) == 0
            fprintf(2, "No cluster_id value set in configuration profile: %s\n",options.profileName);
            fprintf(2, "A cluster ID must be set (see: updateClusterId()) or provided as an argument.\n");
            tf = false;
            return;
        end
    end

    args = matlab.utils.addArgs(options, ["authMethod", "profileName"]);
    clusterTf = checkCluster(clusterId, args{:});
    if ~clusterTf
        fprintf("Cluster command execution failed\n");
        tf = false;
        return;
    end

    maxSizeWarning(fileToUpload); % warn if more than 10GB

    if options.split
        % Directory to contain the split parts of the file
        tmpDir = tempname;
        mkdir(tmpDir);
        cleanup = onCleanup(@() rmdir(tmpDir, 's'));

        splitFiles = splitFile(fileToUpload, workingDirectory=tmpDir);
        if isempty(splitFiles)
            tf = false;
        else
            args = matlab.utils.addArgs(options, ["authMethod", "profileName"]);
            if doDBFSUpload(splitFiles, destinationDir, args{:})
                dbfsSplitfiles = string.empty;
                delimitedDestinationDir = destinationDir;
                if ~endsWith(delimitedDestinationDir, "/")
                    delimitedDestinationDir = delimitedDestinationDir + "/";
                end
                if ~startsWith(delimitedDestinationDir, "/")
                    delimitedDestinationDir = "/" + delimitedDestinationDir;
                end
                for n = 1:numel(splitFiles)
                    [~, name, ext] = fileparts(splitFiles(n));
                    dbfsSplitfiles(n) = "/dbfs" + delimitedDestinationDir + string(name) + string(ext);
                end

                [~,name,ext] = fileparts(fileToUpload);
                mergedFile = delimitedDestinationDir + string(name) + string(ext);
                dbfsMergedFile = "/dbfs" + mergedFile;
                if commandExecutionMergeFiles(dbfsSplitfiles, dbfsMergedFile, args{:})
                    tf = dbfsCheckUploadedSize(fileToUpload, mergedFile, args{:});
                    md5sum = computeMD5(dbfsMergedFile, args{:});
                else
                    % Python merge failed
                    tf = false;
                end
            else
                % DBFS upload failed
                tf = false;
            end
        end
    else
        splitSizeWarning(fileToUpload);
        args = matlab.utils.addArgs(options, ["authMethod", "profileName"]);
        if doDBFSUpload(fileToUpload, destinationDir, args{:})
            delimitedDestinationDir = destinationDir;
            if ~endsWith(delimitedDestinationDir, "/")
                delimitedDestinationDir = delimitedDestinationDir + "/";
            end
            if ~startsWith(delimitedDestinationDir, "/")
                delimitedDestinationDir = "/" + delimitedDestinationDir;
            end
            [~, name, ext] = fileparts(fileToUpload);
            mergedFile = delimitedDestinationDir + string(name) + string(ext);
            dbfsMergedFile = "/dbfs" + mergedFile;
            tf = dbfsCheckUploadedSize(fileToUpload, mergedFile, args{:});
            md5sumRaw = computeMD5(dbfsMergedFile, args{:});
            fields = split(string(md5sumRaw));
            md5sum = fields(1);
        else
            tf = false;
        end
    end
end


function tf = checkCluster(clusterId, options)
    arguments
        clusterId string {mustBeTextScalar, mustBeNonzeroLengthText}
        options.authMethod (1,1) matlab.databricks.AuthMethod
        options.profileName string {mustBeTextScalar, mustBeNonzeroLengthText}
    end

    args = matlab.utils.addArgs(options, ["authMethod", "profileName", "clusterId"]);
    [result, response] = databricks.internal.commandexecution.executePythonSubprocess("echo 'cluster command check'", "shell", true, "verbose", false, args{:});

    if strcmp(result, "0")
        tf = true;
    else
        fprintf(2, "Error, checkCluster failed for cluster: %s, stderr: %s\n", clusterId, response.stderr);
        tf = false;
    end
end


function md5sum = computeMD5(dbfsMergedFile, options)
    arguments
        dbfsMergedFile string {mustBeTextScalar, mustBeNonzeroLengthText}
        options.authMethod (1,1) matlab.databricks.AuthMethod
        options.profileName string {mustBeTextScalar, mustBeNonzeroLengthText}
    end

    args = matlab.utils.addArgs(options, ["authMethod", "profileName"]);
    cmdStr = string(sprintf("md5sum %s", dbfsMergedFile));
    [result, response] = databricks.internal.commandexecution.executePythonSubprocess(cmdStr, "shell", true, "timeout", int32(5*60), args{:});

    if strcmp(result, "0")
        fields = split(response.stdout);
        md5sum = fields(1);
    else
        fprintf("Error, md5sum call failed for: %s, stderr: %s", dbfsMergedFile, response.stderr);
        md5sum = string.empty;
    end
end


function tf = dbfsCheckUploadedSize(fileToUpload, mergedFile, options)
    arguments
        fileToUpload string {mustBeTextScalar, mustBeNonzeroLengthText}
        mergedFile string {mustBeTextScalar, mustBeNonzeroLengthText}
        options.authMethod (1,1) matlab.databricks.AuthMethod
        options.profileName string {mustBeTextScalar, mustBeNonzeroLengthText}
    end

    fileDirInfo = dir(fileToUpload);
    if isfield(fileDirInfo, "bytes")
        if isempty(fileDirInfo.bytes)
            fprintf(2, "Empty bytes field returned by dir for: %s\n", fileDirInfo);
            tf = false;
            return;
        end
        if ~isnumeric(fileDirInfo.bytes)
            fprintf(2, "bytes field returned by dir of type: %s\n", class(fileDirInfo.bytes));
            tf = false;
            return;
        end
        if numel(fileDirInfo.bytes) > 1
            fprintf(2, "More than 1 element returned for fileDirInfo.bytes: %d\n", numel(fileDirInfo.bytes));
            tf = false;
            return;
        end
        fileSize = fileDirInfo.bytes;
    else
        fprintf(2, "No bytes field returned by dir for: %s\n", fileDirInfo);
        tf = false;
        return;
    end
    
    args = matlab.utils.addArgs(options, ["authMethod", "profileName"]);
    db = databricks.DBFS(args{:});
    dbfsInfo = db.getStatus(mergedFile);
    if isempty(dbfsInfo)
        fprintf("\nFile not found on DBFS: %s\n", mergedFile);
        tf = false;
    else
        if fileSize == dbfsInfo.file_size
            tf = true;
        else
            fprintf("\nFile sizes do not match, local: %s, %d DBFS: %s, %d\n",fileToUpload, fileSize, mergedFile, dbfsInfo.file_size);
            tf = false;
        end
    end
end


function maxSizeWarning(fileToUpload)
    fileDirInfo = dir(fileToUpload);
    fileSize = fileDirInfo.bytes;

    if fileSize > 1024*1024*1000*10 % 10GB
        fprintf("\nDBFS is not a high performance file IO interface.\nFor files of this size please consider using an alternative approach to uploading data.\n");
    end
end


function splitSizeWarning(fileToUpload)
    fileDirInfo = dir(fileToUpload);
    fileSize = fileDirInfo.bytes;

    if fileSize > 1024*1024*1000 % 1GB
        fprintf("\nFor files of this size please consider using the split option for greater reliability.\n");
    end
end


function splitFiles = splitFile(fileToSplit, options)
    % splitFile Splits a file and returns a string array of paths
    % An empty string array is returned in the case of error.

    arguments
        fileToSplit string {mustBeTextScalar, mustBeNonzeroLengthText}
        options.blocks (1,1) int32 {mustBePositive, mustBeFinite, mustBeReal} = 10
        options.retries (1,1) int32 {mustBePositive, mustBeFinite, mustBeReal} = 3
        options.workingDirectory = tempdir
    end

    fprintf("Splitting file: %s\n", fileToSplit);
    fileDirInfo = dir(fileToSplit);
    partSize = fileDirInfo.bytes/(options.blocks-1);
    totalBytes = fileDirInfo.bytes;
    fprintf("File size: %d bytes\n", totalBytes);
    readChunkSize = 1024*1024*10; % 10MB
    [~, filenameBase, ~] = fileparts(fileToSplit);

    [readFid, errmsg] = fopen(fileToSplit, 'r');
    if readFid == -1
        fprintf(2, "Error, could not read file: %s\nMessage: %s\n", fileToSplit, errmsg);
        splitFiles = string.empty;
        return;
    end

    partCtr = 1;
    totalByteCtr = 0;
    splitFiles = string.empty;
    while totalByteCtr < totalBytes
        % Open a file for a given part
        partFile = fullfile(options.workingDirectory, sprintf("%s-part%d",filenameBase, partCtr));
        splitFiles(end+1) = partFile; %#ok<AGROW>
        [writeFid, errmsg] = fopen(partFile, 'w');
        if writeFid == -1
            fprintf(2, "Error, could not write file: %s\nMessage: %s\n", partFile, errmsg);
            splitFiles = string.empty;
            return;
        end
        fprintf("Writing: %s\n", partFile);
        partByteCtr = 0;
        dotCtr = 0;
        readCount = inf;
        while partByteCtr < partSize && readCount > 0
            [chunk, readCount] = fread(readFid, readChunkSize, 'uint8');
            fwrite(writeFid, chunk);
            partByteCtr = partByteCtr + readCount;
            fprintf(".");
            dotCtr = dotCtr + 1;
            if mod(dotCtr, 60) == 0 && partByteCtr < partSize
                fprintf("\n");
            end
        end
        fprintf("\n");
        fclose(writeFid);
        totalByteCtr = totalByteCtr + partByteCtr;
        partCtr = partCtr + 1;
    end
    fclose(readFid);
    fprintf("Split complete\n");
end


function tf = doDBFSUpload(uploadFiles, destinationDir, retries, options)
    arguments
        % String array of files to upload
        uploadFiles string {mustBeNonzeroLengthText}
        % DBFS destination directory
        destinationDir string {mustBeTextScalar, mustBeNonzeroLengthText}
        % Default 3 attempts is a reasonable number of retries
        retries (1,1) int32 {mustBePositive, mustBeFinite, mustBeReal} = 3
        options.authMethod (1,1) matlab.databricks.AuthMethod
        options.profileName string {mustBeTextScalar, mustBeNonzeroLengthText}
    end

    if numel(uploadFiles) > 1
        fprintf("\nUploading files to: %s\n", destinationDir);
    else
        fprintf("\nUploading file to: %s\n", destinationDir);
    end

    args = matlab.utils.addArgs(options, ["authMethod", "profileName"]);
    d = databricks.DBFS(args{:});

    for n = 1:numel(uploadFiles)
        tryCtr = 1;
        uploadDone = false;
        while (tryCtr <= retries) && (uploadDone ~= true)
            try
                [~, name, ext] = fileparts(char(uploadFiles(n)));
                fprintf("%s, try %d of %d\n", [name, ext], tryCtr, retries);
                d.upload(uploadFiles(n), destinationDir);
                uploadDone = true;
            catch ME
                fprintf("Uploading: %s try: %d failed\n", uploadFiles(n), tryCtr);
                fprintf("  Message: %s, %s\n", ME.identifier, ME.message);
                tryCtr = tryCtr + 1;
            end
        end
        if tryCtr >= retries
            fprintf("Retry count: %d, exceeded for: %s to: %s\n", retries, uploadFiles(n), destinationDir);
            fprintf("Upload failed\n");
            tf = false;
            return;
        end
    end
    fprintf("Upload complete\n");
    tf = true;
end


function tf = commandExecutionMergeFiles(splitFiles, mergedFile, options)
    arguments
        splitFiles string {mustBeNonempty}
        mergedFile string {mustBeTextScalar, mustBeNonzeroLengthText}
        options.authMethod (1,1) matlab.databricks.AuthMethod
        options.profileName string {mustBeTextScalar, mustBeNonzeroLengthText}
    end

    args = matlab.utils.addArgs(options, ["authMethod", "profileName"]);
    cmdStr = string(sprintf('cat %s > %s', splitFiles.join(" "), mergedFile));
    [result, response] = databricks.internal.commandexecution.executePythonSubprocess(cmdStr, "shell", true, "timeout", int32(5*60), args{:});

    if ~strcmp(result, "0")
        fprintf("Merging files failed: %s, stderr: %s\n", result, response.stderr);
        tf = false;
        return;
    else
        fprintf("File merge complete\n");
        tf = true;
    end
end


function tf = localMergeFiles(splitFiles, mergedFile) %#ok<DEFNU>
    % Merge the files locally, can be used for testing
    % could use fwrite if needed
    arguments
        splitFiles string {mustBeNonempty}
        mergedFile string {mustBeTextScalar, mustBeNonzeroLengthText}
    end
    fprintf("Merging files locally for tests\n");
    if isfile(mergedFile)
        msg = sprintf('Overwrite existing file: %s Y/[N]: ', mergedFile);
        response = strip(input(msg, 's'));
        if strcmpi(response, 'y')
            tf = false;
            return;
        end
    end

    if isunix
        cmdStr = "cat";
        for n = 1:numel(splitFiles)
            cmdStr = cmdStr + " " + splitFiles(n);
        end
        cmdStr = cmdStr + " > " + mergedFile;
        fprintf("Running: %s\n", cmdStr);
        [status, cmdOut] = system(cmdStr,'-echo');
        if status == 0
            fprintf("File merge complete");
            tf = true;
        else
            fprintf("Merging files failed: %s", cmdOut);
            tf = false;
            return;
        end
    elseif ispc
        % Form: copy /b file1+file2+file3 targetfile
        cmdStr = "copy /b ";
        for n = 1:numel(splitFiles)
            cmdStr = cmdStr + splitFiles(n);
            if n < numel(splitFiles)
                cmdStr = cmdStr + "+";
            end
        end
        cmdStr = cmdStr + " " + destination;
        fprintf("Running: %s\n", cmdStr)
        [status, cmdOut] = system(cmdStr,'-echo');
        if status == 0
            fprintf("File merge complete");
            tf = true;
        else
            fprintf("Merging files failed: %s", cmdOut);
            tf = false;
            return;
        end
    else
        fprintf("Platform not currently supported\n");
        tf = false;
    end
end
