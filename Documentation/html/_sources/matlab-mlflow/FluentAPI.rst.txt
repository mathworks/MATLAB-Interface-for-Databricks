MLflow MATLAB Fluent API
========================

.. note::
    This section of the documentation has been automatically generated based on the Python MLflow fluent interface (version 3.10.1) and may therefore in places use Python terminology and types rather than MATLAB terminology.
    Also, the generated documentation may not be formatted perfectly.

mlflow package
++++++++++++++++++++++++

.. contents::    :local:

.. module:: mlflow

get_run
------------------------------------------------------------

.. function:: get_run(run_id)

    Fetch the run from backend store. The resulting Run contains a collection of run metadata --
    RunInfo as well as a collection of run parameters, tags, and metrics -- RunData. It also
    contains a collection of run inputs (experimental), including information about datasets used by
    the run -- RunInputs. In the case where multiple metrics with the same key are logged for the
    run, the RunData contains the most recently logged value at the largest step for each metric.
    
    :return:
        A single Run object, if the run exists. Otherwise, raises an exception.
    
    :param run_id:
        Unique identifier for the run.
    
register_model
------------------------------------------------------------

.. function:: register_model(model_uri,name,await_registration_for)

    Create a new model version in model registry for the model files specified by ``model_uri``.
    
    Note that this method assumes the model registry backend URI is the same as that of the
    tracking backend.
    
    :return:
        Single :py:class:`mlflow.entities.model_registry.ModelVersion` object created by
        backend.
    
    :param model_uri:
        URI referring to the MLmodel directory. Supported URI schemes include:
        - ``runs:/`` URIs (e.g., ``runs:/<run_id>/<artifact_path>``) to register a model
          from a specific run. The run ID is recorded with the model version.
        - ``models:/`` URIs, which support two forms:
        
          - ``models:/<model_name>/<version>`` to promote an existing registered
            model version. The source run lineage is preserved when the
            referenced model version has an associated source run.
          - ``models:/<model_id>`` to create a new registered model version from a logged
            model (for example, one returned by ``log_model``). The source
            run lineage is preserved.
        
        - Local filesystem paths for registering locally-persisted MLflow models that were
          previously saved using ``save_model``.
    :param name:
        Name of the registered model under which to create a new model version. If a
        registered model with the given name does not exist, it will be created
        automatically.
    :param await_registration_for:
        Number of seconds to wait for the model version to finish
        being created and is in ``READY`` status. By default, the function
        waits for five minutes. Specify 0 or None to skip waiting.
    :param tags:
        A dictionary of key-value pairs that are converted into
        :py:class:`mlflow.entities.model_registry.ModelVersionTag` objects.
    :param env_pack:
        Either a string or an EnvPackConfig. If specified,
        the model dependencies are optionally first installed into the current Python
        environment, and then the complete environment will be packaged and included
        in the registered model artifacts. If the string shortcut "databricks_model_serving" is
        used, then model dependencies will be installed in the current environment. This is
        useful when deploying the model to a serving environment like Databricks Model Serving.
        
        .. Note:: Experimental: This parameter may change or be removed in a future
                                release without warning.
    
set_registry_uri
------------------------------------------------------------

.. function:: set_registry_uri(uri)

    Set the registry server URI. This method is especially useful if you have a registry server
    that's different from the tracking server.
    
    
    :param uri:
        An empty string, or a local file path, prefixed with ``file:/``. Data is stored
        locally at the provided file (or ``./mlruns`` if empty). An HTTP URI like
        ``https://my-tracking-server:5000`` or ``http://my-oss-uc-server:8080``. A Databricks
        workspace, provided as the string "databricks" or, to use a Databricks CLI
        `profile <https://github.com/databricks/databricks-cli#installation>`_,
        "databricks://<profileName>".
    
enable_system_metrics_logging
------------------------------------------------------------

.. function:: enable_system_metrics_logging()

    Enable system metrics logging globally.
    
    Calling this function will enable system metrics logging globally, but users can still opt out
    system metrics logging for individual runs by `mlflow.start_run(log_system_metrics=False)`.
    
    
    
add_trace
------------------------------------------------------------

.. function:: add_trace(trace,target)

    Add a completed trace object into another trace.
    
    This is particularly useful when you call a remote service instrumented by
    MLflow Tracing. By using this function, you can merge the trace from the remote
    service into the current active local trace, so that you can see the full
    trace including what happens inside the remote service call.
    
    The following example demonstrates how to use this function to merge a trace from a remote
    service to the current active trace in the function.
    
    .. code-block:: python
    
        @mlflow.trace(name="predict")
        def predict(input):
            # Call a remote service that returns a trace in the response
            resp = requests.get("https://your-service-endpoint", ...)
    
            # Extract the trace from the response
            trace_json = resp.json().get("trace")
    
            # Use the remote trace as a part of the current active trace.
            # It will be merged under the span "predict" and exported together when it is ended.
            mlflow.add_trace(trace_json)
    
    If you have a specific target span to merge the trace under, you can pass the target span
    
    .. code-block:: python
    
        def predict(input):
            # Create a local span
            with mlflow.start_span(name="predict") as span:
                resp = requests.get("https://your-service-endpoint", ...)
                trace_json = resp.json().get("trace")
    
                # Merge the remote trace under the span created above
                mlflow.add_trace(trace_json, target=span)
    
    
    :param trace:
        A :py:class:`Trace <mlflow.entities.Trace>` object or a dictionary representation
        of the trace. The trace **must** be already completed i.e. no further updates should
        be made to it. Otherwise, this function will raise an exception.
        
        .. attention:
        
            The spans in the trace must be ordered in a way that the parent span comes
            before its children. If the spans are not ordered correctly, this function
            will raise an exception.
    :param target:
        The target span to merge the given trace.
        - If provided, the trace will be merged under the target span.
        - If not provided, the trace will be merged under the current active span.
        - If not provided and there is no active span, a new span named "Remote Trace <...>"
          will be created and the trace will be merged under it.
    
log_expectation
------------------------------------------------------------

.. function:: log_expectation()

    Logs an expectation (e.g. ground truth label) to a Trace. This API only takes keyword arguments.
    
    :return:
        :py:class:`~mlflow.entities.Assessment`: The created expectation assessment.
    
    :param trace_id:
        The ID of the trace.
    :param name:
        The name of the expectation assessment e.g., "expected_answer
    :param value:
        The value of the expectation. It can be any JSON-serializable value.
    :param source:
        The source of the expectation assessment. Must be an instance of
        :py:class:`~mlflow.entities.AssessmentSource`. If not provided,
        default to HUMAN source type.
    :param metadata:
        Additional metadata for the expectation.
    :param span_id:
        The ID of the span associated with the expectation, if it needs be
        associated with a specific span in the trace.
    
end_run
------------------------------------------------------------

.. function:: end_run(status)

    End an active MLflow run (if there is one).
    
    .. code-block:: python
        :test:
        :caption: Example
    
        import mlflow
    
        # Start run and get status
        mlflow.start_run()
        run = mlflow.active_run()
        print(f"run_id: {run.info.run_id}; status: {run.info.status}")
    
        # End run and get status
        mlflow.end_run()
        run = mlflow.get_run(run.info.run_id)
        print(f"run_id: {run.info.run_id}; status: {run.info.status}")
        print("--")
    
        # Check for any active runs
        print(f"Active run: {mlflow.active_run()}")
    
    .. code-block:: text
        :caption: Output
    
        run_id: b47ee4563368419880b44ad8535f6371; status: RUNNING
        run_id: b47ee4563368419880b44ad8535f6371; status: FINISHED
        --
        Active run: None
    
    
    
clear_active_model
------------------------------------------------------------

.. function:: clear_active_model()

    Clear the active model. This will clear the active model previously set by
    
    
    
register_prompt
------------------------------------------------------------

.. function:: register_prompt()

    Register a new :py:class:`Prompt <mlflow.entities.Prompt>` in the MLflow Prompt Registry.
    
    A :py:class:`Prompt <mlflow.entities.Prompt>` is a pair of name and
    template content at minimum. With MLflow Prompt Registry, you can create, manage, and
    version control prompts with the MLflow's robust model tracking framework.
    
    If there is no registered prompt with the given name, a new prompt will be created.
    Otherwise, a new version of the existing prompt will be created.
    
    :return:
        A :py:class:`Prompt <mlflow.entities.Prompt>` object that was created.
    
    :param name:
        The name of the prompt.
    :param template:
        The template content of the prompt. Can be either:
        - A string containing text with variables enclosed in double curly braces,
          e.g. {{variable}}, which will be replaced with actual values by the `format` method.
        - A list of dictionaries representing chat messages, where each message has
          'role' and 'content' keys (e.g., [{"role": "user", "content": "Hello {{name}}"}])
        
        .. note::
        
            If you want to use the prompt with a framework that uses single curly braces
            e.g. LangChain, you can use the `to_single_brace_format` method to convert the
            loaded prompt to a format that uses single curly braces.
        
            .. code-block:: python
        
                prompt = client.load_prompt("my_prompt")
                langchain_format = prompt.to_single_brace_format()
    :param commit_message:
        A message describing the changes made to the prompt, similar to a
        Git commit message. Optional.
    :param tags:
        A dictionary of tags associated with the **prompt version**.
        This is useful for storing version-specific information, such as the author of
        the changes. Optional.
    :param response_format:
        Optional Pydantic class or dictionary defining the expected response
        structure. This can be used to specify the schema for structured outputs from LLM calls.
    :param model_config:
        Optional PromptModelConfig instance or dictionary containing model-specific
        configuration. Using PromptModelConfig provides validation and type safety.
    
set_system_metrics_node_id
------------------------------------------------------------

.. function:: set_system_metrics_node_id(node_id)

    Set the system metrics node id.
    
    node_id is the identifier of the machine where the metrics are collected. This is useful in
    multi-node (distributed training) setup.
    
    
    
get_trace
------------------------------------------------------------

.. function:: get_trace(trace_id,silent)

    .. Note:: Parameter ``request_id`` is deprecated. Use ``trace_id`` instead.
    
    Get a trace by the given request ID if it exists.
    
    This function retrieves the trace from the in-memory buffer first, and if it doesn't exist,
    it fetches the trace from the tracking store. If the trace is not found in the tracking store,
    it returns None.
    
    :return:
        A :py:class:`mlflow.entities.Trace` objects with the given request ID.
    
    :param trace_id:
        The ID of the trace.
    :param silent:
        If True, suppress the warning message when the trace is not found. The API will
        return None without any warning. Default to False.
    
log_feedback
------------------------------------------------------------

