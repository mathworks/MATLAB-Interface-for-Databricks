function vendor = userRequestVendor()
    % userRequestVendor Interactively asks the user for the vendor
    % If an invalid value is provided a message is displayed and an empty value
    % is returned.
    % A matlab.databricks.vendor.Vendor enumeration is returned.
    % Input is case insensitive.
    %
    % Example
    %   v = matlab.databricks.vendor.userRequestVendor()

    %  (c) 2024 MathWorks, Inc.

    if batchStartupOptionUsed
        error("DATABRICKS:userRequestVendor", "Cannot call userRequestVendor in batch mode as it requires interaction");
    end

    enumVals = enumeration('matlab.databricks.vendor.Vendor');
    enumStr = string(join(string(enumVals), ", "));

    inputStr = "Enter cloud vendor, which host the Databricks environment, must be one of: " + enumStr + ": ";
    response = strip(input(inputStr, 's'));

    try
        vendor = matlab.databricks.vendor.Vendor(response);
    catch
        fprintf(2, "Invalid vendor value, must be one of: %s\n", enumStr);
        vendor = matlab.databricks.vendor.Vendor.empty;
    end
end