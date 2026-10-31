function OUT = inout(IN)
    % INOUT Trivial function that returns the input string as output
    
    arguments (Input)
        IN string {mustBeTextScalar, mustBeNonzeroLengthText}
    end
    arguments (Output)
        OUT string
    end

    OUT = IN;
    fprintf("Input string: %s\n", IN);
end
