function model_info = log_save_model(operation,options)
    %LOG_SAVE_MODEL internal function
    
    % Copyright 2023-2025 MathWorks, Inc.
    arguments
        operation string {mustBeMember(operation,["save_model","log_model"])}
        options mlflow.matlab.internal.LogSaveInputs
    end

    if isempty(options.SubFlavor)
        if ~isempty(options.Network)
            options.SubFlavor = "onnx";
        elseif ~isempty(options.FunctionFile)
            options.SubFlavor = "compiler_sdk_python";
        elseif ~isempty(options.MATLABFiles)
            options.SubFlavor = "none";
        else
            error("Either (Network or FunctionFile) and/or MATLABFiles must be specified. " + ...
                "Without this there is nothing to save.")
        end
    end

    switch options.SubFlavor
        case "onnx"
            model_info = save_onnx(operation,options);
        case "compiler_sdk_python"
            model_info = save_compiler_sdk_python(operation,options);
        case "none"
            model_info = save_matlab_only(operation,options);
        case "coder"
    end

function model_info = save_matlab_only(operation,options)
    mlflowopts = options.MLflowOptions;
    location = getPath(operation,options);
    mlpath = py.list(cellstr(options.MATLABFiles));
    switch operation
        case "save_model"
            model_info = py.matlab_mlflow.save_model(location,pyargs(...
                mlflowopts{:}, ...
                'matlab_release',['r' version('-release')],...
                'sub_flavor',"none", ...
                'matlab_path',mlpath));            
        case "log_model"
            if ~isempty(options.RegisteredModelName)
                mlflowopts{end+1} = 'registered_model_name';
                mlflowopts{end+1} = options.RegisteredModelName;
            end
            model_info = py.matlab_mlflow.log_model(location,pyargs(...
                mlflowopts{:}, ...
                'matlab_release',['r' version('-release')],...
                'sub_flavor',"none", ...
                'matlab_path',mlpath));            
    end


function destination = getPath(operation,options)
    switch operation
        case "save_model"
            if isempty(options.Path)
                error("An destination Path must be specified when saving models.")
            else
                destination = options.Path;
            end
        case "log_model"
            if isempty(options.Path)
                destination = "model";
            else
                destination = options.Path;
            end
    end

function model_info = save_compiler_sdk_python(operation,options)
    % If example inputs provided regenerated YAML-filem otherwise assume
    % YAML-file exists already
    input = options.FunctionFile;
    destination = getPath(operation,options);

    if ~isempty(options.ExampleInputs) 
        if ~isempty(options.ExampleOutputs)
            compiler.build.mlflow.types.generateFunctionSignature( ...
                input, ...
                options.ExampleInputs, ...
                'ExactDimensions',options.ExactDimensions,...
                'SaveExample',options.SaveExample, ...
                'NParams',options.NParams,...
                'OUT',options.ExampleOutputs)
        else
            compiler.build.mlflow.types.generateFunctionSignature( ...
                input, ...
                options.ExampleInputs, ...
                'ExactDimensions',options.ExactDimensions,...
                'SaveExample',options.SaveExample, ...
                'NParams',options.NParams)        
        end
    end
    if isempty(options.PackageName)
        [~,options.PackageName] = fileparts(which(input));
    end
    opts = compiler.build.mlflow.PythonPackageOptions( ...
        which(input), ...
        'AdditionalFiles',options.AdditionalFiles, ...
        'PackageName',options.PackageName, ...
        'OutputDir',"build/" + options.PackageName);
    r = compiler.build.mlflow.pythonPackage(opts);

    mlflowopts = options.MLflowOptions;

    if (options.IncludeMPSCTF)
        mpsctf = compiler.build.productionServerArchive(which(input),...
            'AdditionalFiles',options.AdditionalFiles, ...            
            'OutputDir', "build/mps");
        mlflowopts{end+1} = 'mps_ctf';
        mlflowopts{end+1} = mpsctf.Files{1};
    end

    if ~isempty(options.MATLABFiles)
        mlflowopts{end+1} = 'matlab_path';
        mlflowopts{end+1} = py.list(cellstr(options.MATLABFiles));
    end

    mlflowopts{end+1} = 'include_matlab_mlflow_module';
    mlflowopts{end+1} = options.IncludeMATLABMLflowModule;
    
    switch operation
        case "save_model"
            model_info = r.save_model(destination,mlflowopts{:});
        case "log_model"
            if ~isempty(options.RegisteredModelName)
                mlflowopts{end+1} = 'registered_model_name';
                mlflowopts{end+1} = options.RegisteredModelName;
            end            
            model_info = r.log_model(destination,mlflowopts{:});
    end

function model_info = save_onnx(operation,options)
    input = options.Network;
    destination = getPath(operation,options);

    t = tempname;
    exportONNXNetwork(input,t);

    mlflowopts = options.MLflowOptions;

    if ~isempty(options.MATLABFiles)
        mlflowopts{end+1} = 'matlab_path';
        mlflowopts{end+1} = py.list(cellstr(options.MATLABFiles));
    end

    switch operation
        case "save_model"
            model_info = py.matlab_mlflow.save_model(destination,pyargs(...
                mlflowopts{:},...
                'onnx_path',t,...
                'sub_flavor',"onnx"));
        case "log_model"
            if ~isempty(options.RegisteredModelName)
                mlflowopts{end+1} = 'registered_model_name';
                mlflowopts{end+1} = options.RegisteredModelName;
            end            
            model_info = py.matlab_mlflow.log_model(destination,pyargs(...
                mlflowopts{:},...
                'onnx_path',t,...
                'sub_flavor',"onnx"));
    end
