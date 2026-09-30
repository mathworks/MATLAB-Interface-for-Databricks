function varargout = log_figure(varargin)
    %LOG_FIGURE Log a figure as an artifact. The following figure objects are supported:
    % - `matplotlib.figure.Figure`_
    % - `plotly.graph_objects.Figure`_
    % .. _matplotlib.figure.Figure:
    %     https://matplotlib.org/api/_as_gen/matplotlib.figure.Figure.html
    % .. _plotly.graph_objects.Figure:
    %     https://plotly.com/python-api-reference/generated/plotly.graph_objects.Figure.html
    %
    %
    % Input arguments:
    %
    %    figure
    %        Figure to log.
    %
    %    artifact_file
    %        The run-relative artifact file path in posixpath format to which
    %        the figure is saved (e.g. "dir/file.png").
    %
    %    save_kwargs
    %        Additional keyword arguments passed to the method that saves the figure.
    %
    
    % This file has automatically been generated based on
    % MLflow Python SDK version 3.10.1.
    
    % Copyright 2023-2026 MathWorks, Inc.
    
    mlflow.matlab.assertPythonMLflowAvailable()
    args = ["figure","artifact_file"];
    i = mlflow.matlab.internal.pythonPositionalSplit(varargin,args);
    [varargout{1:nargout}] = py.mlflow.log_figure(varargin{1:i},pyargs(varargin{i+1:end}));
