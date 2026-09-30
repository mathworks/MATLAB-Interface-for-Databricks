function numRows = count(obj)
    % count Counts the number of rows

    % (c) 2024 MathWorks, Inc.

    arguments (Input)
        obj (1,1) matlab.pyspark.sql.dataframe.Dataframe
    end
    arguments (Output)
        numRows (1,1) int64
    end
    pyCount = obj.toPy.count();
    if isa(pyCount, 'py.numpy.int64')
        numRows = int64(py.int(pyCount));
    else
        numRows = int64(pyCount);
    end

end
