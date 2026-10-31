import unittest
import pandas as pd
import matlab
import numpy as np
from decimal import Decimal
from datetime import date, datetime, timedelta
from pandas import testing as tm

from converters import *

def test_round_trip(pd_series, ml_data, converter, tester):
    # Pandas Series -> MATLAB
    actual1 = converter.fromPandasSeries(pd_series)
    tester.assertEqual(actual1, ml_data)

    # MATLAB -> Pandas Series
    actual2 = converter.toPandasSeries(ml_data)
    tm.assert_series_equal(actual2, pd_series, check_names=False)

class TestPrimitiveSeriesConverter(unittest.TestCase):

    def test_double(self):
        converter = PrimitiveSeriesConverter(PrimitiveType.FLOAT64)

        pd_series1 = pd.Series(np.array([float(x) for x in range(0, 5)], dtype=np.float64))
        ml_data1 =  matlab.double([0, 1, 2, 3, 4])
        test_round_trip(pd_series1, ml_data1, converter, self)

        pd_series2 = pd.Series(np.array([float(100)], dtype=np.float64))
        ml_data2 =  matlab.double([100])
        test_round_trip(pd_series2, ml_data2, converter, self)

    def test_single(self):
        converter = PrimitiveSeriesConverter(PrimitiveType.FLOAT32)
        pd_series1 = pd.Series(np.array([float(x) for x in range(6, 9)], dtype=np.float32))
        ml_data1 = matlab.single([6, 7, 8])
        test_round_trip(pd_series1, ml_data1, converter, self)

    def test_int8(self):
        converter = PrimitiveSeriesConverter(PrimitiveType.INT8)
        pd_series1 = pd.Series(np.array([x for x in range(0, 4)], dtype=np.int8))
        ml_data1 = matlab.int8([0, 1, 2, 3])
        test_round_trip(pd_series1, ml_data1, converter, self)
    
    def test_int16(self):
        converter = PrimitiveSeriesConverter(PrimitiveType.INT16)
        pd_series1 = pd.Series(np.array([x for x in range(11, 15)], dtype=np.int16))
        ml_data1 = matlab.int16([11, 12, 13, 14])
        test_round_trip(pd_series1, ml_data1, converter, self)

    def test_int32(self):
        converter = PrimitiveSeriesConverter(PrimitiveType.INT32)
        pd_series1 = pd.Series(np.array([x for x in range(0, 6)], dtype=np.int32))
        ml_data1 = matlab.int32([0, 1, 2, 3, 4, 5])
        test_round_trip(pd_series1, ml_data1, converter, self)

    def test_int64(self):
        converter = PrimitiveSeriesConverter(PrimitiveType.INT64)
        pd_series1 = pd.Series(np.array([x for x in range(15, 20)], dtype=np.int64))
        ml_data1 = matlab.int64([15, 16, 17, 18, 19])
        test_round_trip(pd_series1, ml_data1, converter, self)

    def test_logical(self):
        converter = PrimitiveSeriesConverter(PrimitiveType.BOOL)
        pd_series1 = pd.Series(np.array([True, True, False, True, False], dtype=np.bool_))
        ml_data1 = matlab.logical([True, True, False, True, False])
        test_round_trip(pd_series1, ml_data1, converter, self)

class TestStringSeriesConverter(unittest.TestCase):

    def test_string(self):
        converter = StringSeriesConverter()
        pd_series1 = pd.Series(['Hello', 'There', '', 'Dog'], dtype='object')
        ml_data1 = ['Hello', 'There', '', 'Dog']
        test_round_trip(pd_series1, ml_data1, converter, self)

class TestTimedelta64SeriesConverter(unittest.TestCase):

    def test_convert(self):
        converter = Timedelta64SeriesConverter()

        times = [timedelta(hours=1, seconds=20, minutes=2),
                 timedelta(hours=10, seconds=58, minutes=43),
                 timedelta(hours=0, seconds=43, minutes=15)]
        pd_series1 = pd.Series(np.array(times, dtype='timedelta64[ns]'))
        ml_data1 = {
            'TimeUnit': 'ns',
            'TimeData': matlab.int64([3740000000000, 38638000000000, 943000000000])
        }
        test_round_trip(pd_series1, ml_data1, converter, self)

