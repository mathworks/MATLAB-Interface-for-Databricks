function payload = getPayload(obj)
    % GETPAYLOAD Internal method to create the request payload by removing properties

    %   Copyright 2019-2022 MathWorks, Inc.

    % Create a candidate payload
    candidate.experiment_id = obj.experiment_id;

    % Set a timestamp if nothing exists
    if isempty(obj.start_time)
        candidate.start_time = getCurrentTimeUnixINT64;
    else
        candidate.start_time = obj.start_time;
    end

    if ~isempty(obj.data.tags)
        candidate.tags = obj.data.tags;
    end

    payload = jsonencode(candidate);

end %function
