function req = getRequestMessage(obj, method)
    % GETREQUESTMESSAGE Get the request message to call the MLflow API
    %
    %    req = obj.getRequestMessage
    %
    %  will return a matlab.net.http.RequestMessage with the correct
    %  authorization information set.
    %
    %    req = obj.getRequestMessage('POST')
    %
    %  will create a similar RequestMessage with the correct method set too.


    %  (c) 2019-2024 MathWorks, Inc.

    req = matlab.net.http.RequestMessage;
    req.Header = obj.getAuthorizationField();

    req.Header(end+1) = matlab.net.http.field.ContentTypeField('application/json');

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
            error([ ...
                'The method to a request must be either a string or char ("POST", ''GET'', etc.)', newline, ...
                'or a an object of type matlab.net.http.RequestMethod', newline]);
        end
    end
end
