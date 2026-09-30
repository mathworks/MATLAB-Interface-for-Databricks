function kwargsStr = map2kwargsStr(map)
    % MAP2KWARGSSTR Converts a MATLAB container.Map to a Python kwargs string
    % Values must be convertible to a string.
    % Keys must be scalar text.
    %
    % Example:
    %   keySet = {'Jan','Feb','Mar','Apr', 'q1'};
    %   valueSet = {"January", 2, "March", 4.0, true};
    %   kwargsStr = matlab.internal.utils.map2kwargsStr(containers.Map(keySet,valueSet));

    % Copyright 2025-2026 The MathWorks, Inc.
    arguments (Input)
        map
    end
    arguments (Output)
        kwargsStr string {mustBeTextScalar}
    end

    keys = map.keys;
    values = map.values;
    kwargsStr = "";
    for n = 1:length(keys)
        if ~ischar(values{n}) && ~isscalar(values{n})
            fprintf(2, "Only scalar values are currently supported when building a kwarg string: %s\n", keys{n});
        else
            if isscalar(values{n}) && (ismissing(values{n}) || isempty(values{n}))
                kwargsStr = kwargsStr + string(keys{n}) + "=None";
            else
                switch class(values{n})
                    case 'logical'
                        if values{n}
                            kwargsStr = kwargsStr + string(keys{n}) + "=True";
                        else
                            kwargsStr = kwargsStr + string(keys{n}) + "=False";
                        end

                    case 'string'
                        kwargsStr = kwargsStr + string(keys{n}) + "=""" + values{n} + """";

                    case 'char'
                        kwargsStr = kwargsStr + string(keys{n}) + "=""" + string(values{n}) + """";

                    case {'double', 'int32', 'int64', 'uint32', 'uint64', 'single'}
                        kwargsStr = kwargsStr + string(keys{n}) + "=" + string(values{n});
                    otherwise
                        fprintf(2, "Unexpected kwarg value class: %s, skipping.\n", class(values{n}));
                end
            end
            if n ~= length(keys)
                kwargsStr = kwargsStr + ", ";
            end
        end
    end
    kwargsStr = strip(kwargsStr, "right", ",");
end
