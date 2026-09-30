classdef PythonSparkBuilder < handle
    % PythonSparkBuilder Class for compiling MATLAB files for Spark
    %
    % This class is a wrapper for the build process in different
    % SparkContexts. 
    % The base, and most important use case, is for building Python
    % libraries, with wrappers for making the code adhere to Spark APIs.
    %
    %  Please refer to the documentation delivered in this package for
    %  usage examples.
    
    % Copyright 2022-2026 The MathWorks, Inc.
    
    properties
    end

    properties (SetAccess = protected)
        BuildResults
        BuildOpts
        PkgName
        PkgFolder
        OutputDir
        SrcDir
        Files compiler.build.spark.File
        GenMatlabDir string
        HelperFiles string
        ExampleFiles 
        ZipArtifactName (1,1) string
        WheelDestination string = string.empty
        NotebookDestination  string = string.empty
    end

    properties(Hidden)
        PartialTables (1,1) logical = false
        TryCatch (1,1) logical = false
        TryCatchErrorColumn (1,1) string = ""
        Metrics (1,1) logical = false
        Debug   (1,1) logical = false
        Verbose (1,1) logical = false
        DebugPath (1,1) string

        versionTag string
        buildTag string
        platformsTag string
    end

    properties (SetAccess = protected, Hidden)
        PkgNameParts
        WrapperClassName
        CallCtx (1,1) compiler.build.spark.CallContext = compiler.build.spark.CallContext('None')
    end    

    properties (SetAccess = private, Hidden)
        SW matlab.sparkutils.StringWriter
        PyW matlab.sparkutils.PythonWriter
        MW matlab.sparkutils.MATLABWriter
    end


    methods
        function obj = PythonSparkBuilder(buildOpts, options)
            % PythonSparkBuilder Constructor
            %
            % See the help for compiler.build.spark.pythonPackage for an
            % explanation on arguments to this constructor. In general, the
            % pythonPackage function should be used instead of directly
            % instantiating this object.
            %
            % Argument:
            %  buildOpts - A required argument of type compiler.build.PythonPackageOptions
            %
            % Optional named arguments:
            %  versionTag - Version tag for the package, used in the .whl file name.
            %      Default: MATLAB version used to create the build, e.g. 26.1.0.
            %
            %  buildTag - Build tag for the package, used in the .whl file name.
            %      Default: not used, empty string.
            %
            %  partialTables - An option that makes it possible to use a table as input,
            %      that lacks certain columns. The functions compiled must be
            %      written to handle missing columns.
            %      Default: false
            %
            % tryCatch (experimental) - This option encloses the calling of the
            %      compiled function in a try/catch statement, and ensures that a
            %      job will not fail because one section fails in the MATLAB
            %      function. If the MATLAB function fails, an empty table will be
            %      returned, and some messages will be written to stderr, which can
            %      be found in the cluster-logs if turned on. Please note that this
            %      is a sort of "silent error" and should be used with caution.
            %      Default: false
            %
            % tryCatchErrorColumn (experimental) - This option is only active
            %      together with the tryCatch option. It can be used to return the
            %      error message when the compiled MATLAB function fails in a
            %      certain column. The column must exist in the output table and
            %      be of type string.
            %
            % wheelDestination - A string for the directory where the wheel file
            %      should be uploaded. This feature is currently only supported on
            %      Databricks. It will create a %pip install line in the example
            %      python files/notebooks that are generated, and can be used with
            %      the uploadWheel method.
            %
            % notebookDestination - A string for the directory where
            %      notebook example files should be uploaded. This feature
            %      is currently only supported on Databricks. The
            %      uploadExampleNotebooks method will automatically upload
            %      the notebooks to this directory if no argument is
            %      specified.

            % debug - Internal development option. Undocumented.
            %
            % platformsTag - Internal development option. Undocumented. Currently
            %      not processed correctly by setup process.

            arguments
                buildOpts (1,1) compiler.build.PythonPackageOptions
                
                options.versionTag string = string.empty
                options.buildTag string = string.empty
                options.platformsTag string = string.empty

                options.partialTables (1,1) logical = false
                options.debug (1,1) logical = false
                options.tryCatch (1,1) logical = false
                options.tryCatchErrorColumn (1,1) string = ""
                options.wheelDestination string = string.empty
                options.notebookDestination  string = string.empty
            end

            obj.BuildOpts = buildOpts;
            obj.PartialTables = options.partialTables;
            obj.TryCatch = options.tryCatch;
            obj.TryCatchErrorColumn = options.tryCatchErrorColumn;
            obj.Debug = options.debug;

            obj.versionTag = options.versionTag;
            obj.buildTag = options.buildTag;
            obj.platformsTag = options.platformsTag;
            
            if ~isempty(options.wheelDestination)
                if isDatabricksEnvironment()
                    obj.WheelDestination = options.wheelDestination;
                else
                    warning("SPARKAPI:WHEELDESTINATION:PLATFORMS", ...
                        "The WheelDestination property currently only has an effect on " + ...
                        "the Databricks platform. In this environment, it will have no effect.");
                end
            end

            if ~isempty(options.notebookDestination)
                if isDatabricksEnvironment()
                    obj.NotebookDestination = options.notebookDestination;
                else
                    warning("SPARKAPI:NOTEBOOKDESTINATION:PLATFORMS", ...
                        "The NotebookDestination property currently only has an effect on " + ...
                        "the Databricks platform. In this environment, it will have no effect.");
                end
            end

            if obj.TryCatch
                warning("SPARKAPI:TRYCATCH:SILENTERROR", ...
                    "You have turned on the 'TryCatch' option for the build. " + ...
                    "This can be very useful, but it should be noted that this is " + ...
                    "silent error. If a part of the dataframe cannot be " + ...
                    "calculated (throws an error), this will return a table " + ...
                    "with no rows, or a table with one row and an error message. " + ...
                    "Please be aware that this can silently hide errors. Use with care!");
            end
            
            init(obj);
        end

        function addFile(obj, file)
            if isa(file, 'compiler.build.spark.File')
                F = file;
            else
                if iscell(file)
                    F = compiler.build.spark.PythonFile(file{:});
                else
                    [~, args, compilerType]  = compiler.build.spark.types.getFileArgumentInfo(file);
                    if ~isempty(compilerType)
                        fprintf("### Using schema for datatype info for function %s.\n", compilerType.FuncName);
                        F = compiler.build.spark.PythonFileV2(compilerType);
                        if obj.TryCatch
                            if strlength(obj.TryCatchErrorColumn) > 0
                                % If using the TryCatchErrorColumn, the
                                % column must be present in the output.
                                outputNames = F.getOutputNames();
                                colIdx = find(obj.TryCatchErrorColumn == outputNames, 1);
                                if ~isempty(colIdx) 
                                    outputElems = F.getOutputElements();
                                    colType = outputElems(colIdx);
                                    if colType.type ~= "string"
                                        colIdx = [];
                                    end
                                end
                                if isempty(colIdx)
                                    error("SPARKAPI:TRYCATCHERRORCOLUMN:BADCOLUMNNAME", ...
                                        "This build is configured with TryCatchErrorColumn and must have " + ...
                                        "an output column with the given name and type string. " + ...
                                        "This is not the case, so the build is stopped.")
                                end
                            end
                        end
                    elseif isempty(args)
                        error('SPARKAPI:missing_schema_file', ...
                            'There must be a signature file for every file to be compiled. This is not the case for %s', file);
                    else

                        % Using the older JSON schema
                        fprintf(2, "### Using JSON signature file for datatype info for function %s.\n", file);
                        fprintf(2, "### Please note that these signature files have been deprecated.\n");
                        fprintf(2, "### Please consider instead using schema files\n");
                        fprintf(2, "### See <matlab-databricks/Modules/matlab-spark-api/Documentation/FunctionSchemas.md>\n");
                        fprintf(2, "### and <matlab-databricks/Modules/matlab-spark-api/Documentation/PythonSparkBuilder.md>\n");
                        if obj.PartialTables
                            error("SPARKAPI:partial_table_with_json", ...
                                "Using the PartialTables feature is only supported when using schema files instead of JSON signature file.\n" + ...
                                "See <matlab-databricks/Modules/matlab-spark-api/Documentation/FunctionSchemas.md>\n")
                        end
                        if obj.TryCatch
                            error("SPARKAPI:TRYCATCHERRORCOLUMN:OLDSCHEMATYPE", ...
                                "Using the TryCatch feature is only supported when using schema files instead of JSON signature file.\n" + ...
                                "See <matlab-databricks/Modules/matlab-spark-api/Documentation/FunctionSchemas.md>\n")
                        end
                        F = compiler.build.spark.PythonFile(file, args{:});
                    end
                end
            end

            F.Parent = obj;
            obj.Files(end+1) = F;
        end

        function setStringWriter(obj, SW)
            obj.SW = SW;
        end
        function clearStringWriter(obj)
            if isvalid(obj.SW)
                obj.SW.delete();
            end
            obj.SW = matlab.sparkutils.StringWriter.empty;
        end
        function setPythonWriter(obj, PyW)
            obj.PyW = PyW;
        end
        function clearPythonWriter(obj)
            obj.PyW = matlab.sparkutils.PythonWriter.empty;
        end
        function setMATLABWriter(obj, MW)
            obj.MW = MW;
        end
        function clearMATLABWriter(obj)
            obj.MW = matlab.sparkutils.MATLABWriter.empty;
        end

        function deleter = setScopedCallContext(obj, cc)
            % setScopedCallContext Set call context
            % Returns a variable, which is a onCleanup object which resets
            % the context afterwards

            arguments
                obj (1,1) compiler.build.spark.PythonSparkBuilder
                cc (1,1) string
            end

            curCC = obj.CallCtx;
            obj.setCallCtx(cc);
            deleter = onCleanup(@() obj.setCallCtx(curCC));

        end

        function use = useMetrics(obj, ~)
            % useMetrics Helper method to decide if to use Metrics
           
            use = obj.Metrics;
        end
    end

    methods (Access = protected)
        function init(obj)
            obj.PkgName = string(obj.BuildOpts.PackageName);
            obj.PkgNameParts = split(obj.PkgName, ".");

            obj.OutputDir = string(obj.BuildOpts.OutputDir);
            
            parts=split(obj.PkgName, ".");
            N = length(parts);
            srcDir = obj.OutputDir;
            for k=1:N
                srcDir = fullfile(srcDir, parts(k));
            end
            obj.SrcDir = srcDir;

            funcFiles = obj.BuildOpts.FunctionFiles;
            for k=1:length(funcFiles)
                obj.addFile(funcFiles{k});
            end
        end

        function setCallCtx(obj, cc)
            obj.CallCtx = cc;
        end

        function [raw, args]  = getFileArguments(~, file)
            raw = struct.empty;
            args = {};
            helpText = help(file);
            tok=regexp(helpText, '@SB-Start@(.+)@SB-End@', 'tokens', 'once');
            if ~isempty(tok)
                % First try JSON
                try
                    raw = jsondecode(tok{1});
                catch ex
                    % Evidently, this isn't JSON
                end
                if isempty(raw) && hasYAMLParser()
                    try
                        raw = matlab.sparkutils.internal.yamldecode('string', tok{1});
                    catch ex
                        % Evidently, this isn't YAML
                    end
                end
                if isfield(raw, 'InTypes') && isfield(raw, 'OutTypes')
                    args = {raw.InTypes, raw.OutTypes};
                end
            end
            if isempty(raw)
                % If datatype information is not in the comments, it may be
                % in an external JSON file 
                jsonFileName = compiler.build.spark.internal.getJSONName(file);
                if isfile(jsonFileName)
                    raw = jsondecode(fileread(jsonFileName));
                    args = {raw.InTypes, raw.OutTypes};
                end

            end

        end
        
    end
    
    
end

function ok = hasYAMLParser()
    ok = exist('mx_yaml', 'file') ~= 0;
end
