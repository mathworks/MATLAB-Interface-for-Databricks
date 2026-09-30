function varargout = register_prompt(varargin)
    %REGISTER_PROMPT Register a new :py:class:`Prompt <mlflow.entities.Prompt>` in the MLflow Prompt Registry.
    % A :py:class:`Prompt <mlflow.entities.Prompt>` is a pair of name and
    % template content at minimum. With MLflow Prompt Registry, you can create, manage, and
    % version control prompts with the MLflow's robust model tracking framework.
    % If there is no registered prompt with the given name, a new prompt will be created.
    % Otherwise, a new version of the existing prompt will be created.
    %
    %   out = mlflow.register_prompt()
    %
    % Returns: 
    %
    %    A :py:class:`Prompt <mlflow.entities.Prompt>` object that was created.
    %
    % Input arguments:
    %
    %    name
    %        The name of the prompt.
    %
    %    template
    %        The template content of the prompt. Can be either:
    %        - A string containing text with variables enclosed in double curly braces,
    %          e.g. {{variable}}, which will be replaced with actual values by the `format` method.
    %        - A list of dictionaries representing chat messages, where each message has
    %          'role' and 'content' keys (e.g., [{"role": "user", "content": "Hello {{name}}"}])
    %        .. note::
    %            If you want to use the prompt with a framework that uses single curly braces
    %            e.g. LangChain, you can use the `to_single_brace_format` method to convert the
    %            loaded prompt to a format that uses single curly braces.
    %            .. code-block:: python
    %                prompt = client.load_prompt("my_prompt")
    %                langchain_format = prompt.to_single_brace_format()
    %
    %    commit_message
    %        A message describing the changes made to the prompt, similar to a
    %        Git commit message. Optional.
    %
    %    tags
    %        A dictionary of tags associated with the **prompt version**.
    %        This is useful for storing version-specific information, such as the author of
    %        the changes. Optional.
    %
    %    response_format
    %        Optional Pydantic class or dictionary defining the expected response
    %        structure. This can be used to specify the schema for structured outputs from LLM calls.
    %
    %    model_config
    %        Optional PromptModelConfig instance or dictionary containing model-specific
    %        configuration. Using PromptModelConfig provides validation and type safety.
    %
    
    % This file has automatically been generated based on
    % MLflow Python SDK version 3.10.1.
    
    % Copyright 2023-2026 MathWorks, Inc.
    
    mlflow.matlab.assertPythonMLflowAvailable()
    args = [];
    i = mlflow.matlab.internal.pythonPositionalSplit(varargin,args);
    [varargout{1:nargout}] = py.mlflow.register_prompt(varargin{1:i},pyargs(varargin{i+1:end}));
