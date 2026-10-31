function [a,b] = f_no_signature(x,y)
    % f_no_signature - Fixture function
    %
    % Used for testing PythonSparkBuilder, and making sure that a function
    % must have an accompanying signature.
    a = x + y;
    b = x * y;
end