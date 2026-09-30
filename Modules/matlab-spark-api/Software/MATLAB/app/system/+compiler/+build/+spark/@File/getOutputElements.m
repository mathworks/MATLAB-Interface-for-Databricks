function ota = getOutputElements(obj)
    % getOutputElements Return array of output elements
    %
    % This is a helper method that returns an array of output elements. It
    % handles the choice between 'all outputs' and 'all columns'. The
    % latter in case a table is the output type.

    % Copyright 2023 The MathWorks, Inc.

    if obj.TableInterface
        if isa(obj.OutTypes(1), 'compiler.build.spark.types.Table')
            ota = obj.OutTypes(1).TableCols;
        else
            ota = obj.OutTypes;
        end
    else
        ota = obj.OutTypes;
    end


end

