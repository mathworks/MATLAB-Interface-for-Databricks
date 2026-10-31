% plotResult.m
% This file plots the results from the simulation by downloading the
% results from Databricks.
% Please note that the path (in the load command) will differ for any
% simulation. This uses Databricks Connect, and therefore requires that a
% cluster_id must be configured in the databricks-settings.json, and this
% cluster must be running.

% Copyright 2022 The MathWorks, Inc.

spark = getDatabricksSession();

R = spark.read.format("delta").load("/example/3dof_out/profiles_20220707_074901");

R7 = R.filter("ID LIKE 'Road7'");
T7 = R7.table %#ok<NOPTS> 
plot(T7.Time, T7.VerticalDisplacement),shg