function ret = fFilter1(id, str, i32)
    % fFilter1 Test for filter function
    % Must return a single boolean

    % Copyright 2023 The MathWorks, Inc.

    if id < int64(5) || strlength(str) < 5 || i32 > 55
        ret = true;
    else
        ret = false;
    end

end
