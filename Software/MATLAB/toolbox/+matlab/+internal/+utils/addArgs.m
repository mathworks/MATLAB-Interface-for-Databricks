function args = addArgs(options, argNames, initialArgs)
    % addArgs Builds a named argument cell array
    %
    % Returns a 1D cell array of pairs of argument names followed by
    % values.
    % Argument names are returned as strings.
    %
    % If the structure options contains a field named in the string array
    % argNames the name and value are added to the result.
    %
    % Duplicate arguments are overwritten.
    % Named option arguments overwrite initial arguments.
    % In both initial arguments the last entry is used.
    % In named arguments repeated name values have no effect as the struct can
    % only have one field with a given name.
    %
    % Initial arguments must be provided as a 1D cell array with pair of scalar
    % text labels followed by argument values.
    %
    % Examples:
    %   args = matlab.internal.utils.addArgs(options, ["authMethod", "profileName"]);
    %   x = myFunc(args{:});

    % TODO Consider extending to allow populating based on named object properties in
    % addition to struct fields

    %   (c) 2024-2026 MathWorks, Inc.

    arguments
        options (1,1) struct
        argNames string
        initialArgs cell = {}
    end

    cm = containers.Map;
    if ~isempty(initialArgs)
        if length(initialArgs) > 1 && height(initialArgs) > 1
            error("ADDARGS:INITSIZE", "Expected initialArgs to be empty or one dimensional.");
        end
        if mod(numel(initialArgs),2) ~= 0
            error("ADDARGS:INITEVEN", "Expected initialArgs to have an even number of elements.");
        end

        for n = 1:2:numel(initialArgs)
            if ischar(initialArgs{n}) || isStringScalar(initialArgs{n})
                cm(initialArgs{n}) = initialArgs{n+1};
            else
                error("ADDARGS:INITSTRING", "Expected initialArgs entry: %d to be a char or scalar string.", n);
            end
        end
    end

    for n = 1:numel(argNames)
        if isfield(options, argNames(n))
            cm(argNames(n)) = options.(argNames(n));
        end
    end

    if cm.Count > 0
        args = cell(1, cm.Count*2);
        k = cm.keys;
        v = cm.values;
        for n = 1:numel(k)
            args{n*2-1} = string(k{n});
            args{n*2} = v{n};
        end
    else
        args = {};
    end
end