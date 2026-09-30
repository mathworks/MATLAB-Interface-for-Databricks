function INFO = generateCode(swo)
    % generateCode Generate code files for SimWrapper

    % Copyright 2024-2025 MathWorks, Inc.

    arguments
        swo (1,1) simwrapper.SimWrapper
    end

    old = cd(swo.BaseFolder);
    goBack = onCleanup(@() cd(old));

    % TODO: Consider saving file names somewhere
    INFO.hFile = swo.writeHeader(); %#ok<NASGU>
    INFO.cFile = swo.writeSource(); %#ok<NASGU>
    INFO.pyFile = swo.writePython(); %#ok<NASGU>
    
    swo.writeSetupPython();

    swo.writeMATLABExample();
    swo.writePythonExample();
    swo.writeSparkExample();

end