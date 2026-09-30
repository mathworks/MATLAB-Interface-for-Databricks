function E = initFromStruct(data)
    % initFromStruct Create experiment from structure

    %   Copyright 2022 MathWorks, Inc.

    E = mlflow.Experiment();

    E.initFromStructInternal(data);
    
end

