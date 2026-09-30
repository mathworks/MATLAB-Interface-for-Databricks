classdef ClusterLogConf < dynamicprops
    % CLUSTERLOGINFO Location of cluster logs
    % Use this to specify the location of the init_scripts. This can point to a
    % DBFS (or S3 location when running on AWS).
    %
    % For example:
    %
    %   conf = databricks.ClusterLogConf;
    %   conf.setDestination("dbfs:/home/cluster-logs");

    %   (c) 2020-2024 MathWorks, Inc.

    properties
    end

    methods
    	%% Constructor
        function obj = ClusterLogConf(logDestination)
            arguments
                logDestination (1,1) string = "";
            end
            if strlength(logDestination) > 0
                obj.setDestination(logDestination);
            end

    	end
    end

end %class
