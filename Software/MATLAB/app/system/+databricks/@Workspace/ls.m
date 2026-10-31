function wsTable = ls(obj, varargin)
    % LS Lists contents of Databricks workspace directory or object as table.
    %
    % Returns a the result of Workspace/list as a table.
    %
    % Example:
    % W = databricks.Workspace
    % T = W.ls()
    % T =
    %   22×4 table
    %        Type                                  Path                                   ObjectID        Language
    %     ___________    _________________________________________________________    ________________    ________
    %     "NOTEBOOK"     "/Users/someone@example.com/mapMATLABFunctions"              21340560191488      "SCALA"
    %     "NOTEBOOK"     "/Users/someone@example.com/testing_wheel_21b"               81214135215911      "PYTHON"
    %     "DIRECTORY"    "/Users/someone@example.com/Simulink"                        243123252753716     ""
    %          :                                     :                                        :               :

    %   (c) 2022 The MathWorks, Inc.

    wsTable = table(obj.list(varargin{:}));

end %function
