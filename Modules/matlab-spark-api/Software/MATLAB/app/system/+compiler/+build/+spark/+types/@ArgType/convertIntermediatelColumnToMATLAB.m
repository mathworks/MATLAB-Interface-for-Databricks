function codeOut = convertIntermediatelColumnToMATLAB(obj, codeIn) %#ok<INUSD>
    % convertIntermediatelColumnToMATLAB Intermediate to MATLAB
    %
    % For some datatypes, the intermediate representation must be converted
    % to a different type in MATLAB. A typical example may be Timestamp
    
    % Copyright 2023-2024 The MathWorks, Inc.
    
    codeOut = sprintf("%s'", codeIn);
end