"""
The ``matlab_mlflow`` module provides an API for logging and loading MATLAB models. This module
exports MATLAB models with the following flavors:

MATLAB (native) format
    This is the main flavor that can be loaded back into MATLAB.
:py:mod:`mlflow.pyfunc`
    Produced for use by generic pyfunc-based deployment tools and batch inference.
"""

# Copyright 2023 - 2026 MathWorks, Inc.

import os

import mlflow.version
import yaml
from mlflow import pyfunc
from mlflow.exceptions import MlflowException
from mlflow.models import Model, ModelInputExample, ModelSignature
from mlflow.models.model import MLMODEL_FILE_NAME
from mlflow.models.utils import _save_example
from mlflow.protos.databricks_pb2 import INVALID_STATE
from mlflow.tracking._model_registry import DEFAULT_AWAIT_MAX_SLEEP_SECONDS
from mlflow.tracking.artifact_utils import _download_artifact_from_uri
from mlflow.utils.docstring_utils import LOG_MODEL_PARAM_DOCS, format_docstring
from mlflow.utils.environment import (
    _CONDA_ENV_FILE_NAME,
    _CONSTRAINTS_FILE_NAME,
    _PYTHON_ENV_FILE_NAME,
    _REQUIREMENTS_FILE_NAME,
    _process_conda_env,
    _process_pip_requirements,
    _PythonEnv,
    _validate_env_arguments,
)
from mlflow.utils.file_utils import _copy_file_or_tree, write_to
from mlflow.utils.model_utils import (
    _get_flavor_configuration,
    _validate_and_copy_code_paths,
    _validate_and_prepare_target_save_path,
)
from mlflow.utils.requirements_utils import _get_pinned_requirement

import matlab_mlflow

FLAVOR_NAME = "matlab"


def get_default_pip_requirements(include_matlab_mlflow_module):
    """
    :return: A list of default pip requirements for MLflow Models produced by this flavor.
             Calls to :func:`save_model()` and :func:`log_model()` produce a pip environment
             that, at minimum, contains these requirements.
    """

    pip_deps = []
    if not include_matlab_mlflow_module:
        pip_deps.append(_get_pinned_requirement("matlab-mlflow"))

    return pip_deps


