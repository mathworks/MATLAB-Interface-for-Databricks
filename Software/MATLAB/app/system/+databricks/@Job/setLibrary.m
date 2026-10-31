function setLibrary(obj, lib, varargin)
% SETLIBRARY Method to set a library for the current job
% Set the location of the library. The library is specified as a
% databricks.Library object and will allow users to specify the location of
% the library on DBFS or S3.
%
% Use the databricks.DBFS object to upload the output of the MATLAB
% compiler to the storage service. This can then be configured as:
%
%   % Create a library definition
%   lib = databricks.Library;
%   lib.setType('jar');
%   lib.jar = 'dbfs:/example/meanArrivalDemoApp.jar'
%
%   % Attach the library to the current job

%                 (c) 2019 MathWorks, Inc.

if isa(lib,'databricks.Library')
    
    if ~isprop(obj,'libraries')
        obj.addprop('libraries');
    end
    
    obj.libraries = lib;
    
else
    error('DATABRICKS:INVALID','Invalid input library. Please use a databricks.Library object to configure the object');
end

end %function
