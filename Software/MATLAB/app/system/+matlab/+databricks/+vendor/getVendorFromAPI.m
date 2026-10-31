function vendor = getVendorFromAPI(options)
    % getVendorFromAPI Use the Unity Catalog API to determine a vendor
    % A matlab.databricks.vendor.Vendor enumeration is returned.
    % An empty vendor value is returned in the case of an error.
    % An optional authentication method and profile name can be provided.
    %
    % Example:
    %   v = matlab.databricks.vendor.getVendorFromAPI()

    %  (c) 2024-2026 MathWorks, Inc.

    arguments
        options.authMethod (1,1) matlab.databricks.AuthMethod
        options.profileName string {mustBeTextScalar, mustBeNonzeroLengthText}
        options.verbose (1,1) logical = true
    end

    try
        args = matlab.utils.addArgs(options, ["authMethod", "profileName"]);
        uc = databricks.UnityCatalog(args{:});
        metastoreInfo = uc.metastoreSummary();
        if isa(metastoreInfo, "databricks.datastructures.unitycatalog.ErrorResponse")
            warning("GETVENDORFROMAPI:NOMETSTOREINFO", ...
                "Could not determine cloud platform vendor.");
            disp(metastoreInfo);
            vendor = matlab.databricks.vendor.Vendor.empty;
        else
            vendor = matlab.databricks.vendor.Vendor(metastoreInfo.cloud);
        end
    catch ME
        warning("GETVENDORFROMAPI:UNKNOWN", ...
                "Could not determine cloud platform vendor.\nMessage: %s\n", ME.message);
        vendor = matlab.databricks.vendor.Vendor.empty;
    end
end