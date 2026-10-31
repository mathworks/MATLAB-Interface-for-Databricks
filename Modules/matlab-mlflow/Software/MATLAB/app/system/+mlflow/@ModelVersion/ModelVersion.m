classdef ModelVersion < mlflow.Object
% MODELVERSION MLflow Model Version


%   (c) 2021 MathWorks, Inc. 

    properties
        name                   string
        version                string
        creation_timestamp     datetime
        last_updated_timestamp datetime
        user_id                string
        current_stage          string
        description            string
        source                 string
        run_id                 string
        status                 mlflow.ModelVersionStatus
        status_message         string
        tags                   mlflow.ModelVersionTag
        run_link               string
    end


    methods
        %% Constructor 
        function obj = ModelVersion(varargin)
            obj@mlflow.Object(varargin{:});
        end
    end

    methods (Static = true)
        exp = initFromStruct(S);
    end
    
    methods (Access = protected)
        function initFromStructInternal(obj, data)
            % initFromStructInternal Create object from structure

            fn = fieldnames(data);

            for k=1:length(fn)
                FN = fn{k};
                obj.(FN) = data.(FN);
            end
        end
    end

end %class
