function varargout = search_experiments(varargin)
    %SEARCH_EXPERIMENTS Search for experiments that match the specified search query.
    %
    %   out = mlflow.search_experiments(view_type,max_results,filter_string,order_by)
    %
    % Returns: 
    %
    %    A list of :py:class:`Experiment <mlflow.entities.Experiment>` objects.
    %
    % Input arguments:
    %
    %    view_type
    %        One of enum values ``ACTIVE_ONLY``, ``DELETED_ONLY``, or ``ALL``
    %        defined in :py:class:`mlflow.entities.ViewType`.
    %
    %    max_results
    %        If passed, specifies the maximum number of experiments desired. If not
    %        passed, all experiments will be returned.
    %
    %    filter_string
    %        Filter query string (e.g., ``"name = 'my_experiment'"``), defaults to
    %        searching for all experiments. The following identifiers, comparators, and logical
    %        operators are supported.
    %        Identifiers
    %          - ``name``: Experiment name
    %          - ``creation_time``: Experiment creation time
    %          - ``last_update_time``: Experiment last update time
    %          - ``tags.<tag_key>``: Experiment tag. If ``tag_key`` contains
    %            spaces, it must be wrapped with backticks (e.g., ``"tags.`extra key`"``).
    %        Comparators for string attributes and tags
    %            - ``=``: Equal to
    %            - ``!=``: Not equal to
    %            - ``LIKE``: Case-sensitive pattern match
    %            - ``ILIKE``: Case-insensitive pattern match
    %        Comparators for numeric attributes
    %            - ``=``: Equal to
    %            - ``!=``: Not equal to
    %            - ``<``: Less than
    %            - ``<=``: Less than or equal to
    %            - ``>``: Greater than
    %            - ``>=``: Greater than or equal to
    %        Logical operators
    %          - ``AND``: Combines two sub-queries and returns True if both of them are True.
    %
    %    order_by
    %        List of columns to order by. The ``order_by`` column can contain an optional
    %        ``DESC`` or ``ASC`` value (e.g., ``"name DESC"``). The default ordering is ``ASC``,
    %        so ``"name"`` is equivalent to ``"name ASC"``. If unspecified, defaults to
    %        ``["last_update_time DESC"]``, which lists experiments updated most recently first.
    %        The following fields are supported:
    %            - ``experiment_id``: Experiment ID
    %            - ``name``: Experiment name
    %            - ``creation_time``: Experiment creation time
    %            - ``last_update_time``: Experiment last update time
    %
    
    % This file has automatically been generated based on
    % MLflow Python SDK version 3.10.1.
    
    % Copyright 2023-2026 MathWorks, Inc.
    
    mlflow.matlab.assertPythonMLflowAvailable()
    args = ["view_type","max_results","filter_string","order_by"];
    i = mlflow.matlab.internal.pythonPositionalSplit(varargin,args);
    [varargout{1:nargout}] = py.mlflow.search_experiments(varargin{1:i},pyargs(varargin{i+1:end}));
