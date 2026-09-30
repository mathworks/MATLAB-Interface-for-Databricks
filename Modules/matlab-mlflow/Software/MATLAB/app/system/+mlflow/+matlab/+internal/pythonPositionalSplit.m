function i = pythonPositionalSplit(inputs,args)
    for i=1:length(inputs)
        if isstring(inputs{i}) && ismember(inputs{i},args)
            i = i-1; %#ok<FXSET>
            break
        end
    end