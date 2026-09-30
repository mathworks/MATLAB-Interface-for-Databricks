function runObj = createRun(obj, varargin)
    % CREATERUN Method to create a run

    %  (c) 2020-2021 MathWorks, Inc.

    runObj = mlflow.Run;
    runObj.experiment_id = obj.experiment_id;

end %function
