function TO = tblPlus(TI, a, b, c)
    % tblPlus Table function with additional arguments
    % A = int64(1:10)'
    % B = double(A + 10)
    % C = string(B + 10)
    % T = table(A,B,C)
    %
    % TO = tblPlus(T, int64(3), double(5), "hello")

    TO = TI;
    TO.A = TO.A + a;
    TO.B = TO.B + b;
    TO.C = TO.C + "_" + c;
end
