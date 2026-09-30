function [raw, args, compilerType]  = getFileArgumentInfo(funcName)
    % getFileArgumentInfo Try to retrieve argument info

    % Copyright 2022-2025 The MathWorks, Inc.

    arguments
        funcName (1,1) string
    end
    raw = struct.empty;
    args = {};
    compilerType = [];

    FIS = compiler.build.spark.internal.getFcnFileName(funcName);
    schemaFileName = compiler.build.spark.internal.getSchemaName(FIS.FullFileName);

    if isfile(schemaFileName)
        raw = jsondecode(fileread(schemaFileName));
        % This needs to be reset to ensure relocatability of files
        raw.fullFilename = FIS.FullFileName;
        compilerType = compiler.build.spark.schema.mathworks.CommonBase.load(raw);
    end

    jsonFileName = compiler.build.spark.internal.getJSONName(FIS.FullFileName);
    if isfile(jsonFileName)
        raw = jsondecode(fileread(jsonFileName));
        args = {raw.InTypes, raw.OutTypes};
    end

end
