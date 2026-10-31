% Copyright 2020 The MathWorks, Inc.

%% Create a timetable for testing
fs = 1/100; 
t = (0:fs:100)';
ts = seconds(t);
x = 5*sin(t) + randn(size(t));
y = 3*cos(t) + randn(size(t));
% figure(1); plot(t,x, t,y);
t2 = datetime(t+now, 'ConvertFrom', 'posixtime');

% This will work with Spark/Scala
% Here, the time datatype is "datetime"
% TT = timetable(t2,x,y); 

% This will break in Spark/Scala
% Here, the time datatype is "duration"
TT = timetable(ts,x,y); 

%% Save as parquet file
parquetwrite('tt1.parquet', TT);

%% Connect to databricks and save this file in DBFS
db = databricks.DBFS;
db.mkdir('/test-parquet');
db.upload('tt1.parquet', '/test-parquet');