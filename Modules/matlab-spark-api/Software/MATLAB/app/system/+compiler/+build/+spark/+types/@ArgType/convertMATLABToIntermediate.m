function codeOut = convertMATLABToIntermediate(obj, codeIn)
    % convertMATLABToIntermediate Convert MATLAB values to interm.
    %
    % For some datatypes, an intermediate representation is
    % necessary (e.g. timestamps). If no conversion is necessary,
    % this just returns the same value

    % Copyright 2023 The MathWorks, Inc.

    file = obj.getFileParent();
    Parent = file.Parent;

    transpose = "";
    if obj.isScalarData
        % if Parent.CallCtx ~= compiler.build.spark.CallContext.TablePandas
        transpose = "'";
        % end
    end
    codeOut = sprintf("%s%s", codeIn, transpose);

end