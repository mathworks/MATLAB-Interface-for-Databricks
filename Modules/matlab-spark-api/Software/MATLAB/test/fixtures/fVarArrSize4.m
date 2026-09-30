function TOUT = fVarArrSize4(TIN)
    % fVarArrSize4 Input/Output arrays with changing size

    % Copyright 2023 MathWorks, Inc.

    TOUT = TIN;
    TOUT.x = cellfun(@(x) x + "_XYZ", TOUT.a, 'UniformOutput', false);
    TOUT.y = cellfun(@(x) x + int32(1000), TOUT.b, 'UniformOutput', false);
    
end