function [O1, O2] = f_check_sig_two_out(V)
    % f_check_sig_two_out Argument checking function
    %
    % Can be used with different unsupported combinations, and should fail
    % in signature generation

    % Copyright 2022-2025 MathWorks, Inc.
   
    arguments
        V
    end
    
    if isstring(V) || ischar(V)
        V = char(V);
        switch V
            case 'two_tables_out'
                O1 = table(1,2);
                O2 = table(3,4);
            case 'table_and_more_out'
                O1 = table(1,2);
                O2 = 345;
        end
                
    else
        O1 = V;
        O2 = V;
    end
end
