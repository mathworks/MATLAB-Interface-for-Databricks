classdef DayTimeIntervalType < compiler.build.spark.schema.AnsiIntervalType
    % DayTimeIntervalType Spark schema types

    % Copyright 2025 The MathWorks, Inc.

    properties
        startField (1,1) compiler.build.spark.schema.mathworks.DHMSInterval = "DAY"
        endField (1,1) compiler.build.spark.schema.mathworks.DHMSInterval = "SECOND"
    end

    methods
        function obj = DayTimeIntervalType(varargin)
            obj@compiler.build.spark.schema.AnsiIntervalType();
            obj.type = 'interval';
            switch nargin
                case 1
                    arg = varargin{1};
                    if ischar(arg) || isstring(arg)
                        % Initialize from serialized form
                        if startsWith(arg, "interval")
                            [obj.startField, obj.endField] = deserializeString(arg);
                        else
                            obj.startField = arg;
                        end
                    elseif isa(arg, 'py.pyspark.sql.types.DayTimeIntervalType')
                        obj.startField = int64(arg.startField);
                        obj.endField = int64(arg.endField);
                    else
                        obj.startField = arg;
                    end
                case 2
                    obj.startField = varargin{1};
                    obj.endField = varargin{2};
            end
            assert(obj.startField < obj.endField, ...
                "SPARKAPI:bad_interval_definition", ...
                "The from/to in DayTimeIntervalType requires a larger timespan in the startField than in the endField");
        end

        function PI = pythonInitCode(obj)
            % pythonInitCode Return python init code
            % This will be something like LongType() for atomic types. For
            % compound types, this method must be overridden.
            PI = sprintf("%s(%d, %d)", obj.pythonType(), obj.startField, obj.endField);
        end

        function str = pythonSchemaType(obj)
            % pythonSchemaType Return schema type
            % Base case is just the type name. Override if necessary
            % str = sprintf("%s %s to %s", obj.type, intervalToString(obj.startField), intervalToString(obj.endField));
            str = sprintf("%s %s to %s", obj.type, lower(string(obj.startField)), lower(string(obj.endField)));
        end

        function so = toStruct(obj)
            % toStruct Create struct object suitable for JSON conversion
            % Default implementation for atomic types is a string of the type
            so = obj.pythonSchemaType;
        end

    end


end

function [startF, endF] = deserializeString(str)
    % deserializeString Create object from json 
    %
    % Example: "interval day to second"
    toks = regexp(str, "interval[ ]+([^ ]+)[ ]+to[ ]+([^ ]+)", "tokens", "once");
    startF = compiler.build.spark.schema.mathworks.DHMSInterval(toks{1});
    endF = compiler.build.spark.schema.mathworks.DHMSInterval(toks{2});
end


