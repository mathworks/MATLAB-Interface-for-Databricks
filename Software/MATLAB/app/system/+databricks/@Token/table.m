function tableResult = table(obj, varargin)
    % TABLE Method to convert a list of tokens to a MATLAB table
    % Convert a list of tokens showing the ID and info and omitting the value
    % that is available on the createToken interface.
    % If no tokens are found an error results.
    %
    % Deprecated: This method will be removed in a future release
    %
    % Example:
    %   token = databricks.Token();
    %   list = token.list();
    %   t = table(list);

    %  (c) 2019-2026 MathWorks, Inc.

    tableResult = struct2table([obj(:).token_info]);
end
