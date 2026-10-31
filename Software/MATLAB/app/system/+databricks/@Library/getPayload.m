function jsonStr = getPayload(obj, clusterId, varargin)
% GETPAYLOAD Method to create a payload for the request
% Internal use only

%  (c) 2020 MathWorks, Inc.

req.cluster_id = clusterId;
req.libraries = obj;

jsonStr = jsonencode(req);

end %function
