function doesSupport = hasMWStringArray()
    % hasMWStringArray Returns true if release support MWStringArray
    %
    % This is an internal function, and not part of the API.

    % Copyright 2021-2022 MathWorks, Inc.

    % This function was created to distinguish between releases that support MWStringArray
    % as opposed to only MWCharArray. MWStringArray, however, does not work with
    % out-of-process MATLAB Runtime, so this has been changed to always use MWCharArray.
    % This may be changed in the future, if MWStringArray can be used out-of-process.
    doesSupport = false;
    % doesSupport = ~verLessThan('matlab', '9.9');

end


