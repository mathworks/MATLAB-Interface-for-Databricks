function determineMethodTypes(obj)
    % determineMethodTypes Determine what methods must be created
    %
    % The methods will differ for different function signatures.
    %
    
    % Copyright 2023-2025 The MathWorks, Inc.


    for k=1:length(obj.Files)
        file = obj.Files(k);
        determineMethodTypes(file);
    end

end

