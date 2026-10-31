function [rtwoptions, rtwgensettings] = sim_pandas_opts()
    % sim_pandas_opts Options and settings for the sim_pandas target
    % Called from sim_pandas.tlc
    %
    % Copyright 2024 The MathWorks, Inc.
    
    oIdx = 1;
    
    rtwoptions(oIdx).prompt         = 'SimPandas - code generation options';
    rtwoptions(oIdx).type           = 'Category';
    rtwoptions(oIdx).enable         = 'on';
    rtwoptions(oIdx).default        = 3;   % number of items under this category
    % excluding this one.
    rtwoptions(oIdx).popupstrings  = '';
    rtwoptions(oIdx).tlcvariable   = '';
    rtwoptions(oIdx).tooltip       = '';
    rtwoptions(oIdx).callback      = '';
    rtwoptions(oIdx).opencallback  = '';
    rtwoptions(oIdx).closecallback = '';
    rtwoptions(oIdx).makevariable  = '';
    
    oIdx = oIdx + 1;
    
    rtwoptions(oIdx).prompt         = 'Docker image version';
    rtwoptions(oIdx).type           = 'Edit';
    rtwoptions(oIdx).default        = '0.1.0';
    rtwoptions(oIdx).tlcvariable    = 'DBPoCDockerImageVersion';
    rtwoptions(oIdx).makevariable   = 'DBPOC_DOCKER_IMAGE_VERSION';
    
    oIdx = oIdx + 1;
    
    rtwoptions(oIdx).prompt         = 'Use threads for timing';
    rtwoptions(oIdx).type           = 'NonUI';
    rtwoptions(oIdx).default        = 'off';
    rtwoptions(oIdx).tlcvariable    = 'DBPoCUseThreadsForTiming';
    rtwoptions(oIdx).makevariable   = 'DBPOC_USE_THREADS_FOR_TIMING';
    rtwoptions(oIdx).tooltip = sprintf([...
        'If selected, threads will be used for doing the timing\n', ...
        'If unselected, a simple sleep routine will be used for timing.']);

    oIdx = oIdx + 1;
    
    rtwoptions(oIdx).prompt         = 'Build docker image';
    rtwoptions(oIdx).type           = 'Checkbox';
    rtwoptions(oIdx).default        = 'on';
    rtwoptions(oIdx).tlcvariable    = 'DBPoCBuildDockerImage';
    rtwoptions(oIdx).makevariable   = 'DBPOC_BUILD_DOCKER_IMAGE';
    rtwoptions(oIdx).tooltip = sprintf([...
        'If selected, the docker image will be built.\n', ...
        'If not, only the Dockerfile will be generated.']);
    
    %----------------------------------------%
    % Configure code generation settings %
    %----------------------------------------%

    rtwgensettings.Version        = '1'; % Specify callbacks' compliance with DAStudio dialog
    rtwgensettings.DerivedFrom    = 'ert_shrlib.tlc';
    rtwgensettings.BuildDirSuffix = '_sim_pandas';

    rtwgensettings.SelectCallback = 'sim_pandas_callback_handler(hDlg, hSrc, ''select'')';
    rtwgensettings.ActivateCallback = 'sim_pandas_callback_handler(hDlg, hSrc, ''activate'')';
    rtwgensettings.PostApplyCallback = 'sim_pandas_callback_handler(hDlg, hSrc, ''postapply'')';
    
end

