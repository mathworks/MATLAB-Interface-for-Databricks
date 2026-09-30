function DF = agg(obj, arg)
    % agg Aggregation method
    %
    % TODO: Currently only support columns, not dictionary

    % Copyright 2024 MathWorks, Inc.

    arguments (Input)
        obj (1,1) matlab.pyspark.sql.dataframe.Dataframe
    end
    arguments (Input, Repeating)
        arg {matlab.pyspark.internal.mustBeColType}
    end
    arguments (Output)
        DF (1,1) matlab.pyspark.sql.dataframe.Dataframe
    end

    arg = matlab.pyspark.internal.unifyColArguments(arg);

    DF = matlab.pyspark.sql.dataframe.Dataframe(obj.toPy.agg(arg{:}));

end 

