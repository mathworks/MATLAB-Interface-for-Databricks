classdef WindowSpec < matlab.pyspark.internal.PyWrapper
    % matlab.pyspark.sql.WindowSpec WindowSpec specification for DataFrame operations
    %
    % This class provides methods to define WindowSpec specifications
    %
    % This class is the result of operations on Window and WindowSpec.
    % For information on how to use the different methods, look at the help
    % for the Window class.

    % Copyright 2026 MathWorks, Inc.

    properties (Hidden, SetAccess=private)
        WS (1,1)
    end
    properties
        WindowSpec_ (1,1) string = ""
    end

    methods
        function obj = WindowSpec(wsObj)
            obj.WS = wsObj;
            obj.WindowSpec_ = string(py.str(obj.toPy));
        end

        function windowSpec = orderBy(ws, arg)
            arguments (Input)
                ws (1,1) matlab.pyspark.sql.WindowSpec
            end
            arguments (Input, Repeating)
                arg {matlab.pyspark.internal.mustBeColType}
            end
            arguments (Output)
                windowSpec (1,1) matlab.pyspark.sql.WindowSpec
            end

            arg = matlab.pyspark.internal.unifyColArguments(arg);

            windowSpec = ws.toPy.orderBy(arg{:});
        end

        function windowSpec = partitionBy(ws, arg)
            arguments (Input)
                ws (1,1) matlab.pyspark.sql.WindowSpec
            end
            arguments (Input, Repeating)
                arg {matlab.pyspark.internal.mustBeColType}
            end
            arguments (Output)
                windowSpec (1,1) matlab.pyspark.sql.WindowSpec
            end

            arg = matlab.pyspark.internal.unifyColArguments(arg);

            windowSpec = ws.toPy.partitionBy(arg{:});
        end

        function windowSpec = rangeBetween(ws, start_, end_)
            arguments (Input)
                ws (1,1) matlab.pyspark.sql.WindowSpec
                start_ (1,1) int64
                end_ (1,1) int64
            end
            arguments (Output)
                windowSpec (1,1) matlab.pyspark.sql.WindowSpec
            end

            windowSpec = ws.toPy.rangeBetween(start_, end_);
        end

        function windowSpec = rowsBetween(ws, start_, end_)
            arguments (Input)
                ws (1,1) matlab.pyspark.sql.WindowSpec
                start_ (1,1) int64
                end_ (1,1) int64
            end
            arguments (Output)
                windowSpec (1,1) matlab.pyspark.sql.WindowSpec
            end

            windowSpec = ws.toPy.rowsBetween(start_, end_);
        end

        function pyObj = toPy(obj)
            pyObj = obj.WS;
        end

    end
end