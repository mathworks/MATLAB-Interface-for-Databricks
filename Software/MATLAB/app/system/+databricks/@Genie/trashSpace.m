function [result, errorResponse] = trashSpace(obj, id)
    % TRASHSPACE Move a Genie Space to the trash
    %
    % Example:
    %   g = databricks.Genie;
    %   [result, errorResponse] = g.trashSpace("e1ef34712a29169db030324fd0e1df5f");
    %
    % See also: https://docs.databricks.com/api/workspace/genie/trashspace

    % Copyright 2025-2026 The MathWorks, Inc.

    arguments
        obj databricks.Genie
        id string {mustBeTextScalar, mustBeNonzeroLengthText}
    end

    % Get URI
    URI = obj.getURI('genie', 'spaces');

    URI.Path(end+1) = id;
   
    % Start a DELETE request
    request = obj.getRequestMessage('DELETE');

    % Perform the actual call
    resp = request.send(URI, obj.HTTPOptions);

    if resp.StatusCode == matlab.net.http.StatusCode.OK
        result = true;
        errorResponse = databricks.datastructures.ErrorResponse.empty;
    else
        result = false;
        errorResponse = databricks.datastructures.ErrorResponse().fromJSON(resp.Body.Data);
    end
end