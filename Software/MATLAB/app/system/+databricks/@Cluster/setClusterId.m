function setClusterId(obj, clusterId)
% SETCLUSTERID Method to set a cluster_id to a cluster handle
% Set the cluster id for a cluster handle.
%
%   cl = databricks.Cluster()
%   cl.setClusterId('0531-031912-trill440');
%
% The cluster_id uniquely identifies a Databricks cluster and allows future
% operations such as refresh(), start(), terminate() and permanentDelete();
%
% The cluster_id can be specified as a string or character vector and is stored
% as a character vector.

% (c) 2019-2020 MathWorks, Inc.

% Check input argument
if ~(ischar(clusterId) || isStringScalar(clusterId))
    error('DATABRICKS:ERROR', 'Expected clusterId to be of type character vector or string scalar');
end

% set the property if one does not exist
if ~isprop(obj,'cluster_id')
    addprop(obj,'cluster_id');
end
obj.cluster_id = char(clusterId);

end %function
