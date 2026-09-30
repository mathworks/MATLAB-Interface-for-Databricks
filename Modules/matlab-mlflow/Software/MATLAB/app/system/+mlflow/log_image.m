function varargout = log_image(varargin)
    %LOG_IMAGE Logs an image in MLflow, supporting two use cases:
    % 1. Time-stepped image logging:
    %     Ideal for tracking changes or progressions through iterative processes (e.g.,
    %     during model training phases).
    %     - Usage: :code:`log_image(image, key=key, step=step, timestamp=timestamp)`
    % 2. Artifact file image logging:
    %     Best suited for static image logging where the image is saved directly as a file
    %     artifact.
    %     - Usage: :code:`log_image(image, artifact_file)`
    % The following image formats are supported:
    %     - `numpy.ndarray`_
    %     - `PIL.Image.Image`_
    %     .. _numpy.ndarray:
    %         https://numpy.org/doc/stable/reference/generated/numpy.ndarray.html
    %     .. _PIL.Image.Image:
    %         https://pillow.readthedocs.io/en/stable/reference/Image.html#PIL.Image.Image
    %     - :class:`mlflow.Image`: An MLflow wrapper around PIL image for convenient image logging.
    % Numpy array support
    %     - data types:
    %         - bool (useful for logging image masks)
    %         - integer [0, 255]
    %         - unsigned integer [0, 255]
    %         - float [0.0, 1.0]
    %         .. warning::
    %             - Out-of-range integer values will raise ValueError.
    %             - Out-of-range float values will auto-scale with min/max and warn.
    %     - shape (H: height, W: width):
    %         - H x W (Grayscale)
    %         - H x W x 1 (Grayscale)
    %         - H x W x 3 (an RGB channel order is assumed)
    %         - H x W x 4 (an RGBA channel order is assumed)
    %
    %
    % Input arguments:
    %
    %    image
    %        The image object to be logged.
    %
    %    artifact_file
    %        Specifies the path, in POSIX format, where the image
    %        will be stored as an artifact relative to the run's root directory (for
    %        example, "dir/image.png"). This parameter is kept for backward compatibility
    %        and should not be used together with `key`, `step`, or `timestamp`.
    %
    %    key
    %        Image name for time-stepped image logging. This string may only contain
    %        alphanumerics, underscores (_), dashes (-), periods (.), spaces ( ), and
    %        slashes (/).
    %
    %    step
    %        Integer training step (iteration) at which the image was saved.
    %        Defaults to 0.
    %
    %    timestamp
    %        Time when this image was saved. Defaults to the current system time.
    %
    %    synchronous
    %        *Experimental* If True, blocks until the image is logged successfully.
    %
    
    % This file has automatically been generated based on
    % MLflow Python SDK version 3.10.1.
    
    % Copyright 2023-2026 MathWorks, Inc.
    
    mlflow.matlab.assertPythonMLflowAvailable()
    args = ["image","artifact_file","key","step","timestamp","synchronous"];
    i = mlflow.matlab.internal.pythonPositionalSplit(varargin,args);
    [varargout{1:nargout}] = py.mlflow.log_image(varargin{1:i},pyargs(varargin{i+1:end}));
