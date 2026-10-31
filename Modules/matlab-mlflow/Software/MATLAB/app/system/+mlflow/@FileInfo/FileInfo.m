classdef FileInfo
% FILEINFO Metadata of a single artifact file or directory
% For directory entries file_size is an empty value.
% File sizes are stored as int64s.
%
% Example:
%
%   fi1 = mlflow.FileInfo('path', false, int64(1234));
%
%   paths = {'myArtifact1', 'myDirectory', 'myArtifact2'};
%   dirTFs = {false, true, false};
%   sizes = {int64(1234), [], int64(5678)}
%   fi2 = mlflow.FileInfo(paths, dirTFs, sizes);

%  (c) 2020-2021 MathWorks, Inc.

properties
    path = string.empty;
    is_dir = logical.empty;
    file_size = int64.empty;
end

methods
	%% Constructor
	function obj = FileInfo(varargin)

        switch nargin
            case 0
                % Use default constructor

            case 3
                % Check if we have cell array inputs
                if iscell(varargin{1}) && iscell(varargin{2}) && iscell(varargin{3})
                    if (numel(varargin{1}) ~= numel(varargin{2})) || (numel(varargin{1}) ~= numel(varargin{3}))
                        error('MLFLOW:INVALID','Expected cell arrays of the same size');
                    end

                    paths = varargin{1};
                    is_dirs = varargin{2};
                    file_sizes = varargin{3};

                    for tCount = 1:numel(paths)
                        % Create a vector of objects
                        obj(tCount) = mlflow.FileInfo;
                        obj(tCount).path = paths{tCount};
                        obj(tCount).is_dir = is_dirs{tCount};
                        obj(tCount).file_size = file_sizes{tCount};
                    end
                else
                    obj.path = varargin{1};
                    obj.is_dir = varargin{2};
                    obj.file_size = varargin{3};
                end
            otherwise
                % throw an error
                error('MLFLOW:INVALID','Invalid input specified');
        end
    end %function

    function obj = set.path(obj, value)
        if ischar(value) || isStringScalar(value)
            obj.path = string(value);
        else
            error('MLFLOW:ERROR', 'Expected path of type character vector or scalar string');
        end
    end

    function obj = set.is_dir(obj, value)
        if islogical(value) && isscalar(value)
            obj.is_dir = value;
        else
            error('MLFLOW:ERROR', 'Expected is_dir to be a scalar logical');
        end
    end

    function obj = set.file_size(obj, value)
        if isempty(value) && isnumeric(value)
            obj.file_size = int64.empty;
        elseif isa(value, 'int64') && isscalar(value) && (value >= 0)
            obj.file_size = value;
        else
            error('MLFLOW:ERROR', 'Expected file_size to be a non negative scalar int64 value or an empty numeric value');
        end
    end

end %methods

methods(Static)

    function obj = fromJSON(jsonStr)
        % Decode the data from JSON assumes int64 file_size values have not been truncated
        % by a previous default MATLAB conversion
        allowMissing = false;
        fileData = mlflow.jsondecode(jsonStr, allowMissing, {"files", {':'}, "file_size"}, "int64");

        if numel(fieldnames(fileData)) ~= 0 % empty structure
            % GET request response
            for oCount = 1:numel(fileData.files)
                obj(oCount) = mlflow.FileInfo(); %#ok<*AGROW>
                obj(oCount).path = fileData.files(oCount).path;
                obj(oCount).is_dir = fileData.files(oCount).is_dir;
                if obj(oCount).is_dir
                    obj(oCount).file_size = int64.empty;
                else
                    obj(oCount).file_size = fileData.files(oCount).file_size;
                end
            end
        else
            obj = mlflow.FileInfo.empty;
        end
    end %function

end %methods static

end %class
