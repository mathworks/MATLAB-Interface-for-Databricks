function out = yamlencode(data, outputType, fileName)
    % yamlencode Convert MATLAB variable to YAML
    %
    % Converts a MATLAB variable to YAML encoding. The output can either be
    % returned or written to a file.
    %
    % Examples:
    % Return YAML as a string
    %
    %  out = matlab.sparkutils.internal.yamlencode(struct('a', pi, 'b', 'Hello'), 'string')
    %     out =
    %         'a: 3.1415926535897931
    %          b: Hello'
    %
    % Write YAML to a file
    % matlab.sparkutils.internal.yamlencode(struct('a', pi, 'b', 'Hello'), 'file', 'myfile.yaml')
    %
    % Not all MATLAB types are currently supported by this converter.
    
    % Copyright 2022 The MathWorks, Inc.

    if exist('mx_yaml', 'file') ~= 3
        buildYamlFile = getSparkApiRoot('app', 'mex', 'src', 'build_mxyaml.m');
        if ~isdeployed
            error('YAML:MEX_FILE_MISSING', [...
                'No Mex file has been built for YAML conversion\n', ...
                'Please refer to the build file for more info.\n', ...
                '<a href="matlab: edit(''%s'')">Open build file</a>\n'], ...
                buildYamlFile);
        else
            error('YAML:MEX_FILE_MISSING', [...
                'No Mex file has been built for YAML conversion\n', ...
                'Please refer to the build file for more info.\n', ...
                '%s'], ...
                buildYamlFile);
        end
    end

    switch char(outputType)
        case 'string'
            out = mx_yaml('encode', data, 'string');
        case 'file'
            mx_yaml('encode', data, 'file', char(fileName));
        otherwise
            error('YAML:BAD_ACTION_ARGUMENT', 'The first argument must be either "string" or "file"');
    end

end


