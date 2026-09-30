function varargout = load_table(varargin)
    %LOAD_TABLE Load a table from MLflow Tracking as a pandas.DataFrame. The table is loaded from the
    % specified artifact_file in the specified run_ids. The extra_columns are columns that
    % are not in the table but are augmented with run information and added to the DataFrame.
    %
    %   out = mlflow.load_table(artifact_file,run_ids,extra_columns)
    %
    % Returns: 
    %
    %    pandas.DataFrame containing the loaded table if the artifact exists
    %    or else throw a MlflowException.
    %
    % Input arguments:
    %
    %    artifact_file
    %        The run-relative artifact file path in posixpath format to which
    %        table to load (e.g. "dir/file.json").
    %
    %    run_ids
    %        Optional list of run_ids to load the table from. If no run_ids are specified,
    %        the table is loaded from all runs in the current experiment.
    %
    %    extra_columns
    %        Optional list of extra columns to add to the returned DataFrame
    %        For example, if extra_columns=["run_id"], then the returned DataFrame
    %        will have a column named run_id.
    %
    
    % This file has automatically been generated based on
    % MLflow Python SDK version 3.10.1.
    
    % Copyright 2023-2026 MathWorks, Inc.
    
    mlflow.matlab.assertPythonMLflowAvailable()
    args = ["artifact_file","run_ids","extra_columns"];
    i = mlflow.matlab.internal.pythonPositionalSplit(varargin,args);
    [varargout{1:nargout}] = py.mlflow.load_table(varargin{1:i},pyargs(varargin{i+1:end}));
