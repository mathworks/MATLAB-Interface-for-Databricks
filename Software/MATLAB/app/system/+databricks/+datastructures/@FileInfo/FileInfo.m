classdef FileInfo < handle
    % FILEINFO Stores the attributes of a file or directory
    %
    % Fields:
    %                path :	The path of the file or directory.
    %                       Type string
    %
    %              is_dir : Whether the path is a directory.
    %                       Type: logical
    %
    %           file_size : The length of the file in bytes or zero if the path
    %                       is a directory.
    %                       Type: int64
    %
    %   modification_time : The last time, in epoch milliseconds, the file or
    %                       directory was modified. Note: If the request is for
    %                       a directory on AWS S3, this value is midnight 01-Jan-1970
    %                       Type: datetime
    %
    % The fromJSON() method can be used to create an array of FileInfo objects
    % base on a JSON string as returned from listFiles.
    %
    % If there are no files listed in the JSON string an empty FileInfo object
    % is returned.

    %  (c) 2019-2022 MathWorks, Inc.
    
    properties
        path = char.empty
        is_dir = logical.empty
        file_size = int64.empty
        modification_time = datetime.empty
    end
    
    methods
        %% Constructor
        function obj = FileInfo(~, varargin)
            
        end
    end %methods
    
    methods(Static)
        function obj = fromJSON(jsonStr)
            % May return empty JSON {} if there are no files
            allowMissing = true;

            % allow for a files array or not
            fileData = jsondecodeTypedValues(jsonStr, allowMissing, {"files", {':'}, 'file_size'}, "int64", {"files", {':'}, 'modification_time'}, "int64", {'file_size'}, "int64", {'modification_time'}, "int64");

            if numel(fieldnames(fileData)) ~= 0 % empty structure
                if isfield(fileData, 'files')
                    % If there is a files array iterate through it
                    for oCount = 1:numel(fileData.files)
                        obj(oCount) = databricks.datastructures.FileInfo(); %#ok<*AGROW>
                        obj(oCount).path = fileData.files(oCount).path;
                        obj(oCount).is_dir = fileData.files(oCount).is_dir;
                        obj(oCount).file_size = fileData.files(oCount).file_size;
                        obj(oCount).modification_time = datetime(fileData.files(oCount).modification_time, 'ConvertFrom','epochtime','Epoch','1970-01-01','TicksPerSecond',1000);
                    end
                else
                    % Expecting values for a single FileInfo object only
                    obj = databricks.datastructures.FileInfo();
                    obj.path = fileData.path;
                    obj.is_dir = fileData.is_dir;
                    obj.file_size = fileData.file_size;
                    obj.modification_time = datetime(fileData.modification_time, 'ConvertFrom','epochtime','Epoch','1970-01-01','TicksPerSecond',1000);
                end
            else
                obj = databricks.datastructures.FileInfo.empty;
            end
            
        end %function
    end %methods
end %class
