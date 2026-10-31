function result = wheelScan(whlFile, options)
    % wheelScan Scans a .whl file for unwanted embedded binary components
    %
    % Optional named arguments:
    %     execArch: Architecture to be used for execution.
    %               Default: "GLNXA64"
    % 
    %   extractDir: Directory to extract the .whl contents too.
    %               Default: tempname()
    %
    %   ignoreList: String array of filenames to be ignored (case sensitive)
    %               Default: ""
    %
    %      cleanUp: Delete the extract directory upon completion.
    %               Default: true
    %
    %      verbose: Produce additional output.
    %               Default: true
    %
    % Examples:
    %
    % tf = matlab.utils.internal.wheelscan.wheelScan("mypackagename-26.1.0-py3-none-any.whl");
    %
    % tf = matlab.utils.internal.wheelscan.wheelScan("mypackagename-26.1.0-py3-none-any.whl", ignoreList=["libMatlabDataArray.dll", "mxBase64.mexw64"])

    % (c) 2026 MathWorks 2026

    arguments (Input)
        whlFile string {mustBeFile, mustBeTextScalar, mustBeNonzeroLengthText}
        options.execArch string = "GLNXA64"
        options.extractDir string {mustBeTextScalar, mustBeNonzeroLengthText} = tempname
        options.ignoreList string = ""
        options.cleanUp (1,1) logical = true
        options.verbose (1,1) logical = true
    end

    arguments (Output)
        result (1,1) logical
    end

    if options.verbose
        fprintf("Scanning wheel file: %s\n", whlFile);
        fprintf("Target architecture: %s\n", options.execArch);
    end

    result = true;

    [goodSO, badSOs] = getSOExts(options.execArch);
    [goodMex, badMexs] = getMexExts(options.execArch);
    
    if ~isfolder(options.extractDir)
        createExtDir(options.extractDir, verbose=options.verbose);
    end

    if options.cleanUp
        cleanupResult = onCleanup(@() cleanUpExtDir(options.extractDir, verbose=options.verbose));
    end

    whlFilenames = unzip(whlFile, options.extractDir);

    for n = 1:numel(whlFilenames)
        if ~scanFile(whlFilenames{n}, options.execArch, options.extractDir, goodSO, badSOs, goodMex, badMexs, options.ignoreList, verbose=options.verbose)
            result = false;
        end
    end

    if options.verbose
        fprintf("Scan complete:");
        if result
            fprintf(" passed.\n");
        else
            fprintf(" failed.\n");
        end
    end
end


function tf = scanFile(filename, execArch, extractDir, goodSO, badSOs, goodMex, badMexs, ignoreList, options)
    arguments (Input)
        filename string {mustBeFile, mustBeTextScalar, mustBeNonzeroLengthText}
        execArch string {mustBeTextScalar, mustBeNonzeroLengthText}
        extractDir string {mustBeTextScalar, mustBeNonzeroLengthText}
        goodSO string {mustBeTextScalar, mustBeNonzeroLengthText}
        badSOs string {mustBeNonzeroLengthText}
        goodMex string {mustBeTextScalar, mustBeNonzeroLengthText}
        badMexs string {mustBeNonzeroLengthText}
        ignoreList string
        options.verbose (1,1) logical = true
    end
    arguments (Output)
        tf (1,1) logical
    end

    tf = true;

    if options.verbose
        fprintf("Scanning: %s\n", filename);
    end

    if endsWith(lower(filename), '.ctf')
        if ~scanCTF(filename, execArch, extractDir, goodSO, badSOs, goodMex, badMexs, ignoreList, verbose=options.verbose)
            if options.verbose
                fprintf(2, "CTF scan failed for: %s\n", filename);
            end
            tf = false;
        end
    elseif endsWith(lower(filename), goodSO)
        if options.verbose
            fprintf("Found compatible shared object file: %s\n", filename);
        end
    elseif endsWith(lower(filename), badSOs)
        [~, f, e] = fileparts(filename);
        if any(contains(ignoreList, [f, e]))
            if options.verbose
                fprintf("Ignoring incompatible shared object file: %s\n", filename);
            end
        else
            tf = false;
            if options.verbose
                fprintf(2, "Found an incompatible shared object file: %s\n", filename);
            end
        end
    elseif endsWith(lower(filename), goodMex)
        if options.verbose
            fprintf("Found compatible mex file: %s\n", filename);
        end
    elseif endsWith(lower(filename), badMexs)
        [p, f, e] = fileparts(filename);
        goodFilename = string(f) + goodMex;
        % must get the current directory to allow for case matching on ext
        currDirNamesStruct = dir(p);
        currDirNames = {currDirNamesStruct(:).name};
        if any(contains(currDirNames, goodFilename, IgnoreCase=false))
            if options.verbose
                fprintf("Okay, found a corresponding compatible mex file: %s\n", fileparts(p, goodFilename));
            end
        else
            if any(contains(ignoreList, [f, e]))
                if options.verbose
                    fprintf("Ignoring incompatible mex file: %s\n", filename);
                end
            else
                if options.verbose
                    fprintf(2, "Found an incompatible mex file: %s\n", filename);
                end
                tf = false;
            end
        end
    elseif endsWith(lower(filename), '.exe')
        if ~checkExe(filename, execArch, ignoreList, verbose=options.verbose)
            tf = false;
        end
    end
