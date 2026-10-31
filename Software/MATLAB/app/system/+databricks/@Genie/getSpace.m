function [result, errorResponse] = getSpace(obj, id)
    % GETSPACE Retrieve the information for a Genie Space
    %
    % Example:
    %   g = databricks.Genie;
    %   spaceId = "e1ef34712a29169db030324fd0e1df5f";
    %   space = g.getSpace(spaceId);
    %
    % See also: https://docs.databricks.com/api/workspace/genie/getspace

    % (c) 2025-2026 The MathWorks Inc

    arguments
        obj databricks.Genie
        id string {mustBeTextScalar, mustBeNonzeroLengthText}
    end

    % Get URI
    URI = obj.getURI('genie', 'spaces');

    URI.Path(end+1) = id;
    
    request = obj.getRequestMessage('GET');

    resp = request.send(URI, obj.HTTPOptions);
    if resp.StatusCode == matlab.net.http.StatusCode.OK
        result = databricks.datastructures.genie.Space().fromJSON(resp.Body.Data);
        errorResponse = databricks.datastructures.ErrorResponse.empty;
    else
        result = databricks.datastructures.genie.Space.empty;
        errorResponse = databricks.datastructures.ErrorResponse().fromJSON(resp.Body.Data);
    end
end