classdef RunTag < mlflow.KeyValue
    % RUNTAG Container for holding the tags for a run
    % Create a tag to apply to a run. The inputs to this can be a cell array of
    % key value pairs.
    %
    % This class is normally not instantiated explicitly, but is a result
    % of creating a Run object (cf. mlflow.Run/setTag)
    %
    % Example:
    %
    %   tt1 = mlflow.RunTag('mykey','myvalue');
    %
    % See also mlflow.Run/setTag

    %  Copyright 2020-2022 MathWorks, Inc.


end %class