function V = mlflowPackageVersion()
    % mlflowPackageVersion Return version of the mlflow package
    
    % (c) 2021 MathWorks, Inc.
   
    r = fileparts(fileparts(mlflowRoot));
    verFile = fullfile(r, 'VERSION');
    V = strip(string(fileread(verFile)));
    
end
