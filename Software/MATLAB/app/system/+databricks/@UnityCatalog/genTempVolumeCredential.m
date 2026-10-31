function result = genTempVolumeCredential(obj, operation, volume_id)
    % GENTEMPVOLUMECREDENTIAL Generate a temporary volume credential
    %
    % Required Inputs:
    %   operation
    %       Description: 
    %           The operation performed against the volume data, either READ_VOLUME or WRITE_VOLUME.
    %       Type: 
    %           databricks.datastructures.unitycatalog.Operation
    %
    %   volume_id
    %       Description: 
    %           Id of the volume to read or write.
    %       Type: 
    %           string
    % Outputs:
    %   result  
    %       Description:
    %           A short-lived credential for directly accessing the volume data on cloud storage. 
    %       Type:
    %           databricks.datastructures.unitycatalog.GenTempColCredsResp
    %
    %
    % Examples:
    %   % Basic form
    %   result = uc.genTempVolumeCredential(operation, volume_id);
    %
    %
    %   % Get an Azure SAS to allow a read from MATLAB using copyfile rather than databricks.Files
    %   volName = "main.default.myvolume"
    %   uc = databricks.UnityCatalog;
    %   volInfo = uc.getVolume(volName);
    %   volumeId = volInfo.volume_id;
    %   operation = "READ_VOLUME";
    %   result = uc.genTempVolumeCredential(operation, volumeId);
    %   setenv("MW_WASB_SAS_TOKEN", "?"+result.azure_user_delegation_sas.sas_token);
    %   catalogPath = replace(volName, ".", "/") + "/MathWorks/runtimes/runtime_install.sh"
    %   [p,n,e] = fileparts(catalogPath);
    %   fname = n + e;
    %   dst = fullfile(pwd, fname);
    %   % Convert URL from abfss to wasbs and append the path
    %   % e.g. wasbs://container@account/path_to_file/file.ext
    %   wasbsUrl = replace(result.url, "abfss://", "wasbs://");
    %   wasbsUrl = replace(wasbsUrl, "" + ".dfs.", ".blob.");
    %   wasbsUrl = wasbsUrl + catalogPath;
    %   copyfile(wasbsUrl, dst);
    %
    %   % To write the volume use: operation = "WRITE_VOLUME"
    %   % Note that write are only supported to external volumes , not managed volumes
    %
    %   See also https://learn.microsoft.com/en-us/azure/databricks/external-access/credential-vending
    %            databricks.datastructures.unitycatalog.GenTempColCredsResp
    
    % Copyright 2026 The MathWorks, Inc.
    
    arguments (Input)
        obj databricks.UnityCatalog
        operation databricks.datastructures.unitycatalog.Operation
        volume_id string
    end
    arguments (Output)
        result databricks.datastructures.unitycatalog.GenTempColCredsResp
    end

    % Get URI
    URI = obj.getURI('unity-catalog','temporary-volume-credentials');

    % Start a POST request
    request = obj.getRequestMessage('POST');

    s = struct;
    s.operation = string(operation);
    s.volume_id = volume_id;

    request.Body(1).Payload = jsonencode(s);

    % Perform the actual call
    resp = request.send(URI, obj.HTTPOptions);
    
    if resp.StatusCode == matlab.net.http.StatusCode.OK
        result = databricks.datastructures.unitycatalog.GenTempColCredsResp().fromJSON(resp.Body.Data);
    else
        result = databricks.datastructures.unitycatalog.ErrorResponse().fromJSON(resp.Body.Data);
        result.throw();
    end
end