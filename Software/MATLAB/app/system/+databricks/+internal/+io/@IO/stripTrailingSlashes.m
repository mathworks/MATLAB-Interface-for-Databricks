function path = stripTrailingSlashes(path, options)
    % STRIPTRAILINGSLASHES Strips redundant trailing slashes from paths
    %
    % Example:
    %   path = databricks.internal.io.IO.stripTrailingSlashes("/Volumes/main/default/mydir///");

    %   (c) 2025-2026 The MathWorks, Inc.

    arguments
        path string {mustBeTextScalar, mustBeNonzeroLengthText}
        options.slash (1,1) string {mustBeTextScalar, mustBeMember(options.slash, {'/', '\'})}
        options.type string {mustBeTextScalar, mustBeNonzeroLengthText}
    end

    if isfield(options, "type")
        type = options.type;
    else
        type = databricks.internal.io.IO.getType(path, verbose=false);
        if isempty(type)
            if startsWith(path, "\\")
                type = "UNC";
            elseif startsWith(path, "/")
                type = "LOCALUNIX";
            elseif startsWith(path, lettersPattern(1) + ":\")
                type = "LOCALPC";
            else
                error("STRIPTRAILINGSLASHES:UNKNOWN1", "Could not determine type of path: %s", path)
            end
        else
            type = string(type);
        end
    end

    if isfield(options, "slash")
        slash = options.slash;
    else
        switch upper(type)
            case {"LOCALPC", "UNC"}
                slash = "\";

            otherwise
                slash = "/";
        end
    end
    
    switch upper(type)
        case "LOCALPC"
            path = stripLocalPC(path, slash);

        case "UNC"
            path = stripUNC(path, slash);

        case "LOCALUNIX"
            path = stripLocalUnix(path, slash);
        
        case "S3"
            path = stripS3(path, slash);

        case "ABFSS"
            path = stripABFSS(path, slash);

        case "VOLUMES"
            path = stripVolumes(path, slash);

        case "WORKSPACE"
            path = stripWorkspaces(path, slash);

        case "DBFS"
            path = stripDBFS(path, slash);

        otherwise
            error("STRIPTRAILINGSLASHES:UNKNOWN2", "Unexpected type of path: %s", path)
    end
end


function path = stripDBFS(path, slash)
    % STRIPDBFS Function to strip trailing slashes from a given DBFS path
    %
    % Examples:
    %   dbfs://mydir
    %   /dbfs/
    
    % Check if the path starts with the Unix DBFS prefix
    if startsWith(lower(path), "/dbfs/")
        % Treat as a local Unix path
        path = stripLocalUnix(path, slash);
    % Check if the path starts with the DBFS scheme
    elseif startsWith(lower(path), "dbfs://")
        cutOff = 7; % Length of the DBFS scheme to cut off
        cPath = char(path);
        % Remove trailing slashes from the path
        while endsWith(cPath, slash) && strlength(cPath) > cutOff
            cPath(end) = [];
        end
        path = string(cPath); % Convert back to string
    else
        % Raise an error for unexpected path schemes
        error("STRIPTRAILINGSLASHES:STRIPDBFS", "Unexpected scheme for path: %s", path)
    end
end


function path = stripWorkspaces(path, slash)
    % STRIPWORKSPACES  Remove trailing /s from Unity Catalog Workspace paths
    %
    % Examples:
    %   /Workspaces/users/joe@example.com/
    
    % Treat as a local Unix path
    path = stripLocalUnix(path, slash);
end

function path = stripVolumes(path, slash)
    % STRIPVOLUMES Remove trailing /s from Unity Catalog /Volumes paths
    %
    % Examples:
    %   /Volumes/mycatalog/myschema
    %   /Volumes/mycatalog/myschema/
    %   /Volumes/mycatalog/myschema/mydir/
    %   /Volumes/mycatalog/myschema/mydir//
    %   /Volumes/mycatalog/myschema//

    arguments
        path string {mustBeTextScalar, mustBeNonzeroLengthText}
        slash (1,1) string {mustBeTextScalar, mustBeMember(slash, {'/'})}
    end

    idx = strfind(path, "/");

    if ~startsWith(lower(path), "/volumes/")
        fprintf(2, "Invalid /Volumes path: %s\n", path);
        return;
    end

    if numel(idx) >= 4
        if endsWith(path, slash)
            cPath = char(path);
            while endsWith(cPath, slash) && strlength(cPath) > idx(4)
                cPath(end) = [];
            end
            path = string(cPath);
        end
    end
end


function path = stripABFSS(path, slash)
    % STRIPABFSS remove trailing slashes in abfss paths
    % Sample: abfss://<container-name>@<storage-account-name>.dfs.core.windows.net/<path-to-data>"
    arguments
        path string {mustBeTextScalar, mustBeNonzeroLengthText}
        slash (1,1) string {mustBeTextScalar, mustBeMember(slash, {'/'})}
    end

    if ~endsWith(path, slash)
        return;
    end
    
    % Simpler to just count hte existing "/"
    % containerNameCharsPat = characterListPattern("abcdefghijklmnopqrstuv1234567890-_");
    % containerNamePat = containerNameCharsPat(3,63);
    % storageACCharsPat = characterListPattern("abcdefghijklmnopqrstuv1234567890");
    % storageACPat = storageACCharsPat(3,24);
    % schemePat = caseInsensitivePattern("abfss://");
    % identifier = asManyOfPattern(alphanumericsPattern(1) | "_", 1);
    % identifier = maskedPattern(identifier);
    % subdomain = asManyOfPattern(identifier + ".") + identifier;
    % domainName = namedPattern(identifier,"domainName");
    % domain = optionalPattern(namedPattern(subdomain) + ".") + domainName;
    % fullPat = schemePat + containerNamePat + "@" + storageACPat + "." + domain + "/";
    % 
    % pathSubStr = extractAfter(path, fullPat);
    % acSubStr = extractBefore(path, strlength(path) - strlength(pathSubStr));

    idx = strfind(path, "/");

    if ~startsWith(lower(path), "abfss://")
        fprintf(2, "Invalid abfss path: %s\n", path);
        return;
    end

    if numel(idx) >= 3
        cPath = char(path);
        while endsWith(cPath, slash) && strlength(cPath) > idx(3)
            cPath(end) = [];
        end
        path = string(cPath);
    end
end


function path = stripS3(path, slash)
    arguments
        path string {mustBeTextScalar, mustBeNonzeroLengthText}
        slash (1,1) string {mustBeTextScalar, mustBeMember(slash, {'/'})}
    end

    if endsWith(path, slash)
        cPath = char(path);
        if startsWith(lower(path), "s3://")
            cutOff = 5;
        elseif startsWith(lower(path), "s3a://")
            cutOff = 6;
        else
            error("STRIPTRAILINGSLASHES:STRIPS3", "Unexpected scheme for path: %s", path)
        end

        while endsWith(cPath, slash) && strlength(cPath) > cutOff
            cPath(end) = [];
        end
        path = string(cPath);
    end
end


function path = stripLocalUnix(path, slash)
    arguments
        path string {mustBeTextScalar, mustBeNonzeroLengthText}
        slash (1,1) string {mustBeTextScalar, mustBeMember(slash, {'/'})}
    end

    if endsWith(path, slash)
        cPath = char(path);
        while endsWith(cPath, slash) && strlength(cPath) > 1
            cPath(end) = [];
        end
        path = string(cPath);
    end
end


function path = stripUNC(path, slash)
    arguments
        path string {mustBeTextScalar, mustBeNonzeroLengthText}
        slash (1,1) string {mustBeTextScalar, mustBeMember(slash, {'\'})}
    end

    if endsWith(path, slash)
        cPath = char(path);
        while endsWith(cPath, slash) && strlength(cPath) > 2
            cPath(end) = [];
        end
        path = string(cPath);
    end
end


function path = stripLocalPC(path, slash)
    arguments
        path string {mustBeTextScalar, mustBeNonzeroLengthText}
        slash (1,1) string {mustBeTextScalar, mustBeMember(slash, {'\'})}
    end

    if endsWith(path, slash)
        cPath = char(path);
        while endsWith(cPath, slash) && strlength(cPath) > 3
            cPath(end) = [];
        end
        path = string(cPath);
    end
end
