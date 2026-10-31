function kwargsStr = dictionary2kwargsStr(dict)
    % DICTIONARY2KWARGSSTR Converts a MATLAB dictionary to a Python kwargs string
    % Values and keys must be scalar text.
    %
    % Example:
    %   dict = dictionary("host", "localhost", "port", "8080");
    %   kwargsStr = matlab.internal.utils.dictionary2kwargsStr(dict);

    % Copyright 2025-2026 The MathWorks, Inc.

    arguments (Input)
        dict dictionary
    end
    arguments (Output)
        kwargsStr string {mustBeTextScalar}
    end

    keys = dict.keys;
    values = dict.values;
    kwargsStr = "";

    for n = 1:length(keys)
        if ~isscalar(values(n))
            fprintf(2, "Only scalar values are not currently supported when building a kwarg string, skipping: %s\n", keys(n));
        elseif ismissing(values(n)) || isempty(values(n))
            fprintf(2, "Missing or empty values are not currently supported when building a kwarg string, skipping: %s\n", keys(n));
        else
            switch class(values(n))
                case 'string'
                    kwargsStr = kwargsStr + string(keys(n)) + "=""" + values(n) + """";
                case 'char'
                    kwargsStr = kwargsStr + string(keys(n)) + "=""" + string(values(n)) + """";
                otherwise
                    fprintf(2, "Unexpected kwarg value class: %s, skipping.\n", class(values(n)));
            end
        end
        if n ~= length(keys)
            kwargsStr = kwargsStr + ", ";
        end
    end
    kwargsStr = strip(kwargsStr, "right", ",");
end
