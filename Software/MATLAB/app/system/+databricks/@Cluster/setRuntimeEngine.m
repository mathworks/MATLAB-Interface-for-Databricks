function setRuntimeEngine(obj, runtimeEngine)
    % SETRUNTIMEENGINE Configures cluster property for runtime_engine
    % Decides which runtime engine to be use, e.g. Standard vs. Photon.
    % If unspecified, the runtime engine is inferred from spark_version.
    %
    % See also runtime_engine property handling in getPayload().

    % (c) 2023-2024 MathWorks, Inc.

    if ~(ischar(runtimeEngine) || isStringScalar(runtimeEngine) || isa(runtimeEngine, 'databricks.datastructures.RuntimeEngine'))
        error('DATABRICKS:ERROR', 'Expected runtimeEngine to be of type character vector, string scalar or databricks.datastructures.RuntimeEngine');
    end

    if ~isa(runtimeEngine, 'databricks.datastructures.RuntimeEngine')
        runtimeEngine = databricks.datastructures.RuntimeEngine(runtimeEngine);
    end

    % Add the runtime_engine property and then set it
    if ~isprop(obj,'runtime_engine')
        obj.addprop('runtime_engine');
    end

    obj.runtime_engine = char(runtimeEngine);
end