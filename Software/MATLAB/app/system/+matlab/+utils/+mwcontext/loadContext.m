function ctx = loadContext(input)
    % loadContext  Custom load for JSON

    % Copyright 2026 The MathWorks, Inc.

    arguments 
        input string {mustBeNonzeroLengthText}
    end

    if isfile(input)
        input = fileread(input);
    end

    % First make a simple struct of this
    S = jsondecode(input);

    ctx = matlab.utils.mwcontext.Context();
    ctx.type = S.type;
    ctx.username = S.username;

    warnStruct = warning('off', 'JSONMapper:discriminator:calledfromconstructor');
    turnBackAfter = onCleanup(@() warning(warnStruct));
    useCell = iscell(S.operations);
    for k=1:numel(S.operations)
        if useCell
            op = S.operations{k};
        else
            op = S.operations(k);
        end
        opJSON = jsonencode(op);
        ope = matlab.utils.mwcontext.(op.type)(opJSON);
        % ope = matlab.utils.mwcontext.(op.type)()
        % ope = ope.fromJSON(opJSON);
        ctx.operations(k) = ope;
    end
end
