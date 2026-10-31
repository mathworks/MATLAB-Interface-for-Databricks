function tf = deleteDesktopCluster(options)
    % DELETEDESKTOPCLUSTER Deletes the current Databricks cluster used for MATLAB Desktop
    %
    % Warning: unsaved work may be lost!
    %
    % Requires the MW_CLUSTER_ID environment variable to be set.
    % Returns false if the cluster cannot be found or the MATLAB is not on Databricks.
    % By default calls finish before deleting the cluster which will not gracefully
    % shutdown MATLAB.
    %
    % Example:
    %   tf = matlab.databricks.cluster.deleteDesktopCluster()

    % Copyright 2025-2026 MathWorks, Inc

    arguments
        options.authMethod (1,1) matlab.databricks.AuthMethod
        options.profileName string {mustBeTextScalar, mustBeNonzeroLengthText} = databricks.internal.configurationprofile.ConfigFile.getDefaultProfileName
        options.runFinish (1,1) logical = true
        options.force (1,1) logical = false
    end

    tf = false;

    if databricks.internal.isOnDatabricks()
        clusterId = getenv("MW_CLUSTER_ID");
        if ~isempty(clusterId) && strlength(clusterId) > 0
            args = matlab.utils.addArgs(options, ["authMethod", "profileName"]);
            clusterObj = databricks.Cluster.findById(clusterId, args{:});
            if isempty(clusterObj)
                fprintf(2, "Cluster not found check MW_CLUSTER_ID environment variable: %s\n", clusterId)
            end
            if options.runFinish
                finish();
            end

            if options.force
                tf = true;
                clusterObj.permanentDelete();
            else
                fprintf(2, "WARNING: Deleting the cluster hosting this MATLAB session. Work not saved to /Volumes or /Workspace WILL BE LOST.\n");
                if matlab.utils.ynQuestion("Do you wish to proceed", "N")
                    % last chance to ctrl-c interactively
                    delay = 3;
                    for n =1:delay
                        fprintf(".");
                        pause(1);
                    end
                    fprintf("\nDeleting...\n");
                    pause(1);
                    tf = true;
                    clusterObj.permanentDelete();
                else
                    fprintf("Skipping deletion.\n");
                end
            end
        else
            fprintf(2, "MW_CLUSTER_ID environment variable not set, cannot delete cluster.\n");
        end
    else
        fprintf(2, "Not running on Databricks, cannot delete cluster.\n");
    end
end