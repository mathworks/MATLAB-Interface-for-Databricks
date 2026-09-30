function sparkVersions = getSparkVersions(options)
    % GETSPARKVERSIONS Method to fetch the available spark versions
    % Return the list of available Spark versions. These versions can be used
    % to launch a cluster.
    %
    % Optional named arguments
    %   authMethod     A matlab.databricks.AuthMethod
    %   profileName    A configuration file profileName value
    %
    % Example:
    %
    %   cl = databricks.Cluster;
    %   sparkVer = cl.getSparkVersions();
    %
    %   sparkVer =
    %   55×2 table
    %                   key                                               name                             
    %     ________________________________    _____________________________________________________________
    %     "10.4.x-cpu-ml-scala2.12"           "10.4 LTS ML (includes Apache Spark 3.2.1, Scala 2.12)"      
    %     "10.4.x-gpu-ml-scala2.12"           "10.4 LTS ML (includes Apache Spark 3.2.1, GPU, Scala 2.12)" 
    %     "10.4.x-photon-scala2.12"           "10.4 LTS Photon (includes Apache Spark 3.2.1, Scala 2.12)"  
    %     "10.4.x-scala2.12"                  "10.4 LTS (includes Apache Spark 3.2.1, Scala 2.12)"         
    %     "11.3.x-cpu-ml-scala2.12"           "11.3 LTS ML (includes Apache Spark 3.3.0, Scala 2.12)"      
    %     "11.3.x-gpu-ml-scala2.12"           "11.3 LTS ML (includes Apache Spark 3.3.0, GPU, Scala 2.12)" 
    %     "11.3.x-photon-scala2.12"           "11.3 LTS Photon (includes Apache Spark 3.3.0, Scala 2.12)"  
    %     "11.3.x-scala2.12"                  "11.3 LTS (includes Apache Spark 3.3.0, Scala 2.12)"         
    %     "12.2.x-cpu-ml-scala2.12"           "12.2 LTS ML (includes Apache Spark 3.3.2, Scala 2.12)"      
    %     "12.2.x-gpu-ml-scala2.12"           "12.2 LTS ML (includes Apache Spark 3.3.2, GPU, Scala 2.12)" 
    %     "12.2.x-photon-scala2.12"           "12.2 LTS Photon (includes Apache Spark 3.3.2, Scala 2.12)"  
    %                    :                                                  :                              
    %     "15.4.x-photon-scala2.12"           "15.4 LTS Photon (includes Apache Spark 3.5.0, Scala 2.12)"  
    %     "15.4.x-scala2.12"                  "15.4 LTS (includes Apache Spark 3.5.0, Scala 2.12)"         
    %     "16.0.x-cpu-ml-photon-scala2.12"    "16.0 ML Beta (includes Apache Spark 3.5.0, Scala 2.12)"     
    %     "16.0.x-cpu-ml-scala2.12"           "16.0 ML Beta (includes Apache Spark 3.5.0, Scala 2.12)"     
    %     "16.0.x-gpu-ml-scala2.12"           "16.0 ML Beta (includes Apache Spark 3.5.0, GPU, Scala 2.12)"
    %     "16.0.x-photon-scala2.12"           "16.0 Photon Beta (includes Apache Spark 3.5.0, Scala 2.12)" 
    %     "16.0.x-scala2.12"                  "16.0 Beta (includes Apache Spark 3.5.0, Scala 2.12)"        
    %     "9.1.x-cpu-ml-scala2.12"            "9.1 LTS ML (includes Apache Spark 3.1.2, Scala 2.12)"       
    %     "9.1.x-gpu-ml-scala2.12"            "9.1 LTS ML (includes Apache Spark 3.1.2, GPU, Scala 2.12)"  
    %     "9.1.x-photon-scala2.12"            "9.1 LTS Photon (includes Apache Spark 3.1.2, Scala 2.12)"   
    %     "9.1.x-scala2.12"                   "9.1 LTS (includes Apache Spark 3.1.2, Scala 2.12)"          
	%     Display all 55 rows.

    % (c) 2019-2026 MathWorks, Inc.

    arguments
        options.authMethod (1,1) matlab.databricks.AuthMethod
        options.profileName string {mustBeTextScalar, mustBeNonzeroLengthText} = databricks.internal.configurationprofile.ConfigFile.getDefaultProfileName
    end

    %% Get information about existing spark versions
    % Just creating a databricks.Object and authenticating this avoids a
    % lot of the initializations done in databricks.Cluster
    args = matlab.utils.addArgs(options, ["authMethod", "profileName"]);
    obj = databricks.Object;
    obj.getAuth(args{:});


    clusterURI = obj.getURI('clusters', 'spark-versions');
    request = obj.getRequestMessage('GET');

    % Call databricks
    resp = request.send(clusterURI, databricks.internal.getHTTPOptions(convertResponse=true));

    %% Process the results
    if resp.StatusCode == matlab.net.http.StatusCode.OK
        % Valid response so package and send back to user
        if isfield(resp.Body.Data, 'versions')
            nrows = numel(resp.Body.Data.versions);
        else
            nrows = 0;
        end
        sparkVersions = table('Size', [nrows, 2], 'VariableTypes', ["string", "string"], 'VariableNames', ["key", "name"]);
        for n = 1:nrows
            sparkVersions(n,:) = {string(resp.Body.Data.versions(n).key), string(resp.Body.Data.versions(n).name)};
        end
        sparkVersions = sortrows(sparkVersions, "key");
    else
        error('DATABRICKS:INVALIDRESPONSE',char(resp));
    end
end %function
