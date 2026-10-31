function build_mxyaml()
    % build_mxyaml A function to build the YAML parser
    %
    % This function relies on the YAML library found here: https://github.com/jbeder/yaml-cpp
    % This library is not part of this package. If you want to use this mex
    % function, you need to download and install the package on your own,
    % if you agree to the license under which that package is licensed. 
    %

    % Copyright 2022 The MathWorks, Inc.

    here = fileparts(mfilename("fullpath"));

    old = cd(here);
    goBack = onCleanup(@() cd(old));

    mex -R2018a mx_yaml.cpp -output ../mx_yaml -lyaml-cpp


end