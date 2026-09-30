classdef DataFrameNaFunctions < matlab.pyspark.internal.PyWrapper
    % DataFrameNaFunctions Pyspark DataFrameNaFunctions wrapper

    % (c) 2024 MathWorks, Inc.

    properties (Hidden)
        na
    end

    methods
        function obj = DataFrameNaFunctions(naObj)
            obj.na = naObj;
        end

        function pyObj = toPy(obj)
            pyObj = obj.na;
        end

        function DF = drop(na, options)
            % drop Drop rows

            arguments (Input)
                na (1,1) matlab.pyspark.sql.dataframe.DataFrameNaFunctions
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
            DF = matlab.pyspark.sql.dataframe.Dataframe(na.toPy.drop(pyargs(args{:})));
        end

        function DF = fill(na, value, options)
            % fill Fill columns with default value
            %
            %  df is some table with missing double values in Customers
            %  column. Fill them with 0.0 like this:
            %    df2 = df.na.fill(0.0, subset="Customers")
            arguments (Input)
                na (1,1) matlab.pyspark.sql.dataframe.DataFrameNaFunctions
                value
                options.subset
            end
            arguments (Output)
                DF (1,1) matlab.pyspark.sql.dataframe.Dataframe
            end

            if isfield(options, 'subset')
                args = {'subset', matlab.pyspark.internal.unifyStringArguments(options.subset)};
            else
                args = {};
            end
            DF = matlab.pyspark.sql.dataframe.Dataframe(na.toPy.fill(value, pyargs(args{:})));
        end

    end
end