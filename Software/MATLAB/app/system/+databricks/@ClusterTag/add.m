function add(obj, key, value)
    % ADD Adds a Key Value pair to a ClusterTag object
    %
    % Example
    %   tags = databricks.ClusterTag('key1','value1');
    %   tags.add('additionalKey', 'additionalValue');

    %  (c) 2021 MathWorks, Inc.
    
    % Check key
    if ischar(key) || isStringScalar(key)
        key = char(key);
    else
        error('DATABRICKS:ERROR','Key must be of type character vector or scalar string');
    end
    if length(key) < 1 || length(key) > 127
        % Check value
        error('DATABRICKS:ERROR','Key length must be between 1 and 127 characters inclusive');
    end
    
    if ischar(value) || isStringScalar(value)
        value = char(value);
    else
        error('DATABRICKS:ERROR','Value must be of type character vector or scalar string');
    end
    if length(value) < 1 || length(value) > 255
        error('DATABRICKS:ERROR','Value length must be between 1 and 255 characters inclusive');
    end
    
    % Add entry if not 'full'
    if obj.tags.Count >= 45
        error('DATABRICKS:ERROR','A ClusterTag may have at most 45 entries');
    else
        obj.tags(char(key)) = char(value);
    end
    
end
