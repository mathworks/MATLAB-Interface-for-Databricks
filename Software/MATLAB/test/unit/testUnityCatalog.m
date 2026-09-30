classdef testUnityCatalog < matlab.unittest.TestCase
    % TESTUNITYCATALOG Unit tests for UnityCatalog class. Unity Catalog is
    % an enterprise feature and will not work in a standard workspace.
    % Therefore in the MathWorks internal GITLAB_CI test environment a big
    % part of the tests is skipped.
    %
    % Tests in this file rely on the authentication being provided in the
    % form of a .databrickscfg file in the users home directory; it
    % should contain a valid personal access token.
    %
    % Tests rely on the Azure Enterprise Testing Environment with Unity
    % Catalog enabled. It expects catalog "main" with database "default" to
    % exist and it expects "managedaccess" External Location to exist.
    %
    % On Azure it relies on a storage account "databricksucext" with a
    % container "serviceprincipalaccess" on which an Azure AD App has Data
    % Contributor role configure the App through environment variables:
    %
    %   * SERVICEPRINCIPALACCESS_CLIENTSECRET
    %   * SERVICEPRINCIPALACCESS_CLIENTID
    %   * SERVICEPRINCIPALACCESS_DIRECTORYID

    % Copyright 2023-2025 The MathWorks, Inc.


    methods (Test)

        function testConstructor(testCase)
            % Verify the overall constructor works
            if verLessThan('matlab', '9.9') %#ok<*VERLESSMATLAB>
                fprintf("Unity Catalog requires MATLAB R2020b or later. Skipping test.\n");
                return;
            end
            uc = databricks.UnityCatalog();
            testCase.verifyClass(uc,?databricks.UnityCatalog);
        end

        function testDataStructures(testCase)
            % Verify that datastructures which can (also) be inputs can be
            % constructed and have a fromInputs methods and derive from
            % JSONMapper
            if verLessThan('matlab', '9.9')
                fprintf("Unity Catalog requires MATLAB R2020b or later. Skipping test.\n");
                return;
            end
            inputs = [ ...
                "R2TempCredentials", ...
                "AwsTempCredentials", ...
                "AzureUserDelegationSAS", ...
                "AzureADD", ...
                "ConnectionUpdateRequest", ...
                "AwsIamRole", ...
                "AzureServicePrincipal", ...
                "CatalogInfo", ...
                "ColumnInfo", ...
                "ExternalLocationInfo", ...
                "GcpServiceAccountKey", ...
                "IpAccessList", ...
                "KeyValuePair", ...
                "MetastoreAssignment", ...
                "MetastoreInfo", ...
                "Partition", ...
                "PartitionSpecification", ...
                "PartitionValues", ...
                "PermissionsChange", ...
                "PermissionsDiff", ...
                "PermissionsList", ...
                "PrivilegeAssignment", ...
                "ProviderInfo", ...
                "ProviderShare", ...
                "RecipientInfo", ...
                "RecipientProfile", ...
                "RecipientTokenInfo", ...
                "RotateRecipientToken", ...
                "SchemaInfo", ...
                "ShareDataObject", ...
                "ShareInfo", ...
                "ShareToPrivilegeAssignment", ...
                "StorageCredentialInfo",...
                "ObjectsChange",...
                "ObjectsDiff",...
                "AllowlistRequest",...
                "ArtifactMatchers",...
                "VolumeInfo"];
            for class = inputs
                instance = databricks.datastructures.unitycatalog.(class);
                testCase.verifyClass(instance,strcat('databricks.datastructures.unitycatalog.', class));
                testCase.verifyTrue(isa(instance,'JSONMapper'));
                testCase.verifyTrue(ismethod(instance,'fromInputs'),sprintf('%s lacks fromInputs',class));
            end
            % Verify that datastructures which are only outputs can be
            % constructed and derive from JSONMapper
            general = [ ...
                "GenTempColCredsResp", ...
                "ConnectionInfo", ...
                "ProvisioningInfo", ...
                "Connection", ...
                "ListConnectionsResp", ...
                "CatalogInfoList", ...
                "ErrorResponse", ...
                "ExternalLocationInfoList", ...
                "FileInfo", ...
                "GetMyGroupsResp", ...
                "GetMyInfoResp", ...
                "ListFilesResp", ...
                "MetastoreInfoList", ...
                "ProviderInfoList", ...
                "ProviderShareList", ...
                "RecipientInfoList", ...
                "SchemaInfoList", ...
                "ShareInfoList", ...
                "ShareToPrivilegeAssignmentList", ...
                "StorageCredentialInfoList", ...
                "TableInfo", ...
                "TableInfoList", ...
                "TableSummariesResp", ...
                "TableSummary", ...
                "GetArtifactAllowlistsResp", ...
                "SetArtifactAllowlistResp",...
                "ListVolumesResp"];

            for class = general
                instance = databricks.datastructures.unitycatalog.(class);
                testCase.verifyClass(instance,strcat('databricks.datastructures.unitycatalog.', class));
                testCase.verifyTrue(isa(instance,'JSONMapper'));
            end
            % Verify that datastructures which are enums derive from
            % JSONEnum
            enums = [...
                "Operation", ...
                "AuthenticationType", ...
                "ColumnTypeName", ...
                "DataSourceFormat", ...
                "DeltaSharingScope", ...
                "TableType",...
                "UpdateAction",...
                "ArtifactType",...
                "VolumeType",...
                "ConnectionType",...
                "CredentialType",...
                "ProvisioningState",...
                "SecurableType"...
                    ];

            for class = enums
                mc = meta.class.fromName(strcat('databricks.datastructures.unitycatalog.', class));
                testCase.verifyTrue(contains(mc.SuperclassList.Name,'JSONEnum'));
            end

            % Verify that all datastructures have been tested
            package = meta.package.fromName('databricks.datastructures.unitycatalog');
            classes = {package.ClassList.Name};
            classes = setxor(classes,strcat('databricks.datastructures.unitycatalog.',enums));
            classes = setxor(classes,strcat('databricks.datastructures.unitycatalog.',inputs));
            classes = setxor(classes,strcat('databricks.datastructures.unitycatalog.',general));
            testCase.verifyEmpty(classes,'databricks.datastructures.unitycatalog contains untested classes');
        end

        function testCatalogAndSchema(testCase)
            if verLessThan('matlab', '9.9')
                fprintf("Unity Catalog requires MATLAB R2020b or later. Skipping test.\n");
                return;
            end

            if ~isempty(getenv("GITLAB_CI")) && strcmpi(getenv("DATABRICKS_VENDOR"), "aws")
                fprintf("Creating catalogs is not enabled on AWS, Skipping test.\n");
                return;
            end

            % UnityCatalog Instance
            uc = databricks.UnityCatalog;
            % Generate random catalog name for test
            catalogName = sprintf('unittestcatalog-%s',char(java.util.UUID.randomUUID));

            % Create
            c1 = uc.createCatalog(databricks.datastructures.unitycatalog.CatalogInfo.fromInputs('name',catalogName));
            % Verify class, non-empty and name
            testCase.verifyClass(c1,?databricks.datastructures.unitycatalog.CatalogInfo);
            testCase.verifyNotEmpty(c1);
            testCase.verifyEqual(c1.name,string(catalogName));

            % Get
            c2 = uc.getCatalog(catalogName);
            % Verify class, non-empty and equal to what had been created
            testCase.verifyClass(c2,?databricks.datastructures.unitycatalog.CatalogInfo);
            testCase.verifyNotEmpty(c2);
            testCase.verifyEqual(c1,c2);

            % Update
            comment = string(java.util.UUID.randomUUID);
            c3 = uc.updateCatalog(catalogName,databricks.datastructures.unitycatalog.CatalogInfo.fromInputs('comment',comment));
            testCase.verifyClass(c3,?databricks.datastructures.unitycatalog.CatalogInfo);
            testCase.verifyNotEmpty(c3);
            testCase.verifyEqual(c3.comment,comment);

            % List
            c4 = uc.listCatalogs;
            % Verify class, non-empty and non-empty list
            testCase.verifyClass(c4,?databricks.datastructures.unitycatalog.CatalogInfoList);
            testCase.verifyNotEmpty(c4);
            testCase.verifyNotEmpty(c4.catalogs);

            % Schema create
            schemaName = sprintf('unittestschema-%s',char(java.util.UUID.randomUUID));
            schemaFullName = sprintf('%s.%s',catalogName,schemaName);
            s1 = uc.createSchema(databricks.datastructures.unitycatalog.SchemaInfo.fromInputs('name',schemaName,'catalog_name',catalogName));
            testCase.verifyClass(s1,?databricks.datastructures.unitycatalog.SchemaInfo);
            testCase.verifyNotEmpty(s1);
            testCase.verifyEqual(s1.name,string(schemaName));
            testCase.verifyEqual(s1.full_name,string(schemaFullName));
            % Schema Get
            s2 = uc.getSchema(schemaFullName);
            testCase.verifyClass(s2,?databricks.datastructures.unitycatalog.SchemaInfo);
            testCase.verifyNotEmpty(s2);
            % Schema Update
            s3 = uc.updateSchema(schemaFullName,databricks.datastructures.unitycatalog.SchemaInfo.fromInputs('comment',comment));
            testCase.verifyClass(s3,?databricks.datastructures.unitycatalog.SchemaInfo);
            testCase.verifyNotEmpty(s3);
            testCase.verifyEqual(s3.comment,comment);
            % Schema list
            s4 = uc.listSchemas(catalogName);
            testCase.verifyClass(s4,?databricks.datastructures.unitycatalog.SchemaInfoList);
            testCase.verifyNotEmpty(s4);
            testCase.verifyNotEmpty(s4.schemas);
            % Schema delete
            tf = uc.deleteSchema(schemaFullName);
            testCase.verifyTrue(tf);

            % Delete
            % First need to delete default schema
            tf = uc.deleteSchema([catalogName '.default']);
            testCase.verifyTrue(tf);
            % Then the catalog
            tf = uc.deleteCatalog(catalogName);
            testCase.verifyTrue(tf);
        end

        function testMetastore(testCase) %#ok<MANU>
            if verLessThan('matlab', '9.9')
                fprintf("Unity Catalog requires MATLAB R2020b or later. Skipping test.\n");
                return;
            end

            fprintf("Disabling testUnityCatalog/testMetastore as requires account admin rights\n");
            return;

            % UnityCatalog Instance
            uc = databricks.UnityCatalog; %#ok<UNRCH>

            % Metastore Get
            ms1 = uc.getMetastore('3ce438d4-321c-49ec-9ac1-613acb9c0be3'); % enterprise-testing-uc
            testCase.verifyClass(ms1,?databricks.datastructures.unitycatalog.MetastoreInfo);
            testCase.verifyNotEmpty(ms1);
            testCase.verifyEqual(ms1.name,"enterprise-testing-uc");

            % Metastore list
            ms2 = uc.listMetastores();
            testCase.verifyClass(ms2,?databricks.datastructures.unitycatalog.MetastoreInfoList);
            testCase.verifyNotEmpty(ms2);
            testCase.verifyNotEmpty(ms2.metastores);

            % For now, not testing creating metastores nor deleting. And
            % especially not meta store assignments. We can only have one
            % Unity Catalog on our subscription and these operations are
            % too intrusive on the Databricks instance and we don't have a
            % separate environment to test this on.
        end

        function testCredentialsAndExternalLocation(testCase)
            if isempty(getenv('SERVICEPRINCIPALACCESS_DIRECTORYID')) || ...
                    isempty(getenv('SERVICEPRINCIPALACCESS_CLIENTID')) || ...
                    isempty(getenv('SERVICEPRINCIPALACCESS_CLIENTSECRET'))
                fprintf('Azure credential varaibles not configured. Skipping test.\n');

                return;
            end          
            if verLessThan('matlab', '9.9')
                fprintf("Unity Catalog requires MATLAB R2020b or later. Skipping test.\n");
                return;
            end

            % UnityCatalog Instance
            uc = databricks.UnityCatalog;

            % Set secrets when running local
            if exist('UnityCatalogStorageCredentials','file')==2
                UnityCatalogStorageCredentials;
            end

            % Generate name
            storageCredentialName = sprintf('unittestcredential-%s',char(java.util.UUID.randomUUID));
            % StorageCredential Create
            sci = databricks.datastructures.unitycatalog.StorageCredentialInfo;
            sci.name = storageCredentialName;
            sci.azure_service_principal(1).directory_id = getenv('SERVICEPRINCIPALACCESS_DIRECTORYID');
            sci.azure_service_principal(1).application_id = getenv('SERVICEPRINCIPALACCESS_CLIENTID');
            sci.azure_service_principal(1).client_secret = getenv('SERVICEPRINCIPALACCESS_CLIENTSECRET');
            sc1 = uc.createStorageCredential(sci);
            testCase.verifyClass(sc1,?databricks.datastructures.unitycatalog.StorageCredentialInfo);
            testCase.verifyNotEmpty(sc1);
            testCase.verifyEqual(sc1.name,string(storageCredentialName));
            % StorageCredential Get
            sc2 = uc.getStorageCredential(storageCredentialName);
            testCase.verifyClass(sc2,?databricks.datastructures.unitycatalog.StorageCredentialInfo);
            testCase.verifyNotEmpty(sc2);
            testCase.verifyEqual(sc1,sc2);
            % StorageCredential Update
            comment = string(java.util.UUID.randomUUID);
            sc3 = uc.updateStorageCredential(storageCredentialName, databricks.datastructures.unitycatalog.StorageCredentialInfo.fromInputs('comment',comment));
            testCase.verifyClass(sc3,?databricks.datastructures.unitycatalog.StorageCredentialInfo);
            testCase.verifyNotEmpty(sc3);
            testCase.verifyEqual(sc3.comment,comment);

            % StorageCredential List
            sc4 = uc.listStorageCredentials();
            testCase.verifyClass(sc4,?databricks.datastructures.unitycatalog.StorageCredentialInfoList);
            testCase.verifyNotEmpty(sc4);
            testCase.verifyNotEmpty(sc4.storage_credentials);


            % Generate name
            externalLocationName = sprintf('unittestextloc-%s',char(java.util.UUID.randomUUID));
            % ExternalLocation Create
            el1 = uc.createExternalLocation(databricks.datastructures.unitycatalog.ExternalLocationInfo.fromInputs(...
                "name",externalLocationName, ...
                "credential_name",storageCredentialName, ...
                "url",'abfss://serviceprincipalaccess@databricksucext.dfs.core.windows.net'));
            testCase.verifyClass(el1,?databricks.datastructures.unitycatalog.ExternalLocationInfo);
            testCase.verifyNotEmpty(el1);
            testCase.verifyEqual(el1.name,string(externalLocationName));

            % ExternalLocation Get
            el2 = uc.getExternalLocation(externalLocationName);
            testCase.verifyClass(el2,?databricks.datastructures.unitycatalog.ExternalLocationInfo);
            testCase.verifyNotEmpty(el2);
            testCase.verifyEqual(el1,el2);

            % ExternalLocation Update
            el3 = uc.updateExternalLocation(externalLocationName, databricks.datastructures.unitycatalog.ExternalLocationInfo.fromInputs("comment",comment));
            testCase.verifyClass(el3,?databricks.datastructures.unitycatalog.ExternalLocationInfo);
            testCase.verifyNotEmpty(el3);
            testCase.verifyEqual(el3.comment,comment);

            % ExternalLocation List
            el4 = uc.listExternalLocations();
            testCase.verifyClass(el4,?databricks.datastructures.unitycatalog.ExternalLocationInfoList);
            testCase.verifyNotEmpty(el4);
            testCase.verifyNotEmpty(el4.external_locations);

            % Files List
            fl = uc.listFiles('abfss://serviceprincipalaccess@databricksucext.dfs.core.windows.net');
            testCase.verifyClass(fl,?databricks.datastructures.unitycatalog.ListFilesResp);
            testCase.verifySize(fl.files,[1,2]);

            % ExternalLocation Delete
            tf = uc.deleteExternalLocation(externalLocationName);
            testCase.verifyTrue(tf);

            % StorageCredential Delete
            tf = uc.deleteStorageCredential(storageCredentialName);
            testCase.verifyTrue(tf);
        end

        function testTable(testCase)
            if verLessThan('matlab', '9.9')
                fprintf("Unity Catalog requires MATLAB R2020b or later. Skipping test.\n");
                return;
            end
            % UnityCatalog Instance
            uc = databricks.UnityCatalog;

            % Needs SQL Warehouse to create a table
            swh = databricks.SQLWarehouse.list;
            if isempty(swh)
                fprintf('No SQL Warehouse found, cannot create tables, skip tests.\n');
                return
            end
            swh = swh(1);
            conn = swh.connect();
            % Create a table
            tableName = sprintf('unittesttable_%s',strrep(char(java.util.UUID.randomUUID),'-','_'));
            tableFullName = sprintf('main.default.%s',tableName);
            query = sprintf('CREATE TABLE %s (col1 INT, col2 STRING)',tableFullName);
            r = conn.exec(query);
            testCase.assertEmpty(r.Message)

            query = sprintf("INSERT INTO %s VALUES (1,'foo'),(2,'bar')",tableFullName);
            r = conn.exec(query);
            testCase.assertEmpty(r.Message)

            % Table Get
            t1 = uc.getTable(tableFullName);
            testCase.verifyClass(t1,?databricks.datastructures.unitycatalog.TableInfo);
            testCase.verifyEqual(t1.name,string(tableName));
            testCase.verifyEqual(t1.full_name,string(tableFullName));

            % Table List
            t2 = uc.listTables('main','default');
            testCase.verifyClass(t2,?databricks.datastructures.unitycatalog.TableInfoList);
            testCase.verifyNotEmpty(t2);
            testCase.verifyNotEmpty(t2.tables);

            % Table Summary List
            t3 = uc.listTableSummaries('main','schema_name_pattern','d%','table_name_pattern','unittesttable_%');
            testCase.verifyClass(t3,?databricks.datastructures.unitycatalog.TableSummariesResp);
            testCase.verifyNotEmpty(t3);
            testCase.verifyNotEmpty(t3.tables);

            % Permissions
            p1 = uc.getPermissions("table",tableFullName);
            testCase.verifyClass(p1,?databricks.datastructures.unitycatalog.PermissionsList);
            testCase.verifyNotEmpty(p1);
            % Initially should be empty
            testCase.verifyEmpty(p1.privilege_assignments);
            % Then set
            pd = databricks.datastructures.unitycatalog.PermissionsDiff;
            pd.changes(1).principal = 'account users';
            pd.changes(1).add = ["SELECT","MODIFY"];
            p2 = uc.updatePermissions("table",tableFullName,pd);
            testCase.verifyClass(p2,?databricks.datastructures.unitycatalog.PermissionsList);
            testCase.verifyNotEmpty(p2);
            testCase.verifyNotEmpty(p2.privilege_assignments);
            % Now there should be 2
            testCase.verifySize(p2.privilege_assignments.privileges,[2,1]);

            % setPermissions appears to be unimplemented from DB end
            % pl = databricks.datastructures.unitycatalog.PermissionsList;
            % pl.privilege_assignments(1).principal = 'account users';
            % pl.privilege_assignments(1).privileges = 'SELECT';
            % uc.setPermissions("table",tableFullName,pl);

            % Table delete
            tf = uc.deleteTable(tableFullName);
            testCase.verifyTrue(tf);
        end

        function testUserInfo(testCase)
            if verLessThan('matlab', '9.9')
                fprintf("Unity Catalog requires MATLAB R2020b or later. Skipping test.\n");
                return;
            end

            % UnityCatalog Instance
            uc = databricks.UnityCatalog;
            info = uc.getMyInfo();
            testCase.verifyClass(info,?databricks.datastructures.unitycatalog.GetMyInfoResp);
            testCase.verifyNotEmpty(info);

            ginfo = uc.getMyGroups();
            testCase.verifyClass(ginfo,?databricks.datastructures.unitycatalog.GetMyGroupsResp);
            testCase.verifyNotEmpty(ginfo);
            testCase.verifyNotEmpty(ginfo.group_names);

        end

        function testDatabricksSharing(testCase)
            if verLessThan('matlab', '9.9')
                fprintf("Unity Catalog requires MATLAB R2020b or later. Skipping test.\n");
                return;
            end

            if ~isempty(getenv("GITLAB_CI")) && strcmpi(getenv("DATABRICKS_VENDOR"), "aws")
                fprintf("Creating catalogs is not enabled on AWS, Skipping test.\n");
                return;
            end
            
            % UnityCatalog Instance
            uc = databricks.UnityCatalog;

            providerName = "azure:northeurope:3ce438d4-321c-49ec-9ac1-613acb9c0be3";
            friendlyProviderName = "appdeploypftazuredatabricks";

            % Recipient create - share with ourselves
            recipientName = sprintf('unittestrecipient-%s',char(java.util.UUID.randomUUID));

            % Make sure there's not a remnant object with the same sharing
            % identifier
            rcps=uc.listRecipients();
            rcps = rcps.recipients;
            rcpsToDeleteIdx = find(arrayfun(@(x) isequal(providerName, x.data_recipient_global_metastore_id), rcps));
            if ~isempty(rcpsToDeleteIdx)
                for ri = 1:numel(rcpsToDeleteIdx)
                    uc.deleteRecipient(rcps(rcpsToDeleteIdx(ri)).name);
                end
            end

            r1 = uc.createRecipient(databricks.datastructures.unitycatalog.RecipientInfo.fromInputs( ...
                "name",recipientName,"authentication_type","DATABRICKS", ...
                "data_recipient_global_metastore_id",providerName));
            testCase.verifyClass(r1,?databricks.datastructures.unitycatalog.RecipientInfo);
            testCase.verifyNotEmpty(r1);
            testCase.verifyEqual(r1.name,string(recipientName));

            % Recipient get
            r2 = uc.getRecipient(recipientName);
            testCase.verifyClass(r2,?databricks.datastructures.unitycatalog.RecipientInfo);
            testCase.verifyNotEmpty(r2);
            testCase.verifyEqual(r1,r2);

            % Recipient update
            comment = string(java.util.UUID.randomUUID);
            r3 = uc.updateRecipient(recipientName,databricks.datastructures.unitycatalog.RecipientInfo.fromInputs("comment",comment));
            testCase.verifyClass(r3,?databricks.datastructures.unitycatalog.RecipientInfo);
            testCase.verifyNotEmpty(r3);
            testCase.verifyEqual(r3.comment,comment);

            % Recipient list
            r4 = uc.listRecipients();
            testCase.verifyClass(r4,?databricks.datastructures.unitycatalog.RecipientInfoList);
            testCase.verifyNotEmpty(r4);
            testCase.verifyNotEmpty(r4.recipients);

            % Share Create
            shareName = sprintf('unittestshare-%s',char(java.util.UUID.randomUUID));
            s1 = uc.createShare(databricks.datastructures.unitycatalog.ShareInfo.fromInputs("name",shareName));
            testCase.verifyClass(s1,?databricks.datastructures.unitycatalog.ShareInfo);
            testCase.verifyNotEmpty(s1);
            testCase.verifyEqual(s1.name,string(shareName));

            %Share get
            s2 = uc.getShare(shareName);
            testCase.verifyClass(s2,?databricks.datastructures.unitycatalog.ShareInfo);
            testCase.verifyNotEmpty(s2);
            testCase.verifyEqual(s1,s2);

            % Share Update
            % Standard Comment Test
            s3 = uc.updateShare(shareName,databricks.datastructures.unitycatalog.ShareInfo.fromInputs("comment",comment));
            testCase.verifyClass(s3,?databricks.datastructures.unitycatalog.ShareInfo);
            testCase.verifyNotEmpty(s3);
            testCase.verifyEqual(s3.comment,comment);

            % Also update objects now to actually share something

            % According to documentation you'd expect this to work as
            % follows, but it doesn't

            % si = databricks.datastructures.unitycatalog.ShareInfo;
            % si.objects(1).name = "main.default.department";
            % si.objects(1).data_object_type = "TABLE";
            % si.objects(1).shared_as = "default.department";
            % s3 = uc.updateShare(shareName,si);
            % testCase.verifyClass(s3,?databricks.datastructures.unitycatalog.ShareInfo);
            % testCase.verifyNotEmpty(s3);
            % testCase.verifyNotEmpty(s3.objects);

            % CSV for main.default.department table
            %   deptcode,deptname,location
            %   10,FINANCE,EDINBURGH
            %   20,SOFTWARE,PADDINGTON
            %   30,SALES,MAIDSTONE
            %   40,MARKETING,DARLINGTON
            %   50,ADMIN,BIRMINGHAM


            % We need the following instead
            sc = databricks.datastructures.unitycatalog.ObjectsDiff;
            sc.name = shareName;
            sc.updates(1).action = "ADD";
            sc.updates(1).data_object(1).name = "main.default.department";
            s3 = uc.updateShareObjects(shareName,sc);
            testCase.verifyClass(s3,?databricks.datastructures.unitycatalog.ShareInfo);
            testCase.verifyNotEmpty(s3);
            testCase.verifyNotEmpty(s3.objects);

            % Get shares list for provider, should initially be empty
            sh1 = uc.listProviderShares(friendlyProviderName);
            testCase.verifyClass(sh1,?databricks.datastructures.unitycatalog.ProviderShareList);
            testCase.verifyNotEmpty(sh1);
            testCase.verifyEmpty(sh1.shares);

            % Now also grant our recipient permissions on the share
            pd = databricks.datastructures.unitycatalog.PermissionsDiff;
            pd.changes(1).principal = recipientName;
            pd.changes(1).add(1) = "SELECT";
            pl = uc.updateSharePermissions(shareName,pd);
            testCase.verifyClass(pl,?databricks.datastructures.unitycatalog.PermissionsList);

            % Share Permissions Get
            shp = uc.getSharePermissions(shareName);
            testCase.verifyClass(shp,?databricks.datastructures.unitycatalog.PermissionsList);
            testCase.verifyNotEmpty(shp);
            testCase.verifyNotEmpty(shp.privilege_assignments);

            % After having added the recipient, there now should be a share
            sh2 = uc.listProviderShares(friendlyProviderName);
            testCase.verifyClass(sh2,?databricks.datastructures.unitycatalog.ProviderShareList);
            testCase.verifyNotEmpty(sh2);
            testCase.verifyNotEmpty(sh2.shares);

            % getRecipientSharePermissions
            p = uc.getRecipientSharePermissions(recipientName);
            testCase.verifyClass(p,?databricks.datastructures.unitycatalog.ShareToPrivilegeAssignmentList)
            testCase.verifyNotEmpty(p)
            testCase.verifyNotEmpty(p.permissions_out)

            % Share List
            s4 = uc.listShares();
            testCase.verifyClass(s4,?databricks.datastructures.unitycatalog.ShareInfoList);
            testCase.verifyNotEmpty(s4);
            testCase.verifyNotEmpty(s4.shares);

            % Having shared with ourselves we should also have gotten a
            % provider, get it
            p1 = uc.getProvider(friendlyProviderName);
            testCase.verifyClass(p1,?databricks.datastructures.unitycatalog.ProviderInfo);
            testCase.verifyNotEmpty(p1);

            % Provider list
            p2 = uc.listProviders();
            testCase.verifyClass(p2,?databricks.datastructures.unitycatalog.ProviderInfoList);
            testCase.verifyNotEmpty(p2);
            testCase.verifyNotEmpty(p2.providers);

            % Create a catalog based on the share
            sharedCatalogName = sprintf('unittestsharedcatalog-%s',char(java.util.UUID.randomUUID));
            c1 = uc.createCatalog(databricks.datastructures.unitycatalog.CatalogInfo.fromInputs( ...
                "name",sharedCatalogName,"provider_name",friendlyProviderName,"share_name",shareName));
            testCase.verifyClass(c1,?databricks.datastructures.unitycatalog.CatalogInfo);
            testCase.verifyNotEmpty(c1);
            testCase.verifyEqual(c1.name,string(sharedCatalogName));

            % Catalog delete
            tf = uc.deleteCatalog(sharedCatalogName);
            testCase.verifyTrue(tf);

            % Provider delete
            tf = uc.deleteProvider(friendlyProviderName);
            testCase.verifyTrue(tf);

            % Share Delete
            tf = uc.deleteShare(shareName);
            testCase.verifyTrue(tf);

            % Recipient delete
            tf = uc.deleteRecipient(recipientName);
            testCase.verifyTrue(tf);
        end

        function testExternalSharing(testCase)
            if verLessThan('matlab', '9.9')
                fprintf("Unity Catalog requires MATLAB R2020b or later. Skipping test.\n");
                return;
            end

            % UnityCatalog Instance
            uc = databricks.UnityCatalog;

            % Provider Create
            providerName = sprintf('unittestprovider-%s',char(java.util.UUID.randomUUID));
            e = datetime('now','TimeZone','UTC','Format','yyyy-MM-dd''T''HH:mm:ss.SZ') + hours(1);
            s = struct( ...
                'shareCredentialsVersion', 1, ...
                'endpoint', 'https://sharing.delta.io/delta-sharing/',...
                'bearerToken', char(java.util.UUID.randomUUID),...
                'expirationTime', e);

            pi1 = uc.createProvider(databricks.datastructures.unitycatalog.ProviderInfo.fromInputs( ...
                'name',providerName, ...
                'authentication_type','TOKEN', ...
                'recipient_profile_str',jsonencode(s)));

            testCase.verifyClass(pi1,?databricks.datastructures.unitycatalog.ProviderInfo);
            testCase.verifyNotEmpty(pi1);
            testCase.verifyEqual(pi1.name,string(providerName));

            % Provider Get
            pi2 = uc.getProvider(providerName);
            testCase.verifyClass(pi2,?databricks.datastructures.unitycatalog.ProviderInfo);
            testCase.verifyNotEmpty(pi2);
            testCase.verifyEqual(pi1,pi2);

            % Provider Update
            comment = string(java.util.UUID.randomUUID);
            pi3 = uc.updateProvider(providerName,databricks.datastructures.unitycatalog.ProviderInfo.fromInputs('comment',comment));
            testCase.verifyClass(pi3,?databricks.datastructures.unitycatalog.ProviderInfo);
            testCase.verifyNotEmpty(pi3);
            testCase.verifyEqual(pi3.comment,comment);

            % Provider List
            pi4 = uc.listProviders();
            testCase.verifyClass(pi4,?databricks.datastructures.unitycatalog.ProviderInfoList);
            testCase.verifyNotEmpty(pi4);
            testCase.verifyNotEmpty(pi4.providers);

            % Provider delete
            tf = uc.deleteProvider(providerName);
            testCase.verifyTrue(tf);

            % Recipient create
            recipientName = sprintf('unittestrecipient-%s',char(java.util.UUID.randomUUID));
            ri1 = uc.createRecipient(databricks.datastructures.unitycatalog.RecipientInfo.fromInputs( ...
                "name",recipientName,"authentication_type","TOKEN"));
            testCase.verifyClass(ri1,?databricks.datastructures.unitycatalog.RecipientInfo);
            testCase.verifyNotEmpty(ri1);
            testCase.verifyEqual(ri1.name,string(recipientName));

            % Recipient Get
            ri2 = uc.getRecipient(recipientName);
            testCase.verifyClass(ri2,?databricks.datastructures.unitycatalog.RecipientInfo);
            testCase.verifyNotEmpty(ri2);
            testCase.verifyEqual(ri1,ri2);

            % Recipient Update
            ri3 = uc.updateRecipient(recipientName,databricks.datastructures.unitycatalog.RecipientInfo.fromInputs('comment',comment));
            testCase.verifyClass(ri3,?databricks.datastructures.unitycatalog.RecipientInfo);
            testCase.verifyNotEmpty(ri3);
            testCase.verifyEqual(ri3.comment,comment);

            % Recipient List
            ri4 = uc.listRecipients();
            testCase.verifyClass(ri4,?databricks.datastructures.unitycatalog.RecipientInfoList);
            testCase.verifyNotEmpty(ri4);
            testCase.verifyNotEmpty(ri4.recipients);

            % Rotate token
            ri5 = uc.rotateRecipientToken(recipientName,databricks.datastructures.unitycatalog.RotateRecipientToken.fromInputs('existing_token_expire_in_seconds',0));
            testCase.verifyClass(ri5,?databricks.datastructures.unitycatalog.RecipientInfo);
            testCase.verifyNotEmpty(ri5);
            % Verify token did indeed change
            testCase.verifyNotEqual(ri3.tokens.id,ri5.tokens.id);

            % Recipient Delete
            tf = uc.deleteRecipient(recipientName);
            testCase.verifyTrue(tf);
        end

        function testVolumes(testCase)
            % UnityCatalog Instance
            uc = databricks.UnityCatalog;
            catalog_name = "main";
            schema_name = "default";

            % List existing volumes
            vols = uc.listVolumes(catalog_name, schema_name);
            testCase.verifyClass(vols,?databricks.datastructures.unitycatalog.ListVolumesResp);
            testCase.verifyGreaterThan(numel(vols.volumes), 0);
            % check the 1st entry is of the expected type
            testCase.verifyClass(vols.volumes(1),?databricks.datastructures.unitycatalog.VolumeInfo);
            % Get that 1st volume and check its type
            getV = uc.getVolume(vols.volumes(1).full_name);
            testCase.verifyClass(getV,?databricks.datastructures.unitycatalog.VolumeInfo);
            
            % Create a volume name and use the job id if in CI to avoid
            % name clashes, this volume should get deleted
            ciId = getenv("CI_JOB_ID");
            if isempty(ciId) || strlength(ciId) == 0
                ciId = "0";
            end
            volName = "restapiunittestvolume" + ciId;
            volFullname = catalog_name + "." + schema_name + "." + volName;
            
            % check for the volume
            getV = uc.getVolume(volFullname);
            testCase.verifyClass(getV,?databricks.datastructures.unitycatalog.VolumeInfo);
            if ~isempty(getV)
                % If it exists delete it and check that
                result = uc.deleteVolume(volFullname);
                testCase.verifyTrue(result);
                getV = uc.getVolume(volFullname);
                testCase.verifyClass(getV,?databricks.datastructures.unitycatalog.VolumeInfo);
                testCase.verifyEmpty(getV)
            end

            % Create a volume using the above name
            comment1 = "My unit test comment - this volume can be deleted";
            comment2 = "My updated unit test comment - this volume can be deleted";
            result = uc.createVolume(catalog_name, schema_name, volName, databricks.datastructures.unitycatalog.VolumeType.MANAGED, "", comment1);
            testCase.verifyClass(result,?databricks.datastructures.unitycatalog.VolumeInfo);
            
            % Update the comment on the volume
            vi = databricks.datastructures.unitycatalog.VolumeInfo();
            vi.comment = comment2;
            result = uc.updateVolume(volFullname, vi);
            testCase.verifyClass(result,?databricks.datastructures.unitycatalog.VolumeInfo);
            testCase.verifyEqual(result.comment, comment2);
            getV = uc.getVolume(volFullname);
            testCase.verifyEqual(getV.comment, comment2);
            
            % delete the volume
            result = uc.deleteVolume(volFullname);
            testCase.verifyTrue(result);
            getV = uc.getVolume(volFullname);
            testCase.verifyClass(getV,?databricks.datastructures.unitycatalog.VolumeInfo);
            testCase.verifyEmpty(getV);
        end

        function testConnections(testCase)
            % UnityConnections Instance
            uc = databricks.UnityCatalog;
           
            % List existing connections
            conns = uc.listConnections();
            testCase.verifyClass(conns,?databricks.datastructures.unitycatalog.Connection);            
            
            % Create a connection
            uuid = string(matlab.lang.internal.uuid());
            connectionInfo =  databricks.datastructures.unitycatalog.ConnectionInfo();
            connectionInfo.connection_type = databricks.datastructures.unitycatalog.ConnectionType.HTTP;
            connectionInfo.name = "my_connection_" + uuid;
            connectionInfo.comment = "test connection example.com";
            connectionInfo.options = JSONMapperMap( ...
                "host", "https://example.com", ...
                "port", "443", ...
                "bearer_token", "abcdefgh", ...
                "is_mcp_connection", "false", ...
                "base_path", "/my/base/path/");
            connectionInfo.read_only = false;
            result = uc.createConnection(connectionInfo);
            testCase.verifyClass(result,?databricks.datastructures.unitycatalog.Connection)

            % (Re)List existing connections
            conns = uc.listConnections();
            testCase.verifyClass(conns,?databricks.datastructures.unitycatalog.Connection);
            
            testCase.verifyGreaterThan(numel(conns), 0);
            % check the 1st entry is of the expected type
            testCase.verifyClass(conns(1),?databricks.datastructures.unitycatalog.Connection);

            % Get a connection
            conn = uc.getConnection(connectionInfo.name);
            testCase.verifyClass(conn,?databricks.datastructures.unitycatalog.Connection);
            testCase.verifyEqual(conn.comment, connectionInfo.comment);
            testCase.verifyEqual(conn.name, connectionInfo.name);
            testCase.verifyEqual(conn.connection_type, databricks.datastructures.unitycatalog.ConnectionType.HTTP);

            % Update a connection
            connectionUpdateRequest = databricks.datastructures.unitycatalog.ConnectionUpdateRequest();
            connectionUpdateRequest.new_name = "my_new_connection_name_" + uuid;
            connectionUpdateRequest.options = JSONMapperMap("host", "https://new.example.com", "bearer_token", "abcdefgh");
            result = uc.updateConnection(conn.name, connectionUpdateRequest);
            testCase.verifyEqual(result.name, connectionUpdateRequest.new_name);

            % Delete a connection
            testCase.verifyTrue(uc.deleteConnection(result.name));
        end
    end
end
