function [result, errorResponse] = bigUpload(obj, source, destination, options)
    % UPLOAD Uploads a file of size 5 GiB or greater Caution - Relies upon an undocumented Databricks feature
    % The method is not supported and may be removed without further notice
    % For smaller files use the databricks.Upload method.
    %
    % On success a logical true is returned with an empty databricks.datastructures.files.ErrorResponse.
    % Otherwise false is returned with a populated databricks.datastructures.files.ErrorResponse.
    %
    % The optional named `overwrite` argument indicates if the destination file
    % should be overwritten if it exists. The default is `true`.
    %
    % Examples:
    %   f = databricks.Files;
    %    result = f.bigUpload("myBigFile.zip", "/Volumes/main/default/myvolume/myDir/myBigFile.zip")
    %    result =
    %      logical
    %       1
    %
    %
    %   if ispc
    %       localRuntimePath = fullfile(getenv("%USERPROFILE%"), "Downloads", "MATLAB_Runtime_R2026a_Update_4_glnxa64.zip");
    %   else
    %       localRuntimePath = fullfile(getenv("HOME"), "Downloads", "MATLAB_Runtime_R2026a_Update_4_glnxa64.zip");
    %   end
    %   [p,n,e] = fileparts(localRuntimePath);
    %   fname = n + e;
    %   catalogPath = "/Volumes/main/default/myvolume/MathWorks/runtimes/" + fname;
    %
    %   f = databricks.Files;
    %   [result, errorResponse] = f.bigUpload(localRuntimePath, catalogPath, overwrite=true)
    %
    %
    % See also: https://docs.databricks.com/api/workspace/files/upload

    % Copyright 2026 The MathWorks, Inc.

    % The file contents should be sent as the request body as raw bytes
    % (an octet stream); do not encode or otherwise modify the bytes before
    % sending. The contents of the resulting file will be exactly the bytes
    % sent in the request body.

    arguments (Input)
        obj databricks.Files
        source string {mustBeFile}
        destination string {mustBeTextScalar, mustBeNonzeroLengthText}
        options.overwrite (1,1) logical = true
        options.usePresignedURLs (1,1) logical = true
        options.verbose (1,1) logical = true
    end
    arguments (Output)
        result (1,1) logical
        errorResponse
    end

    if ~isfile(source)
        error("DATABRICKS:Files:bigUpload:NoSource", "File not found: %s", source);
    end

    chunkSize = 100*1048576;
    stats = dir(source);
    fileSize = stats.bytes;
    if fileSize < 5*2^30
        fprintf("Files less than 5 GiB should be uploaded using databricks.File.upload()\n");
    end  

    [initResult, errorResponse] = obj.initiateUpload(destination, overwrite=options.overwrite);
    if ~isempty(errorResponse)
        disp(errorResponse);
        error("DATABRICKS:Files:bigUpload:initFailed", "initiateUpload failed.");
    end
    assert(isfield(initResult, "multipart_upload"), "No multipart_upload field found.");
    assert(isfield(initResult.multipart_upload, "session_token"), "No session_token field found.");
    assert(isa(initResult.multipart_upload.session_token, "char"), "session_token not a char.");
    assert(~isempty(initResult.multipart_upload.session_token), "session_token is empty.");
    assert(isvector(initResult.multipart_upload.session_token), "session_token not a char vector.");
    assert(strlength(initResult.multipart_upload.session_token) > 0, "session_token not set.");
    sessionToken = string(initResult.multipart_upload.session_token);
    % If supporting GCP this should look like:
    % sessionToken = initResult.resumable_upload.session_token;
    % This is currently not supported

    if options.usePresignedURLs
        abortIfFail = onCleanup(@() abortUpload(obj, destination, sessionToken));
        [result, errorResponse] = presignedFlow(obj, source, destination, sessionToken, fileSize, chunkSize, verbose=options.verbose);
        if isempty(errorResponse)           
            cancel(abortIfFail);
        end
    else
        error("DATABRICKS:Files:bigUpload:NoProxyFlow", "The direct proxy workflow is not yet implemented.");
        % Experimental feature, supported on the Databricks data plane
        % only - future work if required.
        % [result, errorResponse] = proxyDirectFlow(obj, source, destination);
    end
end


