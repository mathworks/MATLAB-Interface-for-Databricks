function dataframe = load(obj, rPath, arg)
    % LOAD Method to load the input in as a Dataframe / Dataset
    % The input datasource in as a dataframe / dataset.
    %
    % This can be used in 3 ways:
    %
    %   df = dfr.load("some/path")
    %
    %   df = dfr.load("some/path", "<some_format>") % Default, parquet
    %
    %   df = dfr.load("some/path", "<some_format>", "<some_schema>") 
    %   % Schema in DDL string format
    %
    % Please refer to corresponding pyspark documentation

    % Copyright 2024 MathWorks, Inc.

    arguments (Input)
        obj (1,1) matlab.pyspark.sql.readwriter.DataFrameReader
        rPath (1,1) string
    end
    arguments (Input, Repeating)
        arg (1,1) string
    end
    arguments (Output)
        dataframe (1,1) matlab.pyspark.sql.dataframe.Dataframe
    end

    
    narginchk(2,4);

    if nargin == 2
        % load(path)
        df = obj.toPy.load(rPath);
    elseif nargin == 3
        % load(path, format)
        df = obj.toPy.load(rPath, arg{1});
    elseif nargin == 4
        % load(path, format, schema)
        df = obj.toPy.load(rPath, arg{1}, arg{2});
    end

    dataframe = matlab.pyspark.sql.dataframe.Dataframe(df);
end %function
