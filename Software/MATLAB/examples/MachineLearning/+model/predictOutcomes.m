function [yfit, acc] = predictOutcomes(tIn, mdl)
    %PREDICTOUTCOMES Predict with trained model

    % Copyright 2021-2026 The MathWorks, Inc.

    % Predict with the model passed into this function
    yfit = mdl.predictFcn(tIn);

    % Calculate accuracy
    acc = 100*nnz(yfit == tIn.class)/length(yfit);
end