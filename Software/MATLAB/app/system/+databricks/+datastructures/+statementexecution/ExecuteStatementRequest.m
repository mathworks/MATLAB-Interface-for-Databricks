classdef ExecuteStatementRequest < JSONMapper
    % ExecuteStatementRequest Request to execute a SQL statement
    %
    % ExecuteStatementRequest Properties:
    %   statement - SQL statement to execute
    %   warehouseId - Warehouse upon which to execute a statement
    %   catalog - Default catalog for statement execution
    %   schema - Default schema for statement execution
    %   rowLimit - Maximum number of rows to include in the result set
    %   byteLimit - Maximum byte size of the result set
    %   format - Format of returned data
    %   disposition - Fetch disposition for statement results
    %   waitTimeout - Time the API waits for the statement result set
    %   onWaitTimeout - Action to take when waitTimeout expires
    %   parameters - A list of parameters to pass into a SQL statement containing parameter markers
    %   queryTags - An array of query tags to annotate a SQL statement

    % Copyright 2023-2026, MathWorks Inc.

    properties
        % statement - SQL statement to execute
        statement string
        % warehouseId - Warehouse upon which to execute a statement
        warehouseId string {JSONMapper.fieldName(warehouseId,"warehouse_id")}
        % catalog - Default catalog for statement execution
        catalog string {JSONMapper.fieldName(catalog,"catalog")}
        % schema - Default schema for statement execution
        schema databricks.datastructures.statementexecution.Schema {JSONMapper.fieldName(schema,"schema")}
        % rowLimit - Maximum number of rows to include in the result set
        rowLimit int64 {JSONMapper.fieldName(rowLimit,"row_limit")}
        % byteLimit - Maximum byte size of the result set
        byteLimit int64 {JSONMapper.fieldName(byteLimit,"byte_limit")}
        % Format of returned data
        format databricks.datastructures.statementexecution.Format {JSONMapper.fieldName(format,"format")} = databricks.datastructures.statementexecution.Format.JSON_ARRAY
        % disposition - Fetch disposition for statement results
        disposition databricks.datastructures.statementexecution.Disposition {JSONMapper.fieldName(disposition,"disposition")} = databricks.datastructures.statementexecution.Disposition.INLINE
        % waitTimeout - Time the API waits for the statement result set
        waitTimeout string {JSONMapper.fieldName(waitTimeout,"wait_timeout")}
        % onWaitTimeout - Action to take when waitTimeout expires
        onWaitTimeout databricks.datastructures.statementexecution.TimeoutAction {JSONMapper.fieldName(onWaitTimeout,"on_wait_timeout")} = databricks.datastructures.statementexecution.TimeoutAction.CONTINUE
        % parameters - A list of parameters to pass into a SQL statement containing parameter markers
        parameters databricks.datastructures.statementexecution.Parameter {JSONMapper.JSONArray}
        % queryTags - An array of query tags to annotate a SQL statement
        queryTags databricks.datastructures.statementexecution.QueryTag {JSONMapper.JSONArray, JSONMapper.fieldName(queryTags,"query_tags")}
    end

    methods
        function obj = ExecuteStatementRequest(s,inputs)
            % To allow proper nesting of object, derived objects must
            % call the initialize method from their constructor. This
            % also allows objects to be instantiated with Name-Value pairs
            % as inputs to set properties to specified values.
            arguments
                s { JSONMapper.ConstructorArgument } = []
                inputs.?databricks.datastructures.statementexecution.ExecuteStatementRequest
            end
            obj = obj.initialize(s,inputs);
        end
    end
end
