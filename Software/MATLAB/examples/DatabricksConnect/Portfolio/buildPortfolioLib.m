function PSB = buildPortfolioLib()
    % buildPortfolioLib Build example library .whl file
    %
    % Check the required schema file exists first:
    %   Software\MATLAB\examples\DatabricksConnect\Portfolio\optimizePortfolio.schema
    % See: runWithDatabricksConnect.m

    % Copyright 2024-2026 The MathWorks, Inc.

    opts = compiler.build.PythonPackageOptions(...
        "optimizePortfolio.m", ...
        "OutputDir", "_build", ...
        "PackageName", "example.portfolio");

    fprintf("Output directory: %s\n", opts.OutputDir);

    PSB = compiler.build.spark.pythonPackage(opts);
end