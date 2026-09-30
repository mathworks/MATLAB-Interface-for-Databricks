classdef StructField
%STRUCTFIELD A Named-tuple consisting of a name and a 
% compiler.build.spark.converters.SeriesConverter.

% Copyright 2026 The MathWorks, Inc.

    properties (SetAccess = private)
        Name(1, 1) string = ""
        Converter(1, 1) compiler.build.spark.converters.SeriesConverter = compiler.build.spark.converters.PrimitiveSeriesConverter
    end

    methods
        function obj = StructField(name, converter)
            arguments
                name(1, 1) string
                converter(1, 1) compiler.build.spark.converters.SeriesConverter 
            end
            obj.Name = name;
            obj.Converter = converter;
        end
    end
end