class TestDatetme64SeriesConverter(unittest.TestCase):

    def test_datetime64(self):
        converter = Datetime64SeriesConverter()
        dates = [datetime(1969, 7, 20), datetime(1970, 1, 1), datetime(2020, 6, 7, 6, 1, 20)]
        pd_series1 = pd.Series(np.array(dates, dtype='datetime64[ns]'))
        ml_data1 = {
            'TimeUnit': 'ns',
            'TimeData': matlab.int64([-14256000000000000, 0, 1591509680000000000])
        }
        test_round_trip(pd_series1, ml_data1, converter, self)

class TestDateSeriesConverter(unittest.TestCase):

    def test_date(self):
        converter = DateSeriesConverter()
        dates = [date(1969, 7, 20), date(1970, 1, 1), date(2020, 6, 7)]
        pd_series1 = pd.Series(dates)
        ml_data1 = matlab.int64([718998, 719163, 737583])
        test_round_trip(pd_series1, ml_data1, converter, self)

class TestBinarySeriesConverter(unittest.TestCase):

    def test_convert(self):
        converter = BinarySeriesConverter()
        binary_arrays1 = [b'abcd', b'efghi', b'jk', b'lmnopqrs']
        pd_series1 = pd.Series(binary_arrays1)
        ml_bytes1 = matlab.uint8([int(x) for x in range(97, 116)])
        ml_length1 = matlab.int64([4, 5, 2, 8])
        ml_data1 = {'Bytes': ml_bytes1, 'Lengths': ml_length1}
        test_round_trip(pd_series1, ml_data1, converter, self)

        binary_arrays2 = [b'', b'a', b'bcdef', b'ghi', b'', b'j']
        pd_series2 = pd.Series(binary_arrays2)
        ml_bytes2 = matlab.uint8([int(x) for x in range(97, 107)])
        ml_length2 = matlab.int64([0, 1, 5, 3, 0, 1])
        ml_data2 = {'Bytes': ml_bytes2, 'Lengths': ml_length2}
        test_round_trip(pd_series2, ml_data2, converter, self)


class TestDecimalSeriesConverter(unittest.TestCase):

    def test_convert(self):
        converter = DecimalSeriesConverter()
        decimals = [Decimal('123.45'), Decimal('12245.67'), Decimal('-203.567')]
        pd_series1 = pd.Series(decimals)
        ml_data1 = matlab.double([123.45, 12245.67, -203.567])
        test_round_trip(pd_series1, ml_data1, converter, self)

class TestArraySeriesConverter(unittest.TestCase):

    def test_double(self):
        float64_converter = PrimitiveSeriesConverter(PrimitiveType.FLOAT64)
        converter = ArraySeriesConverter(float64_converter)
        data = [[1.0, 2.0, 3.0], [4.0, 5.0], [6.0, 7.0, 8.0]]
        pd_series1 = pd.Series(data)
        ml_lengths1 = matlab.int64([3, 2, 3])
        ml_array_data1 = matlab.double([1, 2, 3, 4, 5, 6, 7, 8])
        ml_data1 = {'Lengths': ml_lengths1, 'Data': ml_array_data1}
        test_round_trip(pd_series1, ml_data1, converter, self)

    def test_struct(self):
        data = [
            [{'A': 1.0, 'B': 11}, {'A': 2.0, 'B': 12}, {'A': 3.0, 'B': 13}],
            [{'A': 4.0, 'B': 14}, {'A': 5.0 , 'B': 15}]
        ]
        pd_series = pd.Series(data)

        float64_converter = PrimitiveSeriesConverter(PrimitiveType.FLOAT64)
        int8_converter = PrimitiveSeriesConverter(PrimitiveType.INT8)
        field_converter_a = FieldConverter('A', float64_converter)
        field_converter_b = FieldConverter('B', int8_converter)
        struct_converter = StructSeriesConverter([field_converter_a, field_converter_b])
        converter = ArraySeriesConverter(struct_converter)

        expected_lengths = matlab.int64([3, 2])
        expected_a_data = matlab.double([1, 2, 3, 4, 5])
        expected_b_data = matlab.int8([11, 12, 13, 14, 15])
        expected_data = [expected_a_data, expected_b_data]
        expected_ml = {'Lengths': expected_lengths, 'Data': expected_data}

        test_round_trip(pd_series, expected_ml, converter, self)

