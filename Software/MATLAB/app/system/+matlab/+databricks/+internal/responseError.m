function responseError(resp, varargin)
    % RESPONSEERROR Handles a HTTP response error
    % customErrorMsg is message to provide context from the calling function

    % (c) 2020-2022 MathWorks, Inc.

    if length(varargin) == 1 %#ok<ISCL>
        customErrorMsg = varargin{1};
    else
        customErrorMsg = sprintf(varargin{:});
    end

    % TODO consider allowing these to be set via optional name value pair arguments
    component  = 'DATABRICKS';
    mnemonic = 'ERROR';
    msgID = [component, ':', mnemonic];

    if isstruct(resp.Body.Data)
        if isfield(resp.Body.Data, 'error_code') && isfield(resp.Body.Data, 'message')
            if isnumeric(resp.Body.Data.error_code)
                error(msgID, '%s \n  error_code: %d \n  message: %s', char(customErrorMsg), resp.Body.Data.error_code, char(resp.Body.Data.message));
            else
                error(msgID, '%s \n  error_code: %s \n  message: %s', char(customErrorMsg), resp.Body.Data.error_code, char(resp.Body.Data.message));
            end
        else
            error(msgID, '%s\n  Unexpected response body data struct', char(customErrorMsg));
        end
    elseif ischar(resp.Body.Data) ||  isStringScalar(resp.Body.Data)
        error(msgID, '%s\n  %s', char(customErrorMsg), char(resp.Body.Data));
    else
        error(msgID, '%s\n  Unexpected response body data', char(customErrorMsg));
    end
end
