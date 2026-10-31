function T = table(obj)
    % table Turn array of ObjectInfo to table

    % Copyright 2022 The MathWorks, Inc.

    warnOff = warning('OFF', 'MATLAB:structOnObject');
    turnBack = onCleanup(@() warning(warnOff));
 
    for k=1:length(obj)
        S(k) = struct(obj(k)); %#ok<AGROW> 
    end
    T = struct2table(S);

end