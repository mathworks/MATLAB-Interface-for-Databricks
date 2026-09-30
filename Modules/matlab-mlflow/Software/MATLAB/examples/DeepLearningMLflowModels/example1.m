function example1
    net = squeezenet;
    [~] = rmdir('models/squeeze','s');
    mlflow.matlab.save_model(Network=net,Path='models/squeeze');