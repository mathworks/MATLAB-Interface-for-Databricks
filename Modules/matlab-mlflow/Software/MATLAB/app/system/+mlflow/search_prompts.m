function varargout = search_prompts(varargin)
    %SEARCH_PROMPTS Search for prompts in the MLflow Prompt Registry.
    % This call returns prompt metadata for prompts that have been marked
    % as prompts (i.e. tagged with `mlflow.prompt.is_prompt=true`). We can
    % further restrict results via a standard registry filter expression.
    %
    %   out = mlflow.search_prompts()
    %
    % Returns: 
    %
    %    A list of :py:class:`Prompt <mlflow.entities.Prompt>` objects representing prompt metadata:
    %    - name: The prompt name
    %    - description: The prompt description
    %    - tags: Prompt-level tags
    %    - creation_timestamp: When the prompt was created
    %    To get the actual prompt template content,
    %    use :py:func:`mlflow.genai.load_prompt()` API with a specific version:
    %    .. code-block:: python
    %        import mlflow
    %        # Search for prompts
    %        prompts = mlflow.genai.search_prompts(filter_string="name LIKE 'greeting%'")
    %        # Get prompts by experiment
    %        prompts = mlflow.genai.search_prompts(filter_string='experiment_id = "1"')
    %        # Get specific version content
    %        for prompt in prompts:
    %            prompt_version = mlflow.genai.load_prompt(prompt.name, version="1")
    %            print(f"Template: {prompt_version.template}")
    %
    % Input arguments:
    %
    %    filter_string
    %        An additional registry-search expression to apply (e.g.
    %        `"name LIKE 'my_prompt%'"`).  For Unity Catalog registries, must include
    %        catalog and schema: "catalog = 'catalog_name' AND schema = 'schema_name'".
    %
    %    max_results
    %        The maximum number of prompts to return.
    %
    
    % This file has automatically been generated based on
    % MLflow Python SDK version 3.10.1.
    
    % Copyright 2023-2026 MathWorks, Inc.
    
    mlflow.matlab.assertPythonMLflowAvailable()
    args = [];
    i = mlflow.matlab.internal.pythonPositionalSplit(varargin,args);
    [varargout{1:nargout}] = py.mlflow.search_prompts(varargin{1:i},pyargs(varargin{i+1:end}));
