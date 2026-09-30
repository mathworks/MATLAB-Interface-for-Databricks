function D = toPyDict(arg)
    % toPyDict Convert to a python dictionary (argument)
    %
    % The argument can be
    %   a struct
    %   a cell array of pairs

    % Copyright 2024 MathWorks, Inc.
    switch string(class(arg))
        case "struct"
            D = py.dict(arg);
        case "cell"
            N = numel(arg);
            if rem(N,2) ~= 0
                error("SPARKAPI:TO_PY_DICT_ARGUMENT", ...
                    "A cell argument must be a even number of elements");
            end
            arg = reshape(arg(:), 2, N/2);
            S = struct(arg{:});
            D = py.dict(S);
        otherwise
            error("SPARKAPI:TO_PY_DICT_CLASS", ...
                "This class (%s) of argument is currently not supported.", class(arg));
    end

end