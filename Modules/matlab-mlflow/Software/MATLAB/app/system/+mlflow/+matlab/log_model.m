function model_info = log_model(options)
    %LOG_MODEL logs a MATLAB "model" as MLflow model.
    %
    % All inputs to the function are named inputs (or Name-Value pairs).
    %
    % mlflow.matlab.log_model(...,FunctionFile="myFunction.m") logs
    % specified function with "compiler_sdk_python" subflavor.
    %
    % mlflow.matlab.log_model(...,FunctionFile="myFunction.m",...
    %   PackageName="myPackage") also specifies the package name of the
    % Python package which will be generated. If not specified, defaults to
    % the same name as the MATLAB function.
    %
    % mlflow.matlab.log_model(...,FunctionFile="myFunction.m",...
    %       ExampleInputs={IN1,IN2,...}) 
    % also specifies example inputs. If provided (re)runs
    % compiler.build.mlflow.types.generateFunctionSignature with provided
    % inputs to (re)generate a signature YAML-file for the specified MATLAB
    % function. If not provided the signature YAML-file must already exist.
    %
    % mlflow.matlab.log_model(...,FunctionFile="myFunction.m",...
    %       ExampleInputs={IN1,IN2,...},ExampleOutputs={OUT1,OUT2,...}) 
    % also specifies example outputs when (re)running 
    % compiler.build.mlflow.types.generateFunctionSignature if input is
    % provided but output is not, the function will be executed with the
    % example inputs to determine the outputs.
    %
    % mlflow.matlab.log_model(...,FunctionFile="myFunction.m",...
    %       ExampleInputs={IN1,IN2,...},...,SaveExample=TF) 
    % include the example inputs in the saved model or not. Default true.
    %
    % mlflow.matlab.log_model(...,FunctionFile="myFunction.m",...
    %       AdditionalFiles={EXTRA1,EXTRA2,...}) 
    % includes additional files and directories EXTRA1 and EXTRA2 in the
    % generated Python Package. 
    %    
    % mlflow.matlab.log_model(...,Network=NET) logs provided Deep
    % Learning Network with "onnx" subflavor.
    %
    % mlflow.matlab.log_model(...,MATLABFiles=["file1.m","/path/directory"])
    % includes specified files and directories in the model. The main goal
    % for this is to add code/data which can later be loaded back into
    % MATLAB.
    %
    % mlflow.matlab.log_model(...,Subflavor=SUBFLAVOR) overrides the
    % automatically determined subflavor (see above). SUBFLAVOR must be:
    %   "none" - only includes MATLAB code specified through MATLABFiles
    %   "compiler_sdk_python" - compiles the file specified through
    %       FunctionFile into a MATLAB Compiler SDK Python Package and adds
    %       a pyfunc compatible wrapper around it. For more control on the
    %       generated package, it is possible to first manually use
    %       compiler.build.mlflow.pythonPackage and then use its log_model
    %       method instead of working with mlflow.matlab.log_model.
    %   "onnx" - exports the Deep Learning Network provided through Network
    %       in ONNX format then adds this ONNX as native MLflow ONNX flavor
    %       to the MLflow model.
    %   POSSIBLY FUTURE "coder" - compiles the file specified through
    %       FunctionFile into a MATLAB Coder generated C/C++ code and adds
    %       a pyfunc compatible wrapper around it.
    %
    % mlflow.matlab.log_model(...,Path="path/mymodel") specifies the 
    % artifact location where the model is to be logged. If not specified
    % defaults to "model". For optimal compatibility with downstream
    % MLflow deployment workflows it is recommended to work with the
    % default value.
    %
    % mlflow.matlab.log_model(...,MLflowOptions={NAME1,VAL1,NAME2,VAL2,...}) 
    % adds additional named arguments which will be passed along to the 
    % Python mlflow.matlab.log_model function.
    %
    % See Also compiler.build.mlflow.pythonPackage,
    % compiler.build.mlflow.types.generateFunctionSignature,
    % exportONNXNetwork
    
    % Copyright 2023 MathWorks, Inc.
    arguments
        options.?mlflow.matlab.internal.LogSaveInputs
    end
    model_info = mlflow.matlab.internal.log_save_model("log_model",options);