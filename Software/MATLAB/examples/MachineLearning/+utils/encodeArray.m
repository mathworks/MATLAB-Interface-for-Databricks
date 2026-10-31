function aOut = encodeArray(aIn)
    %ENCODEARRAY Encode repeating data for the purposes of machine learning

    % Copyright 2021-2026 The MathWorks, Inc.

    % Encode the gender column
    % 0 = Female
    % 1 = Male
    aOut = zeros(height(aIn), 1);
    msk = aIn == "Male";
    aOut(msk,1) = 1;

    % Mind the datatype --> this is problem / data source specific!
    aOut = int32(aOut);
end