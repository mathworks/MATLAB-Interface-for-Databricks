function javaBuilderLoc = getJavaBuilderPath(silent)
    % getJavaBuilderPath Return the MATLAB Runtime javabuilder.jar path
    % First try the MATLAB Java Builder toolbox dir, then check for a local runtime
    % Check MCRROOT env. var. then default paths
    % If the silent argument is set to logical true then an error will not be thrown
    % if the file cannot be found, the default is false, throw the error.
    
    arguments
        silent (1,1) logical = false;
    end

    try
        jbDir = toolboxdir('javabuilder');
        javaBuilderLoc = fullfile(jbDir, "jar", "javabuilder.jar");
    catch ME
        if (strcmp(ME.identifier,'SPARKUTILS:DIRECTORYNOTFOUND'))
            javaBuilderLoc = '';
        else
            rethrow(ME);
        end
    end
    
    if isempty(javaBuilderLoc)
        mcrroot = getenv('MCRROOT');
        if strlength(mcrroot) > 0
            javaBuilderLoc =  fullfile(mcrroot, 'toolbox', 'javabuilder', 'jar', 'javabuilder.jar');
        else
            if verLessThan('matlab', "9.13") % R2022b
                v = ver('matlab');
                if ~isscalar(v)
                    error("SPARKUTILS:GETJAVABUILDERPATH", "Unexpected nonscalar ver('matlab') output, possibly caused by a misconfigured Contents.m file on the path");
                end
                str = ['v', char(v.Version)];
                rtDir = strrep(str, '.', '');
            else
                rtDir = ['R', char(version('-release'))];
            end
            if ispc
                javaBuilderLoc = fullfile('c:\Program Files', 'MATLAB', 'MATLAB Runtime', rtDir, 'toolbox', 'javabuilder', 'jar', 'javabuilder.jar');
            elseif ismac
                javaBuilderLoc = fullfile('/Applications/MATLAB/MATLAB_Runtime', rtDir, 'toolbox', 'javabuilder', 'jar', 'javabuilder.jar');
            elseif isunix
                javaBuilderLoc = fullfile('/usr/local/MATLAB/MATLAB_Runtime', rtDir, 'toolbox', 'javabuilder', 'jar', 'javabuilder.jar');
            else
                error('SPARKUTILS:GETJAVABUILDERPATH', 'Platform not supported: %s', computer);
            end
        end
    end

    if ~silent
        if ~isfile(javaBuilderLoc)
            error("SPARKUTILS:GETJAVABUILDERPATH", "javabuilder.jar was not found in the MATLAB or MATLAB Runtime directories");
        end
    end
end
