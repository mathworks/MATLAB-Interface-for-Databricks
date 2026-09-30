function newCol = randstr(length, seed)
    % RANDSTR Returns a string of the specified length
    % Characters are chosen uniformly at random from the following pool of
    % characters: 0-9, a-z, A-Z. The random seed is optional. The string length
    % must be a constant two-byte or four-byte integer (SMALLINT or INT, respectively).
    % seed: Seed value for the randstrom generator.
    % Requires Spark v4.0.0 or greater, Databricks runtime 17 or greater.
    %
    % The seed must be >=0 and convertible to an int64 or a py.None value.
    %
    % Example:
    %   spark.range(0, 10, 1, 1).select(matlab.pyspark.sql.functions.randstr(16, 3)).show()
    %   +----------------+
    %   |  randstr(16, 3)|
    %   +----------------+
    %   |gIcaEIuILGwIrJmM|
    %   |Sxj3fhV9FZVeR0xw|
    %   |WBo50u89BpiQd3Lj|
    %   |ZnyhvrOFmZlj5X3v|
    %   |t9d0aJIROeG45HqP|
    %   |qPkK8U962WxJkZWN|
    %   |VzRToVzZoi3mzjWf|
    %   |C23JzJwpnjIxUzAR|
    %   |NjJsoRnwxM20GqM9|
    %   |XKnYaJOjVXuf5iIo|
    %   +----------------+

    % Copyright 2026 MathWorks, Inc.

    arguments (Input)
        length (1,1) {mustBeNumeric, mustBeFinite, mustBeReal, mustBeNonempty, mustBeNonnegative}
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

    newCol = py.pyspark.sql.functions.randstr(py.int(int32(length)), seed);
end