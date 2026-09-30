function payload = getPayload(obj, varargin)
    % GETPAYLOAD Internal method to create the request payload by removing properties

    %  Copyright 2021-2022 MathWorks, Inc.


    % Create a candidate payload
    candidate.name = obj.name;
    candidate.description = obj.description;
    candidate.tags = obj.tags;

    payload = jsonencode(candidate);

end %function
