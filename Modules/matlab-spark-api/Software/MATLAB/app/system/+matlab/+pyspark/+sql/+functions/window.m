function newCol = window(col, windowDuration, options)
    % window Bucketize into windows

    % window(timeColumn: ColumnOrName, windowDuration: str, slideDuration: Optional[str] = None, startTime: Optional[str] = None)
    % Copyright 2024 MathWorks, Inc.


    arguments
        col (1,1) {matlab.pyspark.internal.mustBeColType}
        windowDuration (1,1) string
        options.slideDuration (1,1) string
        options.startTime (1,1) string
    end

    hasSlide = isfield(options, 'slideDuration');
    hasStart = isfield(options, 'startTime');
    col = matlab.pyspark.internal.unifyColArguments(col);

    if hasSlide
        if hasStart
            pyCol = py.pyspark.sql.functions.window(col, windowDuration, slideDuration=options.slideDuration, startTime=options.startTime);
        else
            pyCol = py.pyspark.sql.functions.window(col, windowDuration, slideDuration=options.slideDuration);
        end
    elseif hasStart
            pyCol = py.pyspark.sql.functions.window(col, windowDuration, startTime=options.startTime);        
    else
            pyCol = py.pyspark.sql.functions.window(col, windowDuration);        
    end
    newCol = matlab.pyspark.sql.column.Column(pyCol);

end %function
