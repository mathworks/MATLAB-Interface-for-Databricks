function tf = setVendor(vendor, options)
    % SETVENDOR Convenience function to set the vendor settings field.
    % Returns true on success otherwise false.
    % This function is not case sensitive, a lowercase value is stored.
    %
    % Example:
    %   tf = matlab.databricks.vendor.setVendor("azure");

    % Copyright 2024, The MathWorks, Inc.

    arguments
        vendor string {mustBeTextScalar, mustBeNonzeroLengthText}
        options.enforceEnum (1,1) logical = true;
        options.verbose (1,1) logical = false
    end

    vendorUpper = upper(vendor);
    vendorLower = lower(vendor);
    values = string(enumeration("matlab.databricks.vendor.Vendor"));

    if ~any(matches(values, vendorUpper))
        fprintf(2, "Vendor: %s is not a member of enumeration: matlab.databricks.vendor.Vendor\n", vendor);
        fprintf("Enumeration values are: %s\n", join(values, ", "));
        tf = false;
        return;
    end

    if databricks.internal.settings.Settings.writeDatabricksSettingsFields("vendor", vendorLower, verbose=options.verbose)
        tf = true;
    else
        fprintf(2, "Error writing: %s, to: %s\n", vendor, settingsFile);
        tf = false;
    end
end