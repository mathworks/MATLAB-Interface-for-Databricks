function tableResult = table(obj, varargin)
    % TABLE Method to convert a list of files to a MATLAB table
    % Convert a list of files into a MATLAB table.
    %
    % Example:
    %
    %   db = databricks.DBFS();
    %   fileList = db.listFiles();
    %   t = table(fileList);

    %  (c) 2019-2022 MathWorks, Inc.

    % Preallocate structure
    out = struct('path', '', 'is_dir', false, 'file_size', int64(0), 'modification_time', cell(numel(obj),1));

    % Deal the results into a table
    for oCount = 1:numel(obj)
        out(oCount).path = obj(oCount).path;
        out(oCount).is_dir = obj(oCount).is_dir;
        out(oCount).file_size = obj(oCount).file_size;
        out(oCount).modification_time = obj(oCount).modification_time;
    end

    % Convert into a table
    tableResult = struct2table(out);
    
    % The following makes the table output look better but could break existing code
    % To be considered for a future release
    %
    % Convert cell arrays to strings
    % tableResult.path = string(tableResult.path);

end %function
