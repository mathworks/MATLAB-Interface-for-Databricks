% Script to package (.mlapp) as a MATLAB toolbox (.mltbx)

% Copyright 2026 MathWorks Inc.

% Setup:
% Begin by copying the example to a temporary working location:
workDir = fullfile(tempdir, "ClusterTable");
copyfile(databricksRoot("examples", "AppDesigner", "ClusterTable"), workDir);
fprintf("Working directory: %s\n", workDir);
cd(workDir);


% Build:
% For more details on packaging options see:
%   https://mathworks.com/help/releases/R2025b/matlab/ref/matlab.addons.toolbox.toolboxoptions.html

% App's unique id 
uuid = "d2fe0e9a-7f41-4d54-826f-7d3c7e0edb0b";
opts = matlab.addons.toolbox.ToolboxOptions(pwd, uuid);
opts.ToolboxName = "ClusterTable";
opts.ToolboxVersion = "1.0";
opts.ToolboxFiles = "ClusterTable.mlapp";
opts.OutputFile = fullfile(workDir, "ClusterTable");
opts.ToolboxImageFile = "icon.png";

% Recommended to use >= R2024b as this works best with the MATLAB on Databricks
% Reference Architecture https://github.com/mathworks-ref-arch/matlab-on-databricks
opts.MinimumMatlabRelease = "R2024b";

matlab.addons.toolbox.packageToolbox(opts)

% The following command will install the toolbox after packaging:
matlab.addons.install(opts.OutputFile)

% Launch the App
ClusterTable

% Clean up
% To uninstall the toolbox when no longer needed:
% s = struct;
% s.Name = opts.ToolboxName;
% s.Guid = uuid;
% s.Version = opts.ToolboxVersion;
% matlab.addons.toolbox.uninstallToolbox(s)

% To delete the current working directory copy of the example:
% [status, message, messageid] = rmdir(workDir, "s")
