function [ts_strings, backintime] = fValues_Arrays6(ts, suffix)
    % fValuesArrays6 Timestamp arrays

    % Copyright 2023-2024 MathWorks, Inc.

    ts_strings = string(ts) + suffix;
    backintime = ts - hours(5) + seconds(5);

end