classdef GitSource < JSONMapper
    % GitSource Git repository to use as the source for the app deployment
    %
    % App API 2.0

    % Copyright 2026 The MathWorks, Inc.

    properties
        % Git branch to checkout.
        main string { JSONMapper.fieldName(main, "main")}
        % Git commit SHA to checkout.
        commit string { JSONMapper.fieldName(commit, "commit")}
        % Git repository configuration. Populated from the app's git_repository configuration.
        gitRepository databricks.datastructures.apps.GitRepository { JSONMapper.fieldName(gitRepository, "git_repository")}
        % The resolved commit SHA that was actually used for the deployment.
        % This is populated by the system after resolving the reference (branch, tag, or commit).
        % If commit is specified directly, this will match commit.
        % If a branch or tag is specified, this contains the commit
        % SHA that the branch or tag pointed to at deployment time.
        resolvedCommit string { JSONMapper.fieldName(resolvedCommit, "resolved_commit")}
        % Relative path to the app source code within the Git repository. If not specified, the root of the repository is used.
        sourceCodePath string { JSONMapper.fieldName(sourceCodePath, "source_code_path")}
        % Git tag to checkout.
        tag string { JSONMapper.fieldName(tag, "tag")}
    end

    methods
        function obj = GitSource(s, inputs)
            arguments
                s {JSONMapper.ConstructorArgument} = []
                inputs.?databricks.datastructures.apps.GitSource
            end
            obj@JSONMapper(s, inputs);
        end
    end
end