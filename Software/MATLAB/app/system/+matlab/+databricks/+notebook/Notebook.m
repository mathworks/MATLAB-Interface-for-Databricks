classdef Notebook < handle
    % Notebook - Helper class to create Databricks notebooks

    % Copyright 2024, The MathWorks Inc.

    properties
        % NotebookWriter
        NBW matlab.sparkutils.StringWriter
        Type (1,1) matlab.databricks.notebook.NotebookType = "PYTHON"
    end
    properties (SetAccess = private)
        CommentChar string
    end

    methods
        function obj = Notebook(options)
            arguments
                options.type matlab.databricks.notebook.NotebookType
                options.filename string
            end

            if isfield(options, 'filename')
                obj.NBW = matlab.sparkutils.StringWriter(options.filename);
            else
                % Temporary file
                obj.NBW = matlab.sparkutils.StringWriter();
            end
            if isfield(options, 'type')
                obj.Type = options.type;
            end

            init(obj);
        end

        function str = getString(obj)
            str = obj.NBW.getString();
        end

        function comment(obj, commentStr, varargin)
            arguments
                obj (1,1) matlab.databricks.notebook.Notebook
                commentStr (1,1) string
            end
            arguments (Repeating)
                varargin
            end

            SW = obj.NBW;

            SW.pf('%s%s\n', obj.CommentChar, sprintf(char(commentStr), varargin{:}));

        end

        function addShellSectionHeader(obj, sectionTitle, isTop)
            arguments
                obj (1,1) matlab.databricks.notebook.Notebook
                sectionTitle (1,1) string
                isTop (1,1) logical = false
            end

            SW = obj.NBW;
            if isTop
                obj.comment('Databricks notebook source');
            else
                SW.pf('\n');
                obj.comment('COMMAND ----------');
            end
            obj.comment('DBTITLE 1,%s\n', sectionTitle);
            obj.comment('MAGIC %%sh -e\n');
            obj.comment('MAGIC set -o pipefail\n');

        end

        function addShellSectionLine(obj, cmdStr, varargin)
            arguments
                obj (1,1) matlab.databricks.notebook.Notebook
                cmdStr (1,1) string
            end
            arguments (Repeating)
                varargin
            end

            SW = obj.NBW;

            obj.comment('MAGIC %s\n', sprintf(char(cmdStr), varargin{:}));

        end

        function addSectionHeader(obj, sectionTitle, isTop)
            arguments
                obj (1,1) matlab.databricks.notebook.Notebook
                sectionTitle (1,1) string
                isTop (1,1) logical = false
            end

            SW = obj.NBW;

            if isTop
                obj.comment('Databricks notebook source');
            else
                SW.pf('\n');
                obj.comment('COMMAND ----------');
            end

            obj.comment('DBTITLE 1,%s', sectionTitle);
        end

        function addSectionLine(obj, cmdStr, varargin)
            arguments
                obj (1,1) matlab.databricks.notebook.Notebook
                cmdStr (1,1) string
            end
            arguments (Repeating)
                varargin
            end

            SW = obj.NBW;

            SW.pf('%s\n', sprintf(char(cmdStr), varargin{:}));

        end

        function addSectionFromFile(obj, title, fileName, isTop)
            arguments
                obj (1,1) matlab.databricks.notebook.Notebook
                title (1,1) string
                fileName (1,1) string
                isTop (1,1) logical = false
            end

            if ~isfile(fileName)
                error("DATABRICKS:cluster_install", ...
                    "The file provided, %s, does not exist.\n", fileName);
            end

            obj.addSectionHeader(title, isTop);
            obj.addSectionLine('%s', fileread(fileName));

        end

        function addInstallMavenSection(obj, isTop, useAPT)
            arguments
                obj (1,1) matlab.databricks.notebook.Notebook
                isTop (1,1) logical = true
                useAPT(1,1) logical = false
            end

            if useAPT
                obj.addShellSectionHeader('Install Maven, if not already present', isTop);
                obj.addShellSectionLine('unset LD_LIBRARY_PATH');
                obj.addShellSectionLine('export DEBIAN_FRONTEND=noninteractive');
                obj.addShellSectionLine('apt-get -q update -y --allow-releaseinfo-change-origin -o APT::Update::Error-Mode=any -o Dir::Etc::SourceParts=/tmp/nonexistantDir');
                obj.addShellSectionLine('if [[ $? -ne 0 ]]; then echo "apt-get update failed, check internet access" 1>&2; exit 1; fi');
                obj.addShellSectionLine('apt-get -yq install maven');
            else
                obj.addShellSectionHeader('Install Maven, if not already present', isTop)
                obj.addShellSectionLine('unset LD_LIBRARY_PATH')
                obj.addShellSectionLine('if command -v mvn &> /dev/null; then')
                obj.addShellSectionLine('  echo "Maven is present"')
                obj.addShellSectionLine('else')
                obj.addShellSectionLine('  echo "Maven needs to be installed"')
                obj.addShellSectionLine('  mkdir -p /maven')
                obj.addShellSectionLine('  cd /maven')
                obj.addShellSectionLine('  DLURL="https://dlcdn.apache.org/maven/maven-3/3.9.6/binaries/apache-maven-3.9.6-bin.tar.gz"')
                obj.addShellSectionLine('  DLNAME=$(basename $DLURL)')
                obj.addShellSectionLine('  wget -q $DLURL')
                obj.addShellSectionLine('  tar xf $DLNAME')
                obj.addShellSectionLine('  rm $DLNAME')
                obj.addShellSectionLine('  cd /usr/local/bin')
                obj.addShellSectionLine('  ln -s /maven/apach*/bin/mvn')
                obj.addShellSectionLine('fi')
            end
        end

        function importNotebookToWorkspace(obj, wsPath, options)
            arguments
                obj (1,1) matlab.databricks.notebook.Notebook
                wsPath (1,1) string
                options.silent (1,1) logical = false
                options.authMethod (1,1) matlab.databricks.AuthMethod
                options.profileName string {mustBeTextScalar, mustBeNonzeroLengthText} = databricks.internal.configurationprofile.ConfigFile.getDefaultProfileName
            end

            args = matlab.utils.addArgs(options, ["authMethod", "profileName"]);
            ws = databricks.Workspace(args{:});

            wsnParts = wsPath.split("/");
            % nbName = wsnParts(end);
            wsnFolder = wsnParts(1:end-1).join("/");
            % wsnFolder = workspaceName.extractBefore("/" + nbName);

            try
                stat = ws.getStatus(wsnFolder); %#ok<NASGU>
            catch ME
                % The folder doesn't exist, create it
                ws.mkdirs(wsnFolder);
            end
            content = obj.getString();

            ws.import( ...
                'path',  wsPath, ...
                'language', string(obj.Type), ...
                'format', 'SOURCE', ...
                'content', content, ...
                'overwrite', true);

            if ~options.silent
                wsInfo = ws.getStatus(wsPath);
                url = sprintf("%s/?#notebook/%d", ws.Host, wsInfo.object_id);
                % Appears to work without the org id so can avoid touching the settings file
                % url = sprintf("%s/?o=%s#notebook/%d", cfg.host, cfg.org_id, wsInfo.object_id);
                fprintf('Open notebook: <a href="matlab: web(''%s'')">%s</a>\n', url, url);
            end
        end
    end

    methods (Access=private)
        function init(obj)
            switch obj.Type 
                case "PYTHON"
                    obj.CommentChar = "# ";
                case "SCALA"
                    obj.CommentChar = "// ";
            end
        end
    end
end