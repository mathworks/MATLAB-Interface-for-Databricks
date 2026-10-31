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
    rootStr = matlab.internal.databricksRoot(-1,varargin{:});
end %function
