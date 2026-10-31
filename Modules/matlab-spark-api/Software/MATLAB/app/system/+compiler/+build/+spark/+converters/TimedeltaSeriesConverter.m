classdef TimedeltaSeriesConverter < compiler.build.spark.converters.SeriesConverter
%TIMESTAMPSERIESCONVERTER   Constructs a MATLAB duration array from a
% MATLAB int64 array representing a Pandas Series of timedelta64 values.


% Copyright 2026 The MathWorks, Inc.

    properties (SetAccess=private)
        TimeUnit(1, 1) compiler.build.spark.converters.TimeUnit = ...
             compiler.build.spark.converters.TimeUnit.Seconds
    end

    properties (SetAccess=private)
        Cellify = false
    end

    methods
        function obj = TimedeltaSeriesConverter(timeUnit)
            arguments
                timeUnit(1, 1) compiler.build.spark.converters.TimeUnit
            end

            obj.TimeUnit = timeUnit;
        end

        function output = toMATLAB(~, data)
            unit = compiler.build.spark.converters.TimeUnit.fromString(data.TimeUnit);
            ms = compiler.build.spark.converters.TimeUnit.Milliseconds;
            multiplier = ms.ticksPerSecond() / unit.ticksPerSecond();
            output = milliseconds(double(data.TimeData) * multiplier);
            output = reshape(output, [], 1);
        end

         function output = fromMATLAB(obj, data)
            ms = compiler.build.spark.converters.TimeUnit.Milliseconds;
            multiplier = obj.TimeUnit.ticksPerSecond()/ ms.ticksPerSecond();
            timeData = int64(milliseconds(data) * multiplier);
            output.TimeUnit = obj.TimeUnit.toShortString();
            output.TimeData = reshape(timeData, 1, []);
        end
    end

end