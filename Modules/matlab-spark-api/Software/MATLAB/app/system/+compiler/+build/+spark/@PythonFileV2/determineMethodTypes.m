function determineMethodTypes(obj)
    % determineMethodTypes Determine what methods must be created
    %
    % The methods will differ for different function signatures.
    %

    % Copyright 2023-2025 The MathWorks, Inc.

    % First clear any old settings, to avoid duplicates
    obj.MethodTypes = compiler.build.spark.MethodType.empty;

    if obj.nArgIn > 0
        obj.addMethodType("inputNames");
    end

    if obj.nArgOut > 0
        obj.addMethodType("outputNames");
    end

    obj.addMethodType("colsIterator");

    if ~obj.TableInterface
        obj.addMethodType("plain");
        % if obj.nArgOut == 1
        obj.addMethodType("pandasSeries");
        % end
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
        end
    end

    obj.addMethodType("mapPartitions");

    obj.addMethodType("pandasToColumns");
    obj.addMethodType("columnsToPandas");
    obj.addMethodType("applyInPandas");
    obj.addMethodType("mapInPandas");

    if ~obj.TableInterface
        if obj.nArgOut == 1 && obj.OutData.type == "boolean"
            obj.addMethodType("filter");
        end
    end

    if obj.nArgOut > 0
        if ~obj.TableInterface
            obj.addMethodType("udf");
        end
    end

end

