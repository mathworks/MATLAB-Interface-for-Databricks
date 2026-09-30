function T = getTableWithStrangeNames()
    % getTableWithStrangeNames Return table with 'bad' column names

    % Copyright 2025 MathWorks, Inc.

    id = int64(1:10)';
    d = double(id);
    i32 = int32(id);
    T = table(id, d, i32,  ...
        'VariableNames', {'id', 'Vehicle Speed', '$Other#Name^'});

end