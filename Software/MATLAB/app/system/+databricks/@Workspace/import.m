function [result, errorResponse] = import(obj, options)
    % IMPORT Import a file into /Workspace
    % 
    % Required named arguments:
    %       path: The absolute path of the notebook or directory. Importing
    %             directory is only supported for DBC format. This field is required.
    %
    %   language: If format is set to SOURCE, this field is required, otherwise it
    %             will be ignored. Valid values are SCALA, PYTHON, SQL or R
    %             This argument is case sensitive.
    %
    %    content: Notebook content. This value has a size limit of 10MB. If the limit
    %             is exceeded an error is thrown. It will be base-64 encoded by this
    %             method. It should be scalar text.
    %
    %       file: If content is not set then a local file path for upload must be
    %             provided. The maximum supported file size is 500MB.
    %
    % Only one of file and content should be set at a time.
    %
    % Optional named arguments:
    %     format: Specifies the format of the file to be imported.
    %             It may be one of: SOURCE, HTML, JUPYTER, DBC, R_MARKDOWN, AUTO or RAW.
    %             The default value is SOURCE.
    %             Using AUTO is often preferable to SOURCE.
    %             This argument is case sensitive.
    %
    %
    %  overwrite: Logical that specifies whether to overwrite an existing object.
    %             For DBC format, overwrite is not supported since it may contain
    %             a directory. The default value is false. If path already exists
    %             and overwrite is set to false, this call errors with
    %             RESOURCE_ALREADY_EXISTS.
    %
    %
    % A non empty databricks.datastructures.ErrorResponse errorResponse indicates
    % an error.
    %
    % A logical true result indicates successful completion otherwise false is
    % expected.
    %
    %
    % Example
    %    % Import a string to a notebook
    %    ws = databricks.Workspace;
    %    [result, errorResponse] = ws.import('path', '/Users/joe@example.com/myPythonWS', ...
    %              'format', 'SOURCE', 'language', 'PYTHON', ...
    %              'content', 'print("Hello World")', 'overwrite', true);
    %
    %    % Import a local file to a notebook
    %    ws = databricks.Workspace;
    %    [result, errorResponse] = ws.import('path', '/Users/joe@example.com/myNotebook', ...
    %              'format', 'SOURCE', 'language', 'PYTHON', ...
    %              'file', '/myPath/myFile.py', 'overwrite', true);
    
    
    % Copyright 2020-2026 MathWorks Inc.

    arguments (Input)
        obj
        options.path string {mustBeTextScalar, mustBeNonzeroLengthText}
        options.language string {mustBeTextScalar, mustBeNonzeroLengthText}
        options.format string {mustBeTextScalar, mustBeNonzeroLengthText} = "SOURCE"
        options.content
        options.file string {mustBeFile}
        options.overwrite (1,1) logical = false
        options.verbose (1,1) logical = false
    end
    arguments (Output)
        result (1,1) logical
        errorResponse databricks.datastructures.ErrorResponse
    end

    % path is required
    if ~isfield(options, "path")
        error("DATABRICKS:WORKSPACE:IMPORT:NOPATH",...
            "A path named argument is required.");
    end

    if isfield(options, "file") && isfield (options, "content")
        error("DATABRICKS:WORKSPACE:IMPORT:FILEANDCONTENT",...
            "file and content cannot be used at the same time.");
    end

    [~, file, extension] = databricks.internal.io.IO.fileparts(options.path);
    if strlength(file) + strlength(extension) > 500
        error("DATABRICKS:WORKSPACE:IMPORT:LONGNAME",...
            "The object name must be 500 characters or less in length.");
    end

    pathEntries = split(options.path, "/");
    if numel(pathEntries) > 25+2 % add one for the initial "" and another for the filename
        error("DATABRICKS:WORKSPACE:IMPORT:BADPATH",...
            "The path argument may have at most 25 levels.");
    end

    % Get URI & Start a POST request
    URI = obj.getURI('workspace', 'import');
    request = obj.getRequestMessage('POST');

    s = struct; % s is used in the non file flow only, but the validation is common

    if ismember(options.format, ["SOURCE", "HTML", "JUPYTER", "DBC", "R_MARKDOWN", "AUTO", "RAW"])
        s.format =  options.format;
    else
        error("DATABRICKS:WORKSPACE:IMPORT:FORMAT",...
            "format must be of type scalar string or character vector and equal to SOURCE, HTML, JUPYTER, DBC, R_MARKDOWN, AUTO or RAW");
    end

    % If using SOURCE then the language must be set
    if strcmp(options.format, "SOURCE")
        if isfield(options, "language")
            if ismember(options.language, ["SCALA", "PYTHON", "SQL", "R"])
                s.language = char(options.language);
            else
                error("DATABRICKS:WORKSPACE:IMPORT:SOURCE",...
                    'When format is set to SOURCE (default) the language parameter must be set to one of SCALA, PYTHON, SQL or R');
            end
        end
    end    

    % If content parameter is used it must not be greater than 500MB
    % If not check that a file is provided and exists
    fileLimit = 500*10000000; % 500MB Workspace storage limit
    contentLimit = 10*1000000; % 10MB
    if isfield(options, "content")
        s.path = options.path;

        if options.overwrite
            s.overwrite = string(options.overwrite);
        end

        if ischar(options.content) && (isscalar(options.content) || isvector(options.content)) || isStringScalar(options.content)
            c = char(options.content);
            if numel(c) <= contentLimit
                s.content = matlab.net.base64('encode', uint8(c));
            else
                error("DATABRICKS:WORKSPACE:IMPORT:TOOBIGCHAR",...
                    "content size must be 10MB or less, use the file argument for content up to 500MB.");
            end
        else
            error("DATABRICKS:WORKSPACE:IMPORT:TOOBIGUINT8",...
                    "Content format not supported, expected scalar text or uint8 found: %s", class(options.content));
        end
        
        request.Body(1).Payload = jsonencode(s);
        resp = request.send(URI, obj.HTTPOptions);
        
    elseif isfield(options, "file")
        info = dir(options.file); % Existence checked on input
        nBytes = info.bytes;
        if nBytes > fileLimit
             error("DATABRICKS:WORKSPACE:IMPORT:TOOBIGCHAR",...
                    "file size must be 500MB or less.");
        end
        providerFields = {};
        % There has to be a destination path
        providerFields{end+1} = "path";
        providerFields{end+1} = options.path;
        
        % Python SDK only send this if set to true, non default
        if isfield(options, "overwrite") && options.overwrite
            providerFields{end+1} = "overwrite";
            providerFields{end+1} = string(options.overwrite);
        end

        if isfield(options, "format")
            providerFields{end+1} = "format";
            providerFields{end+1} = options.format;
        end
      
        fp = matlab.net.http.io.FileProvider(options.file);
        % This header requirement is not documented but aligns with how
        % the Databricks Python SDK builds the message
        fp.Header = matlab.net.http.field.ContentDispositionField("form-data", "filename", "content");
        fp.FileSize = nBytes;
        formProvider = matlab.net.http.io.MultipartFormProvider(providerFields{:}, "content", fp);
        formProvider.ForceChunked = false; % Does not mean that chunked will never be used
        request.Body = formProvider;
        [resp, ~, ~] = request.send(URI, obj.HTTPOptions);
    else
        error("DATABRICKS:WORKSPACE:IMPORT:NOCONTENTORFILE",...
                "Either a file a content argument must be specified.");
    end

    if resp.StatusCode == matlab.net.http.StatusCode.OK
        result = true;
        errorResponse = databricks.datastructures.ErrorResponse.empty;
    else
        result = false;
        errorResponse = databricks.datastructures.ErrorResponse().fromJSON(resp.Body.Data);
    end
end
