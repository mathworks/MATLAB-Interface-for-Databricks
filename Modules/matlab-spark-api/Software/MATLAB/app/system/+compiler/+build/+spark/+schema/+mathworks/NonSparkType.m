classdef (Abstract) NonSparkType < compiler.build.spark.schema.mathworks.CommonBase
    % NonSparkType Abstract class, part of the Schema definitions
    %
    % Due to the fact that certain classes, not part of the Spark schemas, are 
    % needed to define certain aspects (file/function, inputs/outputs). this
    % class was created.
    
    % Copyright 2024-2025 The MathWorks, Inc.

    methods

        function obj = NonSparkType()
            obj@compiler.build.spark.schema.mathworks.CommonBase();
        end

    end

end