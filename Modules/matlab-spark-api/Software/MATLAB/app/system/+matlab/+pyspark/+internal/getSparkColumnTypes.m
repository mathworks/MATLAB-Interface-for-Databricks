function OUT = getSparkColumnTypes(df, options)
    % getSparkColumnTypes Get column types from dataframe

    % Copyright 2024 MathWorks, Inc.

    arguments
        df (1,1) matlab.pyspark.sql.dataframe.Dataframe
        options.format {mustBeMember(options.format, {'types', 'dict'})} = 'types'
    end

    t1 = cell(df.limit(2).toPy.dtypes);
    % t1 = cell(df.toPy.dtypes);

    t2 = cellfun(@cell, t1, 'UniformOutput',false);

    
    t3 = [t2{:}];

    t4 = string(t3);

    N = numel(t4);

    t5 = reshape(t4, 2,N/2)';

    switch options.format
        case 'types'
            OUT = t5(:,2);
        case 'dict'
            types = t5(:,2);
            names = t5(:,1);
            OUT = dictionary(names, types);
   end
end