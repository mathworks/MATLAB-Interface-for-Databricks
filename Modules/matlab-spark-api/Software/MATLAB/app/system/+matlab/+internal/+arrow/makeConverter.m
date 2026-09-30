function converter = makeConverter(type, opts)
%MAKECONVERTER  Creates an appropriate ChunkedArrayConverter instance for
%given arrow type.

% Copyright 2026 The MathWorks, Inc.
    arguments
        type
        opts.CastToDouble(1, 1) logical = true
    end

    import matlab.internal.arrow.*

    if py.pyarrow.types.is_integer(type)
        converter = ChunkedIntegerArrayConverter(string(py.str(type)), opts.CastToDouble);
    elseif py.pyarrow.types.is_floating(type)
        converter = ChunkedFloatingArrayConverter(string(py.str(type)));
    elseif py.pyarrow.types.is_boolean(type)
        converter = ChunkedBooleanArrayConverter(opts.CastToDouble);
    elseif py.pyarrow.types.is_timestamp(type)
        timeZone = getTimeZone(type.tz);
        converter = ChunkedTimestampArrayConverter(string(type.unit), timeZone);
    elseif py.pyarrow.types.is_date32(type)
        converter = ChunkedDate32ArrayConverter();
    elseif py.pyarrow.types.is_duration(type)
        converter = ChunkedDurationArrayConverter(string(type.unit));
    elseif py.pyarrow.types.is_string(type)
        converter = ChunkedStringArrayConverter("int32");
    elseif py.pyarrow.types.is_large_string(type)
        converter = ChunkedStringArrayConverter("int64");
    elseif py.pyarrow.types.is_binary(type)
        converter = ChunkedBinaryArrayConverter("int32");
    elseif py.pyarrow.types.is_large_binary(type)
        converter = ChunkedBinaryArrayConverter("int64");
    elseif py.pyarrow.types.is_decimal(type)
        converter = ChunkedDecimalArrayConverter();
    elseif py.pyarrow.types.is_list(type)
        childConverter = makeConverter(type.value_type, CastToDouble=opts.CastToDouble);
        converter = ChunkedListArrayConverter("int32", childConverter);
    elseif py.pyarrow.types.is_large_list(type)
        childConverter = makeConverter(type.value_type, CastToDouble=opts.CastToDouble);
        converter = ChunkedListArrayConverter("int64", childConverter);
    elseif py.pyarrow.types.is_map(type)
        keyConverter = makeConverter(type.key_type);
        itemConverter = makeConverter(type.item_type);
        converter = ChunkedMapArrayConverter(keyConverter, itemConverter);
    elseif py.pyarrow.types.is_struct(type)
        converter = makeStructConverter(type, opts.CastToDouble);
    else
        % TODO: better error message
        error("Unknown Arrow type")
    end
end

function converter = makeStructConverter(type, castToDouble)
    import matlab.internal.arrow.makeConverter
    import matlab.internal.arrow.ChunkedStructArrayConverter

    numFields = int32(type.num_fields);
    fieldNames = repmat(string(missing), [1 numFields]);
    fieldConverters = cell([1 numFields]);

    for ii = 1:numFields
        field = type.field(int32(ii - 1));
        fieldNames(ii) = string(field.name);
        fieldConverters{ii} = makeConverter(field.type, CastToDouble=castToDouble);
    end

    converter = ChunkedStructArrayConverter(fieldNames, [fieldConverters{:}]);
end

function timeZone = getTimeZone(tz)
    if isequaln(tz, py.None)
        timeZone = "";
    else
        timeZone = string(py.str(tz));
    end
end


