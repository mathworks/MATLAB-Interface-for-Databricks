function modelVersions = getLatestVersions(obj, stages)
    % GETLATESTVERSIONS Latest version models for each requests stage
    % Only returns models with current READY status. If no stages are provided,
    % returns the latest version for each stage, including "None".
    %
    % An array of ModelVersions is returned.
    %
    % An optional character vector, cell array of character vectors, string or string
    % array of stages can be provided as the first optional argument.

    %  Copyright 2021-2022 MathWorks, Inc.

    clusterURI = obj.getURI('registered-models', 'get-latest-versions');
    request = obj.getRequestMessage('POST');

    payload.name = obj.name;
    if nargin > 1
        payload.stages = stages;
    end
    request.Body = matlab.net.http.MessageBody;
    request.Body.Payload = jsonencode(payload);

    resp = request.send(clusterURI, getHTTPOptions('ConvertResponse', false));

    if resp.StatusCode == matlab.net.http.StatusCode.OK

        if resp.Body.Data == "{}"
            modelVersions = mlflow.ModelVersion.empty;
        else
            % The result can probably be an array of structs, so we
            % need to fix the encode arguments in the jsondecode call
            allowMissing = true;
            data = mlflow.jsondecode(resp.Body.Data, allowMissing, {"model_version", "creation_timestamp"}, "int64", {"model_version", "last_updated_timestamp"}, "int64");  %#ok<CLARRSTR>
            if isfield(data,'model_versions')
                % We have a non-empty response
                mvs = data.model_versions;
                N = numel(mvs);
                modelVersions = mlflow.ModelVersion.empty;
                for k=1:N
                    MV = mvs(k);
                    FN = fieldnames(MV);
                    mv = mlflow.ModelVersion();
                    for f = 1:numel(FN)
                        F = FN{f};
                        val = MV.(F);
                        switch F
                            case 'tags'
                                if isempty(val)
                                    mv.(F) = mlflow.ModelVersionTag.empty;
                                else
                                    mv.(F) = mlflow.ModelVersionTag(val);
                                end
                            otherwise
                                mv.(F) = val;
                        end
                    end
                    modelVersions(k) = mv;
                end
            else
                error('MLFLOW:ERROR', 'Failed to get model version\n%s', char(resp));
            end
        end

    else
        % Could not get model version
        error('MLFLOW:ERROR', 'Failed to get model version\n%s', char(resp));
    end

end
