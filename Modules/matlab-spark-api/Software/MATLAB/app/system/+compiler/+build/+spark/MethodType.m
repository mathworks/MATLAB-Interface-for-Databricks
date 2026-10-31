classdef MethodType 
    % MethodType types of functions SparkBuilder and PythonSparkBuilder generate

    % Copyright 2023-2026 The MathWorks, Inc.

    enumeration
        inputNames
        outputNames
        rowIterator
        colsIterator
        inputsTransformer
        outputsTransformer
        plain
        row
        map
        mapPartitions
        mapPartitionsTable
        filter
        udf
        applyInPandas
        mapInPandas
        pandasSeries
        pandasToColumns
        columnsToPandas
    end
end