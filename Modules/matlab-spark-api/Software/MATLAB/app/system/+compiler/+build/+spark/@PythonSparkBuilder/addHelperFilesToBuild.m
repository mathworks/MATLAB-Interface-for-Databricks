function buildOpts = addHelperFilesToBuild(obj)
    % addHelperFilesToBuild 

    % Copyright 2022 The MathWorks, Inc.

    buildOpts = obj.BuildOpts;

    for k=1:length(obj.HelperFiles)
        HF = obj.HelperFiles(k);
        buildOpts.FunctionFiles{end+1} = char(HF);
    end

end
