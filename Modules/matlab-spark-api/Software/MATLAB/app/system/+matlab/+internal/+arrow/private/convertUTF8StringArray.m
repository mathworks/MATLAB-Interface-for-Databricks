function str = convertUTF8StringArray(offsets, utf8Data, ~)
%CONVERTUTF8STRINGARRAY Converts a UTF-8 array, represented by an offset
% buffer and a buffer of utf-8 encoded bytes, into a MATLAB string array.

% Copyright 2026 The MathWorks, Inc.

    numStrs = numel(offsets) - 1;
    str = strings([numStrs 1]);
    for ii = 1:numStrs
        startIndex = offsets(ii) + 1;
        endIndex = offsets(ii + 1);
        bytes = utf8Data(startIndex:endIndex);
        str(ii) = native2unicode(bytes, "UTF-8");
    end
end