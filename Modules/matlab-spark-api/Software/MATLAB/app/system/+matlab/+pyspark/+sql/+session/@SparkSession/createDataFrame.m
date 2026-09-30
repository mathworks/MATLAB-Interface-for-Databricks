function DF = createDataFrame(spark, data, options)
    % createDataFrame Creates a Spark Dataframe from a MATLAB table
    % Returns a matlab.pyspark.sql.dataframe.Dataframe
    % Input data snd schema typically undergo format conversion steps which they
    % must support.
    %
    % Input data can be of types:
    %   char or string
    %       Before being converted to a DataFrame scalar data is first converted
    %       to a cell and then a py.list. Vector data is converted to a table with
    %       array2table and then a pandas DataFrame.
    %
    %   cell
    %       Before being converted to a DataFrame a cell array is first converted
    %       to a table with cell2table, then to a pandas DataFrame.
    %
    %   table
    %       Before being converted to a DataFrame a table is converted to a pandas
    %       DataFrame.
    %
    %   py.str (Python string)
    %       Before being conversion a Python string is evaluated using pyrun.
    %       The resulting Python values should be convertible to a DataFrame.
    %
    %   py.list (Python list)
    %       A Python list is passed directly to createDataFrame.
    %
    %   py.pandas.DataFrame, py.pandas.core.frame.DataFrame
    %       A pandas DataFrame is passed directly to createDataFrame.
    %
    %   Numeric scalars or arrays: 'single', 'double', 'int8', 'int16', 'int32',
    %       'int64', 'uint8', 'uint16', 'uint32', 'uint64', 'logical', 'struct
    %       Before being converted to a DataFrame numeric arrays are first
    %       converted to a table with array2table, then to a pandas DataFrame.
    %
    %   Data examples:
    %       'abc'
    %       "abc"
    %       ["abc", "def"]
    %       ["abc"; "def"]
    %       {'abc'}
    %       {'abc'; 'def'}
    %       [1; 2]
    %       py.str("[(1,), (10,), (100,)]")
    %       [missing; "a"; "b"; "c"]
    %       py.str('[(1, "apple"), (2, "banana"), (3, None)]')
    %       py.list({py.tuple({1, "apple"}), py.tuple({2, "banana"}), py.tuple({3, py.None})})
    %       py.list({py.tuple({1.0, nan}), py.tuple({nan, 2.0})})
    %       magic(3)
    %       {py.None; 1}
    %
    %
    % Schema:
    %   An optional schema can be specified as a named argument. It can be specified
    %   in a number of ways.
    %
    %   char
    %       A char are first converted to a string and handled as a string.
    %
    %   string
    %       A string must be a scalar or vector and is converted to a Python list
    %       before being passed as the schema.
    %
    %   cell
    %       A cell must be a cellstr is converted to a py.list before being passed
    %       as the schema.
    %
    %   py.list (Python list)
    %       Used directly.
    %
    %   py.str (Python string) are used directly.
    %       Used directly and should be a DDL formatted string.
    %
    %   Schema examples:
    %       schema="myvalue"
    %       schema={'myvalue1'}  % Cell must be of chars such that iscellstr is satisfied
    %       schema={'myvalue1', 'myvalue2'};
    %       schema=["myvalue1", "myvalue2"]
    %       schema=py.str('col1: string, col2: string')
    %
    %
    % Other unsupported arguments:
    %   samplingRatio is not supported as it only applies to RDD-based DataFrames.
    %
    %   verifySchema is not supported when using Spark/Databricks Connect and
    %   so is not supported by this function.
    %
    %
    % Examples:
    %   % Create a DataFrame based on a MATLAB table
    %   LastName = {'Sanchez';'Johnson';'Li';'Diaz';'Brown'};
    %   Age = [38;43;38;40;49];
    %   Smoker = logical([1;0;1;0;1]);
    %   Height = [71;69;64;67;64];
    %   Weight = [176;163;131;133;119];
    %   BloodPressure = [124 93; 109 77; 125 83; 117 75; 122 80];
    %   T = table(LastName,Age,Smoker,Height,Weight,BloodPressure)
    %
    %   spark = getDatabricksSession;
    %   df = spark.createDataFrame(T);
    %   df.show
    %   +--------+----+------+------+------+---------------+---------------+
    %   |LastName| Age|Smoker|Height|Weight|BloodPressure_1|BloodPressure_2|
    %   +--------+----+------+------+------+---------------+---------------+
    %   | Sanchez|38.0|  true|  71.0| 176.0|          124.0|           93.0|
    %   | Johnson|43.0| false|  69.0| 163.0|          109.0|           77.0|
    %   |      Li|38.0|  true|  64.0| 131.0|          125.0|           83.0|
    %   |    Diaz|40.0| false|  67.0| 133.0|          117.0|           75.0|
    %   |   Brown|49.0|  true|  64.0| 119.0|          122.0|           80.0|
    %   +--------+----+------+------+------+---------------+---------------+
    %
    %
    %   % Source from an array of doubles with non default column names
    %   df = spark.createDataFrame(magic(3), schema=["x1","x2", "x3"]);
    %   df.show
    %   +---+---+---+
    %   | x1| x2| x3|
    %   +---+---+---+
    %   |8.0|1.0|6.0|
    %   |3.0|5.0|7.0|
    %   |4.0|9.0|2.0|
    %   +---+---+---+
    %
    % See also: https://spark.apache.org/docs/latest/api/python/reference/pyspark.sql/api/pyspark.sql.SparkSession.createDataFrame.html

    % (c) 2025-2026 MathWorks, Inc.

    arguments (Input)
        spark (1,1) matlab.pyspark.sql.session.SparkSession
        data
        options.schema
    end
    arguments (Output)
        DF (1,1)  matlab.pyspark.sql.dataframe.Dataframe
    end

    % Imposed by py.pandas.DataFrame
    if isMATLABReleaseOlderThan("R2024a")
        error('PYSPARK:CREATEDATAFRAME:UNSUPPORTED_RELEASE', "createDataFrame is supported in MATLAB R2024a and greater.");
    end

    if isfield(options, "schema")
        switch class(options.schema)
            % May expand this to cover pyspark.sql.types.DataType or other native Python types in the future
            case {'string', 'char'}
                schema = string(options.schema);
                if isscalar(schema) || isvector(schema)
                    schemaPy = py.list(cellstr(schema));
                else
                    error('PYSPARK:CREATEDATAFRAME:SCHEMASTRING', "A string or char schema must be a scalar or vector.");
                end

            case 'cell'
                if iscellstr(options.schema)
                    schemaPy = py.list(options.schema);
                else
                    error('PYSPARK:CREATEDATAFRAME:SCHEMANOTCELLSTR', "A cell array based schema must be cellstr.");
                end

            case {'py.list', 'py.str'}
                schemaPy = options.schema;

            otherwise
                error('PYSPARK:CREATEDATAFRAME:SCHEMATYPE', "Unsupported schema type: %s", class(options.schema));
        end
    end

    % Schema should have a Python representation at this point.
    if isfield(options, "schema")
        schemaArgPy = {schemaPy};
    else
        schemaArgPy = {};
    end

    switch class(data)
        case {'string', 'char'}
            data = string(data); % convert char to string for downstream consistency
            if isscalar(data)
                dataPy = py.list({data});
                dfPy = spark.toPy.createDataFrame(dataPy, schemaArgPy{:});
            else
                dataT = array2table(data);
                dfPy = spark.toPy.createDataFrame(py.pandas.DataFrame(dataT), schemaArgPy{:});
            end

        case "py.str"
            dataPy = pyrun(sprintf("a = %s", string(data)), "a");
            dfPy = spark.toPy.createDataFrame(dataPy, schemaArgPy{:});
        
        case 'cell'
            dataT = cell2table(data);
            dfPy = spark.toPy.createDataFrame(py.pandas.DataFrame(dataT), schemaArgPy{:});

        case 'table'
            dfPy = spark.toPy.createDataFrame(py.pandas.DataFrame(data), schemaArgPy{:});

        case {'py.pandas.DataFrame', 'py.pandas.core.frame.DataFrame'}
            dfPy = spark.toPy.createDataFrame(data, schemaArgPy{:});
            
        case 'py.list'
            dfPy = spark.toPy.createDataFrame(data, schemaArgPy{:});
            
        case {'single', 'double', 'int8', 'int16', 'int32', 'int64', 'uint8', 'uint16', 'uint32', 'uint64', 'logical', 'struct'}
            dataT = array2table(data);
            dfPy = spark.toPy.createDataFrame(py.pandas.DataFrame(dataT), schemaArgPy{:});

        otherwise
            error('PYSPARK:CREATEDATAFRAME:TYPE', "Unsupported data type: %s", class(data));
    end
    DF = matlab.pyspark.sql.dataframe.Dataframe(dfPy); % For clarity, also handled by the output argument
end