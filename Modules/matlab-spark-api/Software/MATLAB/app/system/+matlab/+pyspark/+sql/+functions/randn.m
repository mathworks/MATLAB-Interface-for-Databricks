function newCol = randn(seed)
    % RANDN Generates a random column with independent and identically distributed (i.i.d.) samples from the standard normal distribution
    %
    % seed: Seed value for the random generator.
    % The seed must be >=0 and convertible to an int64 or a py.None value.
    %
    % Examples:
    %
    %   % Generate a random column without a seed
    %   spark.range(0, 2, 1, 1).select("*", matlab.pyspark.sql.functions.randn()).show()
    %   +---+-------------------------+
    %   | id|randn(853313695792000437)|
    %   +---+-------------------------+
    %   |  0|      -1.1194552753031792|
    %   |  1|      -1.0256188858247723|
    %   +---+-------------------------+
    %
    %   % Generate a random column with a specific seed
    %   spark.range(0, 2, 1, 1).select("*", matlab.pyspark.sql.functions.randn(42)).show()
    %   +---+------------------+
    %   | id|         randn(42)|
    %   +---+------------------+
    %   |  0| 2.384479054241...|
    %   |  1|0.1920934041293...|
    %   +---+------------------+

    % Copyright 2026 MathWorks, Inc.

    arguments (Input)
        seed (1,1) = py.None
    end

    arguments (Output)
        newCol (1,1) matlab.pyspark.sql.column.Column
    end

    if seed ~= py.None
        if ~isempty(seed) && isnumeric(seed) && isreal(seed) && isfinite(seed) && ge(seed, 0)
            seed = int64(seed);
        else
            error('PYSPARK:RANDSTR:SEEDTYPE', "Unsupported seed type: %s, expected castable to int64 or py.None", class(seed));
        end
    end

    newCol = py.pyspark.sql.functions.randn(seed);
end