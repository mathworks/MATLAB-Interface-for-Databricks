function varargout = validate_evaluation_results(varargin)
    %VALIDATE_EVALUATION_RESULTS Validate the evaluation result from one model (candidate) against another
    % model (baseline). If the candidate results do not meet the validation
    % thresholds, an ModelValidationFailedException will be raised.
    % .. note::
    %     This API is a replacement for the deprecated model validation
    %     functionality in the :py:func:`mlflow.evaluate` API.
    %
    %
    % Input arguments:
    %
    %    validation_thresholds
    %        A dictionary of metric name to
    %        :py:class:`mlflow.models.MetricThreshold` used for model validation.
    %        Each metric name must either be the name of a builtin metric or the
    %        name of a metric defined in the ``extra_metrics`` parameter.
    %
    %    candidate_result
    %        The evaluation result of the candidate model.
    %        Returned by the :py:func:`mlflow.evaluate` API.
    %
    %    baseline_result
    %        The evaluation result of the baseline model.
    %        Returned by the :py:func:`mlflow.evaluate` API.
    %        If set to None, the candidate model result will be
    %        compared against the threshold values directly.
    %
    
    % This file has automatically been generated based on
    % MLflow Python SDK version 3.10.1.
    
    % Copyright 2023-2026 MathWorks, Inc.
    
    mlflow.matlab.assertPythonMLflowAvailable()
    args = ["validation_thresholds","candidate_result","baseline_result"];
    i = mlflow.matlab.internal.pythonPositionalSplit(varargin,args);
    [varargout{1:nargout}] = py.mlflow.validate_evaluation_results(varargin{1:i},pyargs(varargin{i+1:end}));
