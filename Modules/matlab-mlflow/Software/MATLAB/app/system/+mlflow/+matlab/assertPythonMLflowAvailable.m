function assertPythonMLflowAvailable
    persistent TF
    if isempty(TF)
      TF = true;
      try
        py.importlib.import_module("mlflow");
      catch
        TF = false;
      end
    end
    if ~TF
        ME = MException("mlflow:matlab:pythonUnavailable","This functionality is only available if Python and the mlflow Python module are available to MATLAB");
        throwAsCaller(ME)
    end

