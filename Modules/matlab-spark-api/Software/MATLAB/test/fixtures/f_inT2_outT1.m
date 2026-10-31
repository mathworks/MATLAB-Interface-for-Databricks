function OT = f_inT2_outT1(IT1, IT2)
    % f_inT2_outT1 Argument checking function
    %
    % Data for function signature:
    % IT1 = table(100+randn(10,1), 500 + randn(10,1), 'VariableNames', {'A', 'B'})
    % IT2 = IT1;
    % 

    % Copyright 2022-2024 MathWorks, Inc.
   
    OT = normalize(IT1);
    head(IT2)

end
