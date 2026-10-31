classdef FileStorageInfo < handle
    % FileStorageInfo File storage information.
    % This location type is only available for clusters set up using Databricks Container Services.
    % The destination must be specified as a character vector or scalar string
    % If it is not prefixed with file: or file:/ this will be added.
    % Sample destination:  file:/my/file.sh

    % Copyright 2022 The MathWorks, Inc.

    properties
        % File destination. Example: file:/my/file.sh
        destination = char.empty
    end

    methods
        function obj = FileStorageInfo(destination)
            if ischar(destination) || isStringScalar(destination)
                destination = char(destination);
                if startsWith(destination, 'file:/')
                    obj.destination = destination;
                else
                    if startsWith(destination, '/')
                        obj.destination = ['file:', destination];
                    else
                        obj.destination = ['file:/', destination];
                    end
                end
            else
                error('DATABRICKS:FILESTORAGEINFO', 'Expected destination to be of type character vector or scalar string');
            end
        end
    end
end