# MATLAB MLflow models

This directory contains a number of example MATLAB&reg; functions in the `matlab` directory. The functions mainly demonstrate usage of various data types directly- and inside MATLAB tables.

The functions can be *saved* as MATLAB MLflow models using `saveOrLogAll("save")` or *logged* as MATLAB MLflow models using `saveOrLogAll("log")`.

The tests in `Software/Python/tests/test_compiler_sdk_python.py` test invoking the *saved* models from Python&reg;.

`models_serve.rest` shows how some of the models can be invoked if they are served by MLflow CLI using [`mlflow models serve`](https://mlflow.org/docs/latest/cli.html#mlflow-models-serve).
