function ret = hasInputArrays(obj)
    % hasInputArrays Returns true if there are arrays in the input columns

    % Copyright 2022 The MathWorks, Inc.

    ret = false;
    if obj.nArgIn == 0
        return;
    end
    if isa(obj.InTypes(1), 'compiler.build.spark.types.Table')
        inTypes = obj.InTypes(1).TableCols;
    else
        % Non-table outputs
        inTypes = obj.InTypes;
    end
    ret = ~all(arrayfun(@(ot) ot.isScalarData, inTypes));

end