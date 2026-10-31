function codeOut = convertIntermediatelColumnToMATLAB(obj, codeIn)
    % convertIntermediatelColumnToMATLAB Intermediate to MATLAB
    %
    % See compiler.build.spark.types.ArgType/convertIntermediatelColumnToMATLAB
    
    % Copyright 2023-2024 The MathWorks, Inc.
    if obj.isScalarData
        col = sprintf("%s'", codeIn);
    else
        col = codeIn;
    end

    F = obj.getFileParent();
    SB = F.Parent;

    if SB.CallCtx == compiler.build.spark.CallContext.TablePandas
        % This implies Python AND Pandas
        codeOut = sprintf("datetime(%s, 'ConvertFrom', 'epochtime', 'TicksPerSecond', 1e9)", col);
    else
        % This implies Python or Java
        codeOut = sprintf("datetime(%s, 'ConvertFrom', 'epochtime', 'TicksPerSecond', 1e3)", col);
    end
    
end