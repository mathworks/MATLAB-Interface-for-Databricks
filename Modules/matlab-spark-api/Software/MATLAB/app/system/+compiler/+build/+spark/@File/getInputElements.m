function elems = getInputElements(obj, options)
    % getInputElements Return array of input elements
    %
    % This is a helper method that returns an array of input elements. It
    % returns both the columns of a table *and* additional arguments, if any.
    %
    % It has two optional, named arguments, table and individual
    % 
    % Only get the table elements, i.e. the columns of the table in the
    % first argument.
    %   F.getInputElements(individual=false)
    %
    % Only get the additional/non-table arguments
    %   F.getInputElements(table=false)
    %
    % If used with out options, it returns all elements
    %   F.getInputElements()
    %
    % This last call is equal to calling
    %   F.getInputElements(individual=true, table=true)
    

    % Copyright 2023 The MathWorks, Inc.

    arguments
        obj (1,1) compiler.build.spark.File
        options.table (1,1) logical = true
        options.individual (1,1) logical = true
    end

    elems = compiler.build.spark.types.ArgType.empty;
    if obj.TableInterface
        if options.table
            elems = [elems, obj.InTypes(1).TableCols];
        end
        if options.individual
            elems = [elems, obj.InTypes(2:end)];
        end
    else
        if options.individual
            elems = obj.InTypes;
        end
    end

end

