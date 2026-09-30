classdef BinarySeriesConverter < compiler.build.spark.converters.SeriesConverter
%BINARYSERIESCONVERTER  Constructs a cell array containing uint8 row
% vectors from a MATLAB struct array representing a pandas series of
% variable-length byt4e arrays.

% Copyright 2026 The MathWorks, Inc.

    properties (SetAccess=private)
        Cellify = true
    end

    methods
 
        function output = toMATLAB(~, data)
            % data is a scalar struct with two fields: Lengths and Bytes.
            %
            % The Lengths field is a int64 array. Each int64 value specifies
            % the length of the corresponding uint8 array in the output
            % cell array.
            % 
            % The Bytes field is a uint8 array.
            bytes = data.Bytes;
            startIndex = 1;
            lengths = data.Lengths;
            output = cell([numel(lengths) 1]);
            
            for ii = 1:numel(lengths)
                endIndex = startIndex + lengths(ii) - 1;
                output{ii} = bytes(startIndex:endIndex);
                startIndex = endIndex + 1;
            end
        end

        function output = fromMATLAB(~, data)
            lengths = cellfun(@(elem) int64(numel(elem)), data, UniformOutput=true);
            lengths = reshape(lengths, 1, []);
            bytes = horzcat(data{:});
            output = struct(Bytes=bytes, Lengths=lengths);
        end

    end
end