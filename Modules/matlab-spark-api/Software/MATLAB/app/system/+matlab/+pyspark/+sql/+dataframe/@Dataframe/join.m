function DF = join(df, other, options)
    % join Database join
    %
    % Some syntax examples:
    %
    % R = spark.range(4)
    % DF1 = R.withColumn("A", R.col('id').cast('string'))
    % DF2 = R.withColumn("B", R.col('id').cast('double'))
    % DF1.join(DF2).show()
    % DF1.join(DF2, how="outer").show()
    % DF1.join(DF2, how="left").show()
    % DF1.join(DF2, on=DF1.col('id')==DF2.col('id'),how="left").show()

    % Copyright 2024 MathWorks, Inc.

    arguments (Input)
        df (1,1) matlab.pyspark.sql.dataframe.Dataframe
        other (1,1) matlab.pyspark.sql.dataframe.Dataframe
        options.on {matlab.pyspark.internal.mustBeColType}
        options.how (1,1) string {mustBeMember(options.how, {'inner', 'cross', 'outer', 'full', 'fullouter', 'full_outer', 'left', 'leftouter', 'left_outer', 'right', 'rightouter', 'right_outer', 'semi', 'leftsemi', 'left_semi', 'anti', 'leftanti', 'left_anti'})} = "inner"
    end
    arguments (Output)
        DF (1,1) matlab.pyspark.sql.dataframe.Dataframe
    end

    if isfield(options, 'on')
        onArg = matlab.pyspark.internal.unifyColArguments(options.on);
        dfPY = df.toPy.join(other.toPy, on=onArg, how=options.how);
    else
        dfPY = df.toPy.join(other.toPy, how=options.how);
    end
    DF = matlab.pyspark.sql.dataframe.Dataframe(dfPY);

end

