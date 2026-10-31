classdef Library < databricks.Object
    % LIBRARY A databricks library
    % Contains a specification of libraries required for the Spark job to
    % execute.
    %
    % This allows specification of libraries via either DBFS or S3 URIs.
    % If S3 is used, make sure the cluster has read access on the library. You
    % may need to launch the cluster with an IAM role to access the S3 URI.
    %
    %     lib = databricks.Library();
    %     lib.setType('jar');
    %     lib.jar = 'dbfs:/mnt/libraries/library.jar';
    %
    % An array of this object can be used to configure a databricks.Job.
    
    %   (c) 2019-2026 MathWorks, Inc.
    
    properties (Hidden)
        HTTPOptions matlab.net.http.HTTPOptions
    end
    
    methods
        % Constructor
        function obj = Library(varargin)
            obj.HTTPOptions = databricks.internal.getHTTPOptions(convertResponse=false);
            obj.getAuth(varargin{:});
        end
    end
end