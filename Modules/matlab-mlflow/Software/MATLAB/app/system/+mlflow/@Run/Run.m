classdef Run < mlflow.Object
    % RUN MLflow Run
    % This object allows the creation of runs within an experiment. A run is
    % usually a single execution of a machine learning or data ETL pipeline.
    % This is used to track parameters, metrics and RunTags associated with a
    % single execution.

    %  Copyright 2020-2022 MathWorks, Inc.

    properties
        info          mlflow.RunInfo = mlflow.RunInfo
        data  (1,1)   mlflow.RunData
    end

    properties (Dependent=true)
        run_id          string
        user_id         string
        experiment_id   string
        start_time      int64
        lifecycle_stage string
    end

    methods
    	%% Constructor
    	function obj = Run(varargin)
            obj@mlflow.Object(varargin{:});
    	end
    end

    methods(Static)
        [runs, nextPageToken] = search(experimentIds, options)
    end

    % Getters and Setters
    methods
        function rid = get.run_id(obj)
            rid = obj.info.run_id;
        end
        function uid = get.user_id(obj)
            uid = obj.info.user_id;
        end
        function set.user_id(obj, uid)
            obj.info.user_id = uid;
        end
        function eid = get.experiment_id(obj)
            eid = obj.info.experiment_id;
        end
        function set.experiment_id(obj, eid)
            obj.info.experiment_id = eid;
        end
        function st = get.start_time(obj)
            st = obj.info.start_time;
        end
        function lcs = get.lifecycle_stage(obj)
            lcs = obj.info.lifecycle_stage;
        end

        
    end


end %class