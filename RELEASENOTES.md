# MATLAB Interface for *Databricks* - Release Notes

## Version 8.0.0 (September 30th 2026)

* First public GitHub release: https://github.com/mathworks/MATLAB-Interface-for-Databricks
* License updated to BSD
* Added CONTRIBUTING.md (issues only, no pull requests)
* Removed Simba JDBC driver from shipping

## Version 7.0.7 (September 18th 2026)


* Added R2026b prerelease support (experimental)
* Added Databricks Apps thumbnail support
* Significant updates and improved error handling in `databricks.internal.io.IO.upload`
* Minor bug fix to `databricks.datastructures.currentuser.UserInfo`
* Minor bug fix to `databricks.datastructures.unitycatalog.MetastoreInfo`
* Minor bug fix to `databricks.internal.io.IO.stripTrailingSlashes`
* Renamed LICENSE.txt to LICENSE.md
* Minor documentation updates 
* Removed `diabetes_data.csv` from repo, dataset can be downloaded directly:
  https://www.kaggle.com/andrewmvd/early-diabetes-classification
* matlab-mlflow v1.0.1:
  * Minor README updates
  * Minor fix in internal unit tests
* matlab-spark-api v3.6.4:
  * Minor documentation updates
* The following classes/functions delegates to internal implementations
  * `databricksRoot`
  * `matlab.databricks.databricksPackageVersion`
  * `databricks.JDBCConnection`
  * `matlab.databricks.setup.configureJDBC`
  * `matlab.utils.Maven`

## Version 7.0.6 (August 14th 2026) (Internal Release)

* Added initial Zerobus support (preview)
* Added `databricks.UnityCatalog.metastoreSummary()`
* Refactored internal utility functions to improve maintainability:
* Removed `Software/Python` desktop provisioning support now handled by the Reference
  Architecture https://github.com/mathworks-ref-arch/matlab-on-databricks
* Added support for Databricks runtime 18 LTS
* Made Databricks runtime 17.3 LTS the default for new installations
* Updated Databricks JDBC driver (Simba) to version 2.8.3
* Updated Databricks JDBC driver pom file (OSS) to version 3.4.2
* Following classes/functions delegates to internal implementations
  * `databricks.Object`
  * `matlab.databricks.detectProxy`
  * `databricks.internal.unifiedauthentication/Oauth`
  * `databricks.internal.unifiedauthentication/Provider`
  * `databricks.internal.utils/getHTTPOptions`
  * `databricks.internal.utils/isOnDatabricks`
  * `databricks.internal.utils/Object` and methods `getAuthorizationField` and `getRequestMessage`
  * `matlab.databricks.detectProxy`
* Add support for scopes in `databricks.Token` class
* Add support for generating temporary volume credentials
* Add support for big files upload (preview)
* matlab-spark-api v3.6.3:
  * Fixed bug for converting columns with empty arrays
* matlab-spark-api v3.6.2:
  * Fix issue with code generation of pandas Simulation for serverless.
  * Enable forceNewSession for codegen example files

## Version 7.0.5 (July 23rd 2026)

> **Important:** See deprecation notice in matlab-spark-api release notes about
> `PythonSparkBuilder` signature format.

* Improved support for batch license tokens in `databricks.MATLABBatchTask`
* *Potentially breaking fix* - Improved statement escaping in `databricks.MATLABBatchTask` and `databricks.MATLABRuntimeTask`
* Bug fix`databricks.MATLABBatchTask` for Interface installation
* Stopped spurious missing Documents/matlab directory warning in `databricks.MATLABBatchTask` with R2026a
* Improved task documentation in `Documentation/JobWorkflow.md`
* Added support in `databricks.MATLABBatchTask` and `databricks.MATLABRuntimeTask` for increased Notebook exit value size, now 5MB
* Improved parsing and cluster handling in `databricks.internal.runMATLABTask`
* Refactored internal utility functions to improve maintainability:
  * `matlab.databricks.vendor.Vendor` enumeration now composes `matlab.internal.databricks.vendor.Vendor`
  * `matlab.utils.getHomeDirectory` now delegates to `matlab.internal.utils.getHomeDirectory`
  * Removed PSP copies of `databricks.internal.configurationprofile.ConfigFile`, `Profile`, and `databricks.internal.settings.Settings` in favor of toolbox versions
  * Removed `databricks-settings.json.template` from `config/`; now sourced from toolbox/config
  * Updated settings template call sites to use `matlab.internal.databricksRoot`
  * Updated release packaging (`Mltbx`) to bundle the toolbox directory and source the settings template from it
  * `matlab.databricks.vendor.Vendor` enumeration now composes `matlab.internal.databricks.vendor.Vendor`
  * `matlab.utils.getHomeDirectory` now delegates to `matlab.internal.utils.getHomeDirectory`
  * `matlab.utils.SemVer` now wraps `matlab.internal.utils.SemVer` with dependent properties and added set methods
  * `matlab.databricks.AuthMethod` enumeration now composes `matlab.internal.databricks.AuthMethod`
  * `matlab.databricks.OauthService` enumeration now composes `matlab.internal.databricks.OauthService`
  * `matlab.utils.URL2Link` now delegates to `matlab.internal.utils.URL2Link`
  * `matlab.utils.addArgs` now delegates to `matlab.internal.utils.addArgs`
  * `matlab.utils.isPythonVersionSupported` now delegates to `matlab.internal.utils.isPythonVersionSupported`
  * `matlab.databricks.connect.getDatabricksRuntimePythonVersion` now delegates to `matlab.internal.databricks.connect.getDatabricksRuntimePythonVersion`
  
Many of the non internally namespaced function will be removed in a future major number release.

* Non `.internal` namespaced functions listed will be removed in a future release.
* matlab-spark-api v3.6.1:
  * **Important:** Deprecated the use of signature files for   `PythonSparkBuilder`
    compiler jobs. Going forward, all compilation with this technology will   rely
    on `.schema` files. This implementation has more features than the   previous one.
    The only thing the user has to do is to generate a `.schema` file for   each
    MATLAB file to be compiled, instead of the `_signature.json` files used   with
    the old implementation.
    The old implementation will be completely removed in a future release.
  * Adapted package to also support Apache Spark
  * Added `explain` method to `DataFrame` class
  * Bug fix to `matlab.pyspark.sql.dataframe.Dataframe.collect` array   result handling
  * Improved documentation for `matlab.pyspark.sql.functions` `collect`,   `asc`, `desc`, `concat`, & `upper`
  * Bug fix to `matlab.pyspark.sql.functions.asc`
  * Bug fix to `matlab.pyspark.sql.functions.desc`
  * Bug fix to `matlab.pyspark.sql.functions.upper`
  * Improved functionality and documentation of `matlab.pyspark.sql.row.Row`
  * Bug fix to `matlab.pyspark.sql.row.Row.asDict`
  * Added `matlab.pyspark.sql.row.Row.asMATLABDict`
* matlab-spark-api v3.6.0:
  * Performance improvements to marshalling of compiled code
  * Minor improvements to handling of wheel files and notebooks using `PythonSparkBuilder`

## Version 7.0.4 (June 11th 2026)

* matlab-spark-api v3.5.5:
  * Removed unused Java utilities
  * Added UDF for `pandas.Series` with `Iterator` in compiler workflows
  * Added options to specify `versionTag` and `buildTag` for generated wheel file
    in compiler workflows.

## Version 7.0.3 (May 26th 2026)

* Improvements to databricks.MATLABRuntimeTask
* Improvements and bug fix to databricks.MATLABBatchTask
* Added Databricks Apps REST API support
* matlab-spark-api v3.5.4:
  * Added functions to `matlab.pyspark.sql.functions`:
      `upper`, `array_max`, `array_min`, `to_binary`, `contains`, `hex`
  * Added `matlab.pyspark.sql.dataframe.Dataframe.collect`
  * Added `matlab.pyspark.sql.row.Row`
  * Fixed bug which renamed certain columns when converting to tables
  * Removed previously deprecated partial SparkUI REST API support

