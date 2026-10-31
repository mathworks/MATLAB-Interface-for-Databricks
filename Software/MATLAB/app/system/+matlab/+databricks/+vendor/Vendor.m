classdef Vendor
    % Vendor Supported public Cloud Vendors
    % Google/CGP is not currently supported.

    % Copyright 2024-2026 The MathWorks, Inc.

    properties(SetAccess = immutable)
        vendorImpl matlab.internal.databricks.vendor.Vendor;
    end

    enumeration
        % Amazon Web Services
        AWS (matlab.internal.databricks.vendor.Vendor.AWS)
        % Microsoft Azure
        AZURE (matlab.internal.databricks.vendor.Vendor.AZURE)
    end

    methods
        function obj = Vendor(internalEnum)
            obj.vendorImpl = internalEnum;
        end
    end
end