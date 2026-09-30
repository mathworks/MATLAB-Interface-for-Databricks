function events = getEvents(obj, varargin)
% GETEVENTS Method to list the cluster events
% Retrieve a list of events about the activity of a cluster.
% 
% For example:
%   
%   db = databricks.Cluster;
%   db.setClusterId('0712-182938-knows476');
%   ev = db.getEvents();
% 
%   ev =
% 
%   13x4 table
% 
%           cluster_id          timestamp              type                details   
%     ______________________    __________    _______________________    ____________
% 
%     '0712-182938-knows476'    1.5632e+12    'DRIVER_HEALTHY'           [1x1 struct]
%     '0712-182938-knows476'    1.5632e+12    'RUNNING'                  [1x1 struct]
%     '0712-182938-knows476'    1.5632e+12    'INIT_SCRIPTS_FINISHED'    [1x1 struct]
%     '0712-182938-knows476'    1.5632e+12    'INIT_SCRIPTS_STARTED'     [1x1 struct]
%     '0712-182938-knows476'    1.5632e+12    'STARTING'                 [1x1 struct]
%     '0712-182938-knows476'     1.563e+12    'TERMINATING'              [1x1 struct]
%     '0712-182938-knows476'     1.563e+12    'DRIVER_UNAVAILABLE'       [1x1 struct]
%     '0712-182938-knows476'     1.563e+12    'DRIVER_HEALTHY'           [1x1 struct]
%     '0712-182938-knows476'     1.563e+12    'DRIVER_HEALTHY'           [1x1 struct]
%     '0712-182938-knows476'     1.563e+12    'RUNNING'                  [1x1 struct]
%     '0712-182938-knows476'     1.563e+12    'INIT_SCRIPTS_FINISHED'    [1x1 struct]
%     '0712-182938-knows476'     1.563e+12    'INIT_SCRIPTS_STARTED'     [1x1 struct]
%     '0712-182938-knows476'     1.563e+12    'CREATING'                 [1x1 struct]
%     

%  (c) 2019-2026 MathWorks, Inc.

%% Fetch the events for a cluster 
clusterURI = obj.getURI('clusters', 'events');
request = obj.getRequestMessage('POST');

% Send the cluster_id as payload
request.Body = matlab.net.http.MessageBody;
if ~isprop(obj,'cluster_id')
    error('DATABRICKS:MISSING', 'Cluster ID is not specified. Please check if cluster exists.');
end

payload.cluster_id = obj.cluster_id;
request.Body.Payload = jsonencode(payload);

% Call databricks
resp = request.send(clusterURI, databricks.internal.getHTTPOptions(convertResponse=true));

%% Process the results
if resp.StatusCode == matlab.net.http.StatusCode.OK
    % Valid response so package and send back to user
    events = resp.Body.Data.events;
    
    % Return values are always "cluster_id" "timestamp" "type" "details"
    fn = fieldnames(events);
    tsIdx = find(strcmp('timestamp', fn));
    idx = 1:length(fn);
    idx(tsIdx)=[];
    fn = fn([tsIdx, idx]);
    
    events = orderfields(events, fn);
    
    events = struct2table(events);
    
    % Convert to real timestamp objects
    events.timestamp = datetime(events.timestamp, ...
        'ConvertFrom','epochtime','Epoch','1970-01-01','TicksPerSecond',1000);
    
    events = table2timetable(events);
    
    
    % TODO: Pagination
    
else 
    error('DATABRICKS:ERROR','Failed to get the list of events from cluster_id: %s\n%s', obj.cluster_name, char(resp.Body.Data));
end

end %function
