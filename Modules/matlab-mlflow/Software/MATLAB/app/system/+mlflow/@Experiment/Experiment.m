classdef Experiment < mlflow.Object
    % EXPERIMENT MLflow Experiment
    % This object allows users to create, delete, list, update, restore and
    % query experiments.

    %  Copyright 2020-2022 MathWorks, Inc.

    properties
        experiment_id string
        name string
        artifact_location string
        lifecycle_stage string
        last_update_time int64
        creation_time int64
        tags mlflow.ExperimentTag
    end

    methods
        %% Constructor
        function obj = Experiment(varargin)
            obj@mlflow.Object(varargin{:});
        end
    end

    methods(Static)
        exp = list(varargin);
        exp = getByName(experimentName, varargin);
        exp = initFromStruct(S);
    end

    methods (Access = protected)
        function initFromStructInternal(obj, data)
            % initFromStructInternal Create experiment from structure

            fn = fieldnames(data);

            for k=1:length(fn)
                FN = fn{k};
                obj.(FN) = data.(FN);
            end

        end

    end

end %class