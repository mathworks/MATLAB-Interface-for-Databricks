function tf = isArray(obj)
    % isArray Argument is an array
    
    % Copyright 2023 The MathWorks, Inc.
    
    tf = getVectorLength(obj) > 1;
end