classdef TimeUnit
%TIMEUNIT Enumeration class representing time units.

% Copyright 2026 The MathWorks, Inc.

    enumeration
        Seconds
        Milliseconds
        Microseconds
        Nanoseconds
    end

    methods
        function ticks = ticksPerSecond(obj)
            import compiler.build.spark.converters.TimeUnit
            switch obj
                case TimeUnit.Seconds
                    ticks = 1;
                case TimeUnit.Milliseconds
                    ticks = 1e3;
                case TimeUnit.Microseconds
                    ticks = 1e6;
                otherwise % TimeUnit.Nanoseconds
                    ticks = 1e9;
            end
        end

        function str = toShortString(obj)
            import compiler.build.spark.converters.TimeUnit
            switch obj
                case TimeUnit.Seconds
                    str = "s";
                case TimeUnit.Milliseconds
                    str = "ms";
                case TimeUnit.Microseconds
                    str = "us";
                otherwise % TimeUnit.Nanoseconds
                    str = "ns";
            end
        end

    end

    methods (Static)
        function unit = fromString(str)
            import compiler.build.spark.converters.TimeUnit
            switch lower(str)
                case {"s", "seconds"}
                    unit = TimeUnit.Seconds;
                case {"ms", "milliseconds"}
                    unit = TimeUnit.Milliseconds;
                case {"us", "microseconds"}
                    unit = TimeUnit.Microseconds;
                case {"ns", "nanoseconds"}
                    unit = TimeUnit.Nanoseconds;
                otherwise
                    error("compiler:build:spark:converters:InvalidTimeUnit", ...
                        "Unknown time unit '%s'. Expected one of: " + ...
                        "s, seconds, ms, milliseconds, us, microseconds, ns, nanoseconds.", str);
            end
        end
    end
end