function T_OUT = addStringCol(T_IN)
    % addStringCol Add a string column including _hello_

    T_OUT = T_IN;
    T_OUT.hello = string(T_IN.id) + "_hello_" + string(T_IN.did);
end

