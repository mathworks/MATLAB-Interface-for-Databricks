classdef (Abstract) AtomicType < compiler.build.spark.data.DataType
    % AtomicType Implementation for types in Compiler workflow

    % Copyright 2024 The MathWorks, Inc.

    methods
        function obj = AtomicType(varargin)
            obj@compiler.build.spark.data.DataType(varargin{:});
        end
    end

end