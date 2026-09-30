classdef ArraySeriesConverter < compiler.build.spark.converters.SeriesConverter
%ARRAYSERIESCONVERTERS  Constructs a MATLAB cell array from a MATLAB struct
% representing a a variable-length Pandas Series (i.e. each element is a
% list).

% Copyright 2026 The MathWorks, Inc.

    properties (GetAccess = public)
        ChildConverter(1, 1)
    end

    properties (SetAccess=private)
        Cellify = true
    end

    methods
        function obj = ArraySeriesConverter(childConverter)
            arguments
                childConverter(1, 1) compiler.build.spark.converters.SeriesConverter
            end
            obj.ChildConverter = childConverter;
        end

        function output = toMATLAB(obj, data)
            
            childData = obj.ChildConverter.toMATLAB(data.Data);
            childData = reshape(childData, 1, []);

            startIndex = 1;
            lengths = data.Lengths;
            output = cell([numel(lengths) 1]);
            for ii = 1:numel(lengths)
                endIndex = startIndex + lengths(ii) - 1;
                output{ii} = childData(startIndex:endIndex);
                startIndex = endIndex + 1;
            end
        end

        function output = fromMATLAB(obj, data)
            lengths = cellfun(@(elem) int64(numel(elem)), data, UniformOutput=true);
            lengths = reshape(lengths, 1, []);
            childData = obj.ChildConverter.fromMATLAB(horzcat(data{:}));
            childData = reshape(childData, 1, []);
            output = struct(Data=[], Lengths=[]);
            output.Data = childData;
            output.Lengths = lengths;
        end
    end
end