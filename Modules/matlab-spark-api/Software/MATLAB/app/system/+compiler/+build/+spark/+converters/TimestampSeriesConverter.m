classdef TimestampSeriesConverter < compiler.build.spark.converters.SeriesConverter
%TIMESTAMPSERIESCONVERTER   Constructs a MATLAB datetime array from a
% MATLAB int64 array representing a Pandas Series of datetime64 values.

% Copyright 2026 The MathWorks, Inc.

    properties (SetAccess=private)
        TimeUnit(1, 1) compiler.build.spark.converters.TimeUnit = ...
             compiler.build.spark.converters.TimeUnit.Seconds
    end

    properties (SetAccess=private)
        Cellify = false
    end

    methods

        function obj = TimestampSeriesConverter(timeUnit)
            arguments
                timeUnit(1, 1) compiler.build.spark.converters.TimeUnit
            end

            obj.TimeUnit = timeUnit;
        end

        function output = toMATLAB(~, data)
            unit = compiler.build.spark.converters.TimeUnit.fromString(data.TimeUnit);
            ticksPerSecond = unit.ticksPerSecond();
            output = datetime(data.TimeData, ConvertFrom="epochtime", TicksPerSecond=ticksPerSecond);
            output = reshape(output, [], 1);
        end

        function output = fromMATLAB(obj, data)
            ticksPerSecond = obj.TimeUnit.ticksPerSecond();
            timeData = convertTo(data, "epochtime", TicksPerSecond=ticksPerSecond);
            output.TimeUnit = obj.TimeUnit.toShortString();
            output.TimeData = reshape(timeData, 1, []);
        end
    end

end