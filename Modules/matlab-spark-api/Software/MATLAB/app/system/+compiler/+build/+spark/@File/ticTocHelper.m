function tth = ticTocHelper(file, SW, msg, tIdx)
    % ticTocHelper Generate tic/toc print statements

    % Copyright 2023 The MathWorks, Inc.

    PSB = file.Parent;

    fullMsg = sprintf('%s_%s', file.funcName, msg);

    tth = compiler.build.spark.TicTocHelper(fullMsg, tIdx, SW);

end

