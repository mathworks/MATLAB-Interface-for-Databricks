classdef WorkspaceStorageInfo < handle
    % WorkspaceStorageInfo File destination. Example: /Users/someone@example.com/init_script.sh
    % The destination must be specified as a character vector or scalar string

    % Copyright 2023 The MathWorks, Inc.

    properties
        % Workspace destination. Example: /Users/someone@example.com/init_script.sh
        destination = char.empty
    end

    methods
        function obj = WorkspaceStorageInfo(destination)
            if ~(ischar(destination) || isStringScalar(destination))
                error('DATABRICKS:WORKSPACESTORAGEINFO', 'Expected destination to be of type character vector or scalar string');
            end
            destination = char(destination);
            if ~startsWith(destination, '/Users')
                warning('DATABRICKS:WORKSPACESTORAGEINFO', 'Expected destination to start with /Users: %s', destination);
            end
            obj.destination = destination;
        end
    end
end