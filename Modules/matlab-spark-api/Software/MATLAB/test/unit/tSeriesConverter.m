classdef tSeriesConverter < matlab.unittest.TestCase

% Copyright 2026 The MathWorks, Inc.

    properties (TestParameter)
        NumericType = {"int8", "int16", "int32", "int64", "single", "double"}
    end

    methods (Test)

        function timeUnit(testCase)
            import compiler.build.spark.converters.TimeUnit

            s = TimeUnit.Seconds;
            testCase.verifyEqual(s.ticksPerSecond(), 1);

            ms = TimeUnit.Milliseconds;
            testCase.verifyEqual(ms.ticksPerSecond(), 1e3);

            us = TimeUnit.Microseconds;
            testCase.verifyEqual(us.ticksPerSecond(), 1e6);

            ns = TimeUnit.Nanoseconds;
            testCase.verifyEqual(ns.ticksPerSecond(), 1e9);
        end

        function testPrimitiveSeriesConverterForNumerics(testCase, NumericType)
            import compiler.build.spark.converters.PrimitiveSeriesConverter

            data = cast([1 2 3 4 5], NumericType);
            converter = PrimitiveSeriesConverter();

            actual1 = converter.toMATLAB(data);
            expected1 = reshape(data, [], 1);
            testCase.verifyEqual(actual1, expected1);

            actual2 = converter.fromMATLAB(actual1);
            testCase.verifyEqual(actual2, data);
        end

        function testStringSeriesConverter(testCase)
            import compiler.build.spark.converters.StringSeriesConverter
            data = {'dog', 'cat', 'whale'};
            converter = StringSeriesConverter();

            actual1 = converter.toMATLAB(data);
            expected = ["dog"; "cat"; "whale"];
            testCase.verifyEqual(actual1, expected);

            actual2 = converter.fromMATLAB(actual1);
            expected2 = ["dog" "cat" "whale"];
            testCase.verifyEqual(actual2, expected2);
        end

        function testPrimitiveSeriesConverterForLogical(testCase)
            import compiler.build.spark.converters.PrimitiveSeriesConverter

            data = [true true false false true false false];
            converter = PrimitiveSeriesConverter();

            actual1 = converter.toMATLAB(data);
            expected1 = reshape(data, [], 1);
            testCase.verifyEqual(actual1, expected1);

            actual2 = converter.fromMATLAB(actual1);
            testCase.verifyEqual(actual2, data);
        end

        function testTimestampSeriesConverter(testCase)
            import compiler.build.spark.converters.TimestampSeriesConverter

            expected = reshape(datetime(2026, 03, 24) + days(0:1), [], 1);

            data1 = struct(TimeUnit="ns", TimeData=int64([1.7743104e+18 1.7743968e+18]));
            unit = compiler.build.spark.converters.TimeUnit.Nanoseconds;
            converter = TimestampSeriesConverter(unit);
            actual1 = converter.toMATLAB(data1);
            testCase.verifyEqual(actual1, expected);

            actual2 = converter.fromMATLAB(actual1);
            testCase.verifyEqual(actual2, data1);

            data2 = struct(TimeUnit="us", TimeData=int64([1.7743104e+15 1.7743968e+15]));
            unit = compiler.build.spark.converters.TimeUnit.Microseconds;
            converter = TimestampSeriesConverter(unit);
            actual3 = converter.toMATLAB(data2);
            testCase.verifyEqual(actual3, expected);

            actual4 = converter.fromMATLAB(actual3);
            testCase.verifyEqual(actual4, data2);
        end

        function testDateSeriesConverter(testCase)
            import compiler.build.spark.converters.DateSeriesConverter

            data = int64([739700 739701 739702]);
            converter = DateSeriesConverter();            
            actual1 = converter.toMATLAB(data);
            expected2 = datetime(2026, 3, 25) + days(0:2)';
            testCase.verifyEqual(actual1, expected2);

            actual2 = converter.fromMATLAB(actual1);
            testCase.verifyEqual(actual2, data);
        end

        function testTimedeltaSeriesConverter(testCase)
            import compiler.build.spark.converters.TimedeltaSeriesConverter

            timeData = int64([100011100 20243534550000]);

            data1 = struct(TimeUnit="ns", TimeData=timeData);
            expected1 = seconds([0.1000111; 20243.53455]);
            unit = compiler.build.spark.converters.TimeUnit.Nanoseconds;
            converter = TimedeltaSeriesConverter(unit);
            actual7 = converter.toMATLAB(data1);
            testCase.verifyEqual(actual7, expected1);
            actual2 = converter.fromMATLAB(actual7);
            testCase.verifyEqual(actual2, data1);

            data2 = struct(TimeUnit="us", TimeData=timeData);
            expected2 = seconds([100.0111; 20243534.55]);
            unit = compiler.build.spark.converters.TimeUnit.Microseconds;
            converter = TimedeltaSeriesConverter(unit);
            actual3 = converter.toMATLAB(data2);
            testCase.verifyEqual(actual3, expected2);
            actual4 = converter.fromMATLAB(actual3);
            testCase.verifyEqual(actual4, data2);

            data3 = struct(TimeUnit="ms", TimeData=timeData);
            expected3 = milliseconds([100011100; 20243534550000]);
            unit = compiler.build.spark.converters.TimeUnit.Milliseconds;
            converter = TimedeltaSeriesConverter(unit);
            actual5 = converter.toMATLAB(data3);
            testCase.verifyEqual(actual5, expected3);
            actual6 = converter.fromMATLAB(actual5);
            testCase.verifyEqual(actual6, data3);

            data4 = struct(TimeUnit="s", TimeData=timeData);
            expected4 = seconds([100011100; 20243534550000]);
            unit = compiler.build.spark.converters.TimeUnit.Seconds;
            converter = TimedeltaSeriesConverter(unit);
            actual7 = converter.toMATLAB(data4);
            testCase.verifyEqual(actual7, expected4);
            actual8 = converter.fromMATLAB(actual7);
            testCase.verifyEqual(actual8, data4);
        end

        function testBinarySeriesConverter(testCase)
            import compiler.build.spark.converters.BinarySeriesConverter

            bytes = unicode2native("Hello World!", "UTF-8");
            lengths = int64([4 2 0 6]);
            
            data.Bytes = bytes;
            data.Lengths = lengths;

            converter = BinarySeriesConverter();

            actual1 = converter.toMATLAB(data);
            expected1 = {...
                uint8([72 101 108 108]);...
                uint8([111 32]);...
                uint8.empty(1, 0);...
                uint8([87 111 114 108 100 33])...
            };

            testCase.verifyEqual(actual1, expected1);

            actual2 = converter.fromMATLAB(actual1);
            testCase.verifyEqual(actual2, data);
        end

        function testArraySeriesConverter(testCase)
            import compiler.build.spark.converters.PrimitiveSeriesConverter
            import compiler.build.spark.converters.ArraySeriesConverter

            data.Data = 1:10;
            data.Lengths = int64([2 3 4 0 1]);

            converter = ArraySeriesConverter(PrimitiveSeriesConverter());
            expected1 = {[1 2]; [3 4 5]; [6 7 8 9]; double.empty(1, 0); 10};
            actual1 = converter.toMATLAB(data);
            testCase.verifyEqual(actual1, expected1);

            actual2 = converter.fromMATLAB(actual1);
            testCase.verifyEqual(actual2, data);
        end

        function testStructSeriesConverter(testCase)
            import compiler.build.spark.converters.*

            fieldData1 = struct(TimeUnit="s", TimeData=int64(1:10));
            fieldData2 = arrayfun(@(val) char(val), 65:74, UniformOutput=false);
            fieldData3 = struct(Data=1:20, Lengths=int64(repmat(2, [1 10])));

            innerFieldData1 = struct(Bytes=uint8(1:30), Lengths=int64(repmat(3, [1 10])));
            innerFieldData2 = struct(TimeUnit="s", TimeData=int64(10022400:86400:10800000));
            fieldData4 = {innerFieldData1, innerFieldData2};

            unit = compiler.build.spark.converters.TimeUnit.Seconds;
            
            structField1 = StructField("A", TimedeltaSeriesConverter(unit));
            structField2 = StructField("B", StringSeriesConverter());
            structField3 = StructField("C", ArraySeriesConverter(PrimitiveSeriesConverter()));

            innerStructField1 = StructField("E", BinarySeriesConverter());
            innerStructField2 = StructField("F", TimestampSeriesConverter(unit));
            structField4 = StructField("D", StructSeriesConverter([innerStructField1, innerStructField2]));

            structFields = [structField1, structField2, structField3 structField4];
            converter = StructSeriesConverter(structFields);

            data = {fieldData1, fieldData2, fieldData3, fieldData4};
            actual = converter.toMATLAB(data);

            fieldAValues = seconds(1:10);
            fieldBValues = string(fieldData2);
            fieldCValues = num2cell(reshape(fieldData3.Data, 2, 10)', 2)';

            innerField1Values = num2cell(reshape(innerFieldData1.Bytes, 3, 10)', 2)';
            innerField2Values = datetime(1970, 4, 27) + days(0:9);
            fieldDValues = struct(E=innerField1Values, F=num2cell(innerField2Values));

            expected = struct( ...
                A=num2cell(fieldAValues), ...
                B=num2cell(fieldBValues), ...
                C=fieldCValues, ...
                D=num2cell(fieldDValues) ...
            );
            expected = reshape(expected, [], 1);
            testCase.verifyEqual(actual, expected);

            actual2 = converter.fromMATLAB(actual);
            expected2 = {fieldData1, string(fieldData2), fieldData3, fieldData4};
            testCase.verifyEqual(actual2, expected2);
        end

        function testMapSeriesConverter(testCase)
            import compiler.build.spark.converters.TimedeltaSeriesConverter
            import compiler.build.spark.converters.StringSeriesConverter
            import compiler.build.spark.converters.MapSeriesConverter

            mapData = struct(...
                NumKeyValuePairs=int64([3 5 2]),...
                ValueData=struct(TimeUnit="s", TimeData=int64(1:10)),...
                KeyData={arrayfun(@(val) char(val), 65:74, UniformOutput=false)}...
            );

            unit = compiler.build.spark.converters.TimeUnit.Seconds;
            valueConverter = TimedeltaSeriesConverter(unit);
            keyConverter = StringSeriesConverter();
            
            converter = MapSeriesConverter(keyConverter, valueConverter);

            actual = converter.toMATLAB(mapData);

            expected = {...
                dictionary(["A" "B" "C"], seconds([1 2 3]));...
                dictionary(["D" "E" "F" "G" "H"], seconds([4 5 6 7 8]));...
                dictionary(["I" "J"], seconds([9 10]));...
            };

            testCase.verifyEqual(actual, expected);
            actual2 = converter.fromMATLAB(expected);

            expected2 = mapData;
            expected2.KeyData = string(expected2.KeyData);

            testCase.verifyEqual(actual2, expected2);

        end

    end

end