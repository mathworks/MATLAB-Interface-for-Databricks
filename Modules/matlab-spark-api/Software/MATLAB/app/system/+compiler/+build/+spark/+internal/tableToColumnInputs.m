function columns = tableToColumnInputs(T)
    % tableToColumnInputs Internal helper function.
    %
    % This is an internal function, and not part of the API.

    % Copyright 2021-2022 MathWorks, Inc.

    % The function takes a table, as a normal MATLAB function would expect
    % it, and turns its inputs into colummns (transposed), as they will be
    % received in the SparkBuilder interfaces. This is only used to
    % facilitate development and debugging.

    % Copyright 2023 The MathWorks, Inc.


    columnNames = string(T.Properties.VariableNames);
    N = numel(columnNames);
    columns = cell(N, 1);

    for k=1:N
        columns{k} = T.(columnNames(k))';
    end


end