@format_docstring(LOG_MODEL_PARAM_DOCS.format(package_name=FLAVOR_NAME))
def save_model(
    path,
    sub_flavor="none",
    matlab_path=None,
    matlab_release="r2023a",
    python_path=None,
    package_name=None,
    requiredMCRProducts=None,
    requiredMCRProductNames=None,
    mps_ctf=None,
    onnx_path=None,
    conda_env=None,
    mlflow_model=None,
    include_matlab_mlflow_module=True,
    signature: ModelSignature = None,
    input_example: ModelInputExample = None,
    input_example_path=None,
    input_example_info=None,
    pip_requirements=None,
    extra_pip_requirements=None,
    metadata=None,
    **kwargs,
):
    """
    Save a MATLAB model to a path on the local file system.

    :param path: Local path where the model is to be saved.

    :param sub_flavor: MATLAB sub flavor, valid options ``"none"``, ``"compiler_sdk_python"``,
                       ``"onnx"``, ``"coder"``.

    :param matlab_release: MATLAB release used to created the model.

    :param matlab_path: Path to MATLAB code if including original MATLAB code in model.

    :param onnx_path: Path to Deep Learning Toolbox network saved as ONNX-file. Required for
                      ``sub_flavor = "onnx"``.

    :param python_path: Path to MATLAB Compiler SDK Python package to include in model. Required
                         for ``sub_flavor = "compiler_sdk_python"``.
    :param requiredMCRProducts: location of requiredMCRProducts.txt.
    :param conda_env: {{ conda_env }}
    :param pip_requirements: {{ pip_requirements }}
    :param extra_pip_requirements: {{ extra_pip_requirements }}

    :param mlflow_model: MLflow model config this flavor is being added to.
    :param signature: :py:class:`ModelSignature <mlflow.models.ModelSignature>`
                      describes model input and output :py:class:`Schema <mlflow.types.Schema>`.
                      The model signature can be :py:func:`inferred <mlflow.models.infer_signature>`
                      from datasets with valid model input (e.g. the training dataset with target
                      column omitted) and valid model output (e.g. model predictions generated on
                      the training dataset), for example:

                      .. code-block:: python

                            import numpy as np

                            example_in = np.float64([21.0])
                            example_out = np.float64([42.0])
                            signature = mlflow.models.infer_signature(example_in, example_out)
    :param input_example: Input example provides one or several instances of valid
                          model input. The example can be used as a hint of what data to feed the
                          model.

    :param metadata: Custom metadata dictionary passed to the model and stored in the MLmodel file.

    :param kwargs: kwargs.

    .. code-block:: matlab
        :caption: MATLAB Compiler SDK Python Example - MATLAB Code

        compiler.build.pythonPackage(
            "/work/mymodel/matlab/main_function.m", ...
            "PackageName", ...
            "mlflow_model", ...
            "OutputDir","/work/mymodel/python")

    .. code-block:: python
        :caption: MATLAB Compiler SDK Python Example - Python Code

        matlab_mlflow.save_model(
            path="/work/mymodel/my_mlflow_model",
            sub_flavor="compiler_sdk_python",
            matlab_path="/work/mymodel/matlab",
            python_path="/work/mymodel/python",
        )

    .. code-block:: matlab
        :caption: ONNX Example - MATLAB Code

        exportONNXNetwork(net,"/work/mymodel/onnx/model.onnx")

    .. code-block:: python
        :caption: ONNX Example - Python Code

        matlab_mlflow.save_model(
            path="/work/mymodel/my_mlflow_model",
            sub_flavor="onnx",
            matlab_path="/work/mymodel/matlab",
            onnx_path="/work/mymodel/onnx/model.onnx",
        )
    """

    _validate_env_arguments(conda_env, pip_requirements, extra_pip_requirements)

    path = os.path.abspath(path)
    _validate_and_prepare_target_save_path(path)

    matlab_parameters = {}
    pyfunc_parameters = {}

    # If no Model provided as input, instantiate a new one
    if mlflow_model is None:
        mlflow_model = Model()

    # Copy MATLAB Compiler SDK Python code into model
    if python_path is not None:
        pyfunc_parameters["code"] = _validate_and_copy_code_paths(python_path, path)
        matlab_parameters["package_name"] = package_name

    # If ONNX model is set, save as ONNX model
    if onnx_path is not None:
        import mlflow
        import onnx

        m = onnx.load_model(onnx_path)
        mlflow.onnx.save_model(m, path, mlflow_model=mlflow_model)

    # Copy MPS CTF into package
    if mps_ctf is not None:
        matlab_parameters["mps_ctf"] = _validate_and_copy_code_paths(
            [mps_ctf], path, "mps"
        )

    # Copy MATLAB code into package
    if matlab_path is not None:
        matlab_parameters["matlab_code"] = _validate_and_copy_code_paths(
            matlab_path, path, "matlab"
        )

    # If provided include requiredMCRProducts
    if requiredMCRProducts is not None:
        matlab_parameters["requiredMCRProducts"] = _copy_file_or_tree(
            requiredMCRProducts, path
        )

    if requiredMCRProductNames is not None:
        matlab_parameters["requiredMCRProductNames"] = requiredMCRProductNames

    # Include signature and example inputs if provided
    if signature is not None:
        mlflow_model.signature = signature
    if input_example is not None:
        _save_example(mlflow_model, input_example, path)
    if input_example_path is not None:
        _copy_file_or_tree(
            os.path.join(input_example_path, input_example_info["artifact_path"]), path
        )
        serving_input_path = input_example_info.get("serving_input_path")
        if serving_input_path is not None:
            _copy_file_or_tree(
                os.path.join(input_example_path, serving_input_path), path
            )
        mlflow_model.saved_input_example_info = input_example_info

    # Include metadata if provided
    if metadata is not None:
        mlflow_model.metadata = metadata

    # First save the pyfunc flavor model if Python version is provided
    if sub_flavor == "compiler_sdk_python":
        # If requested include matlab_mlflow itself in the model
        if include_matlab_mlflow_module:
            _validate_and_copy_code_paths(
                [os.path.abspath(matlab_mlflow.__file__)],
                path,
                os.path.join("code", "matlab_mlflow"),
            )
        pyfunc.add_to_model(
            mlflow_model,
            loader_module="matlab_mlflow",
            conda_env=_CONDA_ENV_FILE_NAME,
            python_env=_PYTHON_ENV_FILE_NAME,
            **pyfunc_parameters,
        )
        matlab_parameters["pyfunc_params"] = mlflow_model.flavors.get("python_function")

    # Save the MATLAB flavor model.
    mlflow_model.add_flavor(
        FLAVOR_NAME,
        sub_flavor=sub_flavor,
        matlab_release=matlab_release,
        **matlab_parameters,
    )

    # Write the MLmodel file
    mlflow_model.save(os.path.join(path, MLMODEL_FILE_NAME))

    if sub_flavor != "compiler_sdk_python":
        return

    # Conda/pip environment management. Copied from other flavors. TODO investigate whether this is
    # really necessary, MATLAB dependencies may not be this flexible.
    if conda_env is None:
        if pip_requirements is None:
            default_reqs = get_default_pip_requirements(include_matlab_mlflow_module)
            # To ensure `_load_pyfunc` can successfully load the model during the dependency
            # inference, `mlflow_model.save` must be called beforehand to save an MLmodel file.
            # inferred_reqs = mlflow.models.infer_pip_requirements(
            #    path,
            #    FLAVOR_NAME,
            #    fallback=default_reqs,
            # )
            # default_reqs = sorted(set(inferred_reqs).union(default_reqs))
        else:
            default_reqs = None
        conda_env, pip_requirements, pip_constraints = _process_pip_requirements(
            default_reqs,
            pip_requirements,
            extra_pip_requirements,
        )
    else:
        conda_env, pip_requirements, pip_constraints = _process_conda_env(conda_env)

    with open(os.path.join(path, _CONDA_ENV_FILE_NAME), "w") as f:
        yaml.safe_dump(conda_env, stream=f, default_flow_style=False)

    # Save `constraints.txt` if necessary
    if pip_constraints:
        write_to(os.path.join(path, _CONSTRAINTS_FILE_NAME), "\n".join(pip_constraints))

    # Save `requirements.txt`
    write_to(os.path.join(path, _REQUIREMENTS_FILE_NAME), "\n".join(pip_requirements))

    _PythonEnv.current().to_yaml(os.path.join(path, _PYTHON_ENV_FILE_NAME))

    return mlflow_model


