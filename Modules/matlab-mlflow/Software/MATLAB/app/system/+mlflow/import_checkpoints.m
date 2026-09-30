function varargout = import_checkpoints(varargin)
    %IMPORT_CHECKPOINTS Create external models for all top-level files and directories under the specified
    % checkpoint path.
    % This API only supports Databricks runtime currently.
    %
    %   out = mlflow.import_checkpoints(checkpoint_path,source_run_id,model_prefix,overwrite_checkpoints)
    %
    % Returns: 
    %
    %    List of imported models. If 'overwrite_checkpoints' is True, the list only contains
    %    new created models, otherwise the list contains new created models for the new model
    %    names and existing models for the existing model names.
    %
    % Input arguments:
    %
    %    checkpoint_path
    %        Path that contains the checkpoints.
    %        Only Databricks Unity Catalog Volume path is supported for now.
    %        It must follows the
    %        "/Volumes/<catalog_identifier>/<schema_identifier>/<volume_identifier>/<path_to_checkpoints_directory>"
    %        format specified https://docs.databricks.com/aws/en/sql/language-manual/sql-ref-volumes#volume-naming-and-reference.
    %        Note: Each path must be isolated from other models and runs.
    %
    %    source_run_id
    %        ID of the MLflow source run that these checkpoints were trained with.
    %        If not provided, uses the current active run if available.
    %
    %    model_prefix
    %        String prefix to prepend to the name of each external model created from
    %        each checkpoint. If not provided, no prefix is applied.
    %
    %    overwrite_checkpoints
    %        If True and existing models are found with the same name in the
    %        associated experiment, they will be deleted and recreated to point to the latest
    %        checkpoint. Defaults to False.
    %
    
    % This file has automatically been generated based on
    % MLflow Python SDK version 3.10.1.
    
    % Copyright 2023-2026 MathWorks, Inc.
    
    mlflow.matlab.assertPythonMLflowAvailable()
    args = ["checkpoint_path","source_run_id","model_prefix","overwrite_checkpoints"];
    i = mlflow.matlab.internal.pythonPositionalSplit(varargin,args);
    [varargout{1:nargout}] = py.mlflow.import_checkpoints(varargin{1:i},pyargs(varargin{i+1:end}));
