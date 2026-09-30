function result = list(obj, varargin)
    % LIST List artifacts for a run
    % If no arguments are provided the run_id, path and page_token are taken
    % from the object otherwise the required run_id is taken as the first
    % argument and the path and page_token arguments are optionally provided
    % as name value pairs.
    % A path value is used to return only artifacts with the specified prefix.
    % This can be used to provide for directory hierarchy.
    % All arguments must be provided as character vectors or scalar strings.
    % If there are no results an empty double is returned.
    % Results are returned as a structure containing the root_uri and an array of
    % mlflow.FileInfo objects.
    % If there is no files matching the query there will be no files field.
    % If a FileInfo object corresponds to a directory the is_dir field value will be
    % true and the file_size will be 0.
    %
    % Example:
    %   % Return a list of artifacts for run myRun, overriding and id set in myArtifact
    %   resultsList = myArtifact.list(myRun.run_id)
    %   resultsList =
    %     struct with fields:
    %       root_uri: 'dbfs:/artifactDirectory/45b57414530c4100bbebb2b36dd2a1ee/artifacts'
    %          files: [1x2 mlflow.FileInfo]
    %
    %
    %    % Use a pth prefix to list subdirectory contents
    %    resultsList = myArtifact.list(myRun.run_id, 'path', 'prefixDir')
    %    resultsList =
    %      struct with fields:
    %        root_uri: 'dbfs:/artifactDirectory/45b57414530c4100bbebb2b36dd2a1ee/artifacts'
    %           files: [1x1 mlflow.FileInfo]
    %
    %    resultsList.files(1)
    %    ans =
    %      FileInfo with properties:
    %             path: "prefixDir/myFile.txt"
    %           is_dir: 0
    %        file_size: 128

    %  (c) 2020-2022 MathWorks, Inc.

    % Validation function
    validString = @(x) ischar(x) || isStringScalar(x);

    % Parse the inputs
    if isempty(varargin)
        % No arguments so take id from the object
        run_id = obj.run_id;
    else
        % At least one argument so take all call arguments from method arguments
        p = inputParser;
        p.CaseSensitive = false;
        p.FunctionName = 'list';
        % A run_id is always required
        p.addRequired('run_id',validString);
        % path and page_token set as name value pairs, default to empty
        addParameter(p,'path', string.empty, validString);
        addParameter(p,'page_token', string.empty, validString);
        parse(p,varargin{:});
        % Pass as strings to match obj types
        run_id = string(p.Results.run_id);
        pathStr = string(p.Results.path);
        page_token = string(p.Results.page_token);
    end

    % run_id is a required argument
    if strlength(run_id) > 0
        arguments = {'run_id', run_id};
    else
        error('MLFLOW:ERROR', 'run_id property is not set');
    end
    % Include path and page_token only if length > zero or empty
    if strlength(pathStr) > 0
        arguments{end + 1} = 'path';
        arguments{end + 1} = pathStr;
    end
    if strlength(page_token) > 0
        arguments{end + 1} = 'page_token';
        arguments{end + 1} = page_token;
    end

    % Build the request
    clusterURI = obj.getURI('artifacts', 'list', arguments{:});
    request = obj.getRequestMessage('GET');

    % Call the backend
    [resp, complete] = request.send(clusterURI, getHTTPOptions('ConvertResponse', false)); %#ok<ASGLU>

    % Process the results
    if resp.StatusCode == matlab.net.http.StatusCode.OK
        allowMissing = true;
        resp.Body.Data = mlflow.jsondecode(resp.Body.Data, allowMissing, {"files", {':'}, "file_size"}, "int64");
        if ~isempty(fieldnames(resp.Body.Data))
            % We have a non-empty response, root_uri should always be present
            if isfield(resp.Body.Data, 'root_uri')
                result.root_uri = resp.Body.Data.root_uri;
            else
                error('MLFLOW:ERROR', 'root_uri field not found');
            end
            % This field may not be present if all results are returned by this call
            if isfield(resp.Body.Data, 'next_page_token')
                result.next_page_token = resp.Body.Data.next_page_token;
            end
            % Files should always be present
            if isfield(resp.Body.Data, 'files')
                result.files = mlflow.FileInfo.empty;
                for n = 1:numel(resp.Body.Data.files)
                    % Results can be returned as an array or cell array
                    if iscell(resp.Body.Data.files)
                        currFile = resp.Body.Data.files{n};
                    else
                        currFile = resp.Body.Data.files(n);
                    end
                    if currFile.is_dir
                        result.files(n) = mlflow.FileInfo(currFile.path, currFile.is_dir, int64.empty);
                    else
                        result.files(n) = mlflow.FileInfo(currFile.path, currFile.is_dir, currFile.file_size);
                    end
                end
            end
        else
            % We have an empty response, should not happen with a well formed query
            error('MLFLOW:ERROR', 'Unexpected empty response');
        end
    else
        % Could not list the artifact
        error('MLFLOW:ERROR', 'Failed to list artifact: %s, %s, %s', resp.StatusCode.getReasonPhrase, resp.StatusCode.string, resp.StatusLine);
    end

end %function
