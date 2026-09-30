function add(obj, key, value)
    % ADD Adds a Key Value pair to a SparkEnvPair object
    %
    % Example
    %   vars = databricks.SparkEnvPair('key1','value1');
    %   vars.add('additionalKey', 'additionalValue');

    %  (c) 2022 MathWorks, Inc.
    
    % Check key
    if ischar(key) || isStringScalar(key)
        key = char(key);
    else
        error('DATABRICKS:ERROR','Key must be of type character vector or scalar string');
    end
    
    if ischar(value) || isStringScalar(value)
        value = char(value);
    else
        error('DATABRICKS:ERROR','Value must be of type character vector or scalar string');
    end
    
    % Add entry
    obj.envVarPairs(key) = value;
end
