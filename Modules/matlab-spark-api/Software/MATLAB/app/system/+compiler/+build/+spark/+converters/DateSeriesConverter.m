classdef DateSeriesConverter < compiler.build.spark.converters.SeriesConverter
%DATESERIESCONVERTER Constructs a MATLAB dateteime array from a MATLAB
% int64 array representing a Pandas Series of datetime.date values.

% Copyright 2026 The MathWorks, Inc.

    properties (SetAccess=private)
        Cellify = false
    end

    methods
        function output = toMATLAB(~, data)
            % data is a int64 array in which each element is a
            % proleptic Gregorian ordinal (i.e. number of days from 
            % Jan-01-0001, inclusive).
            output = datetime(1, 1, 1) + days(data - 1);
            output = reshape(output, [], 1);
        end

        function output = fromMATLAB(~, data)
            output = data - datetime(1, 1, 1) + days(1);
            output = int64(days(output));
            output = reshape(output, 1, []);
        end
    end
end