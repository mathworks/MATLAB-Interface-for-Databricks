function setAutoterminationMinutes(obj, mins, varargin)
% SETAUTOTERMINATIONMINUTES Method to set the auto-termination for clusters
% Setting the autotermination minutes for the cluster by setting the
% property on the cluster object. This automatically terminates the cluster
% after it is inactive for this time in minutes.
%
% If not set, this cluster will not be automatically terminated.
% If specified, the threshold must be between 10 and 10000 minutes.
% If this value is set to 0, it will explicitly disable automatic termination.
%
%   cl = databricks.internal.Cluster;
%   cl.setAutoterminationMinutes(100);
%

% Copyright 2021-2026 The MathWorks, Inc.

% Create the property if it does not exist
if ~isprop(obj,'autotermination_minutes')
    addprop(obj,'autotermination_minutes');
end

% Set the property as-is
if isnumeric(mins)
    obj.autotermination_minutes = mins;
else
    error('DATABRICKS:INVALID','Invalid termination time specified. Must be 0 or between 10 and 10000 minutes.');
end

end %function
