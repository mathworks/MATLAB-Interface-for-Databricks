function generateWheel(swo, options)
    % generateWheel Generate wheel file
    %
    % This function takes additional arguments for potentially uploading
    % the wheel file to Databricks
    %
    % swo.generateWheel(upload=true, uploadDirectory="/Volumes/main/default/myvolume/MyWheels")
    %
    % The default is to not upload it.
    %
    % If no uploadDirectory is specified, it will use the
    % interfaceDirectory from the settings, and removing the MathWorks
    % ending, if it exists.
    %
    % If the file is not directly uploaded here, it can later be uploaded
    % using the uploadWheel method.

    % Copyright 2025 MathWorks, Inc.

    arguments
        swo (1,1) simwrapper.SimWrapper
        options.upload (1,1) logical = false
        options.uploadDirectory string
    end

    old = cd(swo.BaseFolder);
    goBack = onCleanup(@() cd(old));

    swo.writeSetupPython();

    % Build the wheel file
    pe = pyenv;
    command = sprintf('%s -m build -w -n', pe.Executable);
    [r,s] = system(command);

    if r~=0
        error("SPARKAPI:codegen_wheel_build", ...
            "Problems building wheel file.\n%s\n", s);
    end

    swo.writeNotebookExample();


    if options.upload
        if isfield(options, 'uploadDirectory')
            swo.uploadWheel(uploadDirectory=options.uploadDirectory);
        else
            swo.uploadWheel();
        end        
    end

end