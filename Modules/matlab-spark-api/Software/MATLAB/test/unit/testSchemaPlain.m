classdef testSchemaPlain < matlab.unittest.TestCase
    % testSchemaPlain Test Schema functions, no Spark session

    % Copyright 2025 MathWorks, Inc.

    methods (Test)
        function testDayTimeIntervalType1(testCase)
            t = compiler.build.spark.schema.DayTimeIntervalType();
            testCase.verifyTrue(t.startField=="DAY");
            testCase.verifyTrue(t.endField=="SECOND");
        end

        function testDayTimeIntervalType2(testCase)
            t = compiler.build.spark.schema.DayTimeIntervalType(1);
            testCase.verifyTrue(t.startField=="HOUR");
            testCase.verifyTrue(t.endField=="SECOND");
        end

        function testDayTimeIntervalType3(testCase)
            t = compiler.build.spark.schema.DayTimeIntervalType('minute');
            testCase.verifyTrue(t.startField=="MINUTE");
            testCase.verifyTrue(t.endField=="SECOND");
        end

        function testDayTimeIntervalType4(testCase)
            t = compiler.build.spark.schema.DayTimeIntervalType('hOuR',2);
            testCase.verifyTrue(t.startField=="HOUR");
            testCase.verifyTrue(t.endField=="MINUTE");
        end

        function testDayTimeIntervalType5(testCase)
            t = compiler.build.spark.schema.DayTimeIntervalType(0,'miNUte');
            testCase.verifyTrue(t.startField=="DAY");
            testCase.verifyTrue(t.endField=="MINUTE");
        end

        function testDayTimeIntervalType6(testCase)
            t = compiler.build.spark.schema.DayTimeIntervalType('interval hour to minute');
            testCase.verifyTrue(t.startField=="HOUR");
            testCase.verifyTrue(t.endField=="MINUTE");
        end

        % Should fail
        function testDayTimeIntervalType7(testCase)
            ft = @() compiler.build.spark.schema.DayTimeIntervalType('MINUTE', 'HOUR');
            testCase.assertError(ft, 'SPARKAPI:bad_interval_definition');
        end

        function testDayTimeIntervalType8(testCase)
            ft = @() compiler.build.spark.schema.DayTimeIntervalType(3, 2);
            testCase.assertError(ft, 'SPARKAPI:bad_interval_definition');
        end

        function testDayTimeIntervalType9(testCase)
            ft = @() compiler.build.spark.schema.DayTimeIntervalType('interval minute to hour');
            testCase.assertError(ft, 'SPARKAPI:bad_interval_definition');
        end

        function testArray1(testCase)
            % A simple test for a normal table
            id = int64(1:5)';
            a1 = arrayfun(@(x) 100*rand(1, randi(5)), id, 'UniformOutput',false);
            T = table(id, a1);
            S = compiler.build.spark.schema.DataType.createSchema(T);
            testCase.assertClass(S, 'compiler.build.spark.schema.StructType');
            testCase.assertLength(S.fields, 2);
            testCase.assertClass(S.fields(1).dataType, 'compiler.build.spark.schema.LongType')
            testCase.assertClass(S.fields(2).dataType, 'compiler.build.spark.schema.ArrayType')
            testCase.assertClass(S.fields(2).dataType.elementType, 'compiler.build.spark.schema.DoubleType')
        end

        function testArray2(testCase)
            % A special case to catch a nested structure with an array.
            % In this case, the first element in the column will actually
            % be an array, so it's an easy check.
            N = 5;
            id = int64(1:N)';
            a = cell(N, 1);
            for k=1:N
                s(k) = struct('Name', string(char(k+64)) + k, ...
                    'Arr', 100*rand(1,1+randi(5)));
                a{k} = 10*rand(1, 1+randi(3));
            end
            s = s(:);
            T = table(id, a, s);
            S = compiler.build.spark.schema.DataType.createSchema(T);
            
            testCase.assertClass(S, 'compiler.build.spark.schema.StructType');
            testCase.assertLength(S.fields, 3);
            
            testCase.assertClass(S.fields(1).dataType, 'compiler.build.spark.schema.LongType')

            testCase.assertClass(S.fields(2).dataType, 'compiler.build.spark.schema.ArrayType')
            testCase.assertClass(S.fields(2).dataType.elementType, 'compiler.build.spark.schema.DoubleType')
            
            testCase.assertClass(S.fields(3).dataType, 'compiler.build.spark.schema.StructType')
            testCase.assertLength(S.fields(3).dataType.fields, 2);
            testCase.assertClass(S.fields(3).dataType.fields(1).dataType, 'compiler.build.spark.schema.StringType')
            testCase.assertClass(S.fields(3).dataType.fields(2).dataType, 'compiler.build.spark.schema.ArrayType')
        end

        function testArray3(testCase)
            % A special case to catch a nested structure with an array.
            % In this case, the first element in the column will actually
            % be an array, so it's an easy check.
            % This should be like testArray3, but values start arrays with
            % scalar.
            N = 5;
            id = int64(1:N)';
            a = cell(N, 1);
            for k=1:N
                s1(k) = struct('Name', string(char(k+64)) + k, ...
                    'Arr', 100*rand(1,1+randi(5)));
                s2(k) = struct('Name', string(char(k+64)) + k, ...
                    'Arr', (1:k)*rand(1));
                a{k} = (1:k)*rand(1);
            end
            s1 = s1(:);
            s2 = s2(:);
            T = table(id, a, s1, s2);
            S = compiler.build.spark.schema.DataType.createSchema(T);
            
            testCase.assertClass(S, 'compiler.build.spark.schema.StructType');
            testCase.assertLength(S.fields, 4);
            
            testCase.assertClass(S.fields(1).dataType, 'compiler.build.spark.schema.LongType')

            testCase.assertClass(S.fields(2).dataType, 'compiler.build.spark.schema.ArrayType')
            testCase.assertClass(S.fields(2).dataType.elementType, 'compiler.build.spark.schema.DoubleType')
            
            testCase.assertClass(S.fields(3).dataType, 'compiler.build.spark.schema.StructType')
            testCase.assertLength(S.fields(3).dataType.fields, 2);
            testCase.assertClass(S.fields(3).dataType.fields(1).dataType, 'compiler.build.spark.schema.StringType')
            testCase.assertClass(S.fields(3).dataType.fields(2).dataType, 'compiler.build.spark.schema.ArrayType')

            testCase.assertClass(S.fields(4).dataType, 'compiler.build.spark.schema.StructType')
            testCase.assertLength(S.fields(4).dataType.fields, 2);
            testCase.assertClass(S.fields(4).dataType.fields(1).dataType, 'compiler.build.spark.schema.StringType')
            testCase.assertClass(S.fields(4).dataType.fields(2).dataType, 'compiler.build.spark.schema.ArrayType')

            testCase.assertEqual(S.fields(3).dataType.json(), S.fields(4).dataType.json());
        end

    end
end

