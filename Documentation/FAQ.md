# Frequently Asked Questions (FAQ)

## Long Path support

If using Windows&reg; and parts of the package appear to be "missing", this may be due
to Windows path length limitations. Windows has a maximum path length of 260
(256 usable) characters. This can be increased to 32,767 characters by enabling
long path support.

For more information see: [https://learn.microsoft.com/en-us/windows/win32/fileio/maximum-file-path-limitation?tabs=registry](https://learn.microsoft.com/en-us/windows/win32/fileio/maximum-file-path-limitation?tabs=registry)

Once enabled the partial copy of the package should be deleted and the package
should be reinstalled from the original download file.

## Databricks ARM support

Clusters used to run MATLAB on Databricks&reg; must be x86-64 based. ARM-based clusters
(such as AWS&reg; Graviton-based instances) are not supported. The error message below
indicates an attempt to install MATLAB on an ARM-based cluster:

```text
/tmp/MATLAB_installer/install: 1: exec: /tmp/MATLAB_installer/bin/linux-arm-64/install_unix_legacy: not found
Install of MATLAB runtime failed, returned: 127
```

Apple&reg; silicon ARM based systems are supported as desktop clients.

## Enable MATLAB startup diagnostics

When running MATLAB on Databricks, the startup process is more complex.
I.e. starting the MATLAB Web Proxy and desktop MATLAB from a custom Docker&reg; image.
It can be difficult to determine a point of failure especially if introducing
custom startup code. For example, to install in-house toolboxes prior to the end
user getting access to the MATLAB IDE.

This can be addressed by setting the following environment variables at cluster
creation time:

```bash
MW_DIAGNOSTIC_SPEC' = ".*=fatal,critical,error,warning;connector::worker.*=all;connector::container::http=all;connector::lifecycle=all;connector::http::server=all"

'MW_DIAGNOSTIC_DEST'="file=/tmp/myLog.txt"
```

Once MATLAB has started, or attempted to start, the log file can be retrieved from
the cluster by using a notebook to copy it to a workspace location from which
it can be downloaded via the Databricks UI.

## What Simulink features are supported in MATLAB *on* Databricks

When running the MATLAB/Simulink&reg; desktop environment on Databricks some limitations
apply, e.g. hardware in-the-loop scenarios are not possible as hardware cannot be
directly connected.

The following high-level guidance aimed at MATLAB&reg; Online&trade; is broadly applicable
as the underlying browser based desktop approaches are very similar:
[https://www.mathworks.com/products/matlab-online/limitations.html](https://www.mathworks.com/products/matlab-online/limitations.html)
For clarification on specific use cases contact: <databricks@mathworks.com>.

## Illegal Parquet type: INT64 (TIME_MICROS)

The following error can indicate a current incompatibility between Spark&trade; and `.parquet` files
written by MATLAB, using `parquetwrite()`:

```text
...java.io.IOException: Could not read or convert schema for file: dbfs:/myData/myDurationData.parquet
...
Caused by: org.apache.spark.sql.AnalysisException: Illegal Parquet type: INT64 (TIME_MICROS);
 at org.apache.spark.sql.execution.datasources.parquet.
```

The issue arises if the MATLAB data contains a duration data type. Current workarounds are:

* Write a numeric value e.g. an `int64` as an alternative to represent a number of milliseconds etc.
* Write two datetimes in the parquet, e.g. a start and stop time and compute the difference in Spark.
* Write and import data in another format e.g. `.csv`.

## Did not start the server. Desired port was 31515

This error can be caused by security restriction on the cluster that prevent the MATLAB runtime from opening a given port.

In version of the package > 2.0.2 this should be addressed by the automatic addition of:
`MW_CONNECTOR_CONNECTION_PROFILES="noop"` as a Spark environment variable when the cluster is configured.
However is cluster is started by other means then this value should be set in addition to the MATLAB runtime's required LD_LIBRARY_PATH settings as Spark environment variables.

```text
MatlabRuntimeError: An Error occurred when evaluating the result from a function. Details: Dynamic exception type: std::runtime_error
std::exception::what: Did not start the server. Desired port was 31515. Last error was: Failed to start server: 127.0.0.1:31614
```

## Invalid shard address / Certificate chain validation error

An error similar to the following most simply may indicate an invalid host value being used.

```text
ds = spark.range(10)
15:59:41.804 [main] ERROR com.databricks.service.SparkClientManager - Fail to get the SparkClient
java.util.concurrent.ExecutionException: com.databricks.service.SparkServiceConnectionException: Invalid shard address: "https://adb-1122334455667788.19.azuredatabricks.net"

To connect to a Databricks cluster, you must specify the URL of your Databricks shard.
Shard address: The URL of your shard (e.g., "https://dbc-01234567-89ab.cloud.databricks.com")
  - Get current value: spark.conf.get("spark.databricks.service.address")
  - Set via conf: spark.conf.set("spark.databricks.service.address", <your shard address>)
  - Set via environment variable: export DATABRICKS_ADDRESS=<your shard address>
.
.
.
Caused by: sun.security.provider.certpath.SunCertPathBuilderException: unable to find valid certification path to requested target
                at sun.security.provider.certpath.SunCertPathBuilder.build(SunCertPathBuilder.java:141)
                at sun.security.provider.certpath.SunCertPathBuilder.engineBuild(SunCertPathBuilder.java:126)
                at java.security.cert.CertPathBuilder.build(CertPathBuilder.java:280)
                at sun.security.validator.PKIXValidator.doBuild(PKIXValidator.java:392)
```

To rule this out double check the value used by Databricks Connect in the .databricks-connect file.
Test the REST API connectivity with the same host value e.g. using a basic DBFS call.

```matlab
db = databricks.DBFS;
l = db.ls('/');
```

A more problematic cause can be a failed SSL hand shake in the Databricks Connect
communication between MATLAB and the cluster.
Check the error log for reports similar to:

```text
Caused by: sun.security.validator.ValidatorException: PKIX path building failed: sun.security.provider.certpath.SunCertPathBuilderException: unable to find valid certification path
to requested target
```

This may be caused by a proxy between the MATLAB client and the Databricks cluster
for which MATLAB does not have a trusted certificate chain. This can be addressed
by adding an additional certificate to the MATLAB Java&reg; trust store using the
`keytool` program, which is part of the the Java Runtime Environment (JRE&trade;).

**Warning**: Only trust a certificate that you know to be trustworthy, having
checked with IT security. An invalid SSL handshake may indicate a serious security
issue and trusting a malicious certificate risks exposing data and credentials.

MATLAB JRE's copy of `keytool` by default is stored in:

```text
Linux: /usr/local/MATLAB/R2025b/sys/java/jre/glnxa64/jre/bin
or
Windows: c:\Program Files\MATLAB\R2022a\sys\java\jre\win64\jre\bin
```

From the command line in the JRE directory:

Linux&reg;:

```bash
keytool -importcert -trustcacerts -file newCert.pem \
 -alias myalias1 \
 -keystore ../lib/security/cacerts \
 -storepass changeit

```

Windows:

```bat
keytool.exe -importcert -trustcacerts -file "c:\newCert.cer" -keystore lib\security\cacerts -alias myalias1 -storepass changeit
```

Then restart MATLAB and attempt to create a Spark session and invoke a
Spark API call. Simply creating a Spark session is not sufficient to
verify the fix.

To get more detailed SSL logs create a file call java.opts in a given
directory containing:

```bash
-Djavax.net.debug=ssl:handshake
```

Start MATLAB in that directory to observe increased logging `javax.net.debug`
accepts a number of other options.
See: [https://www.mathworks.com/help/matlab/matlab_env/java-opts-file.html](https://www.mathworks.com/help/matlab/matlab_env/java-opts-file.html)
A large amount of output can be expected, using the `diary on/off` feature
can be helpful to easily capture output to a file, e.g.:

```matlab
diary on
```

## Saving a .mat file to /dbfs fails

Due to a limitation in the FUSE mount used for `/dbfs` certain IO operations
are not possible, see [DBFS](DBFS.md) for more details.
Consider using the [Files](Files.md) API instead of DBFS.

## Spark Submit fails to find jar on dbfs

An Spark submit task failing with the following error could be due to missing
`/dbfs` in the path defined for `inputLocation` and `SparkJar`. The output
location on the other hand does not require `/dbfs`.

This is an error Log for spark-submit task on databricks cluster.
The log clearly states that the `Local jar /example/flightsByCarrierDemo_21a.jar does not exist`.

```text
21/04/09 17:26:37 WARN SparkConf: The configuration key 'spark.akka.frameSize' has been deprecated as of Spark 1.6 and may be removed in the future. Please use the new key 'spark.rpc.message.maxSize' instead.
21/04/09 17:26:39 WARN DependencyUtils: Local jar /example/flightsByCarrierDemo_21a.jar does not exist, skipping.
21/04/09 17:26:39 WARN SparkSubmit$$anon$2: Failed to load com.mathworks.mlspark.mlsubmit.MatlabSubmit.
java.lang.ClassNotFoundException: com.mathworks.mlspark.mlsubmit.MatlabSubmit
  at java.net.URLClassLoader.findClass(URLClassLoader.java:382)
  at java.lang.ClassLoader.loadClass(ClassLoader.java:418)
  at java.lang.ClassLoader.loadClass(ClassLoader.java:351)
  at java.lang.Class.forName0(Native Method)
  at java.lang.Class.forName(Class.java:348)
  at org.apache.spark.util.Utils$.classForName(Utils.scala:257)
  at org.apache.spark.deploy.SparkSubmit.org$apache$spark$deploy$SparkSubmit$$runMain(SparkSubmit.scala:806)
  at org.apache.spark.deploy.SparkSubmit.doRunMain$1(SparkSubmit.scala:161)
  at org.apache.spark.deploy.SparkSubmit.submit(SparkSubmit.scala:184)
  at org.apache.spark.deploy.SparkSubmit.doSubmit(SparkSubmit.scala:86)
  at org.apache.spark.deploy.SparkSubmit$$anon$2.doSubmit(SparkSubmit.scala:920)
  at org.apache.spark.deploy.SparkSubmit$.main(SparkSubmit.scala:929)
  at org.apache.spark.deploy.SparkSubmit.main(SparkSubmit.scala)
21/04/09 17:26:39 INFO ShutdownHookManager: Shutdown hook called
21/04/09 17:26:39 INFO ShutdownHookManager: Deleting directory /local_disk0/tmp/spark-1253f705-6769-41bd-a25e-77114ead1a21
```

If the jar actually exists at `/example` on dbfs, the reason could be
`defining the Job has missing /dbfs in path` while providing
input data location and SparkJar location as follows:

```matlab
% Defining path for input, output and application

inputLocation = "/data/airlinedelay/*.csv";
sparkApp = "/example/flightsByCarrierDemo_21a.jar";
outputLocation = ['/output/output',datestr(now,30)];

% Creating a Job and a Task 
% Assigning the above paths before running a Spark Submit Job on a new cluster
job = databricks.Job;
job.setCluster(cl); % given cl is a valid cluster definition

task.Application = sparkApp;
task.Arguments = [task.MCRROOT,...
    inputLocation,...
    outputLocation];

job.setTask(task);
job.create();
job.runNow();
```

The above translates to the following `spark-submit` task:

```text
Task: spark-submit
Arguments: ["--class","com.mathworks.mlspark.mlsubmit.MatlabSubmit","--driver-library-path","/usr/local/MATLAB/MATLAB_Runtime/v910/runtime/glnxa64:/usr/local/MATLAB/MATLAB_Runtime/v910/bin/glnxa64:/usr/local/MATLAB/MATLAB_Runtime/v910/sys/os/glnxa64:/usr/local/MATLAB/MATLAB_Runtime/v910/extern/bin/glnxa64","--jars","/usr/local/MATLAB/MATLAB_Runtime/v910/toolbox/mlhadoop/jar/a2.2.0/mwmapreduce.jar,/usr/local/MATLAB/MATLAB_Runtime/v910/toolbox/shared/bigdata/jar/hadoop.2.jar,/usr/local/MATLAB/MATLAB_Runtime/v910/toolbox/compiler/mlspark/jars/2.x/mlspark.jar,","/example/flightsByCarrierDemo_21a.jar","/usr/local/MATLAB/MATLAB_Runtime/v910","/data/airlinedelay/*.csv","/output/output20210409T131006"]
```

The solution in this case would be to change the path to inputLocation and SparkJar as follows:

```matlab
inputLocation = "/dbfs/data/airlinedelay/*.csv";
sparkApp = "/dbfs/example/flightsByCarrierDemo_21a.jar";
```

## Checking if the MATLAB Runtime is configured on a cluster

If the MATLAB Runtime is configured on a given cluster then the LD_LIBRARY_PATH should
be configured to point to it. This is easily checked by starting a notebook and typing
the following shell command, note the use of the leading *%* to pass the command to a
shell:

```bash
%sh env | grep -i MATLAB

LD_LIBRARY_PATH=/MATLAB_Runtime/runtime/glnxa64:/MATLAB_Runtime/bin/glnxa64:/MATLAB_Runtime/sys/os/glnxa64:/MATLAB_Runtime/extern/bin/glnxa64
```

(Paths will differ slightly in versions prior to v5.0.0)

The result returns the LD_LIBRARY_PATH variable, To verify that the corresponding
files exist the following command can be used, again in a notebook, taking the path
from the LD_LIBRARY_PATH. In this case R2024a is configured.

```xml
%sh cat /MATLAB_Runtime/VersionInfo.xml

<?xml version="1.0" encoding="UTF-8"?>
<!-- Version information for MathWorks R2024a Release -->
<MathWorks_version_info>
  <version>24.1.0.2603908</version>
  <release>R2024a</release>
  <description>Update 3</description>
  <date>May 02 2024</date>
  <checksum>803194358</checksum>
</MathWorks_version_info>
```

This indicates the runtime is installed and gives some detailed release information.

## Cluster startup fails with java.lang.NoClassDefFoundError

> In release 5.0.0 and greater, while the error may still be indicative of a similar problem,
> `runtimes.json` is no longer used, see [InstallingMATLABRuntime.md](InstallingMATLABRuntime.md)

If cluster startup fails with java.lang.NoClassDefFoundError:com/mathworks/toolbox/javabuilder/MWApplication
this error denotes that the MATLAB Runtime was not installed on an on-demand cluster.
Make sure that /databricks-v0.4.9/Software/MATLAB/config/runtimes.json includes the correct block for your MATLAB version and that the runtime used is the *Linux* version, one that ends with _glnxa64.zip.

In addition, include the following call in your cluster setup to ensure that the MATLAB Runtime is enabled on the cluster nodes.

```matlab
cl.enableMATLABRuntime('enableInitLogging', true, ...
                       'enableRuntimeInstall', true);
```

## Basic connectivity test

A simple test for basic connectivity using only curl is as follows:

```bash
curl --location --request GET "https://<REDACTED ENDPOINT>.azuredatabricks.net/api/2.0/clusters/list" --header "Authorization: Bearer dap<REDACTED TOKEN>573"
```

The JSON response will include details of clusters. If this request does not succeed then it is unlikely that REST API requests from within MATLAB will succeed and underlying connectivity issues should be considered.

## Getting an Exception in thread "main" java.lang.NoSuchMethodError

If an Exception in thread "main"
`java.lang.NoSuchMethodError: scala.Predef$.refArrayOps` arises.
This means that the version of Scala&reg; requested on the on-demand cluster is too
new for the MATLAB Spark implementation.
The error is caused by Scala 2.12 being installed where the requested method
was deprecated on Scala versions newer than 2.11.
Solution: request a cluster with Scala version 2.11.

## What version of DB Connect should I use?

Databricks advises that the version of Databricks Connect used should match the version of the Databricks used on the cluster in question.

## Jars do not exist

The following error indicates that the ```runtime_install.sh``` script has not be executed when a node(s) were initialized.

```text
20/04/21 17:48:34 WARN SparkConf: The configuration key 'spark.akka.frameSize' has been deprecated as of Spark 1.6 and may be removed in the future. Please use the new key 'spark.rpc.message.maxSize' instead.
20/04/21 17:48:36 WARN DependencyUtils: Local jar /usr/local/MATLAB/MATLAB_Runtime/v97/toolbox/mlhadoop/jar/a2.2.0/mwmapreduce.jar does not exist, skipping.
20/04/21 17:48:36 WARN DependencyUtils: Local jar /usr/local/MATLAB/MATLAB_Runtime/v97/toolbox/shared/bigdata/jar/hadoop.2.jar does not exist, skipping.
20/04/21 17:48:36 WARN DependencyUtils: Local jar /usr/local/MATLAB/MATLAB_Runtime/v97/toolbox/compiler/mlspark/jars/2.x/mlspark.jar does not exist, skipping.
20/04/21 17:48:36 WARN SparkSubmit$$anon$2: Failed to load com.mathworks.mlspark.mlsubmit.MatlabSubmit.
java.lang.ClassNotFoundException: com.mathworks.mlspark.mlsubmit.MatlabSubmit
                at java.net.URLClassLoader.findClass(URLClassLoader.java:382)
                at java.lang.ClassLoader.loadClass(ClassLoader.java:418)
                at java.lang.ClassLoader.loadClass(ClassLoader.java:351)
                at java.lang.Class.forName0(Native Method)
                at java.lang.Class.forName(Class.java:348)
                at org.apache.spark.util.Utils$.classForName(Utils.scala:257)
                at org.apache.spark.deploy.SparkSubmit.org$apache$spark$deploy$SparkSubmit$$runMain(SparkSubmit.scala:806)
                at org.apache.spark.deploy.SparkSubmit.doRunMain$1(SparkSubmit.scala:161)
                at org.apache.spark.deploy.SparkSubmit.submit(SparkSubmit.scala:184)
                at org.apache.spark.deploy.SparkSubmit.doSubmit(SparkSubmit.scala:86)
                at org.apache.spark.deploy.SparkSubmit$$anon$2.doSubmit(SparkSubmit.scala:920)
                at org.apache.spark.deploy.SparkSubmit$.main(SparkSubmit.scala:929)
                at org.apache.spark.deploy.SparkSubmit.main(SparkSubmit.scala)
20/04/21 17:48:36 INFO ShutdownHookManager: Shutdown hook called
20/04/21 17:48:36 INFO ShutdownHookManager: Deleting directory /local_disk0/tmp/spark-3cf75386-147b-4989-a776-58c3f9e416dc
```

## Spark reports a bind exception

The error looks like:

```text
Error using matlab.compiler.mlspark.SparkSession (line 62)
    Java exception occurred:
    java.net.BindException: Cannot assign requested address: bind: Service
    'sparkDriver' failed after 16 retries (on a random free port)! Consider
    explicitly setting the appropriate binding address for the service
    'sparkDriver' (for example spark.driver.bindAddress for SparkDriver) to the
    correct binding address.
        at sun.nio.ch.Net.bind0(Native Method)
        at sun.nio.ch.Net.bind(Net.java:433)
        at sun.nio.ch.Net.bind(Net.java:425)
        at sun.nio.ch.ServerSocketChannelImpl.bind(ServerSocketChannelImpl.java:223)
        at io.netty.channel.socket.nio.NioServerSocketChannel.doBind(NioServerSocketChannel.java:132)
        at io.netty.channel.AbstractChannel$AbstractUnsafe.bind(AbstractChannel.java:551)
        at io.netty.channel.DefaultChannelPipeline$HeadContext.bind(DefaultChannelPipeline.java:1346)
        at io.netty.channel.AbstractChannelHandlerContext.invokeBind(AbstractChannelHandlerContext.java:503)
        at io.netty.channel.AbstractChannelHandlerContext.bind(AbstractChannelHandlerContext.java:488)
        at io.netty.channel.DefaultChannelPipeline.bind(DefaultChannelPipeline.java:985)
        at io.netty.channel.AbstractChannel.bind(AbstractChannel.java:247)
        at io.netty.bootstrap.AbstractBootstrap$2.run(AbstractBootstrap.java:344)
        at io.netty.util.concurrent.AbstractEventExecutor.safeExecute(AbstractEventExecutor.java:163)
        at io.netty.util.concurrent.SingleThreadEventExecutor.runAllTasks(SingleThreadEventExecutor.java:510)
        at io.netty.channel.nio.NioEventLoop.run(NioEventLoop.java:518)
        at io.netty.util.concurrent.SingleThreadEventExecutor$6.run(SingleThreadEventExecutor.java:1044)
        at io.netty.util.internal.ThreadExecutorMap$2.run(ThreadExecutorMap.java:74)
        at io.netty.util.concurrent.FastThreadLocalRunnable.run(FastThreadLocalRunnable.java:30)
        at java.lang.Thread.run(Thread.java:748)
```

This is usually caused due to a change in the computer's network configuration
typically due to a VPN connection or similar changes. The simplest way to fix
this is to restart MATLAB.

## What is DBC format?

A Databricks archive is a JAR file with additional metadata and .dbc extension. It is used to exchange notebooks and can be imported and exported See:

* [Workspaces API](WorkspacesAPI.md)
* [https://docs.databricks.com/notebooks/notebooks-manage.html#databricks-archive](https://docs.databricks.com/notebooks/notebooks-manage.html#databricks-archive)

## Deployed Simulink simulation fails to run with error referring `libmwdastudio.so`

(Not applicable from v5.0.0)

Deployed Simulink R2022a models may fail to run with Databricks Runtime 10.4-LTS throwing a long error stack including:

```text
matlab_pysdk.runtime.MatlabRuntimeError: An error occurred when evaluating the result from a function. Details: Failed to load bundle #198: /usr/local/MATLAB/MATLAB_Runtime/v912/bin/glnxa64/libmwdastudio.so
```

This error is caused by a missing native library (libnss3). This issue is fixed in an updated `runtime_install.sh.template` in release 0.6.16. This init scripts should automatically get updated when installing the new package version, see [upgrading](Upgrade.md#init-scripts).

If a quick fix is needed and upgrading the entire package is not directly possible, `Software/MATLAB/script/runtime_install.sh.template` can be updated manually. Find the line:

```bash
apt-get -q install -y libgbm1
```

and update it to:

```bash
apt-get -q install -y libgbm1 libnss3
```

then use [`matlab.utils.generateInitScript`](InitScripts.md#manual-init-script-configuration) to (re)generate the shell script. Finally, upload the new script to Databricks and (re)start the cluster.

## Deployed Simulink simulation fails to run with "/lib/x86_64-linux-gnu/libc.so.6: version `GLIBC_2.34' not found"

Deployed Simulink models may fail to run throwing a long error stack including:

```text
Error occurred while simulating the model 'mymodel' in rapid accelerator mode. Rerun the simulation in normal mode to diagnose this error. /root/.mcrCache9.12/mypack0/mymodel/slprj/raccel_deploy/mymodel/mymodel: /lib/x86_64-linux-gnu/libc.so.6: version `GLIBC_2.34' not found (required by /root/.mcrCache9.12/mypack0/mymodel/slprj/raccel_deploy/mymodel/mymodel)
```

The exact version mentioned in the error `GLIBC_2.34` may differ, e.g. `GLIBC_2.35` could be seen as well.

This error occurs if the native model binary was built on a system with a newer `glibc` library version than in the runtime image, making it incompatible Databricks runtime images. Rebuild the package on an older Linux system which is compatible with the operating system used in the Databricks runtime image that is used. Typically the best option is to use the same OS distribution and version as used by the Databricks runtime which is used. Check the [Databricks runtime releases](https://docs.databricks.com/release-notes/runtime/releases.html) documentation to see which exact base OS is used by the different Databricks runtime versions.

## Name change SQL Endpoints to SQL Warehouses

Databricks has [changed the name from SQL endpoints to SQL warehouses](https://docs.databricks.com/sql/admin/sql-endpoints.html#sql-endpoints-name-changed-to-sql-warehouses). Due to this change the class names in the MATLAB package have changed as well and code making use of the old class names must be updated:

| Old class name                              | New class name                               |
|---------------------------------------------|----------------------------------------------|
| `databricks.SQLEndpoint`                    | `databricks.SQLWarehouse`                    |
| `databricks.datastructures.EndpointHealth`  | `databricks.datastructures.WarehouseHealth`  |
| `databricks.datastructures.EndpointTagPair` | `databricks.datastructures.WarehouseTagPair` |
| `databricks.datastructures.EndpointTags`    | `databricks.datastructures.WarehouseTags`    |
| `databricks.datastructures.EnpointSpotInstancePolicy` | `databricks.datastructures.WarehousepotInstancePolicy` |
| `databricks.datastructures.EndpointState`   | `databricks.datastructures.WarehouseState`   |
| `databricks.datastructures.EndpointStatus`  | `databricks.datastructures.WarehouseStatus`  |

## Error Creating directory /Users/defaultname@example.com/MathWorks

During a cluster based installed the following error can arise:

```text
Importing notebooks to perform cluster based tasks:
Creating directory: /Users/defaultname@example.com/MathWorks
Error using matlab.databricks.internal.responseError
Failed to create directory: /Users/defaultname@example.com/MathWorks  error_code: DIRECTORY_PROTECTED  message: Folder Users is protected
```

This indicates that Databricks is preventing the creation of a directory and notebook for the user "defaultname@example.com".
This reflects a missed configuration step for the `databricks-settings.json` file, whereby the default username and probably notification email address have not been updated. For further details see [Setup.md](Setup.md).
The path to the file is returned by: `fullfile(prefdir, 'databricks-settings.json')`. If the file is not present a template version can be found in: `/Software/MATLAB/config/databricks-settings.json.template`.

## Base64 encoding/decoding mex files

Where possible platform specific mex files are used to improve the performance of base64 encoding and decoding. This is used heavily in DBFS upload and download operations.
Security measures intended to prevent the execution of unsigned binaries, e.g. macOS&reg; Gatekeeper, can prevent the execution of mex files.
If there is an issue executing the mex files the preference set at install time can be controlled using the following commands after running the `startup` command:

```matlab
% Use optimized mex file
matlab.net.base64('setconfig', 'mex')

% Use MATLAB's standard base64 support
matlab.net.base64('setconfig', 'shipping')
```

*Note:* Restart MATLAB to allow a change to take effect.

The current mode can be returned using:

```matlab
matlab.net.base64('getconfig')
```

The startup command will report the current mode as `DBFS transfer mode: Optimized` or `DBFS transfer mode: Standard`.
For example, `shipping` mode can be used while an issue with mex execution is investigated.

## Problem when build a wheel file on a network drive

Occasionally an issue may be seen when building a wheel file on a network drive.

```text
Error using compiler.build.spark.PythonSparkBuilder/createWheel (line 42)
Error building .whl file: * Getting build dependencies for wheel...
running egg_info
creating demo_nyc_164.egg-info
writing demo_nyc_164.egg-info\PKG-INFO
   ... Many error lines

error: [WinError 145] The directory is not empty: 'build\\bdist.win-amd64\\wheel\\.\\demo_nyc_164-26.2.0-py3.12.egg-info'

ERROR Backend subprocess exited when trying to invoke build_wheel 
```

A workaround is to try the build on a local disk instead, by setting the `OutputDir`
argument for `compiler.build.PythonPackageOptions` to a local directory as follows:

```matlab
opts = compiler.build.PythonPackageOptions(...
    ["foo.m", "baz.m"], ...
    OutputDir="C:\Temp\_build", ...
    PackageName="foo.bar");
```

The problem relates to the underlying Python&reg; command that packages the resulting
wheel file and is being investigated.


[//]: #  (Copyright 2020-2026 The MathWorks, Inc.)
