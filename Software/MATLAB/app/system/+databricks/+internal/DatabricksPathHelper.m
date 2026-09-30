classdef DatabricksPathHelper < handle
    % DatabricksPathHelper - Utility class for Databricks paths

    % Copyright 2024 The MathWorks, Inc.

    properties (SetAccess=private)
        Path (1,1) string
        FSType (1,1) databricks.internal.io.FileSystemType

        IsDBFS (1,1) logical = false
        IsABFSS (1,1) logical = false
        IsVolume (1,1) logical = false
        IsWorkspace (1,1) logical = false
        IsS3 (1,1) logical = false
    end

    methods
        function obj = DatabricksPathHelper(path_)
            obj.Path = path_;
            init(obj);
        end

        function ensureEndsWithSlash(obj)
            if ~obj.Path.endsWith("/")
                obj.Path = obj.Path + "/";
            end
        end

        function fixedPath = get(obj, options)
            % fixedPath Return the path
            % This method returns the path, and adds some options for
            % adapting the output.
            %
            %   stripDBFS will remove dbfs: or dbfs/ at beginning
            %   onlyFolder will return only the folder name
            %   onlyName will just return the file name (or last folder)
            
            arguments
                obj (1,1) databricks.internal.DatabricksPathHelper
                options.stripDBFS (1,1) logical = false
                options.onlyFolder (1,1) logical = false
                options.onlyName (1,1) logical = false
            end

            fixedPath = obj.Path;

            if options.onlyName
                fixedPath = regexp(fixedPath, '[^/]+$', 'match');
                return;
            end

            if options.stripDBFS
                if obj.IsDBFS
                    if fixedPath.startsWith("dbfs:")
                        fixedPath = regexprep(fixedPath, "dbfs:[/]+", "/");
                    elseif fixedPath.startsWith("/dbfs")
                        fixedPath = regexprep(fixedPath, "/dbfs[/]+", "/");
                    end
                end
            end

            if options.onlyFolder
                parts = fixedPath.split("/");
                fixedPath = parts(1:end-1).join("/");
            end
        end

        function dirPath = getDBFSDirPath(obj)
            arguments
                obj (1,1) databricks.internal.DatabricksPathHelper
            end
        
            if obj.IsDBFS
                if startsWith(obj.Path, "dbfs:/")
                    dirPath = strrep(obj.Path, "dbfs:/", "/dbfs/");
                elseif startsWith(obj.Path, "dbfs://")
                        dirPath = strrep(obj.Path, "dbfs://", "/dbfs/");
                elseif startsWith(obj.Path, "/dbfs/")
                    dirPath = obj.Path;
                else
                    error("DATABRICKS:DatabricksPathHelper:getDBFSDirPath", "Invalid path: %s", obj.Path);
                end
            else
                error("DATABRICKS:DatabricksPathHelper:getDBFSDirPath", "FSType must be DBFS");
            end
        end
    end

    methods (Access=private)
        function init(obj)
            if obj.Path.startsWith("/dbfs/") || obj.Path.startsWith("dbfs:")
                obj.FSType = "DBFS";
                obj.IsDBFS = true;
            elseif obj.Path.startsWith("abfss:")
                obj.FSType = "ABFSS";
                obj.IsABFSS = true;
            elseif obj.Path.startsWith("/Volumes/")
                obj.FSType = "Volumes";
                obj.IsVolume = true;
            elseif obj.Path.startsWith("/Users/")
                obj.FSType = "Workspace";
                obj.IsWorkspace = true;
            elseif obj.Path.startsWith("s3:")
                obj.FSType = "S3";
                obj.IsS3 = true;
            else
                error('DATABRICKS:PATHHELPER','Unknown File System Type: "%s"\n', obj.Path);
            end
        end
    end
end