classdef Column < matlab.pyspark.internal.PyWrapper
    % Column - A pyspark column

    % (c) 2024-2026 MathWorks, Inc.

    properties (Hidden, SetAccess=private)
        column
        Label_ string = string.empty
    end

    properties (Dependent=true)
        Label string
    end

    methods
        function obj = Column(col)
            arguments (Input)
                col
            end
            obj.column = col;
        end

        function C = isin(obj, cols)
            % isin - Column of booleans showing whether each element in the Column is contained in cols
            arguments (Input)
                obj (1,1) matlab.pyspark.sql.column.Column
            end
            arguments (Input, Repeating)
                cols
            end
            arguments (Output)
                C (1,1) matlab.pyspark.sql.column.Column
            end
            arg = matlab.pyspark.internal.unifyColArguments(cols);
            C = matlab.pyspark.sql.column.Column(obj.toPy.isin(arg{:}));
        end

        function str = string(obj)
            arguments (Input)
                obj (1,1) matlab.pyspark.sql.column.Column
            end
            arguments (Output)
                str string
            end
            str = string(py.str(obj.toPy));
        end

        function C = asc(obj)
            % asc - Ascending sort of column
            arguments (Input)
                obj (1,1) matlab.pyspark.sql.column.Column
            end
            arguments (Output)
                C (1,1) matlab.pyspark.sql.column.Column
            end
            C = matlab.pyspark.sql.column.Column(obj.toPy.asc());
        end

        function C = asc_nulls_first(obj)
            % asc_nulls_first - Ascending sort of column
            arguments (Input)
                obj (1,1) matlab.pyspark.sql.column.Column
            end
            arguments (Output)
                C (1,1) matlab.pyspark.sql.column.Column
            end
            C = matlab.pyspark.sql.column.Column(obj.toPy.asc_nulls_first());
        end

        function C = asc_nulls_last(obj)
            % asc_nulls_last - Ascending sort of column
            arguments (Input)
                obj (1,1) matlab.pyspark.sql.column.Column
            end
            arguments (Output)
                C (1,1) matlab.pyspark.sql.column.Column
            end
            C = matlab.pyspark.sql.column.Column(obj.toPy.asc_nulls_last());
        end

        function C = desc(obj)
            % desc - Descending sort of column
            arguments (Input)
                obj (1,1) matlab.pyspark.sql.column.Column
            end
            arguments (Output)
                C (1,1) matlab.pyspark.sql.column.Column
            end
            C = matlab.pyspark.sql.column.Column(obj.toPy.desc());
        end

        function C = desc_nulls_first(obj)
            % desc_nulls_first - Descending sort of column
            arguments (Input)
                obj (1,1) matlab.pyspark.sql.column.Column
            end
            arguments (Output)
                C (1,1) matlab.pyspark.sql.column.Column
            end
            C = matlab.pyspark.sql.column.Column(obj.toPy.desc_nulls_first());
        end

        function C = desc_nulls_last(obj)
            % desc_nulls_last - Descending sort of column
            arguments (Input)
                obj (1,1) matlab.pyspark.sql.column.Column
            end
            arguments (Output)
                C (1,1) matlab.pyspark.sql.column.Column
            end
            C = matlab.pyspark.sql.column.Column(obj.toPy.desc_nulls_last());
        end

        function C = astype(obj, castType)
            % astype - Sames as cast
            arguments (Input)
                obj (1,1) matlab.pyspark.sql.column.Column
                castType (1,1) string
            end
            arguments (Output)
                C (1,1) matlab.pyspark.sql.column.Column
            end
            C = matlab.pyspark.sql.column.Column(obj.column.astype(castType));
        end

        function C = isNull(obj)
            % isNull
            C = matlab.pyspark.sql.column.Column(obj.toPy.isNull());
        end

        function C = isNotNull(obj)
            % isNotNull
            C = matlab.pyspark.sql.column.Column(obj.toPy.isNotNull());
        end

        function C = isNaN(obj)
            % isNaN
            C = matlab.pyspark.sql.column.Column(obj.toPy.isNaN());
        end

        function C = bitwiseAND(obj, other)
            % bitwiseAND
            arguments
                obj   (1,1) matlab.pyspark.sql.column.Column
                other (1,1) matlab.pyspark.sql.column.Column
            end
            C = matlab.pyspark.sql.column.Column(obj.toPy.bitwiseAND(other.toPy));
        end

        function C = bitwiseOR(obj, other)
            % bitwiseOR
            arguments
                obj   (1,1) matlab.pyspark.sql.column.Column
                other (1,1) matlab.pyspark.sql.column.Column
            end
            C = matlab.pyspark.sql.column.Column(obj.toPy.bitwiseOR(other.toPy));
        end

        function C = bitwiseXOR(obj, other)
            % bitwiseXOR
            arguments
                obj   (1,1) matlab.pyspark.sql.column.Column
                other (1,1) matlab.pyspark.sql.column.Column
            end
            C = matlab.pyspark.sql.column.Column(obj.toPy.bitwiseXOR(other.toPy));
        end

        function C = startswith(obj, other)
            % startswith
            arguments
                obj   (1,1) matlab.pyspark.sql.column.Column
                other (1,1) matlab.pyspark.sql.column.Column
            end
            C = matlab.pyspark.sql.column.Column(obj.toPy.startswith(other.toPy));
        end

        function C = endswith(obj, other)
            % endswith
            arguments
                obj   (1,1) matlab.pyspark.sql.column.Column
                other (1,1) matlab.pyspark.sql.column.Column
            end
            C = matlab.pyspark.sql.column.Column(obj.toPy.endswith(other.toPy));
        end

        function C = between(obj, lowerBound, upperBound)
            % between
            arguments
                obj   (1,1) matlab.pyspark.sql.column.Column
                lowerBound (1,1) matlab.pyspark.sql.column.Column
                upperBound (1,1) matlab.pyspark.sql.column.Column
            end
            C = matlab.pyspark.sql.column.Column(obj.toPy.between(lowerBound.toPy, upperBound.toPy));
        end

        function C = contains(obj, other)
            % contains
            arguments
                obj   (1,1) matlab.pyspark.sql.column.Column
                other (1,1) matlab.pyspark.sql.column.Column
            end
            C = matlab.pyspark.sql.column.Column(obj.toPy.contains(other.toPy));
        end

        function C = like(obj, likeStr)
            % like SQL like command
            arguments
                obj   (1,1) matlab.pyspark.sql.column.Column
                likeStr (1,1) string
            end
            C = matlab.pyspark.sql.column.Column(obj.toPy.like(likeStr));
        end

        function C = ilike(obj, likeStr)
            % ilike SQL ilike command
            arguments
                obj   (1,1) matlab.pyspark.sql.column.Column
                likeStr (1,1) string
            end
            C = matlab.pyspark.sql.column.Column(obj.toPy.ilike(likeStr));
        end

        function C = rlike(obj, likeStr)
            % rlike SQL rlike command
            arguments
                obj   (1,1) matlab.pyspark.sql.column.Column
                likeStr (1,1) string
            end
            C = matlab.pyspark.sql.column.Column(obj.toPy.rlike(likeStr));
        end

        function pyObj = toPy(obj)
            pyObj = obj.column;
        end

        % Operation overloads
        % .*
        function col = times(obj, other)
            arguments
                obj   (1,1) matlab.pyspark.sql.column.Column
                other (1,1) matlab.pyspark.sql.column.Column
            end
            col = matlab.pyspark.sql.column.Column(pyrun("col = c1 * c2", "col", c1=obj.toPy, c2=other.toPy));
        end

        % *
        function col = mtimes(obj, other)
            arguments
                obj   (1,1) matlab.pyspark.sql.column.Column
                other (1,1) matlab.pyspark.sql.column.Column
            end
            col = matlab.pyspark.sql.column.Column(pyrun("col = c1 * c2", "col", c1=obj.toPy, c2=other.toPy));
        end

        % ./
        function col = rdivide(obj, other)
            arguments
                obj   (1,1) matlab.pyspark.sql.column.Column
                other (1,1) matlab.pyspark.sql.column.Column
            end
            col = matlab.pyspark.sql.column.Column(pyrun("col = c1 / c2", "col", c1=obj.toPy, c2=other.toPy));
        end

        % /
        function col = mrdivide(obj, other)
            arguments
                obj   (1,1) matlab.pyspark.sql.column.Column
                other (1,1) matlab.pyspark.sql.column.Column
            end
            col = matlab.pyspark.sql.column.Column(pyrun("col = c1 / c2", "col", c1=obj.toPy, c2=other.toPy));
        end
        % - unary
        function col = uminus(obj)
            arguments
                obj   (1,1) matlab.pyspark.sql.column.Column
            end
            col = matlab.pyspark.sql.column.Column(pyrun("col = -c1", "col", c1=obj.toPy));
        end

        function col = minus(obj, other)
            arguments
                obj   (1,1) matlab.pyspark.sql.column.Column
                other (1,1) matlab.pyspark.sql.column.Column
            end
            col = matlab.pyspark.sql.column.Column(pyrun("col = c1 - c2", "col", c1=obj.toPy, c2=other.toPy));
        end

        function col = plus(obj, other)
            arguments
                obj   (1,1) matlab.pyspark.sql.column.Column
                other (1,1) matlab.pyspark.sql.column.Column
            end
            col = matlab.pyspark.sql.column.Column(pyrun("col = c1 + c2", "col", c1=obj.toPy, c2=other.toPy));
        end

        function col = divide(obj, other)
            arguments
                obj   (1,1) matlab.pyspark.sql.column.Column
                other (1,1) matlab.pyspark.sql.column.Column
            end
            col = matlab.pyspark.sql.column.Column(pyrun("col = c1 / c2", "col", c1=obj.toPy, c2=other.toPy));
        end

        function col = multiply(obj, other)
            arguments
                obj   (1,1) matlab.pyspark.sql.column.Column
                other (1,1) matlab.pyspark.sql.column.Column
            end
            col = matlab.pyspark.sql.column.Column(pyrun("col = c1 * c2", "col", c1=obj.toPy, c2=other.toPy));
        end

        function col = and(obj, other)
            arguments
                obj   (1,1) matlab.pyspark.sql.column.Column
                other (1,1) matlab.pyspark.sql.column.Column
            end
            col = matlab.pyspark.sql.column.Column(pyrun("col = c1 & c2", "col", c1=obj.toPy, c2=other.toPy));
        end

        function col = or(obj, other)
            arguments
                obj   (1,1) matlab.pyspark.sql.column.Column
                other (1,1) matlab.pyspark.sql.column.Column
            end
            col = matlab.pyspark.sql.column.Column(pyrun("col = c1 | c2", "col", c1=obj.toPy, c2=other.toPy));
        end

        function col = ge(obj, other)
            arguments
                obj   (1,1) matlab.pyspark.sql.column.Column
                other (1,1) matlab.pyspark.sql.column.Column
            end
            col = matlab.pyspark.sql.column.Column(pyrun("col = c1 >= c2", "col", c1=obj.toPy, c2=other.toPy));
        end

        function col = gt(obj, other)
            arguments
                obj   (1,1) matlab.pyspark.sql.column.Column
                other (1,1) matlab.pyspark.sql.column.Column
            end
            col = matlab.pyspark.sql.column.Column(pyrun("col = c1 > c2", "col", c1=obj.toPy, c2=other.toPy));
        end

        function col = le(obj, other)
            arguments
                obj   (1,1) matlab.pyspark.sql.column.Column
                other (1,1) matlab.pyspark.sql.column.Column
            end
            col = matlab.pyspark.sql.column.Column(pyrun("col = c1 <= c2", "col", c1=obj.toPy, c2=other.toPy));
        end

        function col = lt(obj, other)
            arguments
                obj   (1,1) matlab.pyspark.sql.column.Column
                other (1,1) matlab.pyspark.sql.column.Column
            end
            col = matlab.pyspark.sql.column.Column(pyrun("col = c1 < c2", "col", c1=obj.toPy, c2=other.toPy));
        end

        function col = eq(obj, other)
            arguments
                obj   (1,1) matlab.pyspark.sql.column.Column
                other (1,1) matlab.pyspark.sql.column.Column
            end
            col = matlab.pyspark.sql.column.Column(pyrun("col = c1 == c2", "col", c1=obj.toPy, c2=other.toPy));
        end

        function col = ne(obj, other)
            arguments
                obj   (1,1) matlab.pyspark.sql.column.Column
                other (1,1) matlab.pyspark.sql.column.Column
            end
            col = matlab.pyspark.sql.column.Column(pyrun("col = c1 != c2", "col", c1=obj.toPy, c2=other.toPy));
        end

        function col = not(obj)
            arguments
                obj   (1,1) matlab.pyspark.sql.column.Column
            end
            col = matlab.pyspark.sql.column.Column(pyrun("col = ~c1", "col", c1=obj.toPy));
        end

        % Unclear if there can be a not here. Maybe for logical columns
        % function col = not(obj)
        %     arguments
        %         obj   (1,1) matlab.pyspark.sql.column.Column
        %     end
        %     col = matlab.pyspark.sql.column.Column(pyrun("col = !c1", "col", c1=obj.toPy));
        % end

        function col = rem(obj, other)
            % rem Reminder of obj to other, i.e. obj % other
            %
            %  obj should be a column, and other can be a column, a number
            %  or a string
            arguments
                obj   (1,1) matlab.pyspark.sql.column.Column
                other (1,1)
            end
            if isnumeric(other)
                other = int64(other);
            elseif ischar(other) || isstring(other)
                other = "'" + string(other) + "'";
            else
                other = matlab.pyspark.internal.unifyColArguments(other);
            end
            col = matlab.pyspark.sql.column.Column(pyrun("col = c1 % c2", "col", c1=obj.toPy, c2=other));
        end

        function col = when(obj, condition, value)
            % when When condition on column
            arguments
                obj       (1,1) matlab.pyspark.sql.column.Column
                condition (1,1) matlab.pyspark.sql.column.Column
                value     (1,1)
            end

            condition = matlab.pyspark.internal.unifyColArguments(condition);
            if isa(value, 'matlab.pyspark.internal.PyWrapper')
                value = value.toPy;
            end

            col = matlab.pyspark.sql.column.Column(obj.toPy.when(condition, value));
        end

        function col = otherwise_(obj, value)
            % otherwise_ Used with when condition
            %
            % With added underscore, as otherwise is a reserved word in MATLAB
            %
            % df = spark.createDataFrame(py.str('[(2, "Alice"), (5, "Bob")]'), schema=["age", "name"]);
            % df.select(df.name, ...
            %     matlab.pyspark.sql.functions.when(df.age > 3, int32(1)).otherwise_(int32(0))).show()
            % +-----+---------------------------------------+
            % | name|CASE WHEN (age > 3.0) THEN 1 ELSE 0 END|
            % +-----+---------------------------------------+
            % |Alice|                                      0|
            % |  Bob|                                      1|
            % +-----+---------------------------------------+
            arguments (Input)
                obj   (1,1) matlab.pyspark.sql.column.Column
                value (1,1)
            end
            arguments (Output)
                col (1,1) matlab.pyspark.sql.column.Column
            end

            if isa(value, 'matlab.pyspark.internal.PyWrapper')
                value = value.toPy;
            end

            % pyrun needed as otherwise can't be used here.
            col = pyrun("newCol = col.otherwise(val)", "newCol", col=obj.toPy, val=value);
        end

        function col = over(obj, window)
            arguments (Input)
                obj (1,1) matlab.pyspark.sql.column.Column
                window (1,1) matlab.pyspark.sql.WindowSpec
            end
            arguments (Output)
                col (1,1) matlab.pyspark.sql.column.Column
            end
            col = obj.toPy.over(window.toPy);
        end
    end

    methods % Dependent properties
        function str = get.Label(obj)
            if isempty(obj.Label_)
                obj.Label_ = obj.string;
            end
            str = obj.Label_;
        end
    end
end