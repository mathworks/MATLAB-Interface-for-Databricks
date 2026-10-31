classdef testClusterPolicy < matlab.unittest.TestCase
    % TESTCLUSTERPOLICY Unit tests for the ClusterPolicy API


    % (c) 2022 MathWorks, Inc.


    properties
        cpName (1,1) string
        cpDef  (1,1) string
    end



    methods (TestMethodSetup)
        function cpSetup(testCase)
            testCase.cpName = sprintf('zzClusterPolicy-Test-%s', datestr(now,30)); %#ok<TNOW1,DATST>
            testCase.cpDef = ...
                '{"spark_conf.spark.databricks.cluster.profile":{"type":"forbidden","hidden":true}}';
        end
    end

    methods (Test)
        function testConstructor(testCase)
            dcp = databricks.ClusterPolicy;
            testCase.verifyClass(dcp, 'databricks.ClusterPolicy');
        end

        function testCreateDelete(testCase)

            cr = databricks.datastructures.clusterpolicy.CreateRequest();
            cr.name = testCase.cpName;
            cr.definition = testCase.cpDef;

            cp = databricks.ClusterPolicy;
            policyId1 = cp.create(cr);

            CP1 = cp.get(policyId1);
            testCase.verifyClass(CP1, 'databricks.datastructures.clusterpolicy.Policy');
            testCase.verifyEqual(CP1.policyId, policyId1);
            testCase.verifyEqual(CP1.name, testCase.cpName)

            CPS = cp.list();
            testCase.verifyClass(CPS, 'databricks.datastructures.clusterpolicy.ListResponse');
            testCase.verifyTrue(isprop(CPS, 'totalCount'))
            testCase.verifyGreaterThan(CPS.totalCount, 0);

            countOne = CPS.totalCount;

            cp.remove(CP1.policyId);

            CPS_2 = cp.list();
            countTwo = CPS_2.totalCount;
            testCase.verifyGreaterThan(countOne, countTwo);
        end

        function testEdit(testCase)
            cp = databricks.ClusterPolicy;
            cr = databricks.datastructures.clusterpolicy.CreateRequest();
            cr.name = testCase.cpName;
            cr.definition = testCase.cpDef;
            policyId = cp.create(cr);

            CP1 = cp.get(policyId);
            testCase.verifyClass(CP1, 'databricks.datastructures.clusterpolicy.Policy');
            testCase.verifyEqual(CP1.policyId, policyId);
            testCase.verifyEqual(CP1.name, testCase.cpName)

            newName = "XXX" + testCase.cpName;
            pur = databricks.datastructures.clusterpolicy.PolicyUpdateRequest();
            pur.policyId = CP1.policyId;
            pur.definition = testCase.cpDef;
            pur.name = newName;
            cp.edit(pur)
            CP2 = cp.get(policyId);
            testCase.verifyClass(CP2, 'databricks.datastructures.clusterpolicy.Policy');
            testCase.verifyEqual(CP2.policyId, CP1.policyId);
            testCase.verifyEqual(CP2.name, newName)

            % Delete it now
            cp.remove(CP2.policyId);
        end
    end
end
