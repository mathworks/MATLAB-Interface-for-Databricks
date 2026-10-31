classdef PrimitiveSeriesConverter < compiler.build.spark.converters.SeriesConverter
%PRIMITIVESERIESCONVERTER   Converter for constructing primitive MATLAB
% arrays that require zero data-manipulation. 

% Copyright 2026 The MathWorks, Inc.

    properties (SetAccess=private)
        Cellify = false
    end

    methods
        function output = toMATLAB(~, data)
            output = reshape(data, [], 1); 
        end

        function output = fromMATLAB(~, data)
            output = reshape(data, 1, []); 
        end
    end
end