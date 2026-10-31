function [rootStr] = mlflowRoot(varargin)
    % MLFLOWROOT Function to return the root folder for the MLflow interface
    % mlflowRoot alone will return the root for the MATLAB code in the
    % project.
    %
    % mlflowRoot with additional arguments will add these to the path:
    % 
    %   funDir = mlflowRoot('app', 'functions')
    %
    % The special argument of a negative number will move up folders, e.g.
    % the following call will move up two folders, and then into
    % Documentation.
    %
    % docDir = mlflowRoot(-2, 'Documentation')

    % Copyright 2024 The MathWorks, Inc.

    rootStr = fileparts(fileparts(fileparts(mfilename('fullpath'))));

    for k=1:nargin
        arg = varargin{k};
        if isstring(arg) || ischar(arg)
            rootStr = fullfile(rootStr, arg);
        elseif isnumeric(arg) && arg < 0
            for levels = 1:abs(arg)
                rootStr = fileparts(rootStr);
            end
        else
            error('MLFLOW:bad_argument', 'Bad argument for mlflowRoot');
        end
    end
end %function
