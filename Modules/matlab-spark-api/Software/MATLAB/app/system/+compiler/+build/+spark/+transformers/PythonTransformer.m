classdef PythonTransformer < compiler.build.spark.transformers.Transformer

    properties (SetAccess=private)
        PSB
    end

    methods
        function obj = PythonTransformer(varargin)
            obj@compiler.build.spark.transformers.Transformer(varargin{:});
            obj.PSB = obj.F.Parent;
        end
    end

end
