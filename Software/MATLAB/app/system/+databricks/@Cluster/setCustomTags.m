function setCustomTags(obj, clusterTags, varargin)
% SETCUSTOMTAGS Method to create and update custom tags for the cluster
% Set custom tags on the Cluster object. This is useful when creating new
% clusters.
% 
% For example:
% 
%     cl = databricks.Cluster;
%     tag = databricks.ClusterTag('owner','myUserName');
%     cl.setCustomTags(tag);

%  (c) 2019-2024 MathWorks, Inc.

% Create the property if it does not exist
% custom_tags is a containers.Map
if ~isprop(obj,'custom_tags')
    addprop(obj,'custom_tags');
end
    
if isa(clusterTags, 'databricks.ClusterTag')
    if isempty(obj.custom_tags)
        % Add the tag
        obj.custom_tags = clusterTags.tags;
    else
        % Append the clusterTags to the existing custom_tags
        newKeys = clusterTags.tags.keys;
        for n = 1:length(newKeys)
            obj.custom_tags(newKeys{n}) = clusterTags.tags(newKeys{n});
        end
    end
else
    error('DATABRICKS:INVALID','Invalid tags specified. Please use a databricks.ClusterTag to specify the tags');
end

end %function
