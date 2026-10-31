% Simple example of the use of Zerobus

% First import CreateAndMonitor.py into a workspace as a means of creating the
% the required table and monitoring the data insertion outside of MATLAB.

catalog = "main";
schema = "default";
table = "air_quality";

% It is bad practice to include credentials in code and MATLAB loadenv and secret store
% are strongly recommended, see:
%  https://www.mathworks.com/help/matlab/ref/loadenv.html
%  https://www.mathworks.com/help/matlab/ref/setsecret.html

sp_secret = "do<REDACTED>5";
sp_client_id = "a<REDACTED>1";

% Create the Zerobus client
z = databricks.Zerobus(catalog=catalog, schema=schema, table=table, clientId=spClientId, clientSecret=spSecret);

% Number of rows to ingest, 2 at a time
numRows = 100;

% Iterate 2 steps at a time as adding 2 rows per iteration
for n = 1:2:numRows
    % Create some synthetic data
    t1 = randi([-10, 50]);
    t2 = randi([-10, 50]);
    h1 = randi([30, 100]);
    h2 = randi([30, 100]);
    id1 = "device_num_" + string(num2str(n));
    id2 = "device_num_" + string(num2str(n+1));
    
    % Format the data into JSON
    payload = char(sprintf('[{"device_name": "%s", "temp": %d, "humidity": %d }, \n { "device_name": "%s", "temp": %d, "humidity": %d }]',...
        id1, t1, h1, id2, t2, h2));

    % Provide some feedback
    if mod(n,5) == 0
        fprintf("Insert call #%d\n", n);
    end

    % Call the insert method on the Zerobus client
    [result, errorResponse] = z.insert(payload);
    if ~result
        disp(errorResponse);
        error("Iteration % failed.");
    end
end
