function tf = isAppleSilicon()
    % ISAPPLESILICON Returns true is running macOS on Apple silicon systems
    % Otherwise false is returned.
    % This function works on MATLAB x86 releases running via Rosetta 2
    % on Apple silicon hardware.
    %
    % Example
    %   tf = matlab.utils.isAppleSilicon();

    % Copyright 2024 The MathWorks, Inc.

    if ~ismac
        tf = false;
        return;
    else
        [status, cmdOut] = system("sysctl machdep.cpu.brand_string");
        if status ~= 0
            fprintf(2, "sysctl machdep.cpu.brand_string returned: %d", status);
            tf = false;
        else
            if startsWith(cmdOut, "machdep.cpu.brand_string: Apple")
                tf = true;
            else
                tf = false;
            end
        end
    end
end

