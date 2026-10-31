function names = getInputNames(file, options)
    % getInputNames Return array of input names
    %
    % This is a helper method that returns an array of input names. It
    % returns both the column names of a table *and* additional argument
    % namess, if any. 
    %
    % It has two optional, named arguments, table and individual
    % 
    % Only get the table column names,
    %   F.getInputNames(individual=false)
    %
    % Only get the additional/non-table argument names
    %   F.getInputNames(table=false)
    %
    % If used with out options, it returns all element namess
    %   F.getInputNames()
    %
    % This last call is equal to calling
    %   F.getInputNames(individual=true, table=true)
    %
    % A third option, main, can be used to override the options table and
    % individual. If main=true is used as an option, it will set the other
    % options according to the value of TableInterface:
    % 
    %  TableInterface   true         false
    % ------------------------------------------
    %   table           true         false
    % individual        false        true

    % Copyright 2024 The MathWorks, Inc.

    arguments
        file (1,1) compiler.build.spark.PythonFileV2
        options.table (1,1) logical = true
        options.individual (1,1) logical = true
        options.main (1,1) logical = false
    end

    if options.main
        options.table = file.TableInterface;
        options.individual = ~file.TableInterface;
    end

    names = string.empty;
    if file.TableInterface
        if options.table
            names = [names, file.Schema.Inputs(1).SparkType.names];
        end
        if options.individual
            names = [names, file.Schema.Inputs(2:end).Name];
        end
    else
        if options.individual
            names = [file.Schema.Inputs.Name];
        end
    end

end

