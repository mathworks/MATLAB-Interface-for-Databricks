classdef RunData < handle
    % RunData Data fields for a mlflow Run
   
    %  Copyright 2020-2022 MathWorks, Inc.

    properties
        metrics mlflow.Metric
        params mlflow.Param
        tags mlflow.RunTag
    end

    methods
        function obj = RunData(varargin)
            if nargin == 1 && isstruct(varargin{1})
                % This is the information returned by a REST call to the
                % API. It contains one or more of the fields for the
                % properties of this object
                data = varargin{1};
                if isfield(data, 'metrics')
                    obj.addMetrics(data.metrics)
                end
                if isfield(data, 'tags')
                    obj.addTags(data.tags)
                end

                if isfield(data, 'params')
                    obj.addParams(data.params)
                end
            end
        end
    end

    methods (Access = protected)
        function addMetrics(obj, metrics)
            for k=1:length(metrics)
                obj.metrics(k) = mlflow.Metric(metrics(k));
            end
        end

        function addTags(obj, tags)
            for k=1:length(tags)
                obj.tags(k) = mlflow.RunTag(tags(k).key, tags(k).value);
            end
        end

        function addParams(obj, params)
            for k=1:length(params)
                obj.params(k) = mlflow.Param(params(k).key, params(k).value);
            end
        end
    end
end