.. function:: log_feedback()

    Logs feedback to a Trace. This API only takes keyword arguments.
    
    :return:
        :py:class:`~mlflow.entities.Assessment`: The created feedback assessment.
    
    :param trace_id:
        The ID of the trace.
    :param name:
        The name of the feedback assessment e.g., "faithfulness". Defaults to
        "feedback" if not provided.
    :param value:
        The value of the feedback. Must be one of the following types:
        - float
        - int
        - str
        - bool
        - list of values of the same types as above
        - dict with string keys and values of the same types as above
    :param source:
        The source of the feedback assessment. Must be an instance of
        :py:class:`~mlflow.entities.AssessmentSource`. If not provided, defaults to
        CODE source type
    :param error:
        An error object representing any issues encountered while computing the
        feedback, e.g., a timeout error from an LLM judge. Accepts an exception
        object, or an :py:class:`~mlflow.entities.AssessmentError` object. Either
        this or `value` must be provided.
    :param rationale:
        The rationale / justification for the feedback.
    :param metadata:
        Additional metadata for the feedback.
    :param span_id:
        The ID of the span associated with the feedback, if it needs be
        associated with a specific span in the trace.
    
search_experiments
------------------------------------------------------------

.. function:: search_experiments(view_type,max_results,filter_string,order_by)

    Search for experiments that match the specified search query.
    
    :return:
        A list of :py:class:`Experiment <mlflow.entities.Experiment>` objects.
    
    :param view_type:
        One of enum values ``ACTIVE_ONLY``, ``DELETED_ONLY``, or ``ALL``
        defined in :py:class:`mlflow.entities.ViewType`.
    :param max_results:
        If passed, specifies the maximum number of experiments desired. If not
        passed, all experiments will be returned.
    :param filter_string:
        Filter query string (e.g., ``"name = 'my_experiment'"``), defaults to
        searching for all experiments. The following identifiers, comparators, and logical
        operators are supported.
        
        Identifiers
          - ``name``: Experiment name
          - ``creation_time``: Experiment creation time
          - ``last_update_time``: Experiment last update time
          - ``tags.<tag_key>``: Experiment tag. If ``tag_key`` contains
            spaces, it must be wrapped with backticks (e.g., ``"tags.`extra key`"``).
        
        Comparators for string attributes and tags
            - ``=``: Equal to
            - ``!=``: Not equal to
            - ``LIKE``: Case-sensitive pattern match
            - ``ILIKE``: Case-insensitive pattern match
        
        Comparators for numeric attributes
            - ``=``: Equal to
            - ``!=``: Not equal to
            - ``<``: Less than
            - ``<=``: Less than or equal to
            - ``>``: Greater than
            - ``>=``: Greater than or equal to
        
        Logical operators
          - ``AND``: Combines two sub-queries and returns True if both of them are True.
    :param order_by:
        List of columns to order by. The ``order_by`` column can contain an optional
        ``DESC`` or ``ASC`` value (e.g., ``"name DESC"``). The default ordering is ``ASC``,
        so ``"name"`` is equivalent to ``"name ASC"``. If unspecified, defaults to
        ``["last_update_time DESC"]``, which lists experiments updated most recently first.
        The following fields are supported:
        
            - ``experiment_id``: Experiment ID
            - ``name``: Experiment name
            - ``creation_time``: Experiment creation time
            - ``last_update_time``: Experiment last update time
    
log_figure
------------------------------------------------------------

.. function:: log_figure(figure,artifact_file)

    Log a figure as an artifact. The following figure objects are supported:
    
    - `matplotlib.figure.Figure`_
    - `plotly.graph_objects.Figure`_
    
    .. _matplotlib.figure.Figure:
        https://matplotlib.org/api/_as_gen/matplotlib.figure.Figure.html
    
    .. _plotly.graph_objects.Figure:
        https://plotly.com/python-api-reference/generated/plotly.graph_objects.Figure.html
    
    
    :param figure:
        Figure to log.
    :param artifact_file:
        The run-relative artifact file path in posixpath format to which
        the figure is saved (e.g. "dir/file.png").
    :param save_kwargs:
        Additional keyword arguments passed to the method that saves the figure.
    
finalize_logged_model
------------------------------------------------------------

.. function:: finalize_logged_model(model_id,status)

    Finalize a model by updating its status.
    
    :return:
        The updated model.
    
    :param model_id:
        ID of the model to finalize.
    :param status:
        Final status to set on the model.
    
set_system_metrics_samples_before_logging
------------------------------------------------------------

.. function:: set_system_metrics_samples_before_logging(samples)

    Set the number of samples before logging system metrics.
    
    Every time `samples` samples have been collected, the system metrics will be logged to mlflow.
    By default `samples=1`.
    
    
    
get_tracking_uri
------------------------------------------------------------

.. function:: get_tracking_uri()

    Get the current tracking URI. This may not correspond to the tracking URI of
    the currently active run, since the tracking URI can be updated via ``set_tracking_uri``.
    
    :return:
        The tracking URI.
    
    
search_logged_models
------------------------------------------------------------

.. function:: search_logged_models(experiment_ids,filter_string,datasets,max_results,order_by,output_format)

    Search for logged models that match the specified search criteria.
    
    :return:
        The search results in the specified output format.
    
    :param experiment_ids:
        List of experiment IDs to search for logged models. If not specified,
        the active experiment will be used.
    :param filter_string:
        A SQL-like filter string to parse. The filter string syntax supports:
        - Entity specification:
            - attributes: `attribute_name` (default if no prefix is specified)
            - metrics: `metrics.metric_name`
            - parameters: `params.param_name`
            - tags: `tags.tag_name`
        - Comparison operators:
            - For numeric entities (metrics and numeric attributes): <, <=, >, >=, =, !=
            - For string entities (params, tags, string attributes): =, !=, IN, NOT IN
        - Multiple conditions can be joined with 'AND'
        - String values must be enclosed in single quotes
        
        Example filter strings:
            - `creation_time > 100`
            - `metrics.rmse > 0.5 AND params.model_type = 'rf'`
            - `tags.release IN ('v1.0', 'v1.1')`
            - `params.optimizer != 'adam' AND metrics.accuracy >= 0.9`
    :param datasets:
        List of dictionaries to specify datasets on which to apply metrics filters
        For example, a filter string with `metrics.accuracy > 0.9` and dataset with name
        "test_dataset" means we will return all logged models with accuracy > 0.9 on the
        test_dataset. Metric values from ANY dataset matching the criteria are considered.
        If no datasets are specified, then metrics across all datasets are considered in
        the filter. The following fields are supported:
        
        dataset_name (str):
            Required. Name of the dataset.
        dataset_digest (str):
            Optional. Digest of the dataset.
    :param max_results:
        The maximum number of logged models to return.
    :param order_by:
        List of dictionaries to specify the ordering of the search results. The following
        fields are supported:
        
        field_name (str):
            Required. Name of the field to order by, e.g. "metrics.accuracy".
        ascending (bool):
            Optional. Whether the order is ascending or not.
        dataset_name (str):
            Optional. If ``field_name`` refers to a metric, this field
            specifies the name of the dataset associated with the metric. Only metrics
            associated with the specified dataset name will be considered for ordering.
            This field may only be set if ``field_name`` refers to a metric.
        dataset_digest (str):
            Optional. If ``field_name`` refers to a metric, this field
            specifies the digest of the dataset associated with the metric. Only metrics
            associated with the specified dataset name and digest will be considered for
            ordering. This field may only be set if ``dataset_name`` is also set.
    :param output_format:
        The output format of the search results. Supported values are 'pandas'
        and 'list'.
    
log_image
------------------------------------------------------------

.. function:: log_image(image,artifact_file,key,step,timestamp,synchronous)

    Logs an image in MLflow, supporting two use cases:
    
    1. Time-stepped image logging:
        Ideal for tracking changes or progressions through iterative processes (e.g.,
        during model training phases).
    
        - Usage: :code:`log_image(image, key=key, step=step, timestamp=timestamp)`
    
    2. Artifact file image logging:
        Best suited for static image logging where the image is saved directly as a file
        artifact.
    
        - Usage: :code:`log_image(image, artifact_file)`
    
    The following image formats are supported:
        - `numpy.ndarray`_
        - `PIL.Image.Image`_
    
        .. _numpy.ndarray:
            https://numpy.org/doc/stable/reference/generated/numpy.ndarray.html
    
        .. _PIL.Image.Image:
            https://pillow.readthedocs.io/en/stable/reference/Image.html#PIL.Image.Image
    
        - :class:`mlflow.Image`: An MLflow wrapper around PIL image for convenient image logging.
    
    Numpy array support
        - data types:
    
            - bool (useful for logging image masks)
            - integer [0, 255]
            - unsigned integer [0, 255]
            - float [0.0, 1.0]
    
            .. warning::
    
                - Out-of-range integer values will raise ValueError.
                - Out-of-range float values will auto-scale with min/max and warn.
    
        - shape (H: height, W: width):
    
            - H x W (Grayscale)
            - H x W x 1 (Grayscale)
            - H x W x 3 (an RGB channel order is assumed)
            - H x W x 4 (an RGBA channel order is assumed)
    
    
    :param image:
        The image object to be logged.
    :param artifact_file:
        Specifies the path, in POSIX format, where the image
        will be stored as an artifact relative to the run's root directory (for
        example, "dir/image.png"). This parameter is kept for backward compatibility
        and should not be used together with `key`, `step`, or `timestamp`.
    :param key:
        Image name for time-stepped image logging. This string may only contain
        alphanumerics, underscores (_), dashes (-), periods (.), spaces ( ), and
        slashes (/).
    :param step:
        Integer training step (iteration) at which the image was saved.
        Defaults to 0.
    :param timestamp:
        Time when this image was saved. Defaults to the current system time.
    :param synchronous:
        *Experimental* If True, blocks until the image is logged successfully.
    
flush_artifact_async_logging
------------------------------------------------------------

.. function:: flush_artifact_async_logging()

    Flush all pending artifact async logging.
    
    
    
create_experiment
------------------------------------------------------------

.. function:: create_experiment(name,artifact_location,tags)

    Create an experiment.
    
    :return:
        String ID of the created experiment.
        
        .. code-block:: python
           :test:
           :caption: Example
        
           import mlflow
           from pathlib import Path
        
           # Create an experiment name, which must be unique and case sensitive
           experiment_id = mlflow.create_experiment(
               "Social NLP Experiments",
               artifact_location=Path.cwd().joinpath("mlruns").as_uri(),
               tags={"version": "v1", "priority": "P1"},
           )
           experiment = mlflow.get_experiment(experiment_id)
           print(f"Name: {experiment.name}")
           print(f"Experiment_id: {experiment.experiment_id}")
           print(f"Artifact Location: {experiment.artifact_location}")
           print(f"Tags: {experiment.tags}")
           print(f"Lifecycle_stage: {experiment.lifecycle_stage}")
           print(f"Creation timestamp: {experiment.creation_time}")
    
    :param name:
        The experiment name, must be a non-empty unique string.
    :param artifact_location:
        The location to store run artifacts. If not provided, the server picks
        an appropriate default.
    :param tags:
        An optional dictionary of string keys and values to set as tags on the experiment.
    
get_workspace
------------------------------------------------------------

