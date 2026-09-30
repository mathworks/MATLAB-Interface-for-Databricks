function elems = getInputElements(file, options)
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
        options.useData (1,1) logical = false
        options.main (1,1) logical = false
    end

    if options.main
        options.table = file.TableInterface;
        options.individual = ~file.TableInterface;
    end

    if options.useData
        elems = compiler.build.spark.data.DataType.empty;
        if file.TableInterface
            if options.table
                elems = [elems, file.InData(1).fields.dataType];
            end
            if options.individual
                elems = [elems, file.InData(2:end)];
            end
        else
            if options.individual
                elems = file.InData;
            end
        end
    else
        elems = compiler.build.spark.schema.DataType.empty;
        if file.TableInterface
            if options.table
                elems = [elems, file.Schema.Inputs(1).SparkType.fields.dataType];
            end
            if options.individual
                elems = [elems, file.Schema.Inputs(2:end).SparkType];
            end
        else
            if options.individual
                elems = [file.Schema.Inputs.SparkType];
            end
        end
    end
end

