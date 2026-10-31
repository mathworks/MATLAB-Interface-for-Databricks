function result = dir(obj, path, options)
    % DIR List contents of a directory
    % Returns a struct array with file/folder information.
    % For folder/directory entries the size will be 0.
    % The size field is an int64, it may be empty.
    % The date field represents the last modified date and may be an empty
    % datetime.
    % Supports Volumes, DBFS & Workspace path types.
    %
    % Examples:
    %   io = databricks.internal.io.IO;
    %   result = io.dir("/Volumes/main/default/myvolume")
    %
    %   result = io.dir("/Users/user@example.com/")
    
    % Copyright 2026 The MathWorks, Inc.

    arguments
        obj (1,1) databricks.internal.io.IO
        path string {mustBeTextScalar, mustBeNonzeroLengthText}
        options.type (1,1) databricks.internal.io.FileSystemType
        options.verbose (1,1) logical = true
    end

    if isfield(options, "type")
        type = options.type;
    else
        type = obj.getType(path);
    end

    if isempty(type)
        error("DATABRICKS:IO:DIR:NOTYPE", "Filesystem type is required for: %s", path);
    end

    switch type
        case "VOLUMES"
            f = databricks.Files(obj.parentVarargin{:});
            filesList = f.list(path);
            if isa(filesList, 'databricks.datastructures.files.ErrorResponse')
                error("DATABRICKS:IO:DIR:VOLUMES:LISTFAILED", "Files list failed for: %s ", path);
            end
            result = filesList2CommonList(filesList);
        
        case "DBFS"
            d = databricks.DBFS(obj.parentVarargin{:});
            dbfsList = d.listFiles(stripDBFSScheme(path));
            if ~isa(dbfsList, 'databricks.datastructures.FileInfo')
                error("DATABRICKS:IO:DIR:DBFS:LISTFAILED", "DBFS listFiles failed for: %s ", path);
            end
            result = dbfsList2CommonList(dbfsList, getDBFSScheme(path));
            
        case "WORKSPACE"
            ws = databricks.Workspace(obj.parentVarargin{:});
            wsList = ws.list(path);
            if ~isa(wsList, 'databricks.datastructures.ObjectInfo')
                error("DATABRICKS:IO:DIR:WORKSPACE:LISTFAILED", "Workspace list failed for: %s ", path);
            end
            result = wsList2CommonList(wsList);

        otherwise
            error("DATABRICKS:IO:DIR:UNSUPPORTEDTYPE",...
                "Filesystem type: %s, is not supported by databricks.internal.io.IO.dir.", string(type))
    end
end



function result = dbfsList2CommonList(dbfsList, scheme)
    arguments (Input)
        dbfsList databricks.datastructures.FileInfo
        scheme (1,1) string {mustBeTextScalar, mustBeNonzeroLengthText}
    end
    arguments (Output)
        result struct
    end
    
    result = struct.empty;

    for n = 1:numel(dbfsList)
        if dbfsList(n).is_dir
            result(n).isDir = true;
            result(n).size = int64(0);
        else
            result(n).isDir = false;
            result(n).size = dbfsList(n).file_size;
        end
        result(n).date = dbfsList(n).modification_time;
        [p,f,e] = fileparts(dbfsList(n).path);
        result(n).name = string(f) + string(e);
        result(n).folder = strip(scheme + string(p), "right", "/");
    end
end


function result = wsList2CommonList(wsList)
    arguments (Input)
        wsList databricks.datastructures.ObjectInfo
    end
    arguments (Output)
        result struct
    end

    result = struct.empty;

    for n = 1:numel(wsList)
        if wsList(n).object_type == databricks.datastructures.ObjectType.DIRECTORY
            result(n).isDir = true;
            result(n).size = int64(0);
        else
            result(n).isDir = false;
            result(n).size = int64.empty;
        end
        result(n).date = datetime.empty;
        [p,f,e] = fileparts(wsList(n).path);
        result(n).name = string(f) + string(e);
        result(n).folder = string(p);
    end
end


function result = filesList2CommonList(filesList)
    arguments (Input)
        filesList databricks.datastructures.files.ListResponse
    end
    arguments (Output)
        result struct
    end

    result = struct.empty;

    if ~isprop(filesList, "contents")
        error("DATABRICKS:IO:DIR:FILESLIST2COMMONLIST:NOCONTENT",...
         "Expected databricks.datastructures.files.ListResponse content property not found.");
    end

    for n = 1:numel(filesList.contents)
        if filesList.contents(n).isDirectory
            result(n).isDir = true;
            [p,~,~] = fileparts(strip(filesList.contents(n).path, "right", "/"));
            result(n).name = string(filesList.contents(n).name);
            result(n).folder = string(p);
            result(n).size = int64(0);
        else
            result(n).isDir = false;
            [p,f,e] = fileparts(filesList.contents(n).path);
            result(n).name = string(f) + string(e);
            result(n).folder = string(p);
            result(n).size = int64(filesList.contents(n).fileSize);
        end
        if isprop(filesList.contents(n), "lastModified")
            result(n).date = filesList.contents(n).lastModified;
        else
            result(n).date = datetime.empty;
        end
    end
end


function result = stripDBFSScheme(path)
    arguments (Input)
        path string {mustBeTextScalar, mustBeNonzeroLengthText}
    end
    arguments (Output)
        result string {mustBeTextScalar, mustBeNonzeroLengthText}
    end

    if startsWith(path, "/dbfs/", IgnoreCase=true)
        result = extractAfter(path, 5);
    elseif startsWith(path, "dbfs:", IgnoreCase=true)
        result = extractAfter(path, 5);
    else
        result = path;
    end
end


function result = getDBFSScheme(path)
    arguments (Input)
        path string {mustBeTextScalar, mustBeNonzeroLengthText}
    end
    arguments (Output)
        result string {mustBeTextScalar, mustBeNonzeroLengthText}
    end

    if startsWith(path, "/dbfs/", IgnoreCase=true)
        result = extractBefore(path, 6);
    elseif startsWith(path, "dbfs:", IgnoreCase=true)
        result = extractBefore(path, 6);
    else
        result = "";
    end
end