@format_docstring(LOG_MODEL_PARAM_DOCS.format(package_name=FLAVOR_NAME))
def log_model(
    artifact_path_or_name,
    sub_flavor="none",
    matlab_path=None,
    matlab_release="r2023a",
    python_path=None,
    package_name=None,
    requiredMCRProducts=None,
    requiredMCRProductNames=None,
    mps_ctf=None,
    onnx_path=None,
    conda_env=None,
    include_matlab_mlflow_module=True,
    registered_model_name=None,
    signature: ModelSignature = None,
    input_example: ModelInputExample = None,
    input_example_path=None,
    input_example_info=None,
    await_registration_for=DEFAULT_AWAIT_MAX_SLEEP_SECONDS,
    pip_requirements=None,
    extra_pip_requirements=None,
    metadata=None,
    **kwargs,
):
    """
    Log a MATLAB model as an MLflow artifact for the current run.

    :param artifact_path: Run-relative artifact path.

    :param sub_flavor: MATLAB sub flavor, valid options ``"none"``, ``"compiler_sdk_python"``,
                       ``"onnx"``, ``"coder"``.

    :param matlab_release: MATLAB release used to created the model.

    :param matlab_path: Path to MATLAB code if including original MATLAB code in model.

    :param onnx_path: Path to Deep Learning Toolbox network saved as ONNX-file. Required for
                      ``sub_flavor = "onnx"``.

    :param python_path: Path to MATLAB Compiler SDK Python package to include in model. Required
                         for ``sub_flavor = "compiler_sdk_python"``.
    :param requiredMCRProducts: location of requiredMCRProducts.txt.
    :param conda_env: {{ conda_env }}
    :param registered_model_name: This argument may change or be removed in a
                                  future release without warning. If given, create a model
                                  version under ``registered_model_name``, also creating a
                                  registered model if one with the given name does not exist.
    :param signature: :py:class:`ModelSignature <mlflow.models.ModelSignature>`
                      describes model input and output :py:class:`Schema <mlflow.types.Schema>`.
                      The model signature can be :py:func:`inferred <mlflow.models.infer_signature>`
                      from datasets with valid model input (e.g. the training dataset with target
                      column omitted) and valid model output (e.g. model predictions generated on
                      the training dataset), for example:

                      .. code-block:: python

                            import numpy as np

                            example_in = np.float64([21.0])
                            example_out = np.float64([42.0])
                            signature = mlflow.models.infer_signature(example_in, example_out)
    :param kwargs: kwargs
    :param await_registration_for: Number of seconds to wait for the model version to finish
                            being created and is in ``READY`` status. By default, the function
                            waits for five minutes. Specify 0 or None to skip waiting.
    :param pip_requirements: {{ pip_requirements }}
    :param extra_pip_requirements: {{ extra_pip_requirements }}
    :param metadata: Custom metadata dictionary passed to the model and stored in the MLmodel file.

    :return: A :py:class:`ModelInfo <mlflow.models.model.ModelInfo>` instance that contains the
             metadata of the logged model.
    """
    apon = {}
    if mlflow.version.VERSION.startswith("2"):
        apon["artifact_path"] = artifact_path_or_name
    else:
        apon["artifact_path"] = None
        apon["name"] = artifact_path_or_name

    return Model.log(
        **apon,
        sub_flavor=sub_flavor,
        matlab_release=matlab_release,
        matlab_path=matlab_path,
        onnx_path=onnx_path,
        python_path=python_path,
        package_name=package_name,
        requiredMCRProducts=requiredMCRProducts,
        requiredMCRProductNames=requiredMCRProductNames,
        mps_ctf=mps_ctf,
        include_matlab_mlflow_module=include_matlab_mlflow_module,
        flavor=matlab_mlflow,
        registered_model_name=registered_model_name,
        conda_env=conda_env,
        code_paths=python_path,
        signature=signature,
        input_example=input_example,
        input_example_path=input_example_path,
        input_example_info=input_example_info,
        await_registration_for=await_registration_for,
        pip_requirements=pip_requirements,
        extra_pip_requirements=extra_pip_requirements,
        metadata=metadata,
        validate_serving_input=False,
        **kwargs,
    )


