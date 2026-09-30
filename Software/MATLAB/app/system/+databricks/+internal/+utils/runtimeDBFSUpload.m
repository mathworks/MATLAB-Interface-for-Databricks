function tf = runtimeDBFSUpload(options)
    % RUNTIMEDBFSUPLOAD Uploads a MATLAB runtime to DBFS in parts
    % The runtime is first downloaded, then split into parts
    % each of which is uploaded with retries, a merge command is then produced
    % as a notebook.
    % By default the release corresponding to the current MATLAB release is used.
    %
    % Write access to DBFS is required.
    %
    % Optional named parameters:
    %        runtimeURL: URL of the MATLAB runtime to download
    %
    %           retries: Number of times a DBFS upload will be attempted for each part
    %                    of the split file, default is 3
    %
    %            blocks: The number of block to split a runtime file into, default: 10
    %
    %           release: Default is the current release, example: "R2023b"
    %
    %  localDestination: Location to store the downloaded runtime locally. Default: "<home directory>/Downloads"
    %
    % remoteDestination: Location to store the runtime on DBFS. Default: "/MathWorks/runtime"

    %  Copyright 2023-2026 MathWorks, Inc.

    arguments
        options.runtimeURL string {mustBeTextScalar, mustBeNonzeroLengthText}
        options.release string {mustBeTextScalar, mustBeNonzeroLengthText}
        options.blocks (1,1) int32 {mustBePositive, mustBeFinite, mustBeReal} = 10
        options.retries (1,1) int32 {mustBePositive, mustBeFinite, mustBeReal} = 3
        options.remoteDestination string {mustBeTextScalar} = "/MathWorks/runtime"
        options.localDestination string {mustBeTextScalar} = fullfile(matlab.utils.getHomeDirectory(), "Downloads")
        options.clusterId string {mustBeTextScalar, mustBeNonzeroLengthText}
        options.overwriteRuntime (1,1) logical = false
        options.authMethod (1,1) matlab.databricks.AuthMethod
        options.profileName string {mustBeTextScalar, mustBeNonzeroLengthText} = databricks.internal.configurationprofile.ConfigFile.getDefaultProfileName
    end

    if isfield(options, 'runtimeURL')
        runtimeURL = options.runtimeURL;
    else
        if isfield(options, 'release')
            runtimeURL = databricks.internal.mlRuntime.getMATLABRuntimeDownloadURL(release=options.release);
        else
            runtimeURL = databricks.internal.mlRuntime.getMATLABRuntimeDownloadURL();
        end
    end

    disp("Checking for an existing copy of the MATLAB runtime");
    if ~isempty(runtimeURL) && strlength(runtimeURL) > 0
        args = matlab.utils.addArgs(options, ["authMethod", "profileName"]);
        if databricks.internal.mlRuntime.runtimeExists(runtimeURL, options.remoteDestination, args{:})
            fprintf("MATLAB runtime: %s found in: %s\n", runtimeURL, options.remoteDestination);
            if options.overwriteRuntime
                disp("Overwriting existing runtime");
            else
                disp("Not overwriting existing runtime");
                tf = true;
                return;
            end
        else
            disp("Runtime not found");
        end
    else
        disp("No runtime URL found");
        tf = false;
        return;
    end

    % Download uses websave, no auth required
    fileToUpload = doFileDownload(runtimeURL, overwrite=false, destination=options.localDestination);
    fprintf("\n");

    args = matlab.utils.addArgs(options, ["authMethod", "profileName", "clusterId"]);
    tf = databricks.internal.utils.largeFileDBFSUpload(fileToUpload, options.remoteDestination, args{:});
end


function downloadedFile = doFileDownload(fileURL, options)
    arguments
        fileURL string {mustBeTextScalar, mustBeNonzeroLengthText}
        options.overwrite (1,1) logical = false
        options.destination string {mustBeTextScalar, mustBeNonzeroLengthText} = fullfile(matlab.utils.getHomeDirectory(), "Downloads")
    end

    fprintf("Downloading file: %s\n", fileURL);

    fields = split(fileURL, '/');
    URLFileName = fields(end);
    downloadedFile = fullfile(options.destination, URLFileName);
    if isfile(downloadedFile)
        fprintf("File found: %s\n", downloadedFile);
        if options.overwrite
            fprintf("Overwriting: %s\n", downloadedFile);
            response = 'n';
        else
            response = strip(input('Skip download: [Y]/N: ', 's'));
        end
        if isempty(response) || strcmpi(response, 'y')
            fprintf("Skipping download\n");
        else
            fprintf("Beginning download...\n");
            downloadedFile = websave(downloadedFile, fileURL);
        end
    else
        fprintf("Beginning download...\n");
        downloadedFile = websave(downloadedFile, fileURL);
    end
    fprintf("Download complete: %s\n", downloadedFile);
end