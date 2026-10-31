%% usingArtifactArguments
% This is a simple example showing how to use the artifacts feature on a
% function that has additional arguments.

%% Create an example table
A = int64(0:9)';
B = double(A + 10);
C = string(B + 10);
T = table(A,B,C)

% Try calling the tblPlus function with the table and some additional
% arguments.
TO = tblPlus(T, int64(3), double(5), "hello")

% Create a second table more suitable for applyInPandas (grouped data)
T2 = T;
T2.A = rem(T2.A, 3)

%% Create a Spark Session and make Dataframes of the two example tables

spark = getDatabricksSession(forceNewSession=true)

DF = matlab.sparkutils.table2dataset(T, spark)
DF2 = matlab.sparkutils.table2dataset(T2, spark)

%% Build the wheel file
opts = compiler.build.PythonPackageOptions(...
    ["plusPi.m", "doMath.m", "addStringCol.m", "tblPlus.m", "myArr.m"], ...
    "OutputDir", fullfile(tempdir, "Artifacts", "_build"), ...
    "PackageName", "artifacts.example");

PSB = compiler.build.spark.pythonPackage(opts)

%% Add the artifact to the Spark session
% Apart from adding the artifact, this will also import the functions and
% variables from the Wheel files created in the previous step.
PSB.addArtifact(spark)

%% Try to run the function
% In this example, the additional arguments are using automatic conversion
% to Python
OUT = DF.mapInPandas("tblPlus_mapInPandas", schema="tblPlus_output_schema", args={int64(10), pi, 'alice'})
OUT.show

%% Explicit python arguments
% In this example, the additional arguments are explicitly casted to Python
% values
OUT_explicit = DF.mapInPandas("tblPlus_mapInPandas", schema="tblPlus_output_schema", args={py.int(1000), py.float(100), py.str('bob')})
OUT_explicit.show

%% Try applyInPandas
% In this example, the additional arguments are using automatic conversion
% to Python
% Please note how the output is grouped, i.e. the column A elements are all
% grouped together, although the input wasn't.

OUT2 = DF2.groupBy('A').applyInPandas("tblPlus_applyInPandas", schema="tblPlus_output_schema", args={int64(10), pi, 'alice'})
OUT2.show()

%% Try applyInPandas, explicit Python arguments
% In this example, the additional arguments are explicitly casted to Python
% values
% Please note how the output is grouped, i.e. the column A elements are all
% grouped together, although the input wasn't.

OUT2_explicit = DF2.groupBy('A').applyInPandas("tblPlus_applyInPandas", schema="tblPlus_output_schema", args={py.int(1000), py.float(100), py.str('bob')})
OUT2_explicit.show()

