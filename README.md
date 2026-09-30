# MATLAB Interface for Databricks

[![View MATLAB Interface for Databricks on File Exchange](https://www.mathworks.com/matlabcentral/images/matlab-file-exchange.svg)](https://www.mathworks.com/matlabcentral/fileexchange/####-matlab-interface-for-databricks)

MATLAB&reg; Interface for Databricks&reg; enables engineers and data scientists to develop, scale, and deploy MATLAB and Simulink&reg; workflows directly on Databricks, operationalizing algorithms and simulations in production pipelines and digital twins.

## What You Can Do

| Workflow | What it solves | Learn more |
| -------- | -------------- | ---------- |
| **Query Databricks data** | Read Delta tables from MATLAB using SQL via JDBC or ODBC — no Spark&trade; knowledge needed. | [JDBC](Documentation/JDBCWorkflow.md) · [ODBC](Documentation/ODBCWorkflow.md) |
| **Develop with Databricks Connect** | Run Spark operations interactively from MATLAB, filter and sort large datasets on the cluster, then pull results locally for analysis. | [Databricks Connect](Documentation/DBConnectWorkflow.md) |
| **Deploy MATLAB to Spark** | Compile MATLAB functions to Python&reg; wheel files with MATLAB Compiler SDK&trade; and run them as jobs on a Databricks cluster — no desktop in the loop for production. | [Job Workflow](Documentation/JobWorkflow.md) |
| **Manage Databricks resources** | Create and control clusters, upload files to Unity Catalog volumes, manage secrets, execute SQL, and run jobs — all from MATLAB scripts. | [REST APIs](Documentation/DatabricksAPI.md) |
| **Run MATLAB on Databricks** | Run MATLAB Desktop or Runtime directly on a Databricks cluster in Docker&reg; containers, accessed via a browser. | [Reference Architecture](https://github.com/mathworks-ref-arch/matlab-on-databricks) |

## MathWorks Products ([mathworks.com](https://www.mathworks.com))

Requires MATLAB release R2024b or newer
- [MATLAB Compiler SDK](https://www.mathworks.com/products/matlab-compiler-sdk.html) (optional, required when deploying MATLAB to Spark)
- [Database Toolbox&trade;](https://www.mathworks.com/products/database.html) (optional, required for JDBC/ODBC connections)

### 3rd Party Products:
- [Databricks](https://www.databricks.com) account using runtimes >= 13.3
- [Python](https://www.python.org/) 3.10, 3.11, or 3.12 (required by Databricks Connect)
- [Docker](https://www.docker.com/) (required for MATLAB on Databricks and runtimes >= 17)
- Databricks [JDBC](https://www.databricks.com/spark/jdbc-drivers-archive) or [ODBC](https://www.databricks.com/spark/odbc-drivers-download) drivers (required by MATLAB [Database Toolbox](https://www.mathworks.com/products/database.html))

## Installation
Installation instructions

### MATLAB Desktop

#### Installing With Toolbox Package

1. Under "Assets" of a [release](https://github.com/mathworks/MATLAB-Interface-for-Databricks/releases), download the toolbox package `.mltbx` file.
2. Start MATLAB.
3. In the Current Folder browser, navigate to the `.mltbx` file.
4. Right click on the `.mltbx` file and select "Install".

#### Installing With MATLAB Command Window

Paste this into the MATLAB Command window:

```matlab
websave(fullfile(tempdir,"databricks.mltbx"),"https://github.com/mathworks/MATLAB-Interface-for-Databricks/releases/latest/download/matlab-databricks.mltbx");
matlab.addons.install(fullfile(tempdir,"databricks.mltbx"));
```

### MATLAB on Databricks

For full cluster setup instructions, see the [MATLAB on Databricks Reference Architecture](https://github.com/mathworks-ref-arch/matlab-on-databricks).
Follow the instructions in the [Connect to MATLAB](https://github.com/mathworks-ref-arch/matlab-on-databricks/blob/main/resources/notebooks/Connect_to_MATLAB.ipynb) notebook to install the package.

## Getting Started

1. In MATLAB, run `setup`. This will guide you through configuring your Databricks workspace URL, authentication, and connection settings.
2. Configure authentication — see [Authentication](Documentation/Authentication.md) for supported methods (PAT, OAuth, etc.).
3. Try an example: [Databricks Connect NYC taxi](Software/MATLAB/examples/DatabricksConnect/NYC/README.md) or [JDBC workflow](Documentation/JDBCWorkflow.md).

For detailed setup instructions, see [Setup](Documentation/Setup.md).

## Examples

| Example | Description |
| ------- | ----------- |
| [Databricks Connect — NYC Taxi](Software/MATLAB/examples/DatabricksConnect/NYC/README.md) | Query and analyze NYC taxi data using Spark from MATLAB |
| [Databricks Connect — Artifacts](Software/MATLAB/examples/DatabricksConnect/Artifacts/README.md) | Work with Databricks artifacts |
| [Machine Learning](Software/MATLAB/examples/MachineLearning/README.md) | Train and deploy ML models on Databricks |
| [Simscape&trade; Simulation](Software/MATLAB/examples/Simscape/README.md) | Deploy Simscape models to run at Spark scale |
| [Simulink 3DoF](Software/MATLAB/examples/SimulinkSuspension3DoF/README.md) | Deploy a Simulink suspension model to Databricks |
| [App Designer](Software/MATLAB/examples/AppDesigner/ClusterTable/README.md) | Build a MATLAB App to browse Databricks clusters |
| [Tasks](Software/MATLAB/examples/Tasks/README.md) | Run MATLAB batch tasks on Databricks |

See all examples in [`Software/MATLAB/examples/`](Software/MATLAB/examples/).
To learn how to use this in testing workflows, see [Examples](Software/MATLAB/examples/).

## License

The license is available in the [LICENSE.md](LICENSE.md) file in this repository.

## Community Support

[MATLAB Central](https://www.mathworks.com/matlabcentral)

[//]: #  (Copyright 2020-2026 The MathWorks, Inc.)
