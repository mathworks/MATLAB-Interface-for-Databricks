function getPACValue(response) 
    % GETPACVALUE Gets the Value of the Personal Access Code (PAC)

    %   (c) 2022 MathWorks, Inc.
    
    global databrickspac %#ok<GVMIS> 
    
    % Destroy the active browser session
    activeBrowser = com.mathworks.mde.webbrowser.WebBrowser.getActiveBrowser; %#ok<JAPIMATHWORKS>
    if ~isempty(activeBrowser) % close UI if opened
        activeBrowser.close();
    end
    % response should have the form '?pac=myPACValueString'
    % pass through java.net.URLDecoder.decode()
    decodedStr = urldecode(response);
    
    if ~startsWith(decodedStr, '?pac=')
        error('DATABRICKS:INSTALL', 'Expected form response to begin with: ?pac=');
    end
    pac = decodedStr(6:end);
    if isempty(pac)
        error('DATABRICKS:INSTALL', 'A personal access token value is required');
    else
        databrickspac = pac;
    end
end