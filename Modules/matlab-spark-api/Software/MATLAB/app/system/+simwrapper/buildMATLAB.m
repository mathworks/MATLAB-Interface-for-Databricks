function buildMATLAB(matlabFun, funArgs)
    % buildMATLAB Build MATLAB function for use with Python

    % Copyright 2024 MathWorks, Inc.


    %% Create configuration object of class 'coder.EmbeddedCodeConfig'.
    cfg = coder.config('dll','ecoder',true);
    cfg.GenerateReport = true;
    cfg.ReportPotentialDifferences = false;
    cfg.MultiInstanceCode = true;
    cfg.PostCodeGenCommand = "simwrapper.buildMATLAB_pb(projectName, buildInfo)";

    %% Define argument types for entry-point 'getDistanceFromLatLonInKm'.
    ARGS = cell(1,1);
    N = numel(funArgs);
    ARGS{1} = cell(N,1);
    for k=1:N
        ARGS{1}{k} = coder.typeof(funArgs{k});
    end
    %% Invoke MATLAB Coder.
    coderArgs = {...
        '-v', ...
        '-config', cfg, ...
        matlabFun, ...
        '-args', ARGS{1}, ...
        }
    codegen(coderArgs{:});
end