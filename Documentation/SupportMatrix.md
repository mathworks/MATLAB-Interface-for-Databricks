# Supported Workflows & Releases

The following tables summarizes the feature support across MATLAB releases and
underlying platform versions. If exceptions to the following constraints are
encountered, please contact MathWorks <databricks@mathworks.com>.

| Workflows              | R2026b | R2026a | R2025b | R2025a | R2024b | R2024a  | R2023b   | R2023a      | R2022b      | Toolbox Requirements    |
| ---------------------- | ------ | ------ | ------ | ------ | ------ | ------- | -------- | ----------- | ----------- | ----------------------- |
| REST APIs              | Yes    | Yes    | Yes    | Yes    | Yes    | Yes     | Yes      | Yes         | Yes         |                         |
| JDBC                   | Yes    | Yes    | Yes    | Yes    | Yes    | Yes     | Yes      | Yes         | Yes         | Database Toolbox        |
| ODBC                   | Yes    | Yes    | Yes    | Yes    | Yes    | Yes     | Yes      | Yes [N6]    | Yes [N6]    | Database Toolbox        |
| Databricks Connect (v2)| Yes    | Yes    | Yes    | Yes    | Yes    | Yes     | Yes [N3] | Yes [N2,N3] | Yes [N2,N3] |                   |
| Libraries              | Yes    | Yes    | Yes    | Yes    | Yes    | Yes     | Yes      | Yes         | Yes         | Compiler & Compiler SDK |
| UDFs                   | Yes    | Yes    | Yes    | Yes    | Yes    | Yes     | Yes      | Yes         | Yes         | Compiler & Compiler SDK |
| Unity Catalog          | Yes    | Yes    | Yes    | Yes    | Yes    | Yes     | Yes      | Yes         | Yes         |                         |
| Notebook Tasks         | Yes    | Yes    | Yes    | Yes    | Yes    | Yes     | Yes      | Yes         | Yes         |                         |
| MATLAB Tasks           | Yes    | Yes    | Yes    | Yes    | Yes    | Yes     | Yes      | Yes         | Yes         |                         |
| Compiled Simulink [N1] | Yes    | Yes    | Yes    | Yes    | Yes    | Yes     | Yes      | Yes         | Yes         | Simulink, Compiler, Compiler SDK & Simulink Compiler |
| Spark Jar Tasks        | Yes    | Yes    | Yes    | Yes    | Yes    | Yes     | Yes      | Yes         | Yes         | Compiler & Compiler SDK |
| *Spark Support*        |        |        |        |        |        |         |          |             |             |                         |
| Spark 3 - Compiled     | Yes    | Yes    | Yes    | Yes    | Yes    | Yes     | Yes      | Yes         | Yes         | Compiler & Compiler SDK |
| Spark 3 - DB Connect   | Yes    | Yes    | Yes    | Yes    | Yes    | Yes     | Yes      | Yes         | Yes         |                         |
| *Databricks Runtimes*  | Yes    | Yes    | Yes    | Yes    |        |         |          |             |             |                         |
| 18.x LTS               | Yes    | Yes    | Yes    | Yes    | Yes    | No [N5] | No [N5]  | No [N5]     | No [N5]     |                         |
| 17.3.x LTS             | Yes    | Yes    | Yes    | Yes    | Yes    | No [N5] | No [N5]  | No [N5]     | No [N5]     |                         |
| 16.4.x LTS             | Yes    | Yes    | Yes    | Yes    | Yes    | No [N5] | No [N5]  | No [N5]     | No [N5]     |                         |
| 15.4.x LTS             | Yes    | Yes    | Yes    | Yes    | Yes    | Yes     | Yes      | No [N4]     | No [N4]     |                         |
| 14.3.x LTS             | Yes    | Yes    | Yes    | Yes    | Yes    | Yes     | Yes      | Yes         | Yes         |                         |
| 13.3.x LTS             | Yes    | Yes    | Yes    | Yes    | Yes    | Yes     | Yes      | Yes         | Yes         |                         |

| Notes |                                                       |
| ----- | ----------------------------------------------------- |
| [N1]  | Requires a Linux&reg; based development system, see below. |
| [N2]  | On macOS&reg; Databricks Connect is supported on Apple&reg; silicon systems using the native Apple silicon releases of MATLAB only, this precludes R2022b and R2023b which do not support Apple silicon natively. |
| [N3]  | Basic support for converting a Spark Dataframe into a MATLAB table. |
| [N4]  | R2022b and R2023a do not support Python&reg; 3.11, as used by Databricks runtime 15 |
| [N5]  | R2022b to R2024a do not support Python 3.12, as used by Databricks runtime 16, 17 & 18 |
| [N6]  | ODBC Connections on macOS require MATLAB R2023b or later |

