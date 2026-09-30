function V = sparkApiPackageVersion()
    % sparkApiPackageVersion Return version of the matlab-spark-api package
    
    % Copyright 2021 MathWorks, Inc.
   
    r = fileparts(fileparts(getSparkApiRoot));
    verFile = fullfile(r, 'VERSION');
    V = strip(string(fileread(verFile)));
    
end
