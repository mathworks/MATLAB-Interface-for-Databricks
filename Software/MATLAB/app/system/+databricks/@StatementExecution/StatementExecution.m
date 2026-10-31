classdef StatementExecution < databricks.Object
    % STATEMENTEXECUTION Databricks StatementExecution API
    % Class to support working with StatementExecution.
    %
    % Example:
    %    s = databricks.StatementExecution;
    %
    % Security:
    %    Statement Execution API calls require the Databricks SQL API scope.
    %    Treat statement IDs, result payloads, and EXTERNAL_LINKS responses as
    %    sensitive data. External result links are presigned cloud storage URLs
    %    with an expiration time; avoid logging or sharing them and fetch linked
    %    data only over trusted channels.
    %
    % See also: runStatement, execute,
    % https://docs.databricks.com/api/statement-execution/v1/statement-execution

    % Copyright 2023-2026, The MathWorks, Inc.

    properties
        HTTPOptions matlab.net.http.HTTPOptions
    end

    methods
        function obj = StatementExecution(varargin)
            % Constructor
            obj.Version = '2.0';
            obj.HTTPOptions = databricks.internal.getHTTPOptions(convertResponse=false);
            obj.getAuth(varargin{:});
        end
    end
end