For a given supported version of desktop MATLAB the same release of the MATLAB
runtime must be used to run deployed code that has been compiled as a `.whl` file.
Runtimes are typically configured at setup time and can be freely downloaded
from: [https://www.mathworks.com/products/compiler/matlab-runtime.html](https://www.mathworks.com/products/compiler/matlab-runtime.html).

## Python version support requirements

With MATLAB&reg; Compiler SDK&trade; workflows where a Python `.whl` file is produced,
the Python version used by the Databricks runtime must be a version that is supported
by the release of MATLAB used to compile the `.whl` file to be deployed to Databricks.

Versions of Python compatible with MATLAB releases: [https://www.mathworks.com/support/requirements/python-compatibility.html](https://www.mathworks.com/support/requirements/python-compatibility.html)

| MATLAB Release | Supported Python versions (Compiler SDK) |
| -------------- | ---------------------------------------- |
| R2026b         | 3.9, 3.10, 3.11, 3.12, 3.13              |
| R2026a         | 3.9, 3.10, 3.11, 3.12, 3.13              |
| R2025b         | 3.9, 3.10, 3.11, 3.12                    |
| R2025a         | 3.9, 3.10, 3.11, 3.12                    |
| R2024b         | 3.9, 3.10, 3.11, 3.12                    |
| R2024a         | 3.9, 3.10, 3.11                          |
| R2023b         | 3.9, 3.10, 3.11                          |
| R2023a         | 3.8, 3.9, 3.10                           |
| R2022b         | 2.7, 3.8, 3.9, 3.10                      |

Python versions used by supported Databricks runtimes are as follows, note patch
version changes are to be expected:

| Databricks runtime | Python version | Comments                 | Cluster OS         |
| ------------------ | -------------- | ------------------------ | ------------------ |
| 18.x LTS           | 3.12           | Requires R2024b or later | Ubuntu&reg; 24.04.2 LTS |
| 17.3.x LTS         | 3.12           | Requires R2024b or later | Ubuntu 24.04.2 LTS |
| 16.4.x LTS         | 3.12           | Requires R2024b or later | Ubuntu 24.04.2 LTS |
| 15.4.x LTS         | 3.11.0rc1      | Requires R2023b or later | Ubuntu 22.04.4 LTS |
| 14.3.x LTS         | 3.10.12        |                          | Ubuntu 22.04.4 LTS |
| 13.3.x LTS         | 3.10.12        |                          | Ubuntu 22.04.4 LTS |

The implication of this is that if using Databricks 15.4, for example, this uses Python 3.11.
Based on MATLAB's Python version compatibility, this means R2023b or later must be used.

See also: [https://docs.databricks.com/en/dev-tools/sdk-python.html](https://docs.databricks.com/en/dev-tools/sdk-python.html).

## LTS Support

In general this package aims to support Databricks LTS releases and is developed
and tested with those in mind. Non LTS releases can normally be used too, however
this may require some customization, e.g. building a custom Databricks Connect
library or in the cluster creation process.

Setup support will be added for Databricks runtime 16 when an LTS version is
released.

## Docker / Databricks Container Services

A container registry hosted in the same data center as the Databricks instance
is required for:

* The MATLAB Desktop environment on Databricks.
* MATLAB runtimes on Databricks clusters using Databricks runtimes 17.x and later.
* MATLAB R2025a and later runtimes using Databricks runtime 16.x without internet access.

The required Docker&reg; files are provided.
See also: [Container Services](ContainerServices.md).

## Additional 3rd party software

Python 3.10, 3.11 or 3.12 are required to build the Databricks Connect libraries.
The Python environments must have `pip` and `venv` or `virtualenv` installed.

## Operating System support

* Databricks cluster nodes always use Linux. The workflows above are cross
platform on supported MATLAB platforms (Windows&reg;, Linux & macOS), where not
otherwise noted.

* Simulink Compiler usage involves native code generation and thus the OS of the
development platform must match that of the deployment platform i.e. Linux, see
[N1]. Typically the best option is to use the exact same OS distribution and
version as used by the Databricks runtime which is used. This should avoid
`glibc` and any other library version conflicts. At the very least make sure the
development system is *not* using a *newer* `glibc` version than the runtime
image. Check the [Databricks runtime
releases](https://docs.databricks.com/release-notes/runtime/releases.html)
documentation to see which exact base OS is used by the different Databricks
runtime versions.

* Use on macOS will require additional tools e.g. Bash.

[//]: #  (Copyright 2021-2026 The MathWorks, Inc.)
