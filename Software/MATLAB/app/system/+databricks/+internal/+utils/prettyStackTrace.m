function prettyStackTrace()
    % prettyStackTrace Pretty stack trace output

    %  Copyright 2024 MathWorks, Inc.

    dbs = dbstack();

    N = numel(dbs);
    dbs = dbs(end:-1:2);
    funcs = string({dbs.name});
    lineNos = string([dbs.line]);
    funcLines = funcs + ":" + lineNos;
    stackLine = join(funcLines, " -> ");
    fprintf("Stack: %s\n", stackLine);
end
