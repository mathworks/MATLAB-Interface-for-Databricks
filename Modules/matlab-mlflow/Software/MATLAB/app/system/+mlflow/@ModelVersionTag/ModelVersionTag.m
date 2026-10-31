classdef ModelVersionTag < mlflow.KeyValue
    % MODELVERSIONTAG Tag for a model version
    % Create a tag to apply to a run. The inputs to this can be a struct
    % array with the fieldnames key and value, or simply a series of
    % key/value pairs 
    %
    % Example:
    %
    %   mvt1 = mlflow.ModelVersionTag('mykey','myvalue');
    %
    %   mvt2 = mlflow.ModelVersionTag('key1', 'val1','key2', 'val2');
    %
    %  kv = struct('key', {"hello", "there"}, 'value', {"10", "20"});
    %  mvt3 = mlflow.ModelVersionTag(kv)

    %  Copyright 2020-2022 MathWorks, Inc.

end %class