.. function:: get_workspace(name)

    .. Note:: Experimental: This function may change or be removed in a future release without warning.
    
    Return metadata for the specified workspace.
    
    
    
set_system_metrics_sampling_interval
------------------------------------------------------------

.. function:: set_system_metrics_sampling_interval(interval)

    Set the system metrics sampling interval.
    
    Every `interval` seconds, the system metrics will be collected. By default `interval=10`.
    
    
    
set_tag
------------------------------------------------------------

.. function:: set_tag(key,value,synchronous)

    Set a tag under the current run. If no run is active, this method will create a new active
    run.
    
    :return:
        When `synchronous=True`, returns None. When `synchronous=False`, returns an
        :py:class:`mlflow.utils.async_logging.run_operations.RunOperations` instance that
        represents future for logging operation.
    
    :param key:
        Tag name. This string may only contain alphanumerics, underscores (_), dashes (-),
        periods (.), spaces ( ), and slashes (/). All backend stores will support keys up to
        length 250, but some may support larger keys.
    :param value:
        Tag value, but will be string-ified if not. All backend stores will support values
        up to length 5000, but some may support larger values.
    :param synchronous:
        *Experimental* If True, blocks until the tag is logged successfully. If False,
        logs the tag asynchronously and returns a future representing the logging operation.
        If None, read from environment variable `MLFLOW_ENABLE_ASYNC_LOGGING`, which
        defaults to False if not set.
    
log_input
------------------------------------------------------------

.. function:: log_input(dataset,context,tags,model)

    Log a dataset used in the current run.
    
    
    :param dataset:
        :py:class:`mlflow.data.dataset.Dataset` object to be logged.
    :param context:
        Context in which the dataset is used. For example: "training", "testing".
        This will be set as an input tag with key `mlflow.data.context`.
    :param tags:
        Tags to be associated with the dataset. Dictionary of tag_key -> tag_value.
    :param model:
        A :py:class:`mlflow.entities.LoggedModelInput` instance to log as input to
        the run.
    
flush_async_logging
------------------------------------------------------------

.. function:: flush_async_logging()

    Flush all pending async logging.
    
    
    
create_external_model
------------------------------------------------------------

.. function:: create_external_model(name,source_run_id,tags,params,model_type,experiment_id)

    Create a new LoggedModel whose artifacts are stored outside of MLflow. This is useful for
    tracking parameters and performance data (metrics, traces etc.) for a model, application, or
    generative AI agent that is not packaged using the MLflow Model format.
    
    :return:
        A new :py:class:`mlflow.entities.LoggedModel` object with status ``READY``.
    
    :param name:
        The name of the model. If not specified, a random name will be generated.
    :param source_run_id:
        The ID of the run that the model is associated with. If unspecified and a
        run is active, the active run ID will be used.
    :param tags:
        A dictionary of string keys and values to set as tags on the model.
    :param params:
        A dictionary of string keys and values to set as parameters on the model.
    :param model_type:
        The type of the model. This is a user-defined string that can be used to
        search and compare related models. For example, setting ``model_type="agent"``
        enables you to easily search for this model and compare it to other models of
        type ``"agent"`` in the future.
    :param experiment_id:
        The experiment ID of the experiment to which the model belongs.
    
search_model_versions
------------------------------------------------------------

.. function:: search_model_versions(max_results,filter_string,order_by)

    Search for model versions that satisfy the filter criteria.
    
    .. warning:
    
        The model version search results may not have aliases populated for performance reasons.
    
    :return:
        A list of :py:class:`mlflow.entities.model_registry.ModelVersion` objects
        that satisfy the search expressions.
    
    :param max_results:
        If passed, specifies the maximum number of models desired. If not
        passed, all models will be returned.
    :param filter_string:
        Filter query string
        (e.g., ``"name = 'a_model_name' and tag.key = 'value1'"``),
        defaults to searching for all model versions. The following identifiers, comparators,
        and logical operators are supported.
        
        Identifiers
          - ``name``: model name.
          - ``source_path``: model version source path.
          - ``run_id``: The id of the mlflow run that generates the model version.
          - ``tags.<tag_key>``: model version tag. If ``tag_key`` contains spaces, it must be
            wrapped with backticks (e.g., ``"tags.`extra key`"``).
        
        Comparators
          - ``=``: Equal to.
          - ``!=``: Not equal to.
          - ``LIKE``: Case-sensitive pattern match.
          - ``ILIKE``: Case-insensitive pattern match.
          - ``IN``: In a value list. Only ``run_id`` identifier supports ``IN`` comparator.
        
        Logical operators
          - ``AND``: Combines two sub-queries and returns True if both of them are True.
    :param order_by:
        List of column names with ASC|DESC annotation, to be used for ordering
        matching search results.
    
set_tags
------------------------------------------------------------

.. function:: set_tags(tags,synchronous)

    Log a batch of tags for the current run. If no run is active, this method will create a
    new active run.
    
    :return:
        When `synchronous=True`, returns None. When `synchronous=False`, returns an
        :py:class:`mlflow.utils.async_logging.run_operations.RunOperations` instance that
        represents future for logging operation.
    
    :param tags:
        Dictionary of tag_name: String -> value: (String, but will be string-ified if
        not)
    :param synchronous:
        *Experimental* If True, blocks until tags are logged successfully. If False,
        logs tags asynchronously and returns a future representing the logging operation.
        If None, read from environment variable `MLFLOW_ENABLE_ASYNC_LOGGING`, which
        defaults to False if not set.
    
log_inputs
------------------------------------------------------------

.. function:: log_inputs(datasets,contexts,tags_list,models)

    Log a batch of datasets used in the current run.
    
    The lists of `datasets`, `contexts`, `tags_list` must have the same length.
    The entries in these lists can be ``None``, which represents empty value to the
    corresponding input.
    
    
    :param datasets:
        List of :py:class:`mlflow.data.dataset.Dataset` object to be logged.
    :param contexts:
        List of context in which the dataset is used. For example: "training", "testing".
        This will be set as an input tag with key `mlflow.data.context`.
    :param tags_list:
        List of tags to be associated with the dataset. Dictionary of
        tag_key -> tag_value.
    :param models:
        List of :py:class:`mlflow.entities.LoggedModelInput` instance to log as input
        to the run. Currently only Databricks managed MLflow supports this argument.
    
import_checkpoints
------------------------------------------------------------

.. function:: import_checkpoints(checkpoint_path,source_run_id,model_prefix,overwrite_checkpoints)

    Create external models for all top-level files and directories under the specified
    checkpoint path.
    
    This API only supports Databricks runtime currently.
    
    :return:
        List of imported models. If 'overwrite_checkpoints' is True, the list only contains
        new created models, otherwise the list contains new created models for the new model
        names and existing models for the existing model names.
    
    :param checkpoint_path:
        Path that contains the checkpoints.
        Only Databricks Unity Catalog Volume path is supported for now.
        It must follows the
        "/Volumes/<catalog_identifier>/<schema_identifier>/<volume_identifier>/<path_to_checkpoints_directory>"
        format specified https://docs.databricks.com/aws/en/sql/language-manual/sql-ref-volumes#volume-naming-and-reference.
        Note: Each path must be isolated from other models and runs.
    :param source_run_id:
        ID of the MLflow source run that these checkpoints were trained with.
        If not provided, uses the current active run if available.
    :param model_prefix:
        String prefix to prepend to the name of each external model created from
        each checkpoint. If not provided, no prefix is applied.
    :param overwrite_checkpoints:
        If True and existing models are found with the same name in the
        associated experiment, they will be deleted and recreated to point to the latest
        checkpoint. Defaults to False.
    
create_workspace
------------------------------------------------------------

.. function:: create_workspace(name,description,default_artifact_root)

    .. Note:: Experimental: This function may change or be removed in a future release without warning.
    
    Create a new workspace.
    
        Args:
            name: The workspace name (lowercase alphanumeric with optional internal hyphens).
            description: Optional description of the workspace.
            default_artifact_root: Optional artifact root URI; falls back to server default.
    
        Returns:
            The newly created workspace.
    
        Raises:
            MlflowException: If the name is invalid, already exists, or no artifact root available.
    
    
    
search_prompts
------------------------------------------------------------

.. function:: search_prompts()

    Search for prompts in the MLflow Prompt Registry.
    
    This call returns prompt metadata for prompts that have been marked
    as prompts (i.e. tagged with `mlflow.prompt.is_prompt=true`). We can
    further restrict results via a standard registry filter expression.
    
    :return:
        A list of :py:class:`Prompt <mlflow.entities.Prompt>` objects representing prompt metadata:
        
        - name: The prompt name
        - description: The prompt description
        - tags: Prompt-level tags
        - creation_timestamp: When the prompt was created
        
        To get the actual prompt template content,
        use :py:func:`mlflow.genai.load_prompt()` API with a specific version:
        
        .. code-block:: python
            import mlflow
        
            # Search for prompts
            prompts = mlflow.genai.search_prompts(filter_string="name LIKE 'greeting%'")
        
            # Get prompts by experiment
            prompts = mlflow.genai.search_prompts(filter_string='experiment_id = "1"')
        
            # Get specific version content
            for prompt in prompts:
                prompt_version = mlflow.genai.load_prompt(prompt.name, version="1")
                print(f"Template: {prompt_version.template}")
    
    :param filter_string:
        An additional registry-search expression to apply (e.g.
        `"name LIKE 'my_prompt%'"`).  For Unity Catalog registries, must include
        catalog and schema: "catalog = 'catalog_name' AND schema = 'schema_name'".
    :param max_results:
        The maximum number of prompts to return.
    
flush_trace_async_logging
------------------------------------------------------------

.. function:: flush_trace_async_logging(terminate)

    Flush all pending trace async logging.
    
    
    :param terminate:
        If True, shut down the logging threads after flushing.
    
set_telemetry_client
------------------------------------------------------------

.. function:: set_telemetry_client()

    
log_metric
------------------------------------------------------------

.. function:: log_metric(key,value,step,synchronous,timestamp,run_id,model_id,dataset)

    Log a metric under the current run. If no run is active, this method will create
    a new active run.
    
    :return:
        When `synchronous=True`, returns None.
        When `synchronous=False`, returns `RunOperations` that represents future for
        logging operation.
    
    :param key:
        Metric name. This string may only contain alphanumerics, underscores (_),
        dashes (-), periods (.), spaces ( ), and slashes (/).
        All backend stores will support keys up to length 250, but some may
        support larger keys.
    :param value:
        Metric value. Note that some special values such as +/- Infinity may be
        replaced by other values depending on the store. For example, the
        SQLAlchemy store replaces +/- Infinity with max / min float values.
        All backend stores will support values up to length 5000, but some
        may support larger values.
    :param step:
        Metric step. Defaults to zero if unspecified.
    :param synchronous:
        *Experimental* If True, blocks until the metric is logged
        successfully. If False, logs the metric asynchronously and
        returns a future representing the logging operation. If None, read from environment
        variable `MLFLOW_ENABLE_ASYNC_LOGGING`, which defaults to False if not set.
    :param timestamp:
        Time when this metric was calculated. Defaults to the current system time.
    :param run_id:
        If specified, log the metric to the specified run. If not specified, log the metric
        to the currently active run.
    :param model_id:
        The ID of the model associated with the metric. If not specified, use the current
        active model ID set by :py:func:`mlflow.set_active_model`. If no active model exists,
        the models IDs associated with the specified or active run will be used.
    :param dataset:
        The dataset associated with the metric.
    
