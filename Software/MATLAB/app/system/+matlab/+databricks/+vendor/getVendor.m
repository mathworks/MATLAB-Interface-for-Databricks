function vendor = getVendor(options)
    % GETVENDOR Get a Vendor value using a provider chain approach
    %
    % A matlab.databricks.vendor.Vendor enumeration is returned. If a value
    % cannot be determined an empty matlab.databricks.vendor.Vendor is returned.
    % This first non empty value is returned and further checks are skipped.
    %
    % Host values should start with: https://
    %
    % The function will try to determine a vendor in the order using subject to
    % the associated "try" flag.
    %
    % 1. If an optional named argument host is provided.
    %
    % 2. Check the DATABRICKS_VENDOR environment variable.
    %
    % 3. Check the databrcks-settings.json file, this options should not be used
    %    during setup. An existing vendor value is used if set.
    %
    % 4. The .databrickscfg file host value will be used.
    %
    % 5. The databricks.Cluster REST API will be used, requiring authentication
    %    using the optional authMethod and profileName arguments.
    %
    % 6. Finally a value will be interactively requested from the user.
    %    This is mainly intended for use during setup and will require interactive
    %    input.
    %
    % Example
    %   v = matlab.databricks.vendor.getVendor()

    %  (c) 2024 MathWorks, Inc.

    arguments
        options.tryHostArgument (1,1) logical = true
        options.tryEnvironment (1,1) logical = true
        options.tryVendorSettings (1,1) logical = true
        options.tryHostCfg (1,1) logical = true
        options.tryRESTAPI (1,1) logical = true
        options.tryUser (1,1) logical = false
        options.host string {mustBeTextScalar, mustBeNonzeroLengthText}
        options.settingsFile string {mustBeTextScalar, mustBeNonzeroLengthText}
        options.authMethod (1,1) matlab.databricks.AuthMethod
        options.profileName string {mustBeTextScalar, mustBeNonzeroLengthText}
        options.verbose (1,1) logical = true
    end

    vendor = matlab.databricks.vendor.Vendor.empty;

    if options.tryHostArgument && isfield(options, "host")
        vendor = matlab.databricks.vendor.getVendorFromHost(host=options.host);
        if ~isempty(vendor)
            return;
        end
    end
    if options.tryEnvironment
        vendor = matlab.databricks.vendor.getVendorFromEnvironment(verbose=options.verbose);
        if ~isempty(vendor)
            return;
        end
    end
    if options.tryVendorSettings
        args = matlab.utils.addArgs(options, "settingsFile");
        vendor = matlab.databricks.vendor.getVendorFromSettings(args{:});
        if ~isempty(vendor)
            return;
        end
    end
    if options.tryHostCfg
        args = matlab.utils.addArgs(options, ["profileName", "verbose"]);
        vendor = matlab.databricks.vendor.getVendorFromCfgHost(args{:});
        if ~isempty(vendor)
            return;
        end
    end
    if options.tryRESTAPI
        args = matlab.utils.addArgs(options, ["authMethod", "profileName", "verbose"]);
        vendor = matlab.databricks.vendor.getVendorFromAPI(args{:});
        if ~isempty(vendor)
            return;
        end
    end
    if options.tryUser
        vendor = matlab.databricks.vendor.userRequestVendor();
        if ~isempty(vendor)
            return;
        end
    end
end
