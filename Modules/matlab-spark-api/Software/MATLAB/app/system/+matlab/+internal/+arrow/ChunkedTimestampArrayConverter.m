classdef ChunkedTimestampArrayConverter < matlab.internal.arrow.ChunkedPrimitiveArrayConverter
%CHUNKEDTIMESTAMPARRAYCONVERTER Converter for converting ChunkedArrays of
% TimestampArrays to MATLAB datetime arrays.

% Copyright 2026 The MathWorks, Inc.

    properties (SetAccess = private)
        TimeZone(1, 1) string
        TicksPerSecond(1, 1) double
    end

    properties (Constant, Access = private)
        Epoch = datetime(1970, 1, 1, TimeZone="UTC");
        Int64Converter = matlab.internal.arrow.ChunkedIntegerArrayConverter("int64", false)
    end

    methods
        function obj = ChunkedTimestampArrayConverter(timeUnit, timeZone)
            obj.TimeZone = timeZone;
            obj.TicksPerSecond = getTicksPerSecondFromUnit(timeUnit);
        end
    end

    methods (Access = protected)
         function data = allocateTypedVector(obj, numElements)
                data = NaT([numElements 1], TimeZone=obj.TimeZone);
            end

        function data = convertRawData(obj, array)
            epochTime = obj.Int64Converter.convertRawData(array);
            data = datetime(epochTime, ConvertFrom="epochtime", ...
                Epoch=obj.Epoch, TicksPerSecond=obj.TicksPerSecond, ...
                TimeZone=obj.TimeZone);
        end

         function data = setNullElements(obj, data, nullIndices)
            data(nullIndices) = NaT(TimeZone=obj.TimeZone);
        end
    end
end

function ticksPerSecond = getTicksPerSecondFromUnit(timeUnit)
    switch timeUnit
        case "s"
            ticksPerSecond = 1;
        case "ms"
            ticksPerSecond = 1e3;
        case "us"
            ticksPerSecond = 1e6;
        case "ns"
            ticksPerSecond = 1e9;
        otherwise
            msg = compose("Unknown time unit: %s", timeUnit);
            error("sparkapi:UnknownTimeUnit", msg);
    end
end