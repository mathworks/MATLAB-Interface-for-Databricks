function out = yamldecode(inputType, sourceData)
    % yamldecode Convert YAML to MATLAB data 
    %
    % Converts YAML encoding to a MATLAB variable. The output can either be
    % returned or written to a file.
    %
    % Examples:
    % Convert a YAML string
    %
    %  out = matlab.sparkutils.internal.yamldecode('string', 'a: [3, 4, ''hello'']')
    %     out =
    %       struct with fields:
    %
    %         a: {[3]  [4]  'hello'}
    %
    % Convert from YAML in a file
    % out = matlab.sparkutils.internal.yamldecode('file', 'mini.yml')
    %     out =
    %       struct with fields:
    %
    %         a: [1×1 struct]
    %         m: 'pancakes'
    %
    % Not all MATLAB types are currently supported by this converter.

    % Copyright 2022-2024 The MathWorks, Inc.

    if exist('mx_yaml', 'file') ~= 3
        buildYamlFile = char(getSparkApiRoot('app', 'mex', 'src', 'build_mxyaml.m'));
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
                '%s\n'], ...
                buildYamlFile);
        end
    end

    switch char(inputType)
        case 'string'
            out = mx_yaml('decode', 'string', char(sourceData));
        case 'file'
            out = mx_yaml('decode', 'file', char(sourceData));
        otherwise
            error('YAML:BAD_ACTION_ARGUMENT', 'The first argument must be either "string" or "file"');
    end

end


