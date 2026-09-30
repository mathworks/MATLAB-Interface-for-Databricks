function dict = asMATLABDict(obj, recursive)
    % asMATLABDict Converts the Row to a MATLAB dictionary
    % Returns a MATLAB dictionary, can recursively convert lower-level
    % rows provided they are distinct entries, e.g. not part of a
    % list or tuple. Conversion occurs regardless of whether the dictionary
    % is derived from a Row or not.
    % 
    % If called on a Row array, returns a cell array of dictionary objects.
    %
    % Examples:
    %   row = matlab.pyspark.sql.row.Row(containers.Map({'name','age'}, {"Alice", int64(11)}));
    %   d1 = row.asDict();
    %   d2 = dictionary(["age", "name"], {py.int(11), "Alice"});
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
    %   dictionary (string ⟼ cell) with 2 entries:
    %       "key"   ⟼ {[1]}
    %       "value" ⟼ {1×2 py.pyspark.sql.types.Row}
    %
    %
    %   % Return the row recursively converting rows to Python dictionaries
    %   % and converting the resulting Python dictionaries and any other
    %   % Python dictionaries found to MATLAB dictionaries
    %   d1 = row.asDict(true)
    %   d1 =
    %       dictionary (string ⟼ cell) with 2 entries:
    %       "key"   ⟼ {[1]}
    %       "value" ⟼ {[dictionary (string ⟼ cell) with 2 entries]}
    %   d2 = d1("value");
    %   d2{1}
    %   ans =
    %   dictionary (string ⟼ cell) with 2 entries:
    %       "age"  ⟼ {1×1 py.int}
    %       "name" ⟼ {["a"]}
    %
    %
    %   % Produce a dictionary that does not contain cell array based entries
    %   row = matlab.pyspark.sql.row.Row(containers.Map({'name','eyecolour'}, {"Alice", "green"}));
    %   row = 
    %   Row(eyecolour='green', name='Alice')
    %   d1 = row.asDict()
    %   d1 =
    %      dictionary (string ⟼ string) with 2 entries:
    %       "eyecolour" ⟼ "green"
    %       "name"      ⟼ "Alice"
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
        pyd = obj.toPy().asDict(recursive);
        dict = pyDictToMatDict(pyd);
    else
        dict = arrayfun(@(x) pyDictToMatDict(x.toPy.asDict(recursive)), obj, UniformOutput=false);
    end

end


function md = pyDictToMatDict(pyd)
    arguments (Input)
        pyd py.dict
    end
    arguments (Output)
        md dictionary
    end

    % MATLAB converts this level automatically
    md = dictionary(pyd);   

    ks = keys(md);
    for n = 1:numel(ks)
        key = ks(n);
        if isa(md(key), 'cell')
            value = md{key};
        else
            value = md(key);
        end

        if isa(value, "py.dict")
            md(key) = {pyDictToMatDict(value)};
        end
    end
end