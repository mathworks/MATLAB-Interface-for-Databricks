classdef PythonPackageOptions < compiler.build.PythonPackageOptions
%compiler.build.mlflow.PythonPackageOptions Python package options
%specifically for MATLAB flavor MLflow models. They are basically the same
%as compiler.build.PythonPackageOptions with a few extra properties added:
%
%   - Debug
%
% See Also:
%   compiler.build.PythonPackageOptions

% Copyright 2023 MathWorks, Inc.
    properties
        Debug logical = false
    end
    
    methods
        function obj = PythonPackageOptions(files,options)
            arguments
                files = string.empty
                options.?compiler.build.mlflow.PythonPackageOptions
            end
            % Super constructor may not be called conditionally, so always
            % call it, even if input was a
            % compiler.build.PythonPackageOptions already, create a new one
            % with the same files and then also copy the properties
            if isa(files,'compiler.build.PythonPackageOptions')
                f = files.FunctionFiles;
            else
                f = files;
            end
            
            obj@compiler.build.PythonPackageOptions(f)
            
            if isa(files,'compiler.build.PythonPackageOptions')
                % and then also copy the properties
                for p = string(properties(files))'
                    obj.(p) = files.(p);
                end
            end
            % Override any properties through NV-pairs
            for p = string(fieldnames(options))'
                obj.(p) = options.(p);
            end
            
        end
    end
end