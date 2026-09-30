function codeOut = getMATLABInputColumn(obj, arrayName, colIdx) %#ok<INUSD>
    % getMATLABInputColumn Return string with MATLAB column

    % Copyright 2023-2024 The MathWorks, Inc.

    codeOut = sprintf("%s{%d}", arrayName, colIdx);
end
