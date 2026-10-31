function result = depthReport(options)
    % depthReport

    %  Copyright 2024 MathWorks, Inc.

    arguments
        options.verbose (1,1) logical = true
    end

    topDir = databricksRoot(-2);

    result = table('Size', [0,2], 'VariableTypes', ["int32", "string"], 'VariableNames', ["Length", "Path"]);
    report = reportDir(topDir, topDir, verbose=options.verbose);
    result = [result; report];
    result = sortrows(result, 1, {'descend'});

    head(result);
end


function report = reportDir(target, topDir, options)
    arguments
        target string {mustBeTextScalar, mustBeNonzeroLengthText}
        topDir string {mustBeTextScalar, mustBeNonzeroLengthText}
        options.verbose (1,1) logical = true
    end

    report = table('Size', [1,2], 'VariableTypes', ["int32", "string"], 'VariableNames', ["Length", "Path"]);
    targetLength = strlength(target);
    report.Length(1) = targetLength;
    report.Path(1) = replace(target, topDir, "");

    skipList = [".", "..", ".git", ".gitlab", "Internal"];
    dirList = dir(target);
    for n = 1:numel(dirList)
        if ~any(matches(dirList(n).name, skipList))
            if dirList(n).isdir
                subDir = [dirList(n).folder, filesep, dirList(n).name];
                if options.verbose
                    fprintf("%s\n", subDir);
                end
                subReport = reportDir(subDir, topDir, verbose=options.verbose);
                report = [report; subReport]; %#ok<AGROW>
            end
            if ~dirList(n).isdir
                path = target + string(filesep) + string(dirList(n).name);
                path = replace(path, topDir, "");
                report(end+1, :) = {strlength(path), path}; %#ok<AGROW>
            end
        end
    end
end