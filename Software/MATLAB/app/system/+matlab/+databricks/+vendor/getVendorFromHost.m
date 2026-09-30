function vendor = getVendorFromHost(host)
    % getVendorFromHost Determine the vendor based on the Databricks host if possible
    % A matlab.databricks.vendor.Vendor enumeration is returned.
    % If a vendor cannot be determined a empty value is returned.
    % The host argument is expected to start with "https://".
    %
    % Example
    %   v = matlab.databricks.vendor.getVendorFromHost("https://adb-123456789123456.6.azuredatabricks.net")

    %  (c) 2024 MathWorks, Inc.

    arguments
        host string {mustBeTextScalar, mustBeNonzeroLengthText}
    end

    if startsWith(host, "https://dbc-")
        v = 'aws';
    elseif startsWith(host, "https://adb-")
        v = 'azure';
    elseif contains(host, "azuredatabricks.net")
        v = 'azure';
    else
        v = '';
    end

    if strlength(v) == 0
        vendor = matlab.databricks.vendor.Vendor.empty;
    else
        vendor = matlab.databricks.vendor.Vendor(v);
    end
end