initialize_logged_model
------------------------------------------------------------

.. function:: initialize_logged_model(name,source_run_id,tags,params,model_type,experiment_id)

    Initialize a LoggedModel. Creates a LoggedModel with status ``PENDING`` and no artifacts. You
    must add artifacts to the model and finalize it to the ``READY`` state, for example by calling
    a flavor-specific ``log_model()`` method such as :py:func:`mlflow.pyfunc.log_model()`.
    
    :return:
        A new :py:class:`mlflow.entities.LoggedModel` object with status ``PENDING``.
    
    :param name:
        The name of the model. If not specified, a random name will be generated.
    :param source_run_id:
        The ID of the run that the model is associated with. If unspecified and a
        run is active, the active run ID will be used.
    :param tags:
        A dictionary of string keys and values to set as tags on the model.
    :param params:
        A dictionary of string keys and values to set as parameters on the model.
    :param model_type:
        The type of the model.
    :param experiment_id:
        The experiment ID of the experiment to which the model belongs.
    
get_active_model_id
------------------------------------------------------------

.. function:: get_active_model_id()

    Get the active model ID. If no active model is set with ``set_active_model()``, the
    default active model is set using model ID from the environment variable
    ``MLFLOW_ACTIVE_MODEL_ID`` or the legacy environment variable ``_MLFLOW_ACTIVE_MODEL_ID``.
    If neither is set, return None. Note that this function only get the active model ID from the
    current thread.
    
    :return:
        The active model ID if set, otherwise None.
    
    
search_registered_models
------------------------------------------------------------

.. function:: search_registered_models(max_results,filter_string,order_by)

    Search for registered models that satisfy the filter criteria.
    
    :return:
        A list of :py:class:`mlflow.entities.model_registry.RegisteredModel` objects
        that satisfy the search expressions.
    
    :param max_results:
        If passed, specifies the maximum number of models desired. If not
        passed, all models will be returned.
    :param filter_string:
        Filter query string (e.g., "name = 'a_model_name' and tag.key = 'value1'"),
        defaults to searching for all registered models. The following identifiers, comparators,
        and logical operators are supported.
        
        Identifiers
          - "name": registered model name.
          - "tags.<tag_key>": registered model tag. If "tag_key" contains spaces, it must be
            wrapped with backticks (e.g., "tags.`extra key`").
        
        Comparators
          - "=": Equal to.
          - "!=": Not equal to.
          - "LIKE": Case-sensitive pattern match.
          - "ILIKE": Case-insensitive pattern match.
        
        Logical operators
          - "AND": Combines two sub-queries and returns True if both of them are True.
    :param order_by:
        List of column names with ASC|DESC annotation, to be used for ordering
        matching search results.
    
delete_assessment
------------------------------------------------------------

.. function:: delete_assessment(trace_id,assessment_id)

    Deletes an assessment associated with a trace.
    
    
    :param trace_id:
        The ID of the trace.
    :param assessment_id:
        The ID of the assessment to delete.
    
run
------------------------------------------------------------

