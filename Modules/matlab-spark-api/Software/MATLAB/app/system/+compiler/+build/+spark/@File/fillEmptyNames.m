function fillEmptyNames(obj)
    % fillEmptyNames Set names for arguments that weren't given any

    % Copyright 2022-2024 The MathWorks, Inc.

    try
        [inArgCandidates, outArgCandidates] = compiler.build.spark.internal.getArgNames(obj.name);
    catch ME
        % If this fails, just don't use it.
        inArgCandidates = "in_" + (1:obj.nArgIn);
        outArgCandidates = "out_" + (1:obj.nArgOut);
    end

    for k=1:length(obj.InTypes)
        if isempty(obj.InTypes(k).Name)
            obj.InTypes(k).Name = inArgCandidates(k);
        end
    end

    for k=1:length(obj.OutTypes)
        if isempty(obj.OutTypes(k).Name)
            obj.OutTypes(k).Name = outArgCandidates(k);
        end
    end
end

