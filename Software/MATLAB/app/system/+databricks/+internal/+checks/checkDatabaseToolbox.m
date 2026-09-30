function tf = checkDatabaseToolbox(options)
    % checkDatabaseToolbox Tests for checkDatabaseToolbox, warns if not present
    
    %  (c) 2023-2024 MathWorks, Inc.

    arguments
        options.verbose (1,1) logical = true
    end

    if isempty(ver('database'))
        tf = false;
        if options.verbose
            fprintf(2, "Warning:\n");
            fprintf("  Database Toolbox is not installed.\n");
            fprintf("  JDBC/ODBC/SQL Warehouse workflows will not be supported.\n");
            fprintf("  Other workflows can be used.\n");
            fprintf("\n");
        end
    else
        tf = true;
    end
end

