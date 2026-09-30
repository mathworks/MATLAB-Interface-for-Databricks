function codeOut = convertIntermediateToExternal(obj, codeIn)
    % convertIntermediateToExternal To external representation
    %
    % For some datatypes, an conversion to external may be necessary. If no
    % conversion is necessary, this just returns the same value.

    % Copyright 2023 The MathWorks, Inc.

    if obj.isScalarData
        element = "[0]";
    else
        element = "";
    end
    codeOut = sprintf("%s%s.tomemoryview().tolist()%s", codeIn, element, element);
end

