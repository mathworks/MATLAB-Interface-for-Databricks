function generate_shrlib_wrapper(buildInfo)
    % generate_shrlib_wrapper  Helper function to generate wrapper code

    % Copyright 2024-2025 The MathWorks, Inc.


    swo = simwrapper.SimWrapper(buildInfo=buildInfo);

    % TODO: Use this when we get h/c files differently
    % swo.generateCode();
    
    hFile = swo.writeHeader();
    cFile = swo.writeSource();
    pyFile = swo.writePython(); %#ok<NASGU>

    swo.writeMATLABExample();
    swo.writePythonExample();
    swo.writeSparkExample();

    if nargin > 0
        buildInfo.addSourceFiles(cFile);
        buildInfo.addIncludeFiles(hFile);
    end

end