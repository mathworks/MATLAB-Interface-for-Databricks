function varargout = search_runs(varargin)
    %SEARCH_RUNS Search for Runs that fit the specified criteria.
    %
    %   out = mlflow.search_runs(experiment_ids,filter_string,run_view_type,max_results,order_by,output_format,search_all_experiments,experiment_names)
    %
    % Returns: 
    %
    %    If output_format is ``list``: a list of :py:class:`mlflow.entities.Run`. If
    %       output_format is ``pandas``: ``pandas.DataFrame`` of runs, where each metric,
    %       parameter, and tag is expanded into its own column named metrics.*, params.*, or
    %       tags.* respectively. For runs that don't have a particular metric, parameter, or tag,
    %       the value for the corresponding column is (NumPy) ``Nan``, ``None``, or ``None``
    %       respectively.
    %    .. code-block:: python
    %       :test:
    %       :caption: Example
    %       import mlflow
    %       # Create an experiment and log two runs under it
    %       experiment_name = "Social NLP Experiments"
    %       experiment_id = mlflow.create_experiment(experiment_name)
    %       with mlflow.start_run(experiment_id=experiment_id):
    %           mlflow.log_metric("m", 1.55)
    %           mlflow.set_tag("s.release", "1.1.0-RC")
    %       with mlflow.start_run(experiment_id=experiment_id):
    %           mlflow.log_metric("m", 2.50)
    %           mlflow.set_tag("s.release", "1.2.0-GA")
    %       # Search for all the runs in the experiment with the given experiment ID
    %       df = mlflow.search_runs([experiment_id], order_by=["metrics.m DESC"])
    %       print(df[["metrics.m", "tags.s.release", "run_id"]])
    %       print("--")
    %       # Search the experiment_id using a filter_string with tag
    %       # that has a case insensitive pattern
    %       filter_string = "tags.s.release ILIKE '%rc%'"
    %       df = mlflow.search_runs([experiment_id], filter_string=filter_string)
    %       print(df[["metrics.m", "tags.s.release", "run_id"]])
    %       print("--")
    %       # Search for all the runs in the experiment with the given experiment name
    %       df = mlflow.search_runs(experiment_names=[experiment_name], order_by=["metrics.m DESC"])
    %       print(df[["metrics.m", "tags.s.release", "run_id"]])
    %
    % Input arguments:
    %
    %    experiment_ids
    %        List of experiment IDs. Search can work with experiment IDs or
    %        experiment names, but not both in the same call. Values other than
    %        ``None`` or ``[]`` will result in error if ``experiment_names`` is
    %        also not ``None`` or ``[]``. ``None`` will default to the active
    %        experiment if ``experiment_names`` is ``None`` or ``[]``.
    %
    %    filter_string
    %        Filter query string, defaults to searching all runs.
    %
    %    run_view_type
    %        one of enum values ``ACTIVE_ONLY``, ``DELETED_ONLY``, or ``ALL`` runs
    %        defined in :py:class:`mlflow.entities.ViewType`.
    %
    %    max_results
    %        The maximum number of runs to put in the dataframe. Default is 100,000
    %        to avoid causing out-of-memory issues on the user's machine.
    %
    %    order_by
    %        List of columns to order by (e.g., "metrics.rmse"). The ``order_by`` column
    %        can contain an optional ``DESC`` or ``ASC`` value. The default is ``ASC``.
    %        The default ordering is to sort by ``start_time DESC``, then ``run_id``.
    %
    %    output_format
    %        The output format to be returned. If ``pandas``, a ``pandas.DataFrame``
    %        is returned and, if ``list``, a list of :py:class:`mlflow.entities.Run`
    %        is returned.
    %
    %    search_all_experiments
    %        Boolean specifying whether all experiments should be searched.
    %        Only honored if ``experiment_ids`` is ``[]`` or ``None``.
    %
    %    experiment_names
    %        List of experiment names. Search can work with experiment IDs or
    %        experiment names, but not both in the same call. Values other
    %        than ``None`` or ``[]`` will result in error if ``experiment_ids``
    %        is also not ``None`` or ``[]``. ``None`` will default to the active
    %        experiment if ``experiment_ids`` is ``None`` or ``[]``.
    %
    
    % This file has automatically been generated based on
    % MLflow Python SDK version 3.10.1.
    
    % Copyright 2023-2026 MathWorks, Inc.
    
    mlflow.matlab.assertPythonMLflowAvailable()
    args = ["experiment_ids","filter_string","run_view_type","max_results","order_by","output_format","search_all_experiments","experiment_names"];
    i = mlflow.matlab.internal.pythonPositionalSplit(varargin,args);
    [varargout{1:nargout}] = py.mlflow.search_runs(varargin{1:i},pyargs(varargin{i+1:end}));