def load_model(model_uri, dst_path=None):
    """
    Load a MATLAB model from a local file or a run.

    :param model_uri: The location, in URI format, of the MLflow model. For example:

                      - ``/Users/me/path/to/local/model``
                      - ``relative/path/to/local/model``
                      - ``s3://my_bucket/path/to/model``
                      - ``runs:/<mlflow_run_id>/run-relative/path/to/model``

                      For more information about supported URI schemes, see
                      `Referencing Artifacts <https://www.mlflow.org/docs/latest/tracking.html#
                      artifact-locations>`_.
    :param dst_path: The local filesystem path to which to download the model artifact.
                     This directory must already exist. If unspecified, a local output
                     path will be created.

    :return: Directory containing MATLAB code, to be added to the MATLABPATH.
    """
    local_model_path = _download_artifact_from_uri(
        artifact_uri=model_uri, output_path=dst_path
    )
    flavor_conf = _get_flavor_configuration(
        model_path=local_model_path, flavor_name=FLAVOR_NAME
    )
    return os.path.join(local_model_path, flavor_conf["matlab_code"])


def _load_pyfunc(path):
    """
    Load PyFunc implementation. Called by ``pyfunc.load_model``.

    :param path: Local filesystem path to the MLflow Model with the ``matlab`` flavor.
    """
    matlab_configuration = _get_flavor_configuration(
        model_path=path, flavor_name=FLAVOR_NAME
    )
    return _MATLABModelWrapper(matlab_configuration)


# Wrapper for pyfunc compatibility
class _MATLABModelWrapper:
    def __init__(self, matlab_configuration):
        self._matlab_configuration = matlab_configuration
        if self._matlab_configuration["sub_flavor"] == "compiler_sdk_python":
            import importlib

            self._module = importlib.import_module(
                self._matlab_configuration["package_name"]
            )
            self._mlflow_module = importlib.import_module(
                ".mlflow", self._matlab_configuration["package_name"]
            )

            # Initialize MATLAB package/MCR
            self._obj = self._module.initialize()
        elif self._matlab_configuration["sub_flavor"] == "coder":
            pass
        elif self._matlab_configuration["sub_flavor"] == "onnx":
            # This should not occur if the model was saved as onnx model, nevertheless double
            # check and throw an error if this is reached.
            raise MlflowException(
                message="MATLAB mlflow model is corrupt.", error_code=INVALID_STATE
            )
        else:
            raise MlflowException(
                message="MATLAB mlflow sub_flavor is invalid.", error_code=INVALID_STATE
            )

    def predict(self, input_data, params=None):
        if self._matlab_configuration["sub_flavor"] == "compiler_sdk_python":
            out = self._mlflow_module.wrapper(self._obj, input_data, params)
            return out
        elif self._matlab_configuration["sub_flavor"] == "coder":
            pass
        elif self._matlab_configuration["sub_flavor"] == "onnx":
            # This should not occur if the model was saved as onnx model, nevertheless double
            # check and throw an error if this is reached.
            raise MlflowException(
                message="MATLAB mlflow model is corrupt.", error_code=INVALID_STATE
            )
        else:
            raise MlflowException(
                message="MATLAB mlflow sub_flavor is invalid.", error_code=INVALID_STATE
            )
