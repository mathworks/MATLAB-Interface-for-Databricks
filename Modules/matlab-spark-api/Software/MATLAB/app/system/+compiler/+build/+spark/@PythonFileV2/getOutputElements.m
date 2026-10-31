function ota = getOutputElements(obj, options)
    % getOutputElements Return array of output elements
    %
    % This is a helper method that returns an array of output elements. It
    % handles the choice between 'all outputs' and 'all columns'. The
    % latter in case a table is the output type.

    % Copyright 2024 The MathWorks, Inc.

    arguments
        obj (1,1) compiler.build.spark.PythonFileV2
        options.useData (1,1) logical = false
    end
    if options.useData
        if obj.TableInterface
            ota = [obj.OutData.fields.dataType];
        else
            ota = obj.OutData;
        end
    else
        if obj.TableInterface
            ota = [obj.Schema.Outputs(1).SparkType.fields.dataType];
        else
            ota = [obj.Schema.Outputs.SparkType];
        end
    end

end

