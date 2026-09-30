function ret = needsOutputTransformer(obj)
    % needsOutputTransformer Returns true if output transformer needed

    % Copyright 2023 The MathWorks, Inc.

    ret = false;
    if obj.nArgOut == 0
        return;
    end
    outTypes = obj.getOutputElements();

    ret = obj.hasOutputArrays();
    if ~ret
        % Check for timestamps
        ret = any("datetime"==[outTypes.MATLABType]);
    end

end
