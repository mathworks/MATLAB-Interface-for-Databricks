function vendor = getVendorFromCfgHost(options)
    % GETVENDORFROMCFGHOST Returns vendor based on the cfg file host value
    %
    % Returns a matlab.databricks.vendor.Vendor enumeration.
    % If no value is defined an empty matlab.databricks.vendor.Vendor enumeration
    % value is returned.
    %
    % Example
    %   v = matlab.databricks.vendor.getVendorFromCfgHost();

    %  (c) 2024 MathWorks, Inc.

    arguments
        options.profileName string {mustBeTextScalar, mustBeNonzeroLengthText}
        options.verbose (1,1) logical = true
    end

    args = matlab.utils.addArgs(options, "profileName");
    cfgHost = string(databricks.internal.configurationprofile.ConfigFile.getProfileField("host", args{:}));

    if isempty(cfgHost) || ~isscalar(cfgHost) || strlength(cfgHost)==0
        vendor = matlab.databricks.vendor.Vendor.empty;
        if options.verbose
            fprintf(2, "Invalid host file in configuration file.\n");
        end
    else
        vendor = matlab.databricks.vendor.getVendorFromHost(cfgHost);
    end
end