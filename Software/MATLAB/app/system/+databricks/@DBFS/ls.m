function fileTable = ls(obj, varargin)
    % LS Method to list the files on the Databricks file system
    % This is similar to the databricks.DBFS/listFiles but provides the result
    % in an easy to read table format.

    %  (c) 2019-2022 MathWorks, Inc.

    % Call the list files method
    fileTable = table(obj.listFiles(varargin{:}));

    % Cast the path to string format
    fileTable.path = string(fileTable.path);

end %function
