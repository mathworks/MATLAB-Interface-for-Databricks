function T = table(obj)
    % table - Convert Spark DataFrame to MATLAB table

    % (c) 2024-2026 MathWorks, Inc.

    arguments (Input)
        obj (1,1) matlab.pyspark.sql.dataframe.Dataframe
    end

    if isMATLABReleaseOlderThan('R2024a')
        T = table_R2023b(obj);
    elseif obj.getSetUseToArrow()
        at = obj.dataframe.toArrow();
        T = matlab.internal.arrow.arrow2table(at);
    else
        pdf = toPandas(obj);
        T = matlab.pyspark.sql.dataframe.internal.pdf2table(pdf, obj.schema);
    end
end