function generate_shrlib_artifacts(buildInfo)
    % generate_shrlib_artifacts  Helper function to generate artifacts

    % Copyright 2025 The MathWorks, Inc.


    swo = simwrapper.SimWrapper(buildInfo=buildInfo);

    swo.generateArtifact()
    
    swo.generateWheel(upload=false);
    
    assignin('base', sprintf("swo_%s", swo.ModelName), swo);

end