function build_mxBase64()
    % Build_mxBase64 Function to build the mex-function mxBase64

    % Copyright 2020-2022 MathWorks, Inc.

    srcCode = fullfile(databricksRoot,'app','mex','src','mxBase64.c');
    dstDir = fullfile(databricksRoot,'app', 'mex');

    mex('-R2018a', '-outdir', dstDir, srcCode);

end