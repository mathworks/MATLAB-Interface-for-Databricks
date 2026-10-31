function tableDebugInfo(T, infoStr)
    % tableDebugInfo Output some table info for debugging/metrics
    %
    % Outputs some info on a table, mainly to see size.
    %
    % T is the table
    % infoStr some info for better understanding context
    
    % Copyright 2023 The MathWorks, Inc.
    
    arguments
        T table
        infoStr (1,1) string = ""
    end

    w = whos('T');
    numBytes = w.bytes;
    numMB = w.bytes/2^20;


    fprintf("Table: %s [%dx%d] - bytes: %d (%.2f MB)\n", ...
        infoStr, height(T), width(T), numBytes, numMB);
    
end