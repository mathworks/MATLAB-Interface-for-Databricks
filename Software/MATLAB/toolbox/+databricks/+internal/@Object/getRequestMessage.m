function req = getRequestMessage(obj, method)
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


    % Copyright 2019-2026 The MathWorks, Inc.

    req = matlab.net.http.RequestMessage;
    req.Header = obj.getAuthorizationField();

    % Use the short user agent form: MathWorks_MATLAB/25.2.0
    % to match that used with other interfaces and to comply with sematic versioning
    req.Header(end+1) = matlab.net.http.HeaderField("User-Agent", obj.UserAgent);

    % Add telemetry string
    % MATLAB automatically adds a user-agent to the request
    % This is set to the version of MATLAB. eg: MATLAB 9.7.0.1112323 (R2019b)

    if nargin > 1
        req.Method = getMethod(method);
    end

end %function

function method = getMethod(method)
   if isa(method, 'matlab.net.http.RequestMethod')
       % This is the right type already, use it.
   else
       if ischar(method) || isstring(method)
           % This method will throw an error if method is not one of the
           % allowed types
           method = matlab.net.http.RequestMethod(method);
       else
           error('DATABRICKS:ERROR',...
           'The method to a request must be either a string or char ("POST", "GET", etc.)\nor a an object of type matlab.net.http.RequestMethod\n');
       end
   end
end
