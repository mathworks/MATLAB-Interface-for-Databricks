function strs = getImports(file, options)
    % getImports Generate strings with imports

    % Copyright 2024 The MathWorks, Inc.

    arguments
        file (1,1) compiler.build.spark.PythonFile
        options.debug (1,1) logical = false
    end

    api = file.API;
    PSB = file.Parent;

    strs = string.empty;

    fnAPI = string(fieldnames(api));
    wrapperName = PSB.PkgName + ".wrapper";
    for k=1:length(fnAPI)
        FN = fnAPI(k);
        FV = api.(FN);
        if ~apiIsPrivate(FV) || options.debug
            strs(end+1) = sprintf("from %s import %s", wrapperName, FV); %#ok<AGROW>
        end
    end
    if options.debug
        strs(end+1) = sprintf("from %s import Wrapper", wrapperName);
    end
    strs(end+1) = ""; % newline

    strs = strs(:);

end

function tf = apiIsPrivate(name)
    tf = name.startsWith("__");
end

