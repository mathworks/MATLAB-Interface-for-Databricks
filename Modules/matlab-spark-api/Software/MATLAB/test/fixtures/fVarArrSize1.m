function [ts, str_arr] = fVarArrSize1(ts, low, high)
    % fVarArrSize1 Output arrays with changing size

    % Copyright 2023 MathWorks, Inc.

    % Because of test data, low and high may have been interchanged
    low = low - 2;
    high = high + 2;
    low = max(low, 1);


    coeff = randi([low, high]);

    str_arr = "A_" + (1:coeff);
    
end