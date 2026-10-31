classdef UnityCatalog < JSONMapper
    % UnityCatalog
    %
    % App API 2.0

    % Copyright 2026 The MathWorks, Inc.

    properties
        logsTable string { JSONMapper.fieldName(logsTable, "logs_table")}
        metricsTable string { JSONMapper.fieldName(metricsTable, "metrics_table")}
        tracesTable string { JSONMapper.fieldName(tracesTable, "traces_table")}
    end

    methods
        function obj = UnityCatalog(s, inputs)
            arguments
                s {JSONMapper.ConstructorArgument} = []
                inputs.?databricks.datastructures.apps.UnityCatalog
            end
            obj@JSONMapper(s, inputs);
        end
    end
end
