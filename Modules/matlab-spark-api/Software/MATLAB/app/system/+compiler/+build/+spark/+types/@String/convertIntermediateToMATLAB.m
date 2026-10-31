function codeOut= convertIntermediateToMATLAB(obj, codeIn)
    % convertIntermediateToMATLAB Intermediate to MATLAB
    % Implementation for @String
    %
    % See also compiler.build.spark.types.ArgType/convertIntermediateToMATLAB

    % Copyright 2021-2024 The MathWorks, Inc.

        if obj.isScalarData
            codeOut = sprintf("string(%s)", codeIn);
        else
            codeOut = codeIn;
        end
end