end


function result = scanCTF(filename, execArch, extractDir, goodSO, badSOs, goodMex, badMexs, ignoreList, options)
    arguments (Input)
        filename string {mustBeFile, mustBeTextScalar, mustBeNonzeroLengthText}
        execArch string {mustBeTextScalar, mustBeNonzeroLengthText}
        extractDir string {mustBeTextScalar, mustBeNonzeroLengthText}
        goodSO string {mustBeTextScalar, mustBeNonzeroLengthText}
        badSOs string {mustBeNonzeroLengthText}
        goodMex string {mustBeTextScalar, mustBeNonzeroLengthText}
        badMexs string {mustBeNonzeroLengthText}
        ignoreList string
        options.verbose (1,1) logical = true
    end
    arguments (Output)
        result (1,1) logical
    end

    result = true;
    if options.verbose
        fprintf("Scanning CTF: %s\n", filename);
    end

    [~, f, ~] = fileparts(filename);
    ctfExtractDir = fullfile(extractDir, string(f) + "_extracted_ctf");
    if ~isfolder(ctfExtractDir)
        createExtDir(extractDir, verbose=options.verbose);
    end

    ctfFilenames = unzip(filename, ctfExtractDir);

    for n = 1:numel(ctfFilenames)
        if ~scanFile(ctfFilenames{n}, execArch, ctfExtractDir, goodSO, badSOs, goodMex, badMexs, ignoreList, verbose=options.verbose)
            result = false;
        end
    end
end


function [goodSO, badSOs] = getSOExts(execArch)
    % getSOExts Returns good and bad shared object extensions for the given architecture
    % Return results in lower case.
    arguments (Input)
        execArch string {mustBeTextScalar, mustBeNonzeroLengthText}
    end
    arguments (Output)
        goodSO string {mustBeTextScalar, mustBeNonzeroLengthText}
        badSOs string {mustBeNonzeroLengthText}
    end

    switch upper(execArch)
        case "WIN64"
            goodSO = ".dll";
            badSOs = [".so", ".dylib"];

        case "GLNXA64"
            goodSO = ".so";
            badSOs = [".dll", ".dylib"];

        case "MACI64"
            goodSO = ".dylib";
            badSOs = [".so", ".dll"];

        otherwise
            error("Unsupported execution architecture: %s", execArch);
    end
end


function [goodMex, badMexs] = getMexExts(execArch)
    arguments (Input)
        execArch string {mustBeTextScalar, mustBeNonzeroLengthText}
    end
    arguments (Output)
        goodMex string {mustBeTextScalar, mustBeNonzeroLengthText}
        badMexs string {mustBeNonzeroLengthText}
    end

    switch upper(execArch)
        case "WIN64"
            goodMex = ".mexw64";
            badMexs = [".mexa64", ".mexmaca64"];

        case "GLNXA64"
            goodMex = ".mexa64";
            badMexs = [".mexw64", ".mexmaca64"];

        case "MACI64"
            goodMex = ".mexmaca64";
            badMexs = [".mexw64", ".mexa64"];

        otherwise
            error("Unsupported execution architecture: %s", execArch);
    end
