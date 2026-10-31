classdef RegisteredModel < mlflow.Object
    % REGISTEREDMODEL

    %  (c) 2021-2022 MathWorks, Inc.

    properties
        name                    string
        creation_timestamp      int64
        last_updated_timestamp  int64
        user_id                 string
        description             string
        latest_versions         mlflow.ModelVersion
        tags                    mlflow.RegisteredModelTag
    end

    methods
        function obj = RegisteredModel(varargin)
            obj@mlflow.Object(varargin{:});
        end
    end

    methods (Access = protected)
        function initFromStructInternal(obj, data)
            % initFromStructInternal Create object from structure

            fn = fieldnames(data);

            for k=1:length(fn)
                FN = fn{k};
                value = data.(FN);
                switch FN
                    case 'latest_versions'
                        value = mlflow.ModelVersion.initFromStruct(value);
                    otherwise
                end
                obj.(FN) = value;
            end
        end
    end

    methods (Static = true)
        [regModels, nextPageToken] = list(maxResults, pageToken)
        [regModels, nextPageToken] = search(filter, maxResults, orderBy, pageToken)
        obj = get(name)
    end

end %class