.. function:: run(uri,entry_point,version,parameters,docker_args,experiment_name,experiment_id,backend,backend_config,storage_dir,synchronous,run_id,run_name,env_manager,build_image,docker_auth)

    Run an MLflow project. The project can be local or stored at a Git URI.
    
    MLflow provides built-in support for running projects locally or remotely on a Databricks or
    Kubernetes cluster. You can also run projects against other targets by installing an appropriate
    third-party plugin. See `Community Plugins <../plugins.html#community-plugins>`_ for more
    information.
    
    For information on using this method in chained workflows, see `Building Multistep Workflows
    <../projects.html#building-multistep-workflows>`_.
    
    :return:
        :py:class:`mlflow.projects.SubmittedRun` exposing information (e.g. run ID)
        about the launched run.
    
    :param uri:
        URI of project to run. A local filesystem path
        or a Git repository URI (e.g. https://github.com/mlflow/mlflow-example)
        pointing to a project directory containing an MLproject file.
    :param entry_point:
        Entry point to run within the project. If no entry point with the specified
        name is found, runs the project file ``entry_point`` as a script,
        using "python" to run ``.py`` files and the default shell (specified by
        environment variable ``$SHELL``) to run ``.sh`` files.
    :param version:
        For Git-based projects, either a commit hash or a branch name.
    :param parameters:
        Parameters (dictionary) for the entry point command.
    :param docker_args:
        Arguments (dictionary) for the docker command.
    :param experiment_name:
        Name of experiment under which to launch the run.
    :param experiment_id:
        ID of experiment under which to launch the run.
    :param backend:
        Execution backend for the run: MLflow provides built-in support for "local",
        "databricks", and "kubernetes" (experimental) backends. If running against
        Databricks, will run against a Databricks workspace determined as follows:
        if a Databricks tracking URI of the form ``databricks://profile`` has been set
        (e.g. by setting the MLFLOW_TRACKING_URI environment variable), will run
        against the workspace specified by <profile>. Otherwise, runs against the
        workspace specified by the default Databricks CLI profile.
    :param backend_config:
        A dictionary, or a path to a JSON file (must end in '.json'), which will
        be passed as config to the backend. The exact content which should be
        provided is different for each execution backend and is documented
        at https://www.mlflow.org/docs/latest/projects.html.
    :param storage_dir:
        Used only if ``backend`` is "local". MLflow downloads artifacts from
        distributed URIs passed to parameters of type ``path`` to subdirectories of
        ``storage_dir``.
    :param synchronous:
        Whether to block while waiting for a run to complete. Defaults to True.
        Note that if ``synchronous`` is False and ``backend`` is "local", this
        method will return, but the current process will block when exiting until
        the local run completes. If the current process is interrupted, any
        asynchronous runs launched via this method will be terminated. If
        ``synchronous`` is True and the run fails, the current process will
        error out as well.
    :param run_id:
        Note: this argument is used internally by the MLflow project APIs and should
        not be specified. If specified, the run ID will be used instead of
        creating a new run.
    :param run_name:
        The name to give the MLflow Run associated with the project execution.
        If ``None``, the MLflow Run name is left unset.
    :param env_manager:
        Specify an environment manager to create a new environment for the run and
        install project dependencies within that environment. The following values
        are supported:
        
        - local: use the local environment
        - virtualenv: use virtualenv (and pyenv for Python version management)
        - uv: use uv
        - conda: use conda
        
        If unspecified, MLflow automatically determines the environment manager to
        use by inspecting files in the project directory. For example, if
        ``python_env.yaml`` is present, virtualenv will be used.
    :param build_image:
        Whether to build a new docker image of the project or to reuse an existing
        image. Default: False (reuse an existing image)
    :param docker_auth:
        A dictionary representing information to authenticate with a Docker
        registry. See `docker.client.DockerClient.login
        <https://docker-py.readthedocs.io/en/stable/client.html#docker.client.DockerClient.login>`_
        for available options.
    
search_runs
------------------------------------------------------------

.. function:: search_runs(experiment_ids,filter_string,run_view_type,max_results,order_by,output_format,search_all_experiments,experiment_names)

    Search for Runs that fit the specified criteria.
    
    :return:
        If output_format is ``list``: a list of :py:class:`mlflow.entities.Run`. If
           output_format is ``pandas``: ``pandas.DataFrame`` of runs, where each metric,
           parameter, and tag is expanded into its own column named metrics.*, params.*, or
           tags.* respectively. For runs that don't have a particular metric, parameter, or tag,
           the value for the corresponding column is (NumPy) ``Nan``, ``None``, or ``None``
           respectively.
        
        .. code-block:: python
           :test:
           :caption: Example
        
           import mlflow
        
           # Create an experiment and log two runs under it
           experiment_name = "Social NLP Experiments"
           experiment_id = mlflow.create_experiment(experiment_name)
           with mlflow.start_run(experiment_id=experiment_id):
               mlflow.log_metric("m", 1.55)
               mlflow.set_tag("s.release", "1.1.0-RC")
           with mlflow.start_run(experiment_id=experiment_id):
               mlflow.log_metric("m", 2.50)
               mlflow.set_tag("s.release", "1.2.0-GA")
           # Search for all the runs in the experiment with the given experiment ID
           df = mlflow.search_runs([experiment_id], order_by=["metrics.m DESC"])
           print(df[["metrics.m", "tags.s.release", "run_id"]])
           print("--")
           # Search the experiment_id using a filter_string with tag
           # that has a case insensitive pattern
           filter_string = "tags.s.release ILIKE '%rc%'"
           df = mlflow.search_runs([experiment_id], filter_string=filter_string)
           print(df[["metrics.m", "tags.s.release", "run_id"]])
           print("--")
           # Search for all the runs in the experiment with the given experiment name
           df = mlflow.search_runs(experiment_names=[experiment_name], order_by=["metrics.m DESC"])
           print(df[["metrics.m", "tags.s.release", "run_id"]])
    
    :param experiment_ids:
        List of experiment IDs. Search can work with experiment IDs or
        experiment names, but not both in the same call. Values other than
        ``None`` or ``[]`` will result in error if ``experiment_names`` is
        also not ``None`` or ``[]``. ``None`` will default to the active
        experiment if ``experiment_names`` is ``None`` or ``[]``.
    :param filter_string:
        Filter query string, defaults to searching all runs.
    :param run_view_type:
        one of enum values ``ACTIVE_ONLY``, ``DELETED_ONLY``, or ``ALL`` runs
        defined in :py:class:`mlflow.entities.ViewType`.
    :param max_results:
        The maximum number of runs to put in the dataframe. Default is 100,000
        to avoid causing out-of-memory issues on the user's machine.
    :param order_by:
        List of columns to order by (e.g., "metrics.rmse"). The ``order_by`` column
        can contain an optional ``DESC`` or ``ASC`` value. The default is ``ASC``.
        The default ordering is to sort by ``start_time DESC``, then ``run_id``.
    :param output_format:
        The output format to be returned. If ``pandas``, a ``pandas.DataFrame``
        is returned and, if ``list``, a list of :py:class:`mlflow.entities.Run`
        is returned.
    :param search_all_experiments:
        Boolean specifying whether all experiments should be searched.
        Only honored if ``experiment_ids`` is ``[]`` or ``None``.
    :param experiment_names:
        List of experiment names. Search can work with experiment IDs or
        experiment names, but not both in the same call. Values other
        than ``None`` or ``[]`` will result in error if ``experiment_ids``
        is also not ``None`` or ``[]``. ``None`` will default to the active
        experiment if ``experiment_ids`` is ``None`` or ``[]``.
    
log_metrics
------------------------------------------------------------

.. function:: log_metrics(metrics,step,synchronous,run_id,timestamp,model_id,dataset)

    Log multiple metrics for the current run. If no run is active, this method will create a new
    active run.
    
    :return:
        When `synchronous=True`, returns None. When `synchronous=False`, returns an
        :py:class:`mlflow.utils.async_logging.run_operations.RunOperations` instance that
        represents future for logging operation.
    
    :param metrics:
        Dictionary of metric_name: String -> value: Float. Note that some special
        values such as +/- Infinity may be replaced by other values depending on
        the store. For example, sql based store may replace +/- Infinity with
        max / min float values.
    :param step:
        A single integer step at which to log the specified
        Metrics. If unspecified, each metric is logged at step zero.
    :param synchronous:
        *Experimental* If True, blocks until the metrics are logged
        successfully. If False, logs the metrics asynchronously and
        returns a future representing the logging operation. If None, read from environment
        variable `MLFLOW_ENABLE_ASYNC_LOGGING`, which defaults to False if not set.
    :param run_id:
        Run ID. If specified, log metrics to the specified run. If not specified, log
        metrics to the currently active run.
    :param timestamp:
        Time when these metrics were calculated. Defaults to the current system time.
    :param model_id:
        The ID of the model associated with the metric. If not specified, use the current
        active model ID set by :py:func:`mlflow.set_active_model`. If no active model
        exists, the models IDs associated with the specified or active run will be used.
    :param dataset:
        The dataset associated with the metrics.
    
delete_experiment
------------------------------------------------------------

.. function:: delete_experiment(experiment_id)

    Delete an experiment from the backend store.
    
    
    :param experiment_id:
        The string-ified experiment ID returned from ``create_experiment``.
    
is_tracking_uri_set
------------------------------------------------------------

.. function:: is_tracking_uri_set()

    Returns True if the tracking URI has been set, False otherwise.
    
    
    
set_trace_tag
------------------------------------------------------------

.. function:: set_trace_tag(trace_id,key,value)

    .. Note:: Parameter ``request_id`` is deprecated. Use ``trace_id`` instead.
    
    Set a tag on the trace with the given trace ID.
    
    The trace can be an active one or the one that has already ended and recorded in the
    backend. Below is an example of setting a tag on an active trace. You can replace the
    ``trace_id`` parameter to set a tag on an already ended trace.
    
    .. code-block:: python
        :test:
    
        import mlflow
    
        with mlflow.start_span(name="span") as span:
            mlflow.set_trace_tag(span.trace_id, "key", "value")
    
    
    :param trace_id:
        The ID of the trace to set the tag on.
    :param key:
        The string key of the tag. Must be at most 250 characters long, otherwise
        it will be truncated when stored.
    :param value:
        The string value of the tag. Must be at most 250 characters long, otherwise
        it will be truncated when stored.
    
get_active_trace_id
------------------------------------------------------------

.. function:: get_active_trace_id()

    Get the active trace ID in the current process.
    
    This function is thread-safe.
    
    :return:
        The ID of the current active trace if exists, otherwise None.
    
    
log_model_params
------------------------------------------------------------

.. function:: log_model_params(params,model_id)

    Log params to the specified logged model.
    
    :return:
        None
    
    :param params:
        Params to log on the model.
    :param model_id:
        ID of the model. If not specified, use the current active model ID.
    
last_active_run
------------------------------------------------------------

.. function:: last_active_run()

    Gets the most recent active run.
    
    :return:
        The active run (this is equivalent to ``mlflow.active_run()``) if one exists.
        Otherwise, the last run started from the current Python process that reached
        a terminal status (i.e. FINISHED, FAILED, or KILLED).
    
    
get_artifact_uri
------------------------------------------------------------

.. function:: get_artifact_uri(artifact_path)

    Get the absolute URI of the specified artifact in the currently active run.
    
    If `path` is not specified, the artifact root URI of the currently active
    run will be returned; calls to ``log_artifact`` and ``log_artifacts`` write
    artifact(s) to subdirectories of the artifact root URI.
    
    If no run is active, this method will create a new active run.
    
    :return:
        An *absolute* URI referring to the specified artifact or the currently active run's
        artifact root. For example, if an artifact path is provided and the currently active
        run uses an S3-backed store, this may be a uri of the form
        ``s3://<bucket_name>/path/to/artifact/root/path/to/artifact``. If an artifact path
        is not provided and the currently active run uses an S3-backed store, this may be a
        URI of the form ``s3://<bucket_name>/path/to/artifact/root``.
    
    :param artifact_path:
        The run-relative artifact path for which to obtain an absolute URI.
        For example, "path/to/artifact". If unspecified, the artifact root URI
        for the currently active run will be returned.
    
delete_experiment_tag
------------------------------------------------------------

.. function:: delete_experiment_tag(key)

    Delete a tag from the current experiment.
    
    
    :param key:
        Name of the tag to be deleted.
    
set_tracking_uri
------------------------------------------------------------

.. function:: set_tracking_uri(uri)

    Set the tracking server URI. This does not affect the
    currently active run (if one exists), but takes effect for successive runs.
    
    
    :param uri:
        - An empty string, or a local file path, prefixed with ``file:/``. Data is stored
          locally at the provided file (or ``./mlruns`` if empty).
        - An HTTP URI like ``https://my-tracking-server:5000``.
        - A Databricks workspace, provided as the string "databricks" or, to use a Databricks
          CLI `profile <https://github.com/databricks/databricks-cli#installation>`_,
          "databricks://<profileName>".
        - A :py:class:`pathlib.Path` instance
    
search_sessions
------------------------------------------------------------

.. function:: search_sessions(max_results,run_id,model_id,include_spans,locations)

    .. Note:: Experimental: This function may change or be removed in a future release without warning.
    
    Return complete sessions that match the given search criteria.
    
    A session is a collection of traces that share the same session ID, typically representing
    a multi-turn conversation or a series of related interactions. This API retrieves complete
    sessions by first identifying unique session IDs from traces, then fetching all traces
    belonging to each session in parallel.
    
    :return:
        A list of :py:class:`Session <mlflow.entities.Session>` objects, where each session
        contains :py:class:`Trace <mlflow.entities.Trace>` objects that share the same
        session ID. Sessions are ordered by the timestamp of their first trace (most recent first).
        Each Session object provides convenient access via ``session.id`` and supports
        iteration with ``for trace in session``.
    
    :param max_results:
        Maximum number of sessions to return. Default is 100.
    :param run_id:
        A run id to scope the search. When a trace is created under an active run,
        it will be associated with the run and you can filter on the run id to retrieve
        traces.
    :param model_id:
        If specified, search traces associated with the given model ID.
    :param include_spans:
        If ``True``, include spans in the returned traces. Otherwise, only
        the trace metadata is returned. Default is ``True``.
    :param locations:
        A list of locations to search over. To search over experiments, provide
        a list of experiment IDs. To search over UC tables on databricks, provide
        a list of locations in the format `<catalog_name>.<schema_name>`.
        If not provided, the search will be performed across the current active experiment.
    
log_outputs
------------------------------------------------------------

.. function:: log_outputs(models)

    Log outputs, such as models, to the active run. If there is no active run, a new run will be
    created.
    
    :return:
        None.
    
    :param models:
        List of :py:class:`mlflow.entities.LoggedModelOutput` instances to log
        as outputs to the run.
    
last_logged_model
------------------------------------------------------------

.. function:: last_logged_model()

    Fetches the most recent logged model in the current session.
    If no model has been logged, None is returned.
    
    :return:
        The logged model.
    
    
delete_logged_model_tag
------------------------------------------------------------

.. function:: delete_logged_model_tag(model_id,key)

    Delete a tag from the specified logged model.
    
    
    :param model_id:
        ID of the model.
    :param key:
        Tag key to delete.
    
set_workspace
------------------------------------------------------------

.. function:: set_workspace(workspace)

    .. Note:: Experimental: This function may change or be removed in a future release without warning.
    
    Set the active workspace for subsequent MLflow operations.
    
    
    
search_traces
------------------------------------------------------------

.. function:: search_traces(experiment_ids,filter_string,max_results,order_by,extract_fields,run_id,return_type,model_id,sql_warehouse_id,include_spans,locations)

    .. Note:: Parameter ``experiment_ids`` is deprecated. Use ``locations`` instead.
    
    Return traces that match the given list of search expressions within the experiments.
    
    .. note::
    
        If expected number of search results is large, consider using the
        `MlflowClient.search_traces` API directly to paginate through the results. This
        function returns all results in memory and may not be suitable for large result sets.
    
    :return:
        Traces that satisfy the search expressions. Either as a list of
        :py:class:`Trace <mlflow.entities.Trace>` objects or as a Pandas DataFrame,
        depending on the value of the `return_type` parameter.
    
    :param experiment_ids:
        List of experiment ids to scope the search.
    :param filter_string:
        A search filter string.
    :param max_results:
        Maximum number of traces desired. If None, all traces matching the search
        expressions will be returned.
    :param order_by:
        List of order_by clauses.
    :param extract_fields:
        .. deprecated:: 3.6.0
            This parameter is deprecated and will be removed in a future version.
        
        Specify fields to extract from traces using the format
        ``"span_name.[inputs|outputs].field_name"`` or ``"span_name.[inputs|outputs]"``.
        
        .. note::
        
            This parameter is only supported when the return type is set to "pandas".
        
        For instance, ``"predict.outputs.result"`` retrieves the output ``"result"`` field from
        a span named ``"predict"``, while ``"predict.outputs"`` fetches the entire outputs
        dictionary, including keys ``"result"`` and ``"explanation"``.
        
        By default, no fields are extracted into the DataFrame columns. When multiple
        fields are specified, each is extracted as its own column. If an invalid field
        string is provided, the function silently returns without adding that field's column.
        The supported fields are limited to ``"inputs"`` and ``"outputs"`` of spans. If the
        span name or field name contains a dot it must be enclosed in backticks. For example:
        
        .. code-block:: python
        
            # span name contains a dot
            extract_fields = ["`span.name`.inputs.field"]
        
            # field name contains a dot
            extract_fields = ["span.inputs.`field.name`"]
        
            # span name and field name contain a dot
            extract_fields = ["`span.name`.inputs.`field.name`"]
    :param run_id:
        A run id to scope the search. When a trace is created under an active run,
        it will be associated with the run and you can filter on the run id to retrieve the
        trace. See the example below for how to filter traces by run id.
    :param return_type:
        The type of the return value. The following return types are supported. If
        the pandas library is installed, the default return type is "pandas". Otherwise, the
        default return type is "list".
        
        - `"pandas"`: Returns a Pandas DataFrame containing information about traces
            where each row represents a single trace and each column represents a field of the
            trace e.g. trace_id, spans, etc.
        - `"list"`: Returns a list of :py:class:`Trace <mlflow.entities.Trace>` objects.
    :param model_id:
        If specified, search traces associated with the given model ID.
    :param sql_warehouse_id:
        DEPRECATED. Use the `MLFLOW_TRACING_SQL_WAREHOUSE_ID` environment
        variable instead. The ID of the SQL warehouse to use for
        searching traces in inference tables or UC tables. Only used in Databricks.
    :param include_spans:
        If ``True``, include spans in the returned traces. Otherwise, only
        the trace metadata is returned, e.g., trace ID, start time, end time, etc,
        without any spans. Default to ``True``.
    :param locations:
        A list of locations to search over. To search over experiments, provide
        a list of experiment IDs. To search over UC tables on databricks, provide
        a list of locations in the format `<catalog_name>.<schema_name>`.
        If not provided, the search will be performed across the current active experiment.
    
get_assessment
------------------------------------------------------------

.. function:: get_assessment(trace_id,assessment_id)

    Get an assessment entity from the backend store.
    
    :return:
        :py:class:`~mlflow.entities.Assessment`: The Assessment object.
    
    :param trace_id:
        The ID of the trace.
    :param assessment_id:
        The ID of the assessment to get.
    
start_run
------------------------------------------------------------

.. function:: start_run(run_id,experiment_id,run_name,nested,parent_run_id,tags,description,log_system_metrics)

    Start a new MLflow run, setting it as the active run under which metrics and parameters
    will be logged. The return value can be used as a context manager within a ``with`` block;
    otherwise, you must call ``end_run()`` to terminate the current run.
    
    If you pass a ``run_id`` or the ``MLFLOW_RUN_ID`` environment variable is set,
    ``start_run`` attempts to resume a run with the specified run ID and
    other parameters are ignored. ``run_id`` takes precedence over ``MLFLOW_RUN_ID``.
    
    If resuming an existing run, the run status is set to ``RunStatus.RUNNING``.
    
    MLflow sets a variety of default tags on the run, as defined in
    `MLflow system tags <../../tracking/tracking-api.html#system_tags>`_.
    
    :return:
        :py:class:`mlflow.ActiveRun` object that acts as a context manager wrapping the
        run's state.
    
    :param run_id:
        If specified, get the run with the specified UUID and log parameters
        and metrics under that run. The run's end time is unset and its status
        is set to running, but the run's other attributes (``source_version``,
        ``source_type``, etc.) are not changed.
    :param experiment_id:
        ID of the experiment under which to create the current run (applicable
        only when ``run_id`` is not specified). If ``experiment_id`` argument
        is unspecified, will look for valid experiment in the following order:
        activated using ``set_experiment``, ``MLFLOW_EXPERIMENT_NAME``
        environment variable, ``MLFLOW_EXPERIMENT_ID`` environment variable,
        or the default experiment as defined by the tracking server.
    :param run_name:
        Name of new run, should be a non-empty string. Used only when ``run_id`` is
        unspecified. If a new run is created and ``run_name`` is not specified,
        a random name will be generated for the run.
    :param nested:
        Controls whether run is nested in parent run. ``True`` creates a nested run.
    :param parent_run_id:
        If specified, the current run will be nested under the the run with
        the specified UUID. The parent run must be in the ACTIVE state.
    :param tags:
        An optional dictionary of string keys and values to set as tags on the run.
        If a run is being resumed, these tags are set on the resumed run. If a new run is
        being created, these tags are set on the new run.
    :param description:
        An optional string that populates the description box of the run.
        If a run is being resumed, the description is set on the resumed run.
        If a new run is being created, the description is set on the new run.
    :param log_system_metrics:
        bool, defaults to None. If True, system metrics will be logged
        to MLflow, e.g., cpu/gpu utilization. If None, we will check environment variable
        `MLFLOW_ENABLE_SYSTEM_METRICS_LOGGING` to determine whether to log system metrics.
        System metrics logging is an experimental feature in MLflow 2.8 and subject to change.
    
