classdef RegisteredModelTag < mlflow.KeyValue
    % REGISTEREDMODELTAG Tag for a registered model
    % Create a tag to apply to a run.  The inputs to this can be a struct
    % array with the fieldnames key and value, or simply a series of
    % key/value pairs
    %
    % Example:
    %
    %   mvt1 = mlflow.RegisteredModelTag('mykey','myvalue');
    %
    %
    %   mvt2 = mlflow.RegisteredModelTag('key1', 'val1','key2', 'val2');
    %
    %  kv = struct('key', {"hello", "there"}, 'value', {"10", "20"});
    %  mvt3 = mlflow.RegisteredModelTag(kv)

end