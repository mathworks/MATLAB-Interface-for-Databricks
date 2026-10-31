function req = getRequestMessage(obj, varargin)
    % GETREQUESTMESSAGE Get the request message to call the databricks API
    %
    %    req = obj.getRequestMessage
    %
    %  will return a matlab.net.http.RequestMessage with the correct
    %  authorization information set.
    %
    %    req = obj.getRequestMessage('POST')
    %
    %  will create a similar RequestMessage with the correct method set too.
    
    
    %  (c) 2019-2026 MathWorks, Inc.

        req = obj.objectImpl.getRequestMessage(varargin{:});
end %function

