classdef ExperimentTag < mlflow.KeyValue
    % ExperimentTag Container for holding the tags for an experiment
    % Create a tag to apply to an experiment. The inputs to this can be a cell array of
    % key value pairs.
    %
    % This class is normally not instantiated explicitly, but is a result
    % of creating an Experiment object (cf. mlflow.Experiment/setTag)
    %
    % Example:
    %
    %   tt1 = mlflow.ExperimentTag('mykey','myvalue');
    %
    % See also mlflow.Experiment/setTag
    
    %   Copyright 2021-2022 MathWorks, Inc.


    methods
        %% Constructor
        function obj = ExperimentTag(varargin)
            obj@mlflow.KeyValue(varargin{:});
        end
    end

end %class
