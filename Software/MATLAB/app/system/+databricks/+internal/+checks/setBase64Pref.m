function setBase64Pref(options)
    % setBase64Pref Sets the preference for which base 64 function to use, shipping or mex

    %  (c) 2023-2024 MathWorks, Inc.

    arguments
        options.verbose (1,1) logical = true
    end

    if options.verbose
        fprintf("Optimizing DBFS upload & download performance\n");
    end

    mexFile = "mxBase64" + "." + string(mexext);
    mexFileFull = fullfile(databricksRoot, "app", "mex", mexFile);
    
    if ismac
        matlab.net.base64('setconfig', 'shipping');
        if options.verbose
            fprintf("DBFS performance will be reduced on macOS by default\n");
            fprintf("Use: matlab.net.base64('setconfig', 'mex') and associated macOS permissions to enhance\n");
        end
    else
        if isfile(mexFileFull)
            matlab.net.base64('setconfig', 'mex');
            try
                cfg = matlab.net.base64('getconfig');
                if strcmp(cfg, 'mex')
                    data = char(matlab.net.base64('decode', 'SGVsbG8gYmFzZTY0'));
                    if strcmp(data, 'Hello base64')
                        % mex method is set and decode worked
                        if options.verbose
                            fprintf("Optimized transfers enabled\n");
                        end
                    else
                        matlab.net.base64('setconfig', 'shipping');
                        if options.verbose
                            fprintf(2, "DBFS performance will be reduced, optimized base64 support not functioning.\n");
                        end
                    end
                elseif strcmp(cfg, 'shipping')
                    if options.verbose
                        fprintf(2,"DBFS performance will be reduced, optimized preference not set.\n");
                    end
                else
                    matlab.net.base64('setconfig', 'shipping');
                    if options.verbose
                        fprintf(2,"DBFS performance will be reduced, unexpected preference value: %s\n", cfg);
                    end
                end
            catch me %#ok<NASGU>
                matlab.net.base64('setconfig', 'shipping');
                if options.verbose
                    fprintf(2, "DBFS performance will be reduced, unable to use optimized approach.\n");
                end
            end
        else
            matlab.net.base64('setconfig', 'shipping');
            if options.verbose
                fprintf(2, "DBFS performance will be reduced, optimized base64 support not found: %s\n", mexFileFull);
            end
        end
    end
end 