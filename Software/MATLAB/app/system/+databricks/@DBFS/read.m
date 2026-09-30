function rawBytes = read(obj, pathStr, varargin)
    % READ Method to read a file from DBFS
    % Reading a file from DBFS is performed in 1MB chunks. The byte array
    % returned by this method can be saved to disk for persistence.
    %
    % For example:
    %
    %   db = databricks.DBFS;
    %   data = db.read('/example/sample.mat');
    %
    %   % Create a file and save it.
    %   fid = fopen('sample.mat');
    %   fwrite(fid, data);
    %   fclose(fid);
    %
    
    
    %   (c) 2019 MathWorks, Inc.
        
    % Validate the inputs
    validString = @(x) ischar(x) || isstring(x);
    validNumber = @(x) isnumeric(x);
    
    % Created an input parser
    p = inputParser;
    p.addRequired('path',validString);
    p.addOptional('offset',0,validNumber);       %Start at the beginning
    p.addOptional('length',1000000,validNumber); %1MB default
    
    % Parse and setup the parameters
    p.parse(pathStr,varargin{:});
    pathStr = p.Results.path;
    offset = p.Results.offset;
    length = p.Results.length;
    
    [rawBytes, numBytes] = readFileSection(obj, pathStr, offset, length);
    
    while numBytes~=0
        % Continue to read
        offset = offset+numBytes;
        
        %% Create the request to read the file
        [newRawBytes, numBytes] = readFileSection(obj, pathStr, offset, length);
        
        % Call databricks
        rawBytes = [rawBytes, newRawBytes]; %#ok<AGROW> %TODO:Flush instead of grow
        fprintf(1,'.');
    end
    fprintf(1,'\n');
        
    
end %function