set_active_model
------------------------------------------------------------

.. function:: set_active_model()

    Set the active model with the specified name or model ID, and it will be used for linking
    traces that are generated during the lifecycle of the model. The return value can be used as
    a context manager within a ``with`` block; otherwise, you must call ``set_active_model()``
    to update active model.
    
    :return:
        :py:class:`mlflow.ActiveModel` object that acts as a context manager wrapping the
        LoggedModel's state.
    
    :param name:
        The name of the :py:class:`mlflow.entities.LoggedModel` to set as active.
        If a LoggedModel with the name does not exist, it will be created under the current
        experiment. If multiple LoggedModels with the name exist, the latest one will be
        set as active.
    :param model_id:
        The ID of the :py:class:`mlflow.entities.LoggedModel` to set as active.
        If no LoggedModel with the ID exists, an exception will be raised.
    
log_param
------------------------------------------------------------

.. function:: log_param(key,value,synchronous)

    Log a parameter (e.g. model hyperparameter) under the current run. If no run is active,
    this method will create a new active run.
    
    :return:
        When `synchronous=True`, returns parameter value. When `synchronous=False`, returns an
        :py:class:`mlflow.utils.async_logging.run_operations.RunOperations` instance that represents
        future for logging operation.
    
    :param key:
        Parameter name. This string may only contain alphanumerics, underscores (_), dashes
        (-), periods (.), spaces ( ), and slashes (/). All backend stores support keys up to
        length 250, but some may support larger keys.
    :param value:
        Parameter value, but will be string-ified if not. All built-in backend stores support
        values up to length 6000, but some may support larger values.
    :param synchronous:
        *Experimental* If True, blocks until the parameter is logged successfully. If
        False, logs the parameter asynchronously and returns a future representing the logging
        operation. If None, read from environment variable `MLFLOW_ENABLE_ASYNC_LOGGING`,
        which defaults to False if not set.
    
list_workspaces
------------------------------------------------------------

.. function:: list_workspaces()

    .. Note:: Experimental: This function may change or be removed in a future release without warning.
    
    Return the list of workspaces available to the current user.
    
    
    
delete_prompt_alias
------------------------------------------------------------

.. function:: delete_prompt_alias()

    Delete an alias for a :py:class:`Prompt <mlflow.entities.Prompt>` in the MLflow Prompt Registry.
    
    
    :param name:
        The name of the prompt.
    :param alias:
        The alias to delete for the prompt.
    
get_current_active_span
------------------------------------------------------------

.. function:: get_current_active_span()

    Get the current active span in the global context.
    
    .. attention::
    
        This only works when the span is created with fluent APIs like `@mlflow.trace` or
        `with mlflow.start_span`. If a span is created with the
        `mlflow.start_span_no_context` APIs, it won't be
        attached to the global context so this function will not return it.
    
    
    .. code-block:: python
        :test:
    
        import mlflow
    
    
        @mlflow.trace
        def f():
            span = mlflow.get_current_active_span()
            span.set_attribute("key", "value")
            return 0
    
    
        f()
    
    :return:
        The current active span if exists, otherwise None.
    
    
log_params
------------------------------------------------------------

.. function:: log_params(params,synchronous,run_id)

    Log a batch of params for the current run. If no run is active, this method will create a
    new active run.
    
    :return:
        When `synchronous=True`, returns None. When `synchronous=False`, returns an
        :py:class:`mlflow.utils.async_logging.run_operations.RunOperations` instance that
        represents future for logging operation.
    
    :param params:
        Dictionary of param_name: String -> value: (String, but will be string-ified if
        not)
    :param synchronous:
        *Experimental* If True, blocks until the parameters are logged
        successfully. If False, logs the parameters asynchronously and
        returns a future representing the logging operation. If None, read from environment
        variable `MLFLOW_ENABLE_ASYNC_LOGGING`, which defaults to False if not set.
    :param run_id:
        Run ID. If specified, log params to the specified run. If not specified, log
        params to the currently active run.
    
get_experiment
------------------------------------------------------------

.. function:: get_experiment(experiment_id)

    Retrieve an experiment by experiment_id from the backend store
    
    :return:
        :py:class:`mlflow.entities.Experiment`
    
    :param experiment_id:
        The string-ified experiment ID returned from ``create_experiment``.
    
delete_run
------------------------------------------------------------

.. function:: delete_run(run_id)

    Deletes a run with the given ID.
    
    
    :param run_id:
        Unique identifier for the run to delete.
    
load_prompt
------------------------------------------------------------

.. function:: load_prompt()

    Load a :py:class:`Prompt <mlflow.entities.Prompt>` from the MLflow Prompt Registry.
    
    The prompt can be specified by name and version, or by URI.
    
    
    :param name_or_uri:
        The name of the prompt, or the URI in the format "prompts:/name/version".
    :param version:
        The version of the prompt (required when using name, not allowed when using URI).
    :param allow_missing:
        If True, return None instead of raising Exception if the specified prompt
        is not found.
    :param link_to_model:
        If True, the prompt will be linked to the model with the ID specified
        by `model_id`, or the active model ID if `model_id` is None and
        there is an active model.
    :param model_id:
        The ID of the model to which to link the prompt, if `link_to_model` is True.
    :param cache_ttl_seconds:
        Time-to-live in seconds for the cached prompt. If not specified,
        uses the value from `MLFLOW_ALIAS_PROMPT_CACHE_TTL_SECONDS` environment variable for
        alias-based prompts (default 60), and the value from
        `MLFLOW_VERSION_PROMPT_CACHE_TTL_SECONDS` environment variable for version-based prompts
        (default None, no TTL). Set to 0 to bypass the cache and always fetch from the server.
    
set_experiment
------------------------------------------------------------

.. function:: set_experiment(experiment_name,experiment_id)

    Set the given experiment as the active experiment. The experiment must either be specified by
    name via `experiment_name` or by ID via `experiment_id`. The experiment name and ID cannot
    both be specified.
    
    .. note::
        If the experiment being set by name does not exist, a new experiment will be
        created with the given name. After the experiment has been created, it will be set
        as the active experiment. On certain platforms, such as Databricks, the experiment name
        must be an absolute path, e.g. ``"/Users/<username>/my-experiment"``.
    
    :return:
        An instance of :py:class:`mlflow.entities.Experiment` representing the new active
        experiment.
    
    :param experiment_name:
        Case sensitive name of the experiment to be activated.
    :param experiment_id:
        ID of the experiment to be activated. If an experiment with this ID
        does not exist, an exception is thrown.
    
start_span
------------------------------------------------------------

