function examples = generateExamples(obj)
    % generateExamples Generate examples from PythonSparkBuilder
    %

    % Copyright 2023 The MathWorks, Inc.

    outFolder = obj.OutputDir;

    examplesFolder = fullfile(outFolder, 'examples');
    if ~isfolder(examplesFolder)
        mkdir(examplesFolder);
    end

    outNamesPython = string.empty;
    outNamesShell = string.empty;
    for k=1:length(obj.Files)
        F = obj.Files(k);

        [outNameCode, outNameShell] = F.generateExamples(examplesFolder=examplesFolder);
        outNamesPython(end+1) = outNameCode; %#ok<AGROW> 
        outNamesShell(end+1) = outNameShell; %#ok<AGROW> 
    end

    obj.ExampleFiles = table(outNamesPython(:), outNamesShell(:), ...
        'VariableNames', ["PythonExamples", "ShellFiles"]);

end



