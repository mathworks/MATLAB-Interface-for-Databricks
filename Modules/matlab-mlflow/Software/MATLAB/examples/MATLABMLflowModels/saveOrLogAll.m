function saveOrLogAll(saveOrLog)
%SAVEORLOGALL saves or logs all MATLAB example functions as MATLAB MLflow
% models.
%
%   SAVEORLOGALL() saves all models
%
%   SAVEORLOGALL("saves") saves all models
%
%   SAVEORLOGALL("log") logs all models
    
% Copyright 2023-2026 MathWorks, Inc.
    arguments
        saveOrLog string {mustBeMember(saveOrLog,["save","log"])} = "save" 
    end

    % Remove older builds
    delete('matlab/*.yaml');
    delete('matlab/*_example.json');
    [~] = rmdir("build",'s');
    % Determine whether to save or log
    if saveOrLog == "save"
        [~] = rmdir("models",'s');
        action = @save_model;
    else
        action = @log_model;
    end
    
    % Add MATLAB examples to MATLAB path
    addpath(fullfile(fileparts(mfilename("fullpath")),"matlab"));

    % Iterate over all examples
    action('singleInAndOutput',{1})
    action('multipleInAndOutputs',{1,2})
    action('tableInAndOutput',{table(1,2,'VariableNames',["a","b"])})
    action('withDatetime',{datetime('now'),2})
    action('withDatetimeTable',{table(datetime('now'),1,2,'VariableNames',["dt","a","b"])})
    action('stringsAndChars',{["a","b"],["c","d"]})
    action('stringsAndCharsWithTable',{table(["a";"b"],["c";"d"],'VariableNames',["c","s"])})
    action('variousInts',{uint8(8),int8(8),uint16(16),int16(16),uint32(32),int32(32),uint64(64),int64(64)})
    action('variousIntsWithTable',{table(uint8(8),int8(8),uint16(16),int16(16),uint32(32),int32(32),uint64(64),int64(64),'VariableNames',["ui8","i8","ui16","i16","ui32","i32","ui64","i64"])})
    action('logic',{true})
    action('logicWithTable',{table([true;false],'VariableNames',"x")});
    action('singlePrecision',{single(1)})

    action('vectorWithParams',{1,2,3,4},2)
    action('vectorWithVectorParams',{[1,2],[2,4],[3,4],[4,5]},2)
    action('vectorWithDatetimeParams',{datetime("now"),datetime("yesterday")},1)
    
    action('tableWithParams',{table(1,2,'VariableNames',{'a','b'}),1,2},2)

function save_model(name,inputs,Nparams)
    arguments
        name
        inputs
        Nparams = 0
    end
    % Save <name>.m as MLflow model in location models/<name>
    mlflow.matlab.save_model(FunctionFile=name, ...
        MATLABFiles="matlab/"+name+".m", ...
        Path=['models/' name], ...
        ExampleInputs=inputs, ...
        IncludeMPSCTF=true, ...
        NParams=Nparams, ...
        IncludeMATLABMLflowModule=true)

function log_model(name,inputs,Nparams)
    arguments
        name
        inputs
        Nparams = 0
    end
    % Create/set experiment to MATLABExample
    mlflow.set_experiment('MATLABExample');
    % Start a new run with name equal to the example function name
    mlflow.start_run(run_name=name);
    % Log the model in this run, include the artifact in a directory named
    % "model".
    mlflow.matlab.log_model(FunctionFile=name, ...
        MATLABFiles="matlab/"+name+".m", ...
        ExampleInputs=inputs, ...
        NParams=Nparams, ...
        IncludeMATLABMLflowModule=true);

    mlflow.log_param("Tool","MATLAB");
    mlflow.log_metric("Score",rand);
    % End the run
    mlflow.end_run();

