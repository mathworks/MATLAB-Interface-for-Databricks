classdef DbfsStorageInfo < handle
    % DbfsStorageInfo DBFS storage information Example: dbfs:/my/path
    % The destination must be specified as a character vector or scalar string
    % If it is not prefixed with dbfs: or dbfs:/ this will be added.

    % Copyright 2022 The MathWorks, Inc.

    properties
        % DBFS destination. Example: dbfs:/my/file.sh
        destination = char.empty
    end

    methods
        function obj = DbfsStorageInfo(destination)
            if ~(ischar(destination) || isStringScalar(destination))
                error('DATABRICKS:DBFSSTORAGEINFO', 'Expected destination to be of type character vector or scalar string');
            end
            destination = char(destination);
            if startsWith(destination, 'dbfs:/')
                obj.destination = destination;
            else
                if startsWith(destination, '/')
                    obj.destination = ['dbfs:', destination];
                else
                    obj.destination = ['dbfs:/', destination];
                end
            end
        end
    end
end