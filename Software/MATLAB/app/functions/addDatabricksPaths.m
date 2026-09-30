function addDatabricksPaths(options)
    % ADDDATABRICKSPATHS - Script to add paths to MATLAB path
    % This script will add the paths below the Databricks root directory into the MATLAB path.
    % I.E. /Software/MATLAB
    %
    % Optional argument
    %   verbose: Logical to enable additional output, default is true.

    %  (c) 2026 MathWorks, Inc.

    arguments
        options.verbose (1,1) logical = true
        options.forceAddPaths (1,1) logical = false
    end

    if isdeployed
        fprintf(2, "Exiting addDatabricksPaths, addDatabricksPaths should not be called in deployed mode.\n");
        return;
    end

    existingDbxRoot = which('databricks.Object', '-all');
    if ~isempty(existingDbxRoot)
        if options.verbose
            fprintf("MATLAB Interface for Databricks already detected on the MATLAB path, skipping path configuration.\n");
        end
        if options.forceAddPaths
            if options.verbose
                fprintf("Forcing update of paths.")
            end
        else
            return;
        end
    end

    thisDir = pwd;
    cleanUp = onCleanup(@() cd(thisDir));

    % Get the databricksRoot directory without using databricksRoot, not yet on path
    here = fileparts(fileparts(fileparts(mfilename('fullpath'))));

    printBanner('Updating MATLAB Paths', verbose=options.verbose);

    %% Set up the paths to add to the MATLAB path
    % This should be the only section of the code that you need to modify
    % The second argument specifies whether the given directory should be
    % scanned recursively
    rootDirs={...
        fullfile(here,'app', 'functions'),false;...
        fullfile(here,'app', 'mex'),false;...
        fullfile(here,'app', 'system'),false;...
        fullfile(here,'..','..','Modules','matlab-jsonmapper','internal'),false;...
        fullfile(here,'toolbox'),false;...
        fullfile(here,'lib'),false;...
        fullfile(here,'config'),false;...
        fullfile(here,'script'),false;...
        fullfile(here,'sys','modules'),false;...
        fullfile(here,'test','unit'),false;...
        fullfile(here,'test','functional'),false;...
        };
    % Add the package to the path
    iAddFilteredFolders(rootDirs, verbose=options.verbose);
    if options.verbose
        fprintf("\n");
    end

    % Run module startups
    topLevel = fileparts(fileparts(here));
    modRoot = fullfile(topLevel, 'Modules');
    % Get a list of all modules
    mList = dir(fullfile(modRoot,'*'));
    for mCount = 1:numel(mList)
        % Only add proper folders
        mEntry = mList(mCount);
        dName = mEntry.name;
        if strcmp(dName,'.') || strcmp(dName,'..') || ~mEntry.isdir
            continue;
        end
        % Valid Module name
        candidateStartup = fullfile(modRoot,dName,'startup.m');
        if isfile(candidateStartup)
            % We have a module with a startup
            candidateDir = fullfile(modRoot,dName);
            thisStartupDir = cd(candidateDir);
            startup(verbose=options.verbose);
            cd(thisStartupDir);
        else
            candidateStartup = fullfile(modRoot,dName,'Software', 'MATLAB', 'startup.m');
            if isfile(candidateStartup)
                % We have a module with a startup
                candidateDir = fullfile(modRoot,dName,'Software', 'MATLAB');
                thisStartupDir = cd(candidateDir);
                startup(verbose=options.verbose);
                cd(thisStartupDir);
            else
                % Don't add folders without startup.m
            end
        end
    end
end


function printBanner(str, options)
    arguments
        str string {mustBeTextScalar, mustBeNonzeroLengthText}
        options.leadingNewline (1,1) logical = true
        options.verbose (1,1) logical = true
    end

    % Don't print anything if not verbose
    if ~options.verbose
        return;
    end

    if options.leadingNewline
        fprintf("\n");
    end
    disp([char(str), newline,repmat('-',1,strlength(str))]);
end



function iAddFilteredFolders(rootDirs, options)
    % iAddFilteredFolders Helper function to add all folders to the path
    arguments
        rootDirs
        options.verbose (1,1) logical = true
    end

    % Loop through the paths and add the necessary subfolders to the MATLAB path
    for pCount = 1:size(rootDirs,1)

        rootDir=rootDirs{pCount,1};
        if rootDirs{pCount,2}
            % recursively add all paths
            rawPath=genpath(rootDir);

            if ~isempty(rawPath)
                rawPathCell=textscan(rawPath,'%s','delimiter',pathsep);
                rawPathCell=rawPathCell{1};
            else
                rawPathCell = {rootDir};
            end

        else
            % Add only that particular directory
            rawPath = rootDir;
            rawPathCell = {rawPath};
        end

        % Remove undesired paths
        svnFilteredPath=strfind(rawPathCell,'.svn');
        gitFilteredPath=strfind(rawPathCell,'.git');
        slprjFilteredPath=strfind(rawPathCell,'slprj');
        sfprjFilteredPath=strfind(rawPathCell,'sfprj');
        rtwFilteredPath=strfind(rawPathCell,'_ert_rtw');

        % Loop through path and remove all the .svn entries
        if ~isempty(svnFilteredPath)
            for pCount=1:length(svnFilteredPath) %#ok<FXSET>
                filterCheck=[svnFilteredPath{pCount},...
                    gitFilteredPath{pCount},...
                    slprjFilteredPath{pCount},...
                    sfprjFilteredPath{pCount},...
                    rtwFilteredPath{pCount}];
                if isempty(filterCheck)
                    iSafeAddToPath(rawPathCell{pCount}, verbose=options.verbose);
                else
                    % ignore
                end
            end
        else
            iSafeAddToPath(rawPathCell{pCount}, verbose=options.verbose);
        end
    end
end


function iSafeAddToPath(pathStr, options)
    % iSafeAddToPath Helper function to add to MATLAB path.
    arguments
        pathStr string {mustBeTextScalar, mustBeNonzeroLengthText}
        options.verbose (1,1) logical = true
    end

    % Add to path if the file exists
    if exist(pathStr,'dir')
        if options.verbose
            fprintf('Adding %s\n',pathStr);
        end
        addpath(pathStr);
    else
        if options.verbose
            fprintf('Skipping %s\n',pathStr);
        end
    end
end
