function determineMethodTypes(obj)
    % determineMethodTypes Determine what methods must be created
    %
    % The methods will differ for different function signatures.
    %
    
    % Copyright 2023-2025 The MathWorks, Inc.

    % First clear any old settings, to avoid duplicates
    obj.MethodTypes = compiler.build.spark.MethodType.empty;

    if obj.nArgOut > 0
        obj.addMethodType("outputNames");
    end

    obj.addMethodType("rowIterator");
    obj.addMethodType("colsIterator");

    if obj.needsInputTransformer()
        obj.addMethodType("inputsTransformer");
    end

    if obj.needsOutputTransformer()
        obj.addMethodType("outputsTransformer");
    end

    if ~obj.TableInterface
        obj.addMethodType("plain");
    end

    if ~(obj.nArgOut == 0 || obj.TableInterface)
        % No map possible without out arguments
        % Don't create normal row/map method for table interface
        obj.addMethodType("row");
    end

    if obj.nArgOut > 0
        if ~obj.TableInterface
            % No map possible without out arguments
            % Don't create normal row/map method for table interface
            obj.addMethodType("map");
            % Don't create normal row/map method for table interface
            obj.addMethodType("mapPartitions");
        end
    end

    if obj.TableInterface
        obj.addMethodType("mapPartitionsTable");
    end

    if obj.TableInterface
        obj.addMethodType("pandasToColumns");
        obj.addMethodType("columnsToPandas");
        obj.addMethodType("applyInPandas");
        obj.addMethodType("mapInPandas");
    end

    if ~obj.TableInterface
        if obj.nArgOut == 1 && obj.OutTypes.isScalarData
            obj.addMethodType("pandasSeries");
        end
    end

    if ~obj.TableInterface
        if obj.nArgOut == 1 && obj.OutTypes.JavaType == "Boolean"
            obj.addMethodType("filter");
        end
    end

    if obj.nArgOut > 0
        if ~obj.TableInterface
            obj.addMethodType("udf");
        end
    end
    
end

