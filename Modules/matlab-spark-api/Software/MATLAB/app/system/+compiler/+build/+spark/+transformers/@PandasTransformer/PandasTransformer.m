classdef PandasTransformer < compiler.build.spark.transformers.PythonTransformer
    
    methods
        function obj = PandasTransformer(varargin)
            obj@compiler.build.spark.transformers.PythonTransformer(varargin{:});
        end
        
        function generate(obj)            
            obj.F.columnsToPandas_PythonWrapper();
            obj.F.pandasToColumns_PythonWrapper();
        end
    end
end