function codeOut = convertIntermediateColumnForRuntime(obj, codeIn)
    % convertIntermediateColumnForRuntime Convert columns
    %
    % A column in intermediate representation will be a list of values.
    % This will be converted to a cell array in MATLAB. This is an
    % unnecessary step, in case the contents of a column are scalars. In
    % these cases, a conversion should be done.

    % Copyright 2023-2024 The MathWorks, Inc.

    if obj.isScalarData
        codeOut = sprintf("matlab.%s(%s)", obj.MATLABType, codeIn);
    else
        codeOut = sprintf("[matlab.%s(x) for x in %s]\n", obj.MATLABType, codeIn);
    end
end

