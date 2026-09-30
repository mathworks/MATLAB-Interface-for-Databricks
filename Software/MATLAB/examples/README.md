# Examples Overview

This directory contains the following examples:

* [AppDesigner/ClusterTable](#appdesignerclustertable)
* [DatabricksConnect/Artifacts](#databricksconnectartifacts)
* [DatabricksConnect/NYC](#databricksconnectnyc)
* [DatabricksConnect/Portfolio](#databricksconnectportfolio)
* [NestedTypes](#nestedtypes)
* [MachineLearning](#machinelearning)
* [Preview/CodeGeneration](#previewcodegeneration)
* [Simscape&trade;](#simscape)
* [SimulationSuspension3Dof](#simulationsuspension3dof)
* [Tasks/MATLABBatchTask](#tasksmatlabbatchtask)
* [Tasks/MATLABRuntimeTask](#tasksmatlabruntimetask)
* [Tasks/NotebookTask](#tasksnotebooktask)
* [Tasks/SparkPythonTask](#taskssparkpythontask)
* [Tasks/Tasks](#taskstasks)
* [WorkspaceAPI](#workspaceapi)

Toolbox, operating system and Python&reg; environments vary by example.

*WIP* Work in Progress indicates that the example if in the process of being updated
and may not be fully functional, for example it may work on local MATLAB but perhaps
not yet in MATLAB on Databricks&reg;. MathWorks invites feedback and requests for examples
in specific areas of interest to <databricks@mathworks.com>.

## AppDesigner/ClusterTable

Demonstrates how to use App Designer to create a table UI component that displays
Databricks cluster details and describes to how package the app as a toolbox that
can be invoked from MATLAB on Databricks.

## DatabricksConnect/Artifacts

Shows how a MATLAB code can be compiled to a so-called artifact and invoked by
Databricks Connect Spark&trade; API calls such that it runs on a Databricks cluster
at a scale determined by Spark. This is a more advanced Databricks Connect Topic.
Requires MATLAB&reg; Compiler&trade; and MATLAB&reg; Compiler SDK&trade;.

## DatabricksConnect/NYC

Demonstrates basic usage of Databricks Connect to access and manipulate data from
the Databricks sample New York Taxi dataset. Also shows how an algorithm once tested
with Databricks Connect interactively can be compiled to a .whl library and deployed
to a Databricks cluster for batch processing at scale.
Requires MATLAB Compiler and MATLAB Compiler SDK.

## DatabricksConnect/Portfolio

This example requires the Mathworks Financial Toolbox&trade; [https://www.mathworks.com/products/finance.html](https://www.mathworks.com/products/finance.html).
It demonstrates how data can be moved to and fro to Databricks using the REST API
and Databricks Connect to develop and test a portfolio optimization algorithm locally.
After validation, the algorithm is compiled into a deployable *artifact* and executed
remotely on a Databricks cluster again using Databricks Connect.
Requires MATLAB Compiler and MATLAB Compiler SDK.

## NestedTypes

Shows the usage of more complex MATLAB data structures and how to work with them
in the context of compiled `.whl` libraries. Requires MATLAB Compiler and MATLAB
Compiler SDK.

## MachineLearning

This example demonstrates the main steps to consider when developing a machine
learning model in MATLAB and shows how to use this model for inference work with
data on Databricks. The [Statistics and Machine Learning Toolbox&trade;](https://www.mathworks.com/products/statistics.html)
is required to run this example along with MATLAB Compiler and MATLAB Compiler SDK.

## Preview/CodeGeneration

### Under Development

Shows the use of C/C++code generation to produce binary artifacts that can execute
on Databricks without the requirement for a MATLAB runtime. This workflow is under
development and not considered production ready. Contact <databricks@mathworks.com>
with any questions. Requires MATLAB&reg; Coder&trade;.

## Simscape

Virtual vehicle example Requires compilation on Linux&reg; along with Simulink,
MATLAB Compiler, MATLAB Compiler SDK, Simulink&reg; Compiler&trade;, Simscape, Powertrain Blockset&trade;,
Vehicle Dynamics Blockset&trade; & Vehicle Network Blockset.

## SimulationSuspension3Dof

Demonstrates how a Simulink model can be compiled and executed on Databricks.
Requires compilation on Linux. Requires MATLAB Compiler, Simulink Compiler and MATLAB
Compiler SDK.

## Tasks/MATLABBatchTask

Demonstrates the use a MATLAB desktop Docker&reg; image based cluster to run uncompiled
MATLAB code in batch mode as a task. Use an existing running cluster for faster
responses when testing. The cluster will require access to a MATLAB license manager.

## Tasks/MATLABRuntimeTask

Shows the use of a task designed to run standalone binary requiring the MATLAB runtime.
For details of passing arguments and parameters to the task see: `databricks.MATLABRuntimeTask`.
Requires compilation on Linux, MATLAB Compiler and MATLAB Compiler SDK.

## Tasks/NotebookTask

Shows the execution of a Databricks Python notebook task within a job.
Requires Statistics and Machine Learning Toolbox.

## Tasks/SparkPythonTask

Imports and executes a Python script from a workspace as a script rather than a
notebook.

## Tasks/Tasks

Task creates a number of dependent tasks that form a task graph.

## WorkspaceAPI

Examples of the use of the `databricks.Workspace` REST API to work with notebooks
from within MATLAB.
