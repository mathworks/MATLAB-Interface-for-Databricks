function newCol = rand(seed)
    % RAND Generates a random column with independent and identically distributed (i.i.d.) samples uniformly distributed in [0.0, 1.0)
    %
    % seed: Seed value for the random generator. Type int (default: py.None)
    %
    % Examples:
    %
    %   % Generate a random column without a seed
    %   spark.range(0, 2, 1, 1).select("*", matlab.pyspark.sql.functions.rand()).show()
    %   +---+-------------------------+
    %   | id|rand(2945648544237839087)|
    %   +---+-------------------------+
    %   |  0|     0.010911550817409243|
    %   |  1|      0.08416790182034217|
    %   +---+-------------------------+
    %
    %   % Generate a random column with a specific seed
    %   spark.range(0, 2, 1, 1).select("*", matlab.pyspark.sql.functions.rand(int64(42))).show()
    %   +---+-------------------+
    %   | id|           rand(42)|
    %   +---+-------------------+
    %   |  0|0.08575559529546095|
    %   |  1|0.31041139572710486|
    %   +---+-------------------+

    % Copyright 2026 MathWorks, Inc.

    arguments (Input)
        seed (1,1) = py.None
    end

    arguments (Output)
        newCol (1,1) matlab.pyspark.sql.column.Column
    end

    if seed ~= py.None
        if ~isa(seed, 'int64')
             error('PYSPARK:RAND:SEEDTYPE', "Unsupported data type: %s, expected int64 or py.None", class(seed));
        end
    end

    newCol = py.pyspark.sql.functions.rand(seed);
end