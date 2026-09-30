classdef UnityCatalog < databricks.Object
% UNITYCATALOG MATLAB Class for interacting with the Databricks Unity
% Catalog Management API as documented on:
%
%   https://api-docs.databricks.com/rest/latest/unity-catalog-api-specification-2-1.html
%
% UnityCatalog Methods:
%
%   createCatalog                - Creates a new catalog.
%   createExternalLocation       - Creates a new external location.
%   createMetastore              - Creates a new metastore.
%   createMetastoreAssignment    - Creates meta store assignments.
%   createProvider               - Creates a delta sharing provider.
%   createRecipient              - Creates a new delta sharing recipient.
%   createSchema                 - Creates a new schema.
%   createShare                  - Creates new delta sharing share.
%   createStorageCredential      - Creates a new storage credential.
%   deleteCatalog                - Deletes a catalog. 
%   deleteExternalLocation       - Deletes an external location.
%   deleteMetastore              - Deletes a metastore.
%   deleteMetastoreAssignment    - Deletes a metastore assignment.
%   deleteProvider               - Deletes a delta sharing provider.
%   deleteRecipient              - Deletes a delta sharing recipient.
%   deleteSchema                 - Deletes a schema.
%   deleteShare                  - Deletes delta sharing share.
%   deleteStorageCredential      - Deletes a storage credential.
%   deleteTable                  - Deletes a table.
%   getArtifactAllowlists        - Gets the artifact allowlist of a certain artifact type.
%   getCatalog                   - Gets catalog information.
%   getExternalLocation          - Gets external location information.
%   getMetastore                 - Gets metastore information.
%   getMyGroups                  - Gets group membership information of the user.
%   getMyInfo                    - Retrieves current user information as it relates to Unity Catalog.
%   getPermissions               - Gets permissions as set for a given object.
%   getProvider                  - Gets delta sharing provider information.
%   getRecipient                 - Gets delta sharing recipient information.
%   getRecipientSharePermissions - Gets permissions for the given delta.
%   getSchema                    - Gets schema information.
%   getShare                     - Gets delta sharing share information.
%   getSharePermissions          - Gets permissions of specified delta sharing share.
%   getStorageCredential         - Gets storage credential information.
%   getTable                     - Gets table information.
%   listCatalogs                 - Gets list of catalogs.
%   listExternalLocations        - Gets list of external locations.
%   listFiles                    - List files in an external URL.
%   listMetastores               - Lists metastores.
%   listProviders                - Lists delta sharing providers.
%   listProviderShares           - Lists delta sharing shares for a given provider.
%   listRecipients               - Lists delta sharing recipients.
%   listSchemas                  - Lists schemas in a given catalog.
%   listShares                   - Lists delta sharing shares.
%   listStorageCredentials       - Lists storage credentials.
%   listTables                   - Lists tables in a given catalog and schema.
%   listTableSummaries           - Lists high level table information for tables in a given catalog.
%   rotateRecipientToken         - Rotates the token for an external recipient.
%   setArtifactAllowlist         - Set the artifact allowlist of a certain artifact type.
%   updateCatalog                - Updates catalog settings.
%   updateExternalLocation       - Updates external location settings.
%   updateMetastore              - Updates metastore settings.
%   updateMetastoreAssignment    - Updates metastore assignment on a given workspace.
%   updatePermissions            - Updates permissions on a given object.
%   updateProvider               - Updates delta sharing provider settings.
%   updateRecipient              - Updates delta sharing recipient settings.
%   updateSchema                 - Updates schema settings.
%   updateShare                  - Updates delta sharing share settings.
%   updateShareObjects           - Updates objects on a given delta sharing share.
%   updateSharePermissions       - Updates permissions on a delta sharing share.
%   updateStorageCredential      - Updates store credential settings.


% Copyright 2022-2026 The MathWorks, Inc.

    properties (Hidden)
        HTTPOptions matlab.net.http.HTTPOptions
    end

    methods
        function obj = UnityCatalog(varargin)
            % Unity Catalog Constructor

            if verLessThan('matlab', '9.9')
                error("DATABRICKS:UNITYCATALOG","Unity Catalog requires MATLAB R2020b or later");
            end

            obj.Version = '2.1';
            obj.HTTPOptions = databricks.internal.getHTTPOptions(convertResponse=false);
            obj.getAuth(varargin{:});
        end
    end
end