function [result, errorResponse] = proxyDirectFlow(obj, source, destination, sessionToken, fileSize, chunkSize) %#ok<STOUT,DEFNU>
    arguments (Input)
        obj databricks.Files %#ok<INUSA>
        source string {mustBeFile} %#ok<INUSA>
        destination string {mustBeTextScalar, mustBeNonzeroLengthText} %#ok<INUSA>
        sessionToken string {mustBeTextScalar, mustBeNonzeroLengthText} %#ok<INUSA>
        fileSize (1,1) int64 {mustBeNonnegative} %#ok<INUSA>
        chunkSize (1,1) int64 {mustBeNonnegative} %#ok<INUSA>
    end
    arguments (Output)
        result (1,1) logical
        errorResponse
    end

    %  /api/2.0/fs/files/<escaped-path>?session_token=<token>&upload_type=multipart&part_number=<N> Content-Type: application/octet-stream Body: <raw bytes of part>
    %
    % skip create-upload-part-urls entirely. Instead, construct the upload URL by appending query parameters to a fixed proxy endpoint:
    % 
    % PUT http://storage-proxy.databricks.com/api/2.0/fs/files/Volumes/.../file.dat ?session_token={token}&upload_type=multipart&part_number={N}
    % 
    % The critical differences:
    % 
    % Auth is REQUIRED on every PUT (workspace Bearer token) — the opposite of presigned URLs
    % No URL expiration to manage — auth is validated live per request
    % No coordination API calls between parts — URLs are deterministic
    % Only works inside Databricks network (clusters, serverless, jobs) — the proxy hostname http://storage-proxy.databricks.com is only resolvable within the Databricks data plane
    % Still experimental — behind the experimental_files_ext_enable_storage_proxy config flag
    % 
    % The initiate (?action=initiate-upload) and complete (?action=complete-upload) calls remain identical and still go to workspace host. Only the per-part data transfer changes.
    % 
end


function [result, errorResponse] = presignedFlow(obj, source, destination, sessionToken, fileSize, chunkSize, options)
    arguments (Input)
        obj databricks.Files
        source string {mustBeFile}
        destination string {mustBeTextScalar, mustBeNonzeroLengthText}
        sessionToken string {mustBeTextScalar, mustBeNonzeroLengthText}
        fileSize (1,1) int64 {mustBeNonnegative}
        chunkSize (1,1) int64 {mustBeNonnegative}
        options.verbose (1,1) logical = true
    end
    arguments (Output)
        result (1,1) logical
        errorResponse
    end

    count = countParts(fileSize, chunkSize);
    [partURLresult, errorResponse] = requestPresignedPartURL(obj, destination, sessionToken, count);
    if ~isempty(errorResponse)
        disp(errorResponse);
        error("DATABRICKS:Files:bigUpload:requestPresignedPartURLFailed", "requestPresignedPartURL failed, count %d.", count);
    end
    uploadPartURLs = partURLresult.upload_part_urls;
    assert(numel(uploadPartURLs) == count, "Expected %d upload parts URLs.", count);

    uploadCompleteRequest = databricks.datastructures.files.UploadCompleteRequest;
    
    if options.verbose
        fprintf("Uploading: %s\n       to: %s in %d parts.\n", source, destination, count);
    end
    for n = 1:count
        if options.verbose 
            fprintf(".");
            if mod(n, 40) == 0
                fprintf("\n");
            end
        end
        [entry, errorResponse] = uploadDataPart(obj, uploadPartURLs(n), source, chunkSize);
        if ~isempty(errorResponse)
            fprintf("\n");
            disp(errorResponse);
            error("DATABRICKS:Files:bigUpload:uploadDataPartFailed", "uploadDataPart failed, part %d of %d", n, count);
        else
            uploadCompleteRequest.parts(end+1) = entry;
        end
    end
    fprintf("\n");

    [result, errorResponse] = completePartUpload(obj, uploadCompleteRequest, destination, sessionToken); 

    % Diagnostics
    if ~isempty(errorResponse)
        disp(errorResponse);
        fprintf(2, "completePartUpload failed.\n");
    end
end


function [result, errorResponse] = completePartUpload(obj, uploadCompleteRequest, destination, sessionToken)
    arguments (Input)
        obj databricks.Files
        uploadCompleteRequest (1,1) databricks.datastructures.files.UploadCompleteRequest
        destination string {mustBeTextScalar, mustBeNonzeroLengthText}
        sessionToken string {mustBeTextScalar, mustBeNonzeroLengthText}
    end
    arguments (Output)
        result (1,1) logical
        errorResponse
    end

    URI = obj.getURI('fs', 'files');
    [~, pathArray] = databricks.Files.escapePath(destination);
    URI.Path = [URI.Path, pathArray];
    URI.Query(end+1) = matlab.net.QueryParameter("action", "complete-upload");
    URI.Query(end+1) = matlab.net.QueryParameter("upload_type", "multipart");
    URI.Query(end+1) = matlab.net.QueryParameter("session_token", sessionToken);

    request = obj.getRequestMessage('POST');
    request.Body = matlab.net.http.MessageBody;
    request.Body.Payload = uploadCompleteRequest.getPayload();

    resp = request.send(URI, obj.HTTPOptions);

    if resp.StatusCode == matlab.net.http.StatusCode.OK
        result = true;
        errorResponse = databricks.datastructures.files.ErrorResponse.empty;
    else
        result = false;
        errorResponse = databricks.datastructures.files.ErrorResponse().fromJSON(resp.Body.Data);
    end
