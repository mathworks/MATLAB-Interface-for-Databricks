function outArgs = unifyColArguments(args)
    % unifyColArguments Unify column arguments
    %
    % This is a helper function that ensures that arguments to a Python
    % function are consistent

    % Copyright 2024 MathWorks, Inc.

    if ~iscell(args)
        args = {args};
        wasSingleArg = true;
    else
        wasSingleArg = false;
    end

    outArgs = {};
    for k=1:length(args)
        switch class(args{k})
            case 'string'
                S = args{k};
                for n=1:numel(S)
                    outArgs{end+1} = S(n); %#ok<AGROW>
                end
            case 'char'
                outArgs{end+1} = string(args{k}); %#ok<AGROW>
            case 'matlab.pyspark.sql.column.Column'
                outArgs{end+1} = toPy(args{k}); %#ok<AGROW>
            case 'py.pyspark.sql.connect.column.Column'
                % No conversion necessary
                outArgs{end+1} = args{k}; %#ok<AGROW>
            case 'double'
                % No conversion necessary
                outArgs{end+1} = args{k}; %#ok<AGROW>
            case 'single'
                outArgs{end+1} = double(args{k}); %#ok<AGROW>
            case {'int64', 'int32', 'int16', 'int8'}
                outArgs{end+1} = int64(args{k}); %#ok<AGROW>
            otherwise
                error("SPARKAPI:PYCOLUMN_TYPES", "Bad type for a column argument, '%s'", class(args{k}));
        end
    end

    if wasSingleArg && isscalar(outArgs)
        outArgs = outArgs{1};
    end

end