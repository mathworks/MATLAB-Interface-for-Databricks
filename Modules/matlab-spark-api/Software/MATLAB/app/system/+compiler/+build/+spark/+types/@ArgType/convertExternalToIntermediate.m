function [codeOut, preCode] = convertExternalToIntermediate(obj, codeIn)
    % convertExternalToIntermediate To intermediate representation
    %
    % For some datatypes, an intermediate representation is
    % necessary (e.g. timestamps). If no conversion is necessary,
    % this just returns the same value

    % Copyright 2023-2024 The MathWorks, Inc.

    preCode = "";
    if obj.isScalarData
        codeOut = codeIn;
    else
        codeOut = sprintf("matlab.%s(%s)", obj.MATLABType, codeIn);
    end
end