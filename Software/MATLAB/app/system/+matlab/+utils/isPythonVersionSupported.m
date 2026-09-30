function tf = isPythonVersionSupported(varargin)
% ISPYTHONVERSIONSUPPORTED Returns true if MATLAB supports a given Python version
% At least the first 2 version fields should be provided, e.g.: 3.11
%
% Supports MATLAB R2022b and later.
%
% Example:
%   tf = matlab.utils.isPythonVersionSupported("3.11.3");

% Copyright 2025-2026 The MathWorks, Inc.
tf = matlab.internal.utils.isPythonVersionSupported(varargin{:});
end
