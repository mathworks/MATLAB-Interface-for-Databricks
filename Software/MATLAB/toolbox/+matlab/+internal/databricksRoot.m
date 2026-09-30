function [rootStr] = databricksRoot(varargin)
% DATABRICKSROOT Function to return the root folder for the Databricks interface
%
% databricksRoot alone will return the root for the MATLAB code in the
% project.
%
% databricksRoot with additional arguments will add these to the path
%
%  funDir = databricksRoot('app', 'functions')
%
%  The special argument of a negative number will move up folders, e.g.
%  the following call will move up two folders, and then into
%  Documentation.
%
%  docDir = databricksRoot(-2, 'Documentation')

% Copyright 2014-2026 The MathWorks, Inc.

% Traverse up the directory to find the file .toolboxroot which is in
% toolbox directory.
folder = fileparts(mfilename('fullpath'));
while true
    if isfile(fullfile(folder, '.toolboxroot'))
        rootStr = folder;
        break
    end
    parent = fileparts(folder);
    if strcmp(parent, folder)
        error('DATABRICKS:toolboxroot_not_found', ...
            'Could not find .toolboxroot in any ancestor directory.');
    end
    folder = parent;
end


for k=1:nargin
    arg = varargin{k};
    if isstring(arg) || ischar(arg)
        rootStr = fullfile(rootStr, arg);
    elseif isnumeric(arg) && arg < 0
        for levels = 1:abs(arg)
            rootStr = fileparts(rootStr);
        end
    else
        error('DATABRICKS:databricksroot_bad_argument', ...
            'Bad argument for databricksRoot');
    end
end

end %function
