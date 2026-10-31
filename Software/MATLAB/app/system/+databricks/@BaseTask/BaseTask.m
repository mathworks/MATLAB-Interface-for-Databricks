classdef BaseTask < databricks.Object & matlab.mixin.Heterogeneous &  matlab.mixin.CustomDisplay
    % BASETASK Base class for Databricks tasks
    %
    % This abstract class serves as a base task for concrete Databricks
    % tasks, like SparkJarTask, SparkSubmitTask, NotebookTask., MATLABBatchTask
    % and MATLABRuntimeTask
    %
    % SparkSubmitTask is deprecated and should no longer be used see:
    % https://docs.databricks.com/aws/en/jobs/spark-submit
    % Existing support will be removed in a future release

    % Copyright 2021-2026 MathWorks, Inc.

    methods (Abstract)
        entries = getTaskEntries(obj)
    end

    methods(Hidden, Static)
        function out = shellEscape(in)
            arguments (Input)
                in string {mustBeTextScalar, mustBeNonzeroLengthText}
            end
            arguments (Output)
                out (1,1) string
            end

            % TODO To be validated
            
            in = databricks.BaseTask.escapeDoubleBackSlashes(in);
            out = databricks.BaseTask.escapeDoubleQuotes(in);
        end

        function out = escapeDoubleBackSlashes(in)
            % ESCAPEBACKSLASHES Escape \\ with \\\ for shell execution
            
            % TODO To be validated
            arguments (Input)
                in string {mustBeTextScalar, mustBeNonzeroLengthText}
            end
            arguments (Output)
                out (1,1) string
            end

            out = replace(in, "\\", "\\\");
        end


        function out = escapeDoubleQuotes(in)
            % ESCAPEDOUBLEQUOTES Escape " with \" for shell execution
            arguments (Input)
                in string {mustBeTextScalar, mustBeNonzeroLengthText}
            end
            arguments (Output)
                out (1,1) string
            end

            out = replace(in, '"', '\"');
        end


        function out = escapeSingleQuotes(in)
            % ESCAPESINGLEQUOTES Single quotes in the scalar string are escaped with slashes
            % not additional single quotes.
            % This is intended for use with shell commands.
            % Double quotes are not altered by this function.
            arguments (Input)
                in {mustBeTextScalar, mustBeNonzeroLengthText}
            end
            arguments (Output)
                out (1,1) string
            end

            out = replace(in, "'", "'\''");
        end
    end

    methods (Hidden)    
        function uri = notebookPath2URI(obj, options)
            arguments (Input)
                obj (1,1) databricks.BaseTask
                options.authMethod (1,1) matlab.databricks.AuthMethod
                options.profileName string {mustBeTextScalar, mustBeNonzeroLengthText} = databricks.internal.configurationprofile.ConfigFile.getDefaultProfileName
            end

            arguments (Output)
                uri (1,1) string
            end

            args = matlab.utils.addArgs(options, {'authMethod', 'profileName'});
            url = matlab.databricks.workspace.getNotebookLink(obj.notebook_path, args{:});
            uri = matlab.net.URI(url);
        end


        function link = notebookPath2Link(obj, options)
            arguments (Input)
                obj (1,1) databricks.BaseTask
                options.authMethod (1,1) matlab.databricks.AuthMethod
                options.profileName string {mustBeTextScalar, mustBeNonzeroLengthText} = databricks.internal.configurationprofile.ConfigFile.getDefaultProfileName
            end

            arguments (Output)
                link (1,1) string
            end

            args = matlab.utils.addArgs(options, {'authMethod', 'profileName'});
            [~, link] = matlab.databricks.workspace.getNotebookLink(obj.notebook_path, args{:});
        end
    end


    methods(Access = protected)
        function groups = getPropertyGroups(obj)
            % GETPROPERTYGROUPS Customize the display of task objects
            % Renders the Notebook URL as a clickable link
            if isscalar(obj)
                if isprop(obj, "notebook_url") && ~isempty(obj.notebook_url)
                    if ~isprop(obj, "notebook_link")
                        addprop(obj, "notebook_link");
                    end
                    obj.notebook_link = matlab.utils.URL2Link(obj.notebook_url);
                end
                groups = getPropertyGroups@matlab.mixin.CustomDisplay(obj);
            else
                % Nonscalar case: call superclass method
                groups = getPropertyGroups@matlab.mixin.CustomDisplay(obj);
            end
        end %function
    end %methods
end
