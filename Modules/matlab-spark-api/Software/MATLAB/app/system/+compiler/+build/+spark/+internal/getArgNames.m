function [inArgs, outArgs] = getArgNames(fileName)
    % getArgNames Return arg names of a function
    %
    % This function is only used internally, and the methods use here are
    % only for internal use and liable to change.

    % Copyright 2022 The MathWorks, Inc.

    % Parse file
    t = mtree(fileName, '-file');

    % Only use the main function
    t = t.root;
    
    % Get inputs
    inArgs = string.empty;
    outArgs = string.empty;
    ins = t.Ins;
    while ~ins.isempty
        inArgs(end+1) = ins.string; %#ok<AGROW>
        ins = ins.Next;
    end
    % Get outputs
    outs = t.Outs;
    while ~outs.isempty
        outArgs(end+1) = outs.string; %#ok<AGROW>
        outs = outs.Next;
    end
end