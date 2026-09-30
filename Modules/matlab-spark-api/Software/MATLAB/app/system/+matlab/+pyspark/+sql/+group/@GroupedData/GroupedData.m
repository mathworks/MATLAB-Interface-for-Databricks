classdef GroupedData < matlab.pyspark.internal.PyWrapper
    % GroupedData

    % (c) 2024 MathWorks, Inc.
    properties
        groupeddata
    end

    methods
        function obj = GroupedData(gd)
            if nargin ~= 0
                obj.groupeddata = gd;
            end
        end

        function pyObj = toPy(obj)
            pyObj = obj.groupeddata;
        end

        function DF = agg(obj, expr)
            arguments (Input)
                obj (1,1) matlab.pyspark.sql.group.GroupedData
            end
            arguments (Input, Repeating)
                expr  {matlab.pyspark.internal.mustBeColDictType}
            end
            arguments (Output)
                DF (1,1) matlab.pyspark.sql.dataframe.Dataframe
            end
            
            if isscalar(expr)
                try
                    % Try to turn this into a dictionary. If it works use
                    % it. Otherwise, try as columns
                    D = matlab.pyspark.internal.toPyDict(expr{1});
                    DF = matlab.pyspark.sql.dataframe.Dataframe(obj.toPy.agg(D));
                    return;
                catch ME
                    % Ignore this error, and try to run with columns
                end
            end

            cols = matlab.pyspark.internal.unifyColArguments(expr);
            DF = matlab.pyspark.sql.dataframe.Dataframe(obj.toPy.agg(cols{:}));
        end

        function GD = pivot(obj, col, values)
            % pivot Pivot a column of the current GroupedData
            arguments (Input)
                obj (1,1) matlab.pyspark.sql.group.GroupedData
                col (1,1) string
            end
            arguments (Input, Repeating)
                values string
            end
            arguments (Output)
                GD (1,1) matlab.pyspark.sql.group.GroupedData
            end

            values = matlab.pyspark.internal.unifyStringArguments(values);

            if isempty(values)
                GD = matlab.pyspark.sql.group.GroupedData(obj.toPy.pivot(col));
            else
                GD = matlab.pyspark.sql.group.GroupedData(obj.toPy.pivot(col, py.list(values)));
            end
        end
    end

end