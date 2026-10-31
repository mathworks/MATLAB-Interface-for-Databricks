classdef CallContext
    % CallContext What context is this called in, row or table
    %

    % Copyright 2023 The MathWorks, Inc.

    enumeration
        None
        Row
        TableDataFrame
        TablePandas
    end

end