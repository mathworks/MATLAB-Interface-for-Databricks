function tOut = predict_w_TrainedModel(tIn)
    %PREDICT_W_TRAINEDMODEL Use the model trained with MATLAB to predict on new data

    % Copyright 2021-2026 The MathWorks, Inc.

    arguments
        tIn (:,17) table
    end

    % Encode the gender variable (for ML work)
    tIn.gender = utils.encodeArray(tIn.gender);

    % Use the trained model to predict
    %here = fileparts(mfilename('fullpath'));
    %matPath = fullfile(fileparts(here), '+model', 'TrainedModel.mat');
    s = load('TrainedModel.mat', "trainedClassifier");

    % Predict
    [yfit, ~] = model.predictOutcomes(tIn, s.trainedClassifier);

    % Package up data to return
    tOut = utils.prepareOutputTable(tIn, yfit);
end