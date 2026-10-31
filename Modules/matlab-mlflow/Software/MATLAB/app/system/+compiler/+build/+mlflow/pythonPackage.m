function PMB = pythonPackage(files,options)
% pythonPackage Build a Python package specifically to be used in a
% MATLAB flavor MLflow model.

% Copyright 2023 MathWorks, Inc.
    arguments
        files = string.empty
        options.?compiler.build.mlflow.PythonPackageOptions
    end

    c = namedargs2cell(options);
    buildOpts = compiler.build.mlflow.PythonPackageOptions(files,c{:});
    PMB = compiler.build.mlflow.PythonMlflowBuilder(buildOpts);
    PMB.build()
    
end