end


function abortUpload(obj, destination, sessionToken)
    arguments (Input)
        obj (1,1) databricks.Files
        destination string {mustBeTextScalar, mustBeNonzeroLengthText}
        sessionToken string {mustBeTextScalar, mustBeNonzeroLengthText}
    end

    vendor = lower(string(matlab.databricks.vendor.getVendorFromAPI()));
    if strcmpi(vendor, 'azure')
        % Not supported on Azure, cleanup is automatic based on blob
        % garbage collections
        return;
    elseif strcmpi(vendor, 'aws')
        % Clean up below, automatic after 7 days by default
    else
        error("databricks:files:bigUpload:NoAbort", "Abort mechanism not yet implemented for cloud vendor: %s", vendor);
    end

    URI = obj.getURI('fs', 'create-abort-upload-url');
    request = obj.getRequestMessage('POST');
    request.Body = matlab.net.http.MessageBody;

    s = struct;
    s.path = destination;
    s.session_token = sessionToken;
    s.expire_time = toRFC3339Z(datetime("now", "TimeZone", "UTC") + minutes(10));
    request.Body.Payload = jsonencode(s);
    
    resp = request.send(URI, obj.HTTPOptions);

    if resp.StatusCode == matlab.net.http.StatusCode.OK
        u = jsondecode(resp.Body.Data);
        assert(isfield(u, "abort_upload_url"));
        assert(isfield(u.abort_upload_url, "url"));
        deleteRequest = obj.getRequestMessage('DELETE');
        deleteRequest = setContentTypeOctetStream(deleteRequest);
        deleteRequest = removeAuthHeader(deleteRequest);
        deleteResponse = deleteRequest.send(u.abort_upload_url.url, obj.HTTPOptions);
        if deleteResponse.StatusCode == matlab.net.http.StatusCode.OK ...
           || deleteResponse.StatusCode == matlab.net.http.StatusCode.Created ...
           || deleteResponse.StatusCode == matlab.net.http.StatusCode.NoContent
            fprintf("Cleaning up partial upload.\n");
        else
            error("databricks:files:bigUpload:AbortDelete", "Clean up of partial uploads failed.");
        end
    else
        error("databricks:files:bigUpload:AbortPost", "Clean up of partial uploads failed.");
    end
end


function [result, errorResponse] = uploadDataPart(obj, uploadPartURL, source, chunkSize)
    arguments (Input)
        obj (1,1) databricks.Files
        uploadPartURL struct
        source string {mustBeFile}
        chunkSize (1,1) int64 {mustBeNonnegative}    
    end
    arguments (Output)
        result databricks.datastructures.files.UploadCompleteRequestEntry
        errorResponse
    end

    URI = matlab.net.URI(uploadPartURL.url);

    request = obj.getRequestMessage('PUT');
    request = removeAuthHeader(request);
    request = setContentTypeOctetStream(request);
    if isfield(uploadPartURL, "headers")
        for n = 1:numel(uploadPartURL.headers)
            request.Header(end+1) = matlab.net.http.field.GenericField(uploadPartURL.headers(n).name, uploadPartURL.headers(n).value);
        end
    end

    [fileID, errmsg] = fopen(source, 'r');
    if fileID == -1
        error("DATABRICKS:Files:bigUpload:uploadPartURL",...
            "Could not open file: %s\nMessage: %s", source, errmsg);
    end
    closeAfter = onCleanup(@() fclose(fileID));

    startPoint = (uploadPartURL.part_number-1)*chunkSize;
    fseek(fileID, startPoint, 'bof');
    [data, bytesRead] = fread(fileID, chunkSize, '*uint8'); %#ok<ASGLU>

    request.Body(1).Payload = data;

    if numel(data) == 0
        warning('off', 'MATLAB:http:BodyExpectedFor');
    end
    resp = request.send(URI, obj.HTTPOptions);
    if numel(data) == 0
        warning('on', 'MATLAB:http:BodyExpectedFor');
    end

    if resp.StatusCode == matlab.net.http.StatusCode.OK || resp.StatusCode == matlab.net.http.StatusCode.Created % 200 or 201
        result = databricks.datastructures.files.UploadCompleteRequestEntry;
        result.part_number = uploadPartURL.part_number;
        result.etag = extractEtag(resp);
        errorResponse = databricks.datastructures.files.ErrorResponse.empty;
    else
        result = databricks.datastructures.files.UploadCompleteRequestEntry.empty;
        errorResponse = databricks.datastructures.files.ErrorResponse().fromJSON(resp.Body.Data);
    end
