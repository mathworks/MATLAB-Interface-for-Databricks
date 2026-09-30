classdef testSQLWarehouse < matlab.unittest.TestCase
    % TESTSQLWarehouse Unit tests for SQLWarehouse class. SQL warehouses are
    % an enterprise feature and will not work in a standard workspace.
    % Therefore in the MathWorks internal GITLAB_CI test environment a big
    % part of the tests is skipped.
    %
    % Tests in this file rely on the authentication being provided in the
    % form of a .databrickscfg file in the users home directory; it
    % should contain a valid personal access token (while supported by the
    % SQLWarehouse class, Azure AD authentication is currently not tested).

    %  (c) 2022-2025 MathWorks, Inc.

    methods (TestMethodSetup)
        function testSetup(testCase) %#ok<MANU>
        end
    end

    methods (TestMethodTeardown)
        function testTearDown(testCase) %#ok<MANU>
        end
    end

    methods (TestClassTeardown)
        function testClassTeardown(~)
            % On Class Teardown do try to get a list of Warehouses, go
            % through it and if the UNITTESTWarehouse exists at this point
            % (which should not be the case, but perhaps something
            % unexpected happened), delete it.
            try
                l = databricks.SQLWarehouse.list();
                for i=1:length(l)
                    if l(i).name == "UNITTESTWarehouse"
                        disp 'UNITTESTWarehouse Warehouse found unexpectedly at end of tests, deleting it.'
                        l(i).remove
                    end
                end
            catch

            end
        end
    end

    methods (Test)
        function testConstructor(testCase)
            disp('Running testSQLWarehouse/testConstructor');
            % Verify class
            Warehouse = databricks.SQLWarehouse;
            testCase.verifyClass(Warehouse,?databricks.SQLWarehouse);
            % Verify that all properties are initially empty
            p = properties(Warehouse);
            for i = 1:length(p)
                testCase.verifyEmpty(Warehouse.(p{i}));
            end
        end

        function testErrors(testCase)
            disp('Running testSQLWarehouse/testErrors');
            % Create instance
            Warehouse = databricks.SQLWarehouse;
            testCase.verifyClass(Warehouse,?databricks.SQLWarehouse);
            % Verify that refresh, start, stop, remove and connect throw
            % errors if id has not been set.
            testCase.verifyError(@()Warehouse.refresh,'DATABRICKS:ERROR');
            testCase.verifyError(@()Warehouse.start,'DATABRICKS:ERROR');
            testCase.verifyError(@()Warehouse.stop,'DATABRICKS:ERROR');
            testCase.verifyError(@()Warehouse.remove,'DATABRICKS:ERROR');
            testCase.verifyError(@()Warehouse.connect,'DATABRICKS:ERROR');
            % testCase.verifyError(@()Warehouse.connect,'MATLAB:validators:mustBeMemberGenericText');
            % testCase.verifyError(@()Warehouse.connect,'MATLAB:string:MustBeCharCellArrayOrString');


        end

        function testFullWorkflow(testCase)
            disp('Running testSQLWarehouse/testFullWorkflow');


            % Start with list
            l = databricks.SQLWarehouse.list();
            testCase.verifyClass(l,?databricks.SQLWarehouse);

            % Remember number of Warehouses
            initialNumWarehouses = length(l);

            whName = "UNITTESTWarehouse" + string(matlab.lang.internal.uuid());
            % Create the test Warehouse
            Warehouse = databricks.SQLWarehouse;
            % Configure the simplest cheapest Warehouse
            Warehouse.name = whName;
            Warehouse.cluster_size = "2X-Small";
            Warehouse.min_num_clusters = 1;
            Warehouse.max_num_clusters = 1;

            % Use serverless compute to speedup
            Warehouse.enable_serverless_compute = true;
            % Create it
            Warehouse.create();

            % Verify that it is in starting state now
            testCase.verifyEqual(Warehouse.state,databricks.datastructures.WarehouseState.STARTING);
            % And that ID has been filled out
            testCase.verifyNotEmpty(Warehouse.id);

            % Verify that list now indeed returns more items than before
            newNumWarehouses = length(databricks.SQLWarehouse.list);
            testCase.verifyGreaterThan(newNumWarehouses,initialNumWarehouses);

            % Check some other expected defaults
            testCase.verifyEqual(Warehouse.name, whName);
            testCase.verifyEqual(Warehouse.warehouse_type, databricks.datastructures.WarehouseType.PRO);
            testCase.verifyEqual(Warehouse.spot_instance_policy, databricks.datastructures.WarehouseSpotInstancePolicy.COST_OPTIMIZED);
            testCase.verifyTrue(Warehouse.enable_photon);
            testCase.verifyTrue(Warehouse.enable_serverless_compute);

            % Wait for Warehouse to start (with a 7 minute timeout)
            timeout = 7 * 60;
            fprintf('Waiting for Warehouse to start...');
            t = tic;
            while (Warehouse.state == databricks.datastructures.WarehouseState.STARTING) && (toc(t) < timeout)
                pause(5);
                fprintf('.');
                Warehouse.refresh
            end
            fprintf('done\n');
            % Verify that this has indeed succeeded and not timed out
            testCase.verifyLessThan(toc(t),timeout,'Warehouse start timed out');
            % Verify that the Warehouse is indeed running now
            testCase.verifyEqual(Warehouse.state,databricks.datastructures.WarehouseState.RUNNING);

            % Verify JDBC succeeds
            conn = Warehouse.connect();
            if ~isempty(conn.Message)
                fprintf("conn.Message: %s\n", conn.Message);
            end

            testCase.verifyEmpty(conn.Message);
            clear conn

            % Test STOP
            Warehouse.stop;
            testCase.verifyNotEqual(Warehouse.state,databricks.datastructures.WarehouseState.RUNNING);

            % Test START
            Warehouse.start;
            % Verify that it is in starting state now
            testCase.verifyEqual(Warehouse.state,databricks.datastructures.WarehouseState.STARTING);

            % Do not wait for the Warehouse to actually start this time,
            % deleting can also be done while it was in starting state

            % Test REMOVE
            Warehouse.remove;
            pause(1);
            try
                Warehouse.refresh
                testCase.verifyFail("Expected refresh to fail after remove but unexpectedly succeeded.");
            catch ME
                testCase.verifyEqual(ME.body.error_code,'RESOURCE_DOES_NOT_EXIST');
            end

            % Verify that list now indeed returns less Warehouses again
            testCase.verifyLessThan(length(databricks.SQLWarehouse.list),newNumWarehouses);
        end

        function testChannel(testCase)
            disp('Running testSQLWarehouse/testChannel');
            c = databricks.datastructures.Channel;
            testCase.verifyClass(c, 'databricks.datastructures.Channel');
            testCase.verifyClass(c.dbsql_version, 'string');
            testCase.verifyClass(c.name, 'databricks.datastructures.ChannelName');

            n = databricks.datastructures.ChannelName.CHANNEL_NAME_UNSPECIFIED;
            testCase.verifyClass(n, 'databricks.datastructures.ChannelName');
            n = databricks.datastructures.ChannelName.CHANNEL_NAME_PREVIEW;
            testCase.verifyClass(n, 'databricks.datastructures.ChannelName');
            n = databricks.datastructures.ChannelName.CHANNEL_NAME_CURRENT;
            testCase.verifyClass(n, 'databricks.datastructures.ChannelName');
            n = databricks.datastructures.ChannelName.CHANNEL_NAME_PREVIOUS;
            testCase.verifyClass(n, 'databricks.datastructures.ChannelName');
            n = databricks.datastructures.ChannelName.CHANNEL_NAME_CUSTOM;
            testCase.verifyClass(n, 'databricks.datastructures.ChannelName');

            c.name = databricks.datastructures.ChannelName.CHANNEL_NAME_UNSPECIFIED;
            testCase.verifyEqual(c.name, databricks.datastructures.ChannelName.CHANNEL_NAME_UNSPECIFIED);
            c.dbsql_version = "my dbsql_version string";
            testCase.verifyEqual(c.dbsql_version, "my dbsql_version string");
        end

        function testWarehouseType(testCase)
            disp('Running testSQLWarehouse/testWarehouseType');
            n = databricks.datastructures.WarehouseType.PRO;
            testCase.verifyClass(n, 'databricks.datastructures.WarehouseType');
            n = databricks.datastructures.WarehouseType.CLASSIC;
            testCase.verifyClass(n, 'databricks.datastructures.WarehouseType');
            n = databricks.datastructures.WarehouseType.TYPE_UNSPECIFIED;
            testCase.verifyClass(n, 'databricks.datastructures.WarehouseType');
        end

        function testWarehouseSpotInstancePolicy(testCase)
            disp('Running testSQLWarehouse/testWarehouseSpotInstancePolicy');
            n = databricks.datastructures.WarehouseSpotInstancePolicy.POLICY_UNSPECIFIED;
            testCase.verifyClass(n, 'databricks.datastructures.WarehouseSpotInstancePolicy');
            n = databricks.datastructures.WarehouseSpotInstancePolicy.COST_OPTIMIZED;
            testCase.verifyClass(n, 'databricks.datastructures.WarehouseSpotInstancePolicy');
            n = databricks.datastructures.WarehouseSpotInstancePolicy.RELIABILITY_OPTIMIZED;
            testCase.verifyClass(n, 'databricks.datastructures.WarehouseSpotInstancePolicy');
        end

    end % methods

end % class
