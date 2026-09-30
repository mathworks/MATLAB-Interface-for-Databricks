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
    %   [tf, proxyURI] = matlab.internal.databricks.detectProxy()

    % Copyright 2022-2026 The MathWorks, Inc.

    arguments (Output)
        tf (1,1) logical
        proxyURI matlab.net.URI
    end

    opts = databricks.internal.getHTTPOptionsImpl(convertResponse=true);

    % If the setting to not use the proxy is set just return
    if ~opts.UseProxy
        tf = false;
        proxyURI = matlab.net.URI.empty;
        return;
    end

    % If the httpOptions returns a URI use that an return
    if opts.UseProxy && ~isempty(opts.ProxyURI) && strlength(opts.ProxyURI) >0
        % Get <package>-http.json override value
        tf = true;
        proxyURI = matlab.net.URI(opts.ProxyURI);
        return;
    end

    % Check MATLAB proxy settings
    proxyURI = getMATLABProxyURI();
    if isempty(proxyURI) && ispc && usejava('jvm')
        % If the MATLAB proxy is not set check the system proxy
        % Only works on Windows with MATLAB Java support
        proxyURI = getSystemProxy();
    end
    tf = ~isempty(proxyURI);
end


function proxyURI = getSystemProxy()
    arguments (Output)
        proxyURI matlab.net.URI
    end

    if ispc && usejava('jvm')
        % Check the initial state
        initState = char(java.lang.System.getProperty("java.net.useSystemProxies"));
        cleanupObj = onCleanup(@()resetState(initState));

        % Set it to true and get proxy value
        java.lang.System.setProperty("java.net.useSystemProxies","true");
        URIj = java.net.URI("https://www.mathworks.com");
        listJ =  java.net.ProxySelector.getDefault().select(URIj);
        iteratorJ = listJ.iterator();
        % Don't iterate we only care about the first value
        if iteratorJ.hasNext()
            nextJ = iteratorJ.next();
            if strcmpi('DIRECT', char(nextJ.toString))
                % No proxy in direct mode return empty
                proxyURI = matlab.net.URI.empty;
            else
                addressJ = nextJ.address();
                if isa(addressJ, java.net.InetSocketAddress)
                    proxyURI = matlab.net.URI(char(addressJ.toString));
                else
                    warning("DATABRICKS:PROXY", "Expected a java.net.useSystemProxies state: %s", initState)
                    proxyURI = matlab.net.URI.empty;
                end
            end
        else
            % No value, return the empty
            proxyURI = matlab.net.URI.empty;
        end
    else
        proxyURI = matlab.net.URI.empty;
    end
end

function resetState(initState)
    % Reset the state to false after the call if it was not true
    if strcmpi(initState, 'false') || isempty(initState)
        % Reset to false
        java.lang.System.setProperty("java.net.useSystemProxies","false");
    elseif strcmpi(initState, 'true')
        % If the initial state was true, do nothing
    else
        % Should not get here
        warning("DATABRICKS:PROXY", "Unexpected java.net.useSystemProxies state: %s", initState);
    end
end


function proxyURI = getMATLABProxyURI()
    % GETPROXYURI Get the proxy URI from MATLAB settings or Java properties
    arguments (Output)
        proxyURI matlab.net.URI
    end

    if getUseProxy()
        proxyHost = getProxyHost();
        if ~isempty(proxyHost) && strlength(proxyHost) > 0
            proxyPort = getProxyPort();
            if ~isempty(proxyPort) && strlength(proxyPort) > 0
                proxyURI = matlab.net.URI("https://" + proxyHost + ":" + proxyPort);
            else
                proxyURI = matlab.net.URI("https://" + proxyHost);
            end
        else
            proxyURI = matlab.net.URI.empty;
        end
    else
        proxyURI = matlab.net.URI.empty;
    end
end


function tf = getUseProxy()
    % GETUSEPROXY Get the UseProxy setting from MATLAB preferences or settings
    arguments (Output)
        tf (1,1) logical
    end

    if isMATLABReleaseOlderThan("R2025a")
        tf = com.mathworks.services.Prefs.getBooleanPref('HTMLUseProxy'); %#ok<JAPIMATHWORKS>
    else
        s = settings;
        if isprop(s, "matlab") && isprop(s.matlab, "web") && isprop(s.matlab.web, "UseProxy") && isprop(s.matlab.web.UseProxy, "ActiveValue")
            tf = s.matlab.web.UseProxy.ActiveValue;
        else
            tf = false;
        end
    end
end


function host = getProxyHost()
    % GETPROXYHOST Get the proxy host from MATLAB settings or Java properties
    arguments (Output)
        host string
    end

    if isMATLABReleaseOlderThan("R2025a")
        host = string(java.lang.System.getProperty('tmw.proxyHost'));
    else
        s = settings;
        if isprop(s, "matlab") && isprop(s.matlab, "web") && isprop(s.matlab.web, "ProxyHost") && isprop(s.matlab.web.ProxyHost, "ActiveValue")
            host = string(s.matlab.web.ProxyHost.ActiveValue);
        else
            host = string.empty;
        end
    end
end


function port = getProxyPort()
    % GETPROXYPORT Get the proxy port from MATLAB settings or Java properties
    arguments (Output)
        port string
    end

    if isMATLABReleaseOlderThan("R2025a")
        port = string(java.lang.System.getProperty('tmw.proxyPort'));
    else
        s = settings;
        if isprop(s, "matlab") && isprop(s.matlab, "web") && isprop(s.matlab.web, "ProxyPort") && isprop(s.matlab.web.ProxyPort, "ActiveValue")
            port = s.matlab.web.ProxyPort.ActiveValue;
        else
            port = string.empty;
        end
    end
end