.. function:: start_span()

    Context manager to create a new span and start it as the current span in the context.
    
    This context manager automatically manages the span lifecycle and parent-child relationships.
    The span will be ended when the context manager exits. Any exception raised within the
    context manager will set the span status to ``ERROR``, and detailed information such as
    exception message and stacktrace will be recorded to the ``attributes`` field of the span.
    New spans can be created within the context manager, then they will be assigned as child
    spans.
    
    .. code-block:: python
        :test:
    
        import mlflow
    
        with mlflow.start_span("my_span") as span:
            x = 1
            y = 2
            span.set_inputs({"x": x, "y": y})
    
            z = x + y
    
            span.set_outputs(z)
            span.set_attribute("key", "value")
            # do something
    
    When this context manager is used in the top-level scope, i.e. not within another span context,
    the span will be treated as a root span. The root span doesn't have a parent reference and
    **the entire trace will be logged when the root span is ended**.
    
    
    .. tip::
    
        If you want more explicit control over the trace lifecycle, you can use
        the `mlflow.start_span_no_context()` API. It provides lower
        level to start spans and control the parent-child relationships explicitly.
        However, it is generally recommended to use this context manager as long as it satisfies
        your requirements, because it requires less boilerplate code and is less error-prone.
    
    .. note::
    
        The context manager doesn't propagate the span context across threads by default. see
        `Multi Threading <https://mlflow.org/docs/latest/tracing/api/manual-instrumentation#multi-threading>`_
        for how to propagate the span context across threads.
    
    :return:
        Yields an :py:class:`mlflow.entities.Span` that represents the created span.
    
    :param name:
        The name of the span.
    :param span_type:
        The type of the span. Can be either a string or
        a :py:class:`SpanType <mlflow.entities.SpanType>` enum value
    :param attributes:
        A dictionary of attributes to set on the span.
    :param trace_destination:
        The destination to log the trace to, such as MLflow Experiment. If
        not provided, the destination will be an active MLflow experiment or an destination
        set by the :py:func:`mlflow.tracing.set_destination` function. This parameter
        should only be used for root span and setting this for non-root spans will be
        ignored with a warning.
    
login
------------------------------------------------------------

.. function:: login(backend,interactive)

    Configure MLflow server authentication and connect MLflow to tracking server.
    
    This method provides a simple way to connect MLflow to its tracking server. Currently only
    Databricks tracking server is supported. Users will be prompted to enter the credentials if no
    existing Databricks profile is found, and the credentials will be saved to `~/.databrickscfg`.
    
    
    :param backend:
        string, the backend of the tracking server. Currently only "databricks" is
        supported.
    :param interactive:
        bool, controls request for user input on missing credentials. If true, user
        input will be requested if no credentials are found, otherwise an exception will be
        raised if no credentials are found.
    
set_experiment_tag
------------------------------------------------------------

.. function:: set_experiment_tag(key,value)

    Set a tag on the current experiment. Value is converted to a string.
    
    
    :param key:
        Tag name. This string may only contain alphanumerics, underscores (_), dashes (-),
        periods (.), spaces ( ), and slashes (/). All backend stores will support keys up to
        length 250, but some may support larger keys.
    :param value:
        Tag value, but will be string-ified if not. All backend stores will support values
        up to length 5000, but some may support larger values.
    
log_stream
------------------------------------------------------------

.. function:: log_stream(stream,artifact_file,run_id)

    .. Note:: Experimental: This function may change or be removed in a future release without warning.
    
    Log a binary file-like object (e.g., ``io.BytesIO``) as an artifact.
    
    
    :param stream:
        A binary file-like object supporting ``.read()`` method (e.g., ``io.BytesIO``).
    :param artifact_file:
        The run-relative artifact file path in posixpath format to which
        the stream content is saved (e.g. "dir/file.bin").
    :param run_id:
        If specified, log the artifact to the specified run. If not specified, log the
        artifact to the currently active run.
    
load_table
------------------------------------------------------------

.. function:: load_table(artifact_file,run_ids,extra_columns)

    Load a table from MLflow Tracking as a pandas.DataFrame. The table is loaded from the
    specified artifact_file in the specified run_ids. The extra_columns are columns that
    are not in the table but are augmented with run information and added to the DataFrame.
    
    :return:
        pandas.DataFrame containing the loaded table if the artifact exists
        or else throw a MlflowException.
    
    :param artifact_file:
        The run-relative artifact file path in posixpath format to which
        table to load (e.g. "dir/file.json").
    :param run_ids:
        Optional list of run_ids to load the table from. If no run_ids are specified,
        the table is loaded from all runs in the current experiment.
    :param extra_columns:
        Optional list of extra columns to add to the returned DataFrame
        For example, if extra_columns=["run_id"], then the returned DataFrame
        will have a column named run_id.
    
get_experiment_by_name
------------------------------------------------------------

.. function:: get_experiment_by_name(name)

    Retrieve an experiment by experiment name from the backend store
    
    :return:
        An instance of :py:class:`mlflow.entities.Experiment`
        if an experiment with the specified name exists, otherwise None.
    
    :param name:
        The case sensitive experiment name.
    
delete_tag
------------------------------------------------------------

.. function:: delete_tag(key)

    Delete a tag from a run. This is irreversible. If no run is active, this method
    will create a new active run.
    
    
    :param key:
        Name of the tag
    
start_span_no_context
------------------------------------------------------------

.. function:: start_span_no_context(name,span_type,parent_span,inputs,attributes,tags,metadata,experiment_id,start_time_ns)

    Start a span without attaching it to the global tracing context.
    
    This is useful when you want to create a span without automatically linking
    with a parent span and instead manually manage the parent-child relationships.
    
    The span started with this function must be ended manually using the
    `end()` method of the span object.
    
    :return:
        A :py:class:`mlflow.entities.Span` that represents the created span.
    
    :param name:
        The name of the span.
    :param span_type:
        The type of the span. Can be either a string or
        a :py:class:`SpanType <mlflow.entities.SpanType>` enum value
    :param parent_span:
        The parent span to link with. If None, the span will be treated as a root span.
    :param inputs:
        The input data for the span.
    :param attributes:
        A dictionary of attributes to set on the span.
    :param tags:
        A dictionary of tags to set on the trace.
    :param metadata:
        A dictionary of metadata to set on the trace.
    :param experiment_id:
        The experiment ID to associate with the trace. If not provided,
        the current active experiment will be used.
    :param start_time_ns:
        The start time of the span in nanoseconds. If not provided,
        the current time will be used.
    
set_experiment_tags
------------------------------------------------------------

.. function:: set_experiment_tags(tags)

    Set tags for the current active experiment.
    
    
    :param tags:
        Dictionary containing tag names and corresponding values.
    
log_table
------------------------------------------------------------

.. function:: log_table(data,artifact_file,run_id)

    Log a table to MLflow Tracking as a JSON artifact. If the artifact_file already exists
    in the run, the data would be appended to the existing artifact_file.
    
    
    :param data:
        Dictionary or pandas.DataFrame to log.
    :param artifact_file:
        The run-relative artifact file path in posixpath format to which
        the table is saved (e.g. "dir/file.json").
    :param run_id:
        If specified, log the table to the specified run. If not specified, log the
        table to the currently active run.
    
log_artifact
------------------------------------------------------------

.. function:: log_artifact(local_path,artifact_path,run_id)

    Log a local file or directory as an artifact of the currently active run. If no run is
    active, this method will create a new active run.
    
    
    :param local_path:
        Path to the file to write.
    :param artifact_path:
        If provided, the directory in ``artifact_uri`` to write to.
    :param run_id:
        If specified, log the artifact to the specified run. If not specified, log the
        artifact to the currently active run.
    
get_last_active_trace_id
------------------------------------------------------------

.. function:: get_last_active_trace_id(thread_local)

    Get the **LAST** active trace in the same process if exists.
    
    .. warning::
    
        This function is not thread-safe by default, returns the last active trace in
        the same process. If you want to get the last active trace in the current thread,
        set the `thread_local` parameter to True.
    
    :return:
        The ID of the last active trace if exists, otherwise None.
    
    :param thread_local:
        If True, returns the last active trace in the current thread. Otherwise,
        returns the last active trace in the same process. Default is False.
    
delete_trace_tag
------------------------------------------------------------

.. function:: delete_trace_tag(trace_id,key)

    .. Note:: Parameter ``request_id`` is deprecated. Use ``trace_id`` instead.
    
    Delete a tag on the trace with the given trace ID.
    
    The trace can be an active one or the one that has already ended and recorded in the
    backend. Below is an example of deleting a tag on an active trace. You can replace the
    ``trace_id`` parameter to delete a tag on an already ended trace.
    
    .. code-block:: python
        :test:
    
        import mlflow
    
        with mlflow.start_span("my_span") as span:
            mlflow.set_trace_tag(span.trace_id, "key", "value")
            mlflow.delete_trace_tag(span.trace_id, "key")
    
    
    :param trace_id:
        The ID of the trace to delete the tag from.
    :param key:
        The string key of the tag. Must be at most 250 characters long, otherwise
        it will be truncated when stored.
    
update_assessment
------------------------------------------------------------

.. function:: update_assessment(trace_id,assessment_id,assessment)

    Updates an existing expectation (ground truth) in a Trace.
    
    :return:
        :py:class:`~mlflow.entities.Assessment`: The updated feedback or expectation assessment.
    
    :param trace_id:
        The ID of the trace.
    :param assessment_id:
        The ID of the expectation or feedback assessment to update.
    :param assessment:
        The updated assessment.
    
set_logged_model_tags
------------------------------------------------------------

.. function:: set_logged_model_tags(model_id,tags)

    Set tags on the specified logged model.
    
    :return:
        None
    
    :param model_id:
        ID of the model.
    :param tags:
        Tags to set on the model.
    
log_text
------------------------------------------------------------

.. function:: log_text(text,artifact_file,run_id)

    Log text as an artifact.
    
    
    :param text:
        String containing text to log.
    :param artifact_file:
        The run-relative artifact file path in posixpath format to which
        the text is saved (e.g. "dir/file.txt").
    :param run_id:
        If specified, log the artifact to the specified run. If not specified, log the
        artifact to the currently active run.
    
log_artifacts
------------------------------------------------------------

.. function:: log_artifacts(local_dir,artifact_path,run_id)

    Log all the contents of a local directory as artifacts of the run. If no run is active,
    this method will create a new active run.
    
    
    :param local_dir:
        Path to the directory of files to write.
    :param artifact_path:
        If provided, the directory in ``artifact_uri`` to write to.
    :param run_id:
        If specified, log the artifacts to the specified run. If not specified, log the
        artifacts to the currently active run.
    
get_logged_model
------------------------------------------------------------

.. function:: get_logged_model(model_id)

    Get a logged model by ID.
    
    :return:
        The logged model.
    
    :param model_id:
        The ID of the logged model.
    
delete_workspace
------------------------------------------------------------

.. function:: delete_workspace(name)

    .. Note:: Experimental: This function may change or be removed in a future release without warning.
    
    Delete an existing workspace.
    
        Args:
            name: Name of the workspace to delete.
            mode: Deletion mode. One of SET_DEFAULT, CASCADE, or RESTRICT.
    
    
    
update_current_trace
------------------------------------------------------------

