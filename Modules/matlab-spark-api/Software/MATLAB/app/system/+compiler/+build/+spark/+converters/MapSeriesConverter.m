classdef MapSeriesConverter < compiler.build.spark.converters.SeriesConverter
%MAPSERIESCONVERTER Constructs a Nx1 MATLAB struct array from a MATLAB cell 
% array representing a Pandas Series of objects, in which the objects are
% dictionaries. The dictionary keys are type-consistent, and the
% dictionary values are type-consistent as well.

% Copyright 2026 The MathWorks, Inc.

    properties (GetAccess = public)
        KeyConverter(1, 1) 
        ValueConverter(1, 1)
    end

    properties (SetAccess=private)
        Cellify = true
    end

    methods
        function obj = MapSeriesConverter(keyConverter, valueConverter)
            arguments
                keyConverter(1, 1) compiler.build.spark.converters.SeriesConverter
                valueConverter(1, 1) compiler.build.spark.converters.SeriesConverter
            end
            obj.KeyConverter = keyConverter;
            obj.ValueConverter = valueConverter;
        end

        function output = toMATLAB(obj, data)
            numKeyValuePairs = data.NumKeyValuePairs;

            keys = obj.KeyConverter.toMATLAB(data.KeyData);
            values = obj.ValueConverter.toMATLAB(data.ValueData);

            output = cell([numel(numKeyValuePairs) 1]);

            startIndex = 1;
            for ii = 1:numel(numKeyValuePairs)
                endIndex = startIndex + numKeyValuePairs(ii) - 1;
                output{ii} = dictionary(keys(startIndex:endIndex), values(startIndex:endIndex));
                startIndex = endIndex + 1;
            end
        end

        function output = fromMATLAB(obj, data)
            lengths = cellfun(@(elem) int64(numEntries(elem)), data, UniformOutput=true);
            lengths = reshape(lengths, 1, []);

            [keys, values] = cellfun(@getKeyValues, data, UniformOutput=false);
            keys = obj.KeyConverter.fromMATLAB(vertcat(keys{:}));
            values = obj.ValueConverter.fromMATLAB(vertcat(values{:}));

            output = struct(NumKeyValuePairs=[], KeyData=[], ValueData=[]);
            output.NumKeyValuePairs = lengths;
            output.KeyData = keys;
            output.ValueData = values;
        end
    end
end

function [k, v] = getKeyValues(dict)
    k = keys(dict);
    v = values(dict);
end