## Version 7.0.2 (May 11th 2026)

* Added a Databricks Connect artifact with arguments example
* matlab-spark-api v3.5.3:
  * Support additional arguments for `mapInPandas` called from within MATLAB
  * Add module reload functionality to `addArtifacts` in `PythonSparkBuilder` class

## Version 7.0.1 (May 8th 2026)

* Add support for installing MATLAB Toolboxes during startup on
  [MATLAB on Databricks](https://github.com/mathworks-ref-arch/matlab-on-databricks)
* Cluster policy definition string handling bug fix
* matlab-json-mapper v0.4.6:
  * Fixed an issue with broken unit tests
  * Improved documentation related to doNotDecode attribute
  * Added getPrettyPrintPayload() method for improved debugging
  * Added support for heterogenous arrays when working with class hierarchies with discriminator
  * Fixed an issue with serializing doNotDecode properties
* matlab-spark-api v3.5.2:
  * Add Spark functions `date_trunc` and `coalesce`

## Version 7.0.0 (May 7th 2026)

**Major number update release with breaking change.**

* *Breaking change* Init scripts can no longer be used reliably to create MATLAB runtime based clusters
  without internet access, ideally migrate to docker based runtime clusters.
  Init script support will be removed in a future release.
* **Update required** Update the init script in
  `/Volumes/[catalog]/[schema]/[volume]/[Interfacedirectory]/runtimes`
  with the `Software/MATLAB/script/runtime_install.sh` file.
  * See also: `Documentation/InitScripts.md`
  * `Documentation/ContainerServices.md`
  * [https://github.com/mathworks-ref-arch/matlab-on-databricks](https://github.com/mathworks-ref-arch/matlab-on-databricks)
* Added wait support to `createDatabricksCluster`
* Fix for policyId/name based cluster creation using `createDatabricksCluster`
* Support specific update numbers in `generateBuildScript` for MATLAB Desktop
* Updated Databricks runtime version to 17.3 LTS, see
  `[prefdir]/databricks-settings.json`
  The existing value, if present, will not be updated. Init scripts are not supported with this version.
* matlab-spark-api v3.5.0:
  * `createDataFrame` *Breaking* bug fix, Python syntax inputs must be indicated using py.str()
  * Improved function schema format support
  * Added functions to matlab.pyspark.sql.functions:
      `e`, `exp`, `log10`, `log`, `ln`, `log2`, `log1p`, `count`,
      `count_distinct`, `randstr`, `randn`, `acosh`, `asinh`, `atan2`,
      `atanh`, `cos`, `cosh`, `cot`, `curdate`, `current_timezone`,
      `current_user`, `expr`, `isnan`, `isnotnull`, `isnull`, `length`,
      `pi`, `power`, `sin`, `sinh`, `sqrt`, `first`
  * Minor doc updates and bug fixes
  * Internal updates

## Version 6.1.8 (April 28th 2026)

* Examples updates
* Databricks Connect version compatibility updates
* Improve serverless option handling in `getDatabricksSession`
* matlab-spark-api v3.4.7:
  * Add `wheelDestination` option and `uploadWheelFile` method to `PythonSparkBuilder`
  * Minor examples update
  * Improved argument support in `compiler.build.spark.schema.mathworks.generateFunctionSchema`
  * Improve performance in Python/MATLAB-conversions using `arrow`. This is supported for
    Spark 4.0 and higher (can be forced for 3.5 using `DataFrame.getSetUseToArrow(true)`)
  * Improved Python->MATLAB for compiled workflows for `applyInPandas` and `mapInPandas`
  * Improved architecture of marshalling framework for better maintainability

## Version 6.1.7 (April 17th 2026)

* Added support for MATLAB R2026a

## Version 6.1.6 (April 9th 2026)

* Updated handling of Databricks JDBC driver and MATLAB runtime licenses
* Removed `SparkSubmitTask` based examples no longer supported by Databricks. `SparkSubmitTask` will
  be removed in release 7.0.0.

## Version 6.1.5 (March 24th 2026)

* Capped docker build script support for R2024b at update 7 due to a R2024bU8 UI bug

## Version 6.1.4 (March 20th 2026)

* License terms update
* Updates to `setup` and `onDatabricksSetup`

## Version 6.1.3 (March 18th 2026)

* Fixed minor issue in `onDatabricksSetup`

## Version 6.1.2 (March 13th 2026)

* Fixed settings issue for MATLAB on Databricks setup
* matlab-spark-api v3.4.5:
  * Made `PythonSparkBuilder` example notebook contain correct wheel name

## Version 6.1.1 (March 13th 2026)

* Updated MATLAB on Databricks consistency checks
* Updated doc and FAQ

## Version 6.1.0 (March 13th 2026)

* Added Support for MATLAB in Databricks [https://github.com/mathworks-ref-arch/matlab-on-databricks](https://github.com/mathworks-ref-arch/matlab-on-databricks)
* Added support for the Unity Catalog Connections API
* Startup improvements when running on Databricks clusters
* Bug fix when creating a cluster based on a policy id/name
* matlab-spark-api v3.4.4:
  * Documentation updates.
  * Prevent `compiler.build.spark.pythonPackage` builds on unsupported `/Volumes` paths

## Version 6.0.11 (February 27th 2026)

* Fixed bug for interactive Spark in MATLAB on Databricks cluster
* Improved `onDatabricksSetup` function
* matlab-spark-api v3.4.2:
  * Performance improvements for `Dataframe.table` method
  * Updated tests

## Version 6.0.10 (February 19th 2026)

* Disabled checks for updates in batch mode and improved logging
* matlab-spark-api v3.4.1:
  * Refactored API documentation
  * Add `addArtifact` helper method to `PythonSparkBuilder`

## Version 6.0.9 (February 12th 2026)

* Added `forceNewSession` for Databricks Sessions, enabling not reusing existing sessions.
* Updated User Agent in line with recent Databricks changes now `MathWorks_MATLAB/25.2.0` for R2025b
* matlab-spark-api v3.4.0:
  * Added support for functions `spark_partition_id`, `rank`,
    `percent_rank`, `product` and `row_number`
  * Added `DataFrame` method `repartitionByRange`
  * Added `Column` method `over`
  * Added support for `pyspark.sql.Window` and `pyspark.sql.WindowSpec`
  * Bug fix in `createDataFrame` for table inputs.

## Version 6.0.8 (February 9th 2026)

* Updates and bugfixes to `databricks.MATLABBatchTask`
* Bugfixes for `databricks.ODBCConnection` and `databricks.SQLWarehouse` when
  using *OAuth* with `userDriverAuth=false`.
* Added experimental support for creating a Toolbox (`.mltbx`) from the `.zip`.
* matlab-spark-api v3.3.5:
  * Add support for Spark types `DecimalType` and `DateType`
  * Option to run wheel scan in `PythonSparkBuilder`.
  * Improved the performance of converting Spark `Timestamp`s to MATLAB `datetime`s.

## Version 6.0.7 (February 4th 2026)

* Better verboseness handling in `startup`
* MATLAB Desktop cluster provisioning (interim solution)
  * Add `policy_id` to options
  * Improve documentation for Volumes settings

## Version 6.0.5 (February 2nd 2026)

* Minor improvements for MATLAB Desktop cluster provisioning (interim solution)

## Version 6.0.4 (January 30th 2026)

* Added interim Python notebooks to support provisioning MATLAB Desktop cluster
* Update of MATLAB runtime versions
* matlab-spark-api v3.3.4:
  * Add input schemas to Python Wrapper

## Version 6.0.3 (January 15th 2026)

* matlab-spark-api v3.3.3:
  * Add make_timestamp functions
  * The recently added features (in v3.3.0) of partial tables and
    table column names with spaces (names not supported as MATLAB identifiers) are
    both only supported when using the newer schema generation, not when using
    the deprecated JSON signature file.
* Added support for comment syntax handling in .databrickscfg file
* Added support for profile names including white space
* Documented potential SQL write performance improvement approach (preview)
* Updated MATLAB Desktop in Databricks dockerfile
* Improved MATLAB Desktop dockerfile generation script
* Added ability to scan a .whl for incompatible binary files matlab.utils.internal.wheelscan.wheelScan (preview)
* Updated Databricks Connect minimum package versions in requirements.txt files
* Databricks Connect setup now only installs into virtual environments it creates
* Expanded databricks.datastructures.unitycatalog.TableType enum to include additional types
* Added vectorization support to databricks.Cluster.permanentDelete
* Improved internal handling of HTTP options
* Fix to retain a cluster name when editing an existing cluster
* Bug fix to databricks.Genie.listConversationMessages
* Removed legacy Scala Databricks Connect v2 pom build file

## Version 6.0.2 (December 19th 2025)

* Fix to new version check
* Fix to Databricks Connect Setup
* Improved error handling and optional version checks for Databricks Connect
* Databricks Connect fixes when running on Databricks

## Version 6.0.1 (December 17th 2025)

*Major number update release with breaking changes.*

* Moved from OS specific .zip files to a a single common file
* Added support for Databricks runtime 17
  * The use of init scripts deprecated in favor of Docker
  * init script support will be removed in a future release
  * Databricks runtime 17 is not supported using init scripts, Docker must be used
* Removed previously included Databricks Connect .whl files - must now be downloaded from a repository (e.g. PyPi)
* Improved documentation on Policy creation for the MATLAB runtime and desktop
* Enabled support for storing docker auth .json files on /Volumes & /Workspace
* matlab-spark-api v3.3.2:
  * Updated API reference documentation
* matlab-spark-api v3.3.1:
  * Minor bug fix to generated notebooks for char based cluster id
* matlab-spark-api v3.3.0:
  * Add support for table columns with spaces (names not supported as MATLAB identifiers)
  * Add support for partial tables
* Fix to Oauth authentication with Databricks Connect
* Fix to HTTP(S) proxy support for Databricks Connect, JDBC & ODBC
* Fix for change in format of OauthU2M redirect URLs
* Fix to Job.cancel and SQLWarehouse.edit/create

## Version 5.3.9 (December 5th 2025)

* `databricks.SCIM` is deprecated and will be removed in a future release, move to `databricks.CurrentUser`
* Typo fix in `databricks.MATLABBatchTask`
* Added support for the preview Current User API
* Updated Databricks JDBC driver to version 2.7.5
* matlab-spark-api v3.2.9:
  * Added `dropna` method for `Dataframe`
  * Added `alias` method for `Dataframe` and `Column` classes
  * Added `transform` method for `Dataframe`
  * Added `transform` function from `sql.functions`
  * Added support for `TimestampNTZType`
  * Added support for `createDataFrame` (for R2024a and later)
  * Added `not` method for `Column` class

## Version 5.3.8 (November 7th 2025)

* Added ability to create an instance pool based on a cluster: `databricks.internal.instancepool.cloneFromCluster`
* Added support for MATLAB batch mode tasks which are not compiled: `databricks.MATLABBatchTask`
* Added support for MATLAB runtime tasks which are compiled: `databricks.MATLABRuntimeTask`
* Added high-level internal function `databricks.internal.runMATLABTask`
* *Deprecation notice* In a future release the Databricks Connect .whl files will
  no longer be included with this package and will need to be downloaded from
  a external repository e.g. PyPi.
* Bug fix to `databricks.datastructures.instancepools.CreateRequest()`
* `SparkSubmitTask` has been deprecated,
  cf. [https://docs.databricks.com/aws/en/jobs/spark-submit](https://docs.databricks.com/aws/en/jobs/spark-submit).
  Support will be removed in a later release.
* matlab-jsonmapper v0.4.4:
  * Improved default argument handing in getPayload
  * Function name typo fix for getJSON2MATLABNameMap
* matlab-spark-api v3.2.8:
  * Fix schema creation for string arguments

## Version 5.3.7 (October 25th 2025)

* Added support for the Genie REST API

## Version 5.3.6 (October 17th 2025)

* Added support for the Genie REST API
* Added recursive cross API support to `databricks.internal.io.IO.download()`
* Added test for `spark.databricks.isv.product` on Databricks
* Added support for JDBC data sources for Database Explorer App
* Added `matlab.databricks.cluster.deleteDesktopCluster` to delete a cluster on Databricks
* Improved error handling in createMATLABDesktopCluster
* Added additional tests

## Version 5.3.5 (October 9th 2025)

* Statement Execution API external disposition download fix
* Workspace API import improvements
* Updates to shipping wheel files for Databricks Connect
* Fixes to `InstancePool` enumeration values
* matlab-jsonmapper v0.4.3:
  * Documentation typo fix
  * Added JSONMapperMap methods to get keys and values
  * JSONMapperMap disp() update

## Version 5.3.4 (September 19th 2025)

> Note: Please be aware that the Init script for MATLAB Runtime on Databricks
> must be updated, in addition to downloading the MATLAB Runtime zip-file for R2025b.
> This can be done with the `setup` function in `Software/MATLAB`.

* Added support for R2025b runtime
* Updates to SimScape examples

## Version 5.3.3 (September 18th 2025)

* Added support for MATLAB R2025b Desktop
* Updated Databricks JDBC driver to version 2.7.4
* Authentication bug fix for OauthU2M & SQL Warehouses
* MATLAB Desktop changes

## Version 5.3.2 (September 12th 2025)

* Added licensing documentation
* Added command execution features
* Improved MATLAB Desktop user handling

## Version 5.3.1 (August 28th 2025)

* Added REST API support for Instance Pools
* MATLAB Desktop on Databricks updates (Preview)
* Runtime version updates
* Minor bug fixes
* **Planned Breaking changes**
  * The partial SparkUI support is now deprecated and will be removed in a future release, use the equivalent Databricks Workspace support instead
  * Legacy Basic Auth support code will be removed in a future release, this is no longer support by Databricks and so is not functional

## Version 5.2.3 (August 6th 2025)

* Internal, infrastructure updates

## Version 5.2.2 (August 1st 2025)

* Improved desktop on Databricks support (Preview)
* Added support for the Databricks OSS JDBC driver including improved performance (Preview)
* Added FAQ entry for MATLAB Parquet duration type incompatibility
* Fix for autoscaling cluster creation

## Version 5.2.1 (July 25th 2025)

* Updates in code and documentation to Simulink3DoF example
* matlab-spark-api v3.2.1:
  * Add support for `isin` method on `Column` class
  * Add support for dot-notation for retrieving columns from Dataframes, i.e.
    `col = DF.start_time`. Please cf.
    [DataframeColumns.md](./Documentation/DataframeColumns.md) for more information.

## Version 5.1.1 (June 30th 2025)

* Fix venv issue
* Minor code issues
* matlab-spark-api v3.1.1:
  * Minor fix for Databricks upload folder

## Version 5.1.0 (June 27th 2025)

This is a release with important changes to compiler technology in the
`matlab-spark-api` submodule.

* Add logging setting option to `getDatabricksSession`
* Logging to `/Volumes` is now supported
* `createDatabricksCluster` no longer enables logging by default
* matlab-spark-api v3.1.0:

  This is a release that adds several important features and improved functionality
  for the Compiler workflows.

  * Introduce schema generation, as alternative to JSON Signature
    JSON signature is deprecated and will be removed in a future release.
  * Automatically generate MATLAB examples for using artifacts
  * Extended datatype support, adding notably `StructType`, `ArrayType`,
    `MapType`, and `DayTimeIntervalType`.
  * Improved conversion from Spark `DataFrame` to MATLAB `table`.
  * Add support for `DataFrameNaFunctions`
  * Additional `pyspark.sql.functions` implementations
  * Code generation support for Simulink models. This feature is still in its early
    stages. Refer to doc in [CodeGeneration](./Documentation/CodeGeneration.md).
  
## Version 5.0.12 (June 6th 2025)

* Added support for Databricks runtime 16.4.x-scala2.12 LTS (15.4 remains the default in this release)
* Added support for MATLAB R2025a runtime, (init script requires internet access or Docker with DBR 16.x)
* Improved cluster creation error checking
* Improved MATLAB Runtime Docker generation support
* Redact token environment variable in init script logs

## Version 5.0.11 (May 27th 2025)

* Statement execution profilename auth bug fix
* Missing or incomplete profile error handling improvements

## Version 5.0.10 (May 27th 2025)

* createDatarbicksCluster fix for v17 cluster description format change
* Update to creation of Python virtual environments
* Updated JDBC driver to version 2.7.3

## Version 5.0.9 (May 12th 2025)

* Databricks Connect clusterId argument bug fix
* Improved venv & virtualenv handling
* Updated Databricks Connect .whl files

## Version 5.0.8 (May 7th 2025)

* Improved Docker based runtime cluster creation documentation
* databricks.Files error handling documentation fixes
* Added MATLAB desktop create & control notebooks - preview feature
* Added admin setup notebook - preview feature
* Updated MATLAB desktop docker image support - preview feature
* `createDatabricksCluster` docker error message fix
* Minor bug fix to filter out non Linux runtime .zip files
* matlab-spark-api v3.0.10:
  * Fix type error for `Dataframe/count` method

## Version 5.0.7 (April 8th 2025)

* Add logging setting option to `getDatabricksSession`
* Updated databricks-connect libraries for 15.4 to 15.4.8
* Updated databricks-connect libraries for 14.3 to 14.3.8
* Updated databricks-connect libraries for 13.3 to 13.3.5
* Fix pip download for paths with spaces
* matlab-spark-api v3.0.9:
  * Fix for installation of Wheel libraries on Databricks

## Version 5.0.6 (March 7th 2025)

* Bug fix when recording orgId on initial setup

## Version 5.0.5 (March 6th 2025)

* Databricks JDBC driver updated to version Version 2.7.1
  * Enables refresh token support & caching on Windows
* ODBCConnection class updates
* Standalone JDBC driver configuration file is now optional
* Standalone ODBC driver configuration file is now optional
* Setup uses OauthU2M by default in place of PAT
* matlab-spark-api v3.0.8:
  * Fix path for `addArtifact` on Windows

## Version 5.0.4 (February 5th 2025)

* matlab-spark-api v3.0.7:
  * Minor function argument bugfix

## Version 5.0.3 (February 5th 2025)

* remove spurious warnings in createDatabricksCluster
* Better error handling for file operations
* Improve handling of configuration path
* Import *Virtual Environment* handling on Windows/WSL
* matlab-spark-api v3.0.6:
  * Fix bug when generating signature using output arguments
  * Improve error handling for `setuptools` and `distutils`
  * Fix minor compiler issue
  * Handle UDF return types for arrays
  * Minor documentation updates

## Version 5.0.2 (December 16th 2024)

* Added allowlist configuration to setup process (admin only)
* Improved handling of cluster-scoped library restrictions
* Improved allowlist validation (admin only)
* Cloud vendor determination bug fix
* Cluster creation error bug fix
* matlab-spark-api v3.0.2
  * Improved error handling in installWheelOnDatabricksCluster.m

## Version 5.0.1 (November 29th 2024)

* Allow docker URLs with empty name/password in `createDatabricksCluster`
* Minor bug fix to createDatabricksCluster profile handling
* Update to configuration file path handling in deployed mode
* Fix minor package name changes in examples
* Setup no longer needs to request the OrgId value in most cases
* Improved setup's handling of unsupported Python versions
* Minor documentation updates
* matlab-spark-api v3.0.1
  * Minor documentation addition

## Version 5.0.0 (November 20th 2024)

* Significantly simplified `/Volumes` based installation process
  * Required Jar and Python libraries are now included
* Updated Databricks JDBC driver version to: 2.6.40-patch-1
* Renamed shaded driver to: `Software/MATLAB/lib/jar/Shaded-Databricks-JDBC-Driver-0.0.2.jar`
* Added a standalone database only interfaces for JDBC & ODBC
* Reduced startup time
* Added generation of cluster policies
* **Breaking changes**
  * MATLAB R2022b or later is now required
  * Databricks runtimes 13.3 or later are now required
  * Databricks Connect v1 support has been removed, use v2
  * Using Compiler SDK to create Java libraries for Databricks is no longer supported
  * argument updates to the `databricks.Cluster.enableMATLABRuntime` method
  * Removed support for `org_id` & `cluster_id` in `databricks-settings.json`, fields moved to `.databrickscfg`
* The default cluster logging location has been changed from `dbfs:/MathWorks/logs/cluster_logs` to `dbfs:/cluster-logs` to align with the Databricks default
* `createDatabricksCluster`
  * Now supports disabling of logging, logging is enabled by default
  * Default init script path is now `/Volumes` based `settings:interfaceDirectory/runtimes/install_runtime.sh`
  * Init script is now common across MATLAB releases
* Added `LEGACY_SINGLE_USER_STANDARD` to `databricks.datastructures.DataSecurityMode`
* Added `fileExists` and `directoryExists` methods to `databricks.Files`
* Removed support for redundant port field in `databricks-settings.json`, not used by Databricks Connect v2
* Added support for `org_id` & `cluster_id` fields in `.databrickscfg`
* Added `databricks.Workspace.fileExists` method
* Updated examples
* **Authentication Breaking changes**
  * Removed legacy deprecated Active Directory Authentication (and Credential Passthrough) support
  * Removed legacy DBConnect authentication mode support as DB Connect v1 is no longer supported
  * Removed deprecated Basic authentication mode support as no longer supported by Databricks
* **Misc. Breaking changes**
  * Moved `databricksPackageVersion` to `matlab.databricks.databricksPackageVersion`
  * Removed `Library.enableJavaLibrary`
  * Removed `runRuntimeDownloadNotebook`
  * Removed `importRuntimeDownloadNotebook`
  * Removed `checkVersionRequirements`
  * Removed `getDefaultDatabricksSession`, use `getDatabricksSession` instead.
  * Removed `getSparkEnvVars`
  * Removed `generateInitScript`
  * Removed `getRuntimeMapping`
  * Removed `getDefaultSparkProperties`
  * Removed `array2seq`
  * Removed `buildSparkSubmitTask`
  * Removed `getSparkVersion`
  * Removed `javaobj2array`
  * Removed `keyValueJSONEdit`
  * Removed `OpenSparkLog`
  * Removed `pretty`
  * Removed `SparkSubmitOnNewCluster`
  * Removed `string2java`
  * Removed `tail`
  * Removed `uploadAndInstallJar`
* Licenses for third party library can be found in `3rdPartyLicenses` directory
* matlab-spark-api v3.0.0
  This is a major release with breaking changes
  * Python SparkSession introduced
  * Improved argument handling for Spark objects (`Dataframe`, `Column`, etc.)
  * Add support for new `addArtifacts` workflows
  * **Breaking changes**
    * Java SparkSession retired
    * Support for building Java libraries for Spark removed
    * `matlab.sparkutils.Config` class deprecated and removed
    * No `<func>_pandas_schema` generated anymore, please use `<func>_output_schema` instead
    * Removed `RuntimeQueue`, as used by previous Scala builds
    * Removed support for the `compiler.build.spark.internal.pythonPackage`, as this is not needed in newer versions
    * Removed `createJavaSparkConf`
    * Removed `dataset2table`
    * Removed `getPersistentSparkSession`
    * Removed `getSparkJarsLocation`
    * Removed `getSparkMajorVersion`
    * Removed `javaobj2array`
    * Removed `makeJavaArray`
    * Removed `pretty`
    * Removed `string2java`
    * Removed `table2dataframe`
    * Removed `tail`
* matlab-mlflow v0.1.2
  * Added Python fluent interface
  * Added Databricks unified authentication support
  * Added startup verbose option
  * Requires MATLAB R2022b or later
* matlab-jsonmapper v0.4.2
  * README.md typo fix, MATLAB R2020b is required.
  * Added startup verbosity option

## Version 4.0.9 (August 9th 2024)
* Workaround for apt-get update connectivity issue for 11. & 12.x

## Version 4.0.8 (August 9th 2024)
* matlab-spark-api, rel v2.0.7:
  * Ship matlab-runtime-queue Jar file
* matlab-spark-api, rel v2.0.6:
  * Support Short in SparkUtility, bug fix
* Bug fix to databricks.internal.utils.provisionRuntime
* Init scripts no longer abort in the absence of internet access, can affect Simulink see: Documentation/InitScripts.md
* Bug fix to cluster boot failure with Databricks ML runtimes

## Version 4.0.7 (July 8th 2024)
* Workaround for Scala library build issue introduced in Databricks Runtime 14.3.4
* Installation fixes
* Authentication documentation improvements

## Version 4.0.6 (June 21st 2024)
* Minor bug fix if using DotDatabricksConnect authentication mode
* Startup comparison of `.databricks-connect` and `.databrickscfg`, to avoid misconfigurations.
* Minor fixes to batch install
* Better handling of vendor settings.
* Improved cluster handling for JDBC/ODBC connections

## Version 4.0.5 (June 5th 2024)
* Improved updateClusterId if legacy .databricks-connect file is not used
* Bug when handling .databrickscfg files with only one profile
* Improved Oauth token caching

## Version 4.0.4 (May 29th 2024)
* Updated prebuilt Docker container URLs
* Improved default authentication profile name handling
* Migrated Cluster Id from `databricks-settings.json` to `.databrickscfg` file
* Updated default Azure node types, Standard_DS3_v2 to Standard_D4ds_v5
* Minor bug fixes
* matlab-spark-api, rel v2.0.3:
  * Improve profile handling for builds.

## Version 4.0.2 (May 10th 2024)
* Fix when using a non default authentication profile or method
* Add options to `createDatabricksCluster` to better handle Docker images
* Improvements to install process
* `databricks.JDBCConnection` made TokenCachePassPhrase parameter optional
* matlab-spark-api, rel v2.0.2:
  * Argument handling in Databricks specific methods
* matlab-spark-api, rel v2.0.1:
  * Minor argument handling

## Version 4.0.1 (April 23rd 2024)
* Install optimization where a previous installation exists

## Version 4.0.0 (April 23rd 2024)
* Added support for the Databricks Unified Authentication process (.databrickscfg files)
  * **Breaking change** `databricks.SQLWarehouse.connect` interface changed to support Unified Authentication
  * **Breaking change** Azure credential passthrough (legacy) support will be removed in the next minor release
  * `.databricks-connect` files now provide legacy support for Databricks Connect v1 only
* Added support for the Files REST API (currently in Public Preview)
* Added documentation references to the ODBC driver File Exchange entry
* **Breaking change** Updated and moved `databricks.JDBCBuilder` functionality to `databricks.JDBCConnection`
* **Breaking change** Removed support for JDBC drivers less than version 2.6.36
* **Breaking change** getDefaultDatabricksSession renamed to getDatabricksSession
* Updated default Databricks Connect runtime version from 10.4 to 13.3
* **Breaking change** Removed support for the `databricks.Configuration` class
* **Breaking change** `databricks.Object.getSettings/getConfigFromEnvVars` functionality migrated to internal classes
* **Breaking change** Removed `databricks.getConfigFile`
* **Breaking change** Moved `detectProxy` to `matlab.utils.detectProxy`
* **Breaking change** Moved `databricks` (CLI wrapper) to `matlab.databricks.cli`
* Installation updates
* Documentation updates
* matlab-spark-api, rel v2.0.0:
  * **Breaking change** Changed namespace from `matlab.compiler.mlspark` to `matlab.spark.sql` for all Spark classes.
    This should not have an impact for most users, as these name spaces are mostly used _under the hood_. This also
    improves consistency with Apache Spark namespace.
  * Deprecated `getPersistentSparkSession`
  * **Breaking change** Remove the `BuildType` concept for `SparkBuilder`, with which builds for _Tall_ and _SparkAPI_
    could be made. These workflows can still be used with basic Compiler/Compiler SDK workflows.
  * **Breaking change** Removed the function `buildSparkJarTask` (related to `BuildType` above).
* matlab-jsonmapper, rel v0.3.4:
  * Minor documentation updates
* matlab-mlflow, rel v0.0.24:
  * Internal changes to handle changed backend requirements

## Version 3.3.6 (28th March 2024)
* Fix runtime path for R2024a

## Version 3.3.5 (22nd March 2024)
* Add support for MATLAB R2024a

## Version 3.3.4 (16th February 2024)
* JDBC driver updates, and better handling of log messages
* Move Artifact Allowlist helper functions (old names still work)
* Add support for 14.3 LTS release

## Version 3.3.3 (13th February 2024)
* Improved serial installation robustness

## Version 3.3.2 (6th February 2024)
* Minor bugfix for argument handling

## Version 3.3.0 (2nd February 2024)
* Added dedicated shared Cluster documentation (Isolation.md)
* Clarified supported features on MATLAB & Databricks runtime versions (SupportMatrix.md)
* Updated createDatabricksCluster for docker and shared clusters
* Added custom tag support to createDatabricksCluster
* Bug fix to installation DBFS write testing with custom install paths
* Minor bug fixes
* matlab-spark-api, rel v1.1.2:
  * Fix build bug for certain databricks 14+ versions
  
## Version 3.2.1 (23rd January 2024)
* Bugfix, maven install on clusters
* Bugfix, improved support for creating clusters using MATLAB releases without a runtimes.json entry

## Version 3.2.0 (19th January 2024)
* Docker containers updates
* More options for locations in `createDatabricksCluster` (dbfs, workspace, etc.)
* matlab-spark-api, rel v1.1.0:
  * Update to UDF functions for `PythonSparkBuilder`

## Version 3.1.2 (20th December 2023)
* MATLAB Runtime provisioning bug fix

## Version 3.1.1 (12th December 2023)
* Installation bug fix

## Version 3.1.0 (11th December 2023)
* Significant updates to installation to try cluster based options and fall back to local
* REST API documentation updates for Cluster, Command Execution and Unity Catalog APIs
* Added support for init script on volumes for Databricks runtimes 13.3 and greater
* Added Unit Catalog Allow List REST API support (in Databricks Public Preview)
* createDatabricksCluster() doc bug fix for workspaceInitPath argument, see initScriptPath
* Syntax bug fix to Cluster.edit()
* Disabled automatic use of optimized base64 support on macOS
* matlab-spark-api, rel v1.0.11:
  * Improve build of Spark-Utility
  * Add support for Spark 3.5.0

> Rebuilding applications compiled with versions greater than 3.0.12 as `.jar` or `.whl` files is not required.

## Version 3.0.15 (16th November 2023)
* Update SQL Warehouse REST API support
* Documented Python version compatibility for Compiler workflows [SupportMatrix.md](Documentation/SupportMatrix.md)
* matlab-spark-api, rel v1.0.10:
  * Documentation typo fix

> Rebuilding applications compiled with versions greater than 3.0.11 as `.jar` or `.whl` files is not required.

## Version 3.0.12 (31st October 2023)
* matlab-spark-api, rel v1.0.9:
  * Fix for `mapInPandas`/`applyInPandas` issue

> Compiled workflows should be rebuilt in this release (`.jar` or `.whl` files).

## Version 3.0.11 (26th October 2023)
* Updated FAQ regarding incorrect Databricks Connect v1 port values
* Fixed bug in Init Script generation on Windows
* Updated MATLAB R2023b runtime version to Update 2

> Rebuilding applications compiled with versions greater than 2.0.3 as `.jar` or `.whl` files is not required.

## Version 3.0.10 (24th October 2023)
* Improved local install support
* Fixed bug in `runtimeProvision`
* Ensure `ClusterInstall` uses Databricks Runtime based on Databricks Connect version
* Updated R2023b MATLAB runtime version to update 2
* matlab-spark-api, rel v1.0.8:
  * Internal improvements
  * Implement `Column` methods `isNull` and `isNotNull`

> Rebuilding applications compiled with versions greater than 2.0.3 as `.jar` or `.whl` files is not required.

## Version 3.0.9 (20th October 2023)
* Improvements to ClusterInstall regarding Databricks Connect v2
* Fix issue with recursive downloads from DBFS
* matlab-spark-api, rel v1.0.7:
  * Improved support for join method on Dataset object
  * Different handling of Spark Version for Databricks
  * Update build for SparkUtility, related to DatabricksConnect v2

## Version 3.0.7 (4th October 2023)
* Added support for Databricks Connect v2 for Databricks runtimes >= 13.3
* MATLAB versions older than R2021b are no longer supported
* Added support for MATLAB R2023b
* createDatabricksCluster now supports access/data security mode and defaults to SINGLE_USER
* Added support for the Command Execution REST API
* Added a resilient client-side MATLAB runtime downloader/uploader
* Removed support for Databricks runtime 7.x which is no longer supported by Databricks
* Removed now unused spark_version & spark_utility_version fields from databricks-settings.json.template
* Added "export MW_CONNECTOR_CONNECTION_PROFILES=noop" to newly generated init scripts
* Updated JDBC driver *0.0.2 minimum version to 2.6.34
* Run.get() bug fix to int64 and timestamps handling with scalar results
* Documentation updates
* matlab-spark-api, rel v1.0.4:
  * Added support for Spark 3.4.1
  * Added Unity Catalog related testing exception
  * Fix build for DatabricksConnect v2
* matlab-mlflow, rel v0.0.23:
  * Added initial support for Databricks Connect v2 environment variable credentials

## Version 2.0.4 (19th September 2023)
* matlab-spark-api, rel v1.0.1:
  * Handle issue with timestamps in return tables
  * Improved array handling in `table` method on `Dataset`

## Version 2.0.3 (8th September 2023)
* Minor installation update

## Version 2.0.2 (6th September 2023)
* Minor installation update

## Version 2.0.1 (5th September 2023)
* Improved user input handling
* Added detection of cluster job & notebook support
* Updated MATLAB runtime versions

## Version 2.0.0 (4th September 2023)
* Default Databricks runtime version set to 10.4 LTS
* Improve cluster creation from MATLAB
* Spark version now based on Databricks runtime version
* Silent installer improvements
* Documentation and test updates
* matlab-spark-api, rel v1.0.0:
  * Added support for TimeStamps in Compiler SDK Workflows
  * Removed `TableAggregate` method signature
  * Performance improvements for data marshalling between Spark and MATLAB
  * More info in [release notes](Modules/matlab-spark-api/RELEASENOTES.md)

> **Note** This is a major number release with some breaking changes.

## Version 1.5.0 (July 13th 2023)
* Allow editing of existing clusters
* Allow enabling MATLAB on existing clusters, MATLABenableExistingCluster
* Installer now dynamically uses the latest LTS Releases
* Added Databricks Connect support for 12.2. LTS release
* SparkSubmitTask bug fix
* Removed nonfunctional and unused listMATLABRuntime function
* Added policy support to createDatabricksCluster
* Improved error handling
* Added cluster runtime engine & security mode configuration support
* Documentation updates
* matlab-spark-api, rel v0.3.6:
  * Implement table method on DataFrameReader
* matlab-spark-api, rel v0.3.5:
  * Add more Spark Versions
  * Extend test builds

## Version 1.4.1 (June 16th 2023)
* Cluster installer fix

## Version 1.4.1 (June 16th 2023)
* Cluster installer fix

## Version 1.4.0 (June 15th 2023)
* Moved cluster init scripts to the user's workspace
* Documentation updates
* Improved databricks.Job error handling
* Improved databricks.Cluster.getNodeTypes error handling
* Improved databricks.DBFS.download error handling
* Improved databricks.Workspace support
* Fixes to SparkSumbitTask and SparkJarTask libraries
* Cluster based install updates
* Updated Databricks runtime versions
* Updated MATLAB R2023a runtime version
* matlab-spark-api, rel v0.3.4:
  * Handle Python path when building wheel files

## Version 1.3.1 (May 3rd 2023)
* Improvements for local install on Windows
* Better output for DBFS upload/download (percentages)
* matlab-spark-api, rel v0.3.2:
  * Performance improvements for PythonSparkBuilder runtime

## Version 1.3.0 (March 29th 2023)
* Added R2023a support

## Version 1.2.3 (March 7th 2023)
* Changed cluster autotermination default from 0 (indefinite) to 120 minutes as per Databricks default value
* Minor bug fixes for MATLAB supported MATLAB releases prior to R2020b
* Added Databricks Runtime 11.3.x support
* Improved startup process
* Updated MATLAB Runtime versions
* Added Compiler SDK workflow demo
* matlab-mlflow, rel v0.0.22:
  * Removed Contents.m file

## Version 1.2.2 (13th February 2023)
* Documentation updates
* Improved base64 mex file handling
* Improved javabuilder path handling
* Improved startup feedback
* matlab-spark-api, rel v0.3.0:
  * Install doc fixes
  * Implemented `mode` method for `DataFrameWriter`
  * Implemented `bucketBy` and `sortBy` for `DataFrameWriter`
  * Improved javabuilder path handling

## Version 1.2.1 (27th January 2023)
* Runtime URL fix

## Version 1.2.0 (27th January 2023)
* Added Unity Catalog REST API support
* Enabled interactive installer to use MATLAB Runtime in addition to MATLAB Compiler SDK support
* Made apt-get dependant workflows resilient to misconfigured Origins/repos, fixes sporadic install and init script crashes

## Version 1.1.11 (21th December 2022)
* Reduce databricks-connect build time
* matlab-spark-api, rel v0.2.10:
  * Minor fixes for tests
* matlab-spark-api, rel v0.2.9:
  * Generate example files for `PythonSparkBuilder`

## Version 1.1.10 (29th November 2022)
* Update runtime version for R2022b (update 2)
* matlab-spark-api, rel v0.2.8:
  * Support encryption for `SparkBuilder`
  * Support obfuscation for `SparkBuilder`

## Version 1.1.9 (16th November 2022)
* matlab-spark-api, rel v0.2.7:
  * Minor Apple silicon fix

## Version 1.1.8 (16th November 2022)
* Enabled Apple silicon beta in startup
* Improved installation process
* matlab-spark-api, rel v0.2.6:
  * Implemented `pivot` method on `RelationalGroupedDataset`
  * Enabled Apple silicon beta in startup
* matlab-mlflow, rel v0.0.21:
  * Enabled Apple silicon beta in startup

## Version 1.1.7 (14th November 2022)
* Fixed unnecessary client side Maven requirement in cluster based install

## Version 1.1.6 (14th November 2022)
* Improved installation process
* Fixed minor DBFS.download bug
* Updated R2022b runtime version to Update 1
* matlab-spark-api, rel v0.2.5:
  * Consolidated building Java based utilities

## Version 1.1.5 (4th November 2022)
* Improved checks for Maven
* Update Web Desktop for R2022b (PoC feature)
* Improved installation package upload process
* Improved DBFS performance under macOS

## Version 1.1.4 (28th October 2022)
* Improved handling of custom domain names during installation
* Minor bug fix to JDBC connection creation
* UI text improvements to installation process
* matlab-mlflow, rel v0.0.20:
  * Tests with standalone MLflow installation
  * Added basic documentation and a getting started guide
* matlab-spark-api, rel v0.2.3:
  * Handle filename escaping for comments
  * Update `SparkApiRef.md`

## Version 1.1.3 (13th October 2022)
* Redact access token during install
* Improved handling of custom domain names during installation
* matlab-mlflow, rel v0.0.18:
  * Minor documentation updates

## Version 1.1.2 (12th October 2022)
* Fixed error in `databricks.ClusterPolicy.list`

## Version 1.1.1 (11th October 2022)
* Updated Simulink 3DoF example
* Improved error handling in install.m
* Improved Hadoop support (winutils) handling for Windows
* Added updateClusterId function to update .databricks-connect file
* matlab-mlflow, rel v0.0.17:
  * Added RunInfo run_name field support

## Version 1.1.0 (6th October 2022)
* Add support for MATLAB R2022b
* Improved error handling in installation
* Fixed returned data types for some fields in Cluster list, findByName & findById methods
* matlab-spark-api, rel v0.2.0:
  * Global handling of MATLAB Runtime for Java jobs, improving resource utilization
  * Make `runSparkShell` functions Runtime version dependent
  * Add support for `pythonPackage` for older releases
  * Fixed `SparkBuilder` issue for release R2022b
* matlab-mlflow, rel v0.0.16:
  * JSON Decoder support for int32 values
  
## Version 1.0.1 (8th September 2022)
* Interactive installation updates
* Scripted installation updates
* Added ODBC connectivity documentation

## Version 1.0.0 (7th September 2022)
* Full sematic version number adopted vs. just two minor digits
* matlab-spark-api, rel v0.2.0:
  * Improved PythonSparkBuilder
  * Improved error handling in deployed mode
  * Make it possible to use arrays as arguments to Python/Java Spark Builder functions
  * Bugfix for `pretty` in R2019a
* Improved Azure Databricks specific features documentation
* Improved Databricks Connect proxy handling and documentation
* Adopted Databricks Runtime 10.4 as installer default
* Improved Web Desktop creation (PoC feature)
* Improved error handling in deployed mode
* Improved initscript template for R2021a patch handling
* Updated references to the Databricks Workspace
* Workspaces documentation improvements
* JDBC Driver documentation version updates
* JDBCBuilder updates
* Job API int64 (run_id, job_id, created_time) handling fixes
* **Breaking change** `databricks.DBFS/ls` now returns scalar strings in the path column instead of a cell array 
* **Breaking change** SQL Endpoints renamed to SQL Warehouses, also see [FAQ](Documentation/FAQ.md#name-change-sql-endpoints-to-sql-warehouses).
* `getDefaultDatabricksSession` now truly returns a singleton. No longer sets a customizable `appName` as there is just one session for everything Spark related inside MATLAB, sets appName to automatically generated 'matlab_*timestamp*'

## Version 0.6.18 (18th July 2022)
* Minor fix to Databricks Connect library version handling

## Version 0.6.17 (15th July 2022)
* Install libnss3 in runtime setup to support Simulink
* Add Simulink3DoF demo run in Python notebook
* matlab-spark-api, rel v0.1.32:
  * JAVA_HOME handling on Databricks fix
  * Support `mapInPandas`
  * Rename `func_pandas` to `func_applyInPandas`
  * Lazy creation of MATLAB Runtime for Python interface
* matlab-mlflow, rel v0.0.15:
  * REST API improvements and fixes

## Version 0.6.16 (8th July 2022)
* Internal release only

## Version 0.6.15 (10th June 2022)
* Add demo data functions from `/dbfs/databricks-datasets`
* Fixed int64 handling for Job.create job_id value
* Fixed int64 handling in Cluster.refresh
* Added StorageInfo datastructures
* Fixed issue where `spark_conf` key-names were corrupted when submitting Jobs on new clusters
* Added support for setting a cluster's `driver_instance_pool_id`
* Documentation updates
* matlab-spark-api, rel v0.1.30:
  * Support for vectors in `dataset2table`
  * Support string type for SparkBuilder additional arguments
* matlab-mlflow, rel v0.0.14:
  * Fix `int64` and `timestamp` handling for `FileInfo`, `ModelVersion` and `RegisteredModel`.

## Version 0.6.14 (20th May 2022)
* Minor install script fixes

## Version 0.6.13 (18th May 2022)
* JDBC driver related updates
* Improved HTTP options & proxy handling
* matlab-spark-api, rel v0.1.29:
  * Add `isin` method for `Column` object
* matlab-mlflow, rel v0.0.13:
  * Improved HTTP options & proxy handling

## Version 0.6.12 (16th May 2022)
* Added support for Databricks SQL Endpoints
* Interactive and silent installation improvements
* DBFS.getStatus metadata handling bug fix
* Workspace.getStatus metadata handling bug fix
* matlab-spark-api, rel v0.1.28:
  * Add exception cause for missing Jar in Databricks
* matlab-spark-api, rel v0.1.27:
  * Migrate from `distutils` to `setuptools` for `PythonSparkBuilder`
  * Add metrics option for (some) Pandas methods
  * Enable persistent spark sessions for Databricks
  * Add concat method from `sql.functions`
  * Add schema method on `DataFrameReader`
  * Add `TableAggregate` type for `PythonSparkBuilder`

## Version 0.6.11 (14th Apr 2022)
* Added support for setting a cluster's policy_id
* Improve databricks.Workspace int64 handling
* Improved Machine Learning demo
* Added ClusterPolicy REST API
* matlab-spark-api, rel v0.1.26:
  * Support methods `describe` and `summary` on Dataset class
  * Support *Pandas* methods in `PythonSparkBuilder`.
* matlab-mlflow, rel v0.0.12:
  * Improved JSON handling

## Version 0.6.10 (31th Mar 2022)
* Fixed installation bug with R2020a
* JDBC builder fix for 2022a
* Updates to DBFS, Library & FileInfo
* Install libgbm in runtime setup to support Simulink
* matlab-spark-api, rel v0.1.25
  * Enabling additional arguments for Table functions
  * Provide helper functions for Compiler workflows
  * Add `na` method for dataset
* matlab-mlflow, rel v0.0.11
  * Improved documentation
  * Fixed authentication file bug

## Version 0.6.9 (15th Mar 2022)
* Enable cluster creation with custom docker image
* matlab-spark-api, release 0.1.23
  * Implement more `sql.functions` methods

## Version 0.6.8 (22nd Feb 2022)
* Improved error handling
* Reduced dependance on /dbfs
* Updated default runtime directory
* matlab-spark-api:
  * Add PythonSparkBuilder feature
* matlab-mlflow:
  * startup improvements
  * Minor string handling fixes

## Version 0.6.7 (10th Feb 2022)
* Improved error handling

## Version 0.6.6 (9th Feb 2022)
* Improved error handling on Windows

## Version 0.6.5 (9th Feb 2022)
* Updates to running MATLAB on a cluster
* Documentation updates
* MLflow
  * API Documentation updates

## Version 0.6.4 (7th Feb 2022)
* Cluster based installation updates
* Documentation updates
* MLflow
  * Further API updates

## Version 0.6.3 (4th Feb 2022)
* Enhancements to cluster install scripts
* Updated default Databricks runtime to 9.1.x-scala2.12
* MLflow:
  * Improve APIs and underlying objects

## Version 0.6.2 (27th Jan 2022)
* Minor fixes to cluster install scripts

## Version 0.6.1 (26th Jan 2022)
* Minor fixes to cluster install scripts

## Version 0.6.0 (21th Jan 2022)
* Added support for server side package building
* Move submodules to top-level
* Include utility for upload and install of Jars
* MLflow
  * Handle issues with JSON decoding
  * Add MATLAB proxy to mlflow CLI
  * Improved mlflow.Run APIs
  * Add non-Databricks configuration
* matlab-spark-api
  * SparkBuilder Info added
  * Support Yarn as host for SparkSession

## Version 0.5.13 (7th Jan 2022)
* Update JDBC workflow to use update Databricks Jar (log4j issue)
* Add utility function for creating clusters
* Update SparkAPI generated documentation

## Version 0.5.12 (15th Dec 2021)
* Add several methods from `org.apache.spark.sql.functions`
* Improved azPTAuthRest & azPTRefreshTokenREST, using REST auth by default
* Add several methods from `org.apache.spark.sql.functions`
* Bug fixes and documentation improvements to *matlab-spark-api*
* Update SparkAPIRef documentation

## Version 0.5.11 (1st Dec 2021)
* Spark-API doc updates
* SparkSession Hive utilities
* Added REST API support for Azure Credential Passthrough
* Add support for Jobs 2.1 API
* Improved *matlab-spark-api* documentation
* SparkBuilder improvements
* Improve authorization handling for *matlab-mlflow*
* Update API documentation for *matlab-mlflow*

## Version 0.5.10 (21th Oct 2021)
* Fixed bug with mapPartion Table generation
* Fixed bug in azPTRefreshToken
* Added 3.1.1 configuration of Spark
* Several methods on Dataset object added
* R2021b entry added to runtimes.json

## Version 0.5.9 (28th Sept 2021)
* Enable the use of parameters in Notebook tasks
* Enable table input in mapPartition (see spark-api)

## Version 0.5.8 (8th Sept 2021)
* Minor fixes
* Updated version of *matlab-spark-api*, 0.1.11

## Version 0.5.7 (6th Sept 2021)
* Added job schedule support
* Minor fixes

## Version 0.5.6 (3rd Sept 2021)
* Simulink example showing workflow to run Simulink model on Databricks 
* Minor fixes

## Version 0.5.5 (24th Aug 2021)
* Improvements to JDBC error handling and documentation
* Added scripts to generate and run notebook based runtime downloads
* Improve docker support for images based off Databricks images
* Simplified configuring job notifications
* Updated JDBC interface
* Added Azure Credential Passthrough support
* Removed dependency of SparkSession on SparkConf and SparkContext (MATLAB classes)
* Added a feature table to documentation, see Documentation/SupportMatrix.md
* Incorporate *matlab-mlflow* and *matlab-spark-api* in general documentation.

## Version 0.5.4 (10th Jun 2021)
* Support for Spark 3.x (with patches for R2021a)
* Fixed JARs used for spark-submit jobs
* Support for binary types
* Fixed tests for changes in the Jobs API

## Version 0.5.3 (5th May 2021)
* Diagnostics for checking the correctness of the installation
* SparkConfPair and CustomTags reimplemented to use containers.Map
* Added single-node cluster configuration convenience method
* Fixed DBFS upload method error due to server-side changes

## Version 0.5.2 (1st Mar 2021)
* Spark configuration uses ISV strings on cluster creation
* Updated default cluster setting to 7.3.x-scala2.12
* Added methods to create default spark properties and default session
* Added methods to set autotermination properties
* Improved documentation

## Version 0.5.1 (10th Jan 2021)
* Automated releases and documentation
* Both mlflow support and spark-api support as modules
* Searchable HTML doc (auto-generated) and PDF (auto-generated)
* Support for both Spark 2.x and 3.x for the databricks-connect workflows
* More methods for MATLAB spark API abstractions

## Version 0.5.0 (2nd Jan 2021)
* MLFlow support for Experiments and Runs
* Bug fix to enable multiple cluster init scripts
* Added SparkConfPair support to the Clusters API
* Added functionality to turn timestamps of objects into MATLAB datetime types for legibility
* DBFS upload() string handling bug fix

## Version 0.4.10 (1st Oct 2020)
* Added Library REST API documentation
* Added ability to run the silent installer against a particular version of databrick-connect
* Exposed the table method on the SparkSession
* Added byte support for data marshaling
* Exposed JDBC method for the DataFrameReader to read from database sources

## Version 0.4.9 (7th Jul 2020)
* Added Workspaces REST API support
* Added documentation on using Azure blob storage
* Added demonstration used for the Spark+AI summit 2020
* Added DBFS move method
* Added additional Run methods
* Added username field to settings.json

## Version 0.4.8 (17th Jun 2020)
* Added Secrets & scopes REST API support
* Added ability to recursively download files
* Added support for long integers and type accurate table conversions
* Improved Bash and PowerShell installation scripts
* Improved JDBC documentation
* Improved JSON configuration file documentation
* Added ability to set a notification email address in ```settings.json```
* Added support for multiple runtime versions
* Fixed unit tests

## Version 0.4.7 (6th May 2020)
* Improved Databricks Connect and support scripts
* Removed deprecated dbconnect install process
* Added a FAQ section to documentation
* Consolidated authentication and REST API creation to base objects.
* Consolidated DBFS read and download methods. The `read` methods *does not*  save the data to a file anymore. Use download for saving to a file instead.
* Added SQL methods to SparkSession.
* Added Logging for init_scripts
* Added a clean method for the databricks Connect to uninstall the tooling.
* Optimized platform specific base64 encode/decode functions for faster uploads and downloads.

## Version 0.4.6 (15th Apr 2020)
* Improved Databricks Connect and support scripts
* Library API support
* Bug fixes

## Version 0.4.5 (19th Mar 2020)
* Added Connect class for Databricks Connect installation

## Version 0.4.4 (13th Mar 2020)
* Improved dataset support
* Docker work for cluster provisioning
* Functional test work for DBConnect

## Version 0.4.3 (3rd Mar 2020)
* Added service transformer to handle the appropriate FS support in the built library
* Added more tests to the databricks-connect spark integration
* Added methods to find clusters by name and id
* Added documentation and support for custom container services

## Version 0.4.2 (20th Feb 2020)
* Log handling for databricks-connect log files
* Merged Webinar content to the general release
* Updated the Security.md to use the latest recommendations from the Security team

## Version 0.4.1 (12th Feb 2020)
* Better host endpoint handling
* Minor fixes to documentation and help
* Improved error handling for REST requests

## Version 0.4.0 (10th Feb 2020)
* Single configuration process for both databricks-connect and MATLAB
* Methods to follow a unified provider chain to authentication information

## Version 0.3.9 (4th Feb 2020)
* Improved API for dataframes
* Better installation / setup scripts and instructions

## Version 0.3.8 (18th Nov 2019)
* Updated the JDBC driver and Java software
* Added wrapper classes for the dataframe readers and writers (methods not yet exposed)

## Version 0.3.7 (11th Nov 2019)
* Added CLI wrappers for databricks
* Added additional help
* Added DBConnect based workflows and support for Delta Lake data sources

## Version 0.3.6 (15th Oct 2019)
* Added methods and classes to support the creation of custom tags.

## Version 0.3.5 (7th Oct 2019)
* Bugfixes with the DBFS upload/download methods
* Vectorization of upload/download methods to handle directories of data
* Nominally working javaclasspath.txt for databricks-connect
* Changed format of the ```databricks.json``` files to match the config required for databricks-connect

## Version 0.3.4 (1st Oct 2019)
* Added ability to override HTTP options (support for Proxy settings)

## Version 0.3.3 (28th Sep 2019)
* Added benchmarks
* Fixed bug in upload code due to platform specific charset on Linux

## Version 0.3.2 (24th Sep 2019)
* Updated default Spark version for Clusters to 5.5.x-scala2.11
* Added initial benchmarks with 5, 10, 15, 20, 30, 40, 80 workers

## Version 0.3.1 (20th Sep 2019)
* Completed doc with one end-to-end demo example running against the full dataset
* Demo example using the MATLAB API
* Updated recordings
* Updated the screenshots

## Version 0.3.0 (13th Sep 2019)
* Updated the DBFS methods and added convenience
* Testing against R2019b shipping version
* Fixed bug in initialization script to optimize the restart of interactive clusters

## Version 0.2.4 (10th Sep, 2019)
* Renamed the Client object to DBFS and separated the concerns
* Numerous bug fixes - handling of empty responses, etc.

## Version 0.2.3 (9th Sep, 2019)
* Refactored the token related methods and updated the tests

## Version 0.2.2 (6th Sep, 2019)
* Working download method to fetch data / results from DBFS

## Version 0.2.1 (29th Aug, 2019)
* Added demo script for running Tall based API based workflows on the Spark cluster
* Added demo script for running MATLAB Spark API based workflows on the Spark Cluster
* Minor bugfixes

## Version 0.2.0 (20th Aug, 2019)
* Updated minor version number.
* Add features for job email notifications

## Version 0.1.3 (13th Aug, 2019)
* Added features to vectorized creation and deletion of cluster and jobs
* Nominally functional job creation, execution and deletion
* Added more details to log messages
* Updated numerous unit tests and added fixtures

## Version 0.1.2 (16th Jul, 2019)

* Initial release with nominal functionality for DBFS, Token, Cluster and Job creation
 
[//]: #  (Copyright 2019-2026 The MathWorks, Inc.)

