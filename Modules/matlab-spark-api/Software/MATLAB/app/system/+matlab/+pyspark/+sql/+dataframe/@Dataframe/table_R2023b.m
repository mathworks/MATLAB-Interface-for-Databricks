function T = table_R2023b(obj)
    % table - Convert Spark dataframe to MATLAB table
    %
    % This methods is necessary to handle release R2023b and earlier,
    % as these releases have no conversion from Pandas Dataframe to MATLAB
    % table.

    % (c) 2025 MathWorks, Inc.

    arguments (Input)
        obj (1,1) matlab.pyspark.sql.dataframe.Dataframe
    end
    schema = obj.schema();
    D = compiler.build.spark.data.fromSchema(schema);
    numCols = D.NumFields;

    pdf = obj.toPandas();

    COLS = cell(1, numCols);
    VALS = cell(pdf.values.transpose.tolist);
    for k=1:numCols
        elem = D.fields(k).dataType;
        elemSchema = schema.fields(k).dataType;
        curVal = preConversion(VALS{k}, elem, elemSchema);

        COLS{k} = elem.col_MATLABTable(curVal);
    end
    T = table(COLS{:}, 'VariableNames', D.names);
end

function val = preConversion(val, elem, elemSchema)
    % preConversion
    % Some conversions from Python must be executed before running the
    % col_MATLABTable methods.


    if isa(val, 'py.list')
        val = cell(val);
        val = val(:);
    end

    if isa(elemSchema, 'compiler.build.spark.schema.NumericType')
        val = cellfun(str2func(elem.MATLABType), val);
        return;
    elseif isa(elemSchema, 'compiler.build.spark.schema.StringType')
       val = cellfun(@string, val);
       return;
    end
    switch elem.type
        case "string"
            val = string(val);
        case "struct"
            val = cellfun(@struct, cell(val), 'UniformOutput', ~false);
        case "array"
            val = cell(val);
        case "timestamp"
            val = cell(val);
        otherwise
            % pi 
    end

    % We want column arrays for a table
    val = val(:);

end

