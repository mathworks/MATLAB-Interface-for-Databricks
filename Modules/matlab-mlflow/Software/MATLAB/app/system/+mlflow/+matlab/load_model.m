function path = load_model(source,destination)
    % LOAD_MODEL loads a MATLAB flavor MLflow model and returns the
    % location of the MATLAB code it includes.
    % 
    % Loading will fail if the model is not MATLAB flavor or if the MATLAB
    % flavor model does not contain MATLAB code (e.g. if it only contains
    % the MATLAB Compiler SDK compiled Python package or only an ONNX
    % version of a network).
    %
    % path = mlflow.matlab.load_model(source) loads a model from the
    % specified source. Source can be a location on disk or any MLflow
    % compatible URI like for example "models:/modelname/version" or
    % "runs:/runid/artifact_path". If the source is directly locally
    % accessible, the model is left in place and the location of the MATLAB
    % code is returned as output. If the source is a remote location, the
    % model is first downloaded to a local temporary location and then the
    % path of this temporary location is returned.
    %
    % path = mlflow.matlab.load_model(source,destination) copies or
    % downloads the specified source model to the destination and then
    % returns the path of the MATLAB code inside the destination location.
    
    % Copyright 2023 MathWorks, Inc.
    if nargin == 1
        path = py.matlab_mlflow.load_model(source);
    else
        path = py.matlab_mlflow.load_model(source,destination);
    end
    path = string(path);
    