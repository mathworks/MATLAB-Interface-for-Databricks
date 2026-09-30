function MV = initFromStruct(data)
    % initFromStruct Create ModelVersion from structure

    %   Copyright 2022 MathWorks, Inc.

    MV = mlflow.ModelVersion();

    MV.initFromStructInternal(data);
    
end

