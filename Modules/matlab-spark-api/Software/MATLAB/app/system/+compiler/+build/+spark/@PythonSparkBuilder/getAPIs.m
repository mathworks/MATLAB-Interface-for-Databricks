function apis = getAPIs(obj, flat)
    % getAPIs Retrieve APIs from File entries
    %
    % These APIs consist of the python helper functions generated.
    % The output can be either flat (default), or structured. In the
    % structured case, the APIs are organized by the file they were
    % generated for.

    % Copyright 2022 The MathWorks, Inc.

    if nargin < 2
        flat = true;
    else
        flat = logical(flat);
    end

    apis = struct();
    if flat
        for k=1:length(obj.Files)
            F = obj.Files(k);
            Fname = F.funcName;
            fn = string(fieldnames(F.API));
            for ai = 1:length(fn)
                FN = fn(ai);
                prop = Fname + "_" + FN;
                apis.(prop) = F.API.(FN);
            end
        end
    else
        for k=1:length(obj.Files)
            F = obj.Files(k);
            Fname = F.funcName;
            apis.(Fname) = F.API;
        end
    end

end
