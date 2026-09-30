classdef testClusterArgs < matlab.unittest.TestCase
    % testClusterArgs Test validity of cluster arguments
    % 
    % Many functions take an argument for either a cluster object or a
    % cluster id. This test checks that the validator is working properly.

    %  Copyright 2024 MathWorks, Inc.

    properties (TestParameter)
        ARGS = {...
            33, single(5), ...
            int64(4), int32(3:5), int16(999), ...
            uint64(4), uint32(3:5), uint16(999), ...
            [true, false], ...
            databricks.Object, ...
            }
    end
    methods (Test)
        function testClusterObjectArguments(testCase)
            CL_1 = databricks.Cluster();
            CL_2 = databricks.Cluster();

            % A single cluster should be ok.
            try
                test_func(cluster=CL_1);
            catch EX
                testCase.verifyTrue(false, 'Scalar cluster failed');
            end
            
            % Several clusters should fail
            CLS = [CL_1, CL_2];
            testCase.verifyError(@() test_func(cluster=CLS), 'DATABRICKS:CLUSTER_ARGUMENT_NON_SCALAR');
        end

        function testStringArguments(testCase)
            CL_1 = "id_1";
            CL_2 = "id_2";

            % A single cluster should be ok.
            try
                test_func(cluster=CL_1);
            catch EX
                testCase.verifyTrue(false, 'Scalar cluster string id failed');
            end
            
            % Several clusters should fail
            CLS = [CL_1, CL_2];
            testCase.verifyError(@() test_func(cluster=CLS), 'DATABRICKS:CLUSTER_ARGUMENT_NON_SCALAR');
        end

        function testCharArguments(testCase)
            CL_1 = 'id_1';
            CL_2 = CL_1';
            CL_3 = [CL_1; fliplr(CL_1)];

            % A single cluster should be ok.
            try
                test_func(cluster=CL_1);
            catch EX
                testCase.verifyTrue(false, 'Scalar cluster string id failed');
            end
            
            % Non-zero number of rows should fail
            testCase.verifyError(@() test_func(cluster=CL_2), 'DATABRICKS:CLUSTER_ARGUMENT_NON_SCALAR');
            % Non-zero number of rows should fail
            testCase.verifyError(@() test_func(cluster=CL_3), 'DATABRICKS:CLUSTER_ARGUMENT_NON_SCALAR');
        end

        function testOtherDatatypes(testCase, ARGS)
            
            testCase.verifyError(@() test_func(cluster=ARGS), 'DATABRICKS:CLUSTER_ARGUMENT_BAD_TYPE');
        end

        function testNoArguments(testCase)

            try
                test_func();
            catch EX
                testCase.verifyTrue(false, 'Not using an argument should work');                
            end
        end

        function testEmptyClusterObject(testCase)
            cl = databricks.Cluster.empty;
            testCase.verifyError(@() test_func(cluster=cl), 'DATABRICKS:CLUSTER_ARGUMENT_NON_SCALAR');
        end
        function testEmptyStrings(testCase)
            testCase.verifyError(@() test_func(cluster=""), 'DATABRICKS:CLUSTER_ARGUMENT_EMPTY_STRING');
            testCase.verifyError(@() test_func(cluster=string.empty), 'DATABRICKS:CLUSTER_ARGUMENT_NON_SCALAR');
        end
        function testEmptyChars(testCase)
            testCase.verifyError(@() test_func(cluster=''), 'DATABRICKS:CLUSTER_ARGUMENT_EMPTY_STRING');
            testCase.verifyError(@() test_func(cluster=char.empty), 'DATABRICKS:CLUSTER_ARGUMENT_EMPTY_STRING');
        end

    end
end %classdef

function ret = test_func(options)
    arguments
        options.cluster {databricks.internal.cluster.mustBeScalarClusterOrId}
    end

    if isfield(options, 'cluster')
        ret = options.cluster;
    else
        ret = [];
    end
end
