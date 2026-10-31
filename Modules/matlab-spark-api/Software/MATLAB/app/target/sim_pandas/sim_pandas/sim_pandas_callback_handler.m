function sim_pandas_callback_handler(hDlg, hSrc, action)
    % sim_pandas_callback_handler

    % Copyright 2024 The MathWorks, Inc.

    % fprintf("%s: %s\n", mfilename, action);

    switch action
        case 'select'
            % First do inherited settings.
            ert_shrlib_callback_handler(hDlg, hSrc);

            % Now specific ones for the interface.
            setve('CodeInterfacePackaging', 'Reusable function', 'off');
            setve('RootIOFormat', 'Part of model data structure', 'off');
        otherwise
            % Do nothing here
    end
    function setve(opt, value, onoff)
        slConfigUISetVal(hDlg, hSrc, opt, value);
        slConfigUISetEnabled(hDlg, hSrc, opt, onoff);
    end
end

