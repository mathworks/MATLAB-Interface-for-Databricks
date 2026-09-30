function cleanPath(options)
    % CLEANPATH Removes references to the package from the MATLAB path
    % Changes can be optionally saved to the path.
    % A pathdef.m path can optionally be specified.

    % Copyright MathWorks Inc. 2025

    arguments
        options.saveChange (1,1) logical = false
        options.verbose (1,1) logical = true
        options.pathdefPath string {mustBeTextScalar, mustBeNonzeroLengthText}
    end

    if ispc
        pathSep = ";";
    else
        pathSep = ":";
    end

    p = path;
    pEntries = split(p, pathSep);
    dbRoot = databricksRoot;

    pathChanged = false;
    for n = 1:numel(pEntries)
        if startsWith(pEntries{n}, dbRoot)
            if options.verbose
                fprintf("Removing MATLAB path entry: %s\n", pEntries{n});
            end
            pathChanged = true;
            rmpath(pEntries{n});
        end
    end

    if options.saveChange
        if ~pathChanged
            fprintf("No MATLAB path updates to save.\n");
        else
            if options.verbose
                fprintf("Saving updated MATLAB path.\n");
            end
            if isfield(options, "pathdefPath")
                savepath(options.pathdefPath);
            else
                savepath; % Save the updated path to the default location
            end
        end
    end


    jsEntries = javaclasspath('-static');
    for n = 1:numel(jsEntries)
        if startsWith(jsEntries{n}, dbRoot)
            if options.verbose
                fprintf(2, "Unable to removing static Java class path entry: %s\n", jsEntries{n});
                fprintf(2, "See: help javaclasspath\n");
            end
        end
    end

    pathChanged = false;
    jdEntries = javaclasspath('-dynamic');
    for n = 1:numel(jdEntries)
        if startsWith(jdEntries{n}, dbRoot)
            if options.verbose
                fprintf("Removing dynamic Java class path entry: %s\n", jdEntries{n});
            end
            pathChanged = true;
            javarmpath(jdEntries{n});
        end
    end

    if options.saveChange
        if pathChanged
            fprintf(2, "Not saving Java class path update.\n");
        else
        end
    end
end