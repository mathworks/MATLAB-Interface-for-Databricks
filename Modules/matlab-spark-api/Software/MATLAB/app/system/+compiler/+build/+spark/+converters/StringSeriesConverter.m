classdef StringSeriesConverter < compiler.build.spark.converters.SeriesConverter
%STRINGSERIESCONVERTER Constructs a MATLAB string array from a MATLAB
% cellstr array representing a Pandas Series of string values.

% Copyright 2026 The MathWorks, Inc.

    properties (SetAccess=private)
        Cellify = false
    end
   
    methods
        function output = toMATLAB(~, data)
            output = string(data);
            output = reshape(output, [], 1);
        end

        function output = fromMATLAB(~, data)
            output = reshape(data, 1, []);
        end
    end
end