function ret = needsOutputConversion(file)
    % needsOutputConversion Check if outputs need to be converted
    %
    % This is the case, e.g. with Timestamp data.

    % Copyright 2023 The MathWorks, Inc.

    elems = file.getOutputElements();

    ret = false;
    name = "x";
    for k=1:length(elems)
        curElem = elems(k);
        conversion = curElem.convertMWValueForPython(name);
        if conversion ~= name
            ret = true;
            break;
        end
    end
end

