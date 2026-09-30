classdef tMakeConverter < matlab.unittest.TestCase
%TMAKECONVERTER Contains unit tests for matlab.arrow.internal.makeConverter

% Copyright 2026 The MathWorks, Inc.

    properties (TestParameter)
        IntegerType
        FloatType
        TimestampType
        StringType
        DurationType
        BinaryType
        ListType
    end

    methods (TestParameterDefinition, Static)
        function IntegerType = initializeIntegerTypeTestParameter()
            pa = py.importlib.import_module("pyarrow");
            
            S = struct();

            S.Int8 = struct(Type=pa.int8(), ExpectedNumericType="int8", ExpectedStorageSize=1);
            S.Int16 = struct(Type=pa.int16(), ExpectedNumericType="int16", ExpectedStorageSize=2);
            S.Int32 = struct(Type=pa.int32(), ExpectedNumericType="int32", ExpectedStorageSize=4);
            S.Int64 = struct(Type=pa.int64(), ExpectedNumericType="int64", ExpectedStorageSize=8);

            S.UInt8 = struct(Type=pa.uint8(), ExpectedNumericType="uint8", ExpectedStorageSize=1);
            S.UInt16 = struct(Type=pa.uint16(), ExpectedNumericType="uint16", ExpectedStorageSize=2);
            S.UInt32 = struct(Type=pa.uint32(), ExpectedNumericType="uint32", ExpectedStorageSize=4);
            S.UInt64 = struct(Type=pa.uint64(), ExpectedNumericType="uint64", ExpectedStorageSize=8);

            IntegerType = S;
        end

        function FloatType = initializeFloatTypeTestParameter()
            pa = py.importlib.import_module("pyarrow");
            
            S = struct();

            S.Float32 = struct(Type=pa.float32(), ExpectedNumericType="single", ExpectedStorageSize=4);
            S.Float64 = struct(Type=pa.float64(), ExpectedNumericType="double", ExpectedStorageSize=8);

            FloatType = S;
        end

        function TimestampType = initializeTimestmapTypeTestParameter()
            pa = py.importlib.import_module("pyarrow");
            
            S = struct();

            S.NaiveSeconds = struct(Type=pa.timestamp('s'), ExpectedTicksPerSecond=1, ExpectedTimeZone="");
            S.NaiveMilli = struct(Type=pa.timestamp('ms'), ExpectedTicksPerSecond=1e3, ExpectedTimeZone="");
            S.NaiveMicro = struct(Type=pa.timestamp('us'), ExpectedTicksPerSecond=1e6, ExpectedTimeZone="");
            S.NaiveNano = struct(Type=pa.timestamp('ns'), ExpectedTicksPerSecond=1e9, ExpectedTimeZone="");

            S.AwareSeconds = struct(Type=pa.timestamp('s', pyargs("tz", 'UTC')), ExpectedTicksPerSecond=1, ExpectedTimeZone="UTC");
            S.AwareMilli = struct(Type=pa.timestamp('ms', pyargs("tz", 'UTC')), ExpectedTicksPerSecond=1e3, ExpectedTimeZone="UTC");
            S.AwareMicro = struct(Type=pa.timestamp('us', pyargs("tz", 'UTC')), ExpectedTicksPerSecond=1e6, ExpectedTimeZone="UTC");
            S.AwareNano = struct(Type=pa.timestamp('ns', pyargs("tz", 'UTC')), ExpectedTicksPerSecond=1e9, ExpectedTimeZone="UTC");

            TimestampType = S;
        end
    
        function StringType = initializeStringTypeTestParameter()
            pa = py.importlib.import_module("pyarrow");
            
            S = struct();

            S.String = struct(Type=pa.string(), ExpectedOffsetType="int32", ExpectedOffsetSize=4);
            S.LargeString = struct(Type=pa.large_string(), ExpectedOffsetType="int64", ExpectedOffsetSize=8);

            StringType = S;
        end
    
        function DurationType = initializeDurationTypeTestParameter()
            pa = py.importlib.import_module("pyarrow");
            
            S = struct();

            S.Seconds = struct(Type=pa.duration('s'), TicksPerSecond=1);
            S.Milli = struct(Type=pa.duration('ms'), TicksPerSecond=1e3);
            S.Micro = struct(Type=pa.duration('us'), TicksPerSecond=1e6);
            S.Nano = struct(Type=pa.duration('ns'), TicksPerSecond=1e9);

            DurationType = S;
        end
  
        function BinaryType = initializeBinaryTypeTestParameter()
            pa = py.importlib.import_module("pyarrow");
            
            S = struct();

            S.String = struct(Type=pa.binary(), ExpectedOffsetType="int32");
            S.LargeString = struct(Type=pa.large_binary(), ExpectedOffsetType="int64");

            BinaryType = S;
        end

        function ListType = initializeListTypeTestParameter()
            import matlab.internal.arrow.ChunkedFloatingArrayConverter
            import matlab.internal.arrow.ChunkedIntegerArrayConverter

            pa = py.importlib.import_module("pyarrow");
            
            S = struct();

            S.List = struct(Type=pa.list_(pa.float64()), ...
                ExpectedOffsetConverter = ChunkedIntegerArrayConverter("int32", false),...
                ExpectedChildConverter=ChunkedFloatingArrayConverter("double"));

            S.LargeList = struct(Type=pa.large_list(pa.float64()), ...
                ExpectedOffsetConverter = ChunkedIntegerArrayConverter("int64", false),...
                ExpectedChildConverter = ChunkedFloatingArrayConverter("double"));

            ListType = S;
        end

    end

    methods (Test)

        function testIntegerConverters(testCase, IntegerType)
            
            function verifyIntegerConverter(converter, expectedCastToDouble)
                testCase.verifyClass(converter, "matlab.internal.arrow.ChunkedIntegerArrayConverter");
                testCase.verifyEqual(converter.Type, IntegerType.ExpectedNumericType);
                testCase.verifyEqual(converter.StorageSize, IntegerType.ExpectedStorageSize);
                testCase.verifyEqual(converter.CastToDouble, expectedCastToDouble);
            end
            
            converter = matlab.internal.arrow.makeConverter(IntegerType.Type);
            verifyIntegerConverter(converter, true);

            converter = matlab.internal.arrow.makeConverter(IntegerType.Type, CastToDouble=false);
            verifyIntegerConverter(converter, false);

            converter = matlab.internal.arrow.makeConverter(IntegerType.Type, CastToDouble=true);
            verifyIntegerConverter(converter, true);
        end

        function testBooleanConverter(testCase)
            
            function verifyBooleanConverter(converter, expectedCastToDouble)
                testCase.verifyClass(converter, "matlab.internal.arrow.ChunkedBooleanArrayConverter");
                testCase.verifyEqual(converter.CastToDouble, expectedCastToDouble);
            end
            
            type = py.pyarrow.bool_();
            converter = matlab.internal.arrow.makeConverter(type);
            verifyBooleanConverter(converter, true);

            converter = matlab.internal.arrow.makeConverter(type, CastToDouble=false);
            verifyBooleanConverter(converter, false);

            converter = matlab.internal.arrow.makeConverter(type, CastToDouble=true);
            verifyBooleanConverter(converter, true);
        end

        function testFloatConverter(testCase, FloatType)
            
            function verifyFloatConverter(converter)
                testCase.verifyClass(converter, "matlab.internal.arrow.ChunkedFloatingArrayConverter");
                testCase.verifyEqual(converter.Type, FloatType.ExpectedNumericType);
                testCase.verifyEqual(converter.StorageSize, FloatType.ExpectedStorageSize);
            end
            
            type = FloatType.Type;
            converter = matlab.internal.arrow.makeConverter(type);
            verifyFloatConverter(converter);

            converter = matlab.internal.arrow.makeConverter(type, CastToDouble=false);
            verifyFloatConverter(converter);

            converter = matlab.internal.arrow.makeConverter(type, CastToDouble=true);
            verifyFloatConverter(converter);
        end

        function testTimestampConverter(testCase, TimestampType)
            
            function verifyTimestampConverter(converter)
                testCase.verifyClass(converter, "matlab.internal.arrow.ChunkedTimestampArrayConverter");
                testCase.verifyEqual(converter.TicksPerSecond, TimestampType.ExpectedTicksPerSecond);
                testCase.verifyEqual(converter.TimeZone, TimestampType.ExpectedTimeZone);
            end
            
            type = TimestampType.Type;
            converter = matlab.internal.arrow.makeConverter(type);
            verifyTimestampConverter(converter);

            converter = matlab.internal.arrow.makeConverter(type, CastToDouble=false);
            verifyTimestampConverter(converter);

            converter = matlab.internal.arrow.makeConverter(type, CastToDouble=true);
            verifyTimestampConverter(converter);
        end
    
        function testStringConverter(testCase, StringType)
            function verifyStringConverter(converter)
                testCase.verifyClass(converter, "matlab.internal.arrow.ChunkedStringArrayConverter");
                testCase.verifyEqual(converter.OffsetType, StringType.ExpectedOffsetType);
                testCase.verifyEqual(converter.OffsetSize, StringType.ExpectedOffsetSize);
            end
            
            type = StringType.Type;
            converter = matlab.internal.arrow.makeConverter(type);
            verifyStringConverter(converter);

            converter = matlab.internal.arrow.makeConverter(type, CastToDouble=false);
            verifyStringConverter(converter);

            converter = matlab.internal.arrow.makeConverter(type, CastToDouble=true);
            verifyStringConverter(converter);
        end

        function testDate32Converter(testCase)

            expected = matlab.internal.arrow.ChunkedDate32ArrayConverter();
            type = py.pyarrow.date32();
           
            converter = matlab.internal.arrow.makeConverter(type);
            testCase.verifyEqual(converter, expected);

            converter = matlab.internal.arrow.makeConverter(type, CastToDouble=false);
            testCase.verifyEqual(converter, expected);

            converter = matlab.internal.arrow.makeConverter(type, CastToDouble=true);
            testCase.verifyEqual(converter, expected);
        end

        function testDurationConverter(testCase, DurationType)
            function verifyTimestampConverter(converter)
                testCase.verifyClass(converter, "matlab.internal.arrow.ChunkedDurationArrayConverter");
                % Verify Int64ToDurationFcn returns a 1 second duration for
                % the given TicksPerSecond value.
                actual = converter.Int64ToDurationFcn(DurationType.TicksPerSecond);
                testCase.verifyEqual(actual, seconds(1));
            end
            
            type = DurationType.Type;
            converter = matlab.internal.arrow.makeConverter(type);
            verifyTimestampConverter(converter);

            converter = matlab.internal.arrow.makeConverter(type, CastToDouble=false);
            verifyTimestampConverter(converter);

            converter = matlab.internal.arrow.makeConverter(type, CastToDouble=true);
            verifyTimestampConverter(converter);
        end

        function testDecimalConverter(testCase)
            expected = matlab.internal.arrow.ChunkedDecimalArrayConverter();

            type = py.pyarrow.decimal128(5, 2);

            converter = matlab.internal.arrow.makeConverter(type);
            testCase.verifyEqual(converter, expected);

            converter = matlab.internal.arrow.makeConverter(type, CastToDouble=false);
            testCase.verifyEqual(converter, expected);

            converter = matlab.internal.arrow.makeConverter(type, CastToDouble=true);
            testCase.verifyEqual(converter, expected);
        end

        function testBinaryConverter(testCase, BinaryType)

            function verifyBinaryConverter(converter)
                testCase.verifyClass(converter, "matlab.internal.arrow.ChunkedBinaryArrayConverter");
                testCase.verifyEqual(converter.OffsetConverter.Type, BinaryType.ExpectedOffsetType);
            end

            type = BinaryType.Type;
            converter = matlab.internal.arrow.makeConverter(type);
            verifyBinaryConverter(converter);

            converter = matlab.internal.arrow.makeConverter(type, CastToDouble=false);
            verifyBinaryConverter(converter);

            converter = matlab.internal.arrow.makeConverter(type, CastToDouble=true);
            verifyBinaryConverter(converter);

        end

        function testListConverter(testCase, ListType)
            function verifyListConverter(converter)
                testCase.verifyClass(converter, "matlab.internal.arrow.ChunkedListArrayConverter");
                testCase.verifyEqual(converter.ChildConverter, ListType.ExpectedChildConverter);
                testCase.verifyEqual(converter.OffsetConverter, ListType.ExpectedOffsetConverter);
            end
            
            type = ListType.Type;
            converter = matlab.internal.arrow.makeConverter(type);
            verifyListConverter(converter);

            converter = matlab.internal.arrow.makeConverter(type, CastToDouble=false);
            verifyListConverter(converter);

            converter = matlab.internal.arrow.makeConverter(type, CastToDouble=true);
            verifyListConverter(converter);
        end

        function testStructConverter(testCase)

            field1 = py.pyarrow.field("A", py.pyarrow.string());
            field2 = py.pyarrow.field("B", py.pyarrow.date32());
            type = py.pyarrow.struct({field1, field2});

            field1Converter = matlab.internal.arrow.ChunkedStringArrayConverter("int32");
                field2Converter = matlab.internal.arrow.ChunkedDate32ArrayConverter();
            expectedConverter = matlab.internal.arrow.ChunkedStructArrayConverter(...
                ["A" "B"], [field1Converter field2Converter]);

            converter = matlab.internal.arrow.makeConverter(type);
            testCase.verifyEqual(converter, expectedConverter);

            converter = matlab.internal.arrow.makeConverter(type, CastToDouble=false);
            testCase.verifyEqual(converter, expectedConverter);

            converter = matlab.internal.arrow.makeConverter(type, CastToDouble=true);
            testCase.verifyEqual(converter, expectedConverter);

        end
        
    end

end