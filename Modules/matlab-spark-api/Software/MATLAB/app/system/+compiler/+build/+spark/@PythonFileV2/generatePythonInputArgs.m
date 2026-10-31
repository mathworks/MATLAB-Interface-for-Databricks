function [names, namesArray] = generatePythonInputArgs(obj, opts)
    % generatePythonInputArgs Internal helper method

    % Copyright 2024 The MathWorks, Inc.

    arguments
        obj (1,1) compiler.build.spark.PythonFileV2
        opts.withNargout (1,1) logical = false
        opts.convertArgs (1,1) logical = false
    end

    inTypes = obj.getInputElements(table=obj.TableInterface,individual=~obj.TableInterface, useData=true);
    inNames = obj.getInputNames(table=obj.TableInterface,individual=~obj.TableInterface);
    if opts.convertArgs
        namesArray = "arg_" + inNames;
        for k=1:length(inTypes)
            curElem = inTypes(k);
            convFunc = curElem.val_Spark_to_IMPY();
            if ~isempty(convFunc)
                namesArray(k) = sprintf("%s(%s)", convFunc, namesArray(k));
            end
            convFunc = curElem.val_IMPY_to_IMML();
            if ~isempty(convFunc)
                namesArray(k) = sprintf("%s(%s)", convFunc, namesArray(k));
            end
        end
    else
        % Prefix the argument names to avoid name clashes with
        % reserved words.
        namesArray = "arg_" + inNames;
    end
    names = join(namesArray, ", ");
    if opts.withNargout && obj.nArgOut > 1
        names = sprintf("%s, nargout=%d", names, obj.nArgOut);
    end
end