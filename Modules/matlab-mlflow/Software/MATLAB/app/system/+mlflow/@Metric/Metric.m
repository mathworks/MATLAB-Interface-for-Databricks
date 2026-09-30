classdef Metric < handle
    % METRIC Class definition to store MLFLow metrics
    % Metrics for use with the mlflow API.
    %
    % Example:
    %   % Create a metric
    %   metric = mlflow.Metric;
    %   metric.key = 'TrainingLoss';
    %   metric.value = 1e-6;
    %   metric.timestamp = getCurrentTimeUnixINT64();
    %   metric.step = 100;

    %  Copyright 2020-2022 MathWorks, Inc.

    properties
        key char
        value double
        timestamp int64
        step (1,1) int64 
    end

    methods
        %% Constructor
        function obj = Metric(varargin)
            if nargin == 1
                data = varargin{1};
                if isstruct(data)
                    initFromStruct(obj, data)
                elseif strcmpi(data,'now')
                    obj.timestamp = getCurrentTimeUnixINT64();
                end
            end
        end

        function S = toStruct(obj)
            N = length(obj);
            if N == 0
                S = struct("key", {}, "value", {}, "timestamp", {}, "step", {});
            else
                for k = N:-1:1
                    S(k) = struct(...
                        "key", obj(k).key, ...
                        "value", obj(k).value, ...
                        "timestamp", obj(k).timestamp, ...
                        "step", obj(k).step);
                end
            end
        end

        function T = toTable(obj)
            T = struct2table(toStruct(obj));
        end
    end

    methods (Access = protected)
        function initFromStruct(obj, data)
            if isfield(data, 'key')
                obj.key = data.key;
            end
            if isfield(data, 'value')
                obj.value = data.value;
            end
            if isfield(data, 'timestamp')
                obj.timestamp = data.timestamp;
            end
            if isfield(data, 'step')
                obj.step = data.step;
            end
        end
    end

end %class