.. function:: update_current_trace(tags,metadata,client_request_id,request_preview,response_preview,state,model_id)

    Update the current active trace with the given options.
    
    
    :param tags:
        A dictionary of tags to update the trace with Tags are designed for mutable values,
        that can be updated after the trace is created via MLflow UI or API.
    :param metadata:
        A dictionary of metadata to update the trace with. Metadata cannot be updated
        once the trace is logged. It is suitable for recording immutable values like the
        git hash of the application version that produced the trace.
    :param client_request_id:
        Client supplied request ID to associate with the trace. This is
        useful for linking the trace back to a specific request in your application or
        external system. If None, the client request ID is not updated.
    :param request_preview:
        A preview of the request to be shown in the Trace list view in the UI.
        By default, MLflow will truncate the trace request naively by limiting the length.
        This parameter allows you to specify a custom preview string.
    :param response_preview:
        A preview of the response to be shown in the Trace list view in the UI.
        By default, MLflow will truncate the trace response naively by limiting the length.
        This parameter allows you to specify a custom preview string.
    :param state:
        The state to set on the trace. Can be a TraceState enum value or string.
        Only "OK" and "ERROR" are allowed. This overrides the overall trace state without
        affecting the status of the current span.
    :param model_id:
        The ID of the model to associate with the trace. If not set, the active
        model ID is associated with the trace.
    
get_parent_run
------------------------------------------------------------

.. function:: get_parent_run(run_id)

    Gets the parent run for the given run id if one exists.
    
    :return:
        A single :py:class:`mlflow.entities.Run` object, if the parent run exists. Otherwise,
        returns None.
    
    :param run_id:
        Unique identifier for the child run.
    
update_workspace
------------------------------------------------------------

.. function:: update_workspace(name,description,default_artifact_root)

    .. Note:: Experimental: This function may change or be removed in a future release without warning.
    
    Update metadata for an existing workspace.
    
        Args:
            name: The name of the workspace to update.
            description: New description, or ``None`` to leave unchanged.
            default_artifact_root: New artifact root URI, empty string to clear, or ``None``.
    
        Returns:
            The updated workspace.
    
        Raises:
            MlflowException: If the workspace does not exist or no artifact root available.
    
    
    
set_model_version_tag
------------------------------------------------------------

.. function:: set_model_version_tag(name,version,key,value)

    Set a tag for the model version.
    
    
    :param name:
        Registered model name.
    :param version:
        Registered model version.
    :param key:
        Tag key to log. key is required.
    :param value:
        Tag value to log. value is required.
    
disable_system_metrics_logging
------------------------------------------------------------

.. function:: disable_system_metrics_logging()

    Disable system metrics logging globally.
    
    Calling this function will disable system metrics logging globally, but users can still opt in
    system metrics logging for individual runs by `mlflow.start_run(log_system_metrics=True)`.
    
    
    
log_trace
------------------------------------------------------------

.. function:: log_trace()

    .. Warning:: ``mlflow.tracing.fluent.log_trace`` is deprecated since 3.6.0. This method will be removed in a future release.
    
    Create a trace with a single root span.
    This API is useful when you want to log an arbitrary (request, response) pair
    without structured OpenTelemetry spans. The trace is linked to the active experiment.
    
    :return:
        The ID of the logged trace.
    
    :param name:
        The name of the trace (and the root span). Default to "Task".
    :param request:
        Input data for the entire trace. This is also set on the root span of the trace.
    :param response:
        Output data for the entire trace. This is also set on the root span of the trace.
    :param intermediate_outputs:
        A dictionary of intermediate outputs produced by the model or agent
        while handling the request. Keys are the names of the outputs,
        and values are the outputs themselves. Values must be JSON-serializable.
    :param attributes:
        A dictionary of attributes to set on the root span of the trace.
    :param tags:
        A dictionary of tags to set on the trace.
    :param start_time_ms:
        The start time of the trace in milliseconds since the UNIX epoch.
        When not specified, current time is used for start and end time of the trace.
    :param execution_time_ms:
        The execution time of the trace in milliseconds since the UNIX epoch.
    
log_assessment
------------------------------------------------------------

.. function:: log_assessment(trace_id,assessment)

    Logs an assessment to a Trace. The assessment can be an expectation or a feedback.
    
    - Expectation: A label that represents the expected value for a particular operation.
        For example, an expected answer for a user question from a chatbot.
    - Feedback: A label that represents the feedback on the quality of the operation.
        Feedback can come from different sources, such as human judges, heuristic scorers,
        or LLM-as-a-Judge.
    
    The following code annotates a trace with a feedback provided by LLM-as-a-Judge.
    
    .. code-block:: python
    
        import mlflow
        from mlflow.entities import Feedback
    
        feedback = Feedback(
            name="faithfulness",
            value=0.9,
            rationale="The model is faithful to the input.",
            metadata={"model": "gpt-4o-mini"},
        )
    
        mlflow.log_assessment(trace_id="1234", assessment=feedback)
    
    The following code annotates a trace with human-provided ground truth with source information.
    When the source is not provided, the default source is set to "default" with type "HUMAN"
    
    .. code-block:: python
    
        import mlflow
        from mlflow.entities import AssessmentSource, AssessmentSourceType, Expectation
    
        # Specify the annotator information as a source.
        source = AssessmentSource(
            source_type=AssessmentSourceType.HUMAN,
            source_id="john@example.com",
        )
    
        expectation = Expectation(
            name="expected_answer",
            value=42,
            source=source,
        )
    
        mlflow.log_assessment(trace_id="1234", assessment=expectation)
    
    The expectation value can be any JSON-serializable value. For example, you may
     record the full LLM message as the expectation value.
    
    .. code-block:: python
    
        import mlflow
        from mlflow.entities.assessment import Expectation
    
        expectation = Expectation(
            name="expected_message",
            # Full LLM message including expected tool calls
            value={
                "role": "assistant",
                "content": "The answer is 42.",
                "tool_calls": [
                    {
                        "id": "1234",
                        "type": "function",
                        "function": {"name": "add", "arguments": "40 + 2"},
                    }
                ],
            },
        )
        mlflow.log_assessment(trace_id="1234", assessment=expectation)
    
    You can also log an error information during the feedback generation process. To do so,
    provide an instance of :py:class:`~mlflow.entities.AssessmentError` to the `error`
    parameter, and leave the `value` parameter as `None`.
    
    .. code-block:: python
    
        import mlflow
        from mlflow.entities import AssessmentError, Feedback
    
        error = AssessmentError(
            error_code="RATE_LIMIT_EXCEEDED",
            error_message="Rate limit for the judge exceeded.",
        )
    
        feedback = Feedback(
            trace_id="1234",
            name="faithfulness",
            error=error,
        )
        mlflow.log_assessment(trace_id="1234", assessment=feedback)
    
    
    
doctor
------------------------------------------------------------

.. function:: doctor(mask_envs)

    Prints out useful information for debugging issues with MLflow.
    
    
    :param mask_envs:
        If True, mask the MLflow environment variable values
        (e.g. `"MLFLOW_ENV_VAR": "***"`) in the output to prevent leaking sensitive
        information.
    
log_dict
------------------------------------------------------------

.. function:: log_dict(dictionary,artifact_file,run_id)

    Log a JSON/YAML-serializable object (e.g. `dict`) as an artifact. The serialization
    format (JSON or YAML) is automatically inferred from the extension of `artifact_file`.
    If the file extension doesn't exist or match any of [".json", ".yml", ".yaml"],
    JSON format is used.
    
    
    :param dictionary:
        Dictionary to log.
    :param artifact_file:
        The run-relative artifact file path in posixpath format to which
        the dictionary is saved (e.g. "dir/data.json").
    :param run_id:
        If specified, log the dictionary to the specified run. If not specified, log the
        dictionary to the currently active run.
    
set_prompt_alias
------------------------------------------------------------

.. function:: set_prompt_alias()

    Set an alias for a :py:class:`Prompt <mlflow.entities.Prompt>` in the MLflow Prompt Registry.
    
    
    :param name:
        The name of the prompt.
    :param alias:
        The alias to set for the prompt.
    :param version:
        The version of the prompt.
    
validate_evaluation_results
------------------------------------------------------------

.. function:: validate_evaluation_results(validation_thresholds,candidate_result,baseline_result)

    Validate the evaluation result from one model (candidate) against another
    model (baseline). If the candidate results do not meet the validation
    thresholds, an ModelValidationFailedException will be raised.
    
    .. note::
    
        This API is a replacement for the deprecated model validation
        functionality in the :py:func:`mlflow.evaluate` API.
    
    
    :param validation_thresholds:
        A dictionary of metric name to
        :py:class:`mlflow.models.MetricThreshold` used for model validation.
        Each metric name must either be the name of a builtin metric or the
        name of a metric defined in the ``extra_metrics`` parameter.
    :param candidate_result:
        The evaluation result of the candidate model.
        Returned by the :py:func:`mlflow.evaluate` API.
    :param baseline_result:
        The evaluation result of the baseline model.
        Returned by the :py:func:`mlflow.evaluate` API.
        If set to None, the candidate model result will be
        compared against the threshold values directly.
    
get_registry_uri
------------------------------------------------------------

.. function:: get_registry_uri()

    Get the current registry URI. If none has been specified, defaults to the tracking URI.
    
    :return:
        The registry URI.
    
    
active_run
------------------------------------------------------------

.. function:: active_run()

    Get the currently active ``Run``, or None if no such run exists.
    
    .. attention::
        This API is **thread-local** and returns only the active run in the current thread.
        If your application is multi-threaded and a run is started in a different thread,
        this API will not retrieve that run.
    
    **Note**: You cannot access currently-active run attributes
    (parameters, metrics, etc.) through the run returned by ``mlflow.active_run``. In order
    to access such attributes, use the :py:class:`mlflow.client.MlflowClient` as follows:
    
    .. code-block:: python
        :test:
        :caption: Example
    
        import mlflow
    
        mlflow.start_run()
        run = mlflow.active_run()
        print(f"Active run_id: {run.info.run_id}")
        mlflow.end_run()
    
    .. code-block:: text
        :caption: Output
    
        Active run_id: 6f252757005748708cd3aad75d1ff462
    
    
    
override_feedback
------------------------------------------------------------

.. function:: override_feedback()

    Overrides an existing feedback assessment with a new assessment. This API
    logs a new assessment with the `overrides` field set to the provided assessment ID.
    The original assessment will be marked as invalid, but will otherwise be unchanged.
    This is useful when you want to correct an assessment generated by an LLM judge,
    but want to preserve the original assessment for future judge fine-tuning.
    
    If you want to mutate an assessment in-place, use :py:func:`update_assessment` instead.
    
    :return:
        :py:class:`~mlflow.entities.Assessment`: The created assessment.
    
    :param trace_id:
        The ID of the trace.
    :param assessment_id:
        The ID of the assessment to override.
    :param value:
        The new value of the assessment.
    :param rationale:
        The rationale of the new assessment.
    :param source:
        The source of the new assessment.
    :param metadata:
        Additional metadata for the new assessment.
    
