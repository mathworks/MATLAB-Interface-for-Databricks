function [tf, javaBuilderPath] = checkJavaBuilder()
    % checkJavaBuilder Tests for javabuilder.jar advises of potential limitations
    % An error is thrown if a local copy of JavaBuilder.jar cannot be found either
    % from MATLAB Compiler SDK or the MATLAB Runtime
    % If the MATLAB Runtime is installed in a non default directory the MCRROOT
    % environment variable can be used to indicate the location.

    %  (c) 2023-2024 MathWorks, Inc.

    if ~isempty(ver('compiler_sdk'))
        javaBuilderPath = fullfile(matlab.utils.toolboxDir('javabuilder'), 'jar', 'javabuilder.jar');
        if ~isfile(javaBuilderPath)
            % Should not arise
            tf = false;
            warning('DATABRICKS:INSTALL', 'MATLAB Compiler SDK is installed but javabuilder.jar was not found in MATLAB Compiler SDK Toolbox: %s', javaBuilderPath);
            javaBuilderPath = '';
        else
            tf = true;
        end
    else
        javaBuilderPath = matlab.databricks.ClusterInstall.getRuntimeJavaBuilderPath();
        if isfile(javaBuilderPath)
            tf = true;
        else
            tf = false;
            javaBuilderPath = '';
         end
    end

    if ~tf
        rtDownloadURL = 'https://www.mathworks.com/products/compiler/matlab-runtime.html';
        fprintf("Warning: javabuilder.jar not found\n");
        fprintf("  The dependency file javabuilder.jar could not be found.\n");
        fprintf("  Please install either the freely available MATLAB runtime from:\n");
          disp(['    <a href="', rtDownloadURL, '">', rtDownloadURL, '</a>']);
        fprintf("  or the MATLAB Compiler SDK Toolbox.\n\n");
        fprintf("  Installing the MATLAB Runtime will not enable deployed/compiled workflows,\n");
        fprintf("  but will allow the installation to proceed for other workflows.\n");
        fprintf("\n");
    end
end
