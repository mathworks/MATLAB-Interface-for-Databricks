function [codeOut, preCode] = convertExternalToIntermediate(obj, codeIn)
    % convertExternalToIntermediate To intermediate representation
    %
    % See compiler.build.spark.types.ArgType/convertExternalToIntermediate

    % Copyright 2023-2024 The MathWorks, Inc.

    preCode = "";
    if obj.isScalarData
        codeOut = sprintf("int(%s.timestamp()*1000.0)", codeIn);
    else
        error('SPARKAPI:timestamp_array_argument', ...
            'Timestamp arrays are currently not supported');
        % codeOut = sprintf("matlab.%s(%s)", obj.MATLABType, codeIn);
    end
end

