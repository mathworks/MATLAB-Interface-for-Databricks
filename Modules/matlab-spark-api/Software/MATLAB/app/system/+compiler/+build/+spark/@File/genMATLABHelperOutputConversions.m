function str = genMATLABHelperOutputConversions(obj, helperName, options)
    % genMATLABHelperOutputConversions Generate conversion code
    %
    % Some datatypes, like datetime/java.sql.Timestamp, need special
    % attention on the interface between Spark and MATLAB.
    %
    % This method should be generic enough to work with all function types.
    % An additional argument, helperName, is provided, and used in case
    % names for arguments need to be used.
    % A third an optional argument is used if the results should directly
    % be written into another StringWriter.

    % Copyright 2023 The MathWorks, Inc.

    arguments
        obj (1,1) compiler.build.spark.File
        helperName (1,1) string = "T_OUT"
        options.SW matlab.sparkutils.StringWriter = matlab.sparkutils.StringWriter.empty
        options.namedArguments string
        options.isArray (1,1) logical = true
    end

    SW = matlab.sparkutils.StringWriter();

    anyConversions = false;

    outElems = obj.getOutputElements();
    if obj.TableInterface
        % Either tables
        for k=1:length(outElems)
            curElem = outElems(k);
            colName = sprintf("%s.%s", helperName, curElem.Name);
            convStr = curElem.getMATLABHelperOutputConversion(colName, options.isArray);
            if strlength(convStr) > 0
                if ~anyConversions
                    SW.pf("%% Some columns must be converted here.\n");
                    anyConversions = true;
                end
                SW.insertLines(convStr);
            end
        end

    else

        % Or values
        if isfield(options, 'namedArguments')
            colNames = options.namedArguments;
        else
            colNames = "arg" + (1:length(outElems));
        end
        for k=1:length(outElems)
            curElem = outElems(k);
            colName = colNames(k);
            convStr = curElem.getMATLABHelperOutputConversion(colName, options.isArray);
            if strlength(convStr) > 0
                if ~anyConversions
                    SW.pf("%% Some columns must be converted here.\n");
                    anyConversions = true;
                end
                SW.pf("%s\n", convStr);
            end
        end
    end

    if anyConversions
        SW.pf("\n");
    end

    str = SW.getString();

    if ~isempty(options.SW)
        if strlength(str) > 0
            options.SW.insertLines(str);
        end
    end
    
end


