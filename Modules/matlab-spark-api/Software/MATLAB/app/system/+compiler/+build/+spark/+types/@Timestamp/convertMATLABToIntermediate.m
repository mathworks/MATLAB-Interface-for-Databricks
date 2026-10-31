function codeOut = convertMATLABToIntermediate(obj, codeIn)
    % convertMATLABToIntermediate Convert MATLAB values to interm.
    %
    % For some datatypes, an intermediate representation is
    % necessary (e.g. timestamps). If no conversion is necessary,
    % this just returns the same value

    % Copyright 2023 The MathWorks, Inc.

    F = obj.getFileParent();
    PSB = F.Parent;

    if obj.isScalarData
        transpose = "'";
    else
        transpose = "";
    end

    if PSB.CallCtx == compiler.build.spark.CallContext.TablePandas
        codeOut = sprintf("convertTo(%s, 'epochtime', 'TicksPerSecond', 1e9)%s", codeIn, transpose);
    else
        codeOut = sprintf("convertTo(%s, 'epochtime', 'TicksPerSecond', 1e3)%s", codeIn, transpose);
    end
end