function [tf, proxyURI] = detectProxy()
% DETECTPROXY Detects if a HTTP proxy to be used and is configured
% If the databricks-http.json UseProxy flag is set to 1 (default) then
% the following options are checked in order to determine the HTTP proxy URI:
%    databricks-http.json ProxyURI field
%    MATLAB Proxy preferences
%    System proxy preferences (Windows only, & requires Java support)
%
% If the proxy is set to be used and a proxy is configured a logical true is
% returned, otherwise false.
%
% The proxy URI is optionally returned. the URI is returned as a
% matlab.net.URI, if no URI is available or the proxy is not set to be used
% an empty URI is returned.
%
% If the databricks-http.json UseProxy flag is set to 0 the false and an empty
% URI are returned.
%
% The URI is returned with a HTTPS scheme if the value is derived from the
% MATLAB preferences/settings.
%
% Example:
%   [tf, proxyURI] = matlab.databricks.detectProxy()

% (c) 2022-2026 The MathWorks, Inc.

[tf, proxyURI] = matlab.internal.databricks.detectProxy();

end