class TestStructSeriesConverter(unittest.TestCase):

    def test_double(self):
        field_a_data = [float(x) for x in range(0, 5)]
        field_b_data = [x for x in range(10, 15)]
        data = [{'A': a, 'B': b} for a, b in zip(field_a_data, field_b_data)]
        pd_series = pd.Series(data)

        float64_converter = PrimitiveSeriesConverter(PrimitiveType.FLOAT64)
        field_converter_a = FieldConverter('A', float64_converter)
        field_converter_b = FieldConverter('B', float64_converter)
        converter = StructSeriesConverter([field_converter_a, field_converter_b])

        expected_a = matlab.double([0, 1, 2, 3, 4])
        expected_b = matlab.double([10, 11, 12, 13, 14])
        expected_ml = [expected_a, expected_b]
        test_round_trip(pd_series, expected_ml, converter, self)

    def test_nested_struct(self):
        field_a_data = [float(x) for x in range(0, 5)]
        field_b_f1_data = [x for x in range(10, 15)]
        field_b_f2_data = [x for x in range(15, 20)]
        field_b_data = [{'F1': x, 'F2': y} for x, y in zip(field_b_f1_data, field_b_f2_data)]
        data = [{'A': a, 'B': b} for a, b in zip(field_a_data, field_b_data)]
        pd_series = pd.Series(data)

        float64_converter = PrimitiveSeriesConverter(PrimitiveType.FLOAT64)
        field_converter_a = FieldConverter('A', float64_converter)
        field_converter_b1_f1 = FieldConverter('F1', float64_converter)
        field_converter_b1_f2 = FieldConverter('F2', float64_converter)
        field_converter_b = FieldConverter('B', StructSeriesConverter(
            [field_converter_b1_f1, field_converter_b1_f2]))
        converter = StructSeriesConverter([field_converter_a, field_converter_b])

        expected_a = matlab.double([0, 1, 2, 3, 4])
        expected_b_f1 = matlab.double([10, 11, 12, 13, 14])
        expected_b_f2 = matlab.double([15, 16, 17, 18, 19])
        expected_b = [expected_b_f1, expected_b_f2]
        expected_ml = [expected_a, expected_b]
        test_round_trip(pd_series, expected_ml, converter, self)

class TestMapSeriesConverter(unittest.TestCase):

    def test_string_to_float64_map(self):
        data = [{'A': 1.0, 'B': 2.0}, {'C': 3.0, 'D':4.0, 'E': 5.0}]
        pd_series = pd.Series(data)
        
        item_converter = StringSeriesConverter()
        value_converter = PrimitiveSeriesConverter(PrimitiveType.FLOAT64)
        converter = MapSeriesConverter(item_converter, value_converter)

        expected_num_key_value_pairs_array = matlab.int64([2, 3])
        expected_key_data_array = ['A', 'B', 'C', 'D', 'E']
        expected_value_data_array = matlab.double([1, 2, 3, 4, 5])

        expected = {
            'NumKeyValuePairs': expected_num_key_value_pairs_array,
            'KeyData': expected_key_data_array,
            'ValueData': expected_value_data_array
        }

        test_round_trip(pd_series, expected, converter, self)

    def test_string_to_array_map(self):
        data = [{'A': [1.0, 2.0], 'B': [3.0]}, {'C': [4.0, 5.0], 'D':[6.0], 'E': [7.0, 8.0, 9.0]}]
        pd_series = pd.Series(data)

        item_converter = StringSeriesConverter()
        value_converter = ArraySeriesConverter(PrimitiveSeriesConverter(PrimitiveType.FLOAT64))
        converter = MapSeriesConverter(item_converter, value_converter)

        # actual = map_converter.convert(df['Var1'])
        expected_num_key_value_pairs_array = matlab.int64([2, 3])
        expected_key_data_array = ['A', 'B', 'C', 'D', 'E']
        expected_value_data_array = {
            'Lengths': matlab.int64([2, 1, 2, 1, 3]),
            'Data': matlab.double([1.0, 2.0, 3.0, 4.0, 5.0, 6.0, 7.0, 8.0, 9.0])
        }
        expected =  {
            'NumKeyValuePairs': expected_num_key_value_pairs_array,
            'KeyData': expected_key_data_array,
            'ValueData': expected_value_data_array
        }
        test_round_trip(pd_series, expected, converter, self)

        
if __name__ == '__main__':
    unittest.main()