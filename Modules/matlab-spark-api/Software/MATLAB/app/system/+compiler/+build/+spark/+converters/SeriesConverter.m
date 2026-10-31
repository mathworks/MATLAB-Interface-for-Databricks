classdef (Abstract) SeriesConverter < matlab.mixin.Heterogeneous
%SERIESCONVERTER Defines the interface for converting Pandas Series
% into MATLAB arrays.

% Copyright 2026 The MathWorks, Inc.

    properties (Abstract, SetAccess=private)
        % Used by StructSeriesConverter/convertTo to determine if it should
        % use cell array or normal array concatentation for a particular
        % field.
        Cellify(1, 1) logical
    end

    methods (Abstract)
        output = toMATLAB(obj, data)
    end

    methods
        % TODO: Make abstract
        function output = fromMATLAB(~, data)
            output = data;
        end
    end
end