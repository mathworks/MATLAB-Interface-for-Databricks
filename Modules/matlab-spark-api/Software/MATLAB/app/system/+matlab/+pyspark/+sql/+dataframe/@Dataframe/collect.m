function result = collect(obj)
    % COLLECT Returns all the records in the DataFrame as a matlab.pyspark.sql.row.Row or array of matlab.pyspark.sql.row.Row
    %
    % Examples:
    %   % Collecting all rows of a DataFrame
    %   df = spark.createDataFrame(py.str('[(14, "Tom"), (23, "Alice"), (16, "Bob")]'), schema=["age", "name"]);
    %   df.collect()
    %   [Row(age=14, name='Tom'), Row(age=23, name='Alice'), Row(age=16, name='Bob')]
    %
    %
    %   % Collecting all rows after filtering
    %   df = spark.createDataFrame(py.str('[(14, "Tom"), (23, "Alice"), (16, "Bob")]'), schema=["age", "name"]);
    %   df.filter(df.age > 15).collect()
    %   [Row(age=23, name='Alice'), Row(age=16, name='Bob')]
    %
    %
    %   % Collecting all rows after selecting specific columns
    %   df = spark.createDataFrame(py.str('[(14, "Tom"), (23, "Alice"), (16, "Bob")]'), schema=["age", "name"]);
    %   df.select("name").collect()
    %   [Row(name='Tom'), Row(name='Alice'), Row(name='Bob')]
    %
    %
    %   % Collecting all rows from a DataFrame and converting a specific
    %   % column to a cell array
    %   df = spark.createDataFrame(py.str('[(14, "Tom"), (23, "Alice"), (16, "Bob")]'), schema=["age", "name"]);
    %   rows = df.collect()
    %   rows.bracket("name")    % Equivalent to: [row["name"] for row in rows]
    %   ans =
    %       1x3 cell array
    %       {'Tom'}    {'Alice'}    {'Bob'}
    %
    %
    %   % Collecting all rows after applying a function to a column
    %   df = spark.createDataFrame(py.str('[(14, "Tom"), (23, "Alice"), (16, "Bob")]'), schema=["age", "name"]);
    %   df.select(matlab.pyspark.sql.functions.upper(df.name)).collect()
    %   [Row(upper(name)='TOM'), Row(upper(name)='ALICE'), Row(upper(name)='BOB')]
    %
    %
    %   % Collecting all rows from a DataFrame and converting to a list of dictionaries
    %   df = spark.createDataFrame(py.str('[(14, "Tom"), (23, "Alice"), (16, "Bob")]'), schema=["age", "name"]);
    %   rows = df.collect()
    %   for n = 1:numel(rows)
    %       d{n} = rows(n).asMATLABDict();
    %   end
    %
    % See also: https://spark.apache.org/docs/latest/api/python/reference/pyspark.sql/api/pyspark.sql.DataFrame.collect.html
    
    % Copyright 2026 The MathWorks Inc.

    arguments (Input)
        obj matlab.pyspark.sql.dataframe.Dataframe
    end
    arguments (Output)
        result matlab.pyspark.sql.row.Row
    end

    resultPy = obj.toPy.collect();
    
    cellPy = cell(resultPy);
    
    % Do not expect a matrix result
    assert(isempty(cellPy) || isscalar(cellPy) || isvector(cellPy),...
        "SPARKAPI:unexpected_collect_py_size",...
        "Expected a py.list to be empty scalar or a vector.");

    % Returns an array of matlab.pyspark.sql.row.Row
    if isMATLABReleaseOlderThan("R2024a")
        result(1, numel(cellPy)) = matlab.pyspark.sql.row.Row;
    else        
        result = createArray([1, numel(cellPy)], "matlab.pyspark.sql.row.Row");
    end
    
    for n = 1:numel(cellPy)
        result(1, n) = matlab.pyspark.sql.row.Row(cellPy{n});
    end
end