function out = base64(action, data)
    % BASE64 base64 encoder/decoder for Databricks
    % An optimized base64 encoder/decoder for MATLAB
    %
    % This is a wrapper, that will either call the shipping base64
    % encoder/decoder, or use the mex-file provided with this package.
    %
    % Examples:
    % % Check what configuration is used (will return 'shipping' or 'mex')
    % matlab.net.base64('getconfig')
    % ans =
    %    'shipping'
    %
    % % Set what configuration to use ('shipping' and 'mex' possible)
    % matlab.net.base64('setconfig', 'mex')
    %
    % % Encode data
    % encodedData = matlab.net.base64('encode', 'Hello base64')
    % encodedData =
    %     'SGVsbG8gYmFzZTY0'
    %
    % % Decode data
    % data = char(matlab.net.base64('decode', 'SGVsbG8gYmFzZTY0'))
    % data =
    %     'Hello base64

    % Copyright 2020-2022 MathWorks, Inc.

    persistent UseShipping Base64Pref
    if isempty(UseShipping)
        if ~ispref('databricks', 'base64')
            [Base64Pref, UseShipping] = setConfig('mex');
        else
            Base64Pref = getpref('databricks', 'base64');
            UseShipping = strcmp(Base64Pref, 'shipping');
        end
    end

    switch action
        case 'getconfig'
            out = Base64Pref;
        case 'setconfig'
            [UseShipping, Base64Pref] = setConfig(data);
        case 'encode'
            if UseShipping
                out = matlab.net.base64encode(data);
            else
                out = mxBase64('encode', uint8(data));
            end
        case 'decode'
            if UseShipping
                out = matlab.net.base64decode(data);
            else
                out = mxBase64('decode', uint8(data));
            end
        otherwise
            error('DATABRICKS:ERROR', ...
                'Unallowed action: "%s"\nAllowed actions are:%s\n', ...
                action, ...
                '"getconfig" "setconfig" "encode" "decode"');
    end

end

function [useShipping, base64Pref] = setConfig(cfgType)
    if strcmp(cfgType, 'shipping')
        useShipping = true;
        base64Pref = cfgType;
        setpref('databricks', 'base64', base64Pref);
    elseif strcmp(cfgType, 'mex')
        if exist('mxBase64', 'file') == 3
            useShipping = false;
            base64Pref = cfgType;
            setpref('databricks', 'base64', base64Pref);
        else
            % Fallback to shipping
            [useShipping, base64Pref] = setConfig('shipping');
            warning('DATABRICKS:WARNING', ...
                ['Couldn''t switch to mex for base64.', ...
                'The file mxBase64 has not been built.', newline, ...
                'Try calling the file build_mxBase64.m, ', ...
                'located in "', ...
                databricksRoot('app', 'mex', 'src'), ...
                '"']);
        end
    else
        error('DATABRICKS:ERROR', ...
            'Unallowed setting: "%s"\nAllowed setting are "shipping" or "mex"', cfgType);
    end

end


