classdef UserAgentImpl < handle
    % USERAGENTIMPL User Agent class for Databricks SDK
    %
    % Example:
    %   ua = databricks.internal.sdk.UserAgentImpl();
    %
    % See also: https://github.com/databricks/databricks-sdk-py#user-agent-request-attribution

    % Copyright 2025-2026 The MathWorks, Inc.

    properties
        UserAgentPy
        Partner string
        Product string
        Version string
    end

    methods
        function obj = UserAgentImpl()
            % USERAGENT Constructor for UserAgentImpl class
            obj.UserAgentPy = py.importlib.import_module('databricks.sdk.useragent');
            % Configure by default
            obj.withPartner();
            obj.withProduct();
        end

        function obj = withPartner(obj, partner)
            % WITHPARTNER Set the partner for the User Agent
            arguments
                obj
                partner string {mustBeTextScalar, mustBeNonzeroLengthText} = "MathWorks"
            end
            obj.Partner = partner;
            obj.UserAgentPy.with_partner(partner)
        end

        function obj = withProduct(obj, options)
            % WITHPRODUCT Set the product and version for the User Agent
            arguments
                obj
                options.product string {mustBeTextScalar, mustBeNonzeroLengthText}
                options.version string {mustBeTextScalar, mustBeNonzeroLengthText}
            end

            % Value has the form: "24.1.0.2537033" for R2024a Update 1
            % Product is "MATLAB"
            if ~isfield(options, "product") || ~isfield(options, "version")
                w = weboptions;
                userAgentFields = split(w.UserAgent, " ");
                woProduct = string(userAgentFields{1});
                verFields = split(string(userAgentFields{2}), ".");
                % with_product version field must be a valid semantic version so
                % drop the last number
                woVersion = join(verFields(1:3), ".");
            end

            if isfield(options, "product")
                product = options.product;
            else
                product = woProduct;
            end

            if isfield(options, "version")
                version = options.version;
            else
                version = woVersion;
            end

            obj.Product = product;
            obj.Version = version;

            obj.UserAgentPy.with_product(product, version);
        end

        function pyObj = toPy(obj)
            % TOPY Convert UserAgent object to Python user agent object
            pyObj = obj.UserAgentPy;
        end
    end
end