end


function cleanUpExtDir(extDir, options)
    arguments (Input)
        extDir string {mustBeFolder, mustBeTextScalar, mustBeNonzeroLengthText}
        options.verbose (1,1) logical = true
    end
    if options.verbose
        fprintf("Removing extraction directory: %s\n", extDir);
    end
    [status, msg] = rmdir(extDir, "s");
    if ~status
        error("Error removing extraction directory: %s\nMessage: %s", extDir, msg);
    end
end


function createExtDir(extDir, options)
    arguments (Input)
        extDir string {mustBeTextScalar, mustBeNonzeroLengthText}
        options.verbose (1,1) logical = true
    end
    if options.verbose
        fprintf("Creating extraction directory: %s\n", extDir);
    end
    [status, msg] = mkdir(extDir);
    if ~status
        error("Error creating extraction directory: %s\nMessage: %s", extDir, msg);
    end
end


function result = checkMZHeader(filename)
    arguments (Input)
        filename string {mustBeFile, mustBeTextScalar, mustBeNonzeroLengthText}
    end
    arguments (Output)
        result (1,1) logical
    end

    fid = fopen(filename, 'r');
    if fid == -1
        error("Unable to open file: %s", filename);
    end
    h = fread(fid, 10, 'uint8');
    if h(1)==hex2dec('4d') && h(2)==hex2dec('5a')
        result = true;
    else
        result = false;
    end
end


function result = checkMachoHeader(filename)
    arguments (Input)
        filename string {mustBeFile, mustBeTextScalar, mustBeNonzeroLengthText}
    end
    arguments (Output)
        result (1,1) logical
    end

    fid = fopen(filename, 'r');
    if fid == -1
        error("Unable to open file: %s", filename);
    end
    h = fread(fid, 10, 'uint8');
    % DEL ELF header magic bytes: 0x7f 0x45 0x4c 0x46
    if h(1)==hex2dec('CA') &&  h(2)==hex2dec('FE') && h(3)==hex2dec('BA') &&  h(4)==hex2dec('BE')
        result = true;
    else
        result = false;
    end
end


function result = checkELFHeader(filename)
    arguments (Input)
        filename string {mustBeFile, mustBeTextScalar, mustBeNonzeroLengthText}
    end
    arguments (Output)
        result (1,1) logical
    end

    fid = fopen(filename, 'r');
    if fid == -1
        error("Unable to open file: %s", filename);
    end
    h = fread(fid, 10, 'uint8');
    % DEL ELF header magic bytes: 0x7f 0x45 0x4c 0x46
    if h(1)==hex2dec('7f') &&  h(2)==hex2dec('45') && h(3)==hex2dec('4c') &&  h(4)==hex2dec('46')
        result = true;
    else
        result = false;
    end
end


function result = checkExe(filename, execArch, ignoreList, options)
    arguments (Input)
        filename string {mustBeFile, mustBeTextScalar, mustBeNonzeroLengthText}
        execArch string
        ignoreList string
        options.verbose (1,1) logical = true
    end
    arguments (Output)
        result (1,1) logical
    end

    % See: https://en.wikipedia.org/wiki/List_of_file_signatures
    
    result = true;
    [~, f, e] = fileparts(filename);
    if any(contains(ignoreList, [f, e]))
        if options.verbose
            fprintf("Ignoring exe file: %s\n", filename);
        end
    else
        switch upper(execArch)
            case "WIN64"
                headerTf = checkMZHeader(filename);

            case "GLNXA64"
                headerTf = checkELFHeader(filename);

            case "MACI64"
                headerTf = checkMachoHeader(filename);

            otherwise
                error("Unsupported execution architecture: %s", execArch);
        end
        if headerTf
            fprintf(2, "Found compatible exe file: %s\n", filename);
        else
            fprintf(2, "Found an incompatible exe file: %s\n", filename);
        end
        result = headerTf;
    end
end
