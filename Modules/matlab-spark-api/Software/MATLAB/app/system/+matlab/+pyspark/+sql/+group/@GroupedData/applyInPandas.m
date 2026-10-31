function df = applyInPandas(obj, func, options)
    % applyInPandas - Run applyInPandas on a function and a schema
    %
    % This method applies applyInPandas on a specific function and
    % schema. In the general case it's called like this:
    %
    %   DF_OUT = DF.groupBy('article_id').applyInPandas("myFunc", schema="myFunc_Schema");
    %
    % myFunc and myFunc_Schema must be available in the python environment.
    %
    % An alternative way of calling it, in the case a function was
    % generated from MATLAB code (see PythonSparkBuilder).
    %
    %   DF_OUT = DF.groupBy('article_id').applyInPandas("myFunc");
    %
    % This calling will assume that the values available in the python
    % environment are myFunc_applyInPandas and myFunc_output_schema.
    %
    % Finally, there's a way of calling it with additional arguments:
    %   DF_OUT = DF.groupBy('article_id').applyInPandas("myFunc", schema="mySchema", args={arg1, arg2});
    %
    % This can be used for MATLAB functions that take a table as an input,
    % but that has additional arguments. This is described in more detail
    % in Modules\matlab-spark-api\Documentation\SparkBuilderDataTypes.md.
    %
    % Since the Spark functions operate on a Dataframe, the function
    % argument to functions like mapInPandas and applyInPandas expects a
    % function handle. If there are no additional arguments, we just
    % provide the handle of the function, e.g. myFunc_applyInPandas, but if
    % there are additional arguments, the Python code will contain code
    % like this:
    %
    % DF.groupBy('article_id').applyInPandas(myFunc_applyInPandas(3, 'hello'), schema="myFunc_output_schema")
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
        obj (1,1) matlab.pyspark.sql.group.GroupedData
        func (1,1) string
        options.schema (1,1) string
        options.args cell
    end
    arguments (Output)
        df (1,1) matlab.pyspark.sql.dataframe.Dataframe
    end

    if ~isfield(options, 'schema')
        funcName = sprintf("%s_applyInPandas", func);
        schemaName = sprintf("%s_output_schema", func);
    else
        funcName = func;
        schemaName = options.schema;
    end
    
    if ~isfield(options, 'args')
        cmd = sprintf("df = gd.applyInPandas(%s, %s)", funcName, schemaName);
        df = matlab.pyspark.sql.dataframe.Dataframe( ...
            pyrun(cmd, "df", gd=obj.toPy) ...
            );
    else
        cmd = sprintf("df = gd.applyInPandas(%s(*args), %s)", funcName, schemaName);
        df = matlab.pyspark.sql.dataframe.Dataframe( ...
            pyrun(cmd, "df", gd=obj.toPy, args=py.list(options.args)) ...
            );
    end


end