classdef GitRepository < JSONMapper
    % GitRepository Git repository configuration, populated from the app's git_repository configuration
    %
    % App API 2.0

    % Copyright 2026 The MathWorks, Inc.

    properties
        % Git provider. Case insensitive. Supported values: gitHub, gitHubEnterprise,
        % bitbucketCloud, bitbucketServer, azureDevOpsServices, gitLab, gitLabEnterpriseEdition, awsCodeCommit.
        provider string { JSONMapper.fieldName(provider, "provider")}
        % URL of the Git repository.
        % Example "https://github.com/databricks/git_app_repo.git"
        url string { JSONMapper.fieldName(url, "url")}
    end

    methods
        function obj = GitRepository(s, inputs)
            arguments
                s {JSONMapper.ConstructorArgument} = []
                inputs.?databricks.datastructures.apps.GitRepository
            end
            obj@JSONMapper(s, inputs);
        end
    end
end