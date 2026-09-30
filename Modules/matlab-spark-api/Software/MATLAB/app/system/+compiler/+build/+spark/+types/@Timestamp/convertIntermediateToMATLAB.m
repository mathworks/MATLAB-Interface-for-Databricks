function codeOut= convertIntermediateToMATLAB(obj, codeIn)
    % convertIntermediateToMATLAB Intermediate to MATLAB
    % Implementation for @Timestamp
    %
    % See also compiler.build.spark.types.ArgType/convertIntermediateToMATLAB

    % Copyright 2021-2023 The MathWorks, Inc.

    F = obj.getFileParent();
    SB = F.Parent;
    
    if SB.CallCtx == compiler.build.spark.CallContext.TablePandas
        % This implies Python AND Pandas
        codeOut = sprintf("datetime(%s, 'ConvertFrom', 'epochtime', 'TicksPerSecond', 1e9)", codeIn);
    else
        % This implies Python or Java
        codeOut = sprintf("datetime(%s, 'ConvertFrom', 'epochtime', 'TicksPerSecond', 1e3)", codeIn);
    end
end
