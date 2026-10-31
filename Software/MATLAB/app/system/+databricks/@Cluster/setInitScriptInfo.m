function setInitScriptInfo(obj, initObjs, varargin)
% SETINITSCRIPTINFO Method to set the location of an init script
% Sets one or more init_script objects to execute on the initialization of
% the cluster.
% 
% For example:
% 
%   cl = databricks.Cluster;
%   is = databricks.InitScriptInfo;
%   is.setDestination("dbfs:/home/init_script");
% 
%   cl.setInitScriptInfo(is);


%   (c) 2019-2020 MathWorks, Inc.

% Check if we have a valid object
if isa(initObjs,'databricks.InitScriptInfo')
    if ~isprop(obj,'init_scripts')
        addprop(obj,'init_scripts');
    end
    
    % set it as a property value, append as there may be more than one
    % script
    if isempty(obj.init_scripts)
        obj.init_scripts = initObjs;
    else
        obj.init_scripts(end+1) = initObjs;
    end
else
    error('DATABRICKS:INVALID','Input needs to be a databricks.InitScriptInfo object');
end

end %function
