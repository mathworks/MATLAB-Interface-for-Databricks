function Tout = fVarArrSize2(Tin)
    % fVarArrSize2 Output arrays with changing size

    % Copyright 2023 MathWorks, Inc.

    % Because of test data, low and high may have been interchanged

    Tout = Tin;

    H = height(Tout);

    Tout.timez = cellstr(string(Tin.ts));

    for k=1:H
        coeff = randi([3, 15]);
        str_arr = "A_" + k + "_" + (1:coeff);
        Tout.timez{k} = str_arr;
    end
    
end