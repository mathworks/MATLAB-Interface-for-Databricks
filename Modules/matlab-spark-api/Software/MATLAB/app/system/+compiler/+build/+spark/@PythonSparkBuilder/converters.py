# Converters for transforming pandas Series data to/from MATLAB-compatible types.
# Each converter handles a specific data type (primitives, datetime, strings, etc.)
# and provides bidirectional conversion via fromPandasSeries(() and toPandasSeries(() methods.

import numpy
import pandas as pd
import matlab
import itertools
from enum import Enum
from abc import ABC, abstractmethod
from datetime import date

from decimal import Decimal

# Enum representing numeric/boolean types supported by MATLAB.
class PrimitiveType(Enum):
    INT8 = 1
    INT16 = 2
    INT32 = 3
    INT64 = 4
    FLOAT32 = 5
    FLOAT64 = 6
    BOOL = 7

    # Returns the numpy dtype string for this type (e.g. 'int8', 'float64').
    def dtype(self):
        return self.name.lower()

    # Returns a lambda that wraps data in the corresponding MATLAB type constructor.
    def to_matlab_function(self):
        match self:
            case PrimitiveType.INT8:
                return lambda data: matlab.int8(data)
            case PrimitiveType.INT16:
                return lambda data: matlab.int16(data)
            case PrimitiveType.INT32:
                return lambda data: matlab.int32(data)
            case PrimitiveType.INT64:
                return lambda data: matlab.int64(data)
            case PrimitiveType.FLOAT32:
                return lambda data: matlab.single(data)
            case PrimitiveType.FLOAT64:
                return lambda data: matlab.double(data)
            case PrimitiveType.BOOL:
                return lambda data: matlab.logical(data)
            case _:
                raise ValueError("Unknown primititive type")

    # Returns the MATLAB class type (for use with isinstance checks).
    def matlab_class(self):
        match self:
            case PrimitiveType.INT8:
                return matlab.int8
            case PrimitiveType.INT16:
                return matlab.int16
            case PrimitiveType.INT32:
                return matlab.int32
            case PrimitiveType.INT64:
                return matlab.int64
            case PrimitiveType.FLOAT32:
                return matlab.single
            case PrimitiveType.FLOAT64:
                return matlab.double
            case PrimitiveType.BOOL:
                return matlab.logical
            case _:
                raise ValueError("Unknown primititive type")

# Converts MATLAB array data to a numpy array. If data is already a MATLAB typed
# array, uses zero-copy frombuffer; otherwise wraps a scalar in a single-element array.
def matlab_to_numpy_array(data, matlab_class, dtype):
    if isinstance(data, matlab_class):
        return numpy.frombuffer(data, dtype=dtype)
    else:
        return numpy.array([data], dtype=dtype)

# Abstract base class for all series converters.
# fromPandasSeries((): pandas Series -> MATLAB-compatible representation
# toPandasSeries((): MATLAB data -> pandas Series
class SeriesConverter(ABC):

    # Converts a pandas Series to a MATLAB-compatible format.
    def fromPandasSeries(self, ps):
        return self.fromPandasSeriesImpl(ps.to_numpy())

    # Converts MATLAB data back into a pandas Series.
    def toPandasSeries(self, ml_data):
        x = self.toPandasSeriesImpl(ml_data)
        return pd.Series(x, copy=False)

    @abstractmethod
    def fromPandasSeriesImpl(self, numpy):
        pass

    @abstractmethod
    def toPandasSeriesImpl(self, ml_data):
        pass

# Handles conversion of numeric and boolean pandas Series to/from MATLAB arrays.
class PrimitiveSeriesConverter(SeriesConverter):

    def __init__(self, primitive_type: PrimitiveType):
        self.dtype = primitive_type.dtype()
        self.to_matlab_fcn = primitive_type.to_matlab_function()
        self.matlab_class = primitive_type.matlab_class()

    def fromPandasSeriesImpl(self, array):
        if isinstance(array, numpy.ndarray):
            array = array.astype(self.dtype)
        return self.to_matlab_fcn(array)

    def toPandasSeriesImpl(self, ml_data):
        return matlab_to_numpy_array(ml_data, self.matlab_class, self.dtype)

