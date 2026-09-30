function setTableProperties(obj)
    % setTableProperties Set table informations on object
    %
    % This function will check the types of the function.
    % The following cases exist:
    % 1. No tables, neither in input or output. This is a 'Values'
    %    function.
    % 2. 1 input and 1 output, both tables. This is a 'Table' function.
    % 3. 2 or more inputs, and 1 output. The output is a table, and
    %    exactly 1 of the inputs, the fist argument is a table.
    %    This is a Table+ function.
    %
    % Any other input/output combination is not valid.
    % 
    % More information can be found in
    %   Modules/matlab-spark-api/Documentation/SparkBuilderDataTypes.md

    % Copyright 2022-2023 The MathWorks, Inc.

    inTypes = [obj.InTypes.MATLABType];
    outTypes = [obj.OutTypes.MATLABType];
    inTableIdx = find(inTypes == "table");
    if isempty(outTypes)
        % In the case of functions without return values, outTypes will be
        % an empty double, which will break the next find command.
        outTypes = string.empty;
    end
    outTableIdx = find(outTypes == "table");
    if isempty(inTableIdx) && isempty(outTableIdx)
        % Case 1
        obj.TableInterface = false;
        obj.ScopedTables = false;
        obj.PandaSeries = obj.nArgOut == 1;
        return;
    end

    % It has something to do with tables
    if isscalar(inTableIdx)
        if inTableIdx ~= 1
            error('MATLAB_SPARK_API:bad_table_arguments', ...
                ['With table inputs and additional arguments, ', ...
                'the table must be the first argument.']);
        end

        % This can be case 2, 3 or 4
        if isscalar(outTableIdx)
            % This can be case 2 or 3
            if obj.nArgOut > 1
                error('MATLAB_SPARK_API:bad_table_arguments', ...
                    ['With table types, there can only be one output argument, ', ...
                    'which should be of type table.']);
            end
            if isscalar(inTypes)
                % Case 2
                obj.TableInterface = true;
                obj.PandaSeries = false;
                obj.ScopedTables = false;
            else
                % Case 3
                obj.TableInterface = true;
                obj.PandaSeries = false;
                obj.ScopedTables = true;
            end
        else
            error('MATLAB_SPARK_API:bad_table_arguments', ...
                'There cannot be more than one output table argument.');
        end
    else
        % Case 5
        error('MATLAB_SPARK_API:bad_table_arguments', ...
            "With table inputs, there can only be exactly one table argument.\n" + ...
            "Please refer to the following document for more information.\n" + ...
            "Modules/matlab-spark-api/Documentation/SparkBuilderDataTypes.md\n");
    end


end
