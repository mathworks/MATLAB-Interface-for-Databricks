function df = describe(obj, arg)
    % describe Describe columns (statistics)

    % Copyright 2024 MathWorks, Inc.

    arguments (Input)
        obj (1,1) matlab.pyspark.sql.dataframe.Dataframe
    end
    arguments (Input, Repeating)
        arg {matlab.pyspark.internal.mustBeColType}
    end
    arguments (Output)
        df (1,1) matlab.pyspark.sql.dataframe.Dataframe
    end

    arg = matlab.pyspark.internal.unifyColArguments(arg);

    df = matlab.pyspark.sql.dataframe.Dataframe(obj.toPy.describe(arg{:}));

end 

