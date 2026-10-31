classdef Dataframe < matlab.pyspark.internal.PyWrapper ...
        & matlab.mixin.indexing.RedefinesDot
    % Dataframe Pyspark DataFrame wrapper
    % 
    % This class is a wrapper for the pyspark Dataframe class,
    % matlab.pyspark.sql.dataframe.Dataframe, and implements a large part
    % of its methods.

    % (c) 2024-2026 MathWorks, Inc.

    properties (Hidden)
        dataframe
    end

    methods
        function obj = Dataframe(df)
            if nargin==1
                if isa(df, 'py.pyspark.sql.connect.dataframe.DataFrame')
                    obj.dataframe = df;
                else
                    error('sparkapi:dataframe_constructor', ...
                        'The argument to Dataframe must be a Python Spark Dataframe');
                end
            end
        end

        function colObject = col(obj, colName)
            % col Retrieving a column from a Dataframe
            %
            % Whereas this can retrieve a column, the dot-notation can also be
            % used for many, use cases.
            %
            %    c1 = DF.col('age')
            %    c2 = DF.age
            %
            %  c1 and c2 will refer to the same column here.
            %
            % Please refer to the document DataframeColumns.md in the
            % matlab-spark-api/Documentation directory for more information.

            arguments (Input)
                obj (1,1) matlab.pyspark.sql.dataframe.Dataframe
                colName {matlab.pyspark.internal.mustBeColType}
            end
            arguments (Output)
                colObject (1,1) matlab.pyspark.sql.column.Column
            end

            pyCmd = sprintf("pyColObj = df['%s']", colName);
            colObject = matlab.pyspark.sql.column.Column(...
                pyrun(pyCmd, "pyColObj", df=obj.toPy));
        end

        function pandas = toPandas(obj)
            % toPandas Return Python Pandas Dataframe
            pandas = obj.toPy.toPandas;
        end

        function pyObj = toPy(obj)
            pyObj = obj.dataframe;
        end

        function S = schema(obj)
            % schema Return MATLAB representation of Dataframe schema
            arguments (Input)
                obj (1,1) matlab.pyspark.sql.dataframe.Dataframe
            end
            S = compiler.build.spark.schema.DataType.createSchema(obj.toPy.schema);
        end

        function writer = write(obj)
            arguments (Input)
                obj (1,1) matlab.pyspark.sql.dataframe.Dataframe
            end
            arguments (Output)
                writer (1,1) matlab.pyspark.sql.readwriter.DataFrameWriter
            end

            writer = matlab.pyspark.sql.readwriter.DataFrameWriter(obj.toPy.write);
        end

        function df = alias(obj, aliasName)
            % alias Create alias for dataframe
            arguments (Input)
                obj (1,1) matlab.pyspark.sql.dataframe.Dataframe
                aliasName (1,1) string
            end
            arguments (Output)
                df (1,1) matlab.pyspark.sql.dataframe.Dataframe
            end
            df = matlab.pyspark.sql.dataframe.Dataframe(obj.toPy.alias(aliasName));
        end

        function tf = isEmpty(obj)
            % isEmpty Returns true for empty dataframe
            arguments
                obj (1,1) matlab.pyspark.sql.dataframe.Dataframe
            end

            tf = obj.toPy.isEmpty();
        end

        function df = repartition(obj, numPartitions, arg)
            arguments (Input)
                obj (1,1) matlab.pyspark.sql.dataframe.Dataframe
                numPartitions 
            end
            arguments (Input, Repeating)
                arg {matlab.pyspark.internal.mustBeColType}
            end
            arguments (Output)
                df (1,1) matlab.pyspark.sql.dataframe.Dataframe
            end

            if isnumeric(numPartitions)
                numPartitions = int64(numPartitions);
            else
                numPartitions = matlab.pyspark.internal.unifyColArguments(numPartitions);
            end

            arg = matlab.pyspark.internal.unifyColArguments(arg);

            df = matlab.pyspark.sql.dataframe.Dataframe(obj.toPy.repartition(numPartitions, arg{:}));

        end

        
        function df = repartitionByRange(obj, numPartitions, arg)
            % repartitionByRange 
            %
            % df = spark.createDataFrame(py.str('[(2, "Alice"), (5, "Bob")]'), ...
            %      schema=["age", "name"])
            % df.repartitionByRange(2, "age") ...
            %     .select("age", "name", matlab.pyspark.sql.functions.spark_partition_id()).show()
            %   +---+-----+--------------------+
            %   |age| name|SPARK_PARTITION_ID()|
            %   +---+-----+--------------------+
            %   |  2|Alice|                   0|
            %   |  5|  Bob|                   1|
            %   +---+-----+--------------------+

            arguments (Input)
                obj (1,1) matlab.pyspark.sql.dataframe.Dataframe
                numPartitions 
            end
            arguments (Input, Repeating)
                arg {matlab.pyspark.internal.mustBeColType}
            end
            arguments (Output)
                df (1,1) matlab.pyspark.sql.dataframe.Dataframe
            end

            if isnumeric(numPartitions)
                numPartitions = int64(numPartitions);
            else
                numPartitions = matlab.pyspark.internal.unifyColArguments(numPartitions);
            end

            arg = matlab.pyspark.internal.unifyColArguments(arg);

            df = matlab.pyspark.sql.dataframe.Dataframe(obj.toPy.repartitionByRange(numPartitions, arg{:}));

        end

        function DF = dropDuplicates(df, arg)
            % dropDuplicates Drop duplicates
            arguments (Input)
                df (1,1) matlab.pyspark.sql.dataframe.Dataframe
            end
            arguments (Input, Repeating)
                arg string
            end
            arguments (Output)
                DF (1,1) matlab.pyspark.sql.dataframe.Dataframe
            end

            arg = matlab.pyspark.internal.unifyStringArguments(arg);
            
            if numel(arg) > 0
                pyDF = df.toPy.dropDuplicates(arg);
            else
                pyDF = df.toPy.dropDuplicates();
            end
            DF = matlab.pyspark.sql.dataframe.Dataframe( pyDF );
        end

        function DF = drop(df, arg)
            % drop Drop certain columns from Dataframe
            arguments (Input)
                df (1,1) matlab.pyspark.sql.dataframe.Dataframe
            end
            arguments (Input, Repeating)
                arg {matlab.pyspark.internal.mustBeColType}
            end
            arguments (Output)
                DF (1,1) matlab.pyspark.sql.dataframe.Dataframe
            end

            arg = matlab.pyspark.internal.unifyColArguments(arg);

            DF = matlab.pyspark.sql.dataframe.Dataframe(df.toPy.drop(arg{:}));
        end

        function createOrReplaceTempView(df, name)
            % createOrReplaceTempView Create a temporary view

            arguments
                df (1,1) matlab.pyspark.sql.dataframe.Dataframe
                name (1,1) string {mustBeNonzeroLengthText}
            end

            df.toPy.createOrReplaceTempView(name);
        end

        function DF = sample(df, fraction, options)
            % sample Create a temporary view

            arguments (Input)
                df (1,1) matlab.pyspark.sql.dataframe.Dataframe
                fraction (1,1) double {mustBePositive, mustBeLessThan(fraction, 1.0)}
                options.seed (1,1) int64
                options.withReplacement (1,1) logical = false
            end
            arguments (Output)
                DF (1,1) matlab.pyspark.sql.dataframe.Dataframe
            end

            if isfield(options, 'seed')
                pyDF = df.toPy.sample(fraction=fraction, withReplacement=options.withReplacement, seed=options.seed );
            else
                pyDF = df.toPy.sample(fraction=fraction, withReplacement=options.withReplacement );
            end
            DF = matlab.pyspark.sql.dataframe.Dataframe(pyDF);

        end

        function DFNA = na(df)
            % na Get na object

            arguments (Input)
                df (1,1) matlab.pyspark.sql.dataframe.Dataframe
            end
            arguments (Output)
                DFNA (1,1) matlab.pyspark.sql.dataframe.DataFrameNaFunctions
            end

            DFNA = matlab.pyspark.sql.dataframe.DataFrameNaFunctions(df.toPy.na);

        end

        function DF = dropna(df, options)
            % dropna Drop rows with NULL or NaN values
            arguments (Input)
                df (1,1) matlab.pyspark.sql.dataframe.Dataframe
                options.how (1,1) string = 'any'
                options.thresh int64
                options.subset
            end
            arguments (Output)
                DF (1,1) matlab.pyspark.sql.dataframe.Dataframe
            end

            args = {'how', options.how};
            if isfield(options, 'thresh')
                args{end+1} = 'thresh';
                args{end+1} = options.thresh;
            end
            if isfield(options, 'subset')
                args{end+1} = 'subset';
                args(end+1) = {matlab.pyspark.internal.unifyStringArguments(options.subset)};
            end
            
            DF = matlab.pyspark.sql.dataframe.Dataframe(df.toPy.dropna(pyargs(args{:})));
        end
    end

    methods (Hidden)
        T = table_R2023b(obj)

        function OUT = bracket(obj, arg)
            % bracket Implement the df[arg] method
            %
            % This function is not targeted at general usage. It's supposed
            % to handle bracket ([]) operations in Python in MATLAB.
            % As an example:
            %   Python - df['a']
            %   MATLAB - df.bracket('a')
            %
            % Examples:
            %   % column foo
            %   DF.bracket('foo')
            %   % column foo
            %   DF.bracket("foo")
            %   % fourth column (zero-based index)
            %   DF.bracket(3)
            %
            %   % DataFrame with foo and bar columns
            %   DF.bracket({"foo", "bar"})
            %   % DataFrame with foo and bar columns
            %   DF.bracket(["foo", "bar"])
            %
            %   % DataFrame filtered through column
            %   DF.bracket(aColumn)
            %   % DataFrame filtered through column
            %   DF.bracket(DF.bracket("foo").isin("3", "4"))
            
            % From the Spark documentation:
            % Returns
            %
            %     Column or DataFrame, a specified column, or a filtered or
            %     projected dataframe. 
            %
            %             If the input item is an int or str, the output is a Column.
            %
            %             If the input item is a Column, the output is a DataFrame
            %                 filtered by this given Column.
            %
            %             If the input item is a list or tuple, the output is a DataFrame
            %                 projected by this given list or tuple.
            %
            
            arguments (Input)
                obj (1,1) matlab.pyspark.sql.dataframe.Dataframe
                arg
            end
            switch class(arg)
                case 'char'
                    % Output is a column
                    pyCmd = sprintf("out = df['%s']", arg);
                    OUT = matlab.pyspark.sql.column.Column(...
                        pyrun(pyCmd, "out", df=obj.toPy));

                case 'string'
                    if isscalar(arg)
                        pyCmd = sprintf("out = df['%s']", arg);
                        OUT = matlab.pyspark.sql.column.Column(...
                            pyrun(pyCmd, "out", df=obj.toPy));
                    else
                        pyCmd = sprintf("out = df[['%s']]", join(arg, "', '"));
                        OUT = matlab.pyspark.sql.dataframe.Dataframe(...
                            pyrun(pyCmd, "out", df=obj.toPy));
                    end
                case {'double', 'single', 'int64', 'int32', 'int16', 'int8'}
                    pyCmd = sprintf("out = df[%d]", int64(arg));
                    OUT = matlab.pyspark.sql.column.Column(...
                        pyrun(pyCmd, "out", df=obj.toPy));
                case 'cell'
                    pyCmd = sprintf("out = df[['%s']]", join(string(arg), "', '"));
                    OUT = matlab.pyspark.sql.dataframe.Dataframe(...
                        pyrun(pyCmd, "out", df=obj.toPy));
                case "matlab.pyspark.sql.column.Column"
                    OUT = matlab.pyspark.sql.dataframe.Dataframe(...
                        pyrun("out = df[tmpArg]", "out", df=obj.toPy, tmpArg=arg.toPy));
                case "py.pyspark.sql.connect.column.Column"
                    OUT = matlab.pyspark.sql.dataframe.Dataframe(...
                        pyrun("out = df[tmpArg]", "out", df=obj.toPy, tmpArg=arg));
                otherwise
                    error("sparkapi:bad_bracket_argument", ...
                        "The DataFrame bracket method does not take arguments of type '%s'.", class(arg));
            end
        end
    end

    methods (Access=protected)
        function varargout = dotReference(obj,indexOp)
            N = numel(indexOp);

            colOrDF = obj.bracket(indexOp(1).Name);
            curIdx = 2;
            while curIdx <= N
                if indexOp(curIdx).Type == "Dot"
                    if curIdx < N
                        if indexOp(curIdx+1).Type == "Paren"
                            fName = indexOp(curIdx).Name;
                            args = indexOp(curIdx+1).Indices;
                            colOrDF = feval(fName, colOrDF, args{:});
                            curIdx = curIdx + 2;
                        else
                            % There is no paren, just "dot it"
                            colOrDF = colOrDF.(indexOp(curIdx).Name);
                            curIdx = curIdx + 1;
                        end
                    else
                        % There is no paren, just "dot it"
                        colOrDF = colOrDF.(indexOp(curIdx).Name);
                        curIdx = curIdx + 1;
                    end
                else
                    error('sparkapi:dataframe_bracket_restrictions', ...
                        "The bracket method for Dataframe can currently only support " + ...
                        "chaining of dot-operations, not parens or curly braces.")
                end

            end % while loop
            [varargout{1:nargout}] = colOrDF;
        end

        function obj = dotAssign(obj,indexOp,varargin) %#ok<INUSD>
            error('sparkapi:dataframeassign', ...
                'Values cannot be assigned to a Dataframe.');
        end
        
        function n = dotListLength(obj,indexOp,indexContext) %#ok<INUSD>
            % Assuming our methods will always return a value
            n = 1;
            % n = listLength(obj.AddedFields,indexOp,indexContext);
        end
    end


    methods (Hidden)

        function tf = getSetUseToArrow(obj, useToArrowValue)
        % Call getSetUseToArrow with a scalar logical value as the input
        % argument to control whether DataFrame/table() uses
        % arrow-based or pandas-based approach to import the Spark 
        % DataFrame as a MATLAB table.
        %
        % Call getSetUseToArrow without an input argument to query the
        % whether DataFrame/table() will use the arrow-based approach.
        %
        % NOTE: DataFrame/getSetUseToArrow(useToArrowValue) sets a 
        % persistent variable that all DataFrame instances share.
            arguments
                obj
                useToArrowValue logical = logical.empty(0, 0)
            end
            persistent useToArrow
            if isempty(useToArrow)
                ver = string(py.getattr(obj.toPy.sparkSession, "version"));
                useToArrow = matlab.utils.SemVer(ver) >= matlab.utils.SemVer("4.0.0");
            end
            if ~isempty(useToArrowValue)
                validateattributes(useToArrowValue, "logical", "scalar");
                useToArrow = useToArrowValue;
            end
            tf = useToArrow;
        end
    end
end
