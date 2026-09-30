function payload = getPayload(obj, varargin)
    % GETPAYLOAD Internal method to create the request payload by removing properties

    %  Copyright 2019-2022 MathWorks, Inc.


    candidate = struct;

    candidate.name = obj.name;
    if ~isempty(obj.artifact_location)
        candidate.artifact_location = obj.artifact_location;
    end

    candidate.tags = obj.tags;

    payload = jsonencode(candidate);

end %function
