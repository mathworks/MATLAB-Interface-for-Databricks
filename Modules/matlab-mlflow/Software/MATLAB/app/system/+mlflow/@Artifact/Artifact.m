classdef Artifact < mlflow.Object
% ARTIFACT MLflow Artifact object
% MLFlow artifacts are run output files in any format, e.g images, models or 
% other data files.
%
% An artifact can be logged using the mlflow cli as follows:
%  mlflow artifacts log-artifact --local-file myArtifact.mat  --run-id 45b57414530c4100bbebb2b36dd2a1ee --artifact-path myPathPrefix 

%  (c) 2020 MathWorks, Inc.

properties
    % id of the run in question
    run_id = string.empty;
    % Deprecated run_uuid not implemented, field will be removed in a future MLflow version
    
    path = string.empty;
    page_token = string.empty;
end

methods
	% Constructor 
	function obj = Artifact(varargin)
        obj@mlflow.Object(varargin{:});
    end
    
    function set.run_id(obj, value)
        if ischar(value) || isStringScalar(value)
            obj.run_id = string(value);
        else
            error('MLFLOW:ERROR', 'Expected run_id of type character vector or scalar string');
        end
    end

    function set.path(obj, value)
        if ischar(value) || isStringScalar(value)
            obj.path = string(value);
        else
            error('MLFLOW:ERROR', 'Expected path of type character vector or scalar string');
        end
    end

    function set.page_token(obj, value)
        if ischar(value) || isStringScalar(value)
            obj.page_token = string(value);
        else
            error('MLFLOW:ERROR', 'Expected page_token of type character vector or scalar string');
        end
    end
end

end %class