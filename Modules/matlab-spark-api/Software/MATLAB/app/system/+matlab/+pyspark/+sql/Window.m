classdef Window < handle
    % matlab.pyspark.sql.Window Window specification for DataFrame operations
    %
    % This class provides static methods to define window specifications
    % 
    % See the help for different sub-methods for examples how to use it.
    %
    % Spark doc: https://spark.apache.org/docs/latest/api/python/reference/pyspark.sql/window.html

    % Copyright 2026 MathWorks, Inc.

    methods (Static)
        
        function windowSpec = orderBy(arg)
            % orderBy
            %
            % import matlab.pyspark.sql.Window
            % df = spark.createDataFrame('[(1, "a"), (1, "a"), (2, "a"), (1, "b"), (2, "b"), (3, "b")]', ...
            %    schema=["id", "category"])
            % df.show()
            % window = Window.partitionBy("id").orderBy("category")
            % df.withColumn("row_number", matlab.pyspark.sql.functions.row_number().over(window)).show()

            arguments (Input, Repeating)
                arg {matlab.pyspark.internal.mustBeColType}
            end
            arguments (Output)
                windowSpec (1,1) matlab.pyspark.sql.WindowSpec
            end

            arg = matlab.pyspark.internal.unifyColArguments(arg);

            pyWin = py.pyspark.sql.Window();
            windowSpec = pyWin.orderBy(arg{:});
        end

        function windowSpec = partitionBy(arg)
            % partitionBy
            %
            % import matlab.pyspark.sql.Window
            % df = spark.createDataFrame('[(1, "a"), (1, "a"), (2, "a"), (1, "b"), (2, "b"), (3, "b")]', ...
            %    schema=["id", "category"])
            % df.show()
            % window = Window.partitionBy("category").orderBy("id")
            % df.withColumn("row_number", matlab.pyspark.sql.functions.row_number().over(window)).show()

            arguments (Input, Repeating)
                arg {matlab.pyspark.internal.mustBeColType}
            end
            arguments (Output)
                windowSpec (1,1) matlab.pyspark.sql.WindowSpec
            end

            arg = matlab.pyspark.internal.unifyColArguments(arg);

            pyWin = py.pyspark.sql.Window();
            windowSpec = pyWin.partitionBy(arg{:});
        end

        function windowSpec = rangeBetween(start_, end_)
            % rangeBetween
            %
            % import matlab.pyspark.sql.Window
            % df = spark.createDataFrame('[(1, "a"), (1, "a"), (2, "a"), (1, "b"), (2, "b"), (3, "b")]', ...
            %    schema=["id", "category"])
            % df.show()
            % window = Window.partitionBy("category").orderBy("id").rangeBetween(Window.currentRow, 1)
            % df.withColumn("sum", matlab.pyspark.sql.functions.sum("id").over(window)).sort("id", "category").show()

            arguments (Input)
                start_ (1,1) int64
                end_ (1,1) int64
            end
            arguments (Output)
                windowSpec (1,1) matlab.pyspark.sql.WindowSpec
            end

            pyWin = py.pyspark.sql.Window();
            windowSpec = pyWin.rangeBetween(start_, end_);
        end
        
        function windowSpec = rowsBetween(start_, end_)
            % rowsBetween
            %
            % import matlab.pyspark.sql.Window
            % df = spark.createDataFrame('[(1, "a"), (1, "a"), (2, "a"), (1, "b"), (2, "b"), (3, "b")]', ...
            %    schema=["id", "category"])
            % df.show()
            % window = Window.partitionBy("category").orderBy("id").rowsBetween(Window.currentRow, 1)
            % df.withColumn("sum", matlab.pyspark.sql.functions.sum("id").over(window)).sort("id", "category", "sum").show()
            arguments (Input)
                start_ (1,1) int64
                end_ (1,1) int64
            end
            arguments (Output)
                windowSpec (1,1) matlab.pyspark.sql.WindowSpec
            end

            pyWin = py.pyspark.sql.Window();
            windowSpec = pyWin.rowsBetween(start_, end_);
        end

        function bNum = currentRow()
            arguments (Output)
                bNum (1,1) int64
            end

            bNum = pyrun("n = w.currentRow", "n", w=py.pyspark.sql.Window());            
        end

        function bNum = unboundedFollowing()
            arguments (Output)
                bNum (1,1) int64
            end

            bNum = pyrun("n = w.unboundedFollowing", "n", w=py.pyspark.sql.Window());            
        end

        function bNum = unboundedPreceding()
            arguments (Output)
                bNum (1,1) int64
            end

            bNum = pyrun("n = w.unboundedPreceding", "n", w=py.pyspark.sql.Window());            
        end
    end
end