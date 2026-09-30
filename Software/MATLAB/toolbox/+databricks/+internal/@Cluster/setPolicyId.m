function setPolicyId(obj, policyId)
% SETPOLICYID Method to set a policy_id to a cluster handle
% Set the policy id for a cluster handle.
%
%   cl = databricks.internal.Cluster()
%   cl.setPolicyId('MY-POLICY-VALUE');
%
% The policy_id can be specified as a string or character vector and is stored
% as a character vector.
%
% A default policy_id can be defined in the databricks-settings.json file.
% This will then be applied to all created clusters unless overwritten.

% Copyright 2022-2026 The MathWorks, Inc.

% Check input argument
if ~(ischar(policyId) || isStringScalar(policyId))
    error('DATABRICKS:ERROR', 'Expected policyId to be of type character vector or string scalar');
end

% set the property if one does not exist
if ~isprop(obj,'policy_id')
    addprop(obj,'policy_id');
end
obj.policy_id = char(policyId);

end %function
