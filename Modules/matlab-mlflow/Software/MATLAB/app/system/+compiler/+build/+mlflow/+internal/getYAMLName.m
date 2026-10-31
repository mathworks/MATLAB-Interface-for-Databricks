function [yamlFile,exampleFile] = getYAMLName(fof)
% getYAMLName Returns the location of the YAML-file and example
% JSON-file corresponding to a given MATLAB function.
%
%   [YAMLFILE,EXAMPLEFILE] = getYAMLName(FUNCTIONNAME)

% Copyright 2023 The MathWorks, Inc.    
    fof = which(fof);
    if isempty(fof)
        error("Specified file or function not found.");
    end
    [p,f] = fileparts(fof);
    yamlFile = fullfile(p,f + ".yaml");
    exampleFile = fullfile(p,f + "_example.json");