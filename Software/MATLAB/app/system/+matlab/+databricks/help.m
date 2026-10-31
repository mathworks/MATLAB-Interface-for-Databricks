function help(varargin)
    % help Get help from the Databricks Documentation directory
    % Passes request through to matlab.databricks.doc()
    % A filename with or without a .html or .md extension can be given as an argument.
    %
    % Examples
    %   matlab.databricks.help()
    %
    %   matlab.databricks.help('Files')
    %
    % See also: matlab.databricks.doc

    % Copyright 2026 The MathWorks, Inc.

    if isdeployed
        fprintf(2, "Not supported in deployed mode\n.");
        return;
    end

    matlab.databricks.doc(varargin{:});
end