end


function eTag = extractEtag(resp)
    arguments(Input)
        resp (1,1) matlab.net.http.ResponseMessage 
    end
    arguments(Output)
        eTag (1,1) string
    end

    vendor = lower(string(matlab.databricks.vendor.getVendorFromAPI()));
    if strcmpi(vendor, 'azure')
        eTag = "";
    elseif strcmpi(vendor, 'aws')
        eTag = "";
        for n = 1:numel(resp.Header)
            if strcmpi(resp.Header(n).Name, "etag")
                % Value includes quotes
                eTag = string(resp.Header(n).Value);
                break;
            end
        end
    else
        error("databricks:files:bigUpload:NoEtag",...
            "eTag extraction from response header field is not yet implemented for cloud vendor: %s", vendor);
    end
end


function n = countParts(fileSize, chunkSize)
    arguments (Input)
        fileSize (1,1) int64 {mustBeNonnegative}
        chunkSize (1,1) int64 {mustBeNonnegative}
    end
    arguments (Output)
        n (1,1) int64
    end

    if fileSize <= chunkSize
        n = int64(1);
    else
        n = idivide(fileSize, chunkSize, 'ceil');
    end
end


function [result, errorResponse] = requestPresignedPartURL(obj, destination, session_token, count, options)
    arguments (Input)
        obj databricks.Files
        destination string {mustBeTextScalar, mustBeNonzeroLengthText}
        session_token string {mustBeTextScalar, mustBeNonzeroLengthText}
        count (1,1) int32 {mustBePositive}
        options.ttlMinutes (1,1) int32 = int32(55)
    end
    arguments (Output)
        result
        errorResponse
    end
    request = obj.getRequestMessage('POST');
    URI = obj.getURI('fs', 'create-upload-part-urls');

    s = struct;
    s.path = destination;
    s.session_token = session_token;
    s.start_part_number = 1;
    s.count = count;
    s.expire_time = toRFC3339Z(datetime("now", "TimeZone", "UTC") + minutes(options.ttlMinutes));

    request.Body(1).Payload = jsonencode(s);

    resp = request.send(URI, obj.HTTPOptions);

    if resp.StatusCode == matlab.net.http.StatusCode.OK
        result = jsondecode(resp.Body.Data);
        errorResponse = databricks.datastructures.ErrorResponse.empty;
    else
        result = struct.empty;
        errorResponse = databricks.datastructures.ErrorResponse().fromJSON(resp.Body.Data);
    end
end


function request = removeAuthHeader(request)
    arguments (Input)
        request (1,1) matlab.net.http.RequestMessage
    end
    arguments (Output)
        request (1,1) matlab.net.http.RequestMessage
    end

    for n = 1:numel(request.Header)
        if isa(request.Header(n), "matlab.net.http.field.AuthorizationField")
            request.Header(n) = [];
            break;
        end
    end
end


function request = setContentTypeOctetStream(request)
    % Assumes it is preset to JSON or not set, TODO make more general &
    % detect more than one
    arguments (Input)
        request (1,1) matlab.net.http.RequestMessage
    end
    arguments (Output)
        request (1,1) matlab.net.http.RequestMessage
    end

    for n = 1:numel(request.Header)
        headerSet = false;
        if request.Header(n) == matlab.net.http.field.ContentTypeField('application/json')
            request.Header(n) = matlab.net.http.field.ContentTypeField('application/octet-stream');
            headerSet = true;
            break;
        end
    end
    if ~headerSet
        request.Header(end+1) = matlab.net.http.field.ContentTypeField('application/octet-stream');
    end
end


function s = toRFC3339Z(dt)
    arguments (Input)
        dt (1,1) datetime
    end
    arguments (Output)
        s (1,1) string
    end
    % convert to UTC and format
    dt.TimeZone = 'UTC';
    dt.Format = "yyyy-MM-dd'T'HH:mm:ss'Z'";
    s = string(dt);
end
