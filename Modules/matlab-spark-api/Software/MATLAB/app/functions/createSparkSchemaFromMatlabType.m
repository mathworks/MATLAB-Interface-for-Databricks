function [schema, javaDataType] = createSparkSchemaFromMatlabType( val )
    % createSparkSchemaFromMatlabType Create StructType from value

    % Copyright 2021 MathWorks, Inc.

    javaDataType = 'java.lang.Object'; %#ok<NASGU>
    switch class(val)
        case {'string', 'char'}
            javaDataType = 'java.lang.String';
            schema = org.apache.spark.sql.types.DataTypes.StringType;
        case 'double'
            javaDataType = 'java.lang.Double';
            schema = org.apache.spark.sql.types.DataTypes.DoubleType;
        case 'single'
            javaDataType = 'java.lang.Float';
            schema = org.apache.spark.sql.types.DataTypes.FloatType;
        case 'int8'
            javaDataType = 'java.lang.Byte';
            schema = org.apache.spark.sql.types.DataTypes.ByteType;
        case 'int16'
            javaDataType = 'java.lang.Short';
            schema = org.apache.spark.sql.types.DataTypes.ShortType;
        case 'int32'
            javaDataType = 'java.lang.Integer';
            schema = org.apache.spark.sql.types.DataTypes.IntegerType;
        case 'int64'
            javaDataType = 'java.lang.Long';
            schema = org.apache.spark.sql.types.DataTypes.LongType;
        case 'logical'
            javaDataType = 'java.lang.Boolean';
            schema = org.apache.spark.sql.types.DataTypes.BooleanType;
        case 'cell'
            %javaDataType = 'array';
            if isempty(val)
                javaDataType = 'java.lang.Double';
                elementType = org.apache.spark.sql.types.DataTypes.DoubleType;
            else
                [elementType, javaDataType] = createSparkSchemaFromMatlabType( val{1} );
            end
            schema = org.apache.spark.sql.types.ArrayType.apply(elementType);
            %schema = org.apache.spark.sql.types.ArrayType.apply(schema); %extra wrap
        case 'datetime'
            javaDataType = 'java.sql.Timestamp';
            schema = org.apache.spark.sql.types.DataTypes.TimestampType;
        case 'duration'  % TODO: calanderDuration
            javaDataType = 'org.apache.spark.unsafe.types.CalendarInterval';
            schema = org.apache.spark.sql.types.DataTypes.CalendarIntervalType;
        case 'struct'
            javaDataType = 'struct';  % dummy value used in table2dataset
            fn = fieldnames(val);
            numFields = length(fn);
            arr = javaArray('org.apache.spark.sql.types.StructField', numFields);
            dataTypesObj = org.apache.spark.sql.types.DataTypes;
            for fieldIdx = 1 : numFields
                fieldName = fn{fieldIdx};
                fieldValue = val(1).(fieldName);
                fieldSchema = createSparkSchemaFromMatlabType(fieldValue);
                if isStructFieldArray(val, fieldName)
                    arraySchema   = dataTypesObj.createArrayType(fieldSchema);
                    arr(fieldIdx) = dataTypesObj.createStructField( ...
                        fieldName, arraySchema, false);
                else
                    arr(fieldIdx) = dataTypesObj.createStructField( ...
                        fieldName, fieldSchema, false);
                end
            end
            schema = org.apache.spark.sql.types.DataTypes.createStructType(arr);
        case 'table'
            javaDataType = 'struct';  % dummy value used in table2dataset
            S = table2struct(val(1,:));
            schema = createSparkSchemaFromMatlabType(S);
        case 'containers.Map'
            javaDataType = 'java.util.Map';
            mapKeys = val.keys;
            if numel(unique(cellfun(@class,mapKeys,'uniform',false))) > 1
                error('SPARK:ERROR', 'Spark only supports maps that have the same data type for all keys');
            end
            mapValues = val.values;
            if numel(unique(cellfun(@class,mapValues,'uniform',false))) > 1
                error('SPARK:ERROR', 'Spark only supports maps that have the same data type for all values');
            end
            keyType   = createSparkSchemaFromMatlabType(mapKeys{1});
            valueType = createSparkSchemaFromMatlabType(mapValues{1});
            schema = org.apache.spark.sql.types.MapType.apply(keyType, valueType, false);
        otherwise
            error('SPARK:ERROR', 'Datatype "%s" cannot be converted into a Spark Java object', class(val));
    end
end

function isArr = isStructFieldArray(S, fieldName)
    if numel(S)==1
        % Handle char strings separately
        fieldValue = S.(fieldName);
        if isa(fieldValue, 'char') || isa(fieldValue, 'table')
            isArr = size(S.(fieldName), 1) > 1;
        else
            isArr = numel(S.(fieldName)) > 1;
        end
    else
        isArr = false;
        N = length(S);
        for k = 1 : N
            if numel((S(k).(fieldName))) > 1
                isArr = true;
                break
            end
        end
    end
end
