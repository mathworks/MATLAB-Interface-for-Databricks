function configFileName = getConfigFile()
    % GETCONFIGFILE Returns the full name of a configuration file
    % Files are searched for in the following order:
    %   1)  <Home directory>/.mlflow-connect
    %   2)  mlflow.json on the MATLAB path
    %
    % This method should not be used if using Databricks
    % If no file is found then an empty character vector is returned.
    %    
    % Java's system properties are used to get a user's home directory.
   
    % Copyright 2020-2024 MathWorks, Inc.

    if mlflow.Object.isDatabricks
        fprintf(2, "mlflow.getConfigFile should not be used is using Databricks\n");
        configFileName = '';
        return;
    end

    % Databricks Connect configuration file
    userDir = char(java.lang.System.getProperty('user.home'));

    % These candidate will be tested in order. The first one found will be
    % returned to the user. If none is found, an empty string will be returned.
    configFileCandidates = { ...
        fullfile(userDir,'.mlflow-connect'), ...
        which('mlflow.json') ...
        };

    configFileName = '';
    for k=1:length(configFileCandidates)
        candidate = configFileCandidates{k};
        % If this candidate exists, we have a match, and simply break the
        % loop.
        if isfile(candidate)
            configFileName = candidate;
            break;
        end
    end

    if isempty(configFileName)
        docPath = fullfile(fileparts(fileparts(mlflowRoot)), 'Documentation', 'Authentication.md');
        if ~isdeployed
            warning('MLFLOW:FILENOTFOUND',...
                '.mlflow-connect or mlflow.json files not found. See <a href="matlab: edit(''%s'')">Authentication.md</a>',...
                docPath);
        else
            warning('MLFLOW:FILENOTFOUND',...
                '.mlflow-connect or mlflow.json files not found. See %s', docPath);
        end
    end
end
