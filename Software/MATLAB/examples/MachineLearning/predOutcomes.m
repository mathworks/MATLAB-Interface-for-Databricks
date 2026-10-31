function PredictedValues = predOutcomes(data)
    % PREDOUTCOMES Wrapper function to compile

    % Copyright 2021-2026 The MathWorks, Inc.

    %% Pragma(s) required for MATLAB Compiler workflow
    %#function ClassificationNeuralNetwork

    %% Predict with pre-trained model
    PredictedValues = deploy.predict_w_TrainedModel(data);
end