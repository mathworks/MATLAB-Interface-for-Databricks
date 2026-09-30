classdef ResponseException < MException
    % RESPONSEEXCEPTION Exception class for throwing exceptions related to
    % failed REST calls. The failed HTTP Response and a customErrorMsg are
    % provided as inputs and the class then automatically forms an
    % infomative error message. The error message is the same as formed by
    % matlab.databricks.internal.responseError but ResponseException also preserves the full response
    % body which can for example be used in unit tests to verify a specific
    % expected error occurred.
    
    % (c) 2022 MathWorks, Inc.

    properties
        % Original Body of the HTTP Response
        body
    end

    methods
        function obj = ResponseException(resp, customErrorMsg,options)
            % RESPONSEEXCEPTION Constructor
            arguments
                resp matlab.net.http.ResponseMessage
                customErrorMsg string
                options.component = "DATABRICKS"
                options.mnemonic = "ERROR"
            end
            
            msgID = options.component + ":" + options.mnemonic;
            
            if isstruct(resp.Body.Data)
                if isfield(resp.Body.Data, 'error_code') && isfield(resp.Body.Data, 'message')
                    message = sprintf('%s \n  error_code: %s \n  message: %s', char(customErrorMsg), char(resp.Body.Data.error_code), char(resp.Body.Data.message));
                else
                    message = sprintf('%s\n  Unexpected response body data struct', char(customErrorMsg));
                end
            elseif ischar(resp.Body.Data) ||  isStringScalar(resp.Body.Data)
                message = sprintf('%s\n  %s', char(customErrorMsg), char(resp.Body.Data));
            else
                message = sprintf('%s\n  Unexpected response body data', char(customErrorMsg));
            end
            
            obj@MException(msgID,message);
            obj.body = resp.Body.Data;
        end
    end
end