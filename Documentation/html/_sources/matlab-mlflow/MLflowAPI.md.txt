# MATLAB Interface *for MLflow* - API Reference

Classes, methods and functions that include the terms `private` or `internal` in their namespace should not be used directly.
They are subject to change or removal without notice.
The subpackages in the `Modules` directory contain their own `Documentation` directories including API references.

## Index

* MATLAB Interface *for MLflow*
  * [mlflow](#mlflow)
    * [mlflow.Artifact](#mlflowartifact)
      * [mlflow.Artifact.Artifact](#mlflowartifactartifact)
      * [mlflow.Artifact.list](#mlflowartifactlist)
    * [mlflow.Experiment](#mlflowexperiment)
      * [mlflow.Experiment.Experiment](#mlflowexperimentexperiment)
      * [mlflow.Experiment.create](#mlflowexperimentcreate)
      * [mlflow.Experiment.createRun](#mlflowexperimentcreaterun)
      * [mlflow.Experiment.getByName](#mlflowexperimentgetbyname)
      * [mlflow.Experiment.getPayload](#mlflowexperimentgetpayload)
      * [mlflow.Experiment.initFromStruct](#mlflowexperimentinitfromstruct)
      * [mlflow.Experiment.initFromStructInternal](#mlflowexperimentinitfromstructinternal)
      * [mlflow.Experiment.list](#mlflowexperimentlist)
      * [mlflow.Experiment.refresh](#mlflowexperimentrefresh)
      * [mlflow.Experiment.remove](#mlflowexperimentremove)
      * [mlflow.Experiment.restore](#mlflowexperimentrestore)
      * [mlflow.Experiment.setExperimentTag](#mlflowexperimentsetexperimenttag)
      * [mlflow.Experiment.update](#mlflowexperimentupdate)
    * [mlflow.ExperimentTag](#mlflowexperimenttag)
      * [mlflow.ExperimentTag.ExperimentTag](#mlflowexperimenttagexperimenttag)
    * [mlflow.FileInfo](#mlflowfileinfo)
      * [mlflow.FileInfo.FileInfo](#mlflowfileinfofileinfo)
      * [mlflow.FileInfo.fromJSON](#mlflowfileinfofromjson)
    * [mlflow.KeyValue](#mlflowkeyvalue)
      * [mlflow.KeyValue.KeyValue](#mlflowkeyvaluekeyvalue)
      * [mlflow.KeyValue.toStruct](#mlflowkeyvaluetostruct)
      * [mlflow.KeyValue.toTable](#mlflowkeyvaluetotable)
    * [mlflow.Metric](#mlflowmetric)
      * [mlflow.Metric.Metric](#mlflowmetricmetric)
      * [mlflow.Metric.initFromStruct](#mlflowmetricinitfromstruct)
      * [mlflow.Metric.toStruct](#mlflowmetrictostruct)
      * [mlflow.Metric.toTable](#mlflowmetrictotable)
    * [mlflow.ModelVersion](#mlflowmodelversion)
      * [mlflow.ModelVersion.ModelVersion](#mlflowmodelversionmodelversion)
      * [mlflow.ModelVersion.create](#mlflowmodelversioncreate)
      * [mlflow.ModelVersion.deleteTag](#mlflowmodelversiondeletetag)
      * [mlflow.ModelVersion.get](#mlflowmodelversionget)
      * [mlflow.ModelVersion.getDownloadUri](#mlflowmodelversiongetdownloaduri)
      * [mlflow.ModelVersion.getPayload](#mlflowmodelversiongetpayload)
      * [mlflow.ModelVersion.initFromStruct](#mlflowmodelversioninitfromstruct)
      * [mlflow.ModelVersion.initFromStructInternal](#mlflowmodelversioninitfromstructinternal)
      * [mlflow.ModelVersion.setTag](#mlflowmodelversionsettag)
    * [mlflow.ModelVersionStatus](#mlflowmodelversionstatus)
      * [mlflow.ModelVersionStatus.ModelVersionStatus](#mlflowmodelversionstatusmodelversionstatus)
    * [mlflow.ModelVersionTag](#mlflowmodelversiontag)
      * [mlflow.ModelVersionTag.ModelVersionTag](#mlflowmodelversiontagmodelversiontag)
    * [mlflow.Object](#mlflowobject)
      * [mlflow.Object.Object](#mlflowobjectobject)
      * [mlflow.Object.addStructureAsDynProps](#mlflowobjectaddstructureasdynprops)
      * [mlflow.Object.getAuth](#mlflowobjectgetauth)
      * [mlflow.Object.getAuthorizationField](#mlflowobjectgetauthorizationfield)
      * [mlflow.Object.getConfig](#mlflowobjectgetconfig)
      * [mlflow.Object.getConfigFromEnvVars](#mlflowobjectgetconfigfromenvvars)
      * [mlflow.Object.getRequestMessage](#mlflowobjectgetrequestmessage)
      * [mlflow.Object.getURI](#mlflowobjectgeturi)
      * [mlflow.Object.iSanitizeHost](#mlflowobjectisanitizehost)
      * [mlflow.Object.isDatabricks](#mlflowobjectisdatabricks)
      * [mlflow.Object.isPreview](#mlflowobjectispreview)
    * [mlflow.Param](#mlflowparam)
      * [mlflow.Param.Param](#mlflowparamparam)
    * [mlflow.RegisteredModel](#mlflowregisteredmodel)
      * [mlflow.RegisteredModel.RegisteredModel](#mlflowregisteredmodelregisteredmodel)
      * [mlflow.RegisteredModel.create](#mlflowregisteredmodelcreate)
      * [mlflow.RegisteredModel.get](#mlflowregisteredmodelget)
      * [mlflow.RegisteredModel.getLatestVersions](#mlflowregisteredmodelgetlatestversions)
      * [mlflow.RegisteredModel.getPayload](#mlflowregisteredmodelgetpayload)
      * [mlflow.RegisteredModel.initFromStructInternal](#mlflowregisteredmodelinitfromstructinternal)
      * [mlflow.RegisteredModel.list](#mlflowregisteredmodellist)
      * [mlflow.RegisteredModel.remove](#mlflowregisteredmodelremove)
      * [mlflow.RegisteredModel.rename](#mlflowregisteredmodelrename)
      * [mlflow.RegisteredModel.search](#mlflowregisteredmodelsearch)
      * [mlflow.RegisteredModel.setTag](#mlflowregisteredmodelsettag)
      * [mlflow.RegisteredModel.update](#mlflowregisteredmodelupdate)
    * [mlflow.RegisteredModelTag](#mlflowregisteredmodeltag)
      * [mlflow.RegisteredModelTag.RegisteredModelTag](#mlflowregisteredmodeltagregisteredmodeltag)
    * [mlflow.Run](#mlflowrun)
      * [mlflow.Run.Run](#mlflowrunrun)
      * [mlflow.Run.create](#mlflowruncreate)
      * [mlflow.Run.deleteTag](#mlflowrundeletetag)
      * [mlflow.Run.getHistory](#mlflowrungethistory)
      * [mlflow.Run.getPayload](#mlflowrungetpayload)
      * [mlflow.Run.logMetric](#mlflowrunlogmetric)
      * [mlflow.Run.logParameter](#mlflowrunlogparameter)
      * [mlflow.Run.refresh](#mlflowrunrefresh)
      * [mlflow.Run.remove](#mlflowrunremove)
      * [mlflow.Run.restore](#mlflowrunrestore)
      * [mlflow.Run.search](#mlflowrunsearch)
      * [mlflow.Run.setTag](#mlflowrunsettag)
      * [mlflow.Run.update](#mlflowrunupdate)
    * [mlflow.RunData](#mlflowrundata)
      * [mlflow.RunData.RunData](#mlflowrundatarundata)
      * [mlflow.RunData.addMetrics](#mlflowrundataaddmetrics)
      * [mlflow.RunData.addParams](#mlflowrundataaddparams)
      * [mlflow.RunData.addTags](#mlflowrundataaddtags)
    * [mlflow.RunInfo](#mlflowruninfo)
      * [mlflow.RunInfo.RunInfo](#mlflowruninforuninfo)
    * [mlflow.RunStatus](#mlflowrunstatus)
      * [mlflow.RunStatus.RunStatus](#mlflowrunstatusrunstatus)
    * [mlflow.RunTag](#mlflowruntag)
      * [mlflow.RunTag.RunTag](#mlflowruntagruntag)
    * [mlflow.ViewType](#mlflowviewtype)
      * [mlflow.ViewType.ViewType](#mlflowviewtypeviewtype)
    * [mlflow.cli](#mlflowcli)
    * [mlflow.getConfigFile](#mlflowgetconfigfile)
    * [mlflow.jsondecode](#mlflowjsondecode)
  * [Logger](#logger)
  * [getCurrentTimeUnixINT64](#getcurrenttimeunixint64)
  * [getHTTPOptions](#gethttpoptions)
  * [getJsonValue](#getjsonvalue)
  * [jsondecodeTypedValues](#jsondecodetypedvalues)
  * [mlflowPackageVersion](#mlflowpackageversion)
  * [mlflowRoot](#mlflowroot)

## Help

### mlflow

### mlflow.Artifact

Superclass: mlflow.Object

```text
ARTIFACT MLflow Artifact object
  MLFlow artifacts are run output files in any format, e.g images, models or 
  other data files.
 
  An artifact can be logged using the mlflow cli as follows:
   mlflow artifacts log-artifact --local-file myArtifact.mat  --run-id 45b57414530c4100bbebb2b36dd2a1ee --artifact-path myPathPrefix
```

#### mlflow.Artifact.Artifact

```text
ARTIFACT MLflow Artifact object
  MLFlow artifacts are run output files in any format, e.g images, models or 
  other data files.
 
  An artifact can be logged using the mlflow cli as follows:
   mlflow artifacts log-artifact --local-file myArtifact.mat  --run-id 45b57414530c4100bbebb2b36dd2a1ee --artifact-path myPathPrefix
```

#### mlflow.Artifact.list

```text
LIST List artifacts for a run
  If no arguments are provided the run_id, path and page_token are taken
  from the object otherwise the required run_id is taken as the first
  argument and the path and page_token arguments are optionally provided
  as name value pairs.
  A path value is used to return only artifacts with the specified prefix.
  This can be used to provide for directory hierarchy.
  All arguments must be provided as character vectors or scalar strings.
  If there are no results an empty double is returned.
  Results are returned as a structure containing the root_uri and an array of
  mlflow.FileInfo objects.
  If there is no files matching the query there will be no files field.
  If a FileInfo object corresponds to a directory the is_dir field value will be
  true and the file_size will be 0.
 
  Example:
    % Return a list of artifacts for run myRun, overriding and id set in myArtifact
    resultsList = myArtifact.list(myRun.run_id)
    resultsList =
      struct with fields:
        root_uri: 'dbfs:/artifactDirectory/45b57414530c4100bbebb2b36dd2a1ee/artifacts'
           files: [1x2 mlflow.FileInfo]
 
 
     % Use a pth prefix to list subdirectory contents
     resultsList = myArtifact.list(myRun.run_id, 'path', 'prefixDir')
     resultsList =
       struct with fields:
         root_uri: 'dbfs:/artifactDirectory/45b57414530c4100bbebb2b36dd2a1ee/artifacts'
            files: [1x1 mlflow.FileInfo]
 
     resultsList.files(1)
     ans =
       FileInfo with properties:
              path: "prefixDir/myFile.txt"
            is_dir: 0
         file_size: 128
```

### mlflow.Experiment

Superclass: mlflow.Object

```text
EXPERIMENT MLflow Experiment
  This object allows users to create, delete, list, update, restore and
  query experiments.
```

#### mlflow.Experiment.Experiment

```text
EXPERIMENT MLflow Experiment
  This object allows users to create, delete, list, update, restore and
  query experiments.
```

#### mlflow.Experiment.create

```text
CREATE Method to create an experiment with a name
  Returns the ID of the newly created experiment. Validates that another
  experiment with the same name does not already exist and fails if another
  experiment with the same name already exists.
 
  An experiment name must be an absolute path within the MLFlow
  workspace, for example:
 
  '/Users/<some-username>/my-experiment'.
 
  For more information on how to use this method when using Databricks,
  Please see:
  [1] https://docs.databricks.com/applications/mlflow/experiments.html#experiment-migration
  [2] https://mlflow.org/docs/latest/rest-api.html#create-experiment
```

#### mlflow.Experiment.createRun

```text
CREATERUN Method to create a run
```

#### mlflow.Experiment.getByName

```text
GETBYNAME Method to get the metadata for an experiment by name
  This endpoint will return deleted experiments, but prefers the active 
  experiment if an active and deleted experiment share the same name. If 
  multiple deleted experiments share the same name, the API will return 
  one of them.
  
  Example:
  
    mle = mlflow.Experiment.getByName('/Users/joe@example.com/test-experiment');
  
  This will throw a RESOURCE_DOES_NOT_EXIST error if no experiment with the 
  specified name exists.
```

#### mlflow.Experiment.getPayload

```text
GETPAYLOAD Internal method to create the request payload by removing properties
```

#### mlflow.Experiment.initFromStruct

```text
initFromStruct Create experiment from structure
```

#### mlflow.Experiment.initFromStructInternal

```text
initFromStructInternal Create experiment from structure
```

#### mlflow.Experiment.list

```text
LIST Method to list existing experiments
  An optional argument allows users to list only active, deleted or all
  (default) experiments.
 
  Example:
 
    mle = mlflow.Experiment('all');
    mle = mlflow.Experiment('active_only');
    mle = mlflow.Experiment('deleted_only');
```

#### mlflow.Experiment.refresh

```text
REFRESH Method to get metadata for an experiment
  Fetch metadata about an experiment. This method also works on
  deleted experiments.
```

#### mlflow.Experiment.remove

```text
REMOVE Method to delete an experiment
  Delete an experiment from the MLFlow tracking server. 
  
    mle = mlflow.Experiment;
    mle.create();  % Creates an experiment
    mle.remove();  % Deletes an experiment
```

#### mlflow.Experiment.restore

```text
RESTORE Method to restore an experiment marked for deletion 
  This restores associated metadata, runs, metrics, params, and tags. If 
  experiment uses FileStore, underlying artifacts associated with 
  experiment are also restored.
```

#### mlflow.Experiment.setExperimentTag

```text
SETEXPERIMENTTAG Method to set a tag on an experiment
  Experiment metadata can be attached to an experiment using this method.
 
  Example:
    mle = mlflow.Experiment;
    mle.setExperimentTag('key','value');
```

#### mlflow.Experiment.update

```text
UPDATE Method to update experiment metadata
  
  This method can be used to update the name of an experiment. 
 
  Example:
  
    mle = mlflow.Experiment.list;
    experimentHandle = mle(1);
    experimentHandle.update('/Users/username@example.com/myNewExperiment')
```

### mlflow.ExperimentTag

Superclass: mlflow.KeyValue

```text
ExperimentTag Container for holding the tags for an experiment
  Create a tag to apply to an experiment. The inputs to this can be a cell array of
  key value pairs.
 
  This class is normally not instantiated explicitly, but is a result
  of creating an Experiment object (cf. mlflow.Experiment/setTag)
 
  Example:
 
    tt1 = mlflow.ExperimentTag('mykey','myvalue');
 
  See also mlflow.Experiment/setTag
```

#### mlflow.ExperimentTag.ExperimentTag

```text
ExperimentTag Container for holding the tags for an experiment
  Create a tag to apply to an experiment. The inputs to this can be a cell array of
  key value pairs.
 
  This class is normally not instantiated explicitly, but is a result
  of creating an Experiment object (cf. mlflow.Experiment/setTag)
 
  Example:
 
    tt1 = mlflow.ExperimentTag('mykey','myvalue');
 
  See also mlflow.Experiment/setTag
```

### mlflow.FileInfo

```text
FILEINFO Metadata of a single artifact file or directory
  For directory entries file_size is an empty value.
  File sizes are stored as int64s.
 
  Example:
 
    fi1 = mlflow.FileInfo('path', false, int64(1234));
 
    paths = {'myArtifact1', 'myDirectory', 'myArtifact2'};
    dirTFs = {false, true, false};
    sizes = {int64(1234), [], int64(5678)}
    fi2 = mlflow.FileInfo(paths, dirTFs, sizes);
```

#### mlflow.FileInfo.FileInfo

```text
FILEINFO Metadata of a single artifact file or directory
  For directory entries file_size is an empty value.
  File sizes are stored as int64s.
 
  Example:
 
    fi1 = mlflow.FileInfo('path', false, int64(1234));
 
    paths = {'myArtifact1', 'myDirectory', 'myArtifact2'};
    dirTFs = {false, true, false};
    sizes = {int64(1234), [], int64(5678)}
    fi2 = mlflow.FileInfo(paths, dirTFs, sizes);
```

#### mlflow.FileInfo.fromJSON

```text
Decode the data from JSON assumes int64 file_size values have not been truncated
  by a previous default MATLAB conversion
```

### mlflow.KeyValue

Superclass: handle

```text
KeyValue Base class for Tag and Param classes
```

#### mlflow.KeyValue.KeyValue

```text
KeyValue Base class for Tag and Param classes
```

#### mlflow.KeyValue.toStruct

```text
mlflow.KeyValue/toStruct is a function.
    S = toStruct(obj)
```

#### mlflow.KeyValue.toTable

```text
mlflow.KeyValue/toTable is a function.
    T = toTable(obj)
```

### mlflow.Metric

Superclass: handle

```text
METRIC Class definition to store MLFLow metrics
  Metrics for use with the mlflow API.
 
  Example:
    % Create a metric
    metric = mlflow.Metric;
    metric.key = 'TrainingLoss';
    metric.value = 1e-6;
    metric.timestamp = getCurrentTimeUnixINT64();
    metric.step = 100;
```

#### mlflow.Metric.Metric

```text
METRIC Class definition to store MLFLow metrics
  Metrics for use with the mlflow API.
 
  Example:
    % Create a metric
    metric = mlflow.Metric;
    metric.key = 'TrainingLoss';
    metric.value = 1e-6;
    metric.timestamp = getCurrentTimeUnixINT64();
    metric.step = 100;
```

#### mlflow.Metric.initFromStruct

```text
mlflow.Metric/initFromStruct is a function.
    initFromStruct(obj, data)
```

#### mlflow.Metric.toStruct

```text
mlflow.Metric/toStruct is a function.
    S = toStruct(obj)
```

#### mlflow.Metric.toTable

```text
mlflow.Metric/toTable is a function.
    T = toTable(obj)
```

### mlflow.ModelVersion

Superclass: mlflow.Object

```text
MODELVERSION MLflow Model Version
```

#### mlflow.ModelVersion.ModelVersion

```text
MODELVERSION MLflow Model Version
```

#### mlflow.ModelVersion.create

```text
CREATE Method to create a model version
 
  A mlflow.ModelVersion object is returned. It is the new version number
  generated for this model in registry.
 
  Example:
 
    mv = mlflow.ModelVersion;
    result = mv.create();
```

#### mlflow.ModelVersion.deleteTag

```text
DELETETAG Delete a tag on a model version
 
  name must be provided as a scalar string or character vector, it represents
  name of the registered model that the tag was logged under.
 
  version must be provided as a scalar string or character vector, it represents
  the model version number that the tag was logged under.
 
  key must be provided as a scalar string or character vector. It is the name of
  the tag. The name must be an exact match; wild-card deletion is not supported.
  Maximum size is 250 bytes.
```

#### mlflow.ModelVersion.get

```text
GET Get a specified model version
 
  name must be provided as a scalar string or character vector. It is the name of
  the registered model.
 
  version must be provided as a scalar string or character vector. It is the model
  version number.
```

#### mlflow.ModelVersion.getDownloadUri

```text
GETDOWNLOADURI Get Download URI For ModelVersion Artifacts
 
  name must be provided as a scalar string or character vector. It is the name of
  the registered model.
 
  version must be provided as a scalar string or character vector. It is the model
  version number.
 
  The download uri to be returned as a character vector.
```

#### mlflow.ModelVersion.getPayload

```text
GETPAYLOAD Internal method to create the request payload by removing properties
```

#### mlflow.ModelVersion.initFromStruct

```text
initFromStruct Create ModelVersion from structure
```

#### mlflow.ModelVersion.initFromStructInternal

```text
initFromStructInternal Create object from structure
```

#### mlflow.ModelVersion.setTag

```text
SETTAG Set a Model Version tag
 
  name must be provided as a scalar string or character vector, it represents
  the unique name of the model.
 
  version must be provided as a scalar string or character vector, it represents
  the model version number.
 
  key must be provided as a scalar string or character vector, it represents
  the name of the tag. Maximum size depends on storage backend. If a tag with
  this name already exists, its preexisting value will be replaced by the
  specified value. All storage backends are guaranteed to support key values up
  to 250 bytes in size.
 
  value must be provided as a scalar string or character vector, it represents
  the string value of the tag being logged. Maximum size depends on storage
  backend. All storage backends are guaranteed to support key values up to 5000
  bytes in size.
```

### mlflow.ModelVersionStatus

```text
MODELVERSIONSTATUS Status of a Model Version registration
  Possible values:
    PENDING_REGISTRATION  Request to register a new model version is pending
                          as server performs background tasks
 
     FAILED_REGISTRATION  Request to register a new model version has failed
 
                   READY  Model version is ready for use
```

```text
Enumeration values:
  PENDING_REGISTRATION
  FAILED_REGISTRATION
  READY

```

#### mlflow.ModelVersionStatus.ModelVersionStatus

```text
MODELVERSIONSTATUS Status of a Model Version registration
  Possible values:
    PENDING_REGISTRATION  Request to register a new model version is pending
                          as server performs background tasks
 
     FAILED_REGISTRATION  Request to register a new model version has failed
 
                   READY  Model version is ready for use
```

### mlflow.ModelVersionTag

Superclass: mlflow.KeyValue

```text
MODELVERSIONTAG Tag for a model version
  Create a tag to apply to a run. The inputs to this can be a struct
  array with the fieldnames key and value, or simply a series of
  key/value pairs 
 
  Example:
 
    mvt1 = mlflow.ModelVersionTag('mykey','myvalue');
 
    mvt2 = mlflow.ModelVersionTag('key1', 'val1','key2', 'val2');
 
   kv = struct('key', {"hello", "there"}, 'value', {"10", "20"});
   mvt3 = mlflow.ModelVersionTag(kv)
```

#### mlflow.ModelVersionTag.ModelVersionTag

```text
MODELVERSIONTAG Tag for a model version
  Create a tag to apply to a run. The inputs to this can be a struct
  array with the fieldnames key and value, or simply a series of
  key/value pairs 
 
  Example:
 
    mvt1 = mlflow.ModelVersionTag('mykey','myvalue');
 
    mvt2 = mlflow.ModelVersionTag('key1', 'val1','key2', 'val2');
 
   kv = struct('key', {"hello", "there"}, 'value', {"10", "20"});
   mvt3 = mlflow.ModelVersionTag(kv)
```

### mlflow.Object

Superclass: dynamicprops

```text
OBJECT MLflow root object
  Properties added to this object will be available on all mlflow
  classes.
```

#### mlflow.Object.Object

```text
By default, fetch the authentication info.
```

#### mlflow.Object.addStructureAsDynProps

```text
mlflow.Object/addStructureAsDynProps is a function.
    addStructureAsDynProps(obj, S)
```

#### mlflow.Object.getAuth

```text
mlflow.Object/getAuth is a function.
    getAuth(obj, varargin)
```

#### mlflow.Object.getAuthorizationField

```text
GETAUTHORIZATIONFIELD Return the authorization field for API
```

#### mlflow.Object.getConfig

```text
First check environment variables
```

#### mlflow.Object.getConfigFromEnvVars

```text
mlflow.Object/getConfigFromEnvVars is a function.
    config = getConfigFromEnvVars(~)
```

#### mlflow.Object.getRequestMessage

```text
GETREQUESTMESSAGE Get the request message to call the MLflow API
 
     req = obj.getRequestMessage
 
   will return a matlab.net.http.RequestMessage with the correct
   authorization information set.
 
     req = obj.getRequestMessage('POST')
 
   will create a similar RequestMessage with the correct method set too.
```

#### mlflow.Object.getURI

```text
getURI Return a URI object
 
     u = obj.getURI('experiments', 'list')
 
   will return a matlab.net.URI, e.g. in the case of databricks:
     https://<REDACTED>.cloud.databricks.com/api/2.0/mlflow/experiments/list
 
   If the function needs parameters, they can be added as pairs
 
     u = obj.getURI('experiment', 'get', 'experiment_id', '123')
   will return a matlab.net.URI for the get experiment REST
   endpoint.
```

#### mlflow.Object.iSanitizeHost

```text
Set Host
```

#### mlflow.Object.isDatabricks

```text
mlflow.Object.isDatabricks is a function.
    tf = mlflow.Object.isDatabricks
```

#### mlflow.Object.isPreview

```text
Only needs to handle Model Version for now
```

### mlflow.Param

Superclass: mlflow.KeyValue

```text
Param Parameter for a mlflow Run
 
  This class is normally not instantiated explicitly, but is a result
  of creating a Run object (cf. mlflow.Run/logParameter)
 
  Example:
 
    p1 = mlflow.Param('mykey','myvalue');
 
  See also mlflow.Run/logParameter
```

#### mlflow.Param.Param

```text
Param Parameter for a mlflow Run
 
  This class is normally not instantiated explicitly, but is a result
  of creating a Run object (cf. mlflow.Run/logParameter)
 
  Example:
 
    p1 = mlflow.Param('mykey','myvalue');
 
  See also mlflow.Run/logParameter
```

### mlflow.RegisteredModel

Superclass: mlflow.Object

```text
REGISTEREDMODEL
```

#### mlflow.RegisteredModel.RegisteredModel

```text
REGISTEREDMODEL
```

#### mlflow.RegisteredModel.create

```text
CREATE Method to create a registered model
  
  An mlflow.RegisteredModel object is returned.
  
  Example:
  
    rm = mlflow.RegisteredModel;
    result = rm.create();
```

#### mlflow.RegisteredModel.get

```text
GET Method to get a registered model
  
  name must be provided as a scalar string or character vector. It is the
  name of the registered model.
 
  An mlflow.RegisteredModel object is returned.
  
  Example:
  
    rm = mlflow.RegisteredModel;
    result = rm.get('modelName');
```

#### mlflow.RegisteredModel.getLatestVersions

```text
GETLATESTVERSIONS Latest version models for each requests stage
  Only returns models with current READY status. If no stages are provided,
  returns the latest version for each stage, including "None".
 
  An array of ModelVersions is returned.
 
  An optional character vector, cell array of character vectors, string or string
  array of stages can be provided as the first optional argument.
```

#### mlflow.RegisteredModel.getPayload

```text
GETPAYLOAD Internal method to create the request payload by removing properties
```

#### mlflow.RegisteredModel.initFromStructInternal

```text
initFromStructInternal Create object from structure
```

#### mlflow.RegisteredModel.list

```text
LIST List registered models
 
  This is a static method on the mlfow.RegisteredModel class, and will
  list models registered on the mlflow endpoint.
 
  Examples: 
   % List up to 20 models
   regmdls = mlflow.RegisteredModel.list()
 
   % List up to N models (we set N to 5)
   regmdls = mlflow.RegisteredModel.list(5)
   
   % List up to 5 models and save the pagination token
   [regmdls, paginationToken] = mlflow.RegisteredModel.list(5)
   % Now list the next 10 models
   [regmdls, paginationToken] = mlflow.RegisteredModel.list(10, paginationToken)
```

#### mlflow.RegisteredModel.remove

```text
REMOVE Method to delete a registered model
  Delete a registered model from the MLFlow tracking server.
 
    rm = mlflow.RegisteredModel
    rm.remove('modelName');  % Deletes a registered model
```

#### mlflow.RegisteredModel.rename

```text
RENAME Method to rename a registered model
  
  newName must be provided as a scalar string or character vector. It is the
  newname of the registered model.
 
  An mlflow.RegisteredModel object is returned.
  
  Example:
  
    rm = mlflow.RegisteredModel;
    result = rm.rename('oldName', 'newName');
```

#### mlflow.RegisteredModel.search

```text
SEARCH List registered models
 
  This is a static method on the mlfow.RegisteredModel class, and will
  search models registered on the mlflow endpoint. Without arguments,
  it behaves much like the list method.
 
  Examples: 
   % Search up to 100 models
   regmdls = mlflow.RegisteredModel.search()
 
   % Search models whose name is like Test
   regmdls = mlflow.RegisteredModel.search("name LIKE 'Test'")
   
   % Search models whose name is like Test, limit to 5 results
   regmdls = mlflow.RegisteredModel.search("name LIKE 'Test'", 5)
   
   % Search models whose name is like Test, order by user_id
   regmdls = mlflow.RegisteredModel.search("name LIKE 'Test'", 5, [])
   
   
   % Search up to 5 models and save the pagination token
   [regmdls, paginationToken] = mlflow.RegisteredModel.search("name LIKE 'Test'", 5, [])
   % Now search the next 10 models
   [regmdls, paginationToken] = mlflow.RegisteredModel.search("name LIKE 'Test'", 5, [], paginationToken)
```

#### mlflow.RegisteredModel.setTag

```text
SETTAG Method to set a tag on a registered model
  
  The arguments can be either a key/value pair or an object of type
  mlflow.RegisteredModelTag
 
  An mlflow.RegisteredModel object is returned.
  
  Examples:
  
    rm = mlflow.RegisteredModel.get("SomeModel");
    result = rm.update('mykey', 'myvalue');
  
    rmt = mlflow.RegisteredModelTag('otherkey', 'othervalue');
    rm = rm.update(rmt)
```

#### mlflow.RegisteredModel.update

```text
UPDATE Method to update a registered model
  
  name must be provided as a scalar string or character vector. It is the
  name of the registered model.
 
  An optional new description can be provided as a scalar string or character vector.
 
  An mlflow.RegisteredModel object is returned.
  
  Example:
  
    rm = mlflow.RegisteredModel;
    result = rm.update('modelName', 'Updated model description');
```

### mlflow.RegisteredModelTag

Superclass: mlflow.KeyValue

```text
REGISTEREDMODELTAG Tag for a registered model
  Create a tag to apply to a run.  The inputs to this can be a struct
  array with the fieldnames key and value, or simply a series of
  key/value pairs
 
  Example:
 
    mvt1 = mlflow.RegisteredModelTag('mykey','myvalue');
 
 
    mvt2 = mlflow.RegisteredModelTag('key1', 'val1','key2', 'val2');
 
   kv = struct('key', {"hello", "there"}, 'value', {"10", "20"});
   mvt3 = mlflow.RegisteredModelTag(kv)
```

#### mlflow.RegisteredModelTag.RegisteredModelTag

```text
REGISTEREDMODELTAG Tag for a registered model
  Create a tag to apply to a run.  The inputs to this can be a struct
  array with the fieldnames key and value, or simply a series of
  key/value pairs
 
  Example:
 
    mvt1 = mlflow.RegisteredModelTag('mykey','myvalue');
 
 
    mvt2 = mlflow.RegisteredModelTag('key1', 'val1','key2', 'val2');
 
   kv = struct('key', {"hello", "there"}, 'value', {"10", "20"});
   mvt3 = mlflow.RegisteredModelTag(kv)
```

### mlflow.Run

Superclass: mlflow.Object

```text
RUN MLflow Run
  This object allows the creation of runs within an experiment. A run is
  usually a single execution of a machine learning or data ETL pipeline.
  This is used to track parameters, metrics and RunTags associated with a
  single execution.
```

#### mlflow.Run.Run

```text
RUN MLflow Run
  This object allows the creation of runs within an experiment. A run is
  usually a single execution of a machine learning or data ETL pipeline.
  This is used to track parameters, metrics and RunTags associated with a
  single execution.
```

#### mlflow.Run.create

```text
CREATE Method to create a run in a particular run in an experiment
  Create a particular run in an experiment
 
  If the start_time is not defined, then the run will assume the current
  time as specified by the computers local timezone setting.
 
  To configure the start_time, specify the time as an int64 in milliseconds.
 
  Example:
 
    r = mlflow.Run;
    r.start_time = int64(posixtime(datetime('now','TimeZone','local'))*1e3);
```

#### mlflow.Run.deleteTag

```text
DELETETAG Delete a tag on a run
  Tags are run metadata that can be updated during a run and after a run completes.
 
  run_id must be provided as a scalar string or character vector, it represents
  the ID of the run that the tag was logged under.
 
  key must be provided as a scalar string or character vector.It is the name of 
  the tag. Maximum size is 255 bytes.
```

#### mlflow.Run.getHistory

```text
GETHISTORY Retrieve history of a metric from a run
 
  Example:
 
    % Retrieve a Run
    RS = mlflow.Run.search('1', '');
    metrics = RS.getHistory()
```

#### mlflow.Run.getPayload

```text
GETPAYLOAD Internal method to create the request payload by removing properties
```

#### mlflow.Run.logMetric

```text
LOGMETRIC Log a metric for a run.
  A metric is a key-value pair (string key, float value) with an associated
  timestamp.
 
  Examples include the various metrics that represent ML model accuracy and loss.
  A metric can be logged multiple times. If a timestamp is not specified,
  the current time is used.
 
  Example:
 
      % Create a run
      mle = mlflow.Experiment.getByName('/Users/joe@example.com/MLFlowUnitTests');
      r = mle.createRun;
      r.user_id = 'joe';
      r.create();
 
      % Log a metric at the current time
      r.logMetric('TrainingLoss',1e-6);
 
      % Log a metric at a specific time
      r.logMetric('TrainingLoss',1e-6, 1643977759293);
 
      Log a metric and also add a step size
      r.logMetric('TrainingLoss',1e-6, 1643977759293, 100);
 
  A mlflow.Metric object can be used to store the metrics;
 
      % Create a metric
      metric = mlflow.Metric('now');
      metric.key = 'TrainingLoss';
      metric.value = 1e-6;
      r.logMetric(metric);
```

#### mlflow.Run.logParameter

```text
LOGPARAMETER Log a parameter for a run. Specified as a key value pair.
 
  Example:
 
    % Create a run
    r = mlflow.Run;
    r.start_time = int64(posixtime(datetime('now','TimeZone','local'))*1e3);
    r.user_id = 'joe'
    r.create();
 
    % Log a parameter
    r.logParameter('mykey','myval');
```

#### mlflow.Run.refresh

```text
REFRESH Method to get metadata for a run
  Fetch metadata about a run.
 
  Example:
 
    % Create an experiment
    mle = mlflow.Experiment;
    mle.name = '/Users/joe@example.com/myDemo';
    mle.create();  % Creates an experiment
 
    % Create a run
    runObj = mle.createRun();
    runObj.create();       % Creates a run
    runObj.refresh();      % Refresh run metadata
```

#### mlflow.Run.remove

```text
REMOVE Method to delete a run from an experiment
  Delete a run from the MLFlow experiment
  
  Example:
 
    % Create an experiment
    mle = mlflow.Experiment;
    mle.name = '/Users/username@example.com/PFTDemo';
    mle.create();  % Creates an experiment
    
    % Create a run
    runObj = mle.createRun();
    runObj.create();    % Creates a run
    runObj.remove();    % Deletes a run
```

#### mlflow.Run.restore

```text
RESTORE Method to a deleted run
 
  Example:
 
    % Create an experiment
    mle = mlflow.Experiment;
    mle.name = '/Users/username@example.com/PFTDemo';
    mle.create();  % Creates an experiment
    
    % Create a run
    runObj = mle.createRun();
    runObj.create();       % Creates a run
    runObj.remove();       % Deletes a run
    runObj.restore();      % Restore a run
```

#### mlflow.Run.search

```text
SEARCH Method to search for runs that satisfy filter expressions
  Search through MLFlow runs using Metric and Params keys
 
  Examples:
  runs = mlflow.Run.search("1343416123331890")
 
  % Only search 5, and get a next_page_token
  [runs, npt] = mlflow.Run.search(E.experiment_id, maxResults = 5)
  % Search next 10
  [runs2, npt] = mlflow.Run.search(E.experiment_id, maxResults = 10, pageToken=npt)
 
  Other optional arguments are filterExpr, runViewType, orderBy
 
  Cf. https://www.mlflow.org/docs/latest/rest-api.html#search-runs
```

#### mlflow.Run.setTag

```text
SETTAG Set a tag on a run.
  Tags are run metadata that can be updated during a run and after a run completes.
 
  The object on which this method is called must be a 'real run', i.e.
  either created through the API, or retrieved using a search method.
  The run_id of this object will be used to specify on which run the
  tag will be set.
 
  key must be provided as a scalar string or character vector. It is the maximum
  size depends on storage backend. All storage backends are guaranteed to support
  key values up to 250 bytes in size.
 
  value must be provided as a scalar string or character vector. It is the value
  of the tag being logged. Maximum size depends on storage backend. All storage
  backends are guaranteed to support key values up to 5000 bytes in size.
 
  The run_uuid field is deprecated and not support use run_id instead.
```

#### mlflow.Run.update

```text
UPDATE Method to Update run metadata
 
  This method is used to change the current status of a run. The
  possible status options can be found here:
     https://www.mlflow.org/docs/latest/rest-api.html#mlflowrunstatus
 
  Examples: R is an mlflow.Run object
  % Using the current time (as posix int64)
  R.update(mlflow.RunStatus.FINISHED)
 
  % Explicitly setting the time
  R.update(mlflow.RunStatus.FINISHED, 1643877559257)
 
  % Using a string instead of the RunStatus class
  R.update("RUNNING", 1643877559257)
```

### mlflow.RunData

Superclass: handle

```text
RunData Data fields for a mlflow Run
```

#### mlflow.RunData.RunData

```text
RunData Data fields for a mlflow Run
```

#### mlflow.RunData.addMetrics

```text
mlflow.RunData/addMetrics is a function.
    addMetrics(obj, metrics)
```

#### mlflow.RunData.addParams

```text
mlflow.RunData/addParams is a function.
    addParams(obj, params)
```

#### mlflow.RunData.addTags

```text
mlflow.RunData/addTags is a function.
    addTags(obj, tags)
```

### mlflow.RunInfo

Superclass: handle

```text
RUNINFO Metadata of a single run
  The run_uuid field is deprecated and not supported use run_id instead.
  The user_id field is deprecated and not supported use a mlflow.user tag instead.
  The run_name field is returned on Databricks and is undocumented.
```

#### mlflow.RunInfo.RunInfo

```text
Support construction from a struct as might be
  returned from REST call post JSON conversion
```

### mlflow.RunStatus

```text
RUNSTATUS Status of a run
  Possible values:
      RUNNING  Run has been initiated
    SCHEDULED  Run is scheduled to run at a later time
     FINISHED  Run has completed
       FAILED  Run execution failed
       KILLED  Run killed by user
```

```text
Enumeration values:
  RUNNING
  SCHEDULED
  FINISHED
  FAILED
  KILLED

```

#### mlflow.RunStatus.RunStatus

```text
RUNSTATUS Status of a run
  Possible values:
      RUNNING  Run has been initiated
    SCHEDULED  Run is scheduled to run at a later time
     FINISHED  Run has completed
       FAILED  Run execution failed
       KILLED  Run killed by user
```

### mlflow.RunTag

Superclass: mlflow.KeyValue

```text
RUNTAG Container for holding the tags for a run
  Create a tag to apply to a run. The inputs to this can be a cell array of
  key value pairs.
 
  This class is normally not instantiated explicitly, but is a result
  of creating a Run object (cf. mlflow.Run/setTag)
 
  Example:
 
    tt1 = mlflow.RunTag('mykey','myvalue');
 
  See also mlflow.Run/setTag
```

#### mlflow.RunTag.RunTag

```text
RUNTAG Container for holding the tags for a run
  Create a tag to apply to a run. The inputs to this can be a cell array of
  key value pairs.
 
  This class is normally not instantiated explicitly, but is a result
  of creating a Run object (cf. mlflow.Run/setTag)
 
  Example:
 
    tt1 = mlflow.RunTag('mykey','myvalue');
 
  See also mlflow.Run/setTag
```

### mlflow.ViewType

```text
VIEWTYPE View type for ListExperiments query
  Possible values:
 
     ACTIVE_ONLY  Default, Return only active experiments
    DELETED_ONLY  Return only deleted experiments
             ALL  Get all experiments
```

```text
Enumeration values:
  ACTIVE_ONLY
  DELETED_ONLY
  ALL

```

#### mlflow.ViewType.ViewType

```text
VIEWTYPE View type for ListExperiments query
  Possible values:
 
     ACTIVE_ONLY  Default, Return only active experiments
    DELETED_ONLY  Return only deleted experiments
             ALL  Get all experiments
```

### mlflow.cli

```text
cli Interface to mlflow command line API
 
  Please refer to the official documentation of this:
   https://mlflow.org/docs/latest/cli.html
 
  This function will only work if mlflow is installed and available on
  the PATH.
 
  The function returns two values
   ret - the return value of the system command.
   status - the output of the command
 
  If the status is not saved to a variable, its output will simply be
  printed.
 
  Examples
  % Check the help
  mlflow.cli('--help')
 
  % List experiments
  mlflow.cli('experiments', 'list')
 
  % Create an artifact for a run
  mlflow.cli('artifacts', 'log-artifact', '-l', 'Contents.m', ...
     '-r', 'd48a790705394c5bb3ea43039a96ecf5', '-a', 'somewhere')
    2022/01/21 15:26:30 INFO mlflow.store.artifact.cli: Logged artifact from local file Contents.m to artifact_path=somewhere
 
  One special form, outside of the mlflow cli, exist to easier check if
  mlflow is installed on a system. If the first argument to the
  function is true (the logical value, not the string), the function
  will simply return true if mlflow is installed on the system. This
  can be useful if deciding to call this function or not.
 
  Example:
  mlflow.cli(true)
```

### mlflow.getConfigFile

```text
GETCONFIGFILE Returns the full name of the configuration file
  Returns the config file location used by the JAR assemblies by using
  Java's system properties to get a users home directory
  Files are searched for in the following order:
    1)  <Home directory>/.mlflow-connect
    2)  <Home directory>/.databricks-connect
    3)  mlflow.json on the MATLAB path
 
  If none of these files are found then an empty character vector is returned.
  The tooling requires a valid configuration.
```

### mlflow.jsondecode

```text
JSONDECODE Overrides builtin jsondecode, adds field type support see jsondecodeTypedValues
```

### Logger

```text
Logger - Object definition for Logger
  ---------------------------------------------------------------------
  Abstract: A logger object to encapsulate logging and debugging
            messages for a MATLAB application.
 
  Syntax:
            logObj = Logger.getLogger();
 
  Logger Properties:
 
      LogFileLevel - The level of log messages that will be saved to the
      log file
 
      DisplayLevel - The level of log messages that will be displayed
      in the command window
 
      LogFile - The file name or path to the log file. If empty,
      nothing will be logged to file.
 
      Messages - Structure array containing log messages
 
  Logger Methods:
 
      clearMessages(obj) - Clears the log messages currently stored in
      the Logger object
 
      clearLogFile(obj) - Clears the log messages currently stored in
      the log file
 
      write(obj,Level,MessageText) - Writes a message to the log
 
  Examples:
      logObj = Logger.getLogger();
      write(logObj,'warning','My warning message')
```

### getCurrentTimeUnixINT64

```text
GETCURRENTTIMEUNIXINT64 Return the current Unix time in milliseconds
  Returns an INT64 timestamp in the number of milliseconds since the start
  of the Unix time in the current timezone.
 
  This is equalivalent to:
  int64(posixtime(datetime('now','TimeZone','local'))*1e3)
```

### getHTTPOptions

```text
GETHTTPOPTIONS Return HTTP communication options
  Modify the <package>-http.json file to override the settings that the package uses
  for REST based communication. This file must be on the MATLAB path, by default
  it is found in the /Software/MATLAB/config directory.
  If a databricks-http.json file is found on the path it will used in preference
  to a mlflow-http.json file. If no file is found then MATLAB's default
  matlab.net.http.HTTPOptions will be used.
 
  By default, the object sends the following options:
 
             MaxRedirects: 20
           ConnectTimeout: 10
                 UseProxy: 1
                 ProxyURI: []
             Authenticate: 1
              Credentials: [1x1 matlab.net.http.Credentials]
       UseProgressMonitor: 0
              SavePayload: 0
          ConvertResponse: 1
           DecodeResponse: 1
       ProgressMonitorFcn: []
      CertificateFilename: "default"
         VerifyServerName: 1
              DataTimeout: Inf
          ResponseTimeout: Inf
         KeepAliveTimeout: Inf
 
  A ConvertResponse argument can optionally be used to prevent results being
  automatically converted e.g. from JSON to a struct.  If this argument is used
  it will override a ConvertResponse setting in JSON file. The argument is case
  sensitive.
 
  Example:
 
     opts = getHTTPOptions('ConvertResponse', false)
```

### getJsonValue

```text
GETJSONVALUE returns a JSON value as a specified type
  The following arguments are required:
          json: Input JSON as a string or character vector or a
                com.google.gson.JsonArray, com.google.gson.JsonPrimitive or
                com.google.gson.JsonObject as an output of the gson parser e.g:
                   jParser = javaObject('com.google.gson.JsonParser');
                   json = jParser.parse(jsonString);
 
     valueName: Cell array of hierarchical fields naming a single value
                e.g.: valueName = {"level1", "level2", "myPrimitiveField"};
                An unnamed primitive value is denoted by ""
                If a field is an array a single index can be provided as a
                numeric value, e.g.: {"levelA", "arrayB", 4, "myPrimitiveField"};
                Array entries are indexed from 1.
 
      typeName: int64 or string specified as a string or character vector
 
  Returning non scalar value results is currently not supported.
 
  Examples:
 
    % An int64 value as a json primitive with no name/key
    primitiveStr = jsonencode(1234);
    result = getJsonValue(primitiveStr, {""}, "int64")
    result =
      int64
       1234
 
    % A hierarchical structure
    s = struct;
    s.a = int64(123);
    s.b = "String1";
    ss.c = "String2";
    ss.d = int64(456);
    s.f = ss;
    jsonStr = jsonencode(s);
    result = getJsonValue(jsonStr, {"b"}, "string")
    result =
        "String1"
    result = getJsonValue(jsonStr, {"f", "d"}, "int64")
    result =
      int64
       456
 
    % Access using an array index
    s = struct;
    a = struct;
    for n=1:5
        a(n).s = ['abc', num2str(n)];
        a(n).i = int64(n);
     end
    s.a = a;
    jsonStr = jsonencode(s)
    result = getJsonValue(jsonStr, {"a",2,"s"}, "string")
    result =
       "abc2"
```

### jsondecodeTypedValues

```text
JSONDECODETYPEDVALUES Converts JSON extracting named values as specified types
  This allows a named int64 scalar value in a JSON to be returned as part of a
  struct as a int64 typed field without conversion to a double.
 
  MATLAB's Builtin jsondecode() is used to decode all other fields.
 
  Only scalar values of type string, int32 and int64 are currently supported as
  named values.
 
  Once decoded field names which do not conform to MATLAB's naming rules are made
  valid using matlab.lang.makeValidName, as per builtin jsondecode. If field
  name alteration is problematic consider using getJsonValue to directly access
  the JSON value without decoding the larger json text,
 
  A single numeric array index can be provided per field name. Where a
  pattern requires array expansion a ':' can be used to denote a field to
  be expanded
 
  If only a JSON text argument is provided the built in function is
  called directly by this function without alteration of inputs or outputs.
 
  The allowMissing argument is a logical value used to indicate if the
  the absence of a field in the json should be considered an error.
  To allow missing fields set this value to true.
 
  Examples:
 
    s = struct;
    s.a = int64(123);
    s.b = "String1";
    ss.c = "String2";
    ss.d = int64(456);
    s.f = ss;
    jsonStr = jsonencode(s);
    allowMissing = true;
    result = jsondecodeTypedValues(jsonStr, allowMissing, {"f","d"}, "int64", {"a"}, "int64")
    result =
      struct with fields:
        a: 123
        b: 'String1'
        f: [1x1 struct]
    result.f.d
       ans =
         int64
          456
    result.a
       ans =
         int64
          123
 
    % Decode a scalar value with no name
    scalarResult = jsondecodeTypedValues('1234', allowMissing, {""}, "int64");
    result =
      int64
       1234
 
    % Address using an array index
    s = struct;
    v = struct;
    for n=1:3
       v(n).c = ['abc', num2str(n)];
       v(n).i = int64(n);
    end
    s.v = v;
    jsonStr = jsonencode(s);
 
    % Expand and array index
    result = jsondecodeTypedValues(jsonStr, allowMissing, {"v",{':'},"i"}, "int64")
    result.v.i
    ans =
      int64
       1
    ans =
      int64
       2
    ans =
      int64
       3
    result.v(3).i
    ans =
      int64
       3
```

### mlflowPackageVersion

```text
mlflowPackageVersion Return version of the mlflow package
```

### mlflowRoot

```text
MLFLOWROOT Function to return the root folder for the MLflow interface
  mlflowRoot alone will return the root for the MATLAB code in the
  project.
 
  mlflowRoot with additional arguments will add these to the path:
  
    funDir = mlflowRoot('app', 'functions')
 
  The special argument of a negative number will move up folders, e.g.
  the following call will move up two folders, and then into
  Documentation.
 
  docDir = mlflowRoot(-2, 'Documentation')
```

------

**Copyright 2020-2024 The MathWorks Inc.**

[//]: # (Documentation generation settings: )
[//]: # (* Including class level help text )
[//]: # (* Including constructor help text )
[//]: # (* Excluding inherited methods )
[//]: # (* Excluding default MATLAB classes )
[//]: # (* Generated: 20-Sep-2024 22:49:33 )
