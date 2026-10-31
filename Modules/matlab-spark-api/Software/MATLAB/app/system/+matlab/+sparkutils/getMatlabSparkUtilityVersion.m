function v = getMatlabSparkUtilityVersion()
    % getMatlabSparkUtilityVersion Retrieve version from pom-file
    
    % Copyright 2020 The MathWorks, Inc.
   
    swRoot = fileparts(getSparkApiRoot());
    pomFile = fullfile(swRoot, 'Java', 'SparkUtility', 'pom.xml');
    
    X = xmlread(pomFile);
    
    projNode = X.getElementsByTagName('project').item(0);
    versionElement = projNode.getElementsByTagName('version').item(0);
    templateVersion = versionElement.getTextContent();
    
    v = string(templateVersion);
    
end

