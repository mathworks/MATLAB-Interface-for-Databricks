function upload(obj, fileName, varargin)
    % UPLOAD Method to upload files into the DBFS
    % The amount of data uploaded by single API call cannot exceed 1MB. To
    % upload a file that is larger than 1MB to DBFS, this method uses the
    % streaming API, which is a combination of create, addBlock, and close.
    %
    % Example:
    %
    %   db = databricks.DBFS();
    %   db.upload(which('sample.mat'));
    %
    % An optional argument allows the user to specify the destination folder for
    % the upload. The target filename will be the same as the local
    % filename.
    %
    %   db.upload(which('sample.mat'),'/tmp/MATLAB/');
    %
    % A trailing slash is optional. The upload will overwrite an existing file with
    % the same name if one exists in the destination location.
    %
    % If a file has the same name as a folder in the destination folder an error
    % will occur.
    %
    % If a destination folder does not exist a destination of '/MATLAB/' is used by
    % default

    % (c) 2019-2026 MathWorks, Inc.

    % Validate the inputs
    validString = @(x) ischar(x) || isStringScalar(x);
    validLogical = @(x) validateattributes(x, {'numeric', 'logical'}, {'nonempty', 'scalar'});

    % Vectorization
    switch class(fileName)
        case 'cell'
            for cCount=1:numel(fileName)
                % Loop and find each file
                if validString(fileName{cCount})
                    obj.upload(fileName{cCount}, varargin{:});
                else
                    % If an entry is not a string catch it at this point to report the element number
                    error('DATABRICKS:INVALIDERROR', 'Invalid input cell array value at element: %d, expected character vector or scalar string', cCount);
                end
            end

        otherwise
            % Parse the inputs
            p = inputParser;
            p.addRequired('uploadFile', validString);
            p.addOptional('targetDir', '', validString);
            p.addOptional('silent', false, validLogical);

            parse(p, fileName, varargin{:});
            silent = p.Results.silent;

            % Specify output target
            % Convert to char to simplify creation of targetPath and downstream
            % handling
            if~isfile(p.Results.uploadFile)
                error('DATABRICKS:INVALIDERROR', 'File not found: %s', p.Results.uploadFile);
            end
            % Resolve the absolute file for clarity
            [status, info] = fileattrib(p.Results.uploadFile);
            if status
                % Return the full path if fileattrib found the file.
                targetFile = info.Name;
            else
                error('DATABRICKS:INVALIDERROR', 'Error calling fileattrib on: %s ', p.Results.uploadFile);
            end
            % Get the file size for user feedback
            dirResult = dir(targetFile);
            targetSize = dirResult.bytes;
            
            % Build up the destination
            [~, localFile, localExt] = fileparts(targetFile);
            targetDir = char(p.Results.targetDir);
            % Check if the output is a dir or path
            if isempty(targetDir)
                % No target path was specified default to MATLAB
                targetPath = ['/MATLAB/', localFile, localExt];
            elseif ~startsWith(targetDir, '/')
                % A common error if a Windows style path is provided
                error('DATABRICKS:INVALIDERROR', 'Expected destination directory path to begin with "/"');
            elseif endsWith(targetDir, '/')
                % Output location is a directory append the source file name
                % insert a / if required
                targetPath = [targetDir, localFile, localExt];
            else
                targetPath = [targetDir, '/', localFile, localExt];
            end
           
            % Give some feedback
            if ~silent
                fprintf(1,'Uploading: %s Size: %d bytes\n', targetFile, targetSize);
            end

            % Create a DBFS upload file
            dbfs.path = targetPath;
            dbfs.overwrite = 'true';
            createRequest = iSendCreateRequest(obj, 'create', dbfs);

            % Process the results
            if createRequest.StatusCode == matlab.net.http.StatusCode.OK

                % Valid response so package and send back to user
                handle = createRequest.Body.Data.handle;

                % Open and read 1/2 MB at a time at most
                [fid, errmsg] = fopen(p.Results.uploadFile, 'r');
                if fid == -1
                    error('DATABRICKS:UPLOADERROR',"Could not open file: %s\nMessage: %s", p.Results.uploadFile, errmsg);
                end
                finishup = onCleanup(@() iCleanUpFcn(fid));
                chunkSize = bitshift(1,20)/2;  % Split the data into 1/2 MB chunks

                uploadedByteCount = 0;
                previousReportedFraction = 0;
                percentStr = "";
                while ~feof(fid)
                    rawData = fread(fid, chunkSize, 'uchar')';
                    if ~isempty(rawData)
                        % Use enhanced mex base 64 handling if available
                        % uploadData = matlab.net.base64encode(rawData);
                        uploadData = matlab.net.base64('encode', uint8(rawData));

                        % Create the payload
                        chunk.handle = handle;
                        chunk.data = uploadData;

                        % Upload using the handle
                        chunkResponse = iSendRequest(obj, 'add-block', chunk);

                        % Throw a progress point for each chunk
                        if chunkResponse.StatusCode == matlab.net.http.StatusCode.OK
                            % length(rawData can be less than chunksize if
                            % the file is small or at the end of a file
                            if ~silent
                                uploadedByteCount = uploadedByteCount + length(rawData);
                                % Keep just 2 places of precision for %
                                fractionComplete = round(uploadedByteCount/targetSize, 2);
                                % Only report if the percentage has changed
                                if fractionComplete > previousReportedFraction
                                    % Skipping the first instance overwrite the
                                    % previous percentage figure or print a \n
                                    % TODO MATLAB Online handling
                                    specials = "";
                                    if strlength(percentStr) > 0
                                        if isdeployed || ismcc
                                            specials = newline;
                                        else
                                            for n = 1:strlength(percentStr)
                                                specials = specials + sprintf("\b");
                                            end
                                        end
                                    end
                                    percentStr = sprintf('%3.2f%%',fractionComplete*100);
                                    previousReportedFraction = fractionComplete;
                                    percentStr = pad(percentStr, 7, 'left');
                                    fprintf(1,"%s%s",specials, percentStr);
                                end
                            end
                        else
                            % Something failed so clean up
                            error('DATABRICKS:UPLOADERROR', 'Error during upload\n%s', char(chunkResponse));
                        end
                    else
                        if ~feof(fid)
                            error('DATABRICKS:UPLOADERROR', 'An unknown error occurred\n%s', char(chunkResponse));
                        end
                    end
                end

                % Close open file
                fclose(fid);
                % Print a \n after the last percentage report
                if ~silent
                    fprintf(1, '\n');
                end
            else
                error('DATABRICKS:UPLOADERROR', 'Failed to create: %s\n  %s', targetDir, char(createRequest));
            end

            % Close the handle if it exists
            if exist('handle', 'var')
                chunk.handle = handle;
                closeResponse = iSendRequest(obj, 'close', chunk);
                if closeResponse.StatusCode == matlab.net.http.StatusCode.OK
                    % 100% indicates this now
                    % disp('Upload complete');
                else
                    error('DATABRICKS:UPLOADERROR', 'Error closing stream\n  %s', char(closeResponse));
                end
            end
    end %switch
end %function

%% Helper function to send REST JSON calls to Databricks
function response = iSendRequest(obj, apiMethod, body)
    % Connect to the endpoint
    dbfsURI = obj.getURI('dbfs', apiMethod);
    request = obj.getRequestMessage('POST');

    request.Body = matlab.net.http.MessageBody;
    request.Body.Payload = jsonencode(body);
    response = request.send(dbfsURI, databricks.internal.getHTTPOptions(convertResponse=true));
end %function

%% Separate request function to deal with int64 handle
function response = iSendCreateRequest(obj, apiMethod, body)
    % Connect to the endpoint
    dbfsURI = obj.getURI('dbfs', apiMethod);
    request = obj.getRequestMessage('POST');

    request.Body = matlab.net.http.MessageBody;
    request.Body.Payload = jsonencode(body);
    % Don't convert the response JSON to prevent the int64 being converted to a
    % double, the handle value is an int64
    response = request.send(dbfsURI, databricks.internal.getHTTPOptions(convertResponse=false));

    if response.StatusCode ~= matlab.net.http.StatusCode.OK
        error('DATABRICKS:UPLOADERROR', char(response));
    elseif ~isprop(response.Body, 'Data')
        error('DATABRICKS:UPLOADERROR', 'Error expected response Body to have a Data property');
    elseif ~(ischar(response.Body.Data) || isStringScalar(response.Body.Data))
        error('DATABRICKS:UPLOADERROR', 'Error expected response.Body.Data to be of type char or scalar string');
    end

    if isContentTypeHTML(response)
        error('DATABRICKS:UPLOADERROR', 'Error unexpected HTML response:\n%s', char(response));
    elseif isContentTypeJSON(response)
        % Return the int64 value in the expected MATLAB response struct
        allowMissing = false;
        response.Body.Data = jsondecodeTypedValues(response.Body.Data, allowMissing, {"handle"}, "int64");
    else
        % Not HTML or JSON
        error('DATABRICKS:UPLOADERROR', 'Error unexpected response, expecting HTML or JSON:\n%s', char(response));
    end
end %function

%% Cleanup function
function iCleanUpFcn(fid)
    info = fopen(fid);
    if ~isempty(info)
        fclose(fid);
    end
end %function


function tf = isContentTypeJSON(response)
    if ~isprop(response, 'Header')
        error('DATABRICKS:UPLOADERROR', 'Error expected response Body to have a Header property');
    end

    if isempty(response.Header)
        error('DATABRICKS:UPLOADERROR', 'Error unexpected empty Header property');
    end

    tf = false;

    for n = 1:numel(response.Header)
        if strcmpi(response.Header(n).Name, "content-type")
            if strcmpi(response.Header(n).Value, "application/json")
                tf = true;
                break;
            end
        end
    end
end %function


function tf = isContentTypeHTML(response)
    if ~isprop(response, 'Header')
        error('DATABRICKS:UPLOADERROR', 'Error expected response Body to have a Header property');
    end

    if isempty(response.Header)
        error('DATABRICKS:UPLOADERROR', 'Error unexpected empty Header property');
    end

    tf = false;

    for n = 1:numel(response.Header)
        if strcmpi(response.Header(n).Name, "content-type")
            if startsWith(response.Header(n).Value, "text/html")
                tf = true;
                break;
            end
        end
    end
end %function
