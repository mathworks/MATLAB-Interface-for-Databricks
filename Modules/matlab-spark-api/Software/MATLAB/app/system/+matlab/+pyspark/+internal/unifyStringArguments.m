function out_args = unifyStringArguments(args)
    % unifyStringArguments Unify string arguments
    %
    % This will unify several string arguments to always be a cell array of
    % single strings. This make conversions and argument handling easier.

    % Copyright 2024 MathWorks, Inc.

    out_args = {};
     for k=1:length(args)
        switch string(class(args{k}))
            case "string"
                % Do nothing
                s = args{k};
                for n = 1:numel(s)
                    out_args{end+1} = s(n); %#ok<AGROW>
                end
            case "char"
                out_args{end+1} = string(args{k}); %#ok<AGROW>
        end
     end

end