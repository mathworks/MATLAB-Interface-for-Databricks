function dfNew = mapInPandas(obj, func, options)
    % mapInPandas - Run mapInPandas on a function and a schema
    %
    % This method applies mapInPandas on a specific function and
    % schema. In the general case it's called like this:
    %
    %   DF_OUT = DF.mapInPandas("myFunc", schema="mySchema");
    %
    % myFunc and mySchema must be available in the python environment.
    %
    % An alternative way of calling it, in the case a function was
    % generated from MATLAB code (see PythonSparkBuilder).
    %
    %   DF_OUT = DF.mapInPandas("myFunc");
    %
    % This calling will assume that the values available in the python
    % environment are myFunc_mapInPandas and myFunc_output_schema.
    %
    % Finally, there's a way of calling it with additional arguments:
    %   DF_OUT = DF.mapInPandas("myFunc", schema="mySchema", args={arg1, arg2});
    %
    % This can be used for MATLAB functions that take a table as an input,
    % but that has additional arguments. This is described in more detail
    % in Modules\matlab-spark-api\Documentation\SparkBuilderDataTypes.md.
    %
    % Since the Spark functions operate on a Dataframe, the function
    % argument to functions like mapInPandas and applyInPandas expects a
    % function handle. If there are no additional arguments, we just
    % provide the handle of the function, e.g. myFunc_mapInPandas, but if
    % there are additional arguments, the Python code will contain code
    % like this:
    %
    % DF.mapInPandas(myFunc_mapInPandas(3, 'hello'), schema="myFunc_output_schema")
    %
    % This works so that calling the function with these arguments will
    % return a handle to a function suitable for Spark, that takes only one
    % argument. This is a way of parameterizing compiled functions.
    %
    % To be noted here, is that the arguments used should be Python
    % arguments or easily converted to Python automatically.
    %
    % A MATLAB double will convert to a Python float, a MATLAB int64 will
    % be converted to a Python int. If for example we'd need to add the 3
    % arguments int64, double and string, we could do it like this:
    %
    %   args={int64(100), 3.14, "Hello"}
    %
    % It also works to be specific about python types, like this:
    %
    %   args={py.int(1000), py.float(100), py.str('bob')}
    %
    % It should be noted, though, that this can not be done with all
    % Python types, as it's restricted by the functionality of the
    % interface between Python and MATLAB Runtime.

    % (c) 2024-2026 MathWorks, Inc.

    arguments (Input)
        obj (1,1) matlab.pyspark.sql.dataframe.Dataframe
        func (1,1) string
        options.schema (1,1) string
        options.args cell
    end
    arguments (Output)
        dfNew (1,1) matlab.pyspark.sql.dataframe.Dataframe
    end

    if ~isfield(options, 'schema')
        funcName = sprintf("%s_mapInPandas", func);
        schemaName = sprintf("%s_output_schema", func);
    else
        funcName = func;
        schemaName = options.schema;
    end

    if ~isfield(options, 'args')
        cmd = sprintf("df2 = df.mapInPandas(%s, %s)", funcName, schemaName);
        dfNew = matlab.pyspark.sql.dataframe.Dataframe( ...
            pyrun(cmd, "df2", df=obj.toPy) ...
            );
    else
        N = numel(options.args);
        cmd = sprintf("df = df.mapInPandas(%s(*args), schema=%s)", funcName, schemaName);
        dfNew = matlab.pyspark.sql.dataframe.Dataframe( ...
            pyrun(cmd, "df", df=obj.toPy, args=py.list(options.args)) ...
            );
    end
end