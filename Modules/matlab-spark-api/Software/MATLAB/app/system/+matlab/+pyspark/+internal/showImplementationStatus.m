function FINFO = showImplementationStatus(mlObj)
    % showImplementationStatus - Check implementation status
    %
    % The function can be called with a MATLAB wrapper for a PySpark
    % object, and will return a structure with implementation info.
    %
    % E.g.
    %  DF = spark.range(3);
    %  INFO = matlab.pyspark.internal.showImplementationStatus(DF)

    % Copyright 2024 MathWorks, Inc.
    
    pyObj = mlObj.toPy;

    existingMethods = string(methods(mlObj))';
    allMethods = string(py.dir(pyObj));
    relevantMethods = allMethods(~allMethods.startsWith("_"));
    missingMethods = setdiff(relevantMethods, existingMethods);

    FINFO = struct(...
        "Existing", existingMethods, ...
        "All", allMethods, ...
        "Relevant", relevantMethods, ...
        "Missing", missingMethods ...
        );

end