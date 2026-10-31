function T = numExamplesTable()
    % numExamplesTable Create example table for testing
    
    % Copyright 2020 MathWorks, Inc.

    T = 0:1/pi:100;
    X = sin(T*60*pi);
    Y = cos(T*140*pi+pi/exp(1));
    
    S = struct(...
        'T', num2cell(T), ...
        'X', num2cell(X), ...
        'Y', num2cell(Y) ...
        );
    T = struct2table(S);
end
