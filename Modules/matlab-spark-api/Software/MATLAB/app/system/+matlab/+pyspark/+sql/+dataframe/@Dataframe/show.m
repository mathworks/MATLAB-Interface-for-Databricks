function show(obj, arg)
    % show - Show a Dataframe

    % (c) 2024 MathWorks, Inc.

    arguments
        obj (1,1) matlab.pyspark.sql.dataframe.Dataframe
    end
    arguments (Repeating)
        arg
    end

    narginchk(1, 4);
    if nargin == 1
        obj.toPy.show();
    elseif nargin ==2
        obj.toPy.show(int64(arg{1}));
    elseif nargin ==3
        obj.toPy.show(int64(arg{1}), logical(arg{2}));
    elseif nargin ==4
        obj.toPy.show(int64(arg{1}), logical(arg{2}), logical(arg{3}));
    end

end