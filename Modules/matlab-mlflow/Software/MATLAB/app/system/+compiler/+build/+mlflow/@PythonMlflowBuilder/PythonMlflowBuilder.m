classdef PythonMlflowBuilder < handle
    % PythonMlflowBuilder Builder class for building MATLAB Compiler SDK
    % Python packages which are then specifically to be used in mlflow
    % MATLAB flavor models.

    % Copyright 2023 MathWorks, Inc.
    properties
        BuildOptions
        BuildResults
    end

    properties (Access=private)
        YAMLFile
        YAML
        ExampleFile
        Signature
        MainFunction
        InArgs
        OutArgs
        RequiredMCRProductNames
    end
    methods
        function obj = PythonMlflowBuilder(buildOpts)
            arguments
                buildOpts compiler.build.mlflow.PythonPackageOptions
            end
            % Store original build options
            obj.BuildOptions = buildOpts;
            % Clean the output directory
            [~] = rmdir(obj.BuildOptions.OutputDir,'s');
            % Find the main function
            [~,obj.MainFunction] = fileparts(buildOpts.FunctionFiles{1});
            % Load metadata from corresponding YAML-file
            [obj.YAMLFile,obj.ExampleFile] = compiler.build.mlflow.internal.getYAMLName(buildOpts.FunctionFiles{1});
            obj.YAML = py.yaml.safe_load(fileread(obj.YAMLFile));
            % Get the signature from the metadata
            m = py.importlib.import_module('mlflow.models');
            obj.Signature = m.ModelSignature.from_dict(obj.YAML.get('signature'));
            % Determine function in- and output names
            [obj.InArgs,obj.OutArgs] = compiler.build.mlflow.internal.getArgNames(buildOpts.FunctionFiles{1});

            % TODO verify that MATLAB and signature arguments match
        end


        function build(obj)
            % Generate the MATLAB wrapper
            mlwrapper = generateMATLABWrapper(obj);
            if (obj.BuildOptions.Debug)
                disp(mlwrapper);
            end
            % Add it to the Python Build options
            obj.BuildOptions.FunctionFiles{end+1} = mlwrapper;
            % Build the Python package using Compiler SDK
            obj.BuildResults = compiler.build.pythonPackage(obj.BuildOptions);
            % Add the Python wrapper to the generated package
            pywrapper = generatePythonWrapper(obj);
            if (obj.BuildOptions.Debug)
                disp(pywrapper);
            end
            % Add RequiredMCRProductNames
            try
                prodNums = readmatrix(fullfile(obj.BuildOptions.OutputDir,"requiredMCRProducts.txt"),'Delimiter','\t');
                pcmn = compiler.internal.package.docker.Constants.ProductComponentModuleNavigator;
                obj.RequiredMCRProductNames = arrayfun(@(x)string(pcmn.productInfo(x).extPName),prodNums);
            catch
                warning("Unable to determine required MCR Product Names.")
            end

            if (~obj.BuildOptions.Debug)
                rmdir(fileparts(mlwrapper),'s');
            end
        end

        function model_info = save_model(obj,location,varargin)
            [~] = rmdir(location,'s');
            if isfile(obj.ExampleFile) && ~isempty(obj.YAML.get('saved_input_example_info'))
                varargin{end+1} = 'input_example_path';
                varargin{end+1} = fileparts(obj.ExampleFile);
                varargin{end+1} = 'input_example_info';
                varargin{end+1} = obj.YAML.get('saved_input_example_info');
            end
            filelist = py.list(obj.BuildResults.Files(1));
            if ~isempty(obj.RequiredMCRProductNames)
                varargin{end+1} = 'requiredMCRProductNames';
                varargin{end+1} = cellstr(obj.RequiredMCRProductNames);
            end
            model_info = py.matlab_mlflow.save_model(location,pyargs(...
                varargin{:}, ...
                'matlab_release',['r' version('-release')],...
                'sub_flavor',"compiler_sdk_python", ...
                'python_path',filelist, ...
                'package_name',obj.BuildResults.Options.PackageName, ...
                'signature',obj.Signature, ...
                'requiredMCRProducts',fullfile(obj.BuildOptions.OutputDir,"requiredMCRProducts.txt")));
        end

        function model_info = log_model(obj,location,varargin)
            [~] = rmdir(location,'s');
            if isfile(obj.ExampleFile) && ~isempty(obj.YAML.get('saved_input_example_info'))
                varargin{end+1} = 'input_example_path';
                varargin{end+1} = fileparts(obj.ExampleFile);
                varargin{end+1} = 'input_example_info';
                varargin{end+1} = obj.YAML.get('saved_input_example_info');
            end
            filelist = py.list(obj.BuildResults.Files(1));
        
            if ~isempty(obj.RequiredMCRProductNames)
                varargin{end+1} = 'requiredMCRProductNames';
                varargin{end+1} = cellstr(obj.RequiredMCRProductNames);
            end            
            model_info = py.matlab_mlflow.log_model(location,pyargs(...
                varargin{:}, ...
                'matlab_release',['r' version('-release')],...                
                'sub_flavor',"compiler_sdk_python", ...
                'python_path',filelist, ...
                'package_name',obj.BuildResults.Options.PackageName, ...
                'signature',obj.Signature, ...
                'requiredMCRProducts',fullfile(obj.BuildOptions.OutputDir,"requiredMCRProducts.txt")));
        end       

    end

end