function setDataSecurityMode(obj, mode)
    % SETDATASECURITYMODE Configures cluster property for data_security_mode
    % mode can be of type character vector, string scalar or
    % databricks.datastructures.DataSecurityMode.

    % (c) 2023 MathWorks, Inc.

    if ~(ischar(mode) || isStringScalar(mode) || isa(mode, 'databricks.datastructures.DataSecurityMode'))
        error('DATABRICKS:ERROR', 'Expected mode to be of type character vector, string scalar or databricks.datastructures.DataSecurityMode');
    end

    if ~isa(mode, 'databricks.datastructures.DataSecurityMode')
        mode = databricks.datastructures.DataSecurityMode(mode);
    end

    % Add the data_security_mode property and then set it
    if ~isprop(obj,'data_security_mode')
        obj.addprop('data_security_mode');
    end

    obj.data_security_mode = char(mode);
end