function vendor = getVendorFromEnvironment(options)
    % getVendorFromEnvironment Gets a vendor from the DATABRICKS_VENDOR environment variable
    % A matlab.databricks.vendor.Vendor enumeration is returned.
    %
    % If an invalid value is provided a message is optionally displayed
    % An empty value is returned.
    %
    % The variable value is case insensitive.
    %
    % Example
    %   v = matlab.databricks.vendor.getVendorFromEnvironment()

    %  (c) 2024 MathWorks, Inc.
    arguments
        options.verbose (1,1) logical = true
    end

    envVar = getenv("DATABRICKS_VENDOR");
    if isempty(envVar) || strlength(envVar) == 0
        vendor = matlab.databricks.vendor.Vendor.empty;
    else
        try
            vendor = matlab.databricks.vendor.Vendor(envVar);
        catch
            if options.verbose
                enumVals = enumeration('matlab.databricks.vendor.Vendor');
                enumStr = string(join(string(enumVals), ", "));
                fprintf(2, "Invalid vendor value, must be one of: %s\n", enumStr);
            end
            vendor = matlab.databricks.vendor.Vendor.empty;
        end
    end
end