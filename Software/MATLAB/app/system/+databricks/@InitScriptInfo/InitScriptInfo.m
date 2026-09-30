classdef InitScriptInfo < databricks.Object
    % INITSCRIPTINFO Location of init script
    % Use this to specify the location of the init_scripts.
    % The location can be specified as in the forms:
    %   dbfs:/<SCRIPTPATH>
    %   file:/<SCRIPTPATH>
    %   s3://<SCRIPTPATH>
    %   abfss://<SCRIPTPATH>
    %
    % For example:
    %
    %   is = databricks.InitScriptInfo;
    %   is.setDestination("dbfs:/mydirectory/init_script.sh");

    %  (c) 2019-2022 MathWorks, Inc.

    properties
    end

    methods
    	%% Constructor
    	function obj = InitScriptInfo(~, varargin)

    	end
    end

end %class