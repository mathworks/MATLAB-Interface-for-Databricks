function out = fSISO(in)
    % fSISO - Single input, single output
    %
    % There is a difference in behaviour for outputs depending on 1 or many
    % arguments. This should check that this is ok.

    % Copyright 2023 MathWorks, Inc.

    factor = cast(5, 'like', in);

    out = factor * in;

end