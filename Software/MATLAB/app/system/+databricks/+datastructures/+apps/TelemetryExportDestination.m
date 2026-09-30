classdef TelemetryExportDestination < JSONMapper
    % TelemetryExportDestination
    %
    % App API 2.0

    % Copyright 2026 The MathWorks, Inc.

    properties
        unityCatalog string { JSONMapper.fieldName(unityCatalog, "unity_catalog")}
    end

    methods
        function obj = TelemetryExportDestination(s, inputs)
            arguments
                s {JSONMapper.ConstructorArgument} = []
                inputs.?databricks.datastructures.apps.TelemetryExportDestination
            end
            obj@JSONMapper(s, inputs);
        end
    end
end
