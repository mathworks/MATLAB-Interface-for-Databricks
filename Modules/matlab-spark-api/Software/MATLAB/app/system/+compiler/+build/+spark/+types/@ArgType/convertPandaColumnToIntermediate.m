function codeOut = convertPandaColumnToIntermediate(obj, codeIn)
    % convertPandaColumnToIntermediate Panda columns to intermediate
    %
    % For some datatypes, an intermediate representation is
    % necessary (e.g. timestamps). If no conversion is necessary,
    % this just returns the same value

    % Copyright 2023 The MathWorks, Inc.

    codeOut = sprintf('%s.tolist()', codeIn);

end