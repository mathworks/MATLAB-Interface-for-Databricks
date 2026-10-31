function ret = hasOutputArrays(obj)
    % hasOutputArrays Returns true if there are arrays in the output columns

    % Copyright 2022 The MathWorks, Inc.

    ret = false;
    if obj.nArgOut == 0
        return;
    end
    if isa(obj.OutTypes(1), 'compiler.build.spark.types.Table')
        outTypes = obj.OutTypes(1).TableCols;
    else
        % Non-table outputs
        outTypes = obj.OutTypes;
    end
    ret = ~all(arrayfun(@(ot) ot.isScalarData, outTypes));

end