# Converts datetime64 Series by encoding as int64 ticks plus a time unit string.
class Datetime64SeriesConverter(SeriesConverter):

    def fromPandasSeriesImpl(self, array):

        # Convert array into a numpy array if needed.
        if not isinstance(array, numpy.ndarray):
            array = numpy.array(array, dtype='datetime64')

        if not numpy.issubdtype(array.dtype, numpy.datetime64):
            array = array.astype('datetime64')

        # Store the resolution (e.g. 'ns', 'us') so it can be reconstructed on convertTo.
        time_unit = numpy.datetime_data(array.dtype)[0]
        time_data = matlab.int64(array.astype('int64'))
        return {'TimeUnit': time_unit, 'TimeData': time_data}

    def toPandasSeriesImpl(self, ml_data):
        time_unit = ml_data['TimeUnit']
        int64_numpy_array = matlab_to_numpy_array(ml_data['TimeData'], matlab.int64, 'int64')
        dtype = "datetime64[{unit}]".format(unit=time_unit)
        return int64_numpy_array.astype(dtype)

# Converts date objects using ordinal integer representation (days since Jan 1, year 1).
class DateSeriesConverter(SeriesConverter):

    def fromPandasSeriesImpl(self, array):
        int64s = numpy.fromiter((date.toordinal() for date in array),
                                dtype=numpy.int64, count=array.size)
        return matlab.int64(int64s)

    def toPandasSeriesImpl(self, ml_data):
        int64_numpy_array = matlab_to_numpy_array(ml_data, matlab.int64, 'int64')
        iter_generator = (date.fromordinal(elem) for elem in int64_numpy_array)
        return numpy.fromiter(iter_generator, count=len(int64_numpy_array), dtype='object')

# Converts timedelta64 Series using the same int64 + time unit approach as datetime64.
class Timedelta64SeriesConverter(SeriesConverter):

    def fromPandasSeriesImpl(self, array):
        if not isinstance(array, numpy.ndarray):
            array = numpy.array(array, dtype='timedelta64')

        if not numpy.issubdtype(array.dtype, numpy.timedelta64):
            array = array.astype('timedelta64')

        time_unit = numpy.datetime_data(array.dtype)[0]
        time_data = matlab.int64(array.astype('int64'))
        return {'TimeUnit': time_unit, 'TimeData': time_data}

    def toPandasSeriesImpl(self, ml_data):
        time_unit = ml_data['TimeUnit']
        int64_numpy_array = matlab_to_numpy_array(ml_data['TimeData'], matlab.int64, 'int64')
        dtype = "timedelta64[{unit}]".format(unit=time_unit)
        out = int64_numpy_array.astype(dtype)
        return pd.Series(out, copy=False)

# Converts string Series as plain Python lists (no MATLAB wrapping needed).
class StringSeriesConverter(SeriesConverter):

    def fromPandasSeriesImpl(self, array):
        if isinstance(array, numpy.ndarray):
            array = array.tolist()
        return array

    # MATLAB passes a single string as a scalar; wrap it in a list for consistency.
    def toPandasSeriesImpl(self, ml_data):
        if isinstance(ml_data, str):
            ml_data = [ml_data]
        return ml_data

# Converts Decimal Series via float64 (lossy but necessary since MATLAB lacks a Decimal type).
class DecimalSeriesConverter(SeriesConverter):

    def fromPandasSeriesImpl(self, array):
        if not isinstance(array, numpy.ndarray):
            array = numpy.array(array)
        return matlab.double(array.astype('float64'))

    def toPandasSeriesImpl(self, ml_data):
        float64_numpy_array = matlab_to_numpy_array(ml_data, matlab.double, 'float64')
        # Convert via string to avoid floating-point representation artifacts in Decimal.
        iter_generator = (Decimal(str(elem)) for elem in float64_numpy_array)
        return numpy.fromiter(iter_generator, count=len(float64_numpy_array), dtype='object')

# Yields start offsets for variable-length segments given their lengths and cumulative sums.
def aray_like_offsets_generator(lengths_iter, cumsum_iter):
    for length, cumsum in zip(lengths_iter, cumsum_iter):
        yield (cumsum - length)

# Converts binary (bytes) Series by flattening into a single byte buffer plus lengths.
class BinarySeriesConverter(SeriesConverter):

    def fromPandasSeriesImpl(self, array):
        int64_array = numpy.fromiter((len(x) for x in array),
                                      count=len(array), dtype='int64')
        byte_array = bytearray().join(array)
        return {'Bytes': matlab.uint8(byte_array), 'Lengths': matlab.int64(int64_array)}

    # Reconstructs individual bytes objects by slicing the flat buffer using lengths.
    def toPandasSeriesImpl(self, ml_data):
        uint8_numpy_array = matlab_to_numpy_array(ml_data['Bytes'], matlab.uint8, 'uint8')
        lengths_numpy_array = matlab_to_numpy_array(ml_data['Lengths'], matlab.int64, 'int64')

        offset_iter = aray_like_offsets_generator(lengths_numpy_array, itertools.accumulate(lengths_numpy_array))
        iter_gen = (bytes(uint8_numpy_array[pos:pos+length]) for pos, length in zip(offset_iter, lengths_numpy_array))

        return [value for value in iter_gen]

