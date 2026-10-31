function startup(options)
    %% STARTUP - Script to add my paths to MATLAB path
    % This script will add the paths below the root directory into the MATLAB
    % path. It will omit the SVN and other crud.  You may modify undesired path
    % filter to your desire.

    %  (c) 2019-2024 MathWorks, Inc.

    arguments
        options.verbose (1,1) logical = true
    end

    if options.verbose
        displayBanner('Adding MLFlow paths');
    end

    if ~usejava('jvm')
        error('MLFLOW:STARTUP', 'MATLAB must be used with the JVM enabled');
    end

    % Pull up to same level as databricks
    if verLessThan('matlab', '9.13') %#ok<VERLESSMATLAB>
        fprintf(2, 'This package requires MATLAB R2022b or later\n.');
    end

    %% Set up the paths to add to the MATLAB path
    % This should be the only section of the code that you need to modify
    % The second argument specifies whether the given directory should be
    % scanned recursively
    here = fileparts(mfilename('fullpath'));

    rootDirs={...
        fullfile(here,'app', 'functions'),false;...
        fullfile(here,'app', 'system'),false;...
        fullfile(here,'lib'),false;...
        fullfile(here,'config'),false;...
        fullfile(here,'test','unit'),false;...
        };

    %% Add the framework to the path
    iAddFilteredFolders(rootDirs, verbose=options.verbose);

    % No modules used
    % %% Handle the modules for the project.
    % disp('Initializing all modules');
    % modRoot = fullfile(here,'sys','modules');

    % % Get a list of all modules
    % mList = dir(fullfile(modRoot));
    % for mCount = 1:numel(mList)
    %     % Only add proper folders
    %     mEntry = mList(mCount);
    %     dName = mEntry.name;
    %     if strcmp(dName,'.') || strcmp(dName,'..') || ~mEntry.isdir
    %         continue;
    %     end
    %     % Valid Module name
    %     candidateStartup = fullfile(modRoot,dName,'startup.m');
    %     if exist(candidateStartup,'file')
    %         % We have a module with a startup
    %         run(candidateStartup);
    %     else
    %         candidateStartup = fullfile(modRoot,dName,'Software', 'MATLAB', 'startup.m');
    %         if exist(candidateStartup,'file')
    %             % We have a module with a startup
    %             run(candidateStartup);
    %         else
    %             % Don't add folders without startup.m
    %         end
    %     end
    % end

    %% Post path-setup operations
    if options.verbose
        fprintf("\n");
    end
end

%% iAddFilteredFolders Helper function to add all folders to the path
function iAddFilteredFolders(rootDirs, options)
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

        % remove undesired paths
        svnFilteredPath=strfind(rawPathCell,'.svn');
        gitFilteredPath=strfind(rawPathCell,'.git');
        slprjFilteredPath=strfind(rawPathCell,'slprj');
        sfprjFilteredPath=strfind(rawPathCell,'sfprj');
        rtwFilteredPath=strfind(rawPathCell,'_ert_rtw');

        % loop through path and remove all the .svn entries
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

    %% Post path-setup operations

    % Example: Change to a particular directory
    % cd( fullfile( here, 'examples' ) );

    % Example: Setup Simulink code generation folders
    %myCacheFolder = fullfile('C:','cachefolder');
    %myCodeGenFolder = pwd;
    %Simulink.fileGenControl('set', 'CacheFolder', myCacheFolder, ...
    %   'CodeGenFolder', myCodeGenFolder);

    % Example: Setup Java dynamic path
    %iSafeAddToJavaPath(fullfile(spellroot,'lib','java','MATLABSpellCheck','dist','MATLABSpellCheck.jar'));

end

%% Helper function to add to MATLAB path.
function iSafeAddToPath(pathStr, options)
    arguments
        pathStr string
        options.verbose (1,1) logical = true
    end

    % Add to path if the file exists
    if exist(pathStr,'dir')
        if options.verbose
            fprintf('Adding: %s\n',pathStr);
        end
        addpath(pathStr);
    else
        if options.verbose
            fprintf('Skipping: %s\n',pathStr);
        end
    end
end

%% Helper function to add to the Dynamic Java classpath
function iSafeAddToJavaPath(pathStr, options) %#ok<DEFNU>
    arguments
        pathStr string
        options.verbose (1,1) logical = true
    end

    % Check the current java path
    jPaths = javaclasspath('-dynamic');

    % Add to path if the file exists
    if exist(pathStr,'dir')
        if options.verbose
            fprintf('Adding: %s\n',pathStr);
        end
        if ~strcmpi(pathStr, jPaths)
            addpath(pathStr);
        else
            if options.verbose
                fprintf('Skipping: %s\n',pathStr);
            end
        end
    elseif isfile( pathStr )
        javaaddpath( pathStr );
    else
        fprintf('Skipping: %s\n',pathStr);
    end
end


function displayBanner(appStr) %#ok<DEFNU>
    % Helper function to create a banner
    disp(appStr);
    disp(repmat('-',1,numel(appStr)));
end