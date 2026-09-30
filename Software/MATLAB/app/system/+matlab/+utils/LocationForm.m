classdef LocationForm
    % LOCATIONFORM specifies if a location is a URI or path format
    %   PATH : location begins with '/'
    %   URI  : location begins with 'scheme:'

    % Copyright 2018 The MathWorks, Inc.

    enumeration
        URI
        PATH
    end

end %class