# Converts Series of variable-length arrays (list-of-lists) by flattening data and
# storing element lengths. Delegates element conversion to a nested data_converter.
class ArraySeriesConverter(SeriesConverter):

    def __init__(self, data_converter: SeriesConverter):
        self.DataConverter = data_converter

    def fromPandasSeriesImpl(self, array):

        length_array = numpy.fromiter((len(x) for x in array),
                                      count=len(array), dtype='int64')
        int64_length_array = matlab.int64(length_array)

        data_array = numpy.concatenate(array)
        data = self.DataConverter.fromPandasSeriesImpl(data_array)

        return {'Lengths': int64_length_array, 'Data': data}

    def toPandasSeriesImpl(self, ml_data):
        data_numpy = self.DataConverter.toPandasSeriesImpl(ml_data['Data'])
        lengths_numpy = matlab_to_numpy_array(ml_data['Lengths'], matlab.int64, 'int64')
        offset_iter = aray_like_offsets_generator(lengths_numpy, itertools.accumulate(lengths_numpy))
        iter_gen = (data_numpy[pos:pos+length] for pos, length in zip(offset_iter, lengths_numpy))
        return [value for value in iter_gen]

# Pairs a field name with its converter, used by StructSeriesConverter.
class FieldConverter:
    def __init__(self, name: str, converter: SeriesConverter):
        self.Name = name
        self.Converter = converter

# Converts Series of dicts (struct-like rows) by converting each field independently.
# Each field is extracted into a column, converted via its own FieldConverter, then
# reassembled into dicts on the way back.
class StructSeriesConverter(SeriesConverter):

    def __init__(self, fieldConverters: list[FieldConverter]):
        self.FieldConverters = fieldConverters

    def fromPandasSeriesImpl(self, array):
        num_fields = len(self.FieldConverters)
        result = [None] * num_fields

        for i in range(0, num_fields):
            fieldConverter = self.FieldConverters[i]
            name = fieldConverter.Name
            vals = [val[name] for val in array]
            result[i] = fieldConverter.Converter.fromPandasSeriesImpl(vals)

        return result

    def toPandasSeriesImpl(self, ml_data):

        num_fields = len(self.FieldConverters)
        key_names = [field.Name for field in self.FieldConverters]

        field_values = [None] * num_fields
        for i in range(0, num_fields):
            field_values[i] = self.FieldConverters[i].Converter.toPandasSeriesImpl(ml_data[i])

        # Transpose field-major data back into row-major list of dicts.
        return [dict(zip(key_names, values)) for values in zip(*field_values)]

# Converts Series of dicts (map type) by flattening all keys and values into separate
# arrays and storing the number of key-value pairs per element for reconstruction.
class MapSeriesConverter(SeriesConverter):

    def __init__(self, key_converter: SeriesConverter, value_converter: SeriesConverter):
        self.KeyConverter = key_converter
        self.ValueConverter = value_converter

    def fromPandasSeriesImpl(self, array):

        num_key_value_pairs_array = numpy.fromiter((len(val) for val in array),
                                      count=len(array), dtype='int64')
        num_key_value_pairs = sum(num_key_value_pairs_array)

        key_generator = itertools.chain.from_iterable(elem.keys() for elem in array)
        key_array = [key for key in key_generator]

        value_generator = itertools.chain.from_iterable(elem.values() for elem in array)
        value_array = [value for value in value_generator]

        return {'NumKeyValuePairs': matlab.int64(num_key_value_pairs_array),
                'KeyData': self.KeyConverter.fromPandasSeriesImpl(key_array),
                'ValueData': self.ValueConverter.fromPandasSeriesImpl(value_array)}

    # Rebuilds dicts by slicing the flat key/value arrays using per-element lengths.
    def toPandasSeriesImpl(self, ml_data):
        lengths = matlab_to_numpy_array(ml_data['NumKeyValuePairs'], matlab.int64, 'int64')
        keys = self.KeyConverter.toPandasSeriesImpl(ml_data['KeyData'])
        values = self.ValueConverter.toPandasSeriesImpl(ml_data['ValueData'])
        offset_iter = aray_like_offsets_generator(lengths, itertools.accumulate(lengths))
        iter_gen = (dict(zip(keys[pos:pos + length], values[pos:pos + length])) for pos, length in zip(offset_iter, lengths))
        return [value for value in iter_gen]
