function swo = buildModel(mdlName, options)
    % buildModel Build Simulink model for use with Python
    %
    % This function converts a Simulink model using Embedded Coder, into a
    % shared object and a corresponding Python package, to facilitate its
    % use.
    %
    %   swo = simwrapper.buildModel('my_model')
    %
    % To add a specific package name (recommended), use the option
    % 'packageName'.
    %
    %   swo = simwrapper.buildModel('my_model', packageName='some.userlib')
    %
    % In some cases, a clean build must be done. To achieve this, use the
    % option 'cleanBuild'
    %
    %   swo = simwrapper.buildModel('my_model', cleanBuild=true)

    % Copyright 2025 MathWorks, Inc.

    arguments
        mdlName(1,1) string
        options.cleanBuild (1,1) logical = false
        options.packageName (1,1) string = "mypkg.slpandas"
    end
    
    % The system must be loaded for certain operations.
    load_system(mdlName);

    % The model must use the sim_pandas target
    curTgt = get_param(mdlName, 'SystemTargetFile');
    if ~strcmp(curTgt, 'sim_pandas.tlc')
        error('SPARKAPI:sim_pandas_target_not_used', ...
            "The model '%s' must use the sim_pandas target in order to " + ...
            "be built with this function.", mdlName);
    end

    buildDirs = RTW.getBuildDir(mdlName);

    if options.cleanBuild

        slxcFile = mdlName + ".slxc";
        rtwDir = buildDirs.BuildDirectory;

        slprjDir = "slprj";
        % slprjDir = fileparts(dirs.ModelRefRelativeRootSimDir);

        if isfile(slxcFile)
            delete(slxcFile);
        end
        if isfolder(rtwDir)
            rmdir(rtwDir, 's');
        end
        if isfolder(slprjDir)
            rmdir(slprjDir, 's');
        end


    end

    cleanupAfterwards = setOptions(options); %#ok<NASGU>

    slbuild(mdlName);

    here = cd(buildDirs.BuildDirectory);
    goBack = onCleanup(@() cd(here));
    swo = simwrapper.SimWrapper();
end

function cleanupAfterwards = setOptions(options)

    fn = string(fieldnames(options));
    for k=1:numel(fn)
        FN = fn(k);
        simwrapper.Properties.setProp(FN, options.(FN));
    end
    cleanupAfterwards = onCleanup(@() simwrapper.Properties.clearData());
end

