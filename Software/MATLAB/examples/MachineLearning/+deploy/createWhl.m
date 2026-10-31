function PSB = createWhl(FuncFileNames, BuildDir, PythonPkgName)
    % createWhl Build example .whl file

    % Copyright 2022-2026, MathWorks Inc.

    arguments
        FuncFileNames string = {mustBeNonzeroLengthText}
        BuildDir string = {mustBeTextScalar, mustBeNonzeroLengthText}
        PythonPkgName string = {mustBeTextScalar, mustBeNonzeroLengthText}
    end

    opts = compiler.build.PythonPackageOptions(...
        FuncFileNames, ...
        "OutputDir", BuildDir, ...
        "PackageName", PythonPkgName ...
        );

    PSB = compiler.build.spark.pythonPackage(opts);

    % Notify the user what just happened
    [wheelFile, wheelName] = PSB.getWheelFile();
    fprintf("\nCompleted building the wheel: ""%s""...\n", wheelName)
    fprintf("The .whl filename is: %s\nand can be found here: %s\n", wheelName, wheelFile)
end