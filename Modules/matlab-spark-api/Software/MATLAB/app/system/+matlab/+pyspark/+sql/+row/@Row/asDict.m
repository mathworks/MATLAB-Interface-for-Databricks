function dict = asDict(obj, recursive)
    % ASDICT Converts the Row to a Python dictionary
    % Returns a MATLAB dictionary, can recursively convert lower-level rows.
    % 
    % If called on a Row array, returns a cell array of Python dictionary objects.
    %
    % Examples:
    %   row = matlab.pyspark.sql.row.Row(containers.Map({'name','age'}, {"Alice", int64(11)}));
    %   d1 = row.asDict();
    %   d2 = py.dict(pyargs('name', "Alice", 'age', int64(11)));
    %   % d1 and d2 should be equal MATLAB dictionaries
    %   isequal(d1, d2)
    %
    %   % Nest a row in a Row in a Row
    %   rowInner = matlab.pyspark.sql.row.Row(containers.Map({'name','age'}, {"a", int64(2)}));
    %   row = matlab.pyspark.sql.row.Row({"key", "value"}, {1, rowInner})
    %   row =
    %   Row(key=1.0, value=Row(age=2, name='a'))
    %   row.asDict()
    %   ans = 
    %   Python dict with no properties.
    %       {'key': 1.0, 'value': Row(age=2, name='a')}
    %
    %   % Return the row recursively converting rows to Python dictionaries
    %   % and converting the resulting Python dictionaries and any other
    %   % Python dictionaries found to MATLAB dictionaries
    %   d1 = row.asDict(true)
    %   d1 = 
    %     Python dict with no properties.
    %       {'key': 1.0, 'value': {'age': 2, 'name': 'a'}}
    %
    %   d2 = d1{"value"}
    %   d2 = 
    %   Python dict with no properties.
    %    {'age': 2, 'name': 'a'}
    %
    %
    % See also: https://spark.apache.org/docs/latest/api/python/reference/pyspark.sql/api/pyspark.sql.Row.asDict.html

    % Copyright 2026 MathWorks, Inc.

    arguments (Input)
        obj (1,:) matlab.pyspark.sql.row.Row
        recursive (1,1) logical = false
    end
    arguments (Output)
        dict
    end

    if isscalar(obj)
        dict = obj.toPy().asDict(recursive);
    else
        dict = arrayfun(@(x) x.toPy.asDict(recursive), obj, UniformOutput=false);
    end
end
