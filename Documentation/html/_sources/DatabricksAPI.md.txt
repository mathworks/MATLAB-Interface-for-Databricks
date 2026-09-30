# MATLAB Interface *for Databricks* - API Reference

Classes, methods and functions that include the terms `private` or `internal` in their namespace should not be used directly.
They are subject to change or removal without notice.
The subpackages in the `Modules` directory contain their own `Documentation` directories including API references.

## Index

* MATLAB Interface *for Databricks*
  * [databricks](#databricks)
    * [databricks.datastructures](#databricksdatastructures)
      * [databricks.datastructures.apps](#databricksdatastructuresapps)
        * [databricks.datastructures.apps.App](#databricksdatastructuresappsapp)
          * [databricks.datastructures.apps.App.App](#databricksdatastructuresappsappapp)
        * [databricks.datastructures.apps.AppDeployment](#databricksdatastructuresappsappdeployment)
          * [databricks.datastructures.apps.AppDeployment.AppDeployment](#databricksdatastructuresappsappdeploymentappdeployment)
        * [databricks.datastructures.apps.AppPermission](#databricksdatastructuresappsapppermission)
          * [databricks.datastructures.apps.AppPermission.AppPermission](#databricksdatastructuresappsapppermissionapppermission)
        * [databricks.datastructures.apps.AppState](#databricksdatastructuresappsappstate)
          * [databricks.datastructures.apps.AppState.AppState](#databricksdatastructuresappsappstateappstate)
        * [databricks.datastructures.apps.AppStatus](#databricksdatastructuresappsappstatus)
          * [databricks.datastructures.apps.AppStatus.AppStatus](#databricksdatastructuresappsappstatusappstatus)
        * [databricks.datastructures.apps.ComputeSize](#databricksdatastructuresappscomputesize)
          * [databricks.datastructures.apps.ComputeSize.ComputeSize](#databricksdatastructuresappscomputesizecomputesize)
        * [databricks.datastructures.apps.ComputeState](#databricksdatastructuresappscomputestate)
          * [databricks.datastructures.apps.ComputeState.ComputeState](#databricksdatastructuresappscomputestatecomputestate)
        * [databricks.datastructures.apps.ComputeStatus](#databricksdatastructuresappscomputestatus)
          * [databricks.datastructures.apps.ComputeStatus.ComputeStatus](#databricksdatastructuresappscomputestatuscomputestatus)
        * [databricks.datastructures.apps.CreateAppRequest](#databricksdatastructuresappscreateapprequest)
          * [databricks.datastructures.apps.CreateAppRequest.CreateAppRequest](#databricksdatastructuresappscreateapprequestcreateapprequest)
        * [databricks.datastructures.apps.CreateAppResponse](#databricksdatastructuresappscreateappresponse)
          * [databricks.datastructures.apps.CreateAppResponse.CreateAppResponse](#databricksdatastructuresappscreateappresponsecreateappresponse)
        * [databricks.datastructures.apps.CreateDeploymentRequest](#databricksdatastructuresappscreatedeploymentrequest)
          * [databricks.datastructures.apps.CreateDeploymentRequest.CreateDeploymentRequest](#databricksdatastructuresappscreatedeploymentrequestcreatedeploymentrequest)
        * [databricks.datastructures.apps.CreateDeploymentResponse](#databricksdatastructuresappscreatedeploymentresponse)
          * [databricks.datastructures.apps.CreateDeploymentResponse.CreateDeploymentResponse](#databricksdatastructuresappscreatedeploymentresponsecreatedeploymentresponse)
        * [databricks.datastructures.apps.Database](#databricksdatastructuresappsdatabase)
          * [databricks.datastructures.apps.Database.Database](#databricksdatastructuresappsdatabasedatabase)
        * [databricks.datastructures.apps.DatabasePermission](#databricksdatastructuresappsdatabasepermission)
          * [databricks.datastructures.apps.DatabasePermission.DatabasePermission](#databricksdatastructuresappsdatabasepermissiondatabasepermission)
        * [databricks.datastructures.apps.DeleteAppResponse](#databricksdatastructuresappsdeleteappresponse)
          * [databricks.datastructures.apps.DeleteAppResponse.DeleteAppResponse](#databricksdatastructuresappsdeleteappresponsedeleteappresponse)
        * [databricks.datastructures.apps.DeleteThumbnailResponse](#databricksdatastructuresappsdeletethumbnailresponse)
          * [databricks.datastructures.apps.DeleteThumbnailResponse.DeleteThumbnailResponse](#databricksdatastructuresappsdeletethumbnailresponsedeletethumbnailresponse)
        * [databricks.datastructures.apps.DeploymentArtifacts](#databricksdatastructuresappsdeploymentartifacts)
          * [databricks.datastructures.apps.DeploymentArtifacts.DeploymentArtifacts](#databricksdatastructuresappsdeploymentartifactsdeploymentartifacts)
        * [databricks.datastructures.apps.DeploymentState](#databricksdatastructuresappsdeploymentstate)
          * [databricks.datastructures.apps.DeploymentState.DeploymentState](#databricksdatastructuresappsdeploymentstatedeploymentstate)
        * [databricks.datastructures.apps.DeploymentStatus](#databricksdatastructuresappsdeploymentstatus)
          * [databricks.datastructures.apps.DeploymentStatus.DeploymentStatus](#databricksdatastructuresappsdeploymentstatusdeploymentstatus)
        * [databricks.datastructures.apps.EnvVar](#databricksdatastructuresappsenvvar)
          * [databricks.datastructures.apps.EnvVar.EnvVar](#databricksdatastructuresappsenvvarenvvar)
        * [databricks.datastructures.apps.Experiment](#databricksdatastructuresappsexperiment)
          * [databricks.datastructures.apps.Experiment.Experiment](#databricksdatastructuresappsexperimentexperiment)
        * [databricks.datastructures.apps.ExperimentPermission](#databricksdatastructuresappsexperimentpermission)
          * [databricks.datastructures.apps.ExperimentPermission.ExperimentPermission](#databricksdatastructuresappsexperimentpermissionexperimentpermission)
        * [databricks.datastructures.apps.GeniePermission](#databricksdatastructuresappsgeniepermission)
          * [databricks.datastructures.apps.GeniePermission.GeniePermission](#databricksdatastructuresappsgeniepermissiongeniepermission)
        * [databricks.datastructures.apps.GenieSpace](#databricksdatastructuresappsgeniespace)
          * [databricks.datastructures.apps.GenieSpace.GenieSpace](#databricksdatastructuresappsgeniespacegeniespace)
        * [databricks.datastructures.apps.GetAppResponse](#databricksdatastructuresappsgetappresponse)
          * [databricks.datastructures.apps.GetAppResponse.GetAppResponse](#databricksdatastructuresappsgetappresponsegetappresponse)
        * [databricks.datastructures.apps.GetDeploymentResponse](#databricksdatastructuresappsgetdeploymentresponse)
          * [databricks.datastructures.apps.GetDeploymentResponse.GetDeploymentResponse](#databricksdatastructuresappsgetdeploymentresponsegetdeploymentresponse)
        * [databricks.datastructures.apps.GitRepository](#databricksdatastructuresappsgitrepository)
          * [databricks.datastructures.apps.GitRepository.GitRepository](#databricksdatastructuresappsgitrepositorygitrepository)
        * [databricks.datastructures.apps.GitSource](#databricksdatastructuresappsgitsource)
          * [databricks.datastructures.apps.GitSource.GitSource](#databricksdatastructuresappsgitsourcegitsource)
        * [databricks.datastructures.apps.Job](#databricksdatastructuresappsjob)
          * [databricks.datastructures.apps.Job.Job](#databricksdatastructuresappsjobjob)
        * [databricks.datastructures.apps.JobPermission](#databricksdatastructuresappsjobpermission)
          * [databricks.datastructures.apps.JobPermission.JobPermission](#databricksdatastructuresappsjobpermissionjobpermission)
        * [databricks.datastructures.apps.ListAppsResponse](#databricksdatastructuresappslistappsresponse)
          * [databricks.datastructures.apps.ListAppsResponse.ListAppsResponse](#databricksdatastructuresappslistappsresponselistappsresponse)
        * [databricks.datastructures.apps.ListAppsResult](#databricksdatastructuresappslistappsresult)
          * [databricks.datastructures.apps.ListAppsResult.ListAppsResult](#databricksdatastructuresappslistappsresultlistappsresult)
        * [databricks.datastructures.apps.ListDeploymentResult](#databricksdatastructuresappslistdeploymentresult)
          * [databricks.datastructures.apps.ListDeploymentResult.ListDeploymentResult](#databricksdatastructuresappslistdeploymentresultlistdeploymentresult)
        * [databricks.datastructures.apps.Mode](#databricksdatastructuresappsmode)
          * [databricks.datastructures.apps.Mode.Mode](#databricksdatastructuresappsmodemode)
        * [databricks.datastructures.apps.Postgres](#databricksdatastructuresappspostgres)
          * [databricks.datastructures.apps.Postgres.Postgres](#databricksdatastructuresappspostgrespostgres)
        * [databricks.datastructures.apps.PostgresPermission](#databricksdatastructuresappspostgrespermission)
          * [databricks.datastructures.apps.PostgresPermission.PostgresPermission](#databricksdatastructuresappspostgrespermissionpostgrespermission)
        * [databricks.datastructures.apps.Resource](#databricksdatastructuresappsresource)
          * [databricks.datastructures.apps.Resource.Resource](#databricksdatastructuresappsresourceresource)
        * [databricks.datastructures.apps.SQLWarehouse](#databricksdatastructuresappssqlwarehouse)
          * [databricks.datastructures.apps.SQLWarehouse.SQLWarehouse](#databricksdatastructuresappssqlwarehousesqlwarehouse)
        * [databricks.datastructures.apps.SQLWarehousePermission](#databricksdatastructuresappssqlwarehousepermission)
          * [databricks.datastructures.apps.SQLWarehousePermission.SQLWarehousePermission](#databricksdatastructuresappssqlwarehousepermissionsqlwarehousepermission)
        * [databricks.datastructures.apps.Secret](#databricksdatastructuresappssecret)
          * [databricks.datastructures.apps.Secret.Secret](#databricksdatastructuresappssecretsecret)
        * [databricks.datastructures.apps.SecretPermission](#databricksdatastructuresappssecretpermission)
          * [databricks.datastructures.apps.SecretPermission.SecretPermission](#databricksdatastructuresappssecretpermissionsecretpermission)
        * [databricks.datastructures.apps.ServingEndpoint](#databricksdatastructuresappsservingendpoint)
          * [databricks.datastructures.apps.ServingEndpoint.ServingEndpoint](#databricksdatastructuresappsservingendpointservingendpoint)
        * [databricks.datastructures.apps.ServingPermission](#databricksdatastructuresappsservingpermission)
          * [databricks.datastructures.apps.ServingPermission.ServingPermission](#databricksdatastructuresappsservingpermissionservingpermission)
        * [databricks.datastructures.apps.StartAppResponse](#databricksdatastructuresappsstartappresponse)
          * [databricks.datastructures.apps.StartAppResponse.StartAppResponse](#databricksdatastructuresappsstartappresponsestartappresponse)
        * [databricks.datastructures.apps.StopAppResponse](#databricksdatastructuresappsstopappresponse)
          * [databricks.datastructures.apps.StopAppResponse.StopAppResponse](#databricksdatastructuresappsstopappresponsestopappresponse)
        * [databricks.datastructures.apps.TelemetryExportDestination](#databricksdatastructuresappstelemetryexportdestination)
          * [databricks.datastructures.apps.TelemetryExportDestination.TelemetryExportDestination](#databricksdatastructuresappstelemetryexportdestinationtelemetryexportdestination)
        * [databricks.datastructures.apps.Thumbnail](#databricksdatastructuresappsthumbnail)
          * [databricks.datastructures.apps.Thumbnail.Thumbnail](#databricksdatastructuresappsthumbnailthumbnail)
        * [databricks.datastructures.apps.UCSecurable](#databricksdatastructuresappsucsecurable)
          * [databricks.datastructures.apps.UCSecurable.UCSecurable](#databricksdatastructuresappsucsecurableucsecurable)
        * [databricks.datastructures.apps.UCSecurablePermission](#databricksdatastructuresappsucsecurablepermission)
          * [databricks.datastructures.apps.UCSecurablePermission.UCSecurablePermission](#databricksdatastructuresappsucsecurablepermissionucsecurablepermission)
        * [databricks.datastructures.apps.UCSecurableType](#databricksdatastructuresappsucsecurabletype)
          * [databricks.datastructures.apps.UCSecurableType.UCSecurableType](#databricksdatastructuresappsucsecurabletypeucsecurabletype)
        * [databricks.datastructures.apps.UnityCatalog](#databricksdatastructuresappsunitycatalog)
          * [databricks.datastructures.apps.UnityCatalog.UnityCatalog](#databricksdatastructuresappsunitycatalogunitycatalog)
        * [databricks.datastructures.apps.UpdateThumbnailRequest](#databricksdatastructuresappsupdatethumbnailrequest)
          * [databricks.datastructures.apps.UpdateThumbnailRequest.UpdateThumbnailRequest](#databricksdatastructuresappsupdatethumbnailrequestupdatethumbnailrequest)
      * [databricks.datastructures.clusterpolicy](#databricksdatastructuresclusterpolicy)
        * [databricks.datastructures.clusterpolicy.AccessControlList](#databricksdatastructuresclusterpolicyaccesscontrollist)
          * [databricks.datastructures.clusterpolicy.AccessControlList.AccessControlList](#databricksdatastructuresclusterpolicyaccesscontrollistaccesscontrollist)
        * [databricks.datastructures.clusterpolicy.AllPermissions](#databricksdatastructuresclusterpolicyallpermissions)
          * [databricks.datastructures.clusterpolicy.AllPermissions.AllPermissions](#databricksdatastructuresclusterpolicyallpermissionsallpermissions)
        * [databricks.datastructures.clusterpolicy.CreateRequest](#databricksdatastructuresclusterpolicycreaterequest)
          * [databricks.datastructures.clusterpolicy.CreateRequest.CreateRequest](#databricksdatastructuresclusterpolicycreaterequestcreaterequest)
        * [databricks.datastructures.clusterpolicy.CreateResponse](#databricksdatastructuresclusterpolicycreateresponse)
          * [databricks.datastructures.clusterpolicy.CreateResponse.CreateResponse](#databricksdatastructuresclusterpolicycreateresponsecreateresponse)
        * [databricks.datastructures.clusterpolicy.ErrorResponse](#databricksdatastructuresclusterpolicyerrorresponse)
          * [databricks.datastructures.clusterpolicy.ErrorResponse.ErrorResponse](#databricksdatastructuresclusterpolicyerrorresponseerrorresponse)
          * [databricks.datastructures.clusterpolicy.ErrorResponse.throw](#databricksdatastructuresclusterpolicyerrorresponsethrow)
        * [databricks.datastructures.clusterpolicy.GetPermissionLevelsResponse](#databricksdatastructuresclusterpolicygetpermissionlevelsresponse)
          * [databricks.datastructures.clusterpolicy.GetPermissionLevelsResponse.GetPermissionLevelsResponse](#databricksdatastructuresclusterpolicygetpermissionlevelsresponsegetpermissionlevelsresponse)
        * [databricks.datastructures.clusterpolicy.GetPermissionsResponse](#databricksdatastructuresclusterpolicygetpermissionsresponse)
          * [databricks.datastructures.clusterpolicy.GetPermissionsResponse.GetPermissionsResponse](#databricksdatastructuresclusterpolicygetpermissionsresponsegetpermissionsresponse)
        * [databricks.datastructures.clusterpolicy.ListOrder](#databricksdatastructuresclusterpolicylistorder)
          * [databricks.datastructures.clusterpolicy.ListOrder.ListOrder](#databricksdatastructuresclusterpolicylistorderlistorder)
        * [databricks.datastructures.clusterpolicy.ListResponse](#databricksdatastructuresclusterpolicylistresponse)
          * [databricks.datastructures.clusterpolicy.ListResponse.ListResponse](#databricksdatastructuresclusterpolicylistresponselistresponse)
        * [databricks.datastructures.clusterpolicy.PermissionLevel](#databricksdatastructuresclusterpolicypermissionlevel)
          * [databricks.datastructures.clusterpolicy.PermissionLevel.PermissionLevel](#databricksdatastructuresclusterpolicypermissionlevelpermissionlevel)
        * [databricks.datastructures.clusterpolicy.Policy](#databricksdatastructuresclusterpolicypolicy)
          * [databricks.datastructures.clusterpolicy.Policy.Policy](#databricksdatastructuresclusterpolicypolicypolicy)
        * [databricks.datastructures.clusterpolicy.PolicySortColumn](#databricksdatastructuresclusterpolicypolicysortcolumn)
          * [databricks.datastructures.clusterpolicy.PolicySortColumn.PolicySortColumn](#databricksdatastructuresclusterpolicypolicysortcolumnpolicysortcolumn)
        * [databricks.datastructures.clusterpolicy.PolicyUpdateRequest](#databricksdatastructuresclusterpolicypolicyupdaterequest)
          * [databricks.datastructures.clusterpolicy.PolicyUpdateRequest.PolicyUpdateRequest](#databricksdatastructuresclusterpolicypolicyupdaterequestpolicyupdaterequest)
      * [databricks.datastructures.commandexecution](#databricksdatastructurescommandexecution)
        * [databricks.datastructures.commandexecution.CancelRequest](#databricksdatastructurescommandexecutioncancelrequest)
          * [databricks.datastructures.commandexecution.CancelRequest.CancelRequest](#databricksdatastructurescommandexecutioncancelrequestcancelrequest)
          * [databricks.datastructures.commandexecution.CancelRequest.fromInputs](#databricksdatastructurescommandexecutioncancelrequestfrominputs)
        * [databricks.datastructures.commandexecution.CommandsStatusResponse](#databricksdatastructurescommandexecutioncommandsstatusresponse)
          * [databricks.datastructures.commandexecution.CommandsStatusResponse.CommandsStatusResponse](#databricksdatastructurescommandexecutioncommandsstatusresponsecommandsstatusresponse)
        * [databricks.datastructures.commandexecution.CommandsStatusResults](#databricksdatastructurescommandexecutioncommandsstatusresults)
          * [databricks.datastructures.commandexecution.CommandsStatusResults.CommandsStatusResults](#databricksdatastructurescommandexecutioncommandsstatusresultscommandsstatusresults)
        * [databricks.datastructures.commandexecution.CommandsStatusStatus](#databricksdatastructurescommandexecutioncommandsstatusstatus)
          * [databricks.datastructures.commandexecution.CommandsStatusStatus.CommandsStatusStatus](#databricksdatastructurescommandexecutioncommandsstatusstatuscommandsstatusstatus)
        * [databricks.datastructures.commandexecution.ContextsStatus](#databricksdatastructurescommandexecutioncontextsstatus)
          * [databricks.datastructures.commandexecution.ContextsStatus.ContextsStatus](#databricksdatastructurescommandexecutioncontextsstatuscontextsstatus)
        * [databricks.datastructures.commandexecution.ContextsStatusResponse](#databricksdatastructurescommandexecutioncontextsstatusresponse)
          * [databricks.datastructures.commandexecution.ContextsStatusResponse.ContextsStatusResponse](#databricksdatastructurescommandexecutioncontextsstatusresponsecontextsstatusresponse)
        * [databricks.datastructures.commandexecution.CreateRequest](#databricksdatastructurescommandexecutioncreaterequest)
          * [databricks.datastructures.commandexecution.CreateRequest.CreateRequest](#databricksdatastructurescommandexecutioncreaterequestcreaterequest)
          * [databricks.datastructures.commandexecution.CreateRequest.fromInputs](#databricksdatastructurescommandexecutioncreaterequestfrominputs)
        * [databricks.datastructures.commandexecution.CreateResponse](#databricksdatastructurescommandexecutioncreateresponse)
          * [databricks.datastructures.commandexecution.CreateResponse.CreateResponse](#databricksdatastructurescommandexecutioncreateresponsecreateresponse)
        * [databricks.datastructures.commandexecution.DestroyRequest](#databricksdatastructurescommandexecutiondestroyrequest)
          * [databricks.datastructures.commandexecution.DestroyRequest.DestroyRequest](#databricksdatastructurescommandexecutiondestroyrequestdestroyrequest)
          * [databricks.datastructures.commandexecution.DestroyRequest.fromInputs](#databricksdatastructurescommandexecutiondestroyrequestfrominputs)
        * [databricks.datastructures.commandexecution.ErrorResponse](#databricksdatastructurescommandexecutionerrorresponse)
          * [databricks.datastructures.commandexecution.ErrorResponse.ErrorResponse](#databricksdatastructurescommandexecutionerrorresponseerrorresponse)
          * [databricks.datastructures.commandexecution.ErrorResponse.throw](#databricksdatastructurescommandexecutionerrorresponsethrow)
        * [databricks.datastructures.commandexecution.ExecuteRequest](#databricksdatastructurescommandexecutionexecuterequest)
          * [databricks.datastructures.commandexecution.ExecuteRequest.ExecuteRequest](#databricksdatastructurescommandexecutionexecuterequestexecuterequest)
          * [databricks.datastructures.commandexecution.ExecuteRequest.fromInputs](#databricksdatastructurescommandexecutionexecuterequestfrominputs)
        * [databricks.datastructures.commandexecution.ExecuteResponse](#databricksdatastructurescommandexecutionexecuteresponse)
          * [databricks.datastructures.commandexecution.ExecuteResponse.ExecuteResponse](#databricksdatastructurescommandexecutionexecuteresponseexecuteresponse)
        * [databricks.datastructures.commandexecution.Language](#databricksdatastructurescommandexecutionlanguage)
          * [databricks.datastructures.commandexecution.Language.Language](#databricksdatastructurescommandexecutionlanguagelanguage)
        * [databricks.datastructures.commandexecution.ResultType](#databricksdatastructurescommandexecutionresulttype)
          * [databricks.datastructures.commandexecution.ResultType.ResultType](#databricksdatastructurescommandexecutionresulttyperesulttype)
      * [databricks.datastructures.currentuser](#databricksdatastructurescurrentuser)
        * [databricks.datastructures.currentuser.Email](#databricksdatastructurescurrentuseremail)
          * [databricks.datastructures.currentuser.Email.Email](#databricksdatastructurescurrentuseremailemail)
        * [databricks.datastructures.currentuser.Entitlement](#databricksdatastructurescurrentuserentitlement)
          * [databricks.datastructures.currentuser.Entitlement.Entitlement](#databricksdatastructurescurrentuserentitlemententitlement)
        * [databricks.datastructures.currentuser.ErrorResponse](#databricksdatastructurescurrentusererrorresponse)
          * [databricks.datastructures.currentuser.ErrorResponse.ErrorResponse](#databricksdatastructurescurrentusererrorresponseerrorresponse)
          * [databricks.datastructures.currentuser.ErrorResponse.throw](#databricksdatastructurescurrentusererrorresponsethrow)
        * [databricks.datastructures.currentuser.Group](#databricksdatastructurescurrentusergroup)
          * [databricks.datastructures.currentuser.Group.Group](#databricksdatastructurescurrentusergroupgroup)
        * [databricks.datastructures.currentuser.Name](#databricksdatastructurescurrentusername)
          * [databricks.datastructures.currentuser.Name.Name](#databricksdatastructurescurrentusernamename)
        * [databricks.datastructures.currentuser.Role](#databricksdatastructurescurrentuserrole)
          * [databricks.datastructures.currentuser.Role.Role](#databricksdatastructurescurrentuserrolerole)
        * [databricks.datastructures.currentuser.UserInfo](#databricksdatastructurescurrentuseruserinfo)
          * [databricks.datastructures.currentuser.UserInfo.UserInfo](#databricksdatastructurescurrentuseruserinfouserinfo)
      * [databricks.datastructures.files](#databricksdatastructuresfiles)
        * [databricks.datastructures.files.DirectoryEntry](#databricksdatastructuresfilesdirectoryentry)
          * [databricks.datastructures.files.DirectoryEntry.DirectoryEntry](#databricksdatastructuresfilesdirectoryentrydirectoryentry)
        * [databricks.datastructures.files.DirectoryMetadata](#databricksdatastructuresfilesdirectorymetadata)
          * [databricks.datastructures.files.DirectoryMetadata.DirectoryMetadata](#databricksdatastructuresfilesdirectorymetadatadirectorymetadata)
        * [databricks.datastructures.files.ErrorResponse](#databricksdatastructuresfileserrorresponse)
          * [databricks.datastructures.files.ErrorResponse.ErrorResponse](#databricksdatastructuresfileserrorresponseerrorresponse)
          * [databricks.datastructures.files.ErrorResponse.throw](#databricksdatastructuresfileserrorresponsethrow)
        * [databricks.datastructures.files.FileMetadata](#databricksdatastructuresfilesfilemetadata)
          * [databricks.datastructures.files.FileMetadata.FileMetadata](#databricksdatastructuresfilesfilemetadatafilemetadata)
        * [databricks.datastructures.files.ListResponse](#databricksdatastructuresfileslistresponse)
          * [databricks.datastructures.files.ListResponse.ListResponse](#databricksdatastructuresfileslistresponselistresponse)
        * [databricks.datastructures.files.ListResponsePaginated](#databricksdatastructuresfileslistresponsepaginated)
          * [databricks.datastructures.files.ListResponsePaginated.ListResponsePaginated](#databricksdatastructuresfileslistresponsepaginatedlistresponsepaginated)
        * [databricks.datastructures.files.UploadCompleteRequest](#databricksdatastructuresfilesuploadcompleterequest)
          * [databricks.datastructures.files.UploadCompleteRequest.UploadCompleteRequest](#databricksdatastructuresfilesuploadcompleterequestuploadcompleterequest)
        * [databricks.datastructures.files.UploadCompleteRequestEntry](#databricksdatastructuresfilesuploadcompleterequestentry)
          * [databricks.datastructures.files.UploadCompleteRequestEntry.UploadCompleteRequestEntry](#databricksdatastructuresfilesuploadcompleterequestentryuploadcompleterequestentry)
      * [databricks.datastructures.genie](#databricksdatastructuresgenie)
        * [databricks.datastructures.genie.Attachment](#databricksdatastructuresgenieattachment)
          * [databricks.datastructures.genie.Attachment.Attachment](#databricksdatastructuresgenieattachmentattachment)
        * [databricks.datastructures.genie.Chunk](#databricksdatastructuresgeniechunk)
          * [databricks.datastructures.genie.Chunk.Chunk](#databricksdatastructuresgeniechunkchunk)
        * [databricks.datastructures.genie.Column](#databricksdatastructuresgeniecolumn)
          * [databricks.datastructures.genie.Column.Column](#databricksdatastructuresgeniecolumncolumn)
        * [databricks.datastructures.genie.Conversation](#databricksdatastructuresgenieconversation)
          * [databricks.datastructures.genie.Conversation.Conversation](#databricksdatastructuresgenieconversationconversation)
        * [databricks.datastructures.genie.CreateConversationMessageResponse](#databricksdatastructuresgeniecreateconversationmessageresponse)
          * [databricks.datastructures.genie.CreateConversationMessageResponse.CreateConversationMessageResponse](#databricksdatastructuresgeniecreateconversationmessageresponsecreateconversationmessageresponse)
        * [databricks.datastructures.genie.DataArray](#databricksdatastructuresgeniedataarray)
          * [databricks.datastructures.genie.DataArray.DataArray](#databricksdatastructuresgeniedataarraydataarray)
          * [databricks.datastructures.genie.DataArray.toEntries](#databricksdatastructuresgeniedataarraytoentries)
        * [databricks.datastructures.genie.Error](#databricksdatastructuresgenieerror)
          * [databricks.datastructures.genie.Error.Error](#databricksdatastructuresgenieerrorerror)
        * [databricks.datastructures.genie.ErrorCode](#databricksdatastructuresgenieerrorcode)
          * [databricks.datastructures.genie.ErrorCode.ErrorCode](#databricksdatastructuresgenieerrorcodeerrorcode)
        * [databricks.datastructures.genie.ErrorMsgExec](#databricksdatastructuresgenieerrormsgexec)
          * [databricks.datastructures.genie.ErrorMsgExec.ErrorMsgExec](#databricksdatastructuresgenieerrormsgexecerrormsgexec)
        * [databricks.datastructures.genie.ErrorType](#databricksdatastructuresgenieerrortype)
          * [databricks.datastructures.genie.ErrorType.ErrorType](#databricksdatastructuresgenieerrortypeerrortype)
        * [databricks.datastructures.genie.ExecMsgAttachmentSQLQueryResponse](#databricksdatastructuresgenieexecmsgattachmentsqlqueryresponse)
          * [databricks.datastructures.genie.ExecMsgAttachmentSQLQueryResponse.ExecMsgAttachmentSQLQueryResponse](#databricksdatastructuresgenieexecmsgattachmentsqlqueryresponseexecmsgattachmentsqlqueryresponse)
        * [databricks.datastructures.genie.ExternalLink](#databricksdatastructuresgenieexternallink)
          * [databricks.datastructures.genie.ExternalLink.ExternalLink](#databricksdatastructuresgenieexternallinkexternallink)
        * [databricks.datastructures.genie.Format](#databricksdatastructuresgenieformat)
          * [databricks.datastructures.genie.Format.Format](#databricksdatastructuresgenieformatformat)
        * [databricks.datastructures.genie.GetMsgAttachmentSQLQueryResponse](#databricksdatastructuresgeniegetmsgattachmentsqlqueryresponse)
          * [databricks.datastructures.genie.GetMsgAttachmentSQLQueryResponse.GetMsgAttachmentSQLQueryResponse](#databricksdatastructuresgeniegetmsgattachmentsqlqueryresponsegetmsgattachmentsqlqueryresponse)
        * [databricks.datastructures.genie.ListConversationMessagesResponse](#databricksdatastructuresgenielistconversationmessagesresponse)
          * [databricks.datastructures.genie.ListConversationMessagesResponse.ListConversationMessagesResponse](#databricksdatastructuresgenielistconversationmessagesresponselistconversationmessagesresponse)
        * [databricks.datastructures.genie.ListConversationsResponse](#databricksdatastructuresgenielistconversationsresponse)
          * [databricks.datastructures.genie.ListConversationsResponse.ListConversationsResponse](#databricksdatastructuresgenielistconversationsresponselistconversationsresponse)
        * [databricks.datastructures.genie.ListSpacesResponse](#databricksdatastructuresgenielistspacesresponse)
          * [databricks.datastructures.genie.ListSpacesResponse.ListSpacesResponse](#databricksdatastructuresgenielistspacesresponselistspacesresponse)
        * [databricks.datastructures.genie.Manifest](#databricksdatastructuresgeniemanifest)
          * [databricks.datastructures.genie.Manifest.Manifest](#databricksdatastructuresgeniemanifestmanifest)
        * [databricks.datastructures.genie.Message](#databricksdatastructuresgeniemessage)
          * [databricks.datastructures.genie.Message.Message](#databricksdatastructuresgeniemessagemessage)
        * [databricks.datastructures.genie.MsgExecResult](#databricksdatastructuresgeniemsgexecresult)
          * [databricks.datastructures.genie.MsgExecResult.MsgExecResult](#databricksdatastructuresgeniemsgexecresultmsgexecresult)
        * [databricks.datastructures.genie.Query](#databricksdatastructuresgeniequery)
          * [databricks.datastructures.genie.Query.Query](#databricksdatastructuresgeniequeryquery)
        * [databricks.datastructures.genie.QueryResultMetadata](#databricksdatastructuresgeniequeryresultmetadata)
          * [databricks.datastructures.genie.QueryResultMetadata.QueryResultMetadata](#databricksdatastructuresgeniequeryresultmetadataqueryresultmetadata)
        * [databricks.datastructures.genie.Schema](#databricksdatastructuresgenieschema)
          * [databricks.datastructures.genie.Schema.Schema](#databricksdatastructuresgenieschemaschema)
        * [databricks.datastructures.genie.Space](#databricksdatastructuresgeniespace)
          * [databricks.datastructures.genie.Space.Space](#databricksdatastructuresgeniespacespace)
        * [databricks.datastructures.genie.StartConversationResponse](#databricksdatastructuresgeniestartconversationresponse)
          * [databricks.datastructures.genie.StartConversationResponse.StartConversationResponse](#databricksdatastructuresgeniestartconversationresponsestartconversationresponse)
        * [databricks.datastructures.genie.State](#databricksdatastructuresgeniestate)
          * [databricks.datastructures.genie.State.State](#databricksdatastructuresgeniestatestate)
        * [databricks.datastructures.genie.StatementResponse](#databricksdatastructuresgeniestatementresponse)
          * [databricks.datastructures.genie.StatementResponse.StatementResponse](#databricksdatastructuresgeniestatementresponsestatementresponse)
        * [databricks.datastructures.genie.StatementResponseStatus](#databricksdatastructuresgeniestatementresponsestatus)
          * [databricks.datastructures.genie.StatementResponseStatus.StatementResponseStatus](#databricksdatastructuresgeniestatementresponsestatusstatementresponsestatus)
        * [databricks.datastructures.genie.Status](#databricksdatastructuresgeniestatus)
          * [databricks.datastructures.genie.Status.Status](#databricksdatastructuresgeniestatusstatus)
        * [databricks.datastructures.genie.Text](#databricksdatastructuresgenietext)
          * [databricks.datastructures.genie.Text.Text](#databricksdatastructuresgenietexttext)
        * [databricks.datastructures.genie.TypeName](#databricksdatastructuresgenietypename)
          * [databricks.datastructures.genie.TypeName.TypeName](#databricksdatastructuresgenietypenametypename)
      * [databricks.datastructures.instancepools](#databricksdatastructuresinstancepools)
        * [databricks.datastructures.instancepools.AWSAttributes](#databricksdatastructuresinstancepoolsawsattributes)
          * [databricks.datastructures.instancepools.AWSAttributes.AWSAttributes](#databricksdatastructuresinstancepoolsawsattributesawsattributes)
        * [databricks.datastructures.instancepools.AvailabilityAWS](#databricksdatastructuresinstancepoolsavailabilityaws)
          * [databricks.datastructures.instancepools.AvailabilityAWS.AvailabilityAWS](#databricksdatastructuresinstancepoolsavailabilityawsavailabilityaws)
        * [databricks.datastructures.instancepools.AvailabilityAzure](#databricksdatastructuresinstancepoolsavailabilityazure)
          * [databricks.datastructures.instancepools.AvailabilityAzure.AvailabilityAzure](#databricksdatastructuresinstancepoolsavailabilityazureavailabilityazure)
        * [databricks.datastructures.instancepools.AzureAttributes](#databricksdatastructuresinstancepoolsazureattributes)
          * [databricks.datastructures.instancepools.AzureAttributes.AzureAttributes](#databricksdatastructuresinstancepoolsazureattributesazureattributes)
        * [databricks.datastructures.instancepools.AzureDiskVolumeType](#databricksdatastructuresinstancepoolsazurediskvolumetype)
          * [databricks.datastructures.instancepools.AzureDiskVolumeType.AzureDiskVolumeType](#databricksdatastructuresinstancepoolsazurediskvolumetypeazurediskvolumetype)
        * [databricks.datastructures.instancepools.CreateRequest](#databricksdatastructuresinstancepoolscreaterequest)
          * [databricks.datastructures.instancepools.CreateRequest.CreateRequest](#databricksdatastructuresinstancepoolscreaterequestcreaterequest)
        * [databricks.datastructures.instancepools.DiskSpec](#databricksdatastructuresinstancepoolsdiskspec)
          * [databricks.datastructures.instancepools.DiskSpec.DiskSpec](#databricksdatastructuresinstancepoolsdiskspecdiskspec)
        * [databricks.datastructures.instancepools.DiskType](#databricksdatastructuresinstancepoolsdisktype)
          * [databricks.datastructures.instancepools.DiskType.DiskType](#databricksdatastructuresinstancepoolsdisktypedisktype)
        * [databricks.datastructures.instancepools.DockerBasicAuth](#databricksdatastructuresinstancepoolsdockerbasicauth)
          * [databricks.datastructures.instancepools.DockerBasicAuth.DockerBasicAuth](#databricksdatastructuresinstancepoolsdockerbasicauthdockerbasicauth)
        * [databricks.datastructures.instancepools.DockerImage](#databricksdatastructuresinstancepoolsdockerimage)
          * [databricks.datastructures.instancepools.DockerImage.DockerImage](#databricksdatastructuresinstancepoolsdockerimagedockerimage)
        * [databricks.datastructures.instancepools.EbsVolumeType](#databricksdatastructuresinstancepoolsebsvolumetype)
          * [databricks.datastructures.instancepools.EbsVolumeType.EbsVolumeType](#databricksdatastructuresinstancepoolsebsvolumetypeebsvolumetype)
        * [databricks.datastructures.instancepools.InstancePool](#databricksdatastructuresinstancepoolsinstancepool)
          * [databricks.datastructures.instancepools.InstancePool.InstancePool](#databricksdatastructuresinstancepoolsinstancepoolinstancepool)
        * [databricks.datastructures.instancepools.InstancePools](#databricksdatastructuresinstancepoolsinstancepools)
          * [databricks.datastructures.instancepools.InstancePools.InstancePools](#databricksdatastructuresinstancepoolsinstancepoolsinstancepools)
        * [databricks.datastructures.instancepools.PendingInstanceError](#databricksdatastructuresinstancepoolspendinginstanceerror)
          * [databricks.datastructures.instancepools.PendingInstanceError.PendingInstanceError](#databricksdatastructuresinstancepoolspendinginstanceerrorpendinginstanceerror)
        * [databricks.datastructures.instancepools.Permissions](#databricksdatastructuresinstancepoolspermissions)
          * [databricks.datastructures.instancepools.Permissions.Permissions](#databricksdatastructuresinstancepoolspermissionspermissions)
        * [databricks.datastructures.instancepools.State](#databricksdatastructuresinstancepoolsstate)
          * [databricks.datastructures.instancepools.State.State](#databricksdatastructuresinstancepoolsstatestate)
        * [databricks.datastructures.instancepools.Stats](#databricksdatastructuresinstancepoolsstats)
          * [databricks.datastructures.instancepools.Stats.Stats](#databricksdatastructuresinstancepoolsstatsstats)
        * [databricks.datastructures.instancepools.Status](#databricksdatastructuresinstancepoolsstatus)
          * [databricks.datastructures.instancepools.Status.Status](#databricksdatastructuresinstancepoolsstatusstatus)
      * [databricks.datastructures.libraries](#databricksdatastructureslibraries)
        * [databricks.datastructures.libraries.Cran](#databricksdatastructureslibrariescran)
          * [databricks.datastructures.libraries.Cran.Cran](#databricksdatastructureslibrariescrancran)
        * [databricks.datastructures.libraries.Egg](#databricksdatastructureslibrariesegg)
          * [databricks.datastructures.libraries.Egg.Egg](#databricksdatastructureslibrarieseggegg)
        * [databricks.datastructures.libraries.Jar](#databricksdatastructureslibrariesjar)
          * [databricks.datastructures.libraries.Jar.Jar](#databricksdatastructureslibrariesjarjar)
        * [databricks.datastructures.libraries.Library](#databricksdatastructureslibrarieslibrary)
          * [databricks.datastructures.libraries.Library.Library](#databricksdatastructureslibrarieslibrarylibrary)
          * [databricks.datastructures.libraries.Library.fromJSON_HIDDEN](#databricksdatastructureslibrarieslibraryfromjson_hidden)
          * [databricks.datastructures.libraries.Library.getPayload_HIDDEN](#databricksdatastructureslibrarieslibrarygetpayload_hidden)
          * [databricks.datastructures.libraries.Library.onePropOnly](#databricksdatastructureslibrarieslibraryoneproponly)
          * [databricks.datastructures.libraries.Library.resetProperties](#databricksdatastructureslibrarieslibraryresetproperties)
          * [databricks.datastructures.libraries.Library.setLibrary](#databricksdatastructureslibrarieslibrarysetlibrary)
          * [databricks.datastructures.libraries.Library.structToProperty](#databricksdatastructureslibrarieslibrarystructtoproperty)
          * [databricks.datastructures.libraries.Library.toClassCase](#databricksdatastructureslibrarieslibrarytoclasscase)
        * [databricks.datastructures.libraries.LibraryType](#databricksdatastructureslibrarieslibrarytype)
          * [databricks.datastructures.libraries.LibraryType.LibraryType](#databricksdatastructureslibrarieslibrarytypelibrarytype)
        * [databricks.datastructures.libraries.Maven](#databricksdatastructureslibrariesmaven)
          * [databricks.datastructures.libraries.Maven.Maven](#databricksdatastructureslibrariesmavenmaven)
        * [databricks.datastructures.libraries.Pypi](#databricksdatastructureslibrariespypi)
          * [databricks.datastructures.libraries.Pypi.Pypi](#databricksdatastructureslibrariespypipypi)
        * [databricks.datastructures.libraries.Requirements](#databricksdatastructureslibrariesrequirements)
          * [databricks.datastructures.libraries.Requirements.Requirements](#databricksdatastructureslibrariesrequirementsrequirements)
        * [databricks.datastructures.libraries.Whl](#databricksdatastructureslibrarieswhl)
          * [databricks.datastructures.libraries.Whl.Whl](#databricksdatastructureslibrarieswhlwhl)
      * [databricks.datastructures.scim](#databricksdatastructuresscim)
        * [databricks.datastructures.scim.ErrorResponse](#databricksdatastructuresscimerrorresponse)
          * [databricks.datastructures.scim.ErrorResponse.ErrorResponse](#databricksdatastructuresscimerrorresponseerrorresponse)
          * [databricks.datastructures.scim.ErrorResponse.throw](#databricksdatastructuresscimerrorresponsethrow)
        * [databricks.datastructures.scim.MeResponse](#databricksdatastructuresscimmeresponse)
          * [databricks.datastructures.scim.MeResponse.MeResponse](#databricksdatastructuresscimmeresponsemeresponse)
        * [databricks.datastructures.scim.emails](#databricksdatastructuresscimemails)
          * [databricks.datastructures.scim.emails.emails](#databricksdatastructuresscimemailsemails)
        * [databricks.datastructures.scim.entitlements](#databricksdatastructuresscimentitlements)
          * [databricks.datastructures.scim.entitlements.entitlements](#databricksdatastructuresscimentitlementsentitlements)
        * [databricks.datastructures.scim.groups](#databricksdatastructuresscimgroups)
          * [databricks.datastructures.scim.groups.groups](#databricksdatastructuresscimgroupsgroups)
        * [databricks.datastructures.scim.name](#databricksdatastructuresscimname)
          * [databricks.datastructures.scim.name.name](#databricksdatastructuresscimnamename)
        * [databricks.datastructures.scim.roles](#databricksdatastructuresscimroles)
          * [databricks.datastructures.scim.roles.roles](#databricksdatastructuresscimrolesroles)
      * [databricks.datastructures.secret](#databricksdatastructuressecret)
        * [databricks.datastructures.secret.secretList](#databricksdatastructuressecretsecretlist)
          * [databricks.datastructures.secret.secretList.secretList](#databricksdatastructuressecretsecretlistsecretlist)
        * [databricks.datastructures.secret.secretListItem](#databricksdatastructuressecretsecretlistitem)
          * [databricks.datastructures.secret.secretListItem.secretListItem](#databricksdatastructuressecretsecretlistitemsecretlistitem)
      * [databricks.datastructures.token](#databricksdatastructurestoken)
        * [databricks.datastructures.token.CreateRequest](#databricksdatastructurestokencreaterequest)
          * [databricks.datastructures.token.CreateRequest.CreateRequest](#databricksdatastructurestokencreaterequestcreaterequest)
        * [databricks.datastructures.token.CreateResponse](#databricksdatastructurestokencreateresponse)
          * [databricks.datastructures.token.CreateResponse.CreateResponse](#databricksdatastructurestokencreateresponsecreateresponse)
          * [databricks.datastructures.token.CreateResponse.getPropertyGroups](#databricksdatastructurestokencreateresponsegetpropertygroups)
        * [databricks.datastructures.token.ListResponse](#databricksdatastructurestokenlistresponse)
          * [databricks.datastructures.token.ListResponse.ListResponse](#databricksdatastructurestokenlistresponselistresponse)
        * [databricks.datastructures.token.TokenInfo](#databricksdatastructurestokentokeninfo)
          * [databricks.datastructures.token.TokenInfo.TokenInfo](#databricksdatastructurestokentokeninfotokeninfo)
          * [databricks.datastructures.token.TokenInfo.tokenInfo2struct](#databricksdatastructurestokentokeninfotokeninfo2struct)
      * [databricks.datastructures.unitycatalog](#databricksdatastructuresunitycatalog)
        * [databricks.datastructures.unitycatalog.AllowlistRequest](#databricksdatastructuresunitycatalogallowlistrequest)
          * [databricks.datastructures.unitycatalog.AllowlistRequest.AllowlistRequest](#databricksdatastructuresunitycatalogallowlistrequestallowlistrequest)
          * [databricks.datastructures.unitycatalog.AllowlistRequest.fromInputs](#databricksdatastructuresunitycatalogallowlistrequestfrominputs)
        * [databricks.datastructures.unitycatalog.ArtifactMatchers](#databricksdatastructuresunitycatalogartifactmatchers)
          * [databricks.datastructures.unitycatalog.ArtifactMatchers.ArtifactMatchers](#databricksdatastructuresunitycatalogartifactmatchersartifactmatchers)
          * [databricks.datastructures.unitycatalog.ArtifactMatchers.fromInputs](#databricksdatastructuresunitycatalogartifactmatchersfrominputs)
        * [databricks.datastructures.unitycatalog.ArtifactType](#databricksdatastructuresunitycatalogartifacttype)
          * [databricks.datastructures.unitycatalog.ArtifactType.ArtifactType](#databricksdatastructuresunitycatalogartifacttypeartifacttype)
        * [databricks.datastructures.unitycatalog.AuthenticationType](#databricksdatastructuresunitycatalogauthenticationtype)
          * [databricks.datastructures.unitycatalog.AuthenticationType.AuthenticationType](#databricksdatastructuresunitycatalogauthenticationtypeauthenticationtype)
        * [databricks.datastructures.unitycatalog.AwsIamRole](#databricksdatastructuresunitycatalogawsiamrole)
          * [databricks.datastructures.unitycatalog.AwsIamRole.AwsIamRole](#databricksdatastructuresunitycatalogawsiamroleawsiamrole)
          * [databricks.datastructures.unitycatalog.AwsIamRole.fromInputs](#databricksdatastructuresunitycatalogawsiamrolefrominputs)
        * [databricks.datastructures.unitycatalog.AwsTempCredentials](#databricksdatastructuresunitycatalogawstempcredentials)
          * [databricks.datastructures.unitycatalog.AwsTempCredentials.AwsTempCredentials](#databricksdatastructuresunitycatalogawstempcredentialsawstempcredentials)
          * [databricks.datastructures.unitycatalog.AwsTempCredentials.fromInputs](#databricksdatastructuresunitycatalogawstempcredentialsfrominputs)
        * [databricks.datastructures.unitycatalog.AzureADD](#databricksdatastructuresunitycatalogazureadd)
          * [databricks.datastructures.unitycatalog.AzureADD.AzureADD](#databricksdatastructuresunitycatalogazureaddazureadd)
          * [databricks.datastructures.unitycatalog.AzureADD.fromInputs](#databricksdatastructuresunitycatalogazureaddfrominputs)
        * [databricks.datastructures.unitycatalog.AzureServicePrincipal](#databricksdatastructuresunitycatalogazureserviceprincipal)
          * [databricks.datastructures.unitycatalog.AzureServicePrincipal.AzureServicePrincipal](#databricksdatastructuresunitycatalogazureserviceprincipalazureserviceprincipal)
          * [databricks.datastructures.unitycatalog.AzureServicePrincipal.fromInputs](#databricksdatastructuresunitycatalogazureserviceprincipalfrominputs)
        * [databricks.datastructures.unitycatalog.AzureUserDelegationSAS](#databricksdatastructuresunitycatalogazureuserdelegationsas)
          * [databricks.datastructures.unitycatalog.AzureUserDelegationSAS.AzureUserDelegationSAS](#databricksdatastructuresunitycatalogazureuserdelegationsasazureuserdelegationsas)
          * [databricks.datastructures.unitycatalog.AzureUserDelegationSAS.fromInputs](#databricksdatastructuresunitycatalogazureuserdelegationsasfrominputs)
        * [databricks.datastructures.unitycatalog.CatalogInfo](#databricksdatastructuresunitycatalogcataloginfo)
          * [databricks.datastructures.unitycatalog.CatalogInfo.CatalogInfo](#databricksdatastructuresunitycatalogcataloginfocataloginfo)
          * [databricks.datastructures.unitycatalog.CatalogInfo.fromInputs](#databricksdatastructuresunitycatalogcataloginfofrominputs)
        * [databricks.datastructures.unitycatalog.CatalogInfoList](#databricksdatastructuresunitycatalogcataloginfolist)
          * [databricks.datastructures.unitycatalog.CatalogInfoList.CatalogInfoList](#databricksdatastructuresunitycatalogcataloginfolistcataloginfolist)
        * [databricks.datastructures.unitycatalog.ColumnInfo](#databricksdatastructuresunitycatalogcolumninfo)
          * [databricks.datastructures.unitycatalog.ColumnInfo.ColumnInfo](#databricksdatastructuresunitycatalogcolumninfocolumninfo)
          * [databricks.datastructures.unitycatalog.ColumnInfo.fromInputs](#databricksdatastructuresunitycatalogcolumninfofrominputs)
        * [databricks.datastructures.unitycatalog.ColumnTypeName](#databricksdatastructuresunitycatalogcolumntypename)
          * [databricks.datastructures.unitycatalog.ColumnTypeName.ColumnTypeName](#databricksdatastructuresunitycatalogcolumntypenamecolumntypename)
        * [databricks.datastructures.unitycatalog.Connection](#databricksdatastructuresunitycatalogconnection)
          * [databricks.datastructures.unitycatalog.Connection.Connection](#databricksdatastructuresunitycatalogconnectionconnection)
        * [databricks.datastructures.unitycatalog.ConnectionInfo](#databricksdatastructuresunitycatalogconnectioninfo)
          * [databricks.datastructures.unitycatalog.ConnectionInfo.ConnectionInfo](#databricksdatastructuresunitycatalogconnectioninfoconnectioninfo)
        * [databricks.datastructures.unitycatalog.ConnectionType](#databricksdatastructuresunitycatalogconnectiontype)
          * [databricks.datastructures.unitycatalog.ConnectionType.ConnectionType](#databricksdatastructuresunitycatalogconnectiontypeconnectiontype)
        * [databricks.datastructures.unitycatalog.ConnectionUpdateRequest](#databricksdatastructuresunitycatalogconnectionupdaterequest)
          * [databricks.datastructures.unitycatalog.ConnectionUpdateRequest.ConnectionUpdateRequest](#databricksdatastructuresunitycatalogconnectionupdaterequestconnectionupdaterequest)
          * [databricks.datastructures.unitycatalog.ConnectionUpdateRequest.fromInputs](#databricksdatastructuresunitycatalogconnectionupdaterequestfrominputs)
        * [databricks.datastructures.unitycatalog.CredentialType](#databricksdatastructuresunitycatalogcredentialtype)
          * [databricks.datastructures.unitycatalog.CredentialType.CredentialType](#databricksdatastructuresunitycatalogcredentialtypecredentialtype)
        * [databricks.datastructures.unitycatalog.DataSourceFormat](#databricksdatastructuresunitycatalogdatasourceformat)
          * [databricks.datastructures.unitycatalog.DataSourceFormat.DataSourceFormat](#databricksdatastructuresunitycatalogdatasourceformatdatasourceformat)
        * [databricks.datastructures.unitycatalog.DeltaSharingScope](#databricksdatastructuresunitycatalogdeltasharingscope)
          * [databricks.datastructures.unitycatalog.DeltaSharingScope.DeltaSharingScope](#databricksdatastructuresunitycatalogdeltasharingscopedeltasharingscope)
        * [databricks.datastructures.unitycatalog.ErrorResponse](#databricksdatastructuresunitycatalogerrorresponse)
          * [databricks.datastructures.unitycatalog.ErrorResponse.ErrorResponse](#databricksdatastructuresunitycatalogerrorresponseerrorresponse)
          * [databricks.datastructures.unitycatalog.ErrorResponse.throw](#databricksdatastructuresunitycatalogerrorresponsethrow)
        * [databricks.datastructures.unitycatalog.ExternalLocationInfo](#databricksdatastructuresunitycatalogexternallocationinfo)
          * [databricks.datastructures.unitycatalog.ExternalLocationInfo.ExternalLocationInfo](#databricksdatastructuresunitycatalogexternallocationinfoexternallocationinfo)
          * [databricks.datastructures.unitycatalog.ExternalLocationInfo.fromInputs](#databricksdatastructuresunitycatalogexternallocationinfofrominputs)
        * [databricks.datastructures.unitycatalog.ExternalLocationInfoList](#databricksdatastructuresunitycatalogexternallocationinfolist)
          * [databricks.datastructures.unitycatalog.ExternalLocationInfoList.ExternalLocationInfoList](#databricksdatastructuresunitycatalogexternallocationinfolistexternallocationinfolist)
        * [databricks.datastructures.unitycatalog.FileInfo](#databricksdatastructuresunitycatalogfileinfo)
          * [databricks.datastructures.unitycatalog.FileInfo.FileInfo](#databricksdatastructuresunitycatalogfileinfofileinfo)
        * [databricks.datastructures.unitycatalog.GcpServiceAccountKey](#databricksdatastructuresunitycataloggcpserviceaccountkey)
          * [databricks.datastructures.unitycatalog.GcpServiceAccountKey.GcpServiceAccountKey](#databricksdatastructuresunitycataloggcpserviceaccountkeygcpserviceaccountkey)
          * [databricks.datastructures.unitycatalog.GcpServiceAccountKey.fromInputs](#databricksdatastructuresunitycataloggcpserviceaccountkeyfrominputs)
        * [databricks.datastructures.unitycatalog.GenTempColCredsResp](#databricksdatastructuresunitycataloggentempcolcredsresp)
          * [databricks.datastructures.unitycatalog.GenTempColCredsResp.GenTempColCredsResp](#databricksdatastructuresunitycataloggentempcolcredsrespgentempcolcredsresp)
          * [databricks.datastructures.unitycatalog.GenTempColCredsResp.fromInputs](#databricksdatastructuresunitycataloggentempcolcredsrespfrominputs)
        * [databricks.datastructures.unitycatalog.GetArtifactAllowlistsResp](#databricksdatastructuresunitycataloggetartifactallowlistsresp)
          * [databricks.datastructures.unitycatalog.GetArtifactAllowlistsResp.GetArtifactAllowlistsResp](#databricksdatastructuresunitycataloggetartifactallowlistsrespgetartifactallowlistsresp)
        * [databricks.datastructures.unitycatalog.GetMyGroupsResp](#databricksdatastructuresunitycataloggetmygroupsresp)
          * [databricks.datastructures.unitycatalog.GetMyGroupsResp.GetMyGroupsResp](#databricksdatastructuresunitycataloggetmygroupsrespgetmygroupsresp)
        * [databricks.datastructures.unitycatalog.GetMyInfoResp](#databricksdatastructuresunitycataloggetmyinforesp)
          * [databricks.datastructures.unitycatalog.GetMyInfoResp.GetMyInfoResp](#databricksdatastructuresunitycataloggetmyinforespgetmyinforesp)
        * [databricks.datastructures.unitycatalog.IpAccessList](#databricksdatastructuresunitycatalogipaccesslist)
          * [databricks.datastructures.unitycatalog.IpAccessList.IpAccessList](#databricksdatastructuresunitycatalogipaccesslistipaccesslist)
          * [databricks.datastructures.unitycatalog.IpAccessList.fromInputs](#databricksdatastructuresunitycatalogipaccesslistfrominputs)
        * [databricks.datastructures.unitycatalog.KeyValuePair](#databricksdatastructuresunitycatalogkeyvaluepair)
          * [databricks.datastructures.unitycatalog.KeyValuePair.KeyValuePair](#databricksdatastructuresunitycatalogkeyvaluepairkeyvaluepair)
          * [databricks.datastructures.unitycatalog.KeyValuePair.fromInputs](#databricksdatastructuresunitycatalogkeyvaluepairfrominputs)
        * [databricks.datastructures.unitycatalog.ListConnectionsResp](#databricksdatastructuresunitycataloglistconnectionsresp)
          * [databricks.datastructures.unitycatalog.ListConnectionsResp.ListConnectionsResp](#databricksdatastructuresunitycataloglistconnectionsresplistconnectionsresp)
        * [databricks.datastructures.unitycatalog.ListFilesResp](#databricksdatastructuresunitycataloglistfilesresp)
          * [databricks.datastructures.unitycatalog.ListFilesResp.ListFilesResp](#databricksdatastructuresunitycataloglistfilesresplistfilesresp)
        * [databricks.datastructures.unitycatalog.ListVolumesResp](#databricksdatastructuresunitycataloglistvolumesresp)
          * [databricks.datastructures.unitycatalog.ListVolumesResp.ListVolumesResp](#databricksdatastructuresunitycataloglistvolumesresplistvolumesresp)
        * [databricks.datastructures.unitycatalog.MetastoreAssignment](#databricksdatastructuresunitycatalogmetastoreassignment)
          * [databricks.datastructures.unitycatalog.MetastoreAssignment.MetastoreAssignment](#databricksdatastructuresunitycatalogmetastoreassignmentmetastoreassignment)
          * [databricks.datastructures.unitycatalog.MetastoreAssignment.fromInputs](#databricksdatastructuresunitycatalogmetastoreassignmentfrominputs)
        * [databricks.datastructures.unitycatalog.MetastoreInfo](#databricksdatastructuresunitycatalogmetastoreinfo)
          * [databricks.datastructures.unitycatalog.MetastoreInfo.MetastoreInfo](#databricksdatastructuresunitycatalogmetastoreinfometastoreinfo)
          * [databricks.datastructures.unitycatalog.MetastoreInfo.fromInputs](#databricksdatastructuresunitycatalogmetastoreinfofrominputs)
        * [databricks.datastructures.unitycatalog.MetastoreInfoList](#databricksdatastructuresunitycatalogmetastoreinfolist)
          * [databricks.datastructures.unitycatalog.MetastoreInfoList.MetastoreInfoList](#databricksdatastructuresunitycatalogmetastoreinfolistmetastoreinfolist)
        * [databricks.datastructures.unitycatalog.ObjectsChange](#databricksdatastructuresunitycatalogobjectschange)
          * [databricks.datastructures.unitycatalog.ObjectsChange.ObjectsChange](#databricksdatastructuresunitycatalogobjectschangeobjectschange)
          * [databricks.datastructures.unitycatalog.ObjectsChange.fromInputs](#databricksdatastructuresunitycatalogobjectschangefrominputs)
        * [databricks.datastructures.unitycatalog.ObjectsDiff](#databricksdatastructuresunitycatalogobjectsdiff)
          * [databricks.datastructures.unitycatalog.ObjectsDiff.ObjectsDiff](#databricksdatastructuresunitycatalogobjectsdiffobjectsdiff)
          * [databricks.datastructures.unitycatalog.ObjectsDiff.fromInputs](#databricksdatastructuresunitycatalogobjectsdifffrominputs)
        * [databricks.datastructures.unitycatalog.Operation](#databricksdatastructuresunitycatalogoperation)
          * [databricks.datastructures.unitycatalog.Operation.Operation](#databricksdatastructuresunitycatalogoperationoperation)
        * [databricks.datastructures.unitycatalog.Partition](#databricksdatastructuresunitycatalogpartition)
          * [databricks.datastructures.unitycatalog.Partition.Partition](#databricksdatastructuresunitycatalogpartitionpartition)
          * [databricks.datastructures.unitycatalog.Partition.fromInputs](#databricksdatastructuresunitycatalogpartitionfrominputs)
        * [databricks.datastructures.unitycatalog.PartitionSpecification](#databricksdatastructuresunitycatalogpartitionspecification)
          * [databricks.datastructures.unitycatalog.PartitionSpecification.PartitionSpecification](#databricksdatastructuresunitycatalogpartitionspecificationpartitionspecification)
          * [databricks.datastructures.unitycatalog.PartitionSpecification.fromInputs](#databricksdatastructuresunitycatalogpartitionspecificationfrominputs)
        * [databricks.datastructures.unitycatalog.PartitionValues](#databricksdatastructuresunitycatalogpartitionvalues)
          * [databricks.datastructures.unitycatalog.PartitionValues.PartitionValues](#databricksdatastructuresunitycatalogpartitionvaluespartitionvalues)
          * [databricks.datastructures.unitycatalog.PartitionValues.fromInputs](#databricksdatastructuresunitycatalogpartitionvaluesfrominputs)
        * [databricks.datastructures.unitycatalog.PermissionsChange](#databricksdatastructuresunitycatalogpermissionschange)
          * [databricks.datastructures.unitycatalog.PermissionsChange.PermissionsChange](#databricksdatastructuresunitycatalogpermissionschangepermissionschange)
          * [databricks.datastructures.unitycatalog.PermissionsChange.fromInputs](#databricksdatastructuresunitycatalogpermissionschangefrominputs)
        * [databricks.datastructures.unitycatalog.PermissionsDiff](#databricksdatastructuresunitycatalogpermissionsdiff)
          * [databricks.datastructures.unitycatalog.PermissionsDiff.PermissionsDiff](#databricksdatastructuresunitycatalogpermissionsdiffpermissionsdiff)
          * [databricks.datastructures.unitycatalog.PermissionsDiff.fromInputs](#databricksdatastructuresunitycatalogpermissionsdifffrominputs)
        * [databricks.datastructures.unitycatalog.PermissionsList](#databricksdatastructuresunitycatalogpermissionslist)
          * [databricks.datastructures.unitycatalog.PermissionsList.PermissionsList](#databricksdatastructuresunitycatalogpermissionslistpermissionslist)
          * [databricks.datastructures.unitycatalog.PermissionsList.fromInputs](#databricksdatastructuresunitycatalogpermissionslistfrominputs)
        * [databricks.datastructures.unitycatalog.PrivilegeAssignment](#databricksdatastructuresunitycatalogprivilegeassignment)
          * [databricks.datastructures.unitycatalog.PrivilegeAssignment.PrivilegeAssignment](#databricksdatastructuresunitycatalogprivilegeassignmentprivilegeassignment)
          * [databricks.datastructures.unitycatalog.PrivilegeAssignment.fromInputs](#databricksdatastructuresunitycatalogprivilegeassignmentfrominputs)
        * [databricks.datastructures.unitycatalog.ProviderInfo](#databricksdatastructuresunitycatalogproviderinfo)
          * [databricks.datastructures.unitycatalog.ProviderInfo.ProviderInfo](#databricksdatastructuresunitycatalogproviderinfoproviderinfo)
          * [databricks.datastructures.unitycatalog.ProviderInfo.fromInputs](#databricksdatastructuresunitycatalogproviderinfofrominputs)
        * [databricks.datastructures.unitycatalog.ProviderInfoList](#databricksdatastructuresunitycatalogproviderinfolist)
          * [databricks.datastructures.unitycatalog.ProviderInfoList.ProviderInfoList](#databricksdatastructuresunitycatalogproviderinfolistproviderinfolist)
        * [databricks.datastructures.unitycatalog.ProviderShare](#databricksdatastructuresunitycatalogprovidershare)
          * [databricks.datastructures.unitycatalog.ProviderShare.ProviderShare](#databricksdatastructuresunitycatalogprovidershareprovidershare)
          * [databricks.datastructures.unitycatalog.ProviderShare.fromInputs](#databricksdatastructuresunitycatalogprovidersharefrominputs)
        * [databricks.datastructures.unitycatalog.ProviderShareList](#databricksdatastructuresunitycatalogprovidersharelist)
          * [databricks.datastructures.unitycatalog.ProviderShareList.ProviderShareList](#databricksdatastructuresunitycatalogprovidersharelistprovidersharelist)
        * [databricks.datastructures.unitycatalog.ProvisioningInfo](#databricksdatastructuresunitycatalogprovisioninginfo)
          * [databricks.datastructures.unitycatalog.ProvisioningInfo.ProvisioningInfo](#databricksdatastructuresunitycatalogprovisioninginfoprovisioninginfo)
        * [databricks.datastructures.unitycatalog.ProvisioningState](#databricksdatastructuresunitycatalogprovisioningstate)
          * [databricks.datastructures.unitycatalog.ProvisioningState.ProvisioningState](#databricksdatastructuresunitycatalogprovisioningstateprovisioningstate)
        * [databricks.datastructures.unitycatalog.R2TempCredentials](#databricksdatastructuresunitycatalogr2tempcredentials)
          * [databricks.datastructures.unitycatalog.R2TempCredentials.R2TempCredentials](#databricksdatastructuresunitycatalogr2tempcredentialsr2tempcredentials)
          * [databricks.datastructures.unitycatalog.R2TempCredentials.fromInputs](#databricksdatastructuresunitycatalogr2tempcredentialsfrominputs)
        * [databricks.datastructures.unitycatalog.RecipientInfo](#databricksdatastructuresunitycatalogrecipientinfo)
          * [databricks.datastructures.unitycatalog.RecipientInfo.RecipientInfo](#databricksdatastructuresunitycatalogrecipientinforecipientinfo)
          * [databricks.datastructures.unitycatalog.RecipientInfo.fromInputs](#databricksdatastructuresunitycatalogrecipientinfofrominputs)
        * [databricks.datastructures.unitycatalog.RecipientInfoList](#databricksdatastructuresunitycatalogrecipientinfolist)
          * [databricks.datastructures.unitycatalog.RecipientInfoList.RecipientInfoList](#databricksdatastructuresunitycatalogrecipientinfolistrecipientinfolist)
        * [databricks.datastructures.unitycatalog.RecipientProfile](#databricksdatastructuresunitycatalogrecipientprofile)
          * [databricks.datastructures.unitycatalog.RecipientProfile.RecipientProfile](#databricksdatastructuresunitycatalogrecipientprofilerecipientprofile)
          * [databricks.datastructures.unitycatalog.RecipientProfile.fromInputs](#databricksdatastructuresunitycatalogrecipientprofilefrominputs)
        * [databricks.datastructures.unitycatalog.RecipientTokenInfo](#databricksdatastructuresunitycatalogrecipienttokeninfo)
          * [databricks.datastructures.unitycatalog.RecipientTokenInfo.RecipientTokenInfo](#databricksdatastructuresunitycatalogrecipienttokeninforecipienttokeninfo)
          * [databricks.datastructures.unitycatalog.RecipientTokenInfo.fromInputs](#databricksdatastructuresunitycatalogrecipienttokeninfofrominputs)
        * [databricks.datastructures.unitycatalog.RotateRecipientToken](#databricksdatastructuresunitycatalogrotaterecipienttoken)
          * [databricks.datastructures.unitycatalog.RotateRecipientToken.RotateRecipientToken](#databricksdatastructuresunitycatalogrotaterecipienttokenrotaterecipienttoken)
          * [databricks.datastructures.unitycatalog.RotateRecipientToken.fromInputs](#databricksdatastructuresunitycatalogrotaterecipienttokenfrominputs)
        * [databricks.datastructures.unitycatalog.SchemaInfo](#databricksdatastructuresunitycatalogschemainfo)
          * [databricks.datastructures.unitycatalog.SchemaInfo.SchemaInfo](#databricksdatastructuresunitycatalogschemainfoschemainfo)
          * [databricks.datastructures.unitycatalog.SchemaInfo.fromInputs](#databricksdatastructuresunitycatalogschemainfofrominputs)
        * [databricks.datastructures.unitycatalog.SchemaInfoList](#databricksdatastructuresunitycatalogschemainfolist)
          * [databricks.datastructures.unitycatalog.SchemaInfoList.SchemaInfoList](#databricksdatastructuresunitycatalogschemainfolistschemainfolist)
        * [databricks.datastructures.unitycatalog.SecurableType](#databricksdatastructuresunitycatalogsecurabletype)
          * [databricks.datastructures.unitycatalog.SecurableType.SecurableType](#databricksdatastructuresunitycatalogsecurabletypesecurabletype)
        * [databricks.datastructures.unitycatalog.SetArtifactAllowlistResp](#databricksdatastructuresunitycatalogsetartifactallowlistresp)
          * [databricks.datastructures.unitycatalog.SetArtifactAllowlistResp.SetArtifactAllowlistResp](#databricksdatastructuresunitycatalogsetartifactallowlistrespsetartifactallowlistresp)
        * [databricks.datastructures.unitycatalog.ShareDataObject](#databricksdatastructuresunitycatalogsharedataobject)
          * [databricks.datastructures.unitycatalog.ShareDataObject.ShareDataObject](#databricksdatastructuresunitycatalogsharedataobjectsharedataobject)
          * [databricks.datastructures.unitycatalog.ShareDataObject.fromInputs](#databricksdatastructuresunitycatalogsharedataobjectfrominputs)
        * [databricks.datastructures.unitycatalog.ShareInfo](#databricksdatastructuresunitycatalogshareinfo)
          * [databricks.datastructures.unitycatalog.ShareInfo.ShareInfo](#databricksdatastructuresunitycatalogshareinfoshareinfo)
          * [databricks.datastructures.unitycatalog.ShareInfo.fromInputs](#databricksdatastructuresunitycatalogshareinfofrominputs)
        * [databricks.datastructures.unitycatalog.ShareInfoList](#databricksdatastructuresunitycatalogshareinfolist)
          * [databricks.datastructures.unitycatalog.ShareInfoList.ShareInfoList](#databricksdatastructuresunitycatalogshareinfolistshareinfolist)
          * [databricks.datastructures.unitycatalog.ShareInfoList.fromInputs](#databricksdatastructuresunitycatalogshareinfolistfrominputs)
        * [databricks.datastructures.unitycatalog.ShareToPrivilegeAssignment](#databricksdatastructuresunitycatalogsharetoprivilegeassignment)
          * [databricks.datastructures.unitycatalog.ShareToPrivilegeAssignment.ShareToPrivilegeAssignment](#databricksdatastructuresunitycatalogsharetoprivilegeassignmentsharetoprivilegeassignment)
          * [databricks.datastructures.unitycatalog.ShareToPrivilegeAssignment.fromInputs](#databricksdatastructuresunitycatalogsharetoprivilegeassignmentfrominputs)
        * [databricks.datastructures.unitycatalog.ShareToPrivilegeAssignmentList](#databricksdatastructuresunitycatalogsharetoprivilegeassignmentlist)
          * [databricks.datastructures.unitycatalog.ShareToPrivilegeAssignmentList.ShareToPrivilegeAssignmentList](#databricksdatastructuresunitycatalogsharetoprivilegeassignmentlistsharetoprivilegeassignmentlist)
        * [databricks.datastructures.unitycatalog.StorageCredentialInfo](#databricksdatastructuresunitycatalogstoragecredentialinfo)
          * [databricks.datastructures.unitycatalog.StorageCredentialInfo.StorageCredentialInfo](#databricksdatastructuresunitycatalogstoragecredentialinfostoragecredentialinfo)
          * [databricks.datastructures.unitycatalog.StorageCredentialInfo.fromInputs](#databricksdatastructuresunitycatalogstoragecredentialinfofrominputs)
        * [databricks.datastructures.unitycatalog.StorageCredentialInfoList](#databricksdatastructuresunitycatalogstoragecredentialinfolist)
          * [databricks.datastructures.unitycatalog.StorageCredentialInfoList.StorageCredentialInfoList](#databricksdatastructuresunitycatalogstoragecredentialinfoliststoragecredentialinfolist)
        * [databricks.datastructures.unitycatalog.TableInfo](#databricksdatastructuresunitycatalogtableinfo)
          * [databricks.datastructures.unitycatalog.TableInfo.TableInfo](#databricksdatastructuresunitycatalogtableinfotableinfo)
        * [databricks.datastructures.unitycatalog.TableInfoList](#databricksdatastructuresunitycatalogtableinfolist)
          * [databricks.datastructures.unitycatalog.TableInfoList.TableInfoList](#databricksdatastructuresunitycatalogtableinfolisttableinfolist)
        * [databricks.datastructures.unitycatalog.TableSummariesResp](#databricksdatastructuresunitycatalogtablesummariesresp)
          * [databricks.datastructures.unitycatalog.TableSummariesResp.TableSummariesResp](#databricksdatastructuresunitycatalogtablesummariesresptablesummariesresp)
        * [databricks.datastructures.unitycatalog.TableSummary](#databricksdatastructuresunitycatalogtablesummary)
          * [databricks.datastructures.unitycatalog.TableSummary.TableSummary](#databricksdatastructuresunitycatalogtablesummarytablesummary)
        * [databricks.datastructures.unitycatalog.TableType](#databricksdatastructuresunitycatalogtabletype)
          * [databricks.datastructures.unitycatalog.TableType.TableType](#databricksdatastructuresunitycatalogtabletypetabletype)
        * [databricks.datastructures.unitycatalog.UpdateAction](#databricksdatastructuresunitycatalogupdateaction)
          * [databricks.datastructures.unitycatalog.UpdateAction.UpdateAction](#databricksdatastructuresunitycatalogupdateactionupdateaction)
        * [databricks.datastructures.unitycatalog.VolumeInfo](#databricksdatastructuresunitycatalogvolumeinfo)
          * [databricks.datastructures.unitycatalog.VolumeInfo.VolumeInfo](#databricksdatastructuresunitycatalogvolumeinfovolumeinfo)
          * [databricks.datastructures.unitycatalog.VolumeInfo.fromInputs](#databricksdatastructuresunitycatalogvolumeinfofrominputs)
        * [databricks.datastructures.unitycatalog.VolumeType](#databricksdatastructuresunitycatalogvolumetype)
          * [databricks.datastructures.unitycatalog.VolumeType.VolumeType](#databricksdatastructuresunitycatalogvolumetypevolumetype)
      * [databricks.datastructures.Channel](#databricksdatastructureschannel)
        * [databricks.datastructures.Channel.Channel](#databricksdatastructureschannelchannel)
      * [databricks.datastructures.ChannelName](#databricksdatastructureschannelname)
        * [databricks.datastructures.ChannelName.ChannelName](#databricksdatastructureschannelnamechannelname)
      * [databricks.datastructures.DataSecurityMode](#databricksdatastructuresdatasecuritymode)
        * [databricks.datastructures.DataSecurityMode.DataSecurityMode](#databricksdatastructuresdatasecuritymodedatasecuritymode)
      * [databricks.datastructures.DbfsStorageInfo](#databricksdatastructuresdbfsstorageinfo)
        * [databricks.datastructures.DbfsStorageInfo.DbfsStorageInfo](#databricksdatastructuresdbfsstorageinfodbfsstorageinfo)
      * [databricks.datastructures.DockerBasicAuth](#databricksdatastructuresdockerbasicauth)
        * [databricks.datastructures.DockerBasicAuth.DockerBasicAuth](#databricksdatastructuresdockerbasicauthdockerbasicauth)
      * [databricks.datastructures.DockerImage](#databricksdatastructuresdockerimage)
        * [databricks.datastructures.DockerImage.DockerImage](#databricksdatastructuresdockerimagedockerimage)
      * [databricks.datastructures.ErrorResponse](#databricksdatastructureserrorresponse)
        * [databricks.datastructures.ErrorResponse.ErrorResponse](#databricksdatastructureserrorresponseerrorresponse)
        * [databricks.datastructures.ErrorResponse.throw](#databricksdatastructureserrorresponsethrow)
      * [databricks.datastructures.FileInfo](#databricksdatastructuresfileinfo)
        * [databricks.datastructures.FileInfo.FileInfo](#databricksdatastructuresfileinfofileinfo)
        * [databricks.datastructures.FileInfo.fromJSON](#databricksdatastructuresfileinfofromjson)
        * [databricks.datastructures.FileInfo.table](#databricksdatastructuresfileinfotable)
      * [databricks.datastructures.FileStorageInfo](#databricksdatastructuresfilestorageinfo)
        * [databricks.datastructures.FileStorageInfo.FileStorageInfo](#databricksdatastructuresfilestorageinfofilestorageinfo)
      * [databricks.datastructures.NotebookOutput](#databricksdatastructuresnotebookoutput)
        * [databricks.datastructures.NotebookOutput.NotebookOutput](#databricksdatastructuresnotebookoutputnotebookoutput)
      * [databricks.datastructures.ODBCParams](#databricksdatastructuresodbcparams)
        * [databricks.datastructures.ODBCParams.ODBCParams](#databricksdatastructuresodbcparamsodbcparams)
      * [databricks.datastructures.ObjectInfo](#databricksdatastructuresobjectinfo)
        * [databricks.datastructures.ObjectInfo.ObjectInfo](#databricksdatastructuresobjectinfoobjectinfo)
        * [databricks.datastructures.ObjectInfo.fromJSON](#databricksdatastructuresobjectinfofromjson)
        * [databricks.datastructures.ObjectInfo.table](#databricksdatastructuresobjectinfotable)
      * [databricks.datastructures.ObjectType](#databricksdatastructuresobjecttype)
        * [databricks.datastructures.ObjectType.ObjectType](#databricksdatastructuresobjecttypeobjecttype)
      * [databricks.datastructures.RuntimeEngine](#databricksdatastructuresruntimeengine)
        * [databricks.datastructures.RuntimeEngine.RuntimeEngine](#databricksdatastructuresruntimeengineruntimeengine)
      * [databricks.datastructures.S3StorageInfo](#databricksdatastructuress3storageinfo)
        * [databricks.datastructures.S3StorageInfo.S3StorageInfo](#databricksdatastructuress3storageinfos3storageinfo)
      * [databricks.datastructures.WarehouseHealth](#databricksdatastructureswarehousehealth)
        * [databricks.datastructures.WarehouseHealth.WarehouseHealth](#databricksdatastructureswarehousehealthwarehousehealth)
      * [databricks.datastructures.WarehouseSpotInstancePolicy](#databricksdatastructureswarehousespotinstancepolicy)
        * [databricks.datastructures.WarehouseSpotInstancePolicy.WarehouseSpotInstancePolicy](#databricksdatastructureswarehousespotinstancepolicywarehousespotinstancepolicy)
      * [databricks.datastructures.WarehouseState](#databricksdatastructureswarehousestate)
        * [databricks.datastructures.WarehouseState.WarehouseState](#databricksdatastructureswarehousestatewarehousestate)
      * [databricks.datastructures.WarehouseStatus](#databricksdatastructureswarehousestatus)
        * [databricks.datastructures.WarehouseStatus.WarehouseStatus](#databricksdatastructureswarehousestatuswarehousestatus)
      * [databricks.datastructures.WarehouseTagPair](#databricksdatastructureswarehousetagpair)
        * [databricks.datastructures.WarehouseTagPair.WarehouseTagPair](#databricksdatastructureswarehousetagpairwarehousetagpair)
      * [databricks.datastructures.WarehouseTags](#databricksdatastructureswarehousetags)
        * [databricks.datastructures.WarehouseTags.WarehouseTags](#databricksdatastructureswarehousetagswarehousetags)
        * [databricks.datastructures.WarehouseTags.jsonencode](#databricksdatastructureswarehousetagsjsonencode)
      * [databricks.datastructures.WarehouseType](#databricksdatastructureswarehousetype)
        * [databricks.datastructures.WarehouseType.WarehouseType](#databricksdatastructureswarehousetypewarehousetype)
      * [databricks.datastructures.WorkspaceStorageInfo](#databricksdatastructuresworkspacestorageinfo)
        * [databricks.datastructures.WorkspaceStorageInfo.WorkspaceStorageInfo](#databricksdatastructuresworkspacestorageinfoworkspacestorageinfo)
    * [databricks.internal](#databricksinternal)
      * [databricks.internal.checks](#databricksinternalchecks)
        * [databricks.internal.checks.checkCompiler](#databricksinternalcheckscheckcompiler)
        * [databricks.internal.checks.checkCompilerSDK](#databricksinternalcheckscheckcompilersdk)
        * [databricks.internal.checks.checkDatabaseToolbox](#databricksinternalcheckscheckdatabasetoolbox)
        * [databricks.internal.checks.checkJavaBuilder](#databricksinternalcheckscheckjavabuilder)
        * [databricks.internal.checks.checkJavaUserHome](#databricksinternalcheckscheckjavauserhome)
        * [databricks.internal.checks.setBase64Pref](#databricksinternalcheckssetbase64pref)
      * [databricks.internal.cluster](#databricksinternalcluster)
        * [databricks.internal.cluster.downloadLogs](#databricksinternalclusterdownloadlogs)
        * [databricks.internal.cluster.getClusterIdFromClusterOrId](#databricksinternalclustergetclusteridfromclusterorid)
        * [databricks.internal.cluster.getClusterIdFromClusterOrIdImpl](#databricksinternalclustergetclusteridfromclusteroridimpl)
        * [databricks.internal.cluster.getClusterRuntimeVersion](#databricksinternalclustergetclusterruntimeversion)
        * [databricks.internal.cluster.getClusterRuntimeVersionImpl](#databricksinternalclustergetclusterruntimeversionimpl)
        * [databricks.internal.cluster.getDefaultSparkVersion](#databricksinternalclustergetdefaultsparkversion)
        * [databricks.internal.cluster.getDefaultSparkVersionImpl](#databricksinternalclustergetdefaultsparkversionimpl)
        * [databricks.internal.cluster.getSparkBaseVersion](#databricksinternalclustergetsparkbaseversion)
        * [databricks.internal.cluster.getSparkBaseVersionImpl](#databricksinternalclustergetsparkbaseversionimpl)
        * [databricks.internal.cluster.isAptPermittedOnCluster](#databricksinternalclusterisaptpermittedoncluster)
        * [databricks.internal.cluster.isGitHubReadableByCluster](#databricksinternalclusterisgithubreadablebycluster)
        * [databricks.internal.cluster.isInitScriptOnAllowlist](#databricksinternalclusterisinitscriptonallowlist)
        * [databricks.internal.cluster.isInitscriptSupported](#databricksinternalclusterisinitscriptsupported)
        * [databricks.internal.cluster.isJarOnAllowlist](#databricksinternalclusterisjaronallowlist)
        * [databricks.internal.cluster.isJobCluster](#databricksinternalclusterisjobcluster)
        * [databricks.internal.cluster.isJobsSupported](#databricksinternalclusterisjobssupported)
        * [databricks.internal.cluster.isLibraryPolicySet](#databricksinternalclusterislibrarypolicyset)
        * [databricks.internal.cluster.isLibrarySupported](#databricksinternalclusterislibrarysupported)
        * [databricks.internal.cluster.isNotebooksSupported](#databricksinternalclusterisnotebookssupported)
        * [databricks.internal.cluster.isPyPIReadableByCluster](#databricksinternalclusterispypireadablebycluster)
        * [databricks.internal.cluster.isRuntimeDownloadableByCluster](#databricksinternalclusterisruntimedownloadablebycluster)
        * [databricks.internal.cluster.mustBeScalarClusterOrId](#databricksinternalclustermustbescalarclusterorid)
        * [databricks.internal.cluster.mustBeScalarClusterOrIdImpl](#databricksinternalclustermustbescalarclusteroridimpl)
        * [databricks.internal.cluster.startCluster](#databricksinternalclusterstartcluster)
        * [databricks.internal.cluster.startClusterImpl](#databricksinternalclusterstartclusterimpl)
        * [databricks.internal.cluster.waitForClusterToStart](#databricksinternalclusterwaitforclustertostart)
        * [databricks.internal.cluster.waitForClusterToStartImpl](#databricksinternalclusterwaitforclustertostartimpl)
      * [databricks.internal.commandexecution](#databricksinternalcommandexecution)
        * [databricks.internal.commandexecution.cancelCommand](#databricksinternalcommandexecutioncancelcommand)
        * [databricks.internal.commandexecution.commandStatus](#databricksinternalcommandexecutioncommandstatus)
        * [databricks.internal.commandexecution.executePythonCommand](#databricksinternalcommandexecutionexecutepythoncommand)
        * [databricks.internal.commandexecution.executePythonSubprocess](#databricksinternalcommandexecutionexecutepythonsubprocess)
        * [databricks.internal.commandexecution.waitForCommandFinished](#databricksinternalcommandexecutionwaitforcommandfinished)
        * [databricks.internal.commandexecution.waitForContextRunning](#databricksinternalcommandexecutionwaitforcontextrunning)
      * [databricks.internal.configurationprofile](#databricksinternalconfigurationprofile)
        * [databricks.internal.configurationprofile.ConfigFile](#databricksinternalconfigurationprofileconfigfile)
          * [databricks.internal.configurationprofile.ConfigFile.ConfigFile](#databricksinternalconfigurationprofileconfigfileconfigfile)
          * [databricks.internal.configurationprofile.ConfigFile.cfgFileWithMaskedTokens](#databricksinternalconfigurationprofileconfigfilecfgfilewithmaskedtokens)
          * [databricks.internal.configurationprofile.ConfigFile.deleteProfileField](#databricksinternalconfigurationprofileconfigfiledeleteprofilefield)
          * [databricks.internal.configurationprofile.ConfigFile.getAllProfiles](#databricksinternalconfigurationprofileconfigfilegetallprofiles)
          * [databricks.internal.configurationprofile.ConfigFile.getCfgFilePath](#databricksinternalconfigurationprofileconfigfilegetcfgfilepath)
          * [databricks.internal.configurationprofile.ConfigFile.getDefaultProfile](#databricksinternalconfigurationprofileconfigfilegetdefaultprofile)
          * [databricks.internal.configurationprofile.ConfigFile.getDefaultProfileName](#databricksinternalconfigurationprofileconfigfilegetdefaultprofilename)
          * [databricks.internal.configurationprofile.ConfigFile.getEnvVarValue](#databricksinternalconfigurationprofileconfigfilegetenvvarvalue)
          * [databricks.internal.configurationprofile.ConfigFile.getInstanceDefaultProfileName](#databricksinternalconfigurationprofileconfigfilegetinstancedefaultprofilename)
          * [databricks.internal.configurationprofile.ConfigFile.getProfile](#databricksinternalconfigurationprofileconfigfilegetprofile)
          * [databricks.internal.configurationprofile.ConfigFile.getProfileField](#databricksinternalconfigurationprofileconfigfilegetprofilefield)
          * [databricks.internal.configurationprofile.ConfigFile.isDatabricksCfgFile](#databricksinternalconfigurationprofileconfigfileisdatabrickscfgfile)
          * [databricks.internal.configurationprofile.ConfigFile.isProfile](#databricksinternalconfigurationprofileconfigfileisprofile)
          * [databricks.internal.configurationprofile.ConfigFile.listProfiles](#databricksinternalconfigurationprofileconfigfilelistprofiles)
          * [databricks.internal.configurationprofile.ConfigFile.merge](#databricksinternalconfigurationprofileconfigfilemerge)
          * [databricks.internal.configurationprofile.ConfigFile.writeProfileField](#databricksinternalconfigurationprofileconfigfilewriteprofilefield)
          * [databricks.internal.configurationprofile.ConfigFile.writeProfiles](#databricksinternalconfigurationprofileconfigfilewriteprofiles)
        * [databricks.internal.configurationprofile.Profile](#databricksinternalconfigurationprofileprofile)
          * [databricks.internal.configurationprofile.Profile.Profile](#databricksinternalconfigurationprofileprofileprofile)
          * [databricks.internal.configurationprofile.Profile.getValue](#databricksinternalconfigurationprofileprofilegetvalue)
          * [databricks.internal.configurationprofile.Profile.isKey](#databricksinternalconfigurationprofileprofileiskey)
          * [databricks.internal.configurationprofile.Profile.keys](#databricksinternalconfigurationprofileprofilekeys)
          * [databricks.internal.configurationprofile.Profile.remove](#databricksinternalconfigurationprofileprofileremove)
          * [databricks.internal.configurationprofile.Profile.setValue](#databricksinternalconfigurationprofileprofilesetvalue)
          * [databricks.internal.configurationprofile.Profile.setValueFromEnvironment](#databricksinternalconfigurationprofileprofilesetvaluefromenvironment)
          * [databricks.internal.configurationprofile.Profile.toString](#databricksinternalconfigurationprofileprofiletostring)
          * [databricks.internal.configurationprofile.Profile.values](#databricksinternalconfigurationprofileprofilevalues)
      * [databricks.internal.databricksConnect](#databricksinternaldatabricksconnect)
        * [databricks.internal.databricksConnect.getDBCClientVersion](#databricksinternaldatabricksconnectgetdbcclientversion)
        * [databricks.internal.databricksConnect.getDBCClientVersionImpl](#databricksinternaldatabricksconnectgetdbcclientversionimpl)
        * [databricks.internal.databricksConnect.getDBCVersions](#databricksinternaldatabricksconnectgetdbcversions)
        * [databricks.internal.databricksConnect.getLatestDBCVersion](#databricksinternaldatabricksconnectgetlatestdbcversion)
        * [databricks.internal.databricksConnect.getPyDatabricksConnectVersion](#databricksinternaldatabricksconnectgetpydatabricksconnectversion)
        * [databricks.internal.databricksConnect.isDatabricksConnectv2Version](#databricksinternaldatabricksconnectisdatabricksconnectv2version)
        * [databricks.internal.databricksConnect.sortDBVersions](#databricksinternaldatabricksconnectsortdbversions)
      * [databricks.internal.files](#databricksinternalfiles)
        * [databricks.internal.files.download](#databricksinternalfilesdownload)
      * [databricks.internal.genie](#databricksinternalgenie)
        * [databricks.internal.genie.statementResponse2Table](#databricksinternalgeniestatementresponse2table)
      * [databricks.internal.instancepool](#databricksinternalinstancepool)
        * [databricks.internal.instancepool.cloneFromCluster](#databricksinternalinstancepoolclonefromcluster)
      * [databricks.internal.io](#databricksinternalio)
        * [databricks.internal.io.FileSystemType](#databricksinternaliofilesystemtype)
          * [databricks.internal.io.FileSystemType.FileSystemType](#databricksinternaliofilesystemtypefilesystemtype)
        * [databricks.internal.io.IO](#databricksinternalioio)
          * [databricks.internal.io.IO.IO](#databricksinternalioioio)
          * [databricks.internal.io.IO.dir](#databricksinternalioiodir)
          * [databricks.internal.io.IO.download](#databricksinternalioiodownload)
          * [databricks.internal.io.IO.fileparts](#databricksinternalioiofileparts)
          * [databricks.internal.io.IO.getType](#databricksinternalioiogettype)
          * [databricks.internal.io.IO.isfile](#databricksinternalioioisfile)
          * [databricks.internal.io.IO.isfolder](#databricksinternalioioisfolder)
          * [databricks.internal.io.IO.mkdir](#databricksinternalioiomkdir)
          * [databricks.internal.io.IO.stripTrailingSlashes](#databricksinternalioiostriptrailingslashes)
          * [databricks.internal.io.IO.upload](#databricksinternalioioupload)
      * [databricks.internal.job](#databricksinternaljob)
        * [databricks.internal.job.runNotebookJob](#databricksinternaljobrunnotebookjob)
        * [databricks.internal.job.waitForJob](#databricksinternaljobwaitforjob)
      * [databricks.internal.mlRuntime](#databricksinternalmlruntime)
        * [databricks.internal.mlRuntime.getLatestJavabuilder](#databricksinternalmlruntimegetlatestjavabuilder)
        * [databricks.internal.mlRuntime.getLatestRuntime](#databricksinternalmlruntimegetlatestruntime)
        * [databricks.internal.mlRuntime.getMATLABRuntimeDownloadURL](#databricksinternalmlruntimegetmatlabruntimedownloadurl)
        * [databricks.internal.mlRuntime.runtimeExists](#databricksinternalmlruntimeruntimeexists)
        * [databricks.internal.mlRuntime.runtimeReleaseExists](#databricksinternalmlruntimeruntimereleaseexists)
      * [databricks.internal.run](#databricksinternalrun)
        * [databricks.internal.run.waitForRunStatus](#databricksinternalrunwaitforrunstatus)
      * [databricks.internal.runjobs](#databricksinternalrunjobs)
        * [databricks.internal.runjobs.Job](#databricksinternalrunjobsjob)
          * [databricks.internal.runjobs.Job.Job](#databricksinternalrunjobsjobjob)
          * [databricks.internal.runjobs.Job.buildArtifact](#databricksinternalrunjobsjobbuildartifact)
          * [databricks.internal.runjobs.Job.getDBFSFolders](#databricksinternalrunjobsjobgetdbfsfolders)
          * [databricks.internal.runjobs.Job.getDescription](#databricksinternalrunjobsjobgetdescription)
          * [databricks.internal.runjobs.Job.getLibType](#databricksinternalrunjobsjobgetlibtype)
          * [databricks.internal.runjobs.Job.getNumNotebooks](#databricksinternalrunjobsjobgetnumnotebooks)
          * [databricks.internal.runjobs.Job.getSuffix](#databricksinternalrunjobsjobgetsuffix)
          * [databricks.internal.runjobs.Job.getUniqueName](#databricksinternalrunjobsjobgetuniquename)
          * [databricks.internal.runjobs.Job.getWorkspaceName](#databricksinternalrunjobsjobgetworkspacename)
          * [databricks.internal.runjobs.Job.isPython](#databricksinternalrunjobsjobispython)
          * [databricks.internal.runjobs.Job.isScala](#databricksinternalrunjobsjobisscala)
          * [databricks.internal.runjobs.Job.table](#databricksinternalrunjobsjobtable)
          * [databricks.internal.runjobs.Job.uploadArtifact](#databricksinternalrunjobsjobuploadartifact)
          * [databricks.internal.runjobs.Job.uploadNotebook](#databricksinternalrunjobsjobuploadnotebook)
        * [databricks.internal.runjobs.JobTester](#databricksinternalrunjobsjobtester)
          * [databricks.internal.runjobs.JobTester.JobTester](#databricksinternalrunjobsjobtesterjobtester)
          * [databricks.internal.runjobs.JobTester.buildAndUploadJobs](#databricksinternalrunjobsjobtesterbuildanduploadjobs)
          * [databricks.internal.runjobs.JobTester.buildArtifacts](#databricksinternalrunjobsjobtesterbuildartifacts)
          * [databricks.internal.runjobs.JobTester.createJobs](#databricksinternalrunjobsjobtestercreatejobs)
          * [databricks.internal.runjobs.JobTester.createTasksJob](#databricksinternalrunjobsjobtestercreatetasksjob)
          * [databricks.internal.runjobs.JobTester.deployJobs](#databricksinternalrunjobsjobtesterdeployjobs)
          * [databricks.internal.runjobs.JobTester.getJobName](#databricksinternalrunjobsjobtestergetjobname)
          * [databricks.internal.runjobs.JobTester.getOrCreateInstance](#databricksinternalrunjobsjobtestergetorcreateinstance)
          * [databricks.internal.runjobs.JobTester.isEnabled](#databricksinternalrunjobsjobtesterisenabled)
          * [databricks.internal.runjobs.JobTester.saveMatFile](#databricksinternalrunjobsjobtestersavematfile)
          * [databricks.internal.runjobs.JobTester.saveTarFile](#databricksinternalrunjobsjobtestersavetarfile)
          * [databricks.internal.runjobs.JobTester.slCompilerEnabled](#databricksinternalrunjobsjobtesterslcompilerenabled)
          * [databricks.internal.runjobs.JobTester.staticBuildArtifacts](#databricksinternalrunjobsjobtesterstaticbuildartifacts)
          * [databricks.internal.runjobs.JobTester.staticDeployPrebuiltJobs](#databricksinternalrunjobsjobtesterstaticdeployprebuiltjobs)
          * [databricks.internal.runjobs.JobTester.staticLoadFromMat](#databricksinternalrunjobsjobtesterstaticloadfrommat)
          * [databricks.internal.runjobs.JobTester.staticVerifyResults](#databricksinternalrunjobsjobtesterstaticverifyresults)
          * [databricks.internal.runjobs.JobTester.uploadArtifactsAndNotebooks](#databricksinternalrunjobsjobtesteruploadartifactsandnotebooks)
          * [databricks.internal.runjobs.JobTester.verifyResults](#databricksinternalrunjobsjobtesterverifyresults)
        * [databricks.internal.runjobs.Notebook](#databricksinternalrunjobsnotebook)
          * [databricks.internal.runjobs.Notebook.Notebook](#databricksinternalrunjobsnotebooknotebook)
          * [databricks.internal.runjobs.Notebook.getDescription](#databricksinternalrunjobsnotebookgetdescription)
          * [databricks.internal.runjobs.Notebook.getLocalArtifactLocation](#databricksinternalrunjobsnotebookgetlocalartifactlocation)
          * [databricks.internal.runjobs.Notebook.getNotebookTaskData](#databricksinternalrunjobsnotebookgetnotebooktaskdata)
          * [databricks.internal.runjobs.Notebook.getSuffix](#databricksinternalrunjobsnotebookgetsuffix)
          * [databricks.internal.runjobs.Notebook.getUniqueName](#databricksinternalrunjobsnotebookgetuniquename)
          * [databricks.internal.runjobs.Notebook.getWorkspaceName](#databricksinternalrunjobsnotebookgetworkspacename)
          * [databricks.internal.runjobs.Notebook.saveArtifacts](#databricksinternalrunjobsnotebooksaveartifacts)
          * [databricks.internal.runjobs.Notebook.uploadNotebook](#databricksinternalrunjobsnotebookuploadnotebook)
      * [databricks.internal.scope](#databricksinternalscope)
        * [databricks.internal.scope.exists](#databricksinternalscopeexists)
      * [databricks.internal.sdk](#databricksinternalsdk)
        * [databricks.internal.sdk.core](#databricksinternalsdkcore)
          * [databricks.internal.sdk.core.Config](#databricksinternalsdkcoreconfig)
            * [databricks.internal.sdk.core.Config.Config](#databricksinternalsdkcoreconfigconfig)
            * [databricks.internal.sdk.core.Config.OauthToken](#databricksinternalsdkcoreconfigoauthtoken)
            * [databricks.internal.sdk.core.Config.authenticate](#databricksinternalsdkcoreconfigauthenticate)
            * [databricks.internal.sdk.core.Config.configureAuth](#databricksinternalsdkcoreconfigconfigureauth)
            * [databricks.internal.sdk.core.Config.debugString](#databricksinternalsdkcoreconfigdebugstring)
            * [databricks.internal.sdk.core.Config.getAuthCfgMap](#databricksinternalsdkcoreconfiggetauthcfgmap)
            * [databricks.internal.sdk.core.Config.getAuthTypeCfgField](#databricksinternalsdkcoreconfiggetauthtypecfgfield)
            * [databricks.internal.sdk.core.Config.initAuth](#databricksinternalsdkcoreconfiginitauth)
            * [databricks.internal.sdk.core.Config.sdkAuth](#databricksinternalsdkcoreconfigsdkauth)
            * [databricks.internal.sdk.core.Config.toPy](#databricksinternalsdkcoreconfigtopy)
          * [databricks.internal.sdk.core.ConfigImpl](#databricksinternalsdkcoreconfigimpl)
            * [databricks.internal.sdk.core.ConfigImpl.ConfigImpl](#databricksinternalsdkcoreconfigimplconfigimpl)
            * [databricks.internal.sdk.core.ConfigImpl.OauthToken](#databricksinternalsdkcoreconfigimploauthtoken)
            * [databricks.internal.sdk.core.ConfigImpl.authenticate](#databricksinternalsdkcoreconfigimplauthenticate)
            * [databricks.internal.sdk.core.ConfigImpl.configureAuth](#databricksinternalsdkcoreconfigimplconfigureauth)
            * [databricks.internal.sdk.core.ConfigImpl.debugString](#databricksinternalsdkcoreconfigimpldebugstring)
            * [databricks.internal.sdk.core.ConfigImpl.getAuthCfgMap](#databricksinternalsdkcoreconfigimplgetauthcfgmap)
            * [databricks.internal.sdk.core.ConfigImpl.getAuthTypeCfgField](#databricksinternalsdkcoreconfigimplgetauthtypecfgfield)
            * [databricks.internal.sdk.core.ConfigImpl.initAuth](#databricksinternalsdkcoreconfigimplinitauth)
            * [databricks.internal.sdk.core.ConfigImpl.sdkAuth](#databricksinternalsdkcoreconfigimplsdkauth)
            * [databricks.internal.sdk.core.ConfigImpl.toPy](#databricksinternalsdkcoreconfigimpltopy)
        * [databricks.internal.sdk.UserAgent](#databricksinternalsdkuseragent)
          * [databricks.internal.sdk.UserAgent.UserAgent](#databricksinternalsdkuseragentuseragent)
          * [databricks.internal.sdk.UserAgent.toPy](#databricksinternalsdkuseragenttopy)
          * [databricks.internal.sdk.UserAgent.withPartner](#databricksinternalsdkuseragentwithpartner)
          * [databricks.internal.sdk.UserAgent.withProduct](#databricksinternalsdkuseragentwithproduct)
        * [databricks.internal.sdk.UserAgentImpl](#databricksinternalsdkuseragentimpl)
          * [databricks.internal.sdk.UserAgentImpl.UserAgentImpl](#databricksinternalsdkuseragentimpluseragentimpl)
          * [databricks.internal.sdk.UserAgentImpl.toPy](#databricksinternalsdkuseragentimpltopy)
          * [databricks.internal.sdk.UserAgentImpl.withPartner](#databricksinternalsdkuseragentimplwithpartner)
          * [databricks.internal.sdk.UserAgentImpl.withProduct](#databricksinternalsdkuseragentimplwithproduct)
      * [databricks.internal.secret](#databricksinternalsecret)
        * [databricks.internal.secret.create](#databricksinternalsecretcreate)
      * [databricks.internal.settings](#databricksinternalsettings)
        * [databricks.internal.settings.Settings](#databricksinternalsettingssettings)
          * [databricks.internal.settings.Settings.Settings](#databricksinternalsettingssettingssettings)
          * [databricks.internal.settings.Settings.editUserSettings](#databricksinternalsettingssettingseditusersettings)
          * [databricks.internal.settings.Settings.getDefaultSettingsFilePath](#databricksinternalsettingssettingsgetdefaultsettingsfilepath)
          * [databricks.internal.settings.Settings.getSettingsField](#databricksinternalsettingssettingsgetsettingsfield)
          * [databricks.internal.settings.Settings.getSettingsFileReadPath](#databricksinternalsettingssettingsgetsettingsfilereadpath)
          * [databricks.internal.settings.Settings.getSettingsFileWritePath](#databricksinternalsettingssettingsgetsettingsfilewritepath)
          * [databricks.internal.settings.Settings.getSettingsStruct](#databricksinternalsettingssettingsgetsettingsstruct)
          * [databricks.internal.settings.Settings.setSettingsFieldFromEnvironment](#databricksinternalsettingssettingssetsettingsfieldfromenvironment)
          * [databricks.internal.settings.Settings.writeDatabricksSettingsFields](#databricksinternalsettingssettingswritedatabrickssettingsfields)
          * [databricks.internal.settings.Settings.writeSettingsStruct](#databricksinternalsettingssettingswritesettingsstruct)
      * [databricks.internal.statementexecution](#databricksinternalstatementexecution)
        * [databricks.internal.statementexecution.executeStatement](#databricksinternalstatementexecutionexecutestatement)
        * [databricks.internal.statementexecution.executeStatementResponse2Table](#databricksinternalstatementexecutionexecutestatementresponse2table)
      * [databricks.internal.token](#databricksinternaltoken)
        * [databricks.internal.token.isTokenValid](#databricksinternaltokenistokenvalid)
      * [databricks.internal.unifiedauthentication](#databricksinternalunifiedauthentication)
        * [databricks.internal.unifiedauthentication.DotDatabricksConnect](#databricksinternalunifiedauthenticationdotdatabricksconnect)
          * [databricks.internal.unifiedauthentication.DotDatabricksConnect.DotDatabricksConnect](#databricksinternalunifiedauthenticationdotdatabricksconnectdotdatabricksconnect)
          * [databricks.internal.unifiedauthentication.DotDatabricksConnect.getDBCCfgField](#databricksinternalunifiedauthenticationdotdatabricksconnectgetdbccfgfield)
          * [databricks.internal.unifiedauthentication.DotDatabricksConnect.getDBCCfgStruct](#databricksinternalunifiedauthenticationdotdatabricksconnectgetdbccfgstruct)
          * [databricks.internal.unifiedauthentication.DotDatabricksConnect.getDBCFilePath](#databricksinternalunifiedauthenticationdotdatabricksconnectgetdbcfilepath)
          * [databricks.internal.unifiedauthentication.DotDatabricksConnect.initialize](#databricksinternalunifiedauthenticationdotdatabricksconnectinitialize)
          * [databricks.internal.unifiedauthentication.DotDatabricksConnect.inputProperty](#databricksinternalunifiedauthenticationdotdatabricksconnectinputproperty)
          * [databricks.internal.unifiedauthentication.DotDatabricksConnect.isDotDatabricksConnect](#databricksinternalunifiedauthenticationdotdatabricksconnectisdotdatabricksconnect)
          * [databricks.internal.unifiedauthentication.DotDatabricksConnect.setCfgFieldFromEnvironment](#databricksinternalunifiedauthenticationdotdatabricksconnectsetcfgfieldfromenvironment)
          * [databricks.internal.unifiedauthentication.DotDatabricksConnect.setProperty](#databricksinternalunifiedauthenticationdotdatabricksconnectsetproperty)
          * [databricks.internal.unifiedauthentication.DotDatabricksConnect.writeDBCCfgFields](#databricksinternalunifiedauthenticationdotdatabricksconnectwritedbccfgfields)
          * [databricks.internal.unifiedauthentication.DotDatabricksConnect.writeDBCCfgFile](#databricksinternalunifiedauthenticationdotdatabricksconnectwritedbccfgfile)
        * [databricks.internal.unifiedauthentication.Oauth](#databricksinternalunifiedauthenticationoauth)
          * [databricks.internal.unifiedauthentication.Oauth.Oauth](#databricksinternalunifiedauthenticationoauthoauth)
          * [databricks.internal.unifiedauthentication.Oauth.epochSecondsUTCNow](#databricksinternalunifiedauthenticationoauthepochsecondsutcnow)
          * [databricks.internal.unifiedauthentication.Oauth.genVerifierChallenge](#databricksinternalunifiedauthenticationoauthgenverifierchallenge)
          * [databricks.internal.unifiedauthentication.Oauth.getCachedAccessTokenJWT](#databricksinternalunifiedauthenticationoauthgetcachedaccesstokenjwt)
          * [databricks.internal.unifiedauthentication.Oauth.getCachedAccessTokenString](#databricksinternalunifiedauthenticationoauthgetcachedaccesstokenstring)
          * [databricks.internal.unifiedauthentication.Oauth.getCachedValue](#databricksinternalunifiedauthenticationoauthgetcachedvalue)
          * [databricks.internal.unifiedauthentication.Oauth.getDefaultCacheFilePath](#databricksinternalunifiedauthenticationoauthgetdefaultcachefilepath)
          * [databricks.internal.unifiedauthentication.Oauth.getM2MToken](#databricksinternalunifiedauthenticationoauthgetm2mtoken)
          * [databricks.internal.unifiedauthentication.Oauth.getRefreshedToken](#databricksinternalunifiedauthenticationoauthgetrefreshedtoken)
          * [databricks.internal.unifiedauthentication.Oauth.getU2MToken](#databricksinternalunifiedauthenticationoauthgetu2mtoken)
          * [databricks.internal.unifiedauthentication.Oauth.getWSAuthCode](#databricksinternalunifiedauthenticationoauthgetwsauthcode)
          * [databricks.internal.unifiedauthentication.Oauth.isTokenCachingDisabled](#databricksinternalunifiedauthenticationoauthistokencachingdisabled)
          * [databricks.internal.unifiedauthentication.Oauth.missingFieldWarning](#databricksinternalunifiedauthenticationoauthmissingfieldwarning)
          * [databricks.internal.unifiedauthentication.Oauth.oauthM2MAuth](#databricksinternalunifiedauthenticationoauthoauthm2mauth)
          * [databricks.internal.unifiedauthentication.Oauth.oauthU2MAuth](#databricksinternalunifiedauthenticationoauthoauthu2mauth)
          * [databricks.internal.unifiedauthentication.Oauth.writeTokenCache](#databricksinternalunifiedauthenticationoauthwritetokencache)
        * [databricks.internal.unifiedauthentication.OauthImpl](#databricksinternalunifiedauthenticationoauthimpl)
          * [databricks.internal.unifiedauthentication.OauthImpl.OauthImpl](#databricksinternalunifiedauthenticationoauthimploauthimpl)
          * [databricks.internal.unifiedauthentication.OauthImpl.epochSecondsUTCNow](#databricksinternalunifiedauthenticationoauthimplepochsecondsutcnow)
          * [databricks.internal.unifiedauthentication.OauthImpl.genVerifierChallenge](#databricksinternalunifiedauthenticationoauthimplgenverifierchallenge)
          * [databricks.internal.unifiedauthentication.OauthImpl.getCachedValue](#databricksinternalunifiedauthenticationoauthimplgetcachedvalue)
          * [databricks.internal.unifiedauthentication.OauthImpl.getDefaultCacheFilePath](#databricksinternalunifiedauthenticationoauthimplgetdefaultcachefilepath)
          * [databricks.internal.unifiedauthentication.OauthImpl.getM2MToken](#databricksinternalunifiedauthenticationoauthimplgetm2mtoken)
          * [databricks.internal.unifiedauthentication.OauthImpl.getRefreshedToken](#databricksinternalunifiedauthenticationoauthimplgetrefreshedtoken)
          * [databricks.internal.unifiedauthentication.OauthImpl.getU2MToken](#databricksinternalunifiedauthenticationoauthimplgetu2mtoken)
          * [databricks.internal.unifiedauthentication.OauthImpl.getWSAuthCode](#databricksinternalunifiedauthenticationoauthimplgetwsauthcode)
          * [databricks.internal.unifiedauthentication.OauthImpl.isTokenCachingDisabled](#databricksinternalunifiedauthenticationoauthimplistokencachingdisabled)
          * [databricks.internal.unifiedauthentication.OauthImpl.missingFieldWarning](#databricksinternalunifiedauthenticationoauthimplmissingfieldwarning)
          * [databricks.internal.unifiedauthentication.OauthImpl.oauthM2MAuth](#databricksinternalunifiedauthenticationoauthimploauthm2mauth)
          * [databricks.internal.unifiedauthentication.OauthImpl.oauthU2MAuth](#databricksinternalunifiedauthenticationoauthimploauthu2mauth)
          * [databricks.internal.unifiedauthentication.OauthImpl.writeTokenCache](#databricksinternalunifiedauthenticationoauthimplwritetokencache)
        * [databricks.internal.unifiedauthentication.Provider](#databricksinternalunifiedauthenticationprovider)
          * [databricks.internal.unifiedauthentication.Provider.Provider](#databricksinternalunifiedauthenticationproviderprovider)
          * [databricks.internal.unifiedauthentication.Provider.authenticate](#databricksinternalunifiedauthenticationproviderauthenticate)
          * [databricks.internal.unifiedauthentication.Provider.chainPop](#databricksinternalunifiedauthenticationproviderchainpop)
          * [databricks.internal.unifiedauthentication.Provider.oauthM2MPop](#databricksinternalunifiedauthenticationprovideroauthm2mpop)
          * [databricks.internal.unifiedauthentication.Provider.oauthU2MPop](#databricksinternalunifiedauthenticationprovideroauthu2mpop)
          * [databricks.internal.unifiedauthentication.Provider.patPop](#databricksinternalunifiedauthenticationproviderpatpop)
          * [databricks.internal.unifiedauthentication.Provider.populate](#databricksinternalunifiedauthenticationproviderpopulate)
        * [databricks.internal.unifiedauthentication.ProviderImpl](#databricksinternalunifiedauthenticationproviderimpl)
          * [databricks.internal.unifiedauthentication.ProviderImpl.ProviderImpl](#databricksinternalunifiedauthenticationproviderimplproviderimpl)
          * [databricks.internal.unifiedauthentication.ProviderImpl.authenticate](#databricksinternalunifiedauthenticationproviderimplauthenticate)
          * [databricks.internal.unifiedauthentication.ProviderImpl.chainPop](#databricksinternalunifiedauthenticationproviderimplchainpop)
          * [databricks.internal.unifiedauthentication.ProviderImpl.oauthM2MPop](#databricksinternalunifiedauthenticationproviderimploauthm2mpop)
          * [databricks.internal.unifiedauthentication.ProviderImpl.oauthU2MPop](#databricksinternalunifiedauthenticationproviderimploauthu2mpop)
          * [databricks.internal.unifiedauthentication.ProviderImpl.patPop](#databricksinternalunifiedauthenticationproviderimplpatpop)
          * [databricks.internal.unifiedauthentication.ProviderImpl.populate](#databricksinternalunifiedauthenticationproviderimplpopulate)
      * [databricks.internal.utils](#databricksinternalutils)
        * [databricks.internal.utils.deleteDBFSFolders](#databricksinternalutilsdeletedbfsfolders)
        * [databricks.internal.utils.deleteJobs](#databricksinternalutilsdeletejobs)
        * [databricks.internal.utils.deleteUnitTestData](#databricksinternalutilsdeleteunittestdata)
        * [databricks.internal.utils.deleteWorkspaces](#databricksinternalutilsdeleteworkspaces)
        * [databricks.internal.utils.largeFileDBFSUpload](#databricksinternalutilslargefiledbfsupload)
        * [databricks.internal.utils.newVersionCheck](#databricksinternalutilsnewversioncheck)
        * [databricks.internal.utils.newVersionCheckImpl](#databricksinternalutilsnewversioncheckimpl)
        * [databricks.internal.utils.prettyStackTrace](#databricksinternalutilsprettystacktrace)
        * [databricks.internal.utils.runtimeDBFSUpload](#databricksinternalutilsruntimedbfsupload)
      * [databricks.internal.workspace](#databricksinternalworkspace)
        * [databricks.internal.workspace.download](#databricksinternalworkspacedownload)
        * [databricks.internal.workspace.exist](#databricksinternalworkspaceexist)
      * [databricks.internal.BenchmarkRunner](#databricksinternalbenchmarkrunner)
        * [databricks.internal.BenchmarkRunner.BenchmarkRunner](#databricksinternalbenchmarkrunnerbenchmarkrunner)
        * [databricks.internal.BenchmarkRunner.build](#databricksinternalbenchmarkrunnerbuild)
        * [databricks.internal.BenchmarkRunner.createTasks](#databricksinternalbenchmarkrunnercreatetasks)
        * [databricks.internal.BenchmarkRunner.getCluster](#databricksinternalbenchmarkrunnergetcluster)
        * [databricks.internal.BenchmarkRunner.getConfigurations](#databricksinternalbenchmarkrunnergetconfigurations)
        * [databricks.internal.BenchmarkRunner.getJavabuilder](#databricksinternalbenchmarkrunnergetjavabuilder)
        * [databricks.internal.BenchmarkRunner.getLibraries](#databricksinternalbenchmarkrunnergetlibraries)
        * [databricks.internal.BenchmarkRunner.getMachineTypes](#databricksinternalbenchmarkrunnergetmachinetypes)
        * [databricks.internal.BenchmarkRunner.getNotebook](#databricksinternalbenchmarkrunnergetnotebook)
        * [databricks.internal.BenchmarkRunner.getPkgType](#databricksinternalbenchmarkrunnergetpkgtype)
        * [databricks.internal.BenchmarkRunner.getWorkspaceName](#databricksinternalbenchmarkrunnergetworkspacename)
        * [databricks.internal.BenchmarkRunner.init](#databricksinternalbenchmarkrunnerinit)
        * [databricks.internal.BenchmarkRunner.runBenchmark](#databricksinternalbenchmarkrunnerrunbenchmark)
        * [databricks.internal.BenchmarkRunner.uploadNotebook](#databricksinternalbenchmarkrunneruploadnotebook)
        * [databricks.internal.BenchmarkRunner.uploadPackage](#databricksinternalbenchmarkrunneruploadpackage)
      * [databricks.internal.Cluster](#databricksinternalcluster)
        * [databricks.internal.Cluster.Cluster](#databricksinternalclustercluster)
        * [databricks.internal.Cluster.findById](#databricksinternalclusterfindbyid)
        * [databricks.internal.Cluster.findByName](#databricksinternalclusterfindbyname)
        * [databricks.internal.Cluster.getClusterVersionSemVer](#databricksinternalclustergetclusterversionsemver)
        * [databricks.internal.Cluster.getClusterVersionString](#databricksinternalclustergetclusterversionstring)
        * [databricks.internal.Cluster.getNodeTypes](#databricksinternalclustergetnodetypes)
        * [databricks.internal.Cluster.getSparkVersions](#databricksinternalclustergetsparkversions)
        * [databricks.internal.Cluster.list](#databricksinternalclusterlist)
        * [databricks.internal.Cluster.setAutoterminationMinutes](#databricksinternalclustersetautoterminationminutes)
        * [databricks.internal.Cluster.setPolicyId](#databricksinternalclustersetpolicyid)
        * [databricks.internal.Cluster.setSparkConf](#databricksinternalclustersetsparkconf)
        * [databricks.internal.Cluster.setSparkEnvVars](#databricksinternalclustersetsparkenvvars)
      * [databricks.internal.DatabricksPathHelper](#databricksinternaldatabrickspathhelper)
        * [databricks.internal.DatabricksPathHelper.DatabricksPathHelper](#databricksinternaldatabrickspathhelperdatabrickspathhelper)
        * [databricks.internal.DatabricksPathHelper.ensureEndsWithSlash](#databricksinternaldatabrickspathhelperensureendswithslash)
        * [databricks.internal.DatabricksPathHelper.get](#databricksinternaldatabrickspathhelperget)
        * [databricks.internal.DatabricksPathHelper.getDBFSDirPath](#databricksinternaldatabrickspathhelpergetdbfsdirpath)
        * [databricks.internal.DatabricksPathHelper.init](#databricksinternaldatabrickspathhelperinit)
      * [databricks.internal.Object](#databricksinternalobject)
        * [databricks.internal.Object.Object](#databricksinternalobjectobject)
        * [databricks.internal.Object.addStructureAsDynProps](#databricksinternalobjectaddstructureasdynprops)
        * [databricks.internal.Object.epochToTimestamp](#databricksinternalobjectepochtotimestamp)
        * [databricks.internal.Object.getAuth](#databricksinternalobjectgetauth)
        * [databricks.internal.Object.getAuthorizationField](#databricksinternalobjectgetauthorizationfield)
        * [databricks.internal.Object.getRequestMessage](#databricksinternalobjectgetrequestmessage)
        * [databricks.internal.Object.getURI](#databricksinternalobjectgeturi)
        * [databricks.internal.Object.getUserAgent](#databricksinternalobjectgetuseragent)
        * [databricks.internal.Object.isPreview](#databricksinternalobjectispreview)
        * [databricks.internal.Object.rmpropif](#databricksinternalobjectrmpropif)
        * [databricks.internal.Object.sanitizeHost](#databricksinternalobjectsanitizehost)
        * [databricks.internal.Object.setprop](#databricksinternalobjectsetprop)
      * [databricks.internal.PySparkSession](#databricksinternalpysparksession)
        * [databricks.internal.PySparkSession.PySparkSession](#databricksinternalpysparksessionpysparksession)
        * [databricks.internal.PySparkSession.getPropertyGroups](#databricksinternalpysparksessiongetpropertygroups)
      * [databricks.internal.SparkConfPair](#databricksinternalsparkconfpair)
        * [databricks.internal.SparkConfPair.SparkConfPair](#databricksinternalsparkconfpairsparkconfpair)
        * [databricks.internal.SparkConfPair.add](#databricksinternalsparkconfpairadd)
      * [databricks.internal.SparkEnvPair](#databricksinternalsparkenvpair)
        * [databricks.internal.SparkEnvPair.SparkEnvPair](#databricksinternalsparkenvpairsparkenvpair)
        * [databricks.internal.SparkEnvPair.add](#databricksinternalsparkenvpairadd)
      * [databricks.internal.WorkspaceConf](#databricksinternalworkspaceconf)
        * [databricks.internal.WorkspaceConf.WorkspaceConf](#databricksinternalworkspaceconfworkspaceconf)
        * [databricks.internal.WorkspaceConf.check](#databricksinternalworkspaceconfcheck)
        * [databricks.internal.WorkspaceConf.getOrgId](#databricksinternalworkspaceconfgetorgid)
      * [databricks.internal.cleanPath](#databricksinternalcleanpath)
      * [databricks.internal.downloadNotebooksRecursively](#databricksinternaldownloadnotebooksrecursively)
      * [databricks.internal.edit](#databricksinternaledit)
      * [databricks.internal.getFilteredSparkVersions](#databricksinternalgetfilteredsparkversions)
      * [databricks.internal.getFilteredSparkVersionsImpl](#databricksinternalgetfilteredsparkversionsimpl)
      * [databricks.internal.getHTTPOptions](#databricksinternalgethttpoptions)
      * [databricks.internal.getHTTPOptionsImpl](#databricksinternalgethttpoptionsimpl)
      * [databricks.internal.isOnDatabricks](#databricksinternalisondatabricks)
      * [databricks.internal.isOnDatabricksImpl](#databricksinternalisondatabricksimpl)
      * [databricks.internal.runMATLABTask](#databricksinternalrunmatlabtask)
      * [databricks.internal.runSparkPythonTaskExample](#databricksinternalrunsparkpythontaskexample)
    * [databricks.statementexecution](#databricksstatementexecution)
      * [databricks.statementexecution.api](#databricksstatementexecutionapi)
        * [databricks.statementexecution.api.StatementExecution](#databricksstatementexecutionapistatementexecution)
          * [databricks.statementexecution.api.StatementExecution.StatementExecution](#databricksstatementexecutionapistatementexecutionstatementexecution)
          * [databricks.statementexecution.api.StatementExecution.cancelExecution](#databricksstatementexecutionapistatementexecutioncancelexecution)
          * [databricks.statementexecution.api.StatementExecution.executeStatement](#databricksstatementexecutionapistatementexecutionexecutestatement)
          * [databricks.statementexecution.api.StatementExecution.getStatement](#databricksstatementexecutionapistatementexecutiongetstatement)
          * [databricks.statementexecution.api.StatementExecution.getStatementResultChunkN](#databricksstatementexecutionapistatementexecutiongetstatementresultchunkn)
      * [databricks.statementexecution.models](#databricksstatementexecutionmodels)
        * [databricks.statementexecution.models.Chunk](#databricksstatementexecutionmodelschunk)
          * [databricks.statementexecution.models.Chunk.Chunk](#databricksstatementexecutionmodelschunkchunk)
        * [databricks.statementexecution.models.ChunkInfo](#databricksstatementexecutionmodelschunkinfo)
          * [databricks.statementexecution.models.ChunkInfo.ChunkInfo](#databricksstatementexecutionmodelschunkinfochunkinfo)
        * [databricks.statementexecution.models.ColumnInfo](#databricksstatementexecutionmodelscolumninfo)
          * [databricks.statementexecution.models.ColumnInfo.ColumnInfo](#databricksstatementexecutionmodelscolumninfocolumninfo)
        * [databricks.statementexecution.models.ColumnInfoType_nameEnum](#databricksstatementexecutionmodelscolumninfotype_nameenum)
          * [databricks.statementexecution.models.ColumnInfoType_nameEnum.ColumnInfoType_nameEnum](#databricksstatementexecutionmodelscolumninfotype_nameenumcolumninfotype_nameenum)
        * [databricks.statementexecution.models.Disposition](#databricksstatementexecutionmodelsdisposition)
          * [databricks.statementexecution.models.Disposition.Disposition](#databricksstatementexecutionmodelsdispositiondisposition)
        * [databricks.statementexecution.models.ExecuteStatementRequest](#databricksstatementexecutionmodelsexecutestatementrequest)
          * [databricks.statementexecution.models.ExecuteStatementRequest.ExecuteStatementRequest](#databricksstatementexecutionmodelsexecutestatementrequestexecutestatementrequest)
        * [databricks.statementexecution.models.ExternalLink](#databricksstatementexecutionmodelsexternallink)
          * [databricks.statementexecution.models.ExternalLink.ExternalLink](#databricksstatementexecutionmodelsexternallinkexternallink)
        * [databricks.statementexecution.models.Format](#databricksstatementexecutionmodelsformat)
          * [databricks.statementexecution.models.Format.Format](#databricksstatementexecutionmodelsformatformat)
        * [databricks.statementexecution.models.FreeFormObject](#databricksstatementexecutionmodelsfreeformobject)
          * [databricks.statementexecution.models.FreeFormObject.FreeFormObject](#databricksstatementexecutionmodelsfreeformobjectfreeformobject)
        * [databricks.statementexecution.models.ResultData](#databricksstatementexecutionmodelsresultdata)
          * [databricks.statementexecution.models.ResultData.ResultData](#databricksstatementexecutionmodelsresultdataresultdata)
        * [databricks.statementexecution.models.ResultManifest](#databricksstatementexecutionmodelsresultmanifest)
          * [databricks.statementexecution.models.ResultManifest.ResultManifest](#databricksstatementexecutionmodelsresultmanifestresultmanifest)
        * [databricks.statementexecution.models.ResultSchema](#databricksstatementexecutionmodelsresultschema)
          * [databricks.statementexecution.models.ResultSchema.ResultSchema](#databricksstatementexecutionmodelsresultschemaresultschema)
        * [databricks.statementexecution.models.ServiceError](#databricksstatementexecutionmodelsserviceerror)
          * [databricks.statementexecution.models.ServiceError.ServiceError](#databricksstatementexecutionmodelsserviceerrorserviceerror)
        * [databricks.statementexecution.models.ServiceErrorCode](#databricksstatementexecutionmodelsserviceerrorcode)
          * [databricks.statementexecution.models.ServiceErrorCode.ServiceErrorCode](#databricksstatementexecutionmodelsserviceerrorcodeserviceerrorcode)
        * [databricks.statementexecution.models.StatementState](#databricksstatementexecutionmodelsstatementstate)
          * [databricks.statementexecution.models.StatementState.StatementState](#databricksstatementexecutionmodelsstatementstatestatementstate)
        * [databricks.statementexecution.models.StatementStatus](#databricksstatementexecutionmodelsstatementstatus)
          * [databricks.statementexecution.models.StatementStatus.StatementStatus](#databricksstatementexecutionmodelsstatementstatusstatementstatus)
        * [databricks.statementexecution.models.TimeoutAction](#databricksstatementexecutionmodelstimeoutaction)
          * [databricks.statementexecution.models.TimeoutAction.TimeoutAction](#databricksstatementexecutionmodelstimeoutactiontimeoutaction)
        * [databricks.statementexecution.models.executeStatement_200_response](#databricksstatementexecutionmodelsexecutestatement_200_response)
          * [databricks.statementexecution.models.executeStatement_200_response.executeStatement_200_response](#databricksstatementexecutionmodelsexecutestatement_200_responseexecutestatement_200_response)
      * [databricks.statementexecution.BaseClient](#databricksstatementexecutionbaseclient)
        * [databricks.statementexecution.BaseClient.BaseClient](#databricksstatementexecutionbaseclientbaseclient)
        * [databricks.statementexecution.BaseClient.applyCookies](#databricksstatementexecutionbaseclientapplycookies)
        * [databricks.statementexecution.BaseClient.getPropertyGroups](#databricksstatementexecutionbaseclientgetpropertygroups)
        * [databricks.statementexecution.BaseClient.loadConfigFile](#databricksstatementexecutionbaseclientloadconfigfile)
        * [databricks.statementexecution.BaseClient.postSend](#databricksstatementexecutionbaseclientpostsend)
        * [databricks.statementexecution.BaseClient.preSend](#databricksstatementexecutionbaseclientpresend)
        * [databricks.statementexecution.BaseClient.requestAuth](#databricksstatementexecutionbaseclientrequestauth)
        * [databricks.statementexecution.BaseClient.setCookies](#databricksstatementexecutionbaseclientsetcookies)
      * [databricks.statementexecution.CookieJar](#databricksstatementexecutioncookiejar)
        * [databricks.statementexecution.CookieJar.CookieJar](#databricksstatementexecutioncookiejarcookiejar)
        * [databricks.statementexecution.CookieJar.getCookies](#databricksstatementexecutioncookiejargetcookies)
        * [databricks.statementexecution.CookieJar.load](#databricksstatementexecutioncookiejarload)
        * [databricks.statementexecution.CookieJar.persist](#databricksstatementexecutioncookiejarpersist)
        * [databricks.statementexecution.CookieJar.purge](#databricksstatementexecutioncookiejarpurge)
        * [databricks.statementexecution.CookieJar.setCookies](#databricksstatementexecutioncookiejarsetcookies)
      * [databricks.statementexecution.JSONDiscriminator](#databricksstatementexecutionjsondiscriminator)
        * [databricks.statementexecution.JSONDiscriminator.JSONDiscriminator](#databricksstatementexecutionjsondiscriminatorjsondiscriminator)
      * [databricks.statementexecution.JSONEnum](#databricksstatementexecutionjsonenum)
        * [databricks.statementexecution.JSONEnum.JSONEnum](#databricksstatementexecutionjsonenumjsonenum)
        * [databricks.statementexecution.JSONEnum.fromJSON](#databricksstatementexecutionjsonenumfromjson)
      * [databricks.statementexecution.JSONMapper](#databricksstatementexecutionjsonmapper)
        * [databricks.statementexecution.JSONMapper.ConstructorArgument](#databricksstatementexecutionjsonmapperconstructorargument)
        * [databricks.statementexecution.JSONMapper.JSONArray](#databricksstatementexecutionjsonmapperjsonarray)
        * [databricks.statementexecution.JSONMapper.JSONMapper](#databricksstatementexecutionjsonmapperjsonmapper)
        * [databricks.statementexecution.JSONMapper.discriminator](#databricksstatementexecutionjsonmapperdiscriminator)
        * [databricks.statementexecution.JSONMapper.doNotDecode](#databricksstatementexecutionjsonmapperdonotdecode)
        * [databricks.statementexecution.JSONMapper.epochDatetime](#databricksstatementexecutionjsonmapperepochdatetime)
        * [databricks.statementexecution.JSONMapper.fieldName](#databricksstatementexecutionjsonmapperfieldname)
        * [databricks.statementexecution.JSONMapper.fromJSON](#databricksstatementexecutionjsonmapperfromjson)
        * [databricks.statementexecution.JSONMapper.getArrayPayload](#databricksstatementexecutionjsonmappergetarraypayload)
        * [databricks.statementexecution.JSONMapper.getJSON2NATLABNameMap](#databricksstatementexecutionjsonmappergetjson2natlabnamemap)
        * [databricks.statementexecution.JSONMapper.getMATLAB2JSONNameMap](#databricksstatementexecutionjsonmappergetmatlab2jsonnamemap)
        * [databricks.statementexecution.JSONMapper.getPayload](#databricksstatementexecutionjsonmappergetpayload)
        * [databricks.statementexecution.JSONMapper.initialize](#databricksstatementexecutionjsonmapperinitialize)
        * [databricks.statementexecution.JSONMapper.jsonencode](#databricksstatementexecutionjsonmapperjsonencode)
        * [databricks.statementexecution.JSONMapper.stringDatetime](#databricksstatementexecutionjsonmapperstringdatetime)
      * [databricks.statementexecution.JSONMapperMap](#databricksstatementexecutionjsonmappermap)
        * [databricks.statementexecution.JSONMapperMap.JSONMapperMap](#databricksstatementexecutionjsonmappermapjsonmappermap)
        * [databricks.statementexecution.JSONMapperMap.disp](#databricksstatementexecutionjsonmappermapdisp)
        * [databricks.statementexecution.JSONMapperMap.jsonencode](#databricksstatementexecutionjsonmappermapjsonencode)
        * [databricks.statementexecution.JSONMapperMap.keys](#databricksstatementexecutionjsonmappermapkeys)
        * [databricks.statementexecution.JSONMapperMap.subsasgn](#databricksstatementexecutionjsonmappermapsubsasgn)
        * [databricks.statementexecution.JSONMapperMap.subsref](#databricksstatementexecutionjsonmappermapsubsref)
        * [databricks.statementexecution.JSONMapperMap.toKeyValuePairCell](#databricksstatementexecutionjsonmappermaptokeyvaluepaircell)
        * [databricks.statementexecution.JSONMapperMap.values](#databricksstatementexecutionjsonmappermapvalues)
      * [databricks.statementexecution.JSONPropertyInfo](#databricksstatementexecutionjsonpropertyinfo)
        * [databricks.statementexecution.JSONPropertyInfo.JSONPropertyInfo](#databricksstatementexecutionjsonpropertyinfojsonpropertyinfo)
        * [databricks.statementexecution.JSONPropertyInfo.getPropertyInfo](#databricksstatementexecutionjsonpropertyinfogetpropertyinfo)
    * [databricks.Apps](#databricksapps)
      * [databricks.Apps.Apps](#databricksappsapps)
      * [databricks.Apps.createApp](#databricksappscreateapp)
      * [databricks.Apps.createDeployment](#databricksappscreatedeployment)
      * [databricks.Apps.deleteApp](#databricksappsdeleteapp)
      * [databricks.Apps.deleteThumbnail](#databricksappsdeletethumbnail)
      * [databricks.Apps.getApp](#databricksappsgetapp)
      * [databricks.Apps.getDeployment](#databricksappsgetdeployment)
      * [databricks.Apps.listAppsPage](#databricksappslistappspage)
      * [databricks.Apps.listDeploymentPage](#databricksappslistdeploymentpage)
      * [databricks.Apps.listDeploymentPages](#databricksappslistdeploymentpages)
      * [databricks.Apps.start](#databricksappsstart)
      * [databricks.Apps.stop](#databricksappsstop)
      * [databricks.Apps.updateThumbnail](#databricksappsupdatethumbnail)
    * [databricks.BaseTask](#databricksbasetask)
      * [databricks.BaseTask.BaseTask](#databricksbasetaskbasetask)
      * [databricks.BaseTask.escapeDoubleBackSlashes](#databricksbasetaskescapedoublebackslashes)
      * [databricks.BaseTask.escapeDoubleQuotes](#databricksbasetaskescapedoublequotes)
      * [databricks.BaseTask.escapeSingleQuotes](#databricksbasetaskescapesinglequotes)
      * [databricks.BaseTask.getPropertyGroups](#databricksbasetaskgetpropertygroups)
      * [databricks.BaseTask.getTaskEntries](#databricksbasetaskgettaskentries)
      * [databricks.BaseTask.notebookPath2Link](#databricksbasetasknotebookpath2link)
      * [databricks.BaseTask.notebookPath2URI](#databricksbasetasknotebookpath2uri)
      * [databricks.BaseTask.shellEscape](#databricksbasetaskshellescape)
    * [databricks.Cluster](#databrickscluster)
      * [databricks.Cluster.Cluster](#databricksclustercluster)
      * [databricks.Cluster.changeOwner](#databricksclusterchangeowner)
      * [databricks.Cluster.create](#databricksclustercreate)
      * [databricks.Cluster.edit](#databricksclusteredit)
      * [databricks.Cluster.enableMATLABRuntime](#databricksclusterenablematlabruntime)
      * [databricks.Cluster.findById](#databricksclusterfindbyid)
      * [databricks.Cluster.findByName](#databricksclusterfindbyname)
      * [databricks.Cluster.getClusterVersionSemVer](#databricksclustergetclusterversionsemver)
      * [databricks.Cluster.getClusterVersionString](#databricksclustergetclusterversionstring)
      * [databricks.Cluster.getEvents](#databricksclustergetevents)
      * [databricks.Cluster.getNodeTypes](#databricksclustergetnodetypes)
      * [databricks.Cluster.getPayload](#databricksclustergetpayload)
      * [databricks.Cluster.getSparkVersions](#databricksclustergetsparkversions)
      * [databricks.Cluster.getZones](#databricksclustergetzones)
      * [databricks.Cluster.list](#databricksclusterlist)
      * [databricks.Cluster.permanentDelete](#databricksclusterpermanentdelete)
      * [databricks.Cluster.refresh](#databricksclusterrefresh)
      * [databricks.Cluster.restart](#databricksclusterrestart)
      * [databricks.Cluster.setAutoterminationMinutes](#databricksclustersetautoterminationminutes)
      * [databricks.Cluster.setClusterId](#databricksclustersetclusterid)
      * [databricks.Cluster.setClusterLogConf](#databricksclustersetclusterlogconf)
      * [databricks.Cluster.setCustomTags](#databricksclustersetcustomtags)
      * [databricks.Cluster.setDataSecurityMode](#databricksclustersetdatasecuritymode)
      * [databricks.Cluster.setDockerImage](#databricksclustersetdockerimage)
      * [databricks.Cluster.setInitScriptInfo](#databricksclustersetinitscriptinfo)
      * [databricks.Cluster.setInstancePoolId](#databricksclustersetinstancepoolid)
      * [databricks.Cluster.setInstanceProfileARN](#databricksclustersetinstanceprofilearn)
      * [databricks.Cluster.setNumWorkers](#databricksclustersetnumworkers)
      * [databricks.Cluster.setPolicyId](#databricksclustersetpolicyid)
      * [databricks.Cluster.setRuntimeEngine](#databricksclustersetruntimeengine)
      * [databricks.Cluster.setSingleNode](#databricksclustersetsinglenode)
      * [databricks.Cluster.setSparkConf](#databricksclustersetsparkconf)
      * [databricks.Cluster.setSparkEnvVars](#databricksclustersetsparkenvvars)
      * [databricks.Cluster.start](#databricksclusterstart)
      * [databricks.Cluster.terminate](#databricksclusterterminate)
    * [databricks.ClusterLogConf](#databricksclusterlogconf)
      * [databricks.ClusterLogConf.ClusterLogConf](#databricksclusterlogconfclusterlogconf)
      * [databricks.ClusterLogConf.setDestination](#databricksclusterlogconfsetdestination)
    * [databricks.ClusterPolicy](#databricksclusterpolicy)
      * [databricks.ClusterPolicy.ClusterPolicy](#databricksclusterpolicyclusterpolicy)
      * [databricks.ClusterPolicy.create](#databricksclusterpolicycreate)
      * [databricks.ClusterPolicy.edit](#databricksclusterpolicyedit)
      * [databricks.ClusterPolicy.get](#databricksclusterpolicyget)
      * [databricks.ClusterPolicy.getPermissionLevels](#databricksclusterpolicygetpermissionlevels)
      * [databricks.ClusterPolicy.getPolicyPermissions](#databricksclusterpolicygetpolicypermissions)
      * [databricks.ClusterPolicy.list](#databricksclusterpolicylist)
      * [databricks.ClusterPolicy.remove](#databricksclusterpolicyremove)
    * [databricks.ClusterTag](#databricksclustertag)
      * [databricks.ClusterTag.ClusterTag](#databricksclustertagclustertag)
      * [databricks.ClusterTag.add](#databricksclustertagadd)
    * [databricks.CommandExecution](#databrickscommandexecution)
      * [databricks.CommandExecution.CommandExecution](#databrickscommandexecutioncommandexecution)
      * [databricks.CommandExecution.cancel](#databrickscommandexecutioncancel)
      * [databricks.CommandExecution.commandsStatus](#databrickscommandexecutioncommandsstatus)
      * [databricks.CommandExecution.contextsStatus](#databrickscommandexecutioncontextsstatus)
      * [databricks.CommandExecution.create](#databrickscommandexecutioncreate)
      * [databricks.CommandExecution.destroy](#databrickscommandexecutiondestroy)
      * [databricks.CommandExecution.execute](#databrickscommandexecutionexecute)
    * [databricks.CronSchedule](#databrickscronschedule)
      * [databricks.CronSchedule.CronSchedule](#databrickscronschedulecronschedule)
      * [databricks.CronSchedule.setPauseStatus](#databrickscronschedulesetpausestatus)
      * [databricks.CronSchedule.setQuartzCronExpression](#databrickscronschedulesetquartzcronexpression)
      * [databricks.CronSchedule.setTimezoneId](#databrickscronschedulesettimezoneid)
    * [databricks.CurrentUser](#databrickscurrentuser)
      * [databricks.CurrentUser.CurrentUser](#databrickscurrentusercurrentuser)
      * [databricks.CurrentUser.getCurrentUserInfo](#databrickscurrentusergetcurrentuserinfo)
    * [databricks.DBFS](#databricksdbfs)
      * [databricks.DBFS.DBFS](#databricksdbfsdbfs)
      * [databricks.DBFS.download](#databricksdbfsdownload)
      * [databricks.DBFS.getStatus](#databricksdbfsgetstatus)
      * [databricks.DBFS.listFiles](#databricksdbfslistfiles)
      * [databricks.DBFS.ls](#databricksdbfsls)
      * [databricks.DBFS.mkdir](#databricksdbfsmkdir)
      * [databricks.DBFS.move](#databricksdbfsmove)
      * [databricks.DBFS.read](#databricksdbfsread)
      * [databricks.DBFS.readFileSection](#databricksdbfsreadfilesection)
      * [databricks.DBFS.rm](#databricksdbfsrm)
      * [databricks.DBFS.upload](#databricksdbfsupload)
    * [databricks.Files](#databricksfiles)
      * [databricks.Files.Files](#databricksfilesfiles)
      * [databricks.Files.bigUpload](#databricksfilesbigupload)
      * [databricks.Files.completeUpload](#databricksfilescompleteupload)
      * [databricks.Files.create](#databricksfilescreate)
      * [databricks.Files.directoryExists](#databricksfilesdirectoryexists)
      * [databricks.Files.directoryMetadata](#databricksfilesdirectorymetadata)
      * [databricks.Files.download](#databricksfilesdownload)
      * [databricks.Files.escapePath](#databricksfilesescapepath)
      * [databricks.Files.fileExists](#databricksfilesfileexists)
      * [databricks.Files.fileMetadata](#databricksfilesfilemetadata)
      * [databricks.Files.initiateUpload](#databricksfilesinitiateupload)
      * [databricks.Files.list](#databricksfileslist)
      * [databricks.Files.listPaginated](#databricksfileslistpaginated)
      * [databricks.Files.rm](#databricksfilesrm)
      * [databricks.Files.rmdir](#databricksfilesrmdir)
      * [databricks.Files.upload](#databricksfilesupload)
    * [databricks.Genie](#databricksgenie)
      * [databricks.Genie.Genie](#databricksgeniegenie)
      * [databricks.Genie.createConversationMessage](#databricksgeniecreateconversationmessage)
      * [databricks.Genie.deleteConversation](#databricksgeniedeleteconversation)
      * [databricks.Genie.deleteConversationMessage](#databricksgeniedeleteconversationmessage)
      * [databricks.Genie.execMsgAttachmentSQLQuery](#databricksgenieexecmsgattachmentsqlquery)
      * [databricks.Genie.getConversationMessage](#databricksgeniegetconversationmessage)
      * [databricks.Genie.getMsgAttachmentSQLQueryResult](#databricksgeniegetmsgattachmentsqlqueryresult)
      * [databricks.Genie.getSpace](#databricksgeniegetspace)
      * [databricks.Genie.listConversationMessages](#databricksgenielistconversationmessages)
      * [databricks.Genie.listConversationMessagesPage](#databricksgenielistconversationmessagespage)
      * [databricks.Genie.listConversations](#databricksgenielistconversations)
      * [databricks.Genie.listConversationsPage](#databricksgenielistconversationspage)
      * [databricks.Genie.listSpaces](#databricksgenielistspaces)
      * [databricks.Genie.listSpacesPage](#databricksgenielistspacespage)
      * [databricks.Genie.startConversation](#databricksgeniestartconversation)
      * [databricks.Genie.trashSpace](#databricksgenietrashspace)
    * [databricks.InitScriptInfo](#databricksinitscriptinfo)
      * [databricks.InitScriptInfo.InitScriptInfo](#databricksinitscriptinfoinitscriptinfo)
      * [databricks.InitScriptInfo.setDestination](#databricksinitscriptinfosetdestination)
    * [databricks.InstancePools](#databricksinstancepools)
      * [databricks.InstancePools.InstancePools](#databricksinstancepoolsinstancepools)
      * [databricks.InstancePools.create](#databricksinstancepoolscreate)
      * [databricks.InstancePools.get](#databricksinstancepoolsget)
      * [databricks.InstancePools.getPermissions](#databricksinstancepoolsgetpermissions)
      * [databricks.InstancePools.list](#databricksinstancepoolslist)
      * [databricks.InstancePools.remove](#databricksinstancepoolsremove)
    * [databricks.JDBCConnection](#databricksjdbcconnection)
      * [databricks.JDBCConnection.JDBCConnection](#databricksjdbcconnectionjdbcconnection)
      * [databricks.JDBCConnection.checkDataSources](#databricksjdbcconnectioncheckdatasources)
      * [databricks.JDBCConnection.close](#databricksjdbcconnectionclose)
      * [databricks.JDBCConnection.copyToken](#databricksjdbcconnectioncopytoken)
      * [databricks.JDBCConnection.createSourceOpts](#databricksjdbcconnectioncreatesourceopts)
      * [databricks.JDBCConnection.escapeUCName](#databricksjdbcconnectionescapeucname)
      * [databricks.JDBCConnection.getAuthArgs](#databricksjdbcconnectiongetauthargs)
      * [databricks.JDBCConnection.getDefaultJarFilePath](#databricksjdbcconnectiongetdefaultjarfilepath)
      * [databricks.JDBCConnection.getDriverVersion](#databricksjdbcconnectiongetdriverversion)
      * [databricks.JDBCConnection.getEnableTokenCache](#databricksjdbcconnectiongetenabletokencache)
      * [databricks.JDBCConnection.getHTTPProxy](#databricksjdbcconnectiongethttpproxy)
      * [databricks.JDBCConnection.getHttpPath](#databricksjdbcconnectiongethttppath)
      * [databricks.JDBCConnection.getJavaVersion](#databricksjdbcconnectiongetjavaversion)
      * [databricks.JDBCConnection.getPropertyGroups](#databricksjdbcconnectiongetpropertygroups)
      * [databricks.JDBCConnection.getScope](#databricksjdbcconnectiongetscope)
      * [databricks.JDBCConnection.isOSSDriver](#databricksjdbcconnectionisossdriver)
      * [databricks.JDBCConnection.numberOfClassPathEntries](#databricksjdbcconnectionnumberofclasspathentries)
      * [databricks.JDBCConnection.resolveDriverType](#databricksjdbcconnectionresolvedrivertype)
      * [databricks.JDBCConnection.saveSource](#databricksjdbcconnectionsavesource)
      * [databricks.JDBCConnection.testConnection](#databricksjdbcconnectiontestconnection)
      * [databricks.JDBCConnection.updateJavaclassPath](#databricksjdbcconnectionupdatejavaclasspath)
      * [databricks.JDBCConnection.validateCluster](#databricksjdbcconnectionvalidatecluster)
      * [databricks.JDBCConnection.validateDriverVersion](#databricksjdbcconnectionvalidatedriverversion)
    * [databricks.JDBCConnectionImpl](#databricksjdbcconnectionimpl)
      * [databricks.JDBCConnectionImpl.JDBCConnectionImpl](#databricksjdbcconnectionimpljdbcconnectionimpl)
      * [databricks.JDBCConnectionImpl.checkDataSources](#databricksjdbcconnectionimplcheckdatasources)
      * [databricks.JDBCConnectionImpl.close](#databricksjdbcconnectionimplclose)
      * [databricks.JDBCConnectionImpl.copyToken](#databricksjdbcconnectionimplcopytoken)
      * [databricks.JDBCConnectionImpl.createSourceOpts](#databricksjdbcconnectionimplcreatesourceopts)
      * [databricks.JDBCConnectionImpl.delete](#databricksjdbcconnectionimpldelete)
      * [databricks.JDBCConnectionImpl.escapeUCName](#databricksjdbcconnectionimplescapeucname)
      * [databricks.JDBCConnectionImpl.getAuthArgs](#databricksjdbcconnectionimplgetauthargs)
      * [databricks.JDBCConnectionImpl.getDefaultJarFilePath](#databricksjdbcconnectionimplgetdefaultjarfilepath)
      * [databricks.JDBCConnectionImpl.getDriverVersion](#databricksjdbcconnectionimplgetdriverversion)
      * [databricks.JDBCConnectionImpl.getEnableTokenCache](#databricksjdbcconnectionimplgetenabletokencache)
      * [databricks.JDBCConnectionImpl.getHTTPProxy](#databricksjdbcconnectionimplgethttpproxy)
      * [databricks.JDBCConnectionImpl.getHttpPath](#databricksjdbcconnectionimplgethttppath)
      * [databricks.JDBCConnectionImpl.getJavaVersion](#databricksjdbcconnectionimplgetjavaversion)
      * [databricks.JDBCConnectionImpl.getPropertyGroups](#databricksjdbcconnectionimplgetpropertygroups)
      * [databricks.JDBCConnectionImpl.getScope](#databricksjdbcconnectionimplgetscope)
      * [databricks.JDBCConnectionImpl.isOSSDriver](#databricksjdbcconnectionimplisossdriver)
      * [databricks.JDBCConnectionImpl.numberOfClassPathEntries](#databricksjdbcconnectionimplnumberofclasspathentries)
      * [databricks.JDBCConnectionImpl.saveSource](#databricksjdbcconnectionimplsavesource)
      * [databricks.JDBCConnectionImpl.testConnection](#databricksjdbcconnectionimpltestconnection)
      * [databricks.JDBCConnectionImpl.updateJavaclassPath](#databricksjdbcconnectionimplupdatejavaclasspath)
      * [databricks.JDBCConnectionImpl.validateCluster](#databricksjdbcconnectionimplvalidatecluster)
      * [databricks.JDBCConnectionImpl.validateDriverVersion](#databricksjdbcconnectionimplvalidatedriverversion)
    * [databricks.Job](#databricksjob)
      * [databricks.Job.Job](#databricksjobjob)
      * [databricks.Job.create](#databricksjobcreate)
      * [databricks.Job.getPayload](#databricksjobgetpayload)
      * [databricks.Job.list](#databricksjoblist)
      * [databricks.Job.refresh](#databricksjobrefresh)
      * [databricks.Job.remove](#databricksjobremove)
      * [databricks.Job.runNow](#databricksjobrunnow)
      * [databricks.Job.setCluster](#databricksjobsetcluster)
      * [databricks.Job.setJobEmailNotifications](#databricksjobsetjobemailnotifications)
      * [databricks.Job.setJobId](#databricksjobsetjobid)
      * [databricks.Job.setLibrary](#databricksjobsetlibrary)
      * [databricks.Job.setRunAs](#databricksjobsetrunas)
      * [databricks.Job.setSchedule](#databricksjobsetschedule)
      * [databricks.Job.setTask](#databricksjobsettask)
      * [databricks.Job.setTimeoutSeconds](#databricksjobsettimeoutseconds)
      * [databricks.Job.submit](#databricksjobsubmit)
    * [databricks.JobEmailNotifications](#databricksjobemailnotifications)
      * [databricks.JobEmailNotifications.JobEmailNotifications](#databricksjobemailnotificationsjobemailnotifications)
      * [databricks.JobEmailNotifications.getNotificationEmail](#databricksjobemailnotificationsgetnotificationemail)
    * [databricks.Library](#databrickslibrary)
      * [databricks.Library.Library](#databrickslibrarylibrary)
      * [databricks.Library.getClusterStatus](#databrickslibrarygetclusterstatus)
      * [databricks.Library.getPayload](#databrickslibrarygetpayload)
      * [databricks.Library.getType](#databrickslibrarygettype)
      * [databricks.Library.install](#databrickslibraryinstall)
      * [databricks.Library.setType](#databrickslibrarysettype)
      * [databricks.Library.table](#databrickslibrarytable)
      * [databricks.Library.uninstall](#databrickslibraryuninstall)
    * [databricks.MATLABBatchTask](#databricksmatlabbatchtask)
      * [databricks.MATLABBatchTask.MATLABBatchTask](#databricksmatlabbatchtaskmatlabbatchtask)
      * [databricks.MATLABBatchTask.createPyNotebook](#databricksmatlabbatchtaskcreatepynotebook)
      * [databricks.MATLABBatchTask.getTaskEntries](#databricksmatlabbatchtaskgettaskentries)
    * [databricks.MATLABRuntimeTask](#databricksmatlabruntimetask)
      * [databricks.MATLABRuntimeTask.MATLABRuntimeTask](#databricksmatlabruntimetaskmatlabruntimetask)
      * [databricks.MATLABRuntimeTask.createPyNotebook](#databricksmatlabruntimetaskcreatepynotebook)
      * [databricks.MATLABRuntimeTask.getTaskEntries](#databricksmatlabruntimetaskgettaskentries)
    * [databricks.NotebookTask](#databricksnotebooktask)
      * [databricks.NotebookTask.NotebookTask](#databricksnotebooktasknotebooktask)
      * [databricks.NotebookTask.getTaskEntries](#databricksnotebooktaskgettaskentries)
    * [databricks.ODBCConnection](#databricksodbcconnection)
      * [databricks.ODBCConnection.ODBCConnection](#databricksodbcconnectionodbcconnection)
      * [databricks.ODBCConnection.checkDataSources](#databricksodbcconnectioncheckdatasources)
      * [databricks.ODBCConnection.checkDriverVersion](#databricksodbcconnectioncheckdriverversion)
      * [databricks.ODBCConnection.close](#databricksodbcconnectionclose)
      * [databricks.ODBCConnection.copyToken](#databricksodbcconnectioncopytoken)
      * [databricks.ODBCConnection.delete](#databricksodbcconnectiondelete)
      * [databricks.ODBCConnection.escapeUCName](#databricksodbcconnectionescapeucname)
      * [databricks.ODBCConnection.generateDSNFile](#databricksodbcconnectiongeneratedsnfile)
      * [databricks.ODBCConnection.getAuthArgs](#databricksodbcconnectiongetauthargs)
      * [databricks.ODBCConnection.getDefaultDriver](#databricksodbcconnectiongetdefaultdriver)
      * [databricks.ODBCConnection.getHTTPProxy](#databricksodbcconnectiongethttpproxy)
      * [databricks.ODBCConnection.getHttpPath](#databricksodbcconnectiongethttppath)
      * [databricks.ODBCConnection.getPropertyGroups](#databricksodbcconnectiongetpropertygroups)
      * [databricks.ODBCConnection.getScope](#databricksodbcconnectiongetscope)
      * [databricks.ODBCConnection.validateCluster](#databricksodbcconnectionvalidatecluster)
    * [databricks.Object](#databricksobject)
      * [databricks.Object.Object](#databricksobjectobject)
      * [databricks.Object.addStructureAsDynProps](#databricksobjectaddstructureasdynprops)
      * [databricks.Object.epochToTimestamp](#databricksobjectepochtotimestamp)
      * [databricks.Object.getAuth](#databricksobjectgetauth)
      * [databricks.Object.getAuthorizationField](#databricksobjectgetauthorizationfield)
      * [databricks.Object.getRequestMessage](#databricksobjectgetrequestmessage)
      * [databricks.Object.getURI](#databricksobjectgeturi)
      * [databricks.Object.getUserAgent](#databricksobjectgetuseragent)
      * [databricks.Object.isPreview](#databricksobjectispreview)
      * [databricks.Object.rmpropif](#databricksobjectrmpropif)
      * [databricks.Object.sanitizeHost](#databricksobjectsanitizehost)
      * [databricks.Object.setprop](#databricksobjectsetprop)
    * [databricks.PySparkSession](#databrickspysparksession)
      * [databricks.PySparkSession.PySparkSession](#databrickspysparksessionpysparksession)
      * [databricks.PySparkSession.getPropertyGroups](#databrickspysparksessiongetpropertygroups)
    * [databricks.Run](#databricksrun)
      * [databricks.Run.Run](#databricksrunrun)
      * [databricks.Run.cancel](#databricksruncancel)
      * [databricks.Run.export](#databricksrunexport)
      * [databricks.Run.get](#databricksrunget)
      * [databricks.Run.getOutput](#databricksrungetoutput)
      * [databricks.Run.list](#databricksrunlist)
    * [databricks.SCIM](#databricksscim)
      * [databricks.SCIM.SCIM](#databricksscimscim)
      * [databricks.SCIM.me](#databricksscimme)
    * [databricks.SQLWarehouse](#databrickssqlwarehouse)
      * [databricks.SQLWarehouse.SQLWarehouse](#databrickssqlwarehousesqlwarehouse)
      * [databricks.SQLWarehouse.connect](#databrickssqlwarehouseconnect)
      * [databricks.SQLWarehouse.create](#databrickssqlwarehousecreate)
      * [databricks.SQLWarehouse.edit](#databrickssqlwarehouseedit)
      * [databricks.SQLWarehouse.list](#databrickssqlwarehouselist)
      * [databricks.SQLWarehouse.performAction](#databrickssqlwarehouseperformaction)
      * [databricks.SQLWarehouse.refresh](#databrickssqlwarehouserefresh)
      * [databricks.SQLWarehouse.remove](#databrickssqlwarehouseremove)
      * [databricks.SQLWarehouse.start](#databrickssqlwarehousestart)
      * [databricks.SQLWarehouse.stop](#databrickssqlwarehousestop)
    * [databricks.Scope](#databricksscope)
      * [databricks.Scope.Scope](#databricksscopescope)
      * [databricks.Scope.create](#databricksscopecreate)
      * [databricks.Scope.delete](#databricksscopedelete)
      * [databricks.Scope.list](#databricksscopelist)
      * [databricks.Scope.validateScope](#databricksscopevalidatescope)
    * [databricks.Secret](#databrickssecret)
      * [databricks.Secret.Secret](#databrickssecretsecret)
      * [databricks.Secret.delete](#databrickssecretdelete)
      * [databricks.Secret.list](#databrickssecretlist)
      * [databricks.Secret.put](#databrickssecretput)
      * [databricks.Secret.setValue](#databrickssecretsetvalue)
      * [databricks.Secret.validateKey](#databrickssecretvalidatekey)
      * [databricks.Secret.validateScope](#databrickssecretvalidatescope)
    * [databricks.SparkConfPair](#databrickssparkconfpair)
      * [databricks.SparkConfPair.SparkConfPair](#databrickssparkconfpairsparkconfpair)
      * [databricks.SparkConfPair.add](#databrickssparkconfpairadd)
    * [databricks.SparkEnvPair](#databrickssparkenvpair)
      * [databricks.SparkEnvPair.SparkEnvPair](#databrickssparkenvpairsparkenvpair)
      * [databricks.SparkEnvPair.add](#databrickssparkenvpairadd)
    * [databricks.SparkJarTask](#databrickssparkjartask)
      * [databricks.SparkJarTask.SparkJarTask](#databrickssparkjartasksparkjartask)
      * [databricks.SparkJarTask.getTaskEntries](#databrickssparkjartaskgettaskentries)
    * [databricks.SparkPythonTask](#databrickssparkpythontask)
      * [databricks.SparkPythonTask.SparkPythonTask](#databrickssparkpythontasksparkpythontask)
      * [databricks.SparkPythonTask.getTaskEntries](#databrickssparkpythontaskgettaskentries)
    * [databricks.SparkSubmitTask](#databrickssparksubmittask)
      * [databricks.SparkSubmitTask.SparkSubmitTask](#databrickssparksubmittasksparksubmittask)
      * [databricks.SparkSubmitTask.getParameters](#databrickssparksubmittaskgetparameters)
      * [databricks.SparkSubmitTask.getTaskEntries](#databrickssparksubmittaskgettaskentries)
    * [databricks.Tasks](#databrickstasks)
      * [databricks.Tasks.Tasks](#databrickstaskstasks)
      * [databricks.Tasks.addJobCluster](#databrickstasksaddjobcluster)
      * [databricks.Tasks.addTask](#databrickstasksaddtask)
      * [databricks.Tasks.getTaskEntries](#databrickstasksgettaskentries)
    * [databricks.Token](#databrickstoken)
      * [databricks.Token.Token](#databrickstokentoken)
      * [databricks.Token.create](#databrickstokencreate)
      * [databricks.Token.getPropertyGroups](#databrickstokengetpropertygroups)
      * [databricks.Token.list](#databrickstokenlist)
      * [databricks.Token.revoke](#databrickstokenrevoke)
      * [databricks.Token.table](#databrickstokentable)
    * [databricks.UnityCatalog](#databricksunitycatalog)
      * [databricks.UnityCatalog.UnityCatalog](#databricksunitycatalogunitycatalog)
      * [databricks.UnityCatalog.createCatalog](#databricksunitycatalogcreatecatalog)
      * [databricks.UnityCatalog.createConnection](#databricksunitycatalogcreateconnection)
      * [databricks.UnityCatalog.createExternalLocation](#databricksunitycatalogcreateexternallocation)
      * [databricks.UnityCatalog.createMetastore](#databricksunitycatalogcreatemetastore)
      * [databricks.UnityCatalog.createMetastoreAssignment](#databricksunitycatalogcreatemetastoreassignment)
      * [databricks.UnityCatalog.createProvider](#databricksunitycatalogcreateprovider)
      * [databricks.UnityCatalog.createRecipient](#databricksunitycatalogcreaterecipient)
      * [databricks.UnityCatalog.createSchema](#databricksunitycatalogcreateschema)
      * [databricks.UnityCatalog.createShare](#databricksunitycatalogcreateshare)
      * [databricks.UnityCatalog.createStorageCredential](#databricksunitycatalogcreatestoragecredential)
      * [databricks.UnityCatalog.createVolume](#databricksunitycatalogcreatevolume)
      * [databricks.UnityCatalog.deleteCatalog](#databricksunitycatalogdeletecatalog)
      * [databricks.UnityCatalog.deleteConnection](#databricksunitycatalogdeleteconnection)
      * [databricks.UnityCatalog.deleteExternalLocation](#databricksunitycatalogdeleteexternallocation)
      * [databricks.UnityCatalog.deleteMetastore](#databricksunitycatalogdeletemetastore)
      * [databricks.UnityCatalog.deleteMetastoreAssignment](#databricksunitycatalogdeletemetastoreassignment)
      * [databricks.UnityCatalog.deleteProvider](#databricksunitycatalogdeleteprovider)
      * [databricks.UnityCatalog.deleteRecipient](#databricksunitycatalogdeleterecipient)
      * [databricks.UnityCatalog.deleteSchema](#databricksunitycatalogdeleteschema)
      * [databricks.UnityCatalog.deleteShare](#databricksunitycatalogdeleteshare)
      * [databricks.UnityCatalog.deleteStorageCredential](#databricksunitycatalogdeletestoragecredential)
      * [databricks.UnityCatalog.deleteTable](#databricksunitycatalogdeletetable)
      * [databricks.UnityCatalog.deleteVolume](#databricksunitycatalogdeletevolume)
      * [databricks.UnityCatalog.genTempVolumeCredential](#databricksunitycataloggentempvolumecredential)
      * [databricks.UnityCatalog.getArtifactAllowlists](#databricksunitycataloggetartifactallowlists)
      * [databricks.UnityCatalog.getCatalog](#databricksunitycataloggetcatalog)
      * [databricks.UnityCatalog.getConnection](#databricksunitycataloggetconnection)
      * [databricks.UnityCatalog.getExternalLocation](#databricksunitycataloggetexternallocation)
      * [databricks.UnityCatalog.getMetastore](#databricksunitycataloggetmetastore)
      * [databricks.UnityCatalog.getMyGroups](#databricksunitycataloggetmygroups)
      * [databricks.UnityCatalog.getMyInfo](#databricksunitycataloggetmyinfo)
      * [databricks.UnityCatalog.getPermissions](#databricksunitycataloggetpermissions)
      * [databricks.UnityCatalog.getProvider](#databricksunitycataloggetprovider)
      * [databricks.UnityCatalog.getRecipient](#databricksunitycataloggetrecipient)
      * [databricks.UnityCatalog.getRecipientSharePermissions](#databricksunitycataloggetrecipientsharepermissions)
      * [databricks.UnityCatalog.getSchema](#databricksunitycataloggetschema)
      * [databricks.UnityCatalog.getShare](#databricksunitycataloggetshare)
      * [databricks.UnityCatalog.getSharePermissions](#databricksunitycataloggetsharepermissions)
      * [databricks.UnityCatalog.getStorageCredential](#databricksunitycataloggetstoragecredential)
      * [databricks.UnityCatalog.getTable](#databricksunitycataloggettable)
      * [databricks.UnityCatalog.getVolume](#databricksunitycataloggetvolume)
      * [databricks.UnityCatalog.listCatalogs](#databricksunitycataloglistcatalogs)
      * [databricks.UnityCatalog.listConnections](#databricksunitycataloglistconnections)
      * [databricks.UnityCatalog.listConnectionsPage](#databricksunitycataloglistconnectionspage)
      * [databricks.UnityCatalog.listExternalLocations](#databricksunitycataloglistexternallocations)
      * [databricks.UnityCatalog.listFiles](#databricksunitycataloglistfiles)
      * [databricks.UnityCatalog.listMetastores](#databricksunitycataloglistmetastores)
      * [databricks.UnityCatalog.listProviderShares](#databricksunitycataloglistprovidershares)
      * [databricks.UnityCatalog.listProviders](#databricksunitycataloglistproviders)
      * [databricks.UnityCatalog.listRecipients](#databricksunitycataloglistrecipients)
      * [databricks.UnityCatalog.listSchemas](#databricksunitycataloglistschemas)
      * [databricks.UnityCatalog.listShares](#databricksunitycataloglistshares)
      * [databricks.UnityCatalog.listStorageCredentials](#databricksunitycatalogliststoragecredentials)
      * [databricks.UnityCatalog.listTableSummaries](#databricksunitycataloglisttablesummaries)
      * [databricks.UnityCatalog.listTables](#databricksunitycataloglisttables)
      * [databricks.UnityCatalog.listVolumes](#databricksunitycataloglistvolumes)
      * [databricks.UnityCatalog.metastoreSummary](#databricksunitycatalogmetastoresummary)
      * [databricks.UnityCatalog.rotateRecipientToken](#databricksunitycatalogrotaterecipienttoken)
      * [databricks.UnityCatalog.setArtifactAllowlist](#databricksunitycatalogsetartifactallowlist)
      * [databricks.UnityCatalog.updateCatalog](#databricksunitycatalogupdatecatalog)
      * [databricks.UnityCatalog.updateConnection](#databricksunitycatalogupdateconnection)
      * [databricks.UnityCatalog.updateExternalLocation](#databricksunitycatalogupdateexternallocation)
      * [databricks.UnityCatalog.updateMetastore](#databricksunitycatalogupdatemetastore)
      * [databricks.UnityCatalog.updateMetastoreAssignment](#databricksunitycatalogupdatemetastoreassignment)
      * [databricks.UnityCatalog.updatePermissions](#databricksunitycatalogupdatepermissions)
      * [databricks.UnityCatalog.updateProvider](#databricksunitycatalogupdateprovider)
      * [databricks.UnityCatalog.updateRecipient](#databricksunitycatalogupdaterecipient)
      * [databricks.UnityCatalog.updateSchema](#databricksunitycatalogupdateschema)
      * [databricks.UnityCatalog.updateShare](#databricksunitycatalogupdateshare)
      * [databricks.UnityCatalog.updateShareObjects](#databricksunitycatalogupdateshareobjects)
      * [databricks.UnityCatalog.updateSharePermissions](#databricksunitycatalogupdatesharepermissions)
      * [databricks.UnityCatalog.updateStorageCredential](#databricksunitycatalogupdatestoragecredential)
      * [databricks.UnityCatalog.updateVolume](#databricksunitycatalogupdatevolume)
    * [databricks.Workspace](#databricksworkspace)
      * [databricks.Workspace.Workspace](#databricksworkspaceworkspace)
      * [databricks.Workspace.delete](#databricksworkspacedelete)
      * [databricks.Workspace.directoryExists](#databricksworkspacedirectoryexists)
      * [databricks.Workspace.export](#databricksworkspaceexport)
      * [databricks.Workspace.fileExists](#databricksworkspacefileexists)
      * [databricks.Workspace.getStatus](#databricksworkspacegetstatus)
      * [databricks.Workspace.import](#databricksworkspaceimport)
      * [databricks.Workspace.list](#databricksworkspacelist)
      * [databricks.Workspace.ls](#databricksworkspacels)
      * [databricks.Workspace.mkdirs](#databricksworkspacemkdirs)
    * [databricks.Zerobus](#databrickszerobus)
      * [databricks.Zerobus.Zerobus](#databrickszerobuszerobus)
      * [databricks.Zerobus.getAccessToken](#databrickszerobusgetaccesstoken)
      * [databricks.Zerobus.insert](#databrickszerobusinsert)
      * [databricks.Zerobus.requireNamedArg](#databrickszerobusrequirenamedarg)
  * [matlab.databricks](#matlabdatabricks)
    * [matlab.databricks.cluster](#matlabdatabrickscluster)
      * [matlab.databricks.cluster.DesktopClusterConfigurator](#matlabdatabricksclusterdesktopclusterconfigurator)
        * [matlab.databricks.cluster.DesktopClusterConfigurator.DesktopClusterConfigurator](#matlabdatabricksclusterdesktopclusterconfiguratordesktopclusterconfigurator)
        * [matlab.databricks.cluster.DesktopClusterConfigurator.configureCluster](#matlabdatabricksclusterdesktopclusterconfiguratorconfigurecluster)
        * [matlab.databricks.cluster.DesktopClusterConfigurator.delete](#matlabdatabricksclusterdesktopclusterconfiguratordelete)
        * [matlab.databricks.cluster.DesktopClusterConfigurator.execPySubcmd](#matlabdatabricksclusterdesktopclusterconfiguratorexecpysubcmd)
        * [matlab.databricks.cluster.DesktopClusterConfigurator.execPySubproc](#matlabdatabricksclusterdesktopclusterconfiguratorexecpysubproc)
        * [matlab.databricks.cluster.DesktopClusterConfigurator.getPropertyGroups](#matlabdatabricksclusterdesktopclusterconfiguratorgetpropertygroups)
        * [matlab.databricks.cluster.DesktopClusterConfigurator.refresh](#matlabdatabricksclusterdesktopclusterconfiguratorrefresh)
        * [matlab.databricks.cluster.DesktopClusterConfigurator.stopTimerCallBack](#matlabdatabricksclusterdesktopclusterconfiguratorstoptimercallback)
      * [matlab.databricks.cluster.MATLABEnableExistingCluster](#matlabdatabricksclustermatlabenableexistingcluster)
      * [matlab.databricks.cluster.deleteDesktopCluster](#matlabdatabricksclusterdeletedesktopcluster)
      * [matlab.databricks.cluster.getClusterMATLABRelease](#matlabdatabricksclustergetclustermatlabrelease)
      * [matlab.databricks.cluster.setPyenvForCluster](#matlabdatabricksclustersetpyenvforcluster)
    * [matlab.databricks.connect](#matlabdatabricksconnect)
      * [matlab.databricks.connect.getDatabricksRuntimePythonVersion](#matlabdatabricksconnectgetdatabricksruntimepythonversion)
      * [matlab.databricks.connect.getVenvPythonPath](#matlabdatabricksconnectgetvenvpythonpath)
      * [matlab.databricks.connect.setPyenv](#matlabdatabricksconnectsetpyenv)
    * [matlab.databricks.demodata](#matlabdatabricksdemodata)
      * [matlab.databricks.demodata.loadFires](#matlabdatabricksdemodataloadfires)
      * [matlab.databricks.demodata.loadNYCTaxiTable](#matlabdatabricksdemodataloadnyctaxitable)
    * [matlab.databricks.environment](#matlabdatabricksenvironment)
      * [matlab.databricks.environment.Manager](#matlabdatabricksenvironmentmanager)
        * [matlab.databricks.environment.Manager.Manager](#matlabdatabricksenvironmentmanagermanager)
        * [matlab.databricks.environment.Manager.getPrefDir](#matlabdatabricksenvironmentmanagergetprefdir)
        * [matlab.databricks.environment.Manager.writePrefs](#matlabdatabricksenvironmentmanagerwriteprefs)
    * [matlab.databricks.genie](#matlabdatabricksgenie)
      * [matlab.databricks.genie.Conversation](#matlabdatabricksgenieconversation)
        * [matlab.databricks.genie.Conversation.Conversation](#matlabdatabricksgenieconversationconversation)
        * [matlab.databricks.genie.Conversation.delete](#matlabdatabricksgenieconversationdelete)
        * [matlab.databricks.genie.Conversation.prompt](#matlabdatabricksgenieconversationprompt)
      * [matlab.databricks.genie.Genie](#matlabdatabricksgeniegenie)
        * [matlab.databricks.genie.Genie.Genie](#matlabdatabricksgeniegeniegenie)
        * [matlab.databricks.genie.Genie.chat](#matlabdatabricksgeniegeniechat)
        * [matlab.databricks.genie.Genie.cleanupConversation](#matlabdatabricksgeniegeniecleanupconversation)
        * [matlab.databricks.genie.Genie.prompt](#matlabdatabricksgeniegenieprompt)
        * [matlab.databricks.genie.Genie.saveTable](#matlabdatabricksgeniegeniesavetable)
      * [matlab.databricks.genie.Message](#matlabdatabricksgeniemessage)
        * [matlab.databricks.genie.Message.Message](#matlabdatabricksgeniemessagemessage)
        * [matlab.databricks.genie.Message.displayMessage](#matlabdatabricksgeniemessagedisplaymessage)
        * [matlab.databricks.genie.Message.showAttachments](#matlabdatabricksgeniemessageshowattachments)
      * [matlab.databricks.genie.Response](#matlabdatabricksgenieresponse)
        * [matlab.databricks.genie.Response.Response](#matlabdatabricksgenieresponseresponse)
        * [matlab.databricks.genie.Response.containsMessage](#matlabdatabricksgenieresponsecontainsmessage)
        * [matlab.databricks.genie.Response.containsQuery](#matlabdatabricksgenieresponsecontainsquery)
        * [matlab.databricks.genie.Response.containsText](#matlabdatabricksgenieresponsecontainstext)
        * [matlab.databricks.genie.Response.executeQuery](#matlabdatabricksgenieresponseexecutequery)
        * [matlab.databricks.genie.Response.updateMessage](#matlabdatabricksgenieresponseupdatemessage)
        * [matlab.databricks.genie.Response.updateQuery](#matlabdatabricksgenieresponseupdatequery)
        * [matlab.databricks.genie.Response.updateResponse](#matlabdatabricksgenieresponseupdateresponse)
        * [matlab.databricks.genie.Response.waitForCompletedMessage](#matlabdatabricksgenieresponsewaitforcompletedmessage)
        * [matlab.databricks.genie.Response.waitForCompletedQuery](#matlabdatabricksgenieresponsewaitforcompletedquery)
        * [matlab.databricks.genie.Response.waitForCompletedResponse](#matlabdatabricksgenieresponsewaitforcompletedresponse)
      * [matlab.databricks.genie.Space](#matlabdatabricksgeniespace)
        * [matlab.databricks.genie.Space.Space](#matlabdatabricksgeniespacespace)
        * [matlab.databricks.genie.Space.delete](#matlabdatabricksgeniespacedelete)
        * [matlab.databricks.genie.Space.deleteConversation](#matlabdatabricksgeniespacedeleteconversation)
        * [matlab.databricks.genie.Space.prompt](#matlabdatabricksgeniespaceprompt)
        * [matlab.databricks.genie.Space.startConversation](#matlabdatabricksgeniespacestartconversation)
      * [matlab.databricks.genie.StatementResponse](#matlabdatabricksgeniestatementresponse)
        * [matlab.databricks.genie.StatementResponse.StatementResponse](#matlabdatabricksgeniestatementresponsestatementresponse)
    * [matlab.databricks.internal](#matlabdatabricksinternal)
      * [matlab.databricks.internal.pkgsettings](#matlabdatabricksinternalpkgsettings)
        * [matlab.databricks.internal.pkgsettings.getPkgSettings](#matlabdatabricksinternalpkgsettingsgetpkgsettings)
        * [matlab.databricks.internal.pkgsettings.writePkgSettings](#matlabdatabricksinternalpkgsettingswritepkgsettings)
      * [matlab.databricks.internal.Mltbx](#matlabdatabricksinternalmltbx)
        * [matlab.databricks.internal.Mltbx.Mltbx](#matlabdatabricksinternalmltbxmltbx)
        * [matlab.databricks.internal.Mltbx.build](#matlabdatabricksinternalmltbxbuild)
        * [matlab.databricks.internal.Mltbx.disableAll](#matlabdatabricksinternalmltbxdisableall)
        * [matlab.databricks.internal.Mltbx.disableOtherVersions](#matlabdatabricksinternalmltbxdisableotherversions)
        * [matlab.databricks.internal.Mltbx.disableVersion](#matlabdatabricksinternalmltbxdisableversion)
        * [matlab.databricks.internal.Mltbx.doPackage](#matlabdatabricksinternalmltbxdopackage)
        * [matlab.databricks.internal.Mltbx.enableVersion](#matlabdatabricksinternalmltbxenableversion)
        * [matlab.databricks.internal.Mltbx.install](#matlabdatabricksinternalmltbxinstall)
        * [matlab.databricks.internal.Mltbx.isEnabled](#matlabdatabricksinternalmltbxisenabled)
        * [matlab.databricks.internal.Mltbx.isInstalled](#matlabdatabricksinternalmltbxisinstalled)
        * [matlab.databricks.internal.Mltbx.isMoreThanOneEnabled](#matlabdatabricksinternalmltbxismorethanoneenabled)
        * [matlab.databricks.internal.Mltbx.listEnabledVersions](#matlabdatabricksinternalmltbxlistenabledversions)
        * [matlab.databricks.internal.Mltbx.listInstalledVersions](#matlabdatabricksinternalmltbxlistinstalledversions)
        * [matlab.databricks.internal.Mltbx.uninstall](#matlabdatabricksinternalmltbxuninstall)
        * [matlab.databricks.internal.Mltbx.uninstallAll](#matlabdatabricksinternalmltbxuninstallall)
        * [matlab.databricks.internal.Mltbx.versionLimits](#matlabdatabricksinternalmltbxversionlimits)
      * [matlab.databricks.internal.deployedInputError](#matlabdatabricksinternaldeployedinputerror)
      * [matlab.databricks.internal.docLink](#matlabdatabricksinternaldoclink)
      * [matlab.databricks.internal.getMetastoreURL](#matlabdatabricksinternalgetmetastoreurl)
      * [matlab.databricks.internal.htmlLink](#matlabdatabricksinternalhtmllink)
      * [matlab.databricks.internal.mdLink](#matlabdatabricksinternalmdlink)
      * [matlab.databricks.internal.responseError](#matlabdatabricksinternalresponseerror)
      * [matlab.databricks.internal.runParallelTasksJob](#matlabdatabricksinternalrunparalleltasksjob)
      * [matlab.databricks.internal.uploadArtifactsCICD](#matlabdatabricksinternaluploadartifactscicd)
    * [matlab.databricks.notebook](#matlabdatabricksnotebook)
      * [matlab.databricks.notebook.Notebook](#matlabdatabricksnotebooknotebook)
        * [matlab.databricks.notebook.Notebook.Notebook](#matlabdatabricksnotebooknotebooknotebook)
        * [matlab.databricks.notebook.Notebook.addInstallMavenSection](#matlabdatabricksnotebooknotebookaddinstallmavensection)
        * [matlab.databricks.notebook.Notebook.addSectionFromFile](#matlabdatabricksnotebooknotebookaddsectionfromfile)
        * [matlab.databricks.notebook.Notebook.addSectionHeader](#matlabdatabricksnotebooknotebookaddsectionheader)
        * [matlab.databricks.notebook.Notebook.addSectionLine](#matlabdatabricksnotebooknotebookaddsectionline)
        * [matlab.databricks.notebook.Notebook.addShellSectionHeader](#matlabdatabricksnotebooknotebookaddshellsectionheader)
        * [matlab.databricks.notebook.Notebook.addShellSectionLine](#matlabdatabricksnotebooknotebookaddshellsectionline)
        * [matlab.databricks.notebook.Notebook.comment](#matlabdatabricksnotebooknotebookcomment)
        * [matlab.databricks.notebook.Notebook.getString](#matlabdatabricksnotebooknotebookgetstring)
        * [matlab.databricks.notebook.Notebook.importNotebookToWorkspace](#matlabdatabricksnotebooknotebookimportnotebooktoworkspace)
        * [matlab.databricks.notebook.Notebook.init](#matlabdatabricksnotebooknotebookinit)
      * [matlab.databricks.notebook.NotebookType](#matlabdatabricksnotebooknotebooktype)
        * [matlab.databricks.notebook.NotebookType.NotebookType](#matlabdatabricksnotebooknotebooktypenotebooktype)
    * [matlab.databricks.setup](#matlabdatabrickssetup)
      * [matlab.databricks.setup.internal](#matlabdatabrickssetupinternal)
        * [matlab.databricks.setup.internal.checkDBCJCP](#matlabdatabrickssetupinternalcheckdbcjcp)
        * [matlab.databricks.setup.internal.configureAllowlist](#matlabdatabrickssetupinternalconfigureallowlist)
        * [matlab.databricks.setup.internal.dbcCreateVenv](#matlabdatabrickssetupinternaldbccreatevenv)
        * [matlab.databricks.setup.internal.depthReport](#matlabdatabrickssetupinternaldepthreport)
        * [matlab.databricks.setup.internal.initScriptMetastoreMsg](#matlabdatabrickssetupinternalinitscriptmetastoremsg)
        * [matlab.databricks.setup.internal.isClusterLocal](#matlabdatabrickssetupinternalisclusterlocal)
        * [matlab.databricks.setup.internal.javabuilderMetastoreMsg](#matlabdatabrickssetupinternaljavabuildermetastoremsg)
        * [matlab.databricks.setup.internal.pipDownload](#matlabdatabrickssetupinternalpipdownload)
        * [matlab.databricks.setup.internal.pipInstallFromDir](#matlabdatabrickssetupinternalpipinstallfromdir)
        * [matlab.databricks.setup.internal.pipPkgCheck](#matlabdatabrickssetupinternalpippkgcheck)
        * [matlab.databricks.setup.internal.pyModuleCheck](#matlabdatabrickssetupinternalpymodulecheck)
      * [matlab.databricks.setup.acceptRuntimeTCs](#matlabdatabrickssetupacceptruntimetcs)
      * [matlab.databricks.setup.archiveSettingsFiles](#matlabdatabrickssetuparchivesettingsfiles)
      * [matlab.databricks.setup.askForReleaseList](#matlabdatabrickssetupaskforreleaselist)
      * [matlab.databricks.setup.configureDBC](#matlabdatabrickssetupconfiguredbc)
      * [matlab.databricks.setup.configureJDBC](#matlabdatabrickssetupconfigurejdbc)
      * [matlab.databricks.setup.configureRuntimes](#matlabdatabrickssetupconfigureruntimes)
      * [matlab.databricks.setup.configureSettingsAndCfg](#matlabdatabrickssetupconfiguresettingsandcfg)
      * [matlab.databricks.setup.createClusterPolicies](#matlabdatabrickssetupcreateclusterpolicies)
      * [matlab.databricks.setup.deleteAuthTokens](#matlabdatabrickssetupdeleteauthtokens)
      * [matlab.databricks.setup.depthCheck](#matlabdatabrickssetupdepthcheck)
      * [matlab.databricks.setup.generateVolumeURL](#matlabdatabrickssetupgeneratevolumeurl)
      * [matlab.databricks.setup.provisionJavabuilderJars](#matlabdatabrickssetupprovisionjavabuilderjars)
      * [matlab.databricks.setup.provisionMATLABRuntimes](#matlabdatabrickssetupprovisionmatlabruntimes)
      * [matlab.databricks.setup.rmUnusedWhls](#matlabdatabrickssetuprmunusedwhls)
      * [matlab.databricks.setup.testCredentialsClusterList](#matlabdatabrickssetuptestcredentialsclusterlist)
      * [matlab.databricks.setup.uploadInitscript](#matlabdatabrickssetupuploadinitscript)
    * [matlab.databricks.unitycatalog](#matlabdatabricksunitycatalog)
      * [matlab.databricks.unitycatalog.addArtifactAllowlistItem](#matlabdatabricksunitycatalogaddartifactallowlistitem)
      * [matlab.databricks.unitycatalog.findArtifactInAllowlist](#matlabdatabricksunitycatalogfindartifactinallowlist)
      * [matlab.databricks.unitycatalog.getArtifactAllowlistItems](#matlabdatabricksunitycataloggetartifactallowlistitems)
      * [matlab.databricks.unitycatalog.removeArtifactAllowlistItem](#matlabdatabricksunitycatalogremoveartifactallowlistitem)
    * [matlab.databricks.vendor](#matlabdatabricksvendor)
      * [matlab.databricks.vendor.Vendor](#matlabdatabricksvendorvendor)
        * [matlab.databricks.vendor.Vendor.Vendor](#matlabdatabricksvendorvendorvendor)
      * [matlab.databricks.vendor.getVendor](#matlabdatabricksvendorgetvendor)
      * [matlab.databricks.vendor.getVendorFromAPI](#matlabdatabricksvendorgetvendorfromapi)
      * [matlab.databricks.vendor.getVendorFromCfgHost](#matlabdatabricksvendorgetvendorfromcfghost)
      * [matlab.databricks.vendor.getVendorFromEnvironment](#matlabdatabricksvendorgetvendorfromenvironment)
      * [matlab.databricks.vendor.getVendorFromHost](#matlabdatabricksvendorgetvendorfromhost)
      * [matlab.databricks.vendor.getVendorFromSettings](#matlabdatabricksvendorgetvendorfromsettings)
      * [matlab.databricks.vendor.setVendor](#matlabdatabricksvendorsetvendor)
      * [matlab.databricks.vendor.userRequestVendor](#matlabdatabricksvendoruserrequestvendor)
    * [matlab.databricks.workspace](#matlabdatabricksworkspace)
      * [matlab.databricks.workspace.getNotebookLink](#matlabdatabricksworkspacegetnotebooklink)
      * [matlab.databricks.workspace.import](#matlabdatabricksworkspaceimport)
    * [matlab.databricks.AuthMethod](#matlabdatabricksauthmethod)
      * [matlab.databricks.AuthMethod.AuthMethod](#matlabdatabricksauthmethodauthmethod)
      * [matlab.databricks.AuthMethod.authMethod2AuthType](#matlabdatabricksauthmethodauthmethod2authtype)
    * [matlab.databricks.OauthService](#matlabdatabricksoauthservice)
      * [matlab.databricks.OauthService.OauthService](#matlabdatabricksoauthserviceoauthservice)
    * [matlab.databricks.ReleaseConfig](#matlabdatabricksreleaseconfig)
      * [matlab.databricks.ReleaseConfig.ReleaseConfig](#matlabdatabricksreleaseconfigreleaseconfig)
      * [matlab.databricks.ReleaseConfig.adaptDatabricksRuntimes](#matlabdatabricksreleaseconfigadaptdatabricksruntimes)
      * [matlab.databricks.ReleaseConfig.adaptMATLABReleases](#matlabdatabricksreleaseconfigadaptmatlabreleases)
      * [matlab.databricks.ReleaseConfig.defaultConfig](#matlabdatabricksreleaseconfigdefaultconfig)
      * [matlab.databricks.ReleaseConfig.getUbuntuVersion](#matlabdatabricksreleaseconfiggetubuntuversion)
      * [matlab.databricks.ReleaseConfig.matlabDatabricksCombinationSupported](#matlabdatabricksreleaseconfigmatlabdatabrickscombinationsupported)
    * [matlab.databricks.ResponseException](#matlabdatabricksresponseexception)
      * [matlab.databricks.ResponseException.ResponseException](#matlabdatabricksresponseexceptionresponseexception)
    * [matlab.databricks.SimulinkTempFileManager](#matlabdatabrickssimulinktempfilemanager)
      * [matlab.databricks.SimulinkTempFileManager.SimulinkTempFileManager](#matlabdatabrickssimulinktempfilemanagersimulinktempfilemanager)
      * [matlab.databricks.SimulinkTempFileManager.delete](#matlabdatabrickssimulinktempfilemanagerdelete)
      * [matlab.databricks.SimulinkTempFileManager.log](#matlabdatabrickssimulinktempfilemanagerlog)
      * [matlab.databricks.SimulinkTempFileManager.setup](#matlabdatabrickssimulinktempfilemanagersetup)
    * [matlab.databricks.StructOrCellDeserializable](#matlabdatabricksstructorcelldeserializable)
      * [matlab.databricks.StructOrCellDeserializable.StructOrCellDeserializable](#matlabdatabricksstructorcelldeserializablestructorcelldeserializable)
      * [matlab.databricks.StructOrCellDeserializable.fromStructOrCell](#matlabdatabricksstructorcelldeserializablefromstructorcell)
    * [matlab.databricks.cli](#matlabdatabrickscli)
    * [matlab.databricks.databricksDiagnostics](#matlabdatabricksdatabricksdiagnostics)
    * [matlab.databricks.databricksPackageVersion](#matlabdatabricksdatabrickspackageversion)
    * [matlab.databricks.detectProxy](#matlabdatabricksdetectproxy)
    * [matlab.databricks.doc](#matlabdatabricksdoc)
    * [matlab.databricks.finish](#matlabdatabricksfinish)
    * [matlab.databricks.getDefaultRuntimeJars](#matlabdatabricksgetdefaultruntimejars)
    * [matlab.databricks.getMATLABInterfacePackage](#matlabdatabricksgetmatlabinterfacepackage)
    * [matlab.databricks.help](#matlabdatabrickshelp)
    * [matlab.databricks.startGenieChat](#matlabdatabricksstartgeniechat)
  * [addDatabricksPaths](#adddatabrickspaths)
  * [createDatabricksCluster](#createdatabrickscluster)
  * [databricksRoot](#databricksroot)
  * [finish](#finish)
  * [getDatabricksSession](#getdatabrickssession)
  * [onDatabricksSetup](#ondatabrickssetup)
  * [updateClusterId](#updateclusterid)

## Help

### databricks

### databricks.datastructures

### databricks.datastructures.apps

### databricks.datastructures.apps.App

Superclass: JSONMapper

```text
APP
 
  App API 2.0
```

#### databricks.datastructures.apps.App.App

```text
APP
 
  App API 2.0

    Documentation for databricks.datastructures.apps.App
```

### databricks.datastructures.apps.AppDeployment

Superclass: JSONMapper

```text
APPDEPLOYMENT
 
  App API 2.0
```

#### databricks.datastructures.apps.AppDeployment.AppDeployment

```text
APPDEPLOYMENT
 
  App API 2.0

    Documentation for databricks.datastructures.apps.AppDeployment
```

### databricks.datastructures.apps.AppPermission

Superclass: JSONEnum

```text
APPPERMISSION
 
  Example:
    appPermission = databricks.datastructures.apps.AppPermission.CAN_USE
```

```text
Enumeration values:
  CAN_USE

```

#### databricks.datastructures.apps.AppPermission.AppPermission

```text
APPPERMISSION
 
  Example:
    appPermission = databricks.datastructures.apps.AppPermission.CAN_USE

    Documentation for databricks.datastructures.apps.AppPermission
```

### databricks.datastructures.apps.AppState

Superclass: JSONEnum

```text
AppState
 
  Example:
    state = databricks.datastructures.apps.AppState.DEPLOYING
```

```text
Enumeration values:
  DEPLOYING
  RUNNING
  CRASHED
  UNAVAILABLE

```

#### databricks.datastructures.apps.AppState.AppState

```text
AppState
 
  Example:
    state = databricks.datastructures.apps.AppState.DEPLOYING

    Documentation for databricks.datastructures.apps.AppState
```

### databricks.datastructures.apps.AppStatus

Superclass: JSONMapper

```text
APPSTATUS
 
  App API 2.0
```

#### databricks.datastructures.apps.AppStatus.AppStatus

```text
APPSTATUS
 
  App API 2.0

    Documentation for databricks.datastructures.apps.AppStatus
```

### databricks.datastructures.apps.ComputeSize

Superclass: JSONEnum

```text
ComputeSize The mode of which the deployment will manage the source code
 
  Example:
    computeSize = databricks.datastructures.apps.ComputeSize.LARGE
```

```text
Enumeration values:
  MEDIUM
  LARGE

```

#### databricks.datastructures.apps.ComputeSize.ComputeSize

```text
ComputeSize The mode of which the deployment will manage the source code
 
  Example:
    computeSize = databricks.datastructures.apps.ComputeSize.LARGE

    Documentation for databricks.datastructures.apps.ComputeSize
```

### databricks.datastructures.apps.ComputeState

Superclass: JSONEnum

```text
ComputeState
 
  Example:
    state = databricks.datastructures.apps.ComputeState.ERROR
```

```text
Enumeration values:
  ERROR
  DELETING
  STARTING
  STOPPING
  UPDATING
  STOPPED
  ACTIVE

```

#### databricks.datastructures.apps.ComputeState.ComputeState

```text
ComputeState
 
  Example:
    state = databricks.datastructures.apps.ComputeState.ERROR

    Documentation for databricks.datastructures.apps.ComputeState
```

### databricks.datastructures.apps.ComputeStatus

Superclass: JSONMapper

```text
ComputeStatus
 
  App API 2.0
```

#### databricks.datastructures.apps.ComputeStatus.ComputeStatus

```text
ComputeStatus
 
  App API 2.0

    Documentation for databricks.datastructures.apps.ComputeStatus
```

### databricks.datastructures.apps.CreateAppRequest

Superclass: JSONMapper

```text
CreateAppRequest
 
  App API 2.0
```

#### databricks.datastructures.apps.CreateAppRequest.CreateAppRequest

```text
CreateAppRequest
 
  App API 2.0

    Documentation for databricks.datastructures.apps.CreateAppRequest
```

### databricks.datastructures.apps.CreateAppResponse

Superclass: JSONMapper

```text
CreateAppResponse
 
  App API 2.0
```

#### databricks.datastructures.apps.CreateAppResponse.CreateAppResponse

```text
CreateAppResponse
 
  App API 2.0

    Documentation for databricks.datastructures.apps.CreateAppResponse
```

### databricks.datastructures.apps.CreateDeploymentRequest

Superclass: JSONMapper

```text
CreateDeploymentRequest
 
  App API 2.0
```

#### databricks.datastructures.apps.CreateDeploymentRequest.CreateDeploymentRequest

```text
CreateDeploymentRequest
 
  App API 2.0

    Documentation for databricks.datastructures.apps.CreateDeploymentRequest
```

### databricks.datastructures.apps.CreateDeploymentResponse

Superclass: JSONMapper

```text
CreateDeploymentResponse
 
  App API 2.0
```

#### databricks.datastructures.apps.CreateDeploymentResponse.CreateDeploymentResponse

```text
CreateDeploymentResponse
 
  App API 2.0

    Documentation for databricks.datastructures.apps.CreateDeploymentResponse
```

### databricks.datastructures.apps.Database

Superclass: JSONMapper

```text
DATABASE
 
  App API 2.0
```

#### databricks.datastructures.apps.Database.Database

```text
DATABASE
 
  App API 2.0

    Documentation for databricks.datastructures.apps.Database
```

### databricks.datastructures.apps.DatabasePermission

Superclass: JSONEnum

```text
DATABASEPERMISSION
 
  Example:
    databasePermission = databricks.datastructures.apps.DatabasePermission.CAN_CONNECT_AND_CREATE
```

```text
Enumeration values:
  CAN_CONNECT_AND_CREATE

```

#### databricks.datastructures.apps.DatabasePermission.DatabasePermission

```text
DATABASEPERMISSION
 
  Example:
    databasePermission = databricks.datastructures.apps.DatabasePermission.CAN_CONNECT_AND_CREATE

    Documentation for databricks.datastructures.apps.DatabasePermission
```

### databricks.datastructures.apps.DeleteAppResponse

Superclass: JSONMapper

```text
DeleteAppResponse
 
  App API 2.0
```

#### databricks.datastructures.apps.DeleteAppResponse.DeleteAppResponse

```text
DeleteAppResponse
 
  App API 2.0

    Documentation for databricks.datastructures.apps.DeleteAppResponse
```

### databricks.datastructures.apps.DeleteThumbnailResponse

Superclass: JSONMapper

```text
DeleteThumbnailResponse
 
  Empty response returned when deleting an app thumbnail.
```

#### databricks.datastructures.apps.DeleteThumbnailResponse.DeleteThumbnailResponse

```text
DeleteThumbnailResponse
 
  Empty response returned when deleting an app thumbnail.

    Documentation for databricks.datastructures.apps.DeleteThumbnailResponse
```

### databricks.datastructures.apps.DeploymentArtifacts

Superclass: JSONMapper

```text
DEPLOYMENTARTIFACTS The deployment artifacts for an app
 
  App API 2.0
```

#### databricks.datastructures.apps.DeploymentArtifacts.DeploymentArtifacts

```text
DEPLOYMENTARTIFACTS The deployment artifacts for an app
 
  App API 2.0

    Documentation for databricks.datastructures.apps.DeploymentArtifacts
```

### databricks.datastructures.apps.DeploymentState

Superclass: JSONEnum

```text
DeploymentState State of the deployment
 
  Example:
    state = databricks.datastructures.apps.DeploymentState.SUCCEEDED
```

```text
Enumeration values:
  SUCCEEDED
  FAILED
  IN_PROGRESS
  CANCELLED

```

#### databricks.datastructures.apps.DeploymentState.DeploymentState

```text
DeploymentState State of the deployment
 
  Example:
    state = databricks.datastructures.apps.DeploymentState.SUCCEEDED

    Documentation for databricks.datastructures.apps.DeploymentState
```

### databricks.datastructures.apps.DeploymentStatus

Superclass: JSONMapper

```text
DEPLOYMENTSTATUS
 
  App API 2.0
```

#### databricks.datastructures.apps.DeploymentStatus.DeploymentStatus

```text
DEPLOYMENTSTATUS
 
  App API 2.0

    Documentation for databricks.datastructures.apps.DeploymentStatus
```

### databricks.datastructures.apps.EnvVar

Superclass: JSONMapper

```text
ENVVAR The environment variables to set in the app runtime environment
  This will override the environment variables specified in the app.yaml file.
 
  App API 2.0
```

#### databricks.datastructures.apps.EnvVar.EnvVar

```text
ENVVAR The environment variables to set in the app runtime environment
  This will override the environment variables specified in the app.yaml file.
 
  App API 2.0

    Documentation for databricks.datastructures.apps.EnvVar
```

### databricks.datastructures.apps.Experiment

Superclass: JSONMapper

```text
EXPERIMENT
 
  App API 2.0
```

#### databricks.datastructures.apps.Experiment.Experiment

```text
EXPERIMENT
 
  App API 2.0

    Documentation for databricks.datastructures.apps.Experiment
```

### databricks.datastructures.apps.ExperimentPermission

Superclass: JSONEnum

```text
ExperimentPermission
 
  Example:
    ExperimentPermission = databricks.datastructures.apps.ExperimentPermission.CAN_MANAGE
```

```text
Enumeration values:
  CAN_MANAGE
  CAN_EDIT
  CAN_READ

```

#### databricks.datastructures.apps.ExperimentPermission.ExperimentPermission

```text
ExperimentPermission
 
  Example:
    ExperimentPermission = databricks.datastructures.apps.ExperimentPermission.CAN_MANAGE

    Documentation for databricks.datastructures.apps.ExperimentPermission
```

### databricks.datastructures.apps.GeniePermission

Superclass: JSONEnum

```text
GeniePermission
 
  Example:
    GeniePermission = databricks.datastructures.apps.GeniePermission.CAN_MANAGE
```

```text
Enumeration values:
  CAN_MANAGE
  CAN_EDIT
  CAN_RUN
  CAN_VIEW

```

#### databricks.datastructures.apps.GeniePermission.GeniePermission

```text
GeniePermission
 
  Example:
    GeniePermission = databricks.datastructures.apps.GeniePermission.CAN_MANAGE

    Documentation for databricks.datastructures.apps.GeniePermission
```

### databricks.datastructures.apps.GenieSpace

Superclass: JSONMapper

```text
GenieSpace
 
  App API 2.0
```

#### databricks.datastructures.apps.GenieSpace.GenieSpace

```text
GenieSpace
 
  App API 2.0

    Documentation for databricks.datastructures.apps.GenieSpace
```

### databricks.datastructures.apps.GetAppResponse

Superclass: JSONMapper

```text
GetAppResponse
 
  App API 2.0
```

#### databricks.datastructures.apps.GetAppResponse.GetAppResponse

```text
GetAppResponse
 
  App API 2.0

    Documentation for databricks.datastructures.apps.GetAppResponse
```

### databricks.datastructures.apps.GetDeploymentResponse

Superclass: JSONMapper

```text
GetDeploymentResponse
 
  App API 2.0
 
  See also: https://docs.databricks.com/api/workspace/apps/getdeployment
```

#### databricks.datastructures.apps.GetDeploymentResponse.GetDeploymentResponse

```text
GetDeploymentResponse
 
  App API 2.0
 
  See also: https://docs.databricks.com/api/workspace/apps/getdeployment

    Documentation for databricks.datastructures.apps.GetDeploymentResponse
```

### databricks.datastructures.apps.GitRepository

Superclass: JSONMapper

```text
GitRepository Git repository configuration, populated from the app's git_repository configuration
 
  App API 2.0
```

#### databricks.datastructures.apps.GitRepository.GitRepository

```text
GitRepository Git repository configuration, populated from the app's git_repository configuration
 
  App API 2.0

    Documentation for databricks.datastructures.apps.GitRepository
```

### databricks.datastructures.apps.GitSource

Superclass: JSONMapper

```text
GitSource Git repository to use as the source for the app deployment
 
  App API 2.0
```

#### databricks.datastructures.apps.GitSource.GitSource

```text
GitSource Git repository to use as the source for the app deployment
 
  App API 2.0

    Documentation for databricks.datastructures.apps.GitSource
```

### databricks.datastructures.apps.Job

Superclass: JSONMapper

```text
Job
 
  App API 2.0
```

#### databricks.datastructures.apps.Job.Job

```text
Job
 
  App API 2.0

    Documentation for databricks.datastructures.apps.Job
```

### databricks.datastructures.apps.JobPermission

Superclass: JSONEnum

```text
JobPermission
 
  Example:
    JobPermission = databricks.datastructures.apps.JobPermission.CAN_MANAGE
```

```text
Enumeration values:
  CAN_MANAGE
  IS_OWNER
  CAN_MANAGE_RUN
  CAN_VIEW

```

#### databricks.datastructures.apps.JobPermission.JobPermission

```text
JobPermission
 
  Example:
    JobPermission = databricks.datastructures.apps.JobPermission.CAN_MANAGE

    Documentation for databricks.datastructures.apps.JobPermission
```

### databricks.datastructures.apps.ListAppsResponse

Superclass: JSONMapper

```text
ListAppsResponse
 
  App API 2.0
```

#### databricks.datastructures.apps.ListAppsResponse.ListAppsResponse

```text
ListAppsResponse
 
  App API 2.0

    Documentation for databricks.datastructures.apps.ListAppsResponse
```

### databricks.datastructures.apps.ListAppsResult

Superclass: JSONMapper

```text
ListAppsResult Class to represent app list results
```

#### databricks.datastructures.apps.ListAppsResult.ListAppsResult

```text
ListAppsResult Class to represent app list results

    Documentation for databricks.datastructures.apps.ListAppsResult
```

### databricks.datastructures.apps.ListDeploymentResult

Superclass: JSONMapper

```text
ListDeploymentResult Class to represent app deployment list results
```

#### databricks.datastructures.apps.ListDeploymentResult.ListDeploymentResult

```text
ListDeploymentResult Class to represent app deployment list results

    Documentation for databricks.datastructures.apps.ListDeploymentResult
```

### databricks.datastructures.apps.Mode

Superclass: JSONEnum

```text
Mode The mode of which the deployment will manage the source code
 
  Example:
    mode = databricks.datastructures.apps.Mode.SNAPSHOT
```

```text
Enumeration values:
  SNAPSHOT
  AUTO_SYNC

```

#### databricks.datastructures.apps.Mode.Mode

```text
Mode The mode of which the deployment will manage the source code
 
  Example:
    mode = databricks.datastructures.apps.Mode.SNAPSHOT

    Documentation for databricks.datastructures.apps.Mode
```

### databricks.datastructures.apps.Postgres

Superclass: JSONMapper

```text
Postgres
 
  App API 2.0
```

#### databricks.datastructures.apps.Postgres.Postgres

```text
Postgres
 
  App API 2.0

    Documentation for databricks.datastructures.apps.Postgres
```

### databricks.datastructures.apps.PostgresPermission

Superclass: JSONEnum

```text
PostgresPermission
 
  Example:
    postgresPermission = databricks.datastructures.apps.PostgresPermission.CAN_CONNECT_AND_CREATE
```

```text
Enumeration values:
  CAN_CONNECT_AND_CREATE

```

#### databricks.datastructures.apps.PostgresPermission.PostgresPermission

```text
PostgresPermission
 
  Example:
    postgresPermission = databricks.datastructures.apps.PostgresPermission.CAN_CONNECT_AND_CREATE

    Documentation for databricks.datastructures.apps.PostgresPermission
```

### databricks.datastructures.apps.Resource

Superclass: JSONMapper

```text
RESOURCE
 
  App API 2.0
```

#### databricks.datastructures.apps.Resource.Resource

```text
RESOURCE
 
  App API 2.0

    Documentation for databricks.datastructures.apps.Resource
```

### databricks.datastructures.apps.SQLWarehouse

Superclass: JSONMapper

```text
SQLWarehouse
 
  App API 2.0
```

#### databricks.datastructures.apps.SQLWarehouse.SQLWarehouse

```text
SQLWarehouse
 
  App API 2.0

    Documentation for databricks.datastructures.apps.SQLWarehouse
```

### databricks.datastructures.apps.SQLWarehousePermission

Superclass: JSONEnum

```text
SQLWarehousePermission Permission to grant on the serving endpoint
  Supported permissions are: "CAN_MANAGE", "CAN_QUERY", "CAN_VIEW".
 
  Example:
    SQLWarehousePermission = databricks.datastructures.apps.SQLWarehousePermission.CAN_MANAGE
```

```text
Enumeration values:
  CAN_MANAGE
  CAN_USE
  IS_OWNER

```

#### databricks.datastructures.apps.SQLWarehousePermission.SQLWarehousePermission

```text
SQLWarehousePermission Permission to grant on the serving endpoint
  Supported permissions are: "CAN_MANAGE", "CAN_QUERY", "CAN_VIEW".
 
  Example:
    SQLWarehousePermission = databricks.datastructures.apps.SQLWarehousePermission.CAN_MANAGE

    Documentation for databricks.datastructures.apps.SQLWarehousePermission
```

### databricks.datastructures.apps.Secret

Superclass: JSONMapper

```text
Secret
 
  App API 2.0
```

#### databricks.datastructures.apps.Secret.Secret

```text
Secret
 
  App API 2.0

    Documentation for databricks.datastructures.apps.Secret
```

### databricks.datastructures.apps.SecretPermission

Superclass: JSONEnum

```text
SecretPermission
 
  Example:
    secretPermission = databricks.datastructures.apps.SecretPermission.READ
```

```text
Enumeration values:
  READ
  WRITE
  MANAGE

```

#### databricks.datastructures.apps.SecretPermission.SecretPermission

```text
SecretPermission
 
  Example:
    secretPermission = databricks.datastructures.apps.SecretPermission.READ

    Documentation for databricks.datastructures.apps.SecretPermission
```

### databricks.datastructures.apps.ServingEndpoint

Superclass: JSONMapper

```text
ServingEndpoint
 
  App API 2.0
```

#### databricks.datastructures.apps.ServingEndpoint.ServingEndpoint

```text
ServingEndpoint
 
  App API 2.0

    Documentation for databricks.datastructures.apps.ServingEndpoint
```

### databricks.datastructures.apps.ServingPermission

Superclass: JSONEnum

```text
ServingPermission Permission to grant on the serving endpoint
  Supported permissions are: "CAN_MANAGE", "CAN_QUERY", "CAN_VIEW".
 
  Example:
    servingPermission = databricks.datastructures.apps.ServingPermission.CAN_MANAGE
```

```text
Enumeration values:
  CAN_MANAGE
  CAN_QUERY
  CAN_VIEW

```

#### databricks.datastructures.apps.ServingPermission.ServingPermission

```text
ServingPermission Permission to grant on the serving endpoint
  Supported permissions are: "CAN_MANAGE", "CAN_QUERY", "CAN_VIEW".
 
  Example:
    servingPermission = databricks.datastructures.apps.ServingPermission.CAN_MANAGE

    Documentation for databricks.datastructures.apps.ServingPermission
```

### databricks.datastructures.apps.StartAppResponse

Superclass: JSONMapper

```text
StartAppResponse
 
  App API 2.0
```

#### databricks.datastructures.apps.StartAppResponse.StartAppResponse

```text
StartAppResponse
 
  App API 2.0

    Documentation for databricks.datastructures.apps.StartAppResponse
```

### databricks.datastructures.apps.StopAppResponse

Superclass: JSONMapper

```text
StopAppResponse
 
  App API 2.0
```

#### databricks.datastructures.apps.StopAppResponse.StopAppResponse

```text
StopAppResponse
 
  App API 2.0

    Documentation for databricks.datastructures.apps.StopAppResponse
```

### databricks.datastructures.apps.TelemetryExportDestination

Superclass: JSONMapper

```text
TelemetryExportDestination
 
  App API 2.0
```

#### databricks.datastructures.apps.TelemetryExportDestination.TelemetryExportDestination

```text
TelemetryExportDestination
 
  App API 2.0

    Documentation for databricks.datastructures.apps.TelemetryExportDestination
```

### databricks.datastructures.apps.Thumbnail

Superclass: JSONMapper

```text
Thumbnail
 
  The thumbnail for an app.
```

#### databricks.datastructures.apps.Thumbnail.Thumbnail

```text
Thumbnail
 
  The thumbnail for an app.

    Documentation for databricks.datastructures.apps.Thumbnail
```

### databricks.datastructures.apps.UCSecurable

Superclass: JSONMapper

```text
UCSecurable
 
  App API 2.0
```

#### databricks.datastructures.apps.UCSecurable.UCSecurable

```text
UCSecurable
 
  App API 2.0

    Documentation for databricks.datastructures.apps.UCSecurable
```

### databricks.datastructures.apps.UCSecurablePermission

Superclass: JSONEnum

```text
UCSecurablePermission
 
  Example:
    ucSecurablePermission = databricks.datastructures.apps.UCSecurablePermission.READ_VOLUME
```

```text
Enumeration values:
  READ_VOLUME
  WRITE_VOLUME
  SELECT
  EXECUTE
  USE_CONNECTION
  MODIFY

```

#### databricks.datastructures.apps.UCSecurablePermission.UCSecurablePermission

```text
UCSecurablePermission
 
  Example:
    ucSecurablePermission = databricks.datastructures.apps.UCSecurablePermission.READ_VOLUME

    Documentation for databricks.datastructures.apps.UCSecurablePermission
```

### databricks.datastructures.apps.UCSecurableType

Superclass: JSONEnum

```text
UCSecurableType
 
  Example:
    ucSecurableType = databricks.datastructures.apps.UCSecurableType.VOLUME
```

```text
Enumeration values:
  VOLUME
  TABLE
  FUNCTION
  CONNECTION

```

#### databricks.datastructures.apps.UCSecurableType.UCSecurableType

```text
UCSecurableType
 
  Example:
    ucSecurableType = databricks.datastructures.apps.UCSecurableType.VOLUME

    Documentation for databricks.datastructures.apps.UCSecurableType
```

### databricks.datastructures.apps.UnityCatalog

Superclass: JSONMapper

```text
UnityCatalog
 
  App API 2.0
```

#### databricks.datastructures.apps.UnityCatalog.UnityCatalog

```text
UnityCatalog
 
  App API 2.0

    Documentation for databricks.datastructures.apps.UnityCatalog
```

### databricks.datastructures.apps.UpdateThumbnailRequest

Superclass: JSONMapper

```text
UpdateThumbnailRequest
 
  App API 2.0
```

#### databricks.datastructures.apps.UpdateThumbnailRequest.UpdateThumbnailRequest

```text
UpdateThumbnailRequest
 
  App API 2.0

    Documentation for databricks.datastructures.apps.UpdateThumbnailRequest
```

### databricks.datastructures.clusterpolicy

### databricks.datastructures.clusterpolicy.AccessControlList

Superclass: JSONMapper

```text
ACCESSCONTROLLIST Represents all permissions
 
  See: https://docs.databricks.com/api/workspace/clusterpolicies/getpermissions#access_control_list-all_permissions
```

#### databricks.datastructures.clusterpolicy.AccessControlList.AccessControlList

```text
ACCESSCONTROLLIST Represents all permissions
 
  See: https://docs.databricks.com/api/workspace/clusterpolicies/getpermissions#access_control_list-all_permissions

    Documentation for databricks.datastructures.clusterpolicy.AccessControlList
```

### databricks.datastructures.clusterpolicy.AllPermissions

Superclass: JSONMapper

```text
ALLPERMISSIONS Represents all permissions
 
  See: https://docs.databricks.com/api/workspace/clusterpolicies/getpermissions#access_control_list-all_permissions
```

#### databricks.datastructures.clusterpolicy.AllPermissions.AllPermissions

```text
ALLPERMISSIONS Represents all permissions
 
  See: https://docs.databricks.com/api/workspace/clusterpolicies/getpermissions#access_control_list-all_permissions

    Documentation for databricks.datastructures.clusterpolicy.AllPermissions
```

### databricks.datastructures.clusterpolicy.CreateRequest

Superclass: JSONMapper

```text
CREATEREQUEST Represents a Databricks Cluster Policy Creation Request
 
 
  Properties:
    name: Cluster Policy name requested by the user. This has to be unique.
          Length must be between 1 and 100 characters.
 
    definition: Policy definition document expressed in Databricks Cluster
                Policy Definition Language. The value will be automatically escaped.
 
    description: Additional human-readable description of the cluster policy,
                 <= 1000 characters.
 
    policyFamilyId: ID of the policy family. The cluster policy's policy definition
                    inherits the policy family's policy definition.
 
    policyFamilyDefinitionOverrides: Policy definition JSON document expressed in
                                     Databricks Policy Definition Language.
 
    maxClustersPerUser: Max number of clusters per user that can be active using this policy. If not present, there is no max limit.
 
    libraries: A list of libraries to be installed on the next cluster restart that uses this policy. The maximum number of libraries is 500.
 
 
  See: https://docs.databricks.com/api/workspace/clusterpolicies/get
       https://docs.databricks.com/en/admin/clusters/policy-definition.html
```

#### databricks.datastructures.clusterpolicy.CreateRequest.CreateRequest

```text
CREATEREQUEST Represents a Databricks Cluster Policy Creation Request
 
 
  Properties:
    name: Cluster Policy name requested by the user. This has to be unique.
          Length must be between 1 and 100 characters.
 
    definition: Policy definition document expressed in Databricks Cluster
                Policy Definition Language. The value will be automatically escaped.
 
    description: Additional human-readable description of the cluster policy,
                 <= 1000 characters.
 
    policyFamilyId: ID of the policy family. The cluster policy's policy definition
                    inherits the policy family's policy definition.
 
    policyFamilyDefinitionOverrides: Policy definition JSON document expressed in
                                     Databricks Policy Definition Language.
 
    maxClustersPerUser: Max number of clusters per user that can be active using this policy. If not present, there is no max limit.
 
    libraries: A list of libraries to be installed on the next cluster restart that uses this policy. The maximum number of libraries is 500.
 
 
  See: https://docs.databricks.com/api/workspace/clusterpolicies/get
       https://docs.databricks.com/en/admin/clusters/policy-definition.html

    Documentation for databricks.datastructures.clusterpolicy.CreateRequest
```

### databricks.datastructures.clusterpolicy.CreateResponse

Superclass: JSONMapper

```text
CREATERESPONSE Represents a Databricks Cluster Policy Creation Response
 
  Properties
    policyId: Canonical unique identifier for the Cluster Policy
 
  See: https://docs.databricks.com/api/workspace/clusterpolicies/get
       https://docs.databricks.com/en/admin/clusters/policy-definition.html
```

#### databricks.datastructures.clusterpolicy.CreateResponse.CreateResponse

```text
CREATERESPONSE Represents a Databricks Cluster Policy Creation Response
 
  Properties
    policyId: Canonical unique identifier for the Cluster Policy
 
  See: https://docs.databricks.com/api/workspace/clusterpolicies/get
       https://docs.databricks.com/en/admin/clusters/policy-definition.html

    Documentation for databricks.datastructures.clusterpolicy.CreateResponse
```

### databricks.datastructures.clusterpolicy.ErrorResponse

Superclass: JSONMapper

```text
ErrorResponse Error response body
 
  databricks.datastructures.clusterpolicy.ErrorResponse Properties:
    errorCode
    message
```

#### databricks.datastructures.clusterpolicy.ErrorResponse.ErrorResponse

```text
ErrorResponse Error response body
 
  databricks.datastructures.clusterpolicy.ErrorResponse Properties:
    errorCode
    message

    Documentation for databricks.datastructures.clusterpolicy.ErrorResponse
```

#### databricks.datastructures.clusterpolicy.ErrorResponse.throw

```text
databricks.datastructures.clusterpolicy.ErrorResponse/throw is a function.
    throw(obj)
```

### databricks.datastructures.clusterpolicy.GetPermissionLevelsResponse

Superclass: JSONMapper

```text
GETPERMISSIONLEVELSRESPONSE Gets the permission levels that a user can have on an object response
 
  Properties
    permissionLevels: Specific permission levels
```

#### databricks.datastructures.clusterpolicy.GetPermissionLevelsResponse.GetPermissionLevelsResponse

```text
GETPERMISSIONLEVELSRESPONSE Gets the permission levels that a user can have on an object response
 
  Properties
    permissionLevels: Specific permission levels

    Documentation for databricks.datastructures.clusterpolicy.GetPermissionLevelsResponse
```

### databricks.datastructures.clusterpolicy.GetPermissionsResponse

Superclass: JSONMapper

```text
GETPERMISSIONSRESPONSE Response to get cluster policy permissions 
 
  See: https://docs.databricks.com/api/workspace/clusterpolicies/getpermissions#access_control_list-all_permissions
```

#### databricks.datastructures.clusterpolicy.GetPermissionsResponse.GetPermissionsResponse

```text
GETPERMISSIONSRESPONSE Response to get cluster policy permissions 
 
  See: https://docs.databricks.com/api/workspace/clusterpolicies/getpermissions#access_control_list-all_permissions

    Documentation for databricks.datastructures.clusterpolicy.GetPermissionsResponse
```

### databricks.datastructures.clusterpolicy.ListOrder

```text
ListOrder Enumeration for list orders in Databricks
```

```text
Enumeration values:
  DESC
  ASC

```

#### databricks.datastructures.clusterpolicy.ListOrder.ListOrder

```text
ListOrder Enumeration for list orders in Databricks

    Documentation for databricks.datastructures.clusterpolicy.ListOrder
```

### databricks.datastructures.clusterpolicy.ListResponse

Superclass: JSONMapper

```text
LISTRESPONSE Represents a Databricks Cluster Policy List Response
 
  See: https://docs.databricks.com/api/workspace/clusterpolicies/get
       https://docs.databricks.com/en/admin/clusters/policy-definition.html
```

#### databricks.datastructures.clusterpolicy.ListResponse.ListResponse

```text
LISTRESPONSE Represents a Databricks Cluster Policy List Response
 
  See: https://docs.databricks.com/api/workspace/clusterpolicies/get
       https://docs.databricks.com/en/admin/clusters/policy-definition.html

    Documentation for databricks.datastructures.clusterpolicy.ListResponse
```

### databricks.datastructures.clusterpolicy.PermissionLevel

Superclass: JSONMapper

```text
PERMISSIONLEVEL Represents specific permission level
 
  See: https://docs.databricks.com/api/workspace/clusterpolicies/getpermissionlevels#permission_levels-permission_level
```

#### databricks.datastructures.clusterpolicy.PermissionLevel.PermissionLevel

```text
PERMISSIONLEVEL Represents specific permission level
 
  See: https://docs.databricks.com/api/workspace/clusterpolicies/getpermissionlevels#permission_levels-permission_level

    Documentation for databricks.datastructures.clusterpolicy.PermissionLevel
```

### databricks.datastructures.clusterpolicy.Policy

Superclass: JSONMapper

```text
POLICY Represents a Databricks Cluster Policy
 
  See: https://docs.databricks.com/api/workspace/clusterpolicies/get
       https://docs.databricks.com/en/admin/clusters/policy-definition.html
```

#### databricks.datastructures.clusterpolicy.Policy.Policy

```text
POLICY Represents a Databricks Cluster Policy
 
  See: https://docs.databricks.com/api/workspace/clusterpolicies/get
       https://docs.databricks.com/en/admin/clusters/policy-definition.html

    Documentation for databricks.datastructures.clusterpolicy.Policy
```

### databricks.datastructures.clusterpolicy.PolicySortColumn

```text
PolicySortColumn Enumeration for policy sort columns in Databricks
```

```text
Enumeration values:
  POLICY_CREATION_TIME
  POLICY_NAME

```

#### databricks.datastructures.clusterpolicy.PolicySortColumn.PolicySortColumn

```text
PolicySortColumn Enumeration for policy sort columns in Databricks

    Documentation for databricks.datastructures.clusterpolicy.PolicySortColumn
```

### databricks.datastructures.clusterpolicy.PolicyUpdateRequest

Superclass: JSONMapper

```text
POLICYUPDATEREQUEST Represents a Databricks Cluster Policy update
 
  See: https://docs.databricks.com/api/workspace/clusterpolicies/get
       https://docs.databricks.com/en/admin/clusters/policy-definition.html
```

#### databricks.datastructures.clusterpolicy.PolicyUpdateRequest.PolicyUpdateRequest

```text
POLICYUPDATEREQUEST Represents a Databricks Cluster Policy update
 
  See: https://docs.databricks.com/api/workspace/clusterpolicies/get
       https://docs.databricks.com/en/admin/clusters/policy-definition.html

    Documentation for databricks.datastructures.clusterpolicy.PolicyUpdateRequest
```

### databricks.datastructures.commandexecution

### databricks.datastructures.commandexecution.CancelRequest

Superclass: JSONMapper

```text
CancelRequest Databricks Data Structure
 
  databricks.datastructures.commandexecution.CancelRequest Properties:
    clusterId - Running cluster id
    contextId - ID of context
    commandId - ID of command to cancel
```

#### databricks.datastructures.commandexecution.CancelRequest.CancelRequest

```text
CancelRequest Databricks Data Structure
 
  databricks.datastructures.commandexecution.CancelRequest Properties:
    clusterId - Running cluster id
    contextId - ID of context
    commandId - ID of command to cancel

    Documentation for databricks.datastructures.commandexecution.CancelRequest
```

#### databricks.datastructures.commandexecution.CancelRequest.fromInputs

```text
FROMINPUTS creates an instance of the class with specific
  properties set to specific values. For each property that is
  to be set, provide the property name and desired value as 
  Name-Value pairs.
```

### databricks.datastructures.commandexecution.CommandsStatusResponse

Superclass: JSONMapper

```text
CommandsStatusResponse Databricks Data Structure
 
  databricks.datastructures.commandexecution.CommandsStatusResponse Properties:
    id - Commmand ID
    status - Enumeration: "Cancelled" "Cancelling" "Error" "Finished" "Queued" "Running"
    results - databricks.datastructures.commandexecution.CommandsStatusResults
```

#### databricks.datastructures.commandexecution.CommandsStatusResponse.CommandsStatusResponse

```text
CommandsStatusResponse Databricks Data Structure
 
  databricks.datastructures.commandexecution.CommandsStatusResponse Properties:
    id - Commmand ID
    status - Enumeration: "Cancelled" "Cancelling" "Error" "Finished" "Queued" "Running"
    results - databricks.datastructures.commandexecution.CommandsStatusResults

    Documentation for databricks.datastructures.commandexecution.CommandsStatusResponse
```

### databricks.datastructures.commandexecution.CommandsStatusResults

Superclass: JSONMapper

```text
CommandsStatusResults Databricks Data Structure
  
  databricks.datastructures.commandexecution.CommandsStatusResults Properties:
    resultType - Enumeration: "error" "image" "images" "table" "text"
    summary - summary - string = string.empty
    cause - The cause of the error
    filename - The image filename
    filenames - Array of filename strings
    data - object, stored a string
    schema - The table schema
    truncated - true if partial results are returned
    isJsonSchema - true if a JSON schema is returned instead of a string representation of the Hive type
    pos - internal field used by SDK
```

#### databricks.datastructures.commandexecution.CommandsStatusResults.CommandsStatusResults

```text
CommandsStatusResults Databricks Data Structure
  
  databricks.datastructures.commandexecution.CommandsStatusResults Properties:
    resultType - Enumeration: "error" "image" "images" "table" "text"
    summary - summary - string = string.empty
    cause - The cause of the error
    filename - The image filename
    filenames - Array of filename strings
    data - object, stored a string
    schema - The table schema
    truncated - true if partial results are returned
    isJsonSchema - true if a JSON schema is returned instead of a string representation of the Hive type
    pos - internal field used by SDK

    Documentation for databricks.datastructures.commandexecution.CommandsStatusResults
```

### databricks.datastructures.commandexecution.CommandsStatusStatus

Superclass: JSONEnum

```text
Status CommandsStatusStatus of the Status
 
  Enumeration Values:
    "Cancelled" "Cancelling" "Error" "Finished" "Queued" "Running"
```

```text
Enumeration values:
  Cancelled
  Cancelling
  Error
  Finished
  Queued
  Running

```

#### databricks.datastructures.commandexecution.CommandsStatusStatus.CommandsStatusStatus

```text
Status CommandsStatusStatus of the Status
 
  Enumeration Values:
    "Cancelled" "Cancelling" "Error" "Finished" "Queued" "Running"

    Documentation for databricks.datastructures.commandexecution.CommandsStatusStatus
```

### databricks.datastructures.commandexecution.ContextsStatus

Superclass: JSONEnum

```text
ContextsStatus Enumeration of the Status
 
  Enumeration Values:
    Running
    Pending
    Error
```

```text
Enumeration values:
  Running
  Pending
  Error

```

#### databricks.datastructures.commandexecution.ContextsStatus.ContextsStatus

```text
ContextsStatus Enumeration of the Status
 
  Enumeration Values:
    Running
    Pending
    Error

    Documentation for databricks.datastructures.commandexecution.ContextsStatus
```

### databricks.datastructures.commandexecution.ContextsStatusResponse

Superclass: JSONMapper

```text
StatusResponse Databricks Data Structure
 
  databricks.datastructures.commandexecution.ContextsStatusResponse Properties:
    id - ID 
    status - Enumeration: "Running" "Pending" "Error"
```

#### databricks.datastructures.commandexecution.ContextsStatusResponse.ContextsStatusResponse

```text
StatusResponse Databricks Data Structure
 
  databricks.datastructures.commandexecution.ContextsStatusResponse Properties:
    id - ID 
    status - Enumeration: "Running" "Pending" "Error"

    Documentation for databricks.datastructures.commandexecution.ContextsStatusResponse
```

### databricks.datastructures.commandexecution.CreateRequest

Superclass: JSONMapper

```text
CreateRequest Databricks Data Structure
 
  databricks.datastructures.commandexecution.CreateRequest Properties:
    clusterId - Running cluster id
    language -  Enumeration: "python" "scala" "sql"
 
  Example:
    commandExecution = databricks.CommandExecution();
    createRequest = databricks.datastructures.commandexecution.CreateRequest;
    createRequest.clusterId = "1117-171925-4ipnoi3i";
    createRequest.language = databricks.datastructures.commandexecution.Language.python;
    createResponse = commandExecution.create(createRequest);
    if isa(createResponse, 'databricks.datastructures.commandexecution.ErrorResponse')
        error("Context creation failed:\n  %s", createResponse.error);
    else
         contextId = createResponse.id;
    end
```

#### databricks.datastructures.commandexecution.CreateRequest.CreateRequest

```text
CreateRequest Databricks Data Structure
 
  databricks.datastructures.commandexecution.CreateRequest Properties:
    clusterId - Running cluster id
    language -  Enumeration: "python" "scala" "sql"
 
  Example:
    commandExecution = databricks.CommandExecution();
    createRequest = databricks.datastructures.commandexecution.CreateRequest;
    createRequest.clusterId = "1117-171925-4ipnoi3i";
    createRequest.language = databricks.datastructures.commandexecution.Language.python;
    createResponse = commandExecution.create(createRequest);
    if isa(createResponse, 'databricks.datastructures.commandexecution.ErrorResponse')
        error("Context creation failed:\n  %s", createResponse.error);
    else
         contextId = createResponse.id;
    end

    Documentation for databricks.datastructures.commandexecution.CreateRequest
```

#### databricks.datastructures.commandexecution.CreateRequest.fromInputs

```text
FROMINPUTS creates an instance of the class with specific
  properties set to specific values. For each property that is
  to be set, provide the property name and desired value as 
  Name-Value pairs.
```

### databricks.datastructures.commandexecution.CreateResponse

Superclass: JSONMapper

```text
CreateResponse Databricks Data Structure
 
  databricks.datastructures.commandexecution.CreateResponse Properties:
    id - ID of the new execution context
```

#### databricks.datastructures.commandexecution.CreateResponse.CreateResponse

```text
CreateResponse Databricks Data Structure
 
  databricks.datastructures.commandexecution.CreateResponse Properties:
    id - ID of the new execution context

    Documentation for databricks.datastructures.commandexecution.CreateResponse
```

### databricks.datastructures.commandexecution.DestroyRequest

Superclass: JSONMapper

```text
DestroyRequest Request to delete an execution context
 
  databricks.datastructures.commandexecution.DestroyRequest Properties:
    clusterId - Running cluster ID
    contextId - ID of context
 
  Example:
    commandExecution = databricks.CommandExecution;
    destroyRequest = databricks.datastructures.commandexecution.DestroyRequest;
    destroyRequest.clusterId = clusterId;
    destroyRequest.contextId = contextId;
    destroyResponse = commandExecution.destroy(destroyRequest);
```

#### databricks.datastructures.commandexecution.DestroyRequest.DestroyRequest

```text
DestroyRequest Request to delete an execution context
 
  databricks.datastructures.commandexecution.DestroyRequest Properties:
    clusterId - Running cluster ID
    contextId - ID of context
 
  Example:
    commandExecution = databricks.CommandExecution;
    destroyRequest = databricks.datastructures.commandexecution.DestroyRequest;
    destroyRequest.clusterId = clusterId;
    destroyRequest.contextId = contextId;
    destroyResponse = commandExecution.destroy(destroyRequest);

    Documentation for databricks.datastructures.commandexecution.DestroyRequest
```

#### databricks.datastructures.commandexecution.DestroyRequest.fromInputs

```text
FROMINPUTS creates an instance of the class with specific
  properties set to specific values. For each property that is
  to be set, provide the property name and desired value as 
  Name-Value pairs.
```

### databricks.datastructures.commandexecution.ErrorResponse

Superclass: JSONMapper

```text
ErrorResponse Error response body
 
  databricks.datastructures.commandexecution.ErrorResponse Properties:
    error - error message
```

#### databricks.datastructures.commandexecution.ErrorResponse.ErrorResponse

```text
ErrorResponse Error response body
 
  databricks.datastructures.commandexecution.ErrorResponse Properties:
    error - error message

    Documentation for databricks.datastructures.commandexecution.ErrorResponse
```

#### databricks.datastructures.commandexecution.ErrorResponse.throw

```text
databricks.datastructures.commandexecution.ErrorResponse/throw is a function.
    throw(obj)
```

### databricks.datastructures.commandexecution.ExecuteRequest

Superclass: JSONMapper

```text
ExecuteRequest Request to delete an execution context
 
  databricks.datastructures.commandexecution.ExecuteRequest Properties:
    clusterId - Running cluster id
    contextId - ID of context
    language - "python" "scala" "sql"
    command - command
```

#### databricks.datastructures.commandexecution.ExecuteRequest.ExecuteRequest

```text
ExecuteRequest Request to delete an execution context
 
  databricks.datastructures.commandexecution.ExecuteRequest Properties:
    clusterId - Running cluster id
    contextId - ID of context
    language - "python" "scala" "sql"
    command - command

    Documentation for databricks.datastructures.commandexecution.ExecuteRequest
```

#### databricks.datastructures.commandexecution.ExecuteRequest.fromInputs

```text
FROMINPUTS creates an instance of the class with specific
  properties set to specific values. For each property that is
  to be set, provide the property name and desired value as 
  Name-Value pairs.
```

### databricks.datastructures.commandexecution.ExecuteResponse

Superclass: JSONMapper

```text
ExecuteResponse Databricks Data Structure
 
  databricks.datastructures.commandexecution.ExecuteResponse Properties:
    id - ID for tracking the status of the command's execution.
```

#### databricks.datastructures.commandexecution.ExecuteResponse.ExecuteResponse

```text
ExecuteResponse Databricks Data Structure
 
  databricks.datastructures.commandexecution.ExecuteResponse Properties:
    id - ID for tracking the status of the command's execution.

    Documentation for databricks.datastructures.commandexecution.ExecuteResponse
```

### databricks.datastructures.commandexecution.Language

Superclass: JSONEnum

```text
Language Enumeration of the language field
 
  Enumeration Values:
    python
    scala
    sql
```

```text
Enumeration values:
  python
  scala
  sql

```

#### databricks.datastructures.commandexecution.Language.Language

```text
Language Enumeration of the language field
 
  Enumeration Values:
    python
    scala
    sql

    Documentation for databricks.datastructures.commandexecution.Language
```

### databricks.datastructures.commandexecution.ResultType

Superclass: JSONEnum

```text
Status ResultType of the Status
 
  Enumeration Values:
    "error" "image" "images" "table" "text"
```

```text
Enumeration values:
  error
  image
  images
  table
  text

```

#### databricks.datastructures.commandexecution.ResultType.ResultType

```text
Status ResultType of the Status
 
  Enumeration Values:
    "error" "image" "images" "table" "text"

    Documentation for databricks.datastructures.commandexecution.ResultType
```

### databricks.datastructures.currentuser

### databricks.datastructures.currentuser.Email

Superclass: JSONMapper

```text
EMAIL Class to represent email information for a user
```

#### databricks.datastructures.currentuser.Email.Email

```text
EMAIL Class to represent email information for a user

    Documentation for databricks.datastructures.currentuser.Email
```

### databricks.datastructures.currentuser.Entitlement

Superclass: JSONMapper

```text
ENTITLEMENT Class to represent entitlement information for a user
```

#### databricks.datastructures.currentuser.Entitlement.Entitlement

```text
ENTITLEMENT Class to represent entitlement information for a user

    Documentation for databricks.datastructures.currentuser.Entitlement
```

### databricks.datastructures.currentuser.ErrorResponse

Superclass: JSONMapper

```text
ErrorResponse Error response body
```

#### databricks.datastructures.currentuser.ErrorResponse.ErrorResponse

```text
ErrorResponse Error response body

    Documentation for databricks.datastructures.currentuser.ErrorResponse
```

#### databricks.datastructures.currentuser.ErrorResponse.throw

```text
databricks.datastructures.currentuser.ErrorResponse/throw is a function.
    throw(obj)
```

### databricks.datastructures.currentuser.Group

Superclass: JSONMapper

```text
GROUP Class to represent groups a user
```

#### databricks.datastructures.currentuser.Group.Group

```text
GROUP Class to represent groups a user

    Documentation for databricks.datastructures.currentuser.Group
```

### databricks.datastructures.currentuser.Name

Superclass: JSONMapper

```text
NAME Class to represent name information for a user
```

#### databricks.datastructures.currentuser.Name.Name

```text
NAME Class to represent name information for a user

    Documentation for databricks.datastructures.currentuser.Name
```

### databricks.datastructures.currentuser.Role

Superclass: JSONMapper

```text
ROLE Class to represent role information for a user
```

#### databricks.datastructures.currentuser.Role.Role

```text
ROLE Class to represent role information for a user

    Documentation for databricks.datastructures.currentuser.Role
```

### databricks.datastructures.currentuser.UserInfo

Superclass: JSONMapper

```text
USERINFO Class to represent info associated with the user
```

#### databricks.datastructures.currentuser.UserInfo.UserInfo

```text
USERINFO Class to represent info associated with the user

    Documentation for databricks.datastructures.currentuser.UserInfo
```

### databricks.datastructures.files

### databricks.datastructures.files.DirectoryEntry

Superclass: JSONMapper

```text
DirectoryEntry
```

#### databricks.datastructures.files.DirectoryEntry.DirectoryEntry

```text
DirectoryEntry

    Documentation for databricks.datastructures.files.DirectoryEntry
```

### databricks.datastructures.files.DirectoryMetadata

```text
DIRECTORYMETADATA Class to represent a directory's metadata
```

#### databricks.datastructures.files.DirectoryMetadata.DirectoryMetadata

```text
DIRECTORYMETADATA Class to represent a directory's metadata

    Documentation for databricks.datastructures.files.DirectoryMetadata
```

### databricks.datastructures.files.ErrorResponse

Superclass: JSONMapper

```text
ErrorResponse Error response body
 
  databricks.datastructures.files.ErrorResponse Properties:
    errorCode
    message
```

#### databricks.datastructures.files.ErrorResponse.ErrorResponse

```text
ErrorResponse Error response body
 
  databricks.datastructures.files.ErrorResponse Properties:
    errorCode
    message

    Documentation for databricks.datastructures.files.ErrorResponse
```

#### databricks.datastructures.files.ErrorResponse.throw

```text
databricks.datastructures.files.ErrorResponse/throw is a function.
    throw(obj)
```

### databricks.datastructures.files.FileMetadata

```text
FileMetadata Class to store the result of a file metadata query
  Represents a files's metadata.
```

#### databricks.datastructures.files.FileMetadata.FileMetadata

```text
FileMetadata Class to store the result of a file metadata query
  Represents a files's metadata.

    Documentation for databricks.datastructures.files.FileMetadata
```

### databricks.datastructures.files.ListResponse

Superclass: JSONMapper

```text
ListResponse Class to represent a list of contents from a file list query
```

#### databricks.datastructures.files.ListResponse.ListResponse

```text
ListResponse Class to represent a list of contents from a file list query

    Documentation for databricks.datastructures.files.ListResponse
```

### databricks.datastructures.files.ListResponsePaginated

Superclass: JSONMapper

```text
LISTRESPONSEPAGINATED Paginated response to file list query
```

#### databricks.datastructures.files.ListResponsePaginated.ListResponsePaginated

```text
LISTRESPONSEPAGINATED Paginated response to file list query

    Documentation for databricks.datastructures.files.ListResponsePaginated
```

### databricks.datastructures.files.UploadCompleteRequest

Superclass: JSONMapper

```text
UploadCompleteRequest
```

#### databricks.datastructures.files.UploadCompleteRequest.UploadCompleteRequest

```text
UploadCompleteRequest

    Documentation for databricks.datastructures.files.UploadCompleteRequest
```

### databricks.datastructures.files.UploadCompleteRequestEntry

Superclass: JSONMapper

```text
UploadCompleteRequestEntry
```

#### databricks.datastructures.files.UploadCompleteRequestEntry.UploadCompleteRequestEntry

```text
UploadCompleteRequestEntry

    Documentation for databricks.datastructures.files.UploadCompleteRequestEntry
```

### databricks.datastructures.genie

### databricks.datastructures.genie.Attachment

Superclass: JSONMapper

```text
ATTACHMENT Class to represent AI-generated response to the message
```

#### databricks.datastructures.genie.Attachment.Attachment

```text
ATTACHMENT Class to represent AI-generated response to the message

    Documentation for databricks.datastructures.genie.Attachment
```

### databricks.datastructures.genie.Chunk

Superclass: JSONMapper

```text
CHUNK
```

#### databricks.datastructures.genie.Chunk.Chunk

```text
CHUNK

    Documentation for databricks.datastructures.genie.Chunk
```

### databricks.datastructures.genie.Column

Superclass: JSONMapper

```text
COLUMN
```

#### databricks.datastructures.genie.Column.Column

```text
COLUMN

    Documentation for databricks.datastructures.genie.Column
```

### databricks.datastructures.genie.Conversation

Superclass: JSONMapper

```text
CONVERSATION Class to represent a Genie Conversation
```

#### databricks.datastructures.genie.Conversation.Conversation

```text
CONVERSATION Class to represent a Genie Conversation

    Documentation for databricks.datastructures.genie.Conversation
```

### databricks.datastructures.genie.CreateConversationMessageResponse

Superclass: JSONMapper

```text
CREATECONVERSATIONMESSAGERESPONSE Class to represent the response to a create conversation message call
```

#### databricks.datastructures.genie.CreateConversationMessageResponse.CreateConversationMessageResponse

```text
CREATECONVERSATIONMESSAGERESPONSE Class to represent the response to a create conversation message call

    Documentation for databricks.datastructures.genie.CreateConversationMessageResponse
```

### databricks.datastructures.genie.DataArray

```text
DATAARRAY
```

#### databricks.datastructures.genie.DataArray.DataArray

```text
DATAARRAY

    Documentation for databricks.datastructures.genie.DataArray
```

#### databricks.datastructures.genie.DataArray.toEntries

```text
databricks.datastructures.genie.DataArray/toEntries is a function.
    data = toEntries(obj)
```

### databricks.datastructures.genie.Error

Superclass: JSONMapper

```text
ERROR Class to represent Error message if Genie failed to respond to the message
```

#### databricks.datastructures.genie.Error.Error

```text
ERROR Class to represent Error message if Genie failed to respond to the message

    Documentation for databricks.datastructures.genie.Error
```

### databricks.datastructures.genie.ErrorCode

Superclass: JSONEnum

```text
ERRORCODE
```

```text
Enumeration values:
  UNKNOWN
  INTERNAL_ERROR
  TEMPORARILY_UNAVAILABLE
  IO_ERROR
  BAD_REQUEST
  SERVICE_UNDER_MAINTENANCE
  WORKSPACE_TEMPORARILY_UNAVAILABLE
  DEADLINE_EXCEEDED
  CANCELLED
  RESOURCE_EXHAUSTED
  ABORTED
  NOT_FOUND
  ALREADY_EXISTS
  UNAUTHENTICATED

```

#### databricks.datastructures.genie.ErrorCode.ErrorCode

```text
ERRORCODE

    Documentation for databricks.datastructures.genie.ErrorCode
```

### databricks.datastructures.genie.ErrorMsgExec

Superclass: JSONMapper

```text
ERRORMSGEXEC Class to represent Error message if Genie failed to respond to the message
```

#### databricks.datastructures.genie.ErrorMsgExec.ErrorMsgExec

```text
ERRORMSGEXEC Class to represent Error message if Genie failed to respond to the message

    Documentation for databricks.datastructures.genie.ErrorMsgExec
```

### databricks.datastructures.genie.ErrorType

Superclass: JSONEnum

```text
ERROR Error message if Genie failed to respond to the message
```

```text
Enumeration values:
  UNEXPECTED_REPLY_PROCESS_EXCEPTION
  GENERIC_CHAT_COMPLETION_EXCEPTION
  CONTEXT_EXCEEDED_EXCEPTION
  DEPLOYMENT_NOT_FOUND_EXCEPTION
  FUNCTIONS_NOT_AVAILABLE_EXCEPTION
  INVALID_COMPLETION_REQUEST_EXCEPTION
  CONTENT_FILTER_EXCEPTION
  FUNCTION_ARGUMENTS_INVALID_JSON_EXCEPTION
  RETRYABLE_PROCESSING_EXCEPTION
  INVALID_FUNCTION_CALL_EXCEPTION
  LOCAL_CONTEXT_EXCEEDED_EXCEPTION
  CHAT_COMPLETION_NETWORK_EXCEPTION
  INVALID_CHAT_COMPLETION_JSON_EXCEPTION
  GENERIC_CHAT_COMPLETION_SERVICE_EXCEPTION
  WAREHOUSE_ACCESS_MISSING_EXCEPTION
  WAREHOUSE_NOT_FOUND_EXCEPTION
  NO_TABLES_TO_QUERY_EXCEPTION
  SQL_EXECUTION_EXCEPTION
  REPLY_PROCESS_TIMEOUT_EXCEPTION
  COULD_NOT_GET_UC_SCHEMA_EXCEPTION
  INVALID_TABLE_IDENTIFIER_EXCEPTION
  TOO_MANY_TABLES_EXCEPTION
  FUNCTION_ARGUMENTS_INVALID_EXCEPTION
  GENERIC_SQL_EXEC_API_CALL_EXCEPTION
  CHAT_COMPLETION_CLIENT_EXCEPTION
  CHAT_COMPLETION_CLIENT_TIMEOUT_EXCEPTION
  UNKNOWN_AI_MODEL
  TABLES_MISSING_EXCEPTION
  MESSAGE_DELETED_WHILE_EXECUTING_EXCEPTION
  MESSAGE_UPDATED_WHILE_EXECUTING_EXCEPTION
  BLOCK_MULTIPLE_EXECUTIONS_EXCEPTION
  INVALID_CERTIFIED_ANSWER_IDENTIFIER_EXCEPTION
  TOO_MANY_CERTIFIED_ANSWERS_EXCEPTION
  RATE_LIMIT_EXCEEDED_GENERIC_EXCEPTION
  RATE_LIMIT_EXCEEDED_SPECIFIED_WAIT_EXCEPTION
  FUNCTION_CALL_MISSING_PARAMETER_EXCEPTION
  INVALID_CERTIFIED_ANSWER_FUNCTION_EXCEPTION
  ILLEGAL_PARAMETER_DEFINITION_EXCEPTION
  NO_QUERY_TO_VISUALIZE_EXCEPTION
  NO_DEPLOYMENTS_AVAILABLE_TO_WORKSPACE
  STOP_PROCESS_DUE_TO_AUTO_REGENERATE
  FUNCTION_ARGUMENTS_INVALID_TYPE_EXCEPTION
  MESSAGE_CANCELLED_WHILE_EXECUTING_EXCEPTION
  COULD_NOT_GET_MODEL_DEPLOYMENTS_EXCEPTION
  GENERATED_SQL_QUERY_TOO_LONG_EXCEPTION
  MISSING_SQL_QUERY_EXCEPTION
  DESCRIBE_QUERY_UNEXPECTED_FAILURE
  DESCRIBE_QUERY_TIMEOUT
  DESCRIBE_QUERY_INVALID_SQL_ERROR
  INVALID_SQL_UNKNOWN_TABLE_EXCEPTION
  INVALID_SQL_MULTIPLE_STATEMENTS_EXCEPTION
  INVALID_SQL_MULTIPLE_DATASET_REFERENCES_EXCEPTION
  INVALID_CHAT_COMPLETION_ARGUMENTS_JSON_EXCEPTION
  MESSAGE_ATTACHMENT_TOO_LONG_ERROR

```

#### databricks.datastructures.genie.ErrorType.ErrorType

```text
ERROR Error message if Genie failed to respond to the message

    Documentation for databricks.datastructures.genie.ErrorType
```

### databricks.datastructures.genie.ExecMsgAttachmentSQLQueryResponse

Superclass: JSONMapper

```text
EXECMSGATTACHMENTSQLQUERYRESPONSE Class to represent a ExecMsgAttachmentSQLQuery response
```

#### databricks.datastructures.genie.ExecMsgAttachmentSQLQueryResponse.ExecMsgAttachmentSQLQueryResponse

```text
EXECMSGATTACHMENTSQLQUERYRESPONSE Class to represent a ExecMsgAttachmentSQLQuery response

    Documentation for databricks.datastructures.genie.ExecMsgAttachmentSQLQueryResponse
```

### databricks.datastructures.genie.ExternalLink

Superclass: JSONMapper

```text
EXTERNALLINK
```

#### databricks.datastructures.genie.ExternalLink.ExternalLink

```text
EXTERNALLINK

    Documentation for databricks.datastructures.genie.ExternalLink
```

### databricks.datastructures.genie.Format

Superclass: JSONEnum

```text
FORMAT Data type enum
 
  Example:
    f = databricks.datastructures.genie.Format.CSV;
 
  See also: https://docs.databricks.com/api/workspace/genie/executemessageattachmentquery#statement_response-manifest
```

```text
Enumeration values:
  JSON_ARRAY
  ARROW_STREAM
  CSV

```

#### databricks.datastructures.genie.Format.Format

```text
FORMAT Data type enum
 
  Example:
    f = databricks.datastructures.genie.Format.CSV;
 
  See also: https://docs.databricks.com/api/workspace/genie/executemessageattachmentquery#statement_response-manifest

    Documentation for databricks.datastructures.genie.Format
```

### databricks.datastructures.genie.GetMsgAttachmentSQLQueryResponse

Superclass: JSONMapper

```text
GETMSGATTACHMENTSQLQUERYRESPONSE Class to represent a GetMsgAttachmentSQLQuery response
```

#### databricks.datastructures.genie.GetMsgAttachmentSQLQueryResponse.GetMsgAttachmentSQLQueryResponse

```text
GETMSGATTACHMENTSQLQUERYRESPONSE Class to represent a GetMsgAttachmentSQLQuery response

    Documentation for databricks.datastructures.genie.GetMsgAttachmentSQLQueryResponse
```

### databricks.datastructures.genie.ListConversationMessagesResponse

Superclass: JSONMapper

```text
LISTCONVERSATIONMESSAGESRESPONSE Class to represent a page Genie list conversation messages responses
```

#### databricks.datastructures.genie.ListConversationMessagesResponse.ListConversationMessagesResponse

```text
LISTCONVERSATIONMESSAGESRESPONSE Class to represent a page Genie list conversation messages responses

    Documentation for databricks.datastructures.genie.ListConversationMessagesResponse
```

### databricks.datastructures.genie.ListConversationsResponse

Superclass: JSONMapper

```text
LISTCONVERSATIONSRESPONSE Class to represent a page Genie list conversation responses
```

#### databricks.datastructures.genie.ListConversationsResponse.ListConversationsResponse

```text
LISTCONVERSATIONSRESPONSE Class to represent a page Genie list conversation responses

    Documentation for databricks.datastructures.genie.ListConversationsResponse
```

### databricks.datastructures.genie.ListSpacesResponse

Superclass: JSONMapper

```text
LISTSPACESRESPONSE Class to represent a page Genie list space responses
```

#### databricks.datastructures.genie.ListSpacesResponse.ListSpacesResponse

```text
LISTSPACESRESPONSE Class to represent a page Genie list space responses

    Documentation for databricks.datastructures.genie.ListSpacesResponse
```

### databricks.datastructures.genie.Manifest

Superclass: JSONMapper

```text
MANIFEST Provides schema and metadata for the result set
```

#### databricks.datastructures.genie.Manifest.Manifest

```text
MANIFEST Provides schema and metadata for the result set

    Documentation for databricks.datastructures.genie.Manifest
```

### databricks.datastructures.genie.Message

Superclass: JSONMapper

```text
MESSAGE Class to represent a message
  Copyright 2025 The MathWorks, Inc.
```

#### databricks.datastructures.genie.Message.Message

```text
MESSAGE Class to represent a message
  Copyright 2025 The MathWorks, Inc.

    Documentation for databricks.datastructures.genie.Message
```

### databricks.datastructures.genie.MsgExecResult

Superclass: JSONMapper

```text
MSGEXECRESULT Contains the result data of a single chunk when using INLINE disposition
  When using EXTERNAL_LINKS disposition, the array external_links is used instead
  to provide presigned URLs to the result data in cloud storage. Exactly one of
  these alternatives is used. (While the external_links array prepares the API
  to return multiple links in a single response. Currently only a single link
  is returned.)
```

#### databricks.datastructures.genie.MsgExecResult.MsgExecResult

```text
MSGEXECRESULT Contains the result data of a single chunk when using INLINE disposition
  When using EXTERNAL_LINKS disposition, the array external_links is used instead
  to provide presigned URLs to the result data in cloud storage. Exactly one of
  these alternatives is used. (While the external_links array prepares the API
  to return multiple links in a single response. Currently only a single link
  is returned.)

    Documentation for databricks.datastructures.genie.MsgExecResult
```

### databricks.datastructures.genie.Query

Superclass: JSONMapper

```text
Query Class to represent Query Attachment if Genie responds with a SQL query
```

#### databricks.datastructures.genie.Query.Query

```text
Query Class to represent Query Attachment if Genie responds with a SQL query

    Documentation for databricks.datastructures.genie.Query
```

### databricks.datastructures.genie.QueryResultMetadata

Superclass: JSONMapper

```text
QUERYRESULTMETADATA Class to represent Metadata associated with the query result
```

#### databricks.datastructures.genie.QueryResultMetadata.QueryResultMetadata

```text
QUERYRESULTMETADATA Class to represent Metadata associated with the query result

    Documentation for databricks.datastructures.genie.QueryResultMetadata
```

### databricks.datastructures.genie.Schema

Superclass: JSONMapper

```text
SCHEMA
```

#### databricks.datastructures.genie.Schema.Schema

```text
SCHEMA

    Documentation for databricks.datastructures.genie.Schema
```

### databricks.datastructures.genie.Space

Superclass: JSONMapper

```text
SPACE Class to represent a Genie space
```

#### databricks.datastructures.genie.Space.Space

```text
SPACE Class to represent a Genie space

    Documentation for databricks.datastructures.genie.Space
```

### databricks.datastructures.genie.StartConversationResponse

Superclass: JSONMapper

```text
STARTCONVERSATIONRESPONSE Class to represent a response to startConversation
```

#### databricks.datastructures.genie.StartConversationResponse.StartConversationResponse

```text
STARTCONVERSATIONRESPONSE Class to represent a response to startConversation

    Documentation for databricks.datastructures.genie.StartConversationResponse
```

### databricks.datastructures.genie.State

Superclass: JSONEnum

```text
STATE Statement execution state
```

```text
Enumeration values:
  PENDING
  RUNNING
  SUCCEEDED
  FAILED
  CANCELED
  CLOSED

```

#### databricks.datastructures.genie.State.State

```text
STATE Statement execution state

    Documentation for databricks.datastructures.genie.State
```

### databricks.datastructures.genie.StatementResponse

Superclass: JSONMapper

```text
STATEMENTRESPONSE Class to represent a SQL Statement Execution response
```

#### databricks.datastructures.genie.StatementResponse.StatementResponse

```text
STATEMENTRESPONSE Class to represent a SQL Statement Execution response

    Documentation for databricks.datastructures.genie.StatementResponse
```

### databricks.datastructures.genie.StatementResponseStatus

Superclass: JSONMapper

```text
STATEMENTRESPONSESTATUS
```

#### databricks.datastructures.genie.StatementResponseStatus.StatementResponseStatus

```text
STATEMENTRESPONSESTATUS

    Documentation for databricks.datastructures.genie.StatementResponseStatus
```

### databricks.datastructures.genie.Status

Superclass: JSONEnum

```text
STATUS Enumeration for Genie conversation messages
 
  Example:
    f = databricks.datastructures.genie.Status.FAILED;
 
  See also: https://docs.databricks.com/api/workspace/genie/createmessage#status
```

```text
Enumeration values:
  FETCHING_METADATA
  FILTERING_CONTEXT
  ASKING_AI
  PENDING_WAREHOUSE
  EXECUTING_QUERY
  FAILED
  COMPLETED
  SUBMITTED
  QUERY_RESULT_EXPIRED
  CANCELLED

```

#### databricks.datastructures.genie.Status.Status

```text
STATUS Enumeration for Genie conversation messages
 
  Example:
    f = databricks.datastructures.genie.Status.FAILED;
 
  See also: https://docs.databricks.com/api/workspace/genie/createmessage#status

    Documentation for databricks.datastructures.genie.Status
```

### databricks.datastructures.genie.Text

Superclass: JSONMapper

```text
TEXT Class to represent Text Attachment if Genie responds with text
```

#### databricks.datastructures.genie.Text.Text

```text
TEXT Class to represent Text Attachment if Genie responds with text

    Documentation for databricks.datastructures.genie.Text
```

### databricks.datastructures.genie.TypeName

Superclass: JSONEnum

```text
TYPENAME Data type enum
  The name of the base data type. This doesn't include details for complex types
  such as STRUCT, MAP or ARRAY.
 
  Example:
    f = databricks.datastructures.genie.TypeName.BOOLEAN;
 
  See also: https://docs.databricks.com/api/workspace/genie/executemessageattachmentquery#statement_response-manifest-schema-columns-type_name
```

```text
Enumeration values:
  BOOLEAN
  BYTE
  SHORT
  INT
  LONG
  FLOAT
  DOUBLE
  DATE
  TIMESTAMP
  STRING
  BINARY
  DECIMAL
  INTERVAL
  ARRAY
  STRUCT
  MAP
  CHAR
  NULL
  USER_DEFINED_TYPE

```

#### databricks.datastructures.genie.TypeName.TypeName

```text
TYPENAME Data type enum
  The name of the base data type. This doesn't include details for complex types
  such as STRUCT, MAP or ARRAY.
 
  Example:
    f = databricks.datastructures.genie.TypeName.BOOLEAN;
 
  See also: https://docs.databricks.com/api/workspace/genie/executemessageattachmentquery#statement_response-manifest-schema-columns-type_name

    Documentation for databricks.datastructures.genie.TypeName
```

### databricks.datastructures.instancepools

### databricks.datastructures.instancepools.AWSAttributes

Superclass: JSONMapper

```text
AWSATTRIBUTES Attributes related to instance pools running on Amazon Web Services
  If not specified at pool creation, a set of default values will be used.
```

#### databricks.datastructures.instancepools.AWSAttributes.AWSAttributes

```text
AWSATTRIBUTES Attributes related to instance pools running on Amazon Web Services
  If not specified at pool creation, a set of default values will be used.

    Documentation for databricks.datastructures.instancepools.AWSAttributes
```

### databricks.datastructures.instancepools.AvailabilityAWS

Superclass: JSONEnum

```text
AVAILABILITYAWS Enumeration Availability type used for the AWS spot nodes
```

```text
Enumeration values:
  SPOT
  ON_DEMAND

```

#### databricks.datastructures.instancepools.AvailabilityAWS.AvailabilityAWS

```text
AVAILABILITYAWS Enumeration Availability type used for the AWS spot nodes

    Documentation for databricks.datastructures.instancepools.AvailabilityAWS
```

### databricks.datastructures.instancepools.AvailabilityAzure

Superclass: JSONEnum

```text
AVAILABILITYAZURE Enumeration Availability type used for the Azure spot nodes
```

```text
Enumeration values:
  SPOT_AZURE
  ON_DEMAND_AZURE

```

#### databricks.datastructures.instancepools.AvailabilityAzure.AvailabilityAzure

```text
AVAILABILITYAZURE Enumeration Availability type used for the Azure spot nodes

    Documentation for databricks.datastructures.instancepools.AvailabilityAzure
```

### databricks.datastructures.instancepools.AzureAttributes

Superclass: JSONMapper

```text
AZUREATTRIBUTES Attributes related to instance pools running on Azure
  If not specified at pool creation, a set of default values will be used.
```

#### databricks.datastructures.instancepools.AzureAttributes.AzureAttributes

```text
AZUREATTRIBUTES Attributes related to instance pools running on Azure
  If not specified at pool creation, a set of default values will be used.

    Documentation for databricks.datastructures.instancepools.AzureAttributes
```

### databricks.datastructures.instancepools.AzureDiskVolumeType

Superclass: JSONEnum

```text
AZUREDISKVOLUMETYPE Enumeration of All Azure Disk types that Databricks supports
```

```text
Enumeration values:
  PREMIUM_LRS
  STANDARD_LRS

```

#### databricks.datastructures.instancepools.AzureDiskVolumeType.AzureDiskVolumeType

```text
AZUREDISKVOLUMETYPE Enumeration of All Azure Disk types that Databricks supports

    Documentation for databricks.datastructures.instancepools.AzureDiskVolumeType
```

### databricks.datastructures.instancepools.CreateRequest

Superclass: JSONMapper

```text
CREATEREQUEST Request object to create an instance pool
```

#### databricks.datastructures.instancepools.CreateRequest.CreateRequest

```text
CREATEREQUEST Request object to create an instance pool

    Documentation for databricks.datastructures.instancepools.CreateRequest
```

### databricks.datastructures.instancepools.DiskSpec

Superclass: JSONMapper

```text
DISKSPEC Defines the specification of the disks that will be attached to all spark containers
```

#### databricks.datastructures.instancepools.DiskSpec.DiskSpec

```text
DISKSPEC Defines the specification of the disks that will be attached to all spark containers

    Documentation for databricks.datastructures.instancepools.DiskSpec
```

### databricks.datastructures.instancepools.DiskType

Superclass: JSONEnum

```text
DISKTYPE Enumeration of All Disk types that Databricks supports
```

```text
Enumeration values:
  PREMIUM_LRS
  STANDARD_LRS
  GENERAL_PURPOSE_SSD
  THROUGHPUT_OPTIMIZED_HDD

```

#### databricks.datastructures.instancepools.DiskType.DiskType

```text
DISKTYPE Enumeration of All Disk types that Databricks supports

    Documentation for databricks.datastructures.instancepools.DiskType
```

### databricks.datastructures.instancepools.DockerBasicAuth

Superclass: JSONMapper

```text
DOCKERBASICAUTH Container registry basic authentication information
```

#### databricks.datastructures.instancepools.DockerBasicAuth.DockerBasicAuth

```text
DOCKERBASICAUTH Container registry basic authentication information

    Documentation for databricks.datastructures.instancepools.DockerBasicAuth
```

### databricks.datastructures.instancepools.DockerImage

Superclass: JSONMapper

```text
DOCKERIMAGE Docker image connection information
```

#### databricks.datastructures.instancepools.DockerImage.DockerImage

```text
DOCKERIMAGE Docker image connection information

    Documentation for databricks.datastructures.instancepools.DockerImage
```

### databricks.datastructures.instancepools.EbsVolumeType

Superclass: JSONEnum

```text
EBSVOLUMETYPE Enumeration of All AWS Disk types that Databricks supports
```

```text
Enumeration values:
  GENERAL_PURPOSE_SSD
  THROUGHPUT_OPTIMIZED_HDD

```

#### databricks.datastructures.instancepools.EbsVolumeType.EbsVolumeType

```text
EBSVOLUMETYPE Enumeration of All AWS Disk types that Databricks supports

    Documentation for databricks.datastructures.instancepools.EbsVolumeType
```

### databricks.datastructures.instancepools.InstancePool

Superclass: JSONMapper

```text
INSTANCEPOOL Class to represent an Instance Pool
```

#### databricks.datastructures.instancepools.InstancePool.InstancePool

```text
INSTANCEPOOL Class to represent an Instance Pool

    Documentation for databricks.datastructures.instancepools.InstancePool
```

### databricks.datastructures.instancepools.InstancePools

Superclass: JSONMapper

```text
INSTANCEPOOLS Class to represent an array of instance pools
```

#### databricks.datastructures.instancepools.InstancePools.InstancePools

```text
INSTANCEPOOLS Class to represent an array of instance pools

    Documentation for databricks.datastructures.instancepools.InstancePools
```

### databricks.datastructures.instancepools.PendingInstanceError

Superclass: JSONMapper

```text
PENDINGINSTANCEERROR
```

#### databricks.datastructures.instancepools.PendingInstanceError.PendingInstanceError

```text
PENDINGINSTANCEERROR

    Documentation for databricks.datastructures.instancepools.PendingInstanceError
```

### databricks.datastructures.instancepools.Permissions

Superclass: JSONMapper

```text
PERMISSIONS Defines the permissions of an instance pool
  Instance pools can inherit permissions from their root object.
```

#### databricks.datastructures.instancepools.Permissions.Permissions

```text
PERMISSIONS Defines the permissions of an instance pool
  Instance pools can inherit permissions from their root object.

    Documentation for databricks.datastructures.instancepools.Permissions
```

### databricks.datastructures.instancepools.State

Superclass: JSONEnum

```text
STATE Current state of the instance pool
```

```text
Enumeration values:
  ACTIVE
  STOPPED
  DELETED

```

#### databricks.datastructures.instancepools.State.State

```text
STATE Current state of the instance pool

    Documentation for databricks.datastructures.instancepools.State
```

### databricks.datastructures.instancepools.Stats

Superclass: JSONMapper

```text
STATS Usage statistics about the instance pool.
```

#### databricks.datastructures.instancepools.Stats.Stats

```text
STATS Usage statistics about the instance pool.

    Documentation for databricks.datastructures.instancepools.Stats
```

### databricks.datastructures.instancepools.Status

Superclass: JSONMapper

```text
STATUS Status of failed pending instances in the pool
```

#### databricks.datastructures.instancepools.Status.Status

```text
STATUS Status of failed pending instances in the pool

    Documentation for databricks.datastructures.instancepools.Status
```

### databricks.datastructures.libraries

### databricks.datastructures.libraries.Cran

Superclass: JSONMapper

```text
CRAN Represents a cluster Whl library
  Specification of a CRAN library to be installed as part of the library.
 
  See: https://docs.databricks.com/api/workspace/libraries/install
```

#### databricks.datastructures.libraries.Cran.Cran

```text
CRAN Represents a cluster Whl library
  Specification of a CRAN library to be installed as part of the library.
 
  See: https://docs.databricks.com/api/workspace/libraries/install

    Documentation for databricks.datastructures.libraries.Cran
```

### databricks.datastructures.libraries.Egg

Superclass: JSONMapper

```text
EGG Represents a cluster Egg library - Deprecated
  Installing Python egg files is deprecated and is not supported in Databricks Runtime 14.0 and above.
 
  See: https://docs.databricks.com/api/workspace/libraries/install
```

#### databricks.datastructures.libraries.Egg.Egg

```text
EGG Represents a cluster Egg library - Deprecated
  Installing Python egg files is deprecated and is not supported in Databricks Runtime 14.0 and above.
 
  See: https://docs.databricks.com/api/workspace/libraries/install

    Documentation for databricks.datastructures.libraries.Egg
```

### databricks.datastructures.libraries.Jar

Superclass: JSONMapper

```text
JAR Represents a cluster Jar library
  URI of the JAR library to install. Supported URIs include Workspace paths, Unity Catalog
  Volumes paths, and S3 URIs.
 
  Examples: 
    "/Workspace/path/to/library.jar"
    "/Volumes/path/to/library.jar"
    "s3://my-bucket/library.jar"
 
  If S3 is used, please make sure the cluster has read access on the library.
  The cluster may need to be launched with an IAM role to access the S3 URI.
 
  See: https://docs.databricks.com/api/workspace/libraries/install
```

#### databricks.datastructures.libraries.Jar.Jar

```text
JAR Represents a cluster Jar library
  URI of the JAR library to install. Supported URIs include Workspace paths, Unity Catalog
  Volumes paths, and S3 URIs.
 
  Examples: 
    "/Workspace/path/to/library.jar"
    "/Volumes/path/to/library.jar"
    "s3://my-bucket/library.jar"
 
  If S3 is used, please make sure the cluster has read access on the library.
  The cluster may need to be launched with an IAM role to access the S3 URI.
 
  See: https://docs.databricks.com/api/workspace/libraries/install

    Documentation for databricks.datastructures.libraries.Jar
```

### databricks.datastructures.libraries.Library

Superclass: JSONMapper

```text
LIBRARY Represents a cluster library
```

#### databricks.datastructures.libraries.Library.Library

```text
LIBRARY Represents a cluster library

    Documentation for databricks.datastructures.libraries.Library
```

#### databricks.datastructures.libraries.Library.fromJSON_HIDDEN

```text
databricks.datastructures.libraries.Library/fromJSON_HIDDEN is a function.
    obj = fromJSON_HIDDEN(obj, input)
```

#### databricks.datastructures.libraries.Library.getPayload_HIDDEN

```text
databricks.datastructures.libraries.Library/getPayload_HIDDEN is a function.
    json = getPayload_HIDDEN(obj, requiredProperties, optionalProperties)
    json = getPayload_HIDDEN(obj, requiredProperties, optionalProperties, raw)
```

#### databricks.datastructures.libraries.Library.onePropOnly

```text
Props should be the same for all objs so ok to have this
  outside the outer loop
```

#### databricks.datastructures.libraries.Library.resetProperties

```text
Props should be the same for all objs so ok to have this
  outside the outer loop
```

#### databricks.datastructures.libraries.Library.setLibrary

```text
SETLIBRARY Create a Library from a sub type e.g. Jar
 
  Example:
  j = databricks.datastructures.libraries.Jar;
  j.jar = "/Volumes/main/myvolume/myDirectory/myJarFile.jar";
  l = databricks.datastructures.libraries.Library;
  l.setLibrary(j);
```

#### databricks.datastructures.libraries.Library.structToProperty

```text
databricks.datastructures.libraries.Library.structToProperty is a function.
    propertyValue = structToProperty(s)
    [propertyValue, subType] = structToProperty(___)
```

#### databricks.datastructures.libraries.Library.toClassCase

```text
databricks.datastructures.libraries.Library.toClassCase is a function.
    result = toClassCase(str)
```

### databricks.datastructures.libraries.LibraryType

Superclass: JSONEnum

```text
LIBRARYTYPE Enumeration of Databricks library types
```

```text
Enumeration values:
  CRAN
  EGG
  JAR
  MAVEN
  WHL
  PYPI
  REQUIREMENTS

```

#### databricks.datastructures.libraries.LibraryType.LibraryType

```text
LIBRARYTYPE Enumeration of Databricks library types

    Documentation for databricks.datastructures.libraries.LibraryType
```

### databricks.datastructures.libraries.Maven

Superclass: JSONMapper

```text
MAVEN Represents a cluster Jar library
  Specification of a maven library to be installed.
 
  Example:
   "org.jsoup:jsoup:1.7.2"
 
  See: https://docs.databricks.com/api/workspace/libraries/install
```

#### databricks.datastructures.libraries.Maven.Maven

```text
MAVEN Represents a cluster Jar library
  Specification of a maven library to be installed.
 
  Example:
   "org.jsoup:jsoup:1.7.2"
 
  See: https://docs.databricks.com/api/workspace/libraries/install

    Documentation for databricks.datastructures.libraries.Maven
```

### databricks.datastructures.libraries.Pypi

Superclass: JSONMapper

```text
PYPI Represents a cluster Jar library
  Specification of a PyPi library to be installed.
  
  Example: 
    "simplejson"
 
  See: https://docs.databricks.com/api/workspace/libraries/install
```

#### databricks.datastructures.libraries.Pypi.Pypi

```text
PYPI Represents a cluster Jar library
  Specification of a PyPi library to be installed.
  
  Example: 
    "simplejson"
 
  See: https://docs.databricks.com/api/workspace/libraries/install

    Documentation for databricks.datastructures.libraries.Pypi
```

### databricks.datastructures.libraries.Requirements

Superclass: JSONMapper

```text
REQUIREMENTS URI of the requirements.txt file to install.
  Only Workspace paths and Unity Catalog Volumes paths are supported.
 
  Example: 
    "/Workspace/path/to/requirements.txt"
    "/Volumes/path/to/requirements.txt"
 
  See: https://docs.databricks.com/api/workspace/libraries/install
```

#### databricks.datastructures.libraries.Requirements.Requirements

```text
REQUIREMENTS URI of the requirements.txt file to install.
  Only Workspace paths and Unity Catalog Volumes paths are supported.
 
  Example: 
    "/Workspace/path/to/requirements.txt"
    "/Volumes/path/to/requirements.txt"
 
  See: https://docs.databricks.com/api/workspace/libraries/install

    Documentation for databricks.datastructures.libraries.Requirements
```

### databricks.datastructures.libraries.Whl

Superclass: JSONMapper

```text
WHL Represents a cluster Whl library
  URI of the wheel library to install.
  Supported URIs include Workspace paths, Unity Catalog Volumes paths, and S3 URIs.
 
  Examples: 
    "/Workspace/path/to/library.whl
    "/Volumes/path/to/library.whl"
    "s3://my-bucket/library.whl"
 
  If S3 is used, please make sure the cluster has read access on the library.
  The cluster may need to be launched with an IAM role to access the S3 URI.
 
  See: https://docs.databricks.com/api/workspace/libraries/install
```

#### databricks.datastructures.libraries.Whl.Whl

```text
WHL Represents a cluster Whl library
  URI of the wheel library to install.
  Supported URIs include Workspace paths, Unity Catalog Volumes paths, and S3 URIs.
 
  Examples: 
    "/Workspace/path/to/library.whl
    "/Volumes/path/to/library.whl"
    "s3://my-bucket/library.whl"
 
  If S3 is used, please make sure the cluster has read access on the library.
  The cluster may need to be launched with an IAM role to access the S3 URI.
 
  See: https://docs.databricks.com/api/workspace/libraries/install

    Documentation for databricks.datastructures.libraries.Whl
```

### databricks.datastructures.scim

### databricks.datastructures.scim.ErrorResponse

Superclass: JSONMapper

```text
ErrorResponse Error response body
 
  databricks.datastructures.SCIM.ErrorResponse Properties:
    errorCode
    message
```

#### databricks.datastructures.scim.ErrorResponse.ErrorResponse

```text
ErrorResponse Error response body
 
  databricks.datastructures.SCIM.ErrorResponse Properties:
    errorCode
    message

    Documentation for databricks.datastructures.scim.ErrorResponse
```

#### databricks.datastructures.scim.ErrorResponse.throw

```text
databricks.datastructures.scim.ErrorResponse/throw is a function.
    throw(obj)
```

### databricks.datastructures.scim.MeResponse

Superclass: JSONMapper

```text
EMAILS SCIM user groups
```

#### databricks.datastructures.scim.MeResponse.MeResponse

```text
EMAILS SCIM user groups

    Documentation for databricks.datastructures.scim.MeResponse
```

### databricks.datastructures.scim.emails

Superclass: JSONMapper

```text
EMAILS SCIM user emails
```

#### databricks.datastructures.scim.emails.emails

```text
EMAILS SCIM user emails

    Documentation for databricks.datastructures.scim.emails
```

### databricks.datastructures.scim.entitlements

Superclass: JSONMapper

```text
EMAILS SCIM user entitlements
```

#### databricks.datastructures.scim.entitlements.entitlements

```text
EMAILS SCIM user entitlements

    Documentation for databricks.datastructures.scim.entitlements
```

### databricks.datastructures.scim.groups

Superclass: JSONMapper

```text
EMAILS SCIM user groups
```

#### databricks.datastructures.scim.groups.groups

```text
EMAILS SCIM user groups

    Documentation for databricks.datastructures.scim.groups
```

### databricks.datastructures.scim.name

Superclass: JSONMapper

```text
EMAILS SCIM user name
```

#### databricks.datastructures.scim.name.name

```text
EMAILS SCIM user name

    Documentation for databricks.datastructures.scim.name
```

### databricks.datastructures.scim.roles

Superclass: JSONMapper

```text
EMAILS SCIM user roles
```

#### databricks.datastructures.scim.roles.roles

```text
EMAILS SCIM user roles

    Documentation for databricks.datastructures.scim.roles
```

### databricks.datastructures.secret

### databricks.datastructures.secret.secretList

Superclass: JSONMapper

```text
SECRETLIST Lists the secret keys that are stored at a scope
  This is a metadata-only operation; secret data cannot be retrieved using
  this API. Users need the READ permission to make this call.
```

#### databricks.datastructures.secret.secretList.secretList

```text
SECRETLIST Lists the secret keys that are stored at a scope
  This is a metadata-only operation; secret data cannot be retrieved using
  this API. Users need the READ permission to make this call.

    Documentation for databricks.datastructures.secret.secretList
```

### databricks.datastructures.secret.secretListItem

Superclass: JSONMapper

```text
SECRETLISTITEM List entry of the secret keys that are stored at a scope
  This is a metadata-only operation; secret data cannot be retrieved using
  this API. Users need the READ permission to make this call.
```

#### databricks.datastructures.secret.secretListItem.secretListItem

```text
SECRETLISTITEM List entry of the secret keys that are stored at a scope
  This is a metadata-only operation; secret data cannot be retrieved using
  this API. Users need the READ permission to make this call.

    Documentation for databricks.datastructures.secret.secretListItem
```

### databricks.datastructures.token

### databricks.datastructures.token.CreateRequest

Superclass: JSONMapper

```text
CREATEREQUEST Request to create a token
 
  See also: https://docs.databricks.com/api/azure/workspace/tokens/create
```

#### databricks.datastructures.token.CreateRequest.CreateRequest

```text
CREATEREQUEST Request to create a token
 
  See also: https://docs.databricks.com/api/azure/workspace/tokens/create

    Documentation for databricks.datastructures.token.CreateRequest
```

### databricks.datastructures.token.CreateResponse

Superclasses: JSONMapper, matlab.mixin.CustomDisplay

```text
CreateResponse Token create response
 
  See also: https://docs.databricks.com/api/azure/workspace/tokens/create
```

#### databricks.datastructures.token.CreateResponse.CreateResponse

```text
CreateResponse Token create response
 
  See also: https://docs.databricks.com/api/azure/workspace/tokens/create

    Documentation for databricks.datastructures.token.CreateResponse
```

#### databricks.datastructures.token.CreateResponse.getPropertyGroups

```text
GETPROPERTYGROUPS Redacts sensitive information from the object display
```

### databricks.datastructures.token.ListResponse

Superclass: JSONMapper

```text
ListResponse Token list response
 
  See also: https://docs.databricks.com/api/azure/workspace/tokens/list
```

#### databricks.datastructures.token.ListResponse.ListResponse

```text
ListResponse Token list response
 
  See also: https://docs.databricks.com/api/azure/workspace/tokens/list

    Documentation for databricks.datastructures.token.ListResponse
```

### databricks.datastructures.token.TokenInfo

Superclass: JSONMapper

```text
TOKENINFO Token information
 
  See also: https://docs.databricks.com/api/azure/workspace/tokens/update
```

#### databricks.datastructures.token.TokenInfo.TokenInfo

```text
TOKENINFO Token information
 
  See also: https://docs.databricks.com/api/azure/workspace/tokens/update

    Documentation for databricks.datastructures.token.TokenInfo
```

#### databricks.datastructures.token.TokenInfo.tokenInfo2struct

```text
databricks.datastructures.token.TokenInfo/tokenInfo2struct is a function.
    result = tokenInfo2struct(obj)
```

### databricks.datastructures.unitycatalog

### databricks.datastructures.unitycatalog.AllowlistRequest

Superclass: JSONMapper

```text
AllowlistRequest Databricks Data Structure
 
  databricks.datastructures.unitycatalog.AllowlistRequest Properties:
    artifact_matchers - The artifact matchers array
```

#### databricks.datastructures.unitycatalog.AllowlistRequest.AllowlistRequest

```text
AllowlistRequest Databricks Data Structure
 
  databricks.datastructures.unitycatalog.AllowlistRequest Properties:
    artifact_matchers - The artifact matchers array

    Documentation for databricks.datastructures.unitycatalog.AllowlistRequest
```

#### databricks.datastructures.unitycatalog.AllowlistRequest.fromInputs

```text
FROMINPUTS creates an instance of the class with specific
  properties set to specific values. For each property that is
  to be set, provide the property name and desired value as 
  Name-Value pairs.
```

### databricks.datastructures.unitycatalog.ArtifactMatchers

Superclass: JSONMapper

```text
ArtifactMatchers Databricks Data Structure
 
  databricks.datastructures.unitycatalog.ArtifactMatchers Properties:
    artifact - The artifact path or maven coordinate
    match_type - The pattern matching type of the artifact
```

#### databricks.datastructures.unitycatalog.ArtifactMatchers.ArtifactMatchers

```text
ArtifactMatchers Databricks Data Structure
 
  databricks.datastructures.unitycatalog.ArtifactMatchers Properties:
    artifact - The artifact path or maven coordinate
    match_type - The pattern matching type of the artifact

    Documentation for databricks.datastructures.unitycatalog.ArtifactMatchers
```

#### databricks.datastructures.unitycatalog.ArtifactMatchers.fromInputs

```text
FROMINPUTS creates an instance of the class with specific
  properties set to specific values. For each property that is
  to be set, provide the property name and desired value as 
  Name-Value pairs.
```

### databricks.datastructures.unitycatalog.ArtifactType

Superclass: JSONEnum

```text
ArtifactType Enumeration of the artifact type of the allowlist
 
  Enumeration Values:
    INIT_SCRIPT
    LIBRARY_JAR
    LIBRARY_MAVEN
```

```text
Enumeration values:
  INIT_SCRIPT
  LIBRARY_JAR
  LIBRARY_MAVEN

```

#### databricks.datastructures.unitycatalog.ArtifactType.ArtifactType

```text
ArtifactType Enumeration of the artifact type of the allowlist
 
  Enumeration Values:
    INIT_SCRIPT
    LIBRARY_JAR
    LIBRARY_MAVEN

    Documentation for databricks.datastructures.unitycatalog.ArtifactType
```

### databricks.datastructures.unitycatalog.AuthenticationType

Superclass: JSONEnum

```text
AuthenticationType Enumeration of the authentication_type field within TableInfo
 
  Enumeration Values:
    TOKEN
    DATABRICKS
```

```text
Enumeration values:
  TOKEN
  DATABRICKS

```

#### databricks.datastructures.unitycatalog.AuthenticationType.AuthenticationType

```text
AuthenticationType Enumeration of the authentication_type field within TableInfo
 
  Enumeration Values:
    TOKEN
    DATABRICKS

    Documentation for databricks.datastructures.unitycatalog.AuthenticationType
```

### databricks.datastructures.unitycatalog.AwsIamRole

Superclass: JSONMapper

```text
AwsIamRole Databricks Data Structure
 
  databricks.datastructures.unitycatalog.AwsIamRole Properties:
    role_arn - The Amazon Resource Name (ARN) of the AWS IAM role for S3
       data access
    unity_catalog_iam_arn - The Amazon Resource Name (ARN) of the AWS IAM user managed by
       Databricks. This is the identity that is going to assume the
       AWS IAM role.
    external_id - The external ID used in role assumption to prevent confused
       deputy problems.
```

#### databricks.datastructures.unitycatalog.AwsIamRole.AwsIamRole

```text
AwsIamRole Databricks Data Structure
 
  databricks.datastructures.unitycatalog.AwsIamRole Properties:
    role_arn - The Amazon Resource Name (ARN) of the AWS IAM role for S3
       data access
    unity_catalog_iam_arn - The Amazon Resource Name (ARN) of the AWS IAM user managed by
       Databricks. This is the identity that is going to assume the
       AWS IAM role.
    external_id - The external ID used in role assumption to prevent confused
       deputy problems.

    Documentation for databricks.datastructures.unitycatalog.AwsIamRole
```

#### databricks.datastructures.unitycatalog.AwsIamRole.fromInputs

```text
FROMINPUTS creates an instance of the class with specific
  properties set to specific values. For each property that is
  to be set, provide the property name and desired value as 
  Name-Value pairs.
```

### databricks.datastructures.unitycatalog.AwsTempCredentials

Superclass: JSONMapper

```text
AwsTempCredentials Databricks Data Structure
 
  Properties:
        access_key_id - The access key ID that identifies the temporary credentials.
         access_point - The Amazon Resource Name (ARN) of the S3 access point for temporary credentials related the external location.
    secret_access_key - The secret access key that can be used to sign AWS API requests.
        session_token - The token that users must pass to AWS API to use the temporary credentials.
```

#### databricks.datastructures.unitycatalog.AwsTempCredentials.AwsTempCredentials

```text
AwsTempCredentials Databricks Data Structure
 
  Properties:
        access_key_id - The access key ID that identifies the temporary credentials.
         access_point - The Amazon Resource Name (ARN) of the S3 access point for temporary credentials related the external location.
    secret_access_key - The secret access key that can be used to sign AWS API requests.
        session_token - The token that users must pass to AWS API to use the temporary credentials.

    Documentation for databricks.datastructures.unitycatalog.AwsTempCredentials
```

#### databricks.datastructures.unitycatalog.AwsTempCredentials.fromInputs

```text
FROMINPUTS creates an instance of the class with specific
  properties set to specific values. For each property that is
  to be set, provide the property name and desired value as 
  Name-Value pairs.
```

### databricks.datastructures.unitycatalog.AzureADD

Superclass: JSONMapper

```text
AzureADD Databricks Data Structure
 
  Properties:
    aad_token - Azure Active Directory token, essentially the Oauth token for
                Azure Service Principal or Managed Identity. Read more at
                https://learn.microsoft.com/en-us/azure/databricks/dev-tools/api/latest/aad/service-prin-aad-token
```

#### databricks.datastructures.unitycatalog.AzureADD.AzureADD

```text
AzureADD Databricks Data Structure
 
  Properties:
    aad_token - Azure Active Directory token, essentially the Oauth token for
                Azure Service Principal or Managed Identity. Read more at
                https://learn.microsoft.com/en-us/azure/databricks/dev-tools/api/latest/aad/service-prin-aad-token

    Documentation for databricks.datastructures.unitycatalog.AzureADD
```

#### databricks.datastructures.unitycatalog.AzureADD.fromInputs

```text
FROMINPUTS creates an instance of the class with specific
  properties set to specific values. For each property that is
  to be set, provide the property name and desired value as 
  Name-Value pairs.
```

### databricks.datastructures.unitycatalog.AzureServicePrincipal

Superclass: JSONMapper

```text
AzureServicePrincipal Databricks Data Structure
 
  databricks.datastructures.unitycatalog.AzureServicePrincipal Properties:
    directory_id - The directory ID corresponding to the Azure Active Directory
       (AAD) tenant of the application
    application_id - The application ID of the application registration within the
       referenced AAD tenant
    client_secret - The client secret generated for the above app ID in AAD. This
       field is redacted on output.
```

#### databricks.datastructures.unitycatalog.AzureServicePrincipal.AzureServicePrincipal

```text
AzureServicePrincipal Databricks Data Structure
 
  databricks.datastructures.unitycatalog.AzureServicePrincipal Properties:
    directory_id - The directory ID corresponding to the Azure Active Directory
       (AAD) tenant of the application
    application_id - The application ID of the application registration within the
       referenced AAD tenant
    client_secret - The client secret generated for the above app ID in AAD. This
       field is redacted on output.

    Documentation for databricks.datastructures.unitycatalog.AzureServicePrincipal
```

#### databricks.datastructures.unitycatalog.AzureServicePrincipal.fromInputs

```text
FROMINPUTS creates an instance of the class with specific
  properties set to specific values. For each property that is
  to be set, provide the property name and desired value as 
  Name-Value pairs.
```

### databricks.datastructures.unitycatalog.AzureUserDelegationSAS

Superclass: JSONMapper

```text
AzureUserDelegationSAS Databricks Data Structure
 
  Properties:
    sas_token - The signed URI (SAS Token) used to access blob services for
       a given path.
```

#### databricks.datastructures.unitycatalog.AzureUserDelegationSAS.AzureUserDelegationSAS

```text
AzureUserDelegationSAS Databricks Data Structure
 
  Properties:
    sas_token - The signed URI (SAS Token) used to access blob services for
       a given path.

    Documentation for databricks.datastructures.unitycatalog.AzureUserDelegationSAS
```

#### databricks.datastructures.unitycatalog.AzureUserDelegationSAS.fromInputs

```text
FROMINPUTS creates an instance of the class with specific
  properties set to specific values. For each property that is
  to be set, provide the property name and desired value as 
  Name-Value pairs.
```

### databricks.datastructures.unitycatalog.CatalogInfo

Superclass: JSONMapper

```text
CatalogInfo Databricks Data Structure
 
  databricks.datastructures.unitycatalog.CatalogInfo Properties:
    name - of Catalog relative to parent metastore
    comment - User-supplied free-form text
    ucproperties - Extensible Catalog properties
    owner - Username/groupname of Catalog owner
    provider_name - For Delta Sharing Catalogs: the name of the delta sharing
       provider
    share_name - For Delta Sharing Catalogs: the name of the share under the share
       provider
    metastore_id - Unique identifier of the parent Metastore
    created_at - Date of Catalog creation
    created_by - Username of Catalog creator
    updated_at - Date of last update to Catalog
    updated_by - Username of user who last updated Catalog
```

#### databricks.datastructures.unitycatalog.CatalogInfo.CatalogInfo

```text
CatalogInfo Databricks Data Structure
 
  databricks.datastructures.unitycatalog.CatalogInfo Properties:
    name - of Catalog relative to parent metastore
    comment - User-supplied free-form text
    ucproperties - Extensible Catalog properties
    owner - Username/groupname of Catalog owner
    provider_name - For Delta Sharing Catalogs: the name of the delta sharing
       provider
    share_name - For Delta Sharing Catalogs: the name of the share under the share
       provider
    metastore_id - Unique identifier of the parent Metastore
    created_at - Date of Catalog creation
    created_by - Username of Catalog creator
    updated_at - Date of last update to Catalog
    updated_by - Username of user who last updated Catalog

    Documentation for databricks.datastructures.unitycatalog.CatalogInfo
```

#### databricks.datastructures.unitycatalog.CatalogInfo.fromInputs

```text
FROMINPUTS creates an instance of the class with specific
  properties set to specific values. For each property that is
  to be set, provide the property name and desired value as 
  Name-Value pairs.
```

### databricks.datastructures.unitycatalog.CatalogInfoList

Superclass: JSONMapper

```text
CatalogInfo Databricks Data Structure
 
  databricks.datastructures.unitycatalog.CatalogInfoList Properties:
    catalogs - List of catalogs
```

#### databricks.datastructures.unitycatalog.CatalogInfoList.CatalogInfoList

```text
CatalogInfo Databricks Data Structure
 
  databricks.datastructures.unitycatalog.CatalogInfoList Properties:
    catalogs - List of catalogs

    Documentation for databricks.datastructures.unitycatalog.CatalogInfoList
```

### databricks.datastructures.unitycatalog.ColumnInfo

Superclass: JSONMapper

```text
ColumnInfo Databricks Data Structure
 
  databricks.datastructures.unitycatalog.ColumnInfo Properties:
    name - User-visible name of column
    type_name - Name of (outer) type; see Column Type  Name above
    type_text - Column type spec (with metadata) as SQL text
    type_json - Column type spec (with metadata) as JSON string
    type_precision - Digits of precision; applies to DECIMAL columns
    type_scale - Digits to right of decimal; applies to DECIMAL columns
    type_interval_type - Format of INTERVAL columns
    position - Ordinal position of column, starting at 0.
    comment - User-supplied free-form text
    nullable - Whether field is nullable (Default: true)
    partition_index - Partition ID
```

#### databricks.datastructures.unitycatalog.ColumnInfo.ColumnInfo

```text
ColumnInfo Databricks Data Structure
 
  databricks.datastructures.unitycatalog.ColumnInfo Properties:
    name - User-visible name of column
    type_name - Name of (outer) type; see Column Type  Name above
    type_text - Column type spec (with metadata) as SQL text
    type_json - Column type spec (with metadata) as JSON string
    type_precision - Digits of precision; applies to DECIMAL columns
    type_scale - Digits to right of decimal; applies to DECIMAL columns
    type_interval_type - Format of INTERVAL columns
    position - Ordinal position of column, starting at 0.
    comment - User-supplied free-form text
    nullable - Whether field is nullable (Default: true)
    partition_index - Partition ID

    Documentation for databricks.datastructures.unitycatalog.ColumnInfo
```

#### databricks.datastructures.unitycatalog.ColumnInfo.fromInputs

```text
FROMINPUTS creates an instance of the class with specific
  properties set to specific values. For each property that is
  to be set, provide the property name and desired value as 
  Name-Value pairs.
```

### databricks.datastructures.unitycatalog.ColumnTypeName

Superclass: JSONEnum

```text
ColumnTypeName Enumeration of the type_name field within ColumnInfo
 
  Enumeration Values:
    BOOLEAN
    BYTE
    SHORT
    INT
    LONG
    FLOAT
    DOUBLE
    DATE
    TIMESTAMP
    STRING
    BINARY
    DECIMAL
    INTERVAL
    ARRAY
    STRUCT
    MAP
    CHAR
    NULL
    TIMESTAMP_NTZ
```

```text
Enumeration values:
  BOOLEAN
  BYTE
  SHORT
  INT
  LONG
  FLOAT
  DOUBLE
  DATE
  TIMESTAMP
  TIMESTAMP_NTZ
  STRING
  BINARY
  DECIMAL
  INTERVAL
  ARRAY
  STRUCT
  MAP
  CHAR
  NULL

```

#### databricks.datastructures.unitycatalog.ColumnTypeName.ColumnTypeName

```text
ColumnTypeName Enumeration of the type_name field within ColumnInfo
 
  Enumeration Values:
    BOOLEAN
    BYTE
    SHORT
    INT
    LONG
    FLOAT
    DOUBLE
    DATE
    TIMESTAMP
    STRING
    BINARY
    DECIMAL
    INTERVAL
    ARRAY
    STRUCT
    MAP
    CHAR
    NULL
    TIMESTAMP_NTZ

    Documentation for databricks.datastructures.unitycatalog.ColumnTypeName
```

### databricks.datastructures.unitycatalog.Connection

Superclass: JSONMapper

```text
Connection Databricks Data Structure
```

#### databricks.datastructures.unitycatalog.Connection.Connection

```text
Connection Databricks Data Structure

    Documentation for databricks.datastructures.unitycatalog.Connection
```

### databricks.datastructures.unitycatalog.ConnectionInfo

Superclass: JSONMapper

```text
ConnectionInfo Databricks Data Structure
```

#### databricks.datastructures.unitycatalog.ConnectionInfo.ConnectionInfo

```text
ConnectionInfo Databricks Data Structure

    Documentation for databricks.datastructures.unitycatalog.ConnectionInfo
```

### databricks.datastructures.unitycatalog.ConnectionType

Superclass: JSONEnum

```text
ConnectionType The type of connection enumeration.
 
  Enumeration Values:
    UNKNOWN_CONNECTION_TYPE
    MYSQL
    POSTGRESQL
    SNOWFLAKE
    REDSHIFT
    SQLDW
    SQLSERVER
    DATABRICKS
    SALESFORCE
    BIGQUERY
    WORKDAY_RAAS
    HIVE_METASTORE
    GA4_RAW_DATA
    SERVICENOW
    SALESFORCE_DATA_CLOUD
    GLUE
    ORACLE 
    TERADATA
    HTTP
    POWER_BI
```

```text
Enumeration values:
  UNKNOWN_CONNECTION_TYPE
  MYSQL
  POSTGRESQL
  SNOWFLAKE
  REDSHIFT
  SQLDW
  SQLSERVER
  DATABRICKS
  SALESFORCE
  BIGQUERY
  WORKDAY_RAAS
  HIVE_METASTORE
  GA4_RAW_DATA
  SERVICENOW
  SALESFORCE_DATA_CLOUD
  GLUE
  ORACLE
  TERADATA
  HTTP
  POWER_BI

```

#### databricks.datastructures.unitycatalog.ConnectionType.ConnectionType

```text
ConnectionType The type of connection enumeration.
 
  Enumeration Values:
    UNKNOWN_CONNECTION_TYPE
    MYSQL
    POSTGRESQL
    SNOWFLAKE
    REDSHIFT
    SQLDW
    SQLSERVER
    DATABRICKS
    SALESFORCE
    BIGQUERY
    WORKDAY_RAAS
    HIVE_METASTORE
    GA4_RAW_DATA
    SERVICENOW
    SALESFORCE_DATA_CLOUD
    GLUE
    ORACLE 
    TERADATA
    HTTP
    POWER_BI

    Documentation for databricks.datastructures.unitycatalog.ConnectionType
```

### databricks.datastructures.unitycatalog.ConnectionUpdateRequest

Superclass: JSONMapper

```text
ConnectionUpdateRequest Databricks Data Structure
```

#### databricks.datastructures.unitycatalog.ConnectionUpdateRequest.ConnectionUpdateRequest

```text
ConnectionUpdateRequest Databricks Data Structure

    Documentation for databricks.datastructures.unitycatalog.ConnectionUpdateRequest
```

#### databricks.datastructures.unitycatalog.ConnectionUpdateRequest.fromInputs

```text
FROMINPUTS creates an instance of the class with specific
  properties set to specific values. For each property that is
  to be set, provide the property name and desired value as 
  Name-Value pairs.
```

### databricks.datastructures.unitycatalog.CredentialType

Superclass: JSONEnum

```text
CredentialType The type of credential enumeration.
 
  Enumeration Values:
    UNKNOWN_CREDENTIAL_TYPE
    USERNAME_PASSWORD
    OAUTH_U2M
    OAUTH_M2M
    OAUTH_REFRESH_TOKEN
    OAUTH_ACCESS_TOKEN
    OAUTH_RESOURCE_OWNER_PASSWORD
    SERVICE_CREDENTIAL
    BEARER_TOKEN
    OIDC_TOKEN
    PEM_PRIVATE_KEY
    OAUTH_U2M_MAPPING
    ANY_STATIC_CREDENTIAL
    OAUTH_MTLS
    SSWS_TOKEN
    EDGEGRID_AKAMAI
```

```text
Enumeration values:
  UNKNOWN_CREDENTIAL_TYPE
  USERNAME_PASSWORD
  OAUTH_U2M
  OAUTH_M2M
  OAUTH_REFRESH_TOKEN
  OAUTH_ACCESS_TOKEN
  OAUTH_RESOURCE_OWNER_PASSWORD
  SERVICE_CREDENTIAL
  BEARER_TOKEN
  OIDC_TOKEN
  PEM_PRIVATE_KEY
  OAUTH_U2M_MAPPING
  ANY_STATIC_CREDENTIAL
  OAUTH_MTLS
  SSWS_TOKEN
  EDGEGRID_AKAMAI

```

#### databricks.datastructures.unitycatalog.CredentialType.CredentialType

```text
CredentialType The type of credential enumeration.
 
  Enumeration Values:
    UNKNOWN_CREDENTIAL_TYPE
    USERNAME_PASSWORD
    OAUTH_U2M
    OAUTH_M2M
    OAUTH_REFRESH_TOKEN
    OAUTH_ACCESS_TOKEN
    OAUTH_RESOURCE_OWNER_PASSWORD
    SERVICE_CREDENTIAL
    BEARER_TOKEN
    OIDC_TOKEN
    PEM_PRIVATE_KEY
    OAUTH_U2M_MAPPING
    ANY_STATIC_CREDENTIAL
    OAUTH_MTLS
    SSWS_TOKEN
    EDGEGRID_AKAMAI

    Documentation for databricks.datastructures.unitycatalog.CredentialType
```

### databricks.datastructures.unitycatalog.DataSourceFormat

Superclass: JSONEnum

```text
DataSourceFormat Enumeration of the table_type field within TableInfo
 
  Enumeration Values:
    DELTA
    CSV
    JSON
    AVRO
    PARQUET
    ORC
    TEXT
    UNITY_CATALOG
    DELTASHARING
```

```text
Enumeration values:
  DELTA
  CSV
  JSON
  AVRO
  PARQUET
  ORC
  TEXT
  UNITY_CATALOG
  DELTASHARING

```

#### databricks.datastructures.unitycatalog.DataSourceFormat.DataSourceFormat

```text
DataSourceFormat Enumeration of the table_type field within TableInfo
 
  Enumeration Values:
    DELTA
    CSV
    JSON
    AVRO
    PARQUET
    ORC
    TEXT
    UNITY_CATALOG
    DELTASHARING

    Documentation for databricks.datastructures.unitycatalog.DataSourceFormat
```

### databricks.datastructures.unitycatalog.DeltaSharingScope

Superclass: JSONEnum

```text
DeltaSharingScope Enumeration of the delta_sharing_scope field within
  MetastoreInfo
 
  Enumeration Values:
    INTERNAL
    INTERNAL_AND_EXTERNAL
```

```text
Enumeration values:
  INTERNAL
  INTERNAL_AND_EXTERNAL

```

#### databricks.datastructures.unitycatalog.DeltaSharingScope.DeltaSharingScope

```text
DeltaSharingScope Enumeration of the delta_sharing_scope field within
  MetastoreInfo
 
  Enumeration Values:
    INTERNAL
    INTERNAL_AND_EXTERNAL

    Documentation for databricks.datastructures.unitycatalog.DeltaSharingScope
```

### databricks.datastructures.unitycatalog.ErrorResponse

Superclass: JSONMapper

```text
ErrorResponse Error response body
 
  databricks.datastructures.unitycatalog.ErrorResponse Properties:
    error_code - error code
    message - error message
    details - error details
```

#### databricks.datastructures.unitycatalog.ErrorResponse.ErrorResponse

```text
ErrorResponse Error response body
 
  databricks.datastructures.unitycatalog.ErrorResponse Properties:
    error_code - error code
    message - error message
    details - error details

    Documentation for databricks.datastructures.unitycatalog.ErrorResponse
```

#### databricks.datastructures.unitycatalog.ErrorResponse.throw

```text
databricks.datastructures.unitycatalog.ErrorResponse/throw is a function.
    throw(obj)
```

### databricks.datastructures.unitycatalog.ExternalLocationInfo

Superclass: JSONMapper

```text
ExternalLocationInfo Databricks Data Structure
 
  databricks.datastructures.unitycatalog.ExternalLocationInfo Properties:
    name - of External Location (must be unique within the parent
       Metastore)
    comment - User-supplied free-form text
    owner - Username/groupname of External Location owner
    url - Path URL in cloud storage, of the form: AWS:
       "s3://bucket-host/[bucket-dir]" Azure: "abfss://host/[path]" GCP:
       "gs://bucket-host/[path]"
    credential_name - Name of the Storage Credential to use with this External Location
    read_only - Whether the External Location is read-only (default: false)
    force - update even if changing url invalidates dependent external
       tables (default: false)
    skip_validation - Whether to skip Storage Credential validation during update of
       the External Location (default: false)
    metastore_id - Unique identifier of the parent Metastore
    created_at - Date of External Location creation
    created_by - Username of External Location creator
    updated_at - Date of last update to External Location
    updated_by - Username of user who last updated External Location
```

#### databricks.datastructures.unitycatalog.ExternalLocationInfo.ExternalLocationInfo

```text
ExternalLocationInfo Databricks Data Structure
 
  databricks.datastructures.unitycatalog.ExternalLocationInfo Properties:
    name - of External Location (must be unique within the parent
       Metastore)
    comment - User-supplied free-form text
    owner - Username/groupname of External Location owner
    url - Path URL in cloud storage, of the form: AWS:
       "s3://bucket-host/[bucket-dir]" Azure: "abfss://host/[path]" GCP:
       "gs://bucket-host/[path]"
    credential_name - Name of the Storage Credential to use with this External Location
    read_only - Whether the External Location is read-only (default: false)
    force - update even if changing url invalidates dependent external
       tables (default: false)
    skip_validation - Whether to skip Storage Credential validation during update of
       the External Location (default: false)
    metastore_id - Unique identifier of the parent Metastore
    created_at - Date of External Location creation
    created_by - Username of External Location creator
    updated_at - Date of last update to External Location
    updated_by - Username of user who last updated External Location

    Documentation for databricks.datastructures.unitycatalog.ExternalLocationInfo
```

#### databricks.datastructures.unitycatalog.ExternalLocationInfo.fromInputs

```text
FROMINPUTS creates an instance of the class with specific
  properties set to specific values. For each property that is
  to be set, provide the property name and desired value as 
  Name-Value pairs.
```

### databricks.datastructures.unitycatalog.ExternalLocationInfoList

Superclass: JSONMapper

```text
CatalogInfo Databricks Data Structure
 
  databricks.datastructures.unitycatalog.ExternalLocationInfoList Properties:
    external_locations - List of external locations
```

#### databricks.datastructures.unitycatalog.ExternalLocationInfoList.ExternalLocationInfoList

```text
CatalogInfo Databricks Data Structure
 
  databricks.datastructures.unitycatalog.ExternalLocationInfoList Properties:
    external_locations - List of external locations

    Documentation for databricks.datastructures.unitycatalog.ExternalLocationInfoList
```

### databricks.datastructures.unitycatalog.FileInfo

Superclass: JSONMapper

```text
FileInfo Databricks Data Structure
 
  databricks.datastructures.unitycatalog.FileInfo Properties:
    path - URI of the storage object
    name - of the object
    size - in bytes
    mtime - Modification time, based on unix epoch
    is_dir - Whether the object is a directory (or a file)
```

#### databricks.datastructures.unitycatalog.FileInfo.FileInfo

```text
FileInfo Databricks Data Structure
 
  databricks.datastructures.unitycatalog.FileInfo Properties:
    path - URI of the storage object
    name - of the object
    size - in bytes
    mtime - Modification time, based on unix epoch
    is_dir - Whether the object is a directory (or a file)

    Documentation for databricks.datastructures.unitycatalog.FileInfo
```

### databricks.datastructures.unitycatalog.GcpServiceAccountKey

Superclass: JSONMapper

```text
GcpServiceAccountKey Databricks Data Structure
 
  databricks.datastructures.unitycatalog.GcpServiceAccountKey Properties:
    email - The email of the service account
    private_key_id - The ID of the service account's private key
    private_key - The service account's RSA private key. This field is redacted
       on output.
```

#### databricks.datastructures.unitycatalog.GcpServiceAccountKey.GcpServiceAccountKey

```text
GcpServiceAccountKey Databricks Data Structure
 
  databricks.datastructures.unitycatalog.GcpServiceAccountKey Properties:
    email - The email of the service account
    private_key_id - The ID of the service account's private key
    private_key - The service account's RSA private key. This field is redacted
       on output.

    Documentation for databricks.datastructures.unitycatalog.GcpServiceAccountKey
```

#### databricks.datastructures.unitycatalog.GcpServiceAccountKey.fromInputs

```text
FROMINPUTS creates an instance of the class with specific
  properties set to specific values. For each property that is
  to be set, provide the property name and desired value as 
  Name-Value pairs.
```

### databricks.datastructures.unitycatalog.GenTempColCredsResp

Superclass: JSONMapper

```text
AzureUserDelegationSAS Databricks Data Structure
 
  Properties:
    aws_temp_credentials - AWS temporary credentials for API authentication
 
    aad_token - Azure Active Directory token, essentially the Oauth token for
                Azure Service Principal or Managed Identity. Read more at
                https://learn.microsoft.com/en-us/azure/databricks/dev-tools/api/latest/aad/service-prin-aad-token
 
    azure_user_delegation_sas - Azure temporary credentials for API authentication
 
    expiry_time - Server time when the credential will expire, in epoch milliseconds
 
    r2_temp_credentials - R2 temporary credentials for API authentication
 
    url - The URL of the storage path accessible by the temporary credential
```

#### databricks.datastructures.unitycatalog.GenTempColCredsResp.GenTempColCredsResp

```text
AzureUserDelegationSAS Databricks Data Structure
 
  Properties:
    aws_temp_credentials - AWS temporary credentials for API authentication
 
    aad_token - Azure Active Directory token, essentially the Oauth token for
                Azure Service Principal or Managed Identity. Read more at
                https://learn.microsoft.com/en-us/azure/databricks/dev-tools/api/latest/aad/service-prin-aad-token
 
    azure_user_delegation_sas - Azure temporary credentials for API authentication
 
    expiry_time - Server time when the credential will expire, in epoch milliseconds
 
    r2_temp_credentials - R2 temporary credentials for API authentication
 
    url - The URL of the storage path accessible by the temporary credential

    Documentation for databricks.datastructures.unitycatalog.GenTempColCredsResp
```

#### databricks.datastructures.unitycatalog.GenTempColCredsResp.fromInputs

```text
FROMINPUTS creates an instance of the class with specific
  properties set to specific values. For each property that is
  to be set, provide the property name and desired value as 
  Name-Value pairs.
```

### databricks.datastructures.unitycatalog.GetArtifactAllowlistsResp

Superclass: JSONMapper

```text
GetArtifactAllowlistsResp Databricks Data Structure
 
  databricks.datastructures.unitycatalog.GetArtifactAllowlistsResp Properties:
    artifact_matchers - A list of allowed artifact match patterns
    metastore_id - Unique identifier of parent metastore
    created_by - Username of the user who set the artifact allowlist
    created_at - Time at which this artifact allowlist was set
```

#### databricks.datastructures.unitycatalog.GetArtifactAllowlistsResp.GetArtifactAllowlistsResp

```text
GetArtifactAllowlistsResp Databricks Data Structure
 
  databricks.datastructures.unitycatalog.GetArtifactAllowlistsResp Properties:
    artifact_matchers - A list of allowed artifact match patterns
    metastore_id - Unique identifier of parent metastore
    created_by - Username of the user who set the artifact allowlist
    created_at - Time at which this artifact allowlist was set

    Documentation for databricks.datastructures.unitycatalog.GetArtifactAllowlistsResp
```

### databricks.datastructures.unitycatalog.GetMyGroupsResp

Superclass: JSONMapper

```text
GetMyGroupsResp Databricks Data Structure
 
  databricks.datastructures.unitycatalog.GetMyGroupsResp Properties:
    group_names - List of group names
```

#### databricks.datastructures.unitycatalog.GetMyGroupsResp.GetMyGroupsResp

```text
GetMyGroupsResp Databricks Data Structure
 
  databricks.datastructures.unitycatalog.GetMyGroupsResp Properties:
    group_names - List of group names

    Documentation for databricks.datastructures.unitycatalog.GetMyGroupsResp
```

### databricks.datastructures.unitycatalog.GetMyInfoResp

Superclass: JSONMapper

```text
GetMyInfoResp Databricks Data Structure
 
  databricks.datastructures.unitycatalog.GetMyInfoResp Properties:
    is_metastore_admin - Flag indicating whether or not the user is a Metastore administrator
```

#### databricks.datastructures.unitycatalog.GetMyInfoResp.GetMyInfoResp

```text
GetMyInfoResp Databricks Data Structure
 
  databricks.datastructures.unitycatalog.GetMyInfoResp Properties:
    is_metastore_admin - Flag indicating whether or not the user is a Metastore administrator

    Documentation for databricks.datastructures.unitycatalog.GetMyInfoResp
```

### databricks.datastructures.unitycatalog.IpAccessList

Superclass: JSONMapper

```text
IpAccessList Databricks Data Structure
 
  databricks.datastructures.unitycatalog.IpAccessList Properties:
    allowed_ip_addresses - Allowed IP Addresses in CIDR notation. Limit of 100.
```

#### databricks.datastructures.unitycatalog.IpAccessList.IpAccessList

```text
IpAccessList Databricks Data Structure
 
  databricks.datastructures.unitycatalog.IpAccessList Properties:
    allowed_ip_addresses - Allowed IP Addresses in CIDR notation. Limit of 100.

    Documentation for databricks.datastructures.unitycatalog.IpAccessList
```

#### databricks.datastructures.unitycatalog.IpAccessList.fromInputs

```text
FROMINPUTS creates an instance of the class with specific
  properties set to specific values. For each property that is
  to be set, provide the property name and desired value as 
  Name-Value pairs.
```

### databricks.datastructures.unitycatalog.KeyValuePair

Superclass: JSONMapper

```text
KeyValuePair Databricks Unity Catalog KeyValuePair Data Structure
 
  databricks.datastructures.unitycatalog.KeyValuePair Properties:
    key - Tag key name.
    value - Tag key value.
```

#### databricks.datastructures.unitycatalog.KeyValuePair.KeyValuePair

```text
KeyValuePair Databricks Unity Catalog KeyValuePair Data Structure
 
  databricks.datastructures.unitycatalog.KeyValuePair Properties:
    key - Tag key name.
    value - Tag key value.

    Documentation for databricks.datastructures.unitycatalog.KeyValuePair
```

#### databricks.datastructures.unitycatalog.KeyValuePair.fromInputs

```text
FROMINPUTS creates an instance of the class with specific
  properties set to specific values. For each property that is
  to be set, provide the property name and desired value as 
  Name-Value pairs.
```

### databricks.datastructures.unitycatalog.ListConnectionsResp

Superclass: JSONMapper

```text
ListConnectionsResp Databricks Data Structure
 
  databricks.datastructures.unitycatalog.ListConnectionsResp Properties:
    files - List of FileInfo objects, one per file/dir
```

#### databricks.datastructures.unitycatalog.ListConnectionsResp.ListConnectionsResp

```text
ListConnectionsResp Databricks Data Structure
 
  databricks.datastructures.unitycatalog.ListConnectionsResp Properties:
    files - List of FileInfo objects, one per file/dir

    Documentation for databricks.datastructures.unitycatalog.ListConnectionsResp
```

### databricks.datastructures.unitycatalog.ListFilesResp

Superclass: JSONMapper

```text
ListFilesResp Databricks Data Structure
 
  databricks.datastructures.unitycatalog.ListFilesResp Properties:
    files - List of FileInfo objects, one per file/dir
```

#### databricks.datastructures.unitycatalog.ListFilesResp.ListFilesResp

```text
ListFilesResp Databricks Data Structure
 
  databricks.datastructures.unitycatalog.ListFilesResp Properties:
    files - List of FileInfo objects, one per file/dir

    Documentation for databricks.datastructures.unitycatalog.ListFilesResp
```

### databricks.datastructures.unitycatalog.ListVolumesResp

Superclass: JSONMapper

```text
ListVolumesResp Databricks Data Structure
 
  databricks.datastructures.unitycatalog.ListVolumesResp Properties:
    volumes - List of FileInfo objects, one per file/dir
    next_page_token - Opaque token to retrieve the next page of results.
                      Absent if there are no more pages. page_token should
                      be set to this value for the next request to retrieve
                      the next page of results.
```

#### databricks.datastructures.unitycatalog.ListVolumesResp.ListVolumesResp

```text
ListVolumesResp Databricks Data Structure
 
  databricks.datastructures.unitycatalog.ListVolumesResp Properties:
    volumes - List of FileInfo objects, one per file/dir
    next_page_token - Opaque token to retrieve the next page of results.
                      Absent if there are no more pages. page_token should
                      be set to this value for the next request to retrieve
                      the next page of results.

    Documentation for databricks.datastructures.unitycatalog.ListVolumesResp
```

### databricks.datastructures.unitycatalog.MetastoreAssignment

Superclass: JSONMapper

```text
MetastoreAssignment Databricks Data Structure
 
  databricks.datastructures.unitycatalog.MetastoreAssignment Properties:
    metastore_id - Unique identifier for metastore
    default_catalog_name - Default catalog used for this assignment
```

#### databricks.datastructures.unitycatalog.MetastoreAssignment.MetastoreAssignment

```text
MetastoreAssignment Databricks Data Structure
 
  databricks.datastructures.unitycatalog.MetastoreAssignment Properties:
    metastore_id - Unique identifier for metastore
    default_catalog_name - Default catalog used for this assignment

    Documentation for databricks.datastructures.unitycatalog.MetastoreAssignment
```

#### databricks.datastructures.unitycatalog.MetastoreAssignment.fromInputs

```text
FROMINPUTS creates an instance of the class with specific
  properties set to specific values. For each property that is
  to be set, provide the property name and desired value as 
  Name-Value pairs.
```

### databricks.datastructures.unitycatalog.MetastoreInfo

Superclass: JSONMapper

```text
MetastoreInfo Databricks Data Structure
 
  databricks.datastructures.unitycatalog.MetastoreInfo Properties:
    name - of metastore
    storage_root - Metastore storage root path. On creation, the new metastore’s ID
       (UUID) is appended to the provided storage_root, so the output
       storage_root is not the same as the input storage_root.
    default_data_access_config_id - DEPRECATED Not implemented
    storage_root_credential_id - Unique identifier of the Storage Credential used by default to access
       the storage_root area of cloud storage.
    owner - Username/groupname of Metastore owner
    delta_sharing_enabled - DEPRECATED Not implemented
    delta_sharing_scope - Delta Sharing Scope (default: INTERNAL)
    delta_sharing_recipient_token_lifetime_in_seconds - The lifetime of delta sharing recipient token in seconds
       (no default; must be specified when delta_sharing_scope is set
       to INTERNAL_AND_EXTERNAL).
    delta_sharing_organization_name - The organization name of a Delta Sharing entity. The name will be
       used in Databricks-to-Databricks Delta Sharing as the official name.
    privilege_model_version - Privilege model version. This is of the form major.minor.
    metastore_id - Unique identifier for metastore
    cloud - vendor of Metastore home shard, e.g. “aws”, “azure”
    region - Cloud region of the Metastore home shard, e.g. “us-west-2”, “westus”
    global_metastore_id - Globally unique metastore ID across clouds and regions.
       E.g., “aws:us-east-1:8dd1e334-c7df-44c9-a359-f86f9aae8919”
    created_at - Date of metastore creation
    created_by - Username of metastore creator
    updated_at - Date of last update to metastore
    updated_by - Username of user who last modified metastore
```

#### databricks.datastructures.unitycatalog.MetastoreInfo.MetastoreInfo

```text
MetastoreInfo Databricks Data Structure
 
  databricks.datastructures.unitycatalog.MetastoreInfo Properties:
    name - of metastore
    storage_root - Metastore storage root path. On creation, the new metastore’s ID
       (UUID) is appended to the provided storage_root, so the output
       storage_root is not the same as the input storage_root.
    default_data_access_config_id - DEPRECATED Not implemented
    storage_root_credential_id - Unique identifier of the Storage Credential used by default to access
       the storage_root area of cloud storage.
    owner - Username/groupname of Metastore owner
    delta_sharing_enabled - DEPRECATED Not implemented
    delta_sharing_scope - Delta Sharing Scope (default: INTERNAL)
    delta_sharing_recipient_token_lifetime_in_seconds - The lifetime of delta sharing recipient token in seconds
       (no default; must be specified when delta_sharing_scope is set
       to INTERNAL_AND_EXTERNAL).
    delta_sharing_organization_name - The organization name of a Delta Sharing entity. The name will be
       used in Databricks-to-Databricks Delta Sharing as the official name.
    privilege_model_version - Privilege model version. This is of the form major.minor.
    metastore_id - Unique identifier for metastore
    cloud - vendor of Metastore home shard, e.g. “aws”, “azure”
    region - Cloud region of the Metastore home shard, e.g. “us-west-2”, “westus”
    global_metastore_id - Globally unique metastore ID across clouds and regions.
       E.g., “aws:us-east-1:8dd1e334-c7df-44c9-a359-f86f9aae8919”
    created_at - Date of metastore creation
    created_by - Username of metastore creator
    updated_at - Date of last update to metastore
    updated_by - Username of user who last modified metastore

    Documentation for databricks.datastructures.unitycatalog.MetastoreInfo
```

#### databricks.datastructures.unitycatalog.MetastoreInfo.fromInputs

```text
FROMINPUTS creates an instance of the class with specific
  properties set to specific values. For each property that is
  to be set, provide the property name and desired value as 
  Name-Value pairs.
```

### databricks.datastructures.unitycatalog.MetastoreInfoList

Superclass: JSONMapper

```text
CatalogInfo Databricks Data Structure
 
  databricks.datastructures.unitycatalog.MetastoreInfoList Properties:
    metastores - List of metastores
```

#### databricks.datastructures.unitycatalog.MetastoreInfoList.MetastoreInfoList

```text
CatalogInfo Databricks Data Structure
 
  databricks.datastructures.unitycatalog.MetastoreInfoList Properties:
    metastores - List of metastores

    Documentation for databricks.datastructures.unitycatalog.MetastoreInfoList
```

### databricks.datastructures.unitycatalog.ObjectsChange

Superclass: JSONMapper

```text
ObjectsChange Databricks Data Structure
 
  databricks.datastructures.unitycatalog.ObjectsChange Properties:
    action - ADD or REMOVE
    data_object - List of privileges assigned to add to the principal
```

#### databricks.datastructures.unitycatalog.ObjectsChange.ObjectsChange

```text
ObjectsChange Databricks Data Structure
 
  databricks.datastructures.unitycatalog.ObjectsChange Properties:
    action - ADD or REMOVE
    data_object - List of privileges assigned to add to the principal

    Documentation for databricks.datastructures.unitycatalog.ObjectsChange
```

#### databricks.datastructures.unitycatalog.ObjectsChange.fromInputs

```text
FROMINPUTS creates an instance of the class with specific
  properties set to specific values. For each property that is
  to be set, provide the property name and desired value as 
  Name-Value pairs.
```

### databricks.datastructures.unitycatalog.ObjectsDiff

Superclass: JSONMapper

```text
ObjectsDiff Databricks Data Structure
 
  databricks.datastructures.unitycatalog.ObjectsDiff Properties:
    name - Name of the principal
    updates - List of privileges assigned to add to the principal
```

#### databricks.datastructures.unitycatalog.ObjectsDiff.ObjectsDiff

```text
ObjectsDiff Databricks Data Structure
 
  databricks.datastructures.unitycatalog.ObjectsDiff Properties:
    name - Name of the principal
    updates - List of privileges assigned to add to the principal

    Documentation for databricks.datastructures.unitycatalog.ObjectsDiff
```

#### databricks.datastructures.unitycatalog.ObjectsDiff.fromInputs

```text
FROMINPUTS creates an instance of the class with specific
  properties set to specific values. For each property that is
  to be set, provide the property name and desired value as 
  Name-Value pairs.
```

### databricks.datastructures.unitycatalog.Operation

Superclass: JSONEnum

```text
Operation The operation performed against the volume data
  Either READ_VOLUME or WRITE_VOLUME. If WRITE_VOLUME is specified, the credentials
  returned will have write permissions, otherwise, it will be read only.
 
  Enumeration Values:
    READ_VOLUME
    WRITE_VOLUME
```

```text
Enumeration values:
  READ_VOLUME
  WRITE_VOLUME

```

#### databricks.datastructures.unitycatalog.Operation.Operation

```text
Operation The operation performed against the volume data
  Either READ_VOLUME or WRITE_VOLUME. If WRITE_VOLUME is specified, the credentials
  returned will have write permissions, otherwise, it will be read only.
 
  Enumeration Values:
    READ_VOLUME
    WRITE_VOLUME

    Documentation for databricks.datastructures.unitycatalog.Operation
```

### databricks.datastructures.unitycatalog.Partition

Superclass: JSONMapper

```text
Partition Databricks Data Structure
 
  databricks.datastructures.unitycatalog.Partition Properties:
    values - Partition Values have AND logical relationship
```

#### databricks.datastructures.unitycatalog.Partition.Partition

```text
Partition Databricks Data Structure
 
  databricks.datastructures.unitycatalog.Partition Properties:
    values - Partition Values have AND logical relationship

    Documentation for databricks.datastructures.unitycatalog.Partition
```

#### databricks.datastructures.unitycatalog.Partition.fromInputs

```text
FROMINPUTS creates an instance of the class with specific
  properties set to specific values. For each property that is
  to be set, provide the property name and desired value as 
  Name-Value pairs.
```

### databricks.datastructures.unitycatalog.PartitionSpecification

Superclass: JSONMapper

```text
PartitionSpecification Databricks Data Structure
 
  databricks.datastructures.unitycatalog.PartitionSpecification Properties:
    partitions - have OR logical relationship
```

#### databricks.datastructures.unitycatalog.PartitionSpecification.PartitionSpecification

```text
PartitionSpecification Databricks Data Structure
 
  databricks.datastructures.unitycatalog.PartitionSpecification Properties:
    partitions - have OR logical relationship

    Documentation for databricks.datastructures.unitycatalog.PartitionSpecification
```

#### databricks.datastructures.unitycatalog.PartitionSpecification.fromInputs

```text
FROMINPUTS creates an instance of the class with specific
  properties set to specific values. For each property that is
  to be set, provide the property name and desired value as 
  Name-Value pairs.
```

### databricks.datastructures.unitycatalog.PartitionValues

Superclass: JSONMapper

```text
PartitionValues Databricks Data Structure
 
  databricks.datastructures.unitycatalog.PartitionValues Properties:
    name - The name of the partition column. Must be distinct within a
       single partition
    value - The value of the partition column. When this value is not set, it
       means `null` value.
    op - The operator to apply for the value. Can be "EQUAL" or "LIKE".
```

#### databricks.datastructures.unitycatalog.PartitionValues.PartitionValues

```text
PartitionValues Databricks Data Structure
 
  databricks.datastructures.unitycatalog.PartitionValues Properties:
    name - The name of the partition column. Must be distinct within a
       single partition
    value - The value of the partition column. When this value is not set, it
       means `null` value.
    op - The operator to apply for the value. Can be "EQUAL" or "LIKE".

    Documentation for databricks.datastructures.unitycatalog.PartitionValues
```

#### databricks.datastructures.unitycatalog.PartitionValues.fromInputs

```text
FROMINPUTS creates an instance of the class with specific
  properties set to specific values. For each property that is
  to be set, provide the property name and desired value as 
  Name-Value pairs.
```

### databricks.datastructures.unitycatalog.PermissionsChange

Superclass: JSONMapper

```text
PermissionsChange Databricks Data Structure
 
  databricks.datastructures.unitycatalog.PermissionsChange Properties:
    principal - The username (email address) or group name
    add - List of privileges assigned to add to the principal
    remove - List of privileges assigned to remove from the principal
```

#### databricks.datastructures.unitycatalog.PermissionsChange.PermissionsChange

```text
PermissionsChange Databricks Data Structure
 
  databricks.datastructures.unitycatalog.PermissionsChange Properties:
    principal - The username (email address) or group name
    add - List of privileges assigned to add to the principal
    remove - List of privileges assigned to remove from the principal

    Documentation for databricks.datastructures.unitycatalog.PermissionsChange
```

#### databricks.datastructures.unitycatalog.PermissionsChange.fromInputs

```text
FROMINPUTS creates an instance of the class with specific
  properties set to specific values. For each property that is
  to be set, provide the property name and desired value as 
  Name-Value pairs.
```

### databricks.datastructures.unitycatalog.PermissionsDiff

Superclass: JSONMapper

```text
PermissionsDiff Databricks Data Structure
 
  databricks.datastructures.unitycatalog.PermissionsDiff Properties:
    changes - List of changes to make to a securable’s permissions
```

#### databricks.datastructures.unitycatalog.PermissionsDiff.PermissionsDiff

```text
PermissionsDiff Databricks Data Structure
 
  databricks.datastructures.unitycatalog.PermissionsDiff Properties:
    changes - List of changes to make to a securable’s permissions

    Documentation for databricks.datastructures.unitycatalog.PermissionsDiff
```

#### databricks.datastructures.unitycatalog.PermissionsDiff.fromInputs

```text
FROMINPUTS creates an instance of the class with specific
  properties set to specific values. For each property that is
  to be set, provide the property name and desired value as 
  Name-Value pairs.
```

### databricks.datastructures.unitycatalog.PermissionsList

Superclass: JSONMapper

```text
PermissionsList Databricks Data Structure
 
  databricks.datastructures.unitycatalog.PermissionsList Properties:
    privilege_assignments - List of privileges assigned to the principal
```

#### databricks.datastructures.unitycatalog.PermissionsList.PermissionsList

```text
PermissionsList Databricks Data Structure
 
  databricks.datastructures.unitycatalog.PermissionsList Properties:
    privilege_assignments - List of privileges assigned to the principal

    Documentation for databricks.datastructures.unitycatalog.PermissionsList
```

#### databricks.datastructures.unitycatalog.PermissionsList.fromInputs

```text
FROMINPUTS creates an instance of the class with specific
  properties set to specific values. For each property that is
  to be set, provide the property name and desired value as 
  Name-Value pairs.
```

### databricks.datastructures.unitycatalog.PrivilegeAssignment

Superclass: JSONMapper

```text
PrivilegeAssignment Databricks Data Structure
 
  databricks.datastructures.unitycatalog.PrivilegeAssignment Properties:
    principal - The username (email address) or group name
    privileges - List of privileges assigned to the principal
```

#### databricks.datastructures.unitycatalog.PrivilegeAssignment.PrivilegeAssignment

```text
PrivilegeAssignment Databricks Data Structure
 
  databricks.datastructures.unitycatalog.PrivilegeAssignment Properties:
    principal - The username (email address) or group name
    privileges - List of privileges assigned to the principal

    Documentation for databricks.datastructures.unitycatalog.PrivilegeAssignment
```

#### databricks.datastructures.unitycatalog.PrivilegeAssignment.fromInputs

```text
FROMINPUTS creates an instance of the class with specific
  properties set to specific values. For each property that is
  to be set, provide the property name and desired value as 
  Name-Value pairs.
```

### databricks.datastructures.unitycatalog.ProviderInfo

Superclass: JSONMapper

```text
ProviderInfo Databricks Data Structure
 
  databricks.datastructures.unitycatalog.ProviderInfo Properties:
    name - of Provider relative to parent metastore
    authentication_type - The delta sharing authentication type. Can be "TOKEN" or
       "DATABRICKS"
    comment - User-supplied free-form text
    owner - Username/groupname of Provider owner
    recipient_profile_str - Applicable for "TOKEN" authentication type only. This is the
       string with the profile file given to the recipient. See
       https://github.com/delta-io/delta-sharing/blob/main/PROTOCOL.md#profile-file-format
       In output mode, the bearer token is redacted.
    created_at - Date of Provider creation
    created_by - Username of Provider creator
    updated_at - Date of last update to Provider
    updated_by - Username of user who last updated Provider
    recipient_profile - The recipient profile. This field is only present when the
       authentication type is TOKEN. See
       https://github.com/delta-io/delta-sharing/blob/main/PROTOCOL.md#profile-file-format
    cloud - vendor of the provider's UC Metastore. This field is only
       present when the authentication type is DATABRICKS.
    region - Cloud region of the provider's UC Metastore. This field is only
       present when the authentication type is DATABRICKS.
    metastore_id - UUID of the provider's UC Metastore. This field is only present
       when the authentication type is DATABRICKS.
```

#### databricks.datastructures.unitycatalog.ProviderInfo.ProviderInfo

```text
ProviderInfo Databricks Data Structure
 
  databricks.datastructures.unitycatalog.ProviderInfo Properties:
    name - of Provider relative to parent metastore
    authentication_type - The delta sharing authentication type. Can be "TOKEN" or
       "DATABRICKS"
    comment - User-supplied free-form text
    owner - Username/groupname of Provider owner
    recipient_profile_str - Applicable for "TOKEN" authentication type only. This is the
       string with the profile file given to the recipient. See
       https://github.com/delta-io/delta-sharing/blob/main/PROTOCOL.md#profile-file-format
       In output mode, the bearer token is redacted.
    created_at - Date of Provider creation
    created_by - Username of Provider creator
    updated_at - Date of last update to Provider
    updated_by - Username of user who last updated Provider
    recipient_profile - The recipient profile. This field is only present when the
       authentication type is TOKEN. See
       https://github.com/delta-io/delta-sharing/blob/main/PROTOCOL.md#profile-file-format
    cloud - vendor of the provider's UC Metastore. This field is only
       present when the authentication type is DATABRICKS.
    region - Cloud region of the provider's UC Metastore. This field is only
       present when the authentication type is DATABRICKS.
    metastore_id - UUID of the provider's UC Metastore. This field is only present
       when the authentication type is DATABRICKS.

    Documentation for databricks.datastructures.unitycatalog.ProviderInfo
```

#### databricks.datastructures.unitycatalog.ProviderInfo.fromInputs

```text
FROMINPUTS creates an instance of the class with specific
  properties set to specific values. For each property that is
  to be set, provide the property name and desired value as 
  Name-Value pairs.
```

### databricks.datastructures.unitycatalog.ProviderInfoList

Superclass: JSONMapper

```text
ProviderInfoList Databricks Data Structure
 
  databricks.datastructures.unitycatalog.ProviderInfoList Properties:
    providers - List of providers
```

#### databricks.datastructures.unitycatalog.ProviderInfoList.ProviderInfoList

```text
ProviderInfoList Databricks Data Structure
 
  databricks.datastructures.unitycatalog.ProviderInfoList Properties:
    providers - List of providers

    Documentation for databricks.datastructures.unitycatalog.ProviderInfoList
```

### databricks.datastructures.unitycatalog.ProviderShare

Superclass: JSONMapper

```text
ProviderShare Databricks Data Structure
 
  databricks.datastructures.unitycatalog.ProviderShare Properties:
    name - The name of the Provider Share.
```

#### databricks.datastructures.unitycatalog.ProviderShare.ProviderShare

```text
ProviderShare Databricks Data Structure
 
  databricks.datastructures.unitycatalog.ProviderShare Properties:
    name - The name of the Provider Share.

    Documentation for databricks.datastructures.unitycatalog.ProviderShare
```

#### databricks.datastructures.unitycatalog.ProviderShare.fromInputs

```text
FROMINPUTS creates an instance of the class with specific
  properties set to specific values. For each property that is
  to be set, provide the property name and desired value as 
  Name-Value pairs.
```

### databricks.datastructures.unitycatalog.ProviderShareList

Superclass: JSONMapper

```text
ProviderShareList Databricks Data Structure
 
  databricks.datastructures.unitycatalog.ProviderShareList Properties:
    shares - List of shares
```

#### databricks.datastructures.unitycatalog.ProviderShareList.ProviderShareList

```text
ProviderShareList Databricks Data Structure
 
  databricks.datastructures.unitycatalog.ProviderShareList Properties:
    shares - List of shares

    Documentation for databricks.datastructures.unitycatalog.ProviderShareList
```

### databricks.datastructures.unitycatalog.ProvisioningInfo

Superclass: JSONMapper

```text
ProvisioningInfo Databricks Data Structure
```

#### databricks.datastructures.unitycatalog.ProvisioningInfo.ProvisioningInfo

```text
ProvisioningInfo Databricks Data Structure

    Documentation for databricks.datastructures.unitycatalog.ProvisioningInfo
```

### databricks.datastructures.unitycatalog.ProvisioningState

Superclass: JSONEnum

```text
ProvisioningState The provisioning state of the resource.
 
  Enumeration Values:
    PROVISIONING
    ACTIVE
    FAILED
    DELETING
    UPDATING
    DEGRADED
```

```text
Enumeration values:
  PROVISIONING
  ACTIVE
  FAILED
  DELETING
  UPDATING
  DEGRADED

```

#### databricks.datastructures.unitycatalog.ProvisioningState.ProvisioningState

```text
ProvisioningState The provisioning state of the resource.
 
  Enumeration Values:
    PROVISIONING
    ACTIVE
    FAILED
    DELETING
    UPDATING
    DEGRADED

    Documentation for databricks.datastructures.unitycatalog.ProvisioningState
```

### databricks.datastructures.unitycatalog.R2TempCredentials

Superclass: JSONMapper

```text
R2TempCredentials R2 temporary credentials for API authentication
   See also: https://developers.cloudflare.com/r2/api/s3/tokens/.
 
  Properties:
        access_key_id - The access key ID that identifies the temporary credentials.
    secret_access_key - The secret access key associated with the access key.
        session_token - The generated JWT that users must pass to use the temporary credentials.
```

#### databricks.datastructures.unitycatalog.R2TempCredentials.R2TempCredentials

```text
R2TempCredentials R2 temporary credentials for API authentication
   See also: https://developers.cloudflare.com/r2/api/s3/tokens/.
 
  Properties:
        access_key_id - The access key ID that identifies the temporary credentials.
    secret_access_key - The secret access key associated with the access key.
        session_token - The generated JWT that users must pass to use the temporary credentials.

    Documentation for databricks.datastructures.unitycatalog.R2TempCredentials
```

#### databricks.datastructures.unitycatalog.R2TempCredentials.fromInputs

```text
FROMINPUTS creates an instance of the class with specific
  properties set to specific values. For each property that is
  to be set, provide the property name and desired value as 
  Name-Value pairs.
```

### databricks.datastructures.unitycatalog.RecipientInfo

Superclass: JSONMapper

```text
RecipientInfo Databricks Data Structure
 
  databricks.datastructures.unitycatalog.RecipientInfo Properties:
    name - of Recipient relative to parent metastore
    authentication_type - The delta sharing authentication type. Can be "TOKEN" or
       "DATABRICKS"
    comment - User-supplied free-form text
    owner - Username/groupname of Recipient owner
    data_recipient_global_metastore_id - The global UC metastore id provided by the data recipient. This
       field is only present when the authentication type is DATABRICKS.
       The identifier is of format <cloud>:<region>:<metastore-uuid>.
    ip_access_list - IP Access List. This field is only applicable for the TOKEN
       authentication type.
    created_at - Date of Recipient creation
    created_by - Username of Recipient creator
    updated_at - Date of last update to Recipient
    updated_by - Username of user who last updated Recipient
    tokens - Recipient Tokens. This field is only present when the
       authentication type is TOKEN.
    cloud - vendor of the recipient's UC Metastore. This field is only
       present when the authentication type is DATABRICKS.
    region - Cloud region of the recipient's UC Metastore. This field is only
       present when the authentication type is DATABRICKS.
    metastore_id - UUID of the recipient's UC Metastore. This field is only present
       when the authentication type is DATABRICKS.
```

#### databricks.datastructures.unitycatalog.RecipientInfo.RecipientInfo

```text
RecipientInfo Databricks Data Structure
 
  databricks.datastructures.unitycatalog.RecipientInfo Properties:
    name - of Recipient relative to parent metastore
    authentication_type - The delta sharing authentication type. Can be "TOKEN" or
       "DATABRICKS"
    comment - User-supplied free-form text
    owner - Username/groupname of Recipient owner
    data_recipient_global_metastore_id - The global UC metastore id provided by the data recipient. This
       field is only present when the authentication type is DATABRICKS.
       The identifier is of format <cloud>:<region>:<metastore-uuid>.
    ip_access_list - IP Access List. This field is only applicable for the TOKEN
       authentication type.
    created_at - Date of Recipient creation
    created_by - Username of Recipient creator
    updated_at - Date of last update to Recipient
    updated_by - Username of user who last updated Recipient
    tokens - Recipient Tokens. This field is only present when the
       authentication type is TOKEN.
    cloud - vendor of the recipient's UC Metastore. This field is only
       present when the authentication type is DATABRICKS.
    region - Cloud region of the recipient's UC Metastore. This field is only
       present when the authentication type is DATABRICKS.
    metastore_id - UUID of the recipient's UC Metastore. This field is only present
       when the authentication type is DATABRICKS.

    Documentation for databricks.datastructures.unitycatalog.RecipientInfo
```

#### databricks.datastructures.unitycatalog.RecipientInfo.fromInputs

```text
FROMINPUTS creates an instance of the class with specific
  properties set to specific values. For each property that is
  to be set, provide the property name and desired value as 
  Name-Value pairs.
```

### databricks.datastructures.unitycatalog.RecipientInfoList

Superclass: JSONMapper

```text
RecipientInfoList Databricks Data Structure
 
  databricks.datastructures.unitycatalog.RecipientInfoList Properties:
    recipients - List of recipients
```

#### databricks.datastructures.unitycatalog.RecipientInfoList.RecipientInfoList

```text
RecipientInfoList Databricks Data Structure
 
  databricks.datastructures.unitycatalog.RecipientInfoList Properties:
    recipients - List of recipients

    Documentation for databricks.datastructures.unitycatalog.RecipientInfoList
```

### databricks.datastructures.unitycatalog.RecipientProfile

Superclass: JSONMapper

```text
RecipientProfile Databricks Data Structure
 
  databricks.datastructures.unitycatalog.RecipientProfile Properties:
    share_credentials_version - This field is only present when the authentication type is TOKEN.
       The file format version of the profile file. This version will be
       increased whenever non-forward-compatible changes are made to the
       profile format. When a client is running an unsupported profile
       file format version, it should show an error message instructing
       the user to upgrade to a newer version of their client.
    endpoint - The url of the sharing server.
```

#### databricks.datastructures.unitycatalog.RecipientProfile.RecipientProfile

```text
RecipientProfile Databricks Data Structure
 
  databricks.datastructures.unitycatalog.RecipientProfile Properties:
    share_credentials_version - This field is only present when the authentication type is TOKEN.
       The file format version of the profile file. This version will be
       increased whenever non-forward-compatible changes are made to the
       profile format. When a client is running an unsupported profile
       file format version, it should show an error message instructing
       the user to upgrade to a newer version of their client.
    endpoint - The url of the sharing server.

    Documentation for databricks.datastructures.unitycatalog.RecipientProfile
```

#### databricks.datastructures.unitycatalog.RecipientProfile.fromInputs

```text
FROMINPUTS creates an instance of the class with specific
  properties set to specific values. For each property that is
  to be set, provide the property name and desired value as 
  Name-Value pairs.
```

### databricks.datastructures.unitycatalog.RecipientTokenInfo

Superclass: JSONMapper

```text
RecipientTokenInfo Databricks Data Structure
 
  databricks.datastructures.unitycatalog.RecipientTokenInfo Properties:
    id - Unique id of the Recipient Token.
    activation_url - Full activation url to retrieve the access token. It will be
       empty if the token is already retrieved.
    expiration_time - Expiration timestamp of the token in epoch milliseconds.
    created_at - Date of Recipient Token creation
    created_by - Username of Recipient Token creator
    updated_at - Date of last update to Recipient Token
    updated_by - Username of user who last updated Recipient Token
```

#### databricks.datastructures.unitycatalog.RecipientTokenInfo.RecipientTokenInfo

```text
RecipientTokenInfo Databricks Data Structure
 
  databricks.datastructures.unitycatalog.RecipientTokenInfo Properties:
    id - Unique id of the Recipient Token.
    activation_url - Full activation url to retrieve the access token. It will be
       empty if the token is already retrieved.
    expiration_time - Expiration timestamp of the token in epoch milliseconds.
    created_at - Date of Recipient Token creation
    created_by - Username of Recipient Token creator
    updated_at - Date of last update to Recipient Token
    updated_by - Username of user who last updated Recipient Token

    Documentation for databricks.datastructures.unitycatalog.RecipientTokenInfo
```

#### databricks.datastructures.unitycatalog.RecipientTokenInfo.fromInputs

```text
FROMINPUTS creates an instance of the class with specific
  properties set to specific values. For each property that is
  to be set, provide the property name and desired value as 
  Name-Value pairs.
```

### databricks.datastructures.unitycatalog.RotateRecipientToken

Superclass: JSONMapper

```text
RotateRecipientToken Databricks Data Structure
 
  databricks.datastructures.unitycatalog.RotateRecipientToken Properties:
    existing_token_expire_in_seconds - This will set the expiration_time of existing token only to a
       smaller timestamp, it cannot extend the expiration_time. Use 0 to
       expire the existing token immediately, negative number will
       return an error.
```

#### databricks.datastructures.unitycatalog.RotateRecipientToken.RotateRecipientToken

```text
RotateRecipientToken Databricks Data Structure
 
  databricks.datastructures.unitycatalog.RotateRecipientToken Properties:
    existing_token_expire_in_seconds - This will set the expiration_time of existing token only to a
       smaller timestamp, it cannot extend the expiration_time. Use 0 to
       expire the existing token immediately, negative number will
       return an error.

    Documentation for databricks.datastructures.unitycatalog.RotateRecipientToken
```

#### databricks.datastructures.unitycatalog.RotateRecipientToken.fromInputs

```text
FROMINPUTS creates an instance of the class with specific
  properties set to specific values. For each property that is
  to be set, provide the property name and desired value as 
  Name-Value pairs.
```

### databricks.datastructures.unitycatalog.SchemaInfo

Superclass: JSONMapper

```text
SCHEMAINFO Databricks Data Structure
 
  databricks.datastructures.unitycatalog.SchemaInfo Properties:
    name - of Schema relative to parent catalog
    catalog_name - Name of parent Catalog
    comment - User-supplied free-form text
    owner - Username/groupname of Schema owner
    ucproperties - Extensible Schema properties
    metastore_id - Unique identifier of the parent Metastore
    full_name - Fully-qualified name of Schema as <catalog>.<schema>
    created_at - Date of Schema creation
    created_by - Username of Schema creator
    updated_at - Date of last update to Schema
    updated_by - Username of user who last updated Schema
```

#### databricks.datastructures.unitycatalog.SchemaInfo.SchemaInfo

```text
SCHEMAINFO Databricks Data Structure
 
  databricks.datastructures.unitycatalog.SchemaInfo Properties:
    name - of Schema relative to parent catalog
    catalog_name - Name of parent Catalog
    comment - User-supplied free-form text
    owner - Username/groupname of Schema owner
    ucproperties - Extensible Schema properties
    metastore_id - Unique identifier of the parent Metastore
    full_name - Fully-qualified name of Schema as <catalog>.<schema>
    created_at - Date of Schema creation
    created_by - Username of Schema creator
    updated_at - Date of last update to Schema
    updated_by - Username of user who last updated Schema

    Documentation for databricks.datastructures.unitycatalog.SchemaInfo
```

#### databricks.datastructures.unitycatalog.SchemaInfo.fromInputs

```text
FROMINPUTS creates an instance of the class with specific
  properties set to specific values. For each property that is
  to be set, provide the property name and desired value as 
  Name-Value pairs.
```

### databricks.datastructures.unitycatalog.SchemaInfoList

Superclass: JSONMapper

```text
SCHEMAINFOLIST Databricks Data Structure
 
  databricks.datastructures.unitycatalog.SchemaInfoList Properties:
    schemas - list of schemas
```

#### databricks.datastructures.unitycatalog.SchemaInfoList.SchemaInfoList

```text
SCHEMAINFOLIST Databricks Data Structure
 
  databricks.datastructures.unitycatalog.SchemaInfoList Properties:
    schemas - list of schemas

    Documentation for databricks.datastructures.unitycatalog.SchemaInfoList
```

### databricks.datastructures.unitycatalog.SecurableType

Superclass: JSONEnum

```text
SecurableType The type of Unity Catalog securable.
```

```text
Enumeration values:
  CATALOG
  SCHEMA
  TABLE
  STORAGE_CREDENTIAL
  EXTERNAL_LOCATION
  FUNCTION
  SHARE
  PROVIDER
  RECIPIENT
  CLEAN_ROOM
  METASTORE
  PIPELINE
  VOLUME
  CONNECTION
  CREDENTIAL
  EXTERNAL_METADATA
  STAGING_TABLE

```

#### databricks.datastructures.unitycatalog.SecurableType.SecurableType

```text
SecurableType The type of Unity Catalog securable.

    Documentation for databricks.datastructures.unitycatalog.SecurableType
```

### databricks.datastructures.unitycatalog.SetArtifactAllowlistResp

Superclass: JSONMapper

```text
SetArtifactAllowlistResp Databricks Data Structure
 
  databricks.datastructures.unitycatalog.SetArtifactAllowlistResp Properties:
    artifact_matchers - A list of allowed artifact match patterns
    metastore_id - Unique identifier of parent metastore
    created_by - Username of the user who set the artifact allowlist
    created_at - Time at which this artifact allowlist was set
```

#### databricks.datastructures.unitycatalog.SetArtifactAllowlistResp.SetArtifactAllowlistResp

```text
SetArtifactAllowlistResp Databricks Data Structure
 
  databricks.datastructures.unitycatalog.SetArtifactAllowlistResp Properties:
    artifact_matchers - A list of allowed artifact match patterns
    metastore_id - Unique identifier of parent metastore
    created_by - Username of the user who set the artifact allowlist
    created_at - Time at which this artifact allowlist was set

    Documentation for databricks.datastructures.unitycatalog.SetArtifactAllowlistResp
```

### databricks.datastructures.unitycatalog.ShareDataObject

Superclass: JSONMapper

```text
ShareDataObject Databricks Data Structure
 
  databricks.datastructures.unitycatalog.ShareDataObject Properties:
    name - A fully qualified name that uniquely identifies a data object.
       For example, a table's fully qualified name is in the format of
       `<catalog>.<schema>.<table>`.
    comment - User-supplied free-form text
    shared_as - A user-provided new name for the data object within the share. If
       this new name is not provided, the object's original name will be
       used as the `shared_as` name. The `shared_as` name must be unique
       within a Share. For tables, the new name must follow the format
       of `<schema>.<table>`.
    partition_specification - Defines the format of partition filtering specification for
       shared tables. It consists of a list of Partitions which in turn
       include a list of PartitionValues.
    cdf_enabled - Whether to enable Change Data Feed (cdf) or indicate if cdf is
       enabled on the shared object.
    start_version - The start version associated with the object for cdf. This allows
       data providers to control the lowest object version that is
       accessible by clients. If specified, clients can query snapshots
       or changes for versions >= start_version. If not specified,
       clients can only query starting from the version of the object at
       the time it was added to the share. NOTE: The start_version
       should be <= the "current" version of the object.
    added_at - Date of table add to share
    added_by - Username of user who added table to share
    data_object_type - Type of data object. Currently, the only supported type is
       "TABLE".
```

#### databricks.datastructures.unitycatalog.ShareDataObject.ShareDataObject

```text
ShareDataObject Databricks Data Structure
 
  databricks.datastructures.unitycatalog.ShareDataObject Properties:
    name - A fully qualified name that uniquely identifies a data object.
       For example, a table's fully qualified name is in the format of
       `<catalog>.<schema>.<table>`.
    comment - User-supplied free-form text
    shared_as - A user-provided new name for the data object within the share. If
       this new name is not provided, the object's original name will be
       used as the `shared_as` name. The `shared_as` name must be unique
       within a Share. For tables, the new name must follow the format
       of `<schema>.<table>`.
    partition_specification - Defines the format of partition filtering specification for
       shared tables. It consists of a list of Partitions which in turn
       include a list of PartitionValues.
    cdf_enabled - Whether to enable Change Data Feed (cdf) or indicate if cdf is
       enabled on the shared object.
    start_version - The start version associated with the object for cdf. This allows
       data providers to control the lowest object version that is
       accessible by clients. If specified, clients can query snapshots
       or changes for versions >= start_version. If not specified,
       clients can only query starting from the version of the object at
       the time it was added to the share. NOTE: The start_version
       should be <= the "current" version of the object.
    added_at - Date of table add to share
    added_by - Username of user who added table to share
    data_object_type - Type of data object. Currently, the only supported type is
       "TABLE".

    Documentation for databricks.datastructures.unitycatalog.ShareDataObject
```

#### databricks.datastructures.unitycatalog.ShareDataObject.fromInputs

```text
FROMINPUTS creates an instance of the class with specific
  properties set to specific values. For each property that is
  to be set, provide the property name and desired value as 
  Name-Value pairs.
```

### databricks.datastructures.unitycatalog.ShareInfo

Superclass: JSONMapper

```text
ShareInfo Databricks Data Structure
 
  databricks.datastructures.unitycatalog.ShareInfo Properties:
    name - of Share relative to parent metastore
    comment - User-supplied free-form text
    objects - A list of shared data objects within the Share
    owner - Username/groupname of Share owner
    created_at - Date of Share creation
    created_by - Username of Share creator
    updated_at - Date of last update to Share
    updated_by - Username of user who last updated Share
```

#### databricks.datastructures.unitycatalog.ShareInfo.ShareInfo

```text
ShareInfo Databricks Data Structure
 
  databricks.datastructures.unitycatalog.ShareInfo Properties:
    name - of Share relative to parent metastore
    comment - User-supplied free-form text
    objects - A list of shared data objects within the Share
    owner - Username/groupname of Share owner
    created_at - Date of Share creation
    created_by - Username of Share creator
    updated_at - Date of last update to Share
    updated_by - Username of user who last updated Share

    Documentation for databricks.datastructures.unitycatalog.ShareInfo
```

#### databricks.datastructures.unitycatalog.ShareInfo.fromInputs

```text
FROMINPUTS creates an instance of the class with specific
  properties set to specific values. For each property that is
  to be set, provide the property name and desired value as 
  Name-Value pairs.
```

### databricks.datastructures.unitycatalog.ShareInfoList

Superclass: JSONMapper

```text
ShareInfoList Databricks Data Structure
 
  databricks.datastructures.unitycatalog.ShareInfoList Properties:
    shares - List of shares
```

#### databricks.datastructures.unitycatalog.ShareInfoList.ShareInfoList

```text
ShareInfoList Databricks Data Structure
 
  databricks.datastructures.unitycatalog.ShareInfoList Properties:
    shares - List of shares

    Documentation for databricks.datastructures.unitycatalog.ShareInfoList
```

#### databricks.datastructures.unitycatalog.ShareInfoList.fromInputs

```text
FROMINPUTS creates an instance of the class with specific
  properties set to specific values. For each property that is
  to be set, provide the property name and desired value as 
  Name-Value pairs.
```

### databricks.datastructures.unitycatalog.ShareToPrivilegeAssignment

Superclass: JSONMapper

```text
ShareToPrivilegeAssignment Databricks Data Structure
 
  databricks.datastructures.unitycatalog.ShareToPrivilegeAssignment Properties:
    share_name - The share name.
    privilege_assignments - The privileges assigned to the principal.
```

#### databricks.datastructures.unitycatalog.ShareToPrivilegeAssignment.ShareToPrivilegeAssignment

```text
ShareToPrivilegeAssignment Databricks Data Structure
 
  databricks.datastructures.unitycatalog.ShareToPrivilegeAssignment Properties:
    share_name - The share name.
    privilege_assignments - The privileges assigned to the principal.

    Documentation for databricks.datastructures.unitycatalog.ShareToPrivilegeAssignment
```

#### databricks.datastructures.unitycatalog.ShareToPrivilegeAssignment.fromInputs

```text
FROMINPUTS creates an instance of the class with specific
  properties set to specific values. For each property that is
  to be set, provide the property name and desired value as 
  Name-Value pairs.
```

### databricks.datastructures.unitycatalog.ShareToPrivilegeAssignmentList

Superclass: JSONMapper

```text
ShareToPrivilegeAssignmentList Databricks Data Structure
 
  databricks.datastructures.unitycatalog.ShareToPrivilegeAssignmentList Properties:
    permissions_out - List of permissions
```

#### databricks.datastructures.unitycatalog.ShareToPrivilegeAssignmentList.ShareToPrivilegeAssignmentList

```text
ShareToPrivilegeAssignmentList Databricks Data Structure
 
  databricks.datastructures.unitycatalog.ShareToPrivilegeAssignmentList Properties:
    permissions_out - List of permissions

    Documentation for databricks.datastructures.unitycatalog.ShareToPrivilegeAssignmentList
```

### databricks.datastructures.unitycatalog.StorageCredentialInfo

Superclass: JSONMapper

```text
StorageCredentialInfo Databricks Data Structure
 
  databricks.datastructures.unitycatalog.StorageCredentialInfo Properties:
    name - of Storage Credential (must be unique within the parent
       Metastore)
    comment - User-supplied free-form text
    owner - Username/groupname of Storage Credential owner
    skip_validation - Specifies whether a Storage Credential with the specified
       configuration should be tested (for access to cloud storage)
       before the object is created/updated. Default: false
    aws_iam_role - Credential details for AWS
    azure_service_principal - Credential details for Azure
    gcp_service_account_key - Credential details for GCP
    id - Output-only
       Unique identifier of the Storage Credential
    metastore_id - Unique identifier of the parent Metastore
    created_at - Date of Storage Credential creation
    created_by - Username of Storage Credential creator
    updated_at - Date of last update to Storage Credential
    updated_by - Username of user who last updated Storage Credential
```

#### databricks.datastructures.unitycatalog.StorageCredentialInfo.StorageCredentialInfo

```text
StorageCredentialInfo Databricks Data Structure
 
  databricks.datastructures.unitycatalog.StorageCredentialInfo Properties:
    name - of Storage Credential (must be unique within the parent
       Metastore)
    comment - User-supplied free-form text
    owner - Username/groupname of Storage Credential owner
    skip_validation - Specifies whether a Storage Credential with the specified
       configuration should be tested (for access to cloud storage)
       before the object is created/updated. Default: false
    aws_iam_role - Credential details for AWS
    azure_service_principal - Credential details for Azure
    gcp_service_account_key - Credential details for GCP
    id - Output-only
       Unique identifier of the Storage Credential
    metastore_id - Unique identifier of the parent Metastore
    created_at - Date of Storage Credential creation
    created_by - Username of Storage Credential creator
    updated_at - Date of last update to Storage Credential
    updated_by - Username of user who last updated Storage Credential

    Documentation for databricks.datastructures.unitycatalog.StorageCredentialInfo
```

#### databricks.datastructures.unitycatalog.StorageCredentialInfo.fromInputs

```text
FROMINPUTS creates an instance of the class with specific
  properties set to specific values. For each property that is
  to be set, provide the property name and desired value as 
  Name-Value pairs.
```

### databricks.datastructures.unitycatalog.StorageCredentialInfoList

Superclass: JSONMapper

```text
CatalogInfo Databricks Data Structure
 
  databricks.datastructures.unitycatalog.StorageCredentialInfoList Properties:
    storage_credentials - List of storage credentials
```

#### databricks.datastructures.unitycatalog.StorageCredentialInfoList.StorageCredentialInfoList

```text
CatalogInfo Databricks Data Structure
 
  databricks.datastructures.unitycatalog.StorageCredentialInfoList Properties:
    storage_credentials - List of storage credentials

    Documentation for databricks.datastructures.unitycatalog.StorageCredentialInfoList
```

### databricks.datastructures.unitycatalog.TableInfo

Superclass: JSONMapper

```text
TableInfo Databricks Data Structure
 
  databricks.datastructures.unitycatalog.TableInfo Properties:
    name - of Table relative to parent Schema
    catalog_name - Name of parent Catalog
    schema_name - Name of parent Schema relative to parent Catalog
    table_type - Distinguishes a view vs. managed/external Table
    data_source_format - See Data Source Format spec
    columns - Sequence of Table columns
    storage_location - URL of storage location for Table data (* REQ for EXTERNAL
       Tables. For Managed Tables, if the path is provided it needs to
       be a Staging Table path that has been generated through the
       Staging Table API, otherwise should be empty)
    storage_credential_name - For EXTERNAL Tables only: the name of storage credential to use
       (may not be changed via UpdateTable endpoint).
    view_definition - SQL text defining the view (for table_type == "VIEW")
    sql_path - List of schemes whose objects can be referenced without
       qualification (ref)
    comment - User-supplied free-form text
    owner - Username/groupname of Table owner
    ucproperties - Extensible Table properties
    metastore_id - Unique identifier of the parent Metastore
    full_name - Fully-qualified name of Table as <catalog>.<schema>.<table>
    created_at - Date of Table creation
    created_by - Username of Table creator
    updated_at - Date of last update to Table
    updated_by - Username of user who last updated Table
```

#### databricks.datastructures.unitycatalog.TableInfo.TableInfo

```text
TableInfo Databricks Data Structure
 
  databricks.datastructures.unitycatalog.TableInfo Properties:
    name - of Table relative to parent Schema
    catalog_name - Name of parent Catalog
    schema_name - Name of parent Schema relative to parent Catalog
    table_type - Distinguishes a view vs. managed/external Table
    data_source_format - See Data Source Format spec
    columns - Sequence of Table columns
    storage_location - URL of storage location for Table data (* REQ for EXTERNAL
       Tables. For Managed Tables, if the path is provided it needs to
       be a Staging Table path that has been generated through the
       Staging Table API, otherwise should be empty)
    storage_credential_name - For EXTERNAL Tables only: the name of storage credential to use
       (may not be changed via UpdateTable endpoint).
    view_definition - SQL text defining the view (for table_type == "VIEW")
    sql_path - List of schemes whose objects can be referenced without
       qualification (ref)
    comment - User-supplied free-form text
    owner - Username/groupname of Table owner
    ucproperties - Extensible Table properties
    metastore_id - Unique identifier of the parent Metastore
    full_name - Fully-qualified name of Table as <catalog>.<schema>.<table>
    created_at - Date of Table creation
    created_by - Username of Table creator
    updated_at - Date of last update to Table
    updated_by - Username of user who last updated Table

    Documentation for databricks.datastructures.unitycatalog.TableInfo
```

### databricks.datastructures.unitycatalog.TableInfoList

Superclass: JSONMapper

```text
CatalogInfo Databricks Data Structure
 
  databricks.datastructures.unitycatalog.TableInfoList Properties:
    tables - List of tables
```

#### databricks.datastructures.unitycatalog.TableInfoList.TableInfoList

```text
CatalogInfo Databricks Data Structure
 
  databricks.datastructures.unitycatalog.TableInfoList Properties:
    tables - List of tables

    Documentation for databricks.datastructures.unitycatalog.TableInfoList
```

### databricks.datastructures.unitycatalog.TableSummariesResp

Superclass: JSONMapper

```text
TableSummariesResp Databricks Data Structure
 
  databricks.datastructures.unitycatalog.TableSummariesResp Properties:
    tables - List of Table Summaries
    next_page_token - Opaque token to use to retrieve the next page of results
```

#### databricks.datastructures.unitycatalog.TableSummariesResp.TableSummariesResp

```text
TableSummariesResp Databricks Data Structure
 
  databricks.datastructures.unitycatalog.TableSummariesResp Properties:
    tables - List of Table Summaries
    next_page_token - Opaque token to use to retrieve the next page of results

    Documentation for databricks.datastructures.unitycatalog.TableSummariesResp
```

### databricks.datastructures.unitycatalog.TableSummary

Superclass: JSONMapper

```text
TableSummary Databricks Data Structure
 
  databricks.datastructures.unitycatalog.TableSummary Properties:
    full_name - Fully-qualified name of Table , of the form <catalog>.<schema>.<table>
    table_type - Distinguishes a view vs. managed/external Table
```

#### databricks.datastructures.unitycatalog.TableSummary.TableSummary

```text
TableSummary Databricks Data Structure
 
  databricks.datastructures.unitycatalog.TableSummary Properties:
    full_name - Fully-qualified name of Table , of the form <catalog>.<schema>.<table>
    table_type - Distinguishes a view vs. managed/external Table

    Documentation for databricks.datastructures.unitycatalog.TableSummary
```

### databricks.datastructures.unitycatalog.TableType

Superclass: JSONEnum

```text
TableType Enumeration of the table_type field within TableInfo
 
  Enumeration Values:
    MANAGED
    EXTERNAL
    VIEW
    MATERIALIZED_VIEW
    STREAMING_TABLE
    MANAGED_SHALLOW_CLONE
    FOREIGN
    EXTERNAL_SHALLOW_CLONE
    METRIC_VIEW
```

```text
Enumeration values:
  MANAGED
  EXTERNAL
  VIEW
  MATERIALIZED_VIEW
  STREAMING_TABLE
  MANAGED_SHALLOW_CLONE
  FOREIGN
  EXTERNAL_SHALLOW_CLONE
  METRIC_VIEW

```

#### databricks.datastructures.unitycatalog.TableType.TableType

```text
TableType Enumeration of the table_type field within TableInfo
 
  Enumeration Values:
    MANAGED
    EXTERNAL
    VIEW
    MATERIALIZED_VIEW
    STREAMING_TABLE
    MANAGED_SHALLOW_CLONE
    FOREIGN
    EXTERNAL_SHALLOW_CLONE
    METRIC_VIEW

    Documentation for databricks.datastructures.unitycatalog.TableType
```

### databricks.datastructures.unitycatalog.UpdateAction

Superclass: JSONEnum

```text
UpdateAction Enumeration of the action field within ShareChangeAction
 
  Enumeration Values:
    ADD
    REMOVE
```

```text
Enumeration values:
  ADD
  REMOVE

```

#### databricks.datastructures.unitycatalog.UpdateAction.UpdateAction

```text
UpdateAction Enumeration of the action field within ShareChangeAction
 
  Enumeration Values:
    ADD
    REMOVE

    Documentation for databricks.datastructures.unitycatalog.UpdateAction
```

### databricks.datastructures.unitycatalog.VolumeInfo

Superclass: JSONMapper

```text
VolumeInfo Databricks Data Structure
 
  databricks.datastructures.unitycatalog.VolumeInfo Properties:
    catalog_name - The identifier of the catalog
    schema_name - The identifier of the schema
    name - Volume name
    full_name - Full name of volume e.g. main.default.my_volume
    volume_type - databricks.datastructures.unitycatalog.VolumeType
    owner - Owner of the volume
    volume_id - ID of the volume
    metastore_id - ID of the metastore
    created_at - Date of volume creation
    created_by - Username of volume creator
    updated_at - Date of last update to volume
    updated_by - Username of user who last updated volume
    storage_location - Underlying volume storage location
    comment - Comment field, user-supplied free-form text
```

#### databricks.datastructures.unitycatalog.VolumeInfo.VolumeInfo

```text
VolumeInfo Databricks Data Structure
 
  databricks.datastructures.unitycatalog.VolumeInfo Properties:
    catalog_name - The identifier of the catalog
    schema_name - The identifier of the schema
    name - Volume name
    full_name - Full name of volume e.g. main.default.my_volume
    volume_type - databricks.datastructures.unitycatalog.VolumeType
    owner - Owner of the volume
    volume_id - ID of the volume
    metastore_id - ID of the metastore
    created_at - Date of volume creation
    created_by - Username of volume creator
    updated_at - Date of last update to volume
    updated_by - Username of user who last updated volume
    storage_location - Underlying volume storage location
    comment - Comment field, user-supplied free-form text

    Documentation for databricks.datastructures.unitycatalog.VolumeInfo
```

#### databricks.datastructures.unitycatalog.VolumeInfo.fromInputs

```text
FROMINPUTS creates an instance of the class with specific
  properties set to specific values. For each property that is
  to be set, provide the property name and desired value as 
  Name-Value pairs.
```

### databricks.datastructures.unitycatalog.VolumeType

Superclass: JSONEnum

```text
VolumeType Enumeration of the volume_type field within VolumeInfo
 
  Enumeration Values:
    MANAGED
    EXTERNAL
```

```text
Enumeration values:
  MANAGED
  EXTERNAL

```

#### databricks.datastructures.unitycatalog.VolumeType.VolumeType

```text
VolumeType Enumeration of the volume_type field within VolumeInfo
 
  Enumeration Values:
    MANAGED
    EXTERNAL

    Documentation for databricks.datastructures.unitycatalog.VolumeType
```

### databricks.datastructures.Channel

Superclass: matlab.databricks.StructOrCellDeserializable

```text
CHANNEL Databricks Channel Data Structure
```

#### databricks.datastructures.Channel.Channel

```text
CHANNEL Databricks Channel Data Structure

    Documentation for databricks.datastructures.Channel
```

### databricks.datastructures.ChannelName

```text
CHANNELNAME Databricks ChannelName Data Structure
```

```text
Enumeration values:
  CHANNEL_NAME_PREVIEW
  CHANNEL_NAME_CURRENT
  CHANNEL_NAME_UNSPECIFIED
  CHANNEL_NAME_PREVIOUS
  CHANNEL_NAME_CUSTOM

```

#### databricks.datastructures.ChannelName.ChannelName

```text
CHANNELNAME Databricks ChannelName Data Structure

    Documentation for databricks.datastructures.ChannelName
```

### databricks.datastructures.DataSecurityMode

```text
DataSecurityMode Enumeration for cluster Data Security Modes in Databricks
 
  Data security mode decides what data governance model to use when accessing
  data from a cluster.
 
  NONE: No security isolation for multiple users sharing the cluster.
  Data governance features are not available in this mode. This mode
  is now referred to as "No isolation shared".
 
  SINGLE_USER: A secure cluster that can only be exclusively used by a single
  user specified in single_user_name. Most programming languages, cluster
  features and data governance features are available in this mode. This mode
  is now referred to as "Dedicated".
 
  USER_ISOLATION: A secure cluster that can be shared by multiple users.
  Cluster users are fully isolated so that they cannot see each other's data
  and credentials. Most data governance features are supported in this mode.
  But programming languages and cluster features might be limited. This mode
  is now referred to as "Standard".
 
  The following LEGACY_* modes are deprecated starting with Databricks Runtime
  15.0 and will be removed for future Databricks Runtime versions:
 
  LEGACY_TABLE_ACL: This mode is for users migrating from legacy Table ACL clusters.
 
  LEGACY_PASSTHROUGH: This mode is for users migrating from legacy Passthrough
  on high concurrency clusters.
 
  LEGACY_SINGLE_USER: This mode is for users migrating from legacy Passthrough
  on standard clusters.
 
  LEGACY_SINGLE_USER_STANDARD: This mode provides a way that doesn't have UC
  nor passthrough enabled.
 
    API               Current terminology     API alias                       Prior terminology / AKA
    =====================================================================================================
    NONE              No isolation shared
    SINGLE_USER       Dedicated               DATA_SECURITY_MODE_DEDICATED    Assigned access mode
    USER_ISOLATION    Standard                DATA_SECURITY_MODE_STANDARD     Shared access mode
```

```text
Enumeration values:
  NONE
  SINGLE_USER
  USER_ISOLATION
  LEGACY_TABLE_ACL
  LEGACY_PASSTHROUGH
  LEGACY_SINGLE_USER
  LEGACY_SINGLE_USER_STANDARD

```

#### databricks.datastructures.DataSecurityMode.DataSecurityMode

```text
DataSecurityMode Enumeration for cluster Data Security Modes in Databricks
 
  Data security mode decides what data governance model to use when accessing
  data from a cluster.
 
  NONE: No security isolation for multiple users sharing the cluster.
  Data governance features are not available in this mode. This mode
  is now referred to as "No isolation shared".
 
  SINGLE_USER: A secure cluster that can only be exclusively used by a single
  user specified in single_user_name. Most programming languages, cluster
  features and data governance features are available in this mode. This mode
  is now referred to as "Dedicated".
 
  USER_ISOLATION: A secure cluster that can be shared by multiple users.
  Cluster users are fully isolated so that they cannot see each other's data
  and credentials. Most data governance features are supported in this mode.
  But programming languages and cluster features might be limited. This mode
  is now referred to as "Standard".
 
  The following LEGACY_* modes are deprecated starting with Databricks Runtime
  15.0 and will be removed for future Databricks Runtime versions:
 
  LEGACY_TABLE_ACL: This mode is for users migrating from legacy Table ACL clusters.
 
  LEGACY_PASSTHROUGH: This mode is for users migrating from legacy Passthrough
  on high concurrency clusters.
 
  LEGACY_SINGLE_USER: This mode is for users migrating from legacy Passthrough
  on standard clusters.
 
  LEGACY_SINGLE_USER_STANDARD: This mode provides a way that doesn't have UC
  nor passthrough enabled.
 
    API               Current terminology     API alias                       Prior terminology / AKA
    =====================================================================================================
    NONE              No isolation shared
    SINGLE_USER       Dedicated               DATA_SECURITY_MODE_DEDICATED    Assigned access mode
    USER_ISOLATION    Standard                DATA_SECURITY_MODE_STANDARD     Shared access mode

    Documentation for databricks.datastructures.DataSecurityMode
```

### databricks.datastructures.DbfsStorageInfo

Superclass: handle

```text
DbfsStorageInfo DBFS storage information Example: dbfs:/my/path
  The destination must be specified as a character vector or scalar string
  If it is not prefixed with dbfs: or dbfs:/ this will be added.
```

#### databricks.datastructures.DbfsStorageInfo.DbfsStorageInfo

```text
DbfsStorageInfo DBFS storage information Example: dbfs:/my/path
  The destination must be specified as a character vector or scalar string
  If it is not prefixed with dbfs: or dbfs:/ this will be added.

    Documentation for databricks.datastructures.DbfsStorageInfo
```

### databricks.datastructures.DockerBasicAuth

Superclass: matlab.databricks.StructOrCellDeserializable

```text
DockerBasicAuth Container registry basic authentication information
 
  Example:
     % Using an authenticated registry
     dbaStruct.username = "myusername"
     dbaStruct.password = "mypassword"
     dba = databricks.datastructures.DockerBasicAuth(dbaStruct)
     diStruct.url = "http://mydockerrepourl.example.com"
     diStruct.basic_auth = dbaStruct
     di = databricks.datastructures.DockerImage(diStruct)
 
  It is bad practice to include passwords in source code.
  It is strongly recommended to read the value from MATLAB vault, a file or
  other external source.
```

#### databricks.datastructures.DockerBasicAuth.DockerBasicAuth

```text
DockerBasicAuth Container registry basic authentication information
 
  Example:
     % Using an authenticated registry
     dbaStruct.username = "myusername"
     dbaStruct.password = "mypassword"
     dba = databricks.datastructures.DockerBasicAuth(dbaStruct)
     diStruct.url = "http://mydockerrepourl.example.com"
     diStruct.basic_auth = dbaStruct
     di = databricks.datastructures.DockerImage(diStruct)
 
  It is bad practice to include passwords in source code.
  It is strongly recommended to read the value from MATLAB vault, a file or
  other external source.

    Documentation for databricks.datastructures.DockerBasicAuth
```

### databricks.datastructures.DockerImage

Superclass: matlab.databricks.StructOrCellDeserializable

```text
DockerImage Docker image connection information
 
  Examples:
     % Unauthenticated repository so do not pass empty a databricks.datastructures.DockerBasicAuth object
     di = databricks.datastructures.DockerImage(struct('url','http://mydockerrepourl.example.com'));
 
     % Using an authenticated registry
     dbaStruct.username = "myusername"
     dbaStruct.password = "mypassword"
     dba = databricks.datastructures.DockerBasicAuth(dbaStruct)
     diStruct.url = "http://mydockerrepourl.example.com"
     diStruct.basic_auth = dbaStruct
     di = databricks.datastructures.DockerImage(diStruct)
 
  It is bad practice to include passwords in source code.
  It is strongly recommended to read the value from MATLAB vault, a file or
  other external source.
```

#### databricks.datastructures.DockerImage.DockerImage

```text
DockerImage Docker image connection information
 
  Examples:
     % Unauthenticated repository so do not pass empty a databricks.datastructures.DockerBasicAuth object
     di = databricks.datastructures.DockerImage(struct('url','http://mydockerrepourl.example.com'));
 
     % Using an authenticated registry
     dbaStruct.username = "myusername"
     dbaStruct.password = "mypassword"
     dba = databricks.datastructures.DockerBasicAuth(dbaStruct)
     diStruct.url = "http://mydockerrepourl.example.com"
     diStruct.basic_auth = dbaStruct
     di = databricks.datastructures.DockerImage(diStruct)
 
  It is bad practice to include passwords in source code.
  It is strongly recommended to read the value from MATLAB vault, a file or
  other external source.

    Documentation for databricks.datastructures.DockerImage
```

### databricks.datastructures.ErrorResponse

Superclass: JSONMapper

```text
ErrorResponse Error response body
 
  databricks.datastructures.ErrorResponse Properties:
    errorCode
    message
```

#### databricks.datastructures.ErrorResponse.ErrorResponse

```text
ErrorResponse Error response body
 
  databricks.datastructures.ErrorResponse Properties:
    errorCode
    message

    Documentation for databricks.datastructures.ErrorResponse
```

#### databricks.datastructures.ErrorResponse.throw

```text
databricks.datastructures.ErrorResponse/throw is a function.
    throw(obj)
```

### databricks.datastructures.FileInfo

Superclass: handle

```text
FILEINFO Stores the attributes of a file or directory
 
  Fields:
                 path :	The path of the file or directory.
                        Type string
 
               is_dir : Whether the path is a directory.
                        Type: logical
 
            file_size : The length of the file in bytes or zero if the path
                        is a directory.
                        Type: int64
 
    modification_time : The last time, in epoch milliseconds, the file or
                        directory was modified. Note: If the request is for
                        a directory on AWS S3, this value is midnight 01-Jan-1970
                        Type: datetime
 
  The fromJSON() method can be used to create an array of FileInfo objects
  base on a JSON string as returned from listFiles.
 
  If there are no files listed in the JSON string an empty FileInfo object
  is returned.
```

#### databricks.datastructures.FileInfo.FileInfo

```text
FILEINFO Stores the attributes of a file or directory
 
  Fields:
                 path :	The path of the file or directory.
                        Type string
 
               is_dir : Whether the path is a directory.
                        Type: logical
 
            file_size : The length of the file in bytes or zero if the path
                        is a directory.
                        Type: int64
 
    modification_time : The last time, in epoch milliseconds, the file or
                        directory was modified. Note: If the request is for
                        a directory on AWS S3, this value is midnight 01-Jan-1970
                        Type: datetime
 
  The fromJSON() method can be used to create an array of FileInfo objects
  base on a JSON string as returned from listFiles.
 
  If there are no files listed in the JSON string an empty FileInfo object
  is returned.

    Documentation for databricks.datastructures.FileInfo
```

#### databricks.datastructures.FileInfo.fromJSON

```text
May return empty JSON {} if there are no files
```

#### databricks.datastructures.FileInfo.table

```text
TABLE Method to convert a list of files to a MATLAB table
  Convert a list of files into a MATLAB table.
 
  Example:
 
    db = databricks.DBFS();
    fileList = db.listFiles();
    t = table(fileList);
```

### databricks.datastructures.FileStorageInfo

Superclass: handle

```text
FileStorageInfo File storage information.
  This location type is only available for clusters set up using Databricks Container Services.
  The destination must be specified as a character vector or scalar string
  If it is not prefixed with file: or file:/ this will be added.
  Sample destination:  file:/my/file.sh
```

#### databricks.datastructures.FileStorageInfo.FileStorageInfo

```text
FileStorageInfo File storage information.
  This location type is only available for clusters set up using Databricks Container Services.
  The destination must be specified as a character vector or scalar string
  If it is not prefixed with file: or file:/ this will be added.
  Sample destination:  file:/my/file.sh

    Documentation for databricks.datastructures.FileStorageInfo
```

### databricks.datastructures.NotebookOutput

Superclass: matlab.databricks.StructOrCellDeserializable

```text
NOTEBOOKOUTPUT Databricks NotebookOutput Data Structure
```

#### databricks.datastructures.NotebookOutput.NotebookOutput

```text
NOTEBOOKOUTPUT Databricks NotebookOutput Data Structure

    Documentation for databricks.datastructures.NotebookOutput
```

### databricks.datastructures.ODBCParams

Superclass: matlab.databricks.StructOrCellDeserializable

```text
ODBCPARAMS Databricks ODBCParams Data Structure
```

#### databricks.datastructures.ODBCParams.ODBCParams

```text
ODBCPARAMS Databricks ODBCParams Data Structure

    Documentation for databricks.datastructures.ODBCParams
```

### databricks.datastructures.ObjectInfo

Superclass: handle

```text
ObjectInfo Databricks structure for Workspaces
```

#### databricks.datastructures.ObjectInfo.ObjectInfo

```text
ObjectInfo Databricks structure for Workspaces

    Documentation for databricks.datastructures.ObjectInfo
```

#### databricks.datastructures.ObjectInfo.fromJSON

```text
May return empty JSON {} if there are no files
```

#### databricks.datastructures.ObjectInfo.table

```text
table Turn array of ObjectInfo to table
```

### databricks.datastructures.ObjectType

```text
ObjectType Enumeration for object types in Databricks
```

```text
Enumeration values:
  NOTEBOOK
  DIRECTORY
  LIBRARY
  REPO
  MLFLOW_EXPERIMENT
  FILE
  DASHBOARD

```

#### databricks.datastructures.ObjectType.ObjectType

```text
ObjectType Enumeration for object types in Databricks

    Documentation for databricks.datastructures.ObjectType
```

### databricks.datastructures.RuntimeEngine

```text
RUNTIMEENGINE Databricks RuntimeEngine Data Structure
  Decides which runtime engine to be use, e.g. Standard vs. Photon.
  If unspecified, the runtime engine is inferred from spark_version.
```

```text
Enumeration values:
  NULL
  STANDARD
  PHOTON

```

#### databricks.datastructures.RuntimeEngine.RuntimeEngine

```text
RUNTIMEENGINE Databricks RuntimeEngine Data Structure
  Decides which runtime engine to be use, e.g. Standard vs. Photon.
  If unspecified, the runtime engine is inferred from spark_version.

    Documentation for databricks.datastructures.RuntimeEngine
```

### databricks.datastructures.S3StorageInfo

Superclass: handle

```text
S3StorageInfo DBFS storage information
  The destination must be specified as a character vector or scalar string
```

#### databricks.datastructures.S3StorageInfo.S3StorageInfo

```text
TODO implement checks for destination, region and endpoint
  currently in the initscriptinfo setDEstination method

    Documentation for databricks.datastructures.S3StorageInfo
```

### databricks.datastructures.WarehouseHealth

Superclass: matlab.databricks.StructOrCellDeserializable

```text
WarehouseHealth Databricks WarehouseHealth Data Structure
```

#### databricks.datastructures.WarehouseHealth.WarehouseHealth

```text
WarehouseHealth Databricks WarehouseHealth Data Structure

    Documentation for databricks.datastructures.WarehouseHealth
```

### databricks.datastructures.WarehouseSpotInstancePolicy

```text
WarehouseSpotInstancePolicy Databricks WarehouseSpotInstancePolicy Data
  Structure.
```

```text
Enumeration values:
  COST_OPTIMIZED
  RELIABILITY_OPTIMIZED
  POLICY_UNSPECIFIED

```

#### databricks.datastructures.WarehouseSpotInstancePolicy.WarehouseSpotInstancePolicy

```text
WarehouseSpotInstancePolicy Databricks WarehouseSpotInstancePolicy Data
  Structure.

    Documentation for databricks.datastructures.WarehouseSpotInstancePolicy
```

### databricks.datastructures.WarehouseState

```text
WarehouseState Databricks WarehouseState Data Structure
```

```text
Enumeration values:
  STARTING
  RUNNING
  STOPPING
  STOPPED
  DELETING
  DELETED

```

#### databricks.datastructures.WarehouseState.WarehouseState

```text
WarehouseState Databricks WarehouseState Data Structure

    Documentation for databricks.datastructures.WarehouseState
```

### databricks.datastructures.WarehouseStatus

```text
WarehouseStatus Databricks WarehouseStatus Data Structure
```

```text
Enumeration values:
  HEALTHY
  DEGRADED
  FAILED

```

#### databricks.datastructures.WarehouseStatus.WarehouseStatus

```text
WarehouseStatus Databricks WarehouseStatus Data Structure

    Documentation for databricks.datastructures.WarehouseStatus
```

### databricks.datastructures.WarehouseTagPair

Superclass: matlab.databricks.StructOrCellDeserializable

```text
WAREHOUSETAGPAIR Databricks WarehouseTagPair Data Structure
```

#### databricks.datastructures.WarehouseTagPair.WarehouseTagPair

```text
WAREHOUSETAGPAIR Databricks WarehouseTagPair Data Structure

    Documentation for databricks.datastructures.WarehouseTagPair
```

### databricks.datastructures.WarehouseTags

Superclass: matlab.databricks.StructOrCellDeserializable

```text
WarehouseTags Databricks WarehouseTags Data Structure
```

#### databricks.datastructures.WarehouseTags.WarehouseTags

```text
WarehouseTags Databricks WarehouseTags Data Structure

    Documentation for databricks.datastructures.WarehouseTags
```

#### databricks.datastructures.WarehouseTags.jsonencode

```text
jsonencode - Create JSON-formatted text from structured MATLAB data

    Syntax
      txt = jsonencode(data)
      txt = jsonencode(data,Name=Value)

    Input Arguments
      data - MATLAB data
        any supported MATLAB data type

    Name-Value Arguments
      ConvertInfAndNaN - Custom encoding
        true or 1 (default) | false or 0
      PrettyPrint - Add indentation
        false (default) | true

    Examples
      openExample('matlab/ConvertCellArrayOfTextToJSONExample')
      web /usr/local/MATLAB/R2026b/help/matlab/ref/jsonencode.html#mw_f92e7632-f4b1-4949-8218-bc9fc17a0551
      web /usr/local/MATLAB/R2026b/help/matlab/ref/jsonencode.html#mw_212db652-eb24-45f9-89a3-11ca6edd8d3e
      web /usr/local/MATLAB/R2026b/help/matlab/ref/jsonencode.html#mw_69b38ba2-26d1-4025-a426-d1bf8ca939a7

    See also jsondecode, webwrite

    Introduced in MATLAB in R2016b
    Documentation for jsonencode
       doc jsonencode
```

### databricks.datastructures.WarehouseType

```text
WarehouseType Databricks WarehouseType Data Structure
  When creating a warehouse if you want to use serverless compute,
  you must set to PRO and also set the field enable_serverless_compute
  to true.
```

```text
Enumeration values:
  PRO
  CLASSIC
  TYPE_UNSPECIFIED

```

#### databricks.datastructures.WarehouseType.WarehouseType

```text
WarehouseType Databricks WarehouseType Data Structure
  When creating a warehouse if you want to use serverless compute,
  you must set to PRO and also set the field enable_serverless_compute
  to true.

    Documentation for databricks.datastructures.WarehouseType
```

### databricks.datastructures.WorkspaceStorageInfo

Superclass: handle

```text
WorkspaceStorageInfo File destination. Example: /Users/someone@example.com/init_script.sh
  The destination must be specified as a character vector or scalar string
```

#### databricks.datastructures.WorkspaceStorageInfo.WorkspaceStorageInfo

```text
WorkspaceStorageInfo File destination. Example: /Users/someone@example.com/init_script.sh
  The destination must be specified as a character vector or scalar string

    Documentation for databricks.datastructures.WorkspaceStorageInfo
```

### databricks.internal

### databricks.internal.checks

### databricks.internal.checks.checkCompiler

```text
checkCompiler Tests for MATLAB Compiler, warns if not present
  If Compiler is not present Compiler SDK will also not be present.
  The check for Compiler SDK will be more serious and will offer to abort the install.
```

### databricks.internal.checks.checkCompilerSDK

```text
checkCompilerSDK Tests for MATLAB Compiler SDK & advises of potential limitations
  A logical true is returned if MATLAB Compiler SDK is installed otherwise false
  is returned.
  If a logical true silent value is provided a message regarding the need for
  MATLAB Compiler SDK will not be displayed.
```

### databricks.internal.checks.checkDatabaseToolbox

```text
checkDatabaseToolbox Tests for checkDatabaseToolbox, warns if not present
```

### databricks.internal.checks.checkJavaBuilder

```text
checkJavaBuilder Tests for javabuilder.jar advises of potential limitations
  An error is thrown if a local copy of JavaBuilder.jar cannot be found either
  from MATLAB Compiler SDK or the MATLAB Runtime
  If the MATLAB Runtime is installed in a non default directory the MCRROOT
  environment variable can be used to indicate the location.
```

### databricks.internal.checks.checkJavaUserHome

```text
checkJavaUserHome Checks that java returns a home directory value
```

### databricks.internal.checks.setBase64Pref

```text
setBase64Pref Sets the preference for which base 64 function to use, shipping or mex
```

### databricks.internal.cluster

### databricks.internal.cluster.downloadLogs

```text
DOWNLOADLOGS Helper function to download certain log files
 
  This is a function for internal use, but may be useful as a tool
  while debugging outputs of a specific run.
 
  This function will download logs recursively from the current cluster
  in the settings file, and save it to a local folder with
  the same name as the cluster_id.
  To save time, it will ignore all gzipped files.
 
  Optional named arguments
    authMethod     A matlab.databricks.AuthMethod
    profileName    A configuration file profileName value
 
  Example:
    databricks.internal.cluster.downloadLogs()
```

### databricks.internal.cluster.getClusterIdFromClusterOrId

```text
getClusterIdFromClusterOrId Returns the cluster_id
  
  The argument can be either a databricks.Cluster object or a
  cluster_id in the form of a string
 
  Will error if cluster_id is empty
 
  If called with two return values, the second value will be the actual
  cluster object, i.e.
 
  [clId, clusterObj] = ...
     databricks.internal.cluster.getClusterIdFromClusterOrId(aClusterId)
 
  [clId, clusterObj] = ...
     databricks.internal.cluster.getClusterIdFromClusterOrId(aClusterObj)
 
  In the first case, clID == aClusterId, and in the second case,
  clusterObj == aClusterObj.
  This might seem superfluous, but the advantage is to always get both
  these values, irregardless of the argument provided.
 
  See also databricks.internal.cluster.mustBeScalarClusterOrId
```

### databricks.internal.cluster.getClusterIdFromClusterOrIdImpl

```text
getClusterIdFromClusterOrIdImpl Returns the cluster_id
 
  The argument can be either a databricks.internal.Cluster object or a
  cluster_id in the form of a string
 
  Will error if cluster_id is empty
 
  If called with two return values, the second value will be the actual
  cluster object, i.e.
 
  [clId, clusterObj] = ...
     databricks.internal.cluster.getClusterIdFromClusterOrIdImpl(aClusterId)
 
  [clId, clusterObj] = ...
     databricks.internal.cluster.getClusterIdFromClusterOrIdImpl(aClusterObj)
 
  In the first case, clID == aClusterId, and in the second case,
  clusterObj == aClusterObj.
  This might seem superfluous, but the advantage is to always get both
  these values, irregardless of the argument provided.
 
  See also databricks.internal.cluster.mustBeScalarClusterOrIdImpl
```

### databricks.internal.cluster.getClusterRuntimeVersion

```text
GETCLUSTERRUNTIMEVERSION Returns the numeric value of a cluster runtime as a string e.g. 16.4
  Errors if the cluster is empty.
  Errors if the cluster spark_version property is missing or not set.
 
  Example:
    ver = databricks.internal.cluster.getClusterRuntimeVersion(clusterObj);
```

### databricks.internal.cluster.getClusterRuntimeVersionImpl

```text
GETCLUSTERRUNTIMEVERSIONIMPL Returns the numeric value of a cluster runtime as a string e.g. 16.4
  Errors if the cluster is empty.
  Errors if the cluster spark_version property is missing or not set.
 
  Example:
    ver = databricks.internal.cluster.getClusterRuntimeVersionImpl(clusterObj);
```

### databricks.internal.cluster.getDefaultSparkVersion

```text
GETDEFAULTSPARKVERSION Spark Version based on settings default Databricks runtime
 
  Optional named arguments:
 
  checkAvailableVersions : Use the Cluster API to determine the available options
                           and choose a filtered response.
                           Default is a logical true.
 
       databricksRuntime : Provide a Databricks runtime base version e.g. 17.3
                           to override the version in the databricks-settings.json
                           file.
 
           ML : Selects a Databricks Runtime version with ML functionality
                enabled. Default is a logical false.
 
          GPU : Selects a Databricks Runtime version with GPU functionality
                enabled. Default is a logical false.
 
       photon : Selects a Databricks Runtime version with Photon functionality
                enabled. Default is a logical false.
 
   authMethod : A matlab.databricks.AuthMethod.
 
  profileName : A configuration file profileName value.
 
  Example:
     v = databricks.internal.cluster.getDefaultSparkVersion()
     v = "17.3.x-scala2.13"
```

### databricks.internal.cluster.getDefaultSparkVersionImpl

```text
GETDEFAULTSPARKVERSIONIMPL Spark Version based on settings default Databricks runtime
 
  Optional named arguments:
 
  checkAvailableVersions : Use the Cluster API to determine the available options
                           and choose a filtered response.
                           Default is a logical true.
 
       databricksRuntime : Provide a Databricks runtime base version e.g. 15.4
                           to override the version in the databricks-settings.json
                           file.
 
           ML : Selects a Databricks Runtime version with ML functionality
                enabled. Default is a logical false.
 
          GPU : Selects a Databricks Runtime version with GPU functionality
                enabled. Default is a logical false.
 
       photon : Selects a Databricks Runtime version with Photon functionality
                enabled. Default is a logical false.
 
   authMethod : A matlab.internal.databricks.AuthMethod.
 
  profileName : A configuration file profileName value.
 
  Example:
     v = databricks.internal.cluster.getDefaultSparkVersionImpl()
     v = "15.4.x-scala2.12"
```

### databricks.internal.cluster.getSparkBaseVersion

```text
getSparkBaseVersion Returns the first 2 fields of a Spark Version separated by a "." or a "-"
  The result is returned as a string.
 
  Example:
    baseVersion = databricks.internal.cluster.getSparkBaseVersion("17.4.x-scala2.13");
```

### databricks.internal.cluster.getSparkBaseVersionImpl

```text
getSparkBaseVersionImpl Returns the first 2 fields of a Spark Version separated by a "."
  The result is returned as a string.
 
  Example:
    baseVersion = databricks.internal.cluster.getSparkBaseVersionImpl("10.4.x-scala2.12");
```

### databricks.internal.cluster.isAptPermittedOnCluster

```text
isAptPermittedOnCluster Returns true if a cluster can run "apt-get update"
```

### databricks.internal.cluster.isGitHubReadableByCluster

```text
isGitHubReadableByCluster returns true if accessing the GitHub returns 200
```

### databricks.internal.cluster.isInitScriptOnAllowlist

```text
ISINITSCRIPTONALLOWLIST Checks if a given init script file is on an allowlist
  Returns a logical.
  A prefix match is performed on the path.
  The check is only performed if the cluster has an accessMode/data_security_mode
  of type "USER_ISOLATION", if not true is returned.
  Either an access mode, cluster object or cluster Id argument is required.
 
  Example:
    tf = databricks.internal.cluster.isInitScripOnAllowlist("/Volumes/default/main/mydir/myscript.sh", clusterOrId=myCluster);
 
  Use of a Databricks runtime v13.3 or greater is assumed.
 
  See also: https://docs.databricks.com/en/init-scripts/index.html
            https://docs.databricks.com/en/data-governance/unity-catalog/manage-privileges/allowlist.html
```

### databricks.internal.cluster.isInitscriptSupported

```text
ISINITSCRIPTSUPPORTED Checks of if a cluster scoped init script is supported
  The destination path should be the full path including the init script filename.
  Returns a logical.
  This function errs on the side of returning true when specific
  failure modes are not known.
 
  Access mode and databricks.datastructures.DataSecurityMode correspondence:
 
    Shared access mode = USER_ISOLATION
    Single user access mode = SINGLE_USER
    No isolation shared access mode (Legacy) = NONE
 
  Use of a Databricks runtime v13.3 or greater is assumed.
 
  Example:
    tf = databricks.internal.cluster.isInitscriptSupported("/Volumes/default/main/mydir/myInitscript.sh", clusterOrId=myCluster)
 
  See also: https://docs.databricks.com/en/init-scripts/index.html
            https://docs.databricks.com/en/data-governance/unity-catalog/manage-privileges/allowlist.html
```

### databricks.internal.cluster.isJarOnAllowlist

```text
ISJARONALLOWLIST Checks if a given jar file is on an allowlist
  Checks .jar paths only, returns true otherwise.
  Returns a logical.
  A prefix match is performed on the path.
  The check is only performed if the cluster has an accessMode/data_security_mode
  of type "USER_ISOLATION", if not true is returned.
  Either an access mode, cluster object or cluster Id argument is required.
 
  Example:
    tf = databricks.internal.cluster.isJarOnAllowlist("/Volumes/default/main/mydir/mylib.jar", clusterOrId=myCluster)
 
  Use of a Databricks runtime v13.3 or greater is assumed.
 
  See also: https://docs.databricks.com/en/libraries/index.html
            https://docs.databricks.com/en/data-governance/unity-catalog/manage-privileges/allowlist.html
```

### databricks.internal.cluster.isJobCluster

```text
isJobCluster 
  
  Returns true if the cluster_id provided is a job cluster, otherwise
  false.
  
  Throws an error otherwise.
 
  Example:
    tf = databricks.internal.cluster.isJobCluster("0306-062556-bqreojvr")
```

### databricks.internal.cluster.isJobsSupported

```text
ISJOBSSUPPORTED Returns true if the cluster supports jobs otherwise false
  If the cluster does not have a workload_type property that specifies jobs
  support, true is assumed as the default.
```

### databricks.internal.cluster.isLibraryPolicySet

```text
ISLIBRARYPOLICYSET Returns true if a Cluster has one or more libraries defined in a policy
  Returns false a library is not defined in a policy or there is no policy set.
  If there is an error determined a cluster an empty logical is returned.
```

### databricks.internal.cluster.isLibrarySupported

```text
ISLIBRARYSUPPORTED Checks of if a Cluster scoped Library is supported
  Checks .jar and .whl paths only, returns true otherwise.
  The destination path should be the full path including the library filename.
  Returns a logical.
  This function errs on the side of returning true when specific
  failure modes are not known.
 
  Access mode and databricks.datastructures.DataSecurityMode correspondence:
 
    Shared access mode = USER_ISOLATION
    Single user access mode = SINGLE_USER
    No isolation shared access mode (Legacy) = NONE
 
  Use of a Databricks runtime v13.3 or greater is assumed.
 
  Example:
    tf = databricks.internal.cluster.isLibrarySupported("/Volumes/default/main/mydir/mylib.whl", clusterOrId=myCluster)
 
  See also: https://docs.databricks.com/en/libraries/index.html
```

### databricks.internal.cluster.isNotebooksSupported

```text
ISNOTEBOOKSSUPPORTED Returns true if the cluster supports notebooks otherwise false
  If the cluster does not have a workload_type property that specifies notebooks
  support, true is assumed as the default.
```

### databricks.internal.cluster.isPyPIReadableByCluster

```text
isPyPIReadableByCluster returns true if accessing the https://pypi.org returns 200
```

### databricks.internal.cluster.isRuntimeDownloadableByCluster

```text
isRuntimeDownloadable returns true if accessing the runtime returns 200
  Unless specified the current release is checked, using the cluster_install.json
  file for URLs.
  An alternative release Value in the form "R2023b" can optionally be used.
  By default the clusterId set via credentials is used, an alternative value
  can optionally be specified.
```

### databricks.internal.cluster.mustBeScalarClusterOrId

```text
mustBeClusterOrId Check if an argument is a cluster or cluster id
  
  This can be used as a validator in arguments blocks.
  
  It cannot be a cluster or cluster_id array.
 
  Example:
    arguments
        clusterOrId {databricks.internal.cluster.mustBeScalarClusterOrId}
    end
```

### databricks.internal.cluster.mustBeScalarClusterOrIdImpl

```text
mustBeScalarClusterOrIdImpl Check if an argument is a cluster or cluster id
 
  This can be used as a validator in arguments blocks.
 
  It cannot be a cluster or cluster_id array.
 
  Example:
    arguments
        clusterOrId {databricks.internal.cluster.mustBeScalarClusterOrIdImpl}
    end
```

### databricks.internal.cluster.startCluster

```text
STARTCLUSTER Start an existing cluster and optionally wait for it to reach RUNNING state
  If the waitForRunning option is enabled (default) then a RUNNING databricks.Cluster
  should be returned. Otherwise or in the case of error an empty databricks.Cluster
  is returned and its state should be handled upstream.
  A timeout of 12 minutes is applied.
 
  Example:
    cluster = databricks.internal.cluster.startCluster(clusterId);
```

### databricks.internal.cluster.startClusterImpl

```text
STARTCLUSTERIMPL Start an existing cluster and optionally wait for it to reach RUNNING state
  If the waitForRunning option is enabled (default) then a RUNNING databricks.internal.Cluster
  should be returned. Otherwise or in the case of error an empty databricks.internal.Cluster
  is returned and its state should be handled upstream.
  A timeout of 12 minutes is applied.
 
  Example:
    cluster = databricks.internal.cluster.startClusterImpl(clusterId);
```

### databricks.internal.cluster.waitForClusterToStart

```text
waitForClusterToStart Wait for a cluster to go to a RUNNING state
    Returns if already RUNNING.
    Waits if PENDING, RESTARTING, RESIZING or UNKNOWN.
    Errors if TERMINATING, TERMINATED ERROR or otherwise.
 
   Optional arguments:
        cluster: Cluster Id or CLuster object, otherwise credentials are used if available
        timeout: Errors if timeout is exceeded, default 12 minutes, specified and an int32 seconds value
     authMethod: A matlab.databricks.AuthMethod
    profileName: A configuration file profileName value
        verbose: Logical to enable additional logging, default false
 
  Example:
    databricks.internal.cluster.waitForClusterToStart(cluster=clusterId)
```

### databricks.internal.cluster.waitForClusterToStartImpl

```text
waitForClusterToStartImpl Wait for a cluster to go to a RUNNING state
    Returns if already RUNNING.
    Waits if PENDING, RESTARTING, RESIZING or UNKNOWN.
    Errors if TERMINATING, TERMINATED ERROR or otherwise.
 
   Optional arguments:
        cluster: Cluster Id or Cluster object, otherwise credentials are used if available
        timeout: Errors if timeout is exceeded, default 12 minutes, specified and an int32 seconds value
     authMethod: A matlab.internal.databricks.AuthMethod
    profileName: A configuration file profileName value
        verbose: Logical to enable additional logging, default false
 
  Example:
    databricks.internal.cluster.waitForClusterToStartImpl(cluster=clusterId)
```

### databricks.internal.commandexecution

### databricks.internal.commandexecution.cancelCommand

```text
CANCELCOMMAND Cancels a command
  Returns a logical.
 
  Example:
    result = databricks.internal.commandexecution.cancelCommand(commandId, contextId);
```

### databricks.internal.commandexecution.commandStatus

```text
COMMANDSTATUS Returns the status of a command
  Returns a databricks.datastructures.commandexecution.CommandsStatusStatus enum
 
  Example:
    result = databricks.internal.commandexecution.commandStatus(commandId, contextId);
```

### databricks.internal.commandexecution.executePythonCommand

```text
executePythonCommand Execute a Python command via the command execution REST API
  If a previously created contextId is provided a new one is not created
 
  Required argument:
    pythonCommand: Python code to execute is single line form
                   Type: scalar string
 
  Optional named arguments:
              env: containers.Map that holds environment variable key-value pairs
                   that will be set as a prefix to the pythonCommand code.
                   Keys and values should be of type scalar text.
 
          timeout: The default timeout is 30 seconds. This timeout applies
                   to command execution only
                   Type: int32
                   Default: 30
 
   startupTimeout: The default value is 8 minutes and is intended to allow for the
                   startup period of a cluster
                   Type: int32
                   Default: 4800 (8 minutes)
 
   contextTimeout: The default contextTimeout is 30 seconds. This timeout applies
                   to context creation phase while the context transitions from pending
                   to running.
                   Type: int32
                   Default: 30
 
        clusterId: ID of cluster to use, if not set the ID will be taken
                   from .databrickscfg configuration file
                   Type: scalar string
 
        contextId: ID of a previously created context to be reused.
                   Type: scalar string
 
    retainContext: Indicate if the context should be destroyed after this call or
                   retained and the ID returned for use in future calls
                   Type: scalar logical
                   Default: false
 
       authMethod: A matlab.databricks.AuthMethod.
 
      profileName: A configuration file profileName value.
 
          verbose: More feedback is provided if set to true.
                   Default: true
 
         blocking: The call will block and wait for completion of the command or not.
                   In the non blocking case the context is not automatically deleted
                   if retainContext is false. The timeout value is not applied to
                   execution.
                   Default: true
 
  Examples:
    % Simply print 'Hello world'
    result = databricks.internal.commandexecution.executePythonCommand("print('Hello world')")
      result = "Hello world"
 
    % Run a sample system command that should return 0 not the value is
    % returned a string "0"
    result = databricks.internal.commandexecution.executePythonCommand("import os; result = os.system('who'); print(result)")
      result = "0"
 
    % subprocess can provide more option and control of output and errors
    pyStr = sprintf('import subprocess; subprocess.run(["md5sum", "%s"], capture_output=True)', myfile);
    [md5sumRaw, contextId, commandId] = databricks.internal.commandexecution.executePythonCommand(pyStr, int32(5*60));
```

### databricks.internal.commandexecution.executePythonSubprocess

```text
executePythonSubprocess Uses a Python subprocess.run command to execute system calls
  Required arguments are provided as a string array of arguments or a scalar string.
 
  Providing a sequence of arguments is preferred, so the module takes care
  of escaping and quoting of arguments, e.g. spaces in file names.
  If passing a single string, either options.shell should be true
  or the string should name a command to execute without arguments.
 
  Optional named arguments:
            env: containers.Map that holds environment variable key-value pairs
                 that will be set as the subprocess.run env argument.
                 Keys and values should be of type scalar text.
                 The values will be set in the environment before the code
                 is executed. In the context of an existing environment, these
                 entries will add to or overwrite existing values.
                 See also inheritEnv option.
 
     inheritEnv: logical value (default: true), that decides if the process
                 should inherit from the existing environment, or build an
                 environment from scratch. It has an effect when the env option
                 is used, but even without env, this option set to false will
                 create an empty environment with which the process is run.
 
          shell: Enable the subprocess shell feature
                 Type: Logical
                 Default: false
 
        timeout: This timeout applies to both context creation and command execution
                 Type: int32
                 Default: 30
 
      clusterId: ID of cluster to use, if not set the ID will be taken
                 from .databrickscfg configuration file
                 Type: scalar string
 
      contextId: ID of a previously created context to be reused
                 Type: scalar string
 
  retainContext: Indicate if the context should be destroyed after this call or
                 retained and the ID returned for use in future calls
                 Type: scalar logical
                 Default: false
 
     authMethod: A matlab.databricks.AuthMethod
 
    profileName: A configuration file profileName value
 
        verbose: More feedback is provided if set to true.
                 Default: true
 
       blocking: The call will block and wait for completion of the command or not.
                 In the non blocking case the context is not automatically deleted
                 if retainContext is false. The timeout value is not applied to
                 execution.
                 Default: true
 
         userId: Run the process with this user id
 
        groupId: Run the process with this group id
 
  The default output is the command's return code.
 
  A response structure is be returned containing:
    The stdout if present and otherwise an empty string.
    The stderr if present and otherwise an empty string.
    The subprocess command string passed to Python.
 
  A contextId value is returned as a string. This corresponds to the context ID
  used to execute the command. It the retainContext argument was set to true
  this value should be used to manually destroy the execution context when
  it is no longer needed:
    destroyRequest = databricks.datastructures.commandexecution.DestroyRequest;
    destroyRequest.clusterId = clusterId;
    destroyRequest.contextId = contextId;
    destroyResponse = commandExecution.destroy(destroyRequest);
  or in the last call to this function in a sequence omit the retainContext
  argument and it will be destroyed.
 
  Examples:
    % print Hello world
    [result, response] = databricks.internal.commandexecution.executePythonSubprocess(["echo", "Hello world"])
    result =
        "0"
    response =
      struct with fields:
         pyCmd: "import subprocess; subprocess.run(["echo", "Hello world"], capture_output=True)"
        stdout: "Hello world\n"
        stderr: ""
 
    % ls /
    [result, response] = databricks.internal.commandexecution.executePythonSubprocess("ls /")
    result =
        "0"
    response =
      struct with fields:
         pyCmd: "import subprocess; subprocess.run(["ls", "/"], capture_output=True)"
        stdout: "BUILD\nVolumes\nWorkspace\nbin\nboot\ndatabricks\ndatabricks-datasets\ndbfs\ndev\netc\nhome\nlib\nlib32\nlib64\nlibx32\nlocal_disk0\nmedia\nmnt\nopt\nproc\nroot\nrun\nsbin\nsrv\nsys\ntmp\nusr\nvar\n"
        stderr: ""
 
    % Use the shell option with a single string, in this case to use globbing
    [result, response] = databricks.internal.commandexecution.executePythonSubprocess("ls /t*", shell=true)
    result =
        "0"
    response =
      struct with fields:
         pyCmd: "import subprocess; subprocess.run(["ls /t*"], capture_output=True, shell=True)"
        stdout: "Rserv\nRtmpEfhqqD\nchauffeur-daemon-params\nchauffeur-daemon.pid\nchauffeur-env.sh\ncustom-spark.conf\ndriver-daemon-params\ndriver-daemon.pid\ndriver-env.sh\nhsperfdata_root\nmaster-params\npython_lsp_logs\nspark-root-org.apache.spark.deploy.master.Master-1.pid\nsystemd-private-441422b1e4f24ed2bcda38b84e2463be-systemd-logind.service-jX39JY\nsystemd-private-441422b1e4f24ed2bcda38b84e2463be-systemd-resolved.service-CIpqKq\ntmp.uyInzKBDSN\n"
        stderr: ""
 
    % Create a directory with spaces in the name
    [result, response] = databricks.internal.commandexecution.executePythonSubprocess(["mkdir", "/tmp/my space dir"])
    result =
        "0"
    response =
      struct with fields:
         pyCmd: "import subprocess; subprocess.run(["mkdir", "/tmp/my space dir"], capture_output=True)"
        stdout: ""
        stderr: ""
```

### databricks.internal.commandexecution.waitForCommandFinished

```text
waitForCommandFinished Wait until a command status Finished is returned or a timeout elapses
  True is returned on success otherwise false.
  The default timeout is 30 seconds.
 
  Optional named arguments
    authMethod     A matlab.databricks.AuthMethod
    profileName    A configuration file profileName value
```

### databricks.internal.commandexecution.waitForContextRunning

```text
waitForContextRunning Wait until a context transitions from Pending to Running
  True is returned on success otherwise false.
  The default timeout is 30 seconds.
  False is returned if a timeout elapses or an unexpected state is
  returned.
  The last received contextsStatus response is optionally returned.
 
  Optional named arguments
    authMethod     A matlab.databricks.AuthMethod
    profileName    A configuration file profileName value
```

### databricks.internal.configurationprofile

### databricks.internal.configurationprofile.ConfigFile

```text
ConfigFile Parser and manager for the .databrickscfg configuration file.
 
  The .databrickscfg file is the standard Databricks configuration file
  used across all Databricks tools (CLI, Python SDK, Go SDK, JDBC/ODBC).
  It stores one or more named connection profiles containing credentials
  and workspace URLs (host, token, client_id, etc.). Its default location
  is ~/.databrickscfg, overridable via the DATABRICKS_CONFIG_FILE env var.
 
  ConfigFile parses the INI-style ~/.databrickscfg file into Profile objects,
  retrieves profiles by name with automatic environment variable overrides
  (e.g., DATABRICKS_HOST overrides the host field), and resolves the
  default profile using this priority:
    1. DATABRICKS_CONFIG_PROFILE env var
    2. profileName from databricks-settings.json
    3. Profile named "DEFAULT"
    4. First profile in the file
 
  Also supports writing/merging profiles back to the file (with backup)
  and deployed mode (compiled MATLAB apps) with alternate file lookup.
 
  Keys are case sensitive.
 
  Examples:
 
      % Create a ConfigFile object c from a file, if the argument is a valid
      % file it will be read otherwise the argument is assumed to be the
      % content
      c = databricks.internal.configurationprofile.ConfigFile('myFilePath.txt');
 
      % Return a credentials profile as a struct
      profile = c.getProfile('profileName');
```

#### databricks.internal.configurationprofile.ConfigFile.ConfigFile

```text
ConfigFile Returns a databricks.internal.configurationprofile.ConfigFile
  The Profiles property is a struct containing profiles present in the configuration file.
  The default configuration file name is <home directory>/.databrickscfg
  If the environment variable DATABRICKS_CONFIG_FILE is set this value overrides the default
  value or function argument.

    Documentation for databricks.internal.configurationprofile.ConfigFile
```

#### databricks.internal.configurationprofile.ConfigFile.cfgFileWithMaskedTokens

```text
cfgFileWithMaskedTokens Returns configuration file with the tokens fields masked
  Tokens are replaced with  asterisks.
  A String is returned.
  Leading and trailing white space is removed.
```

#### databricks.internal.configurationprofile.ConfigFile.deleteProfileField

```text
deleteProfileField Deletes a field from a profile in the configuration file
 
  Example:
    tf = databricks.internal.configurationprofile.ConfigFile.deleteProfileField("cluster_id");
```

#### databricks.internal.configurationprofile.ConfigFile.getAllProfiles

```text
getAllProfiles Populates the Profiles property
  Content is based on all the profiles in the file
  If no profiles are found a empty databricks.internal.configurationprofile.Profile
  with no fields and name DEFAULT is returned
```

#### databricks.internal.configurationprofile.ConfigFile.getCfgFilePath

```text
getCfgFilePath
  If the DATABRICKS_CONFIG_FILE environment variable is set it is used.
  Otherwise a default of <home directory>/.databrickscfg is used.
  A character vector is returned.
  This method does not validate if the file exists or not.
 
  Example:
    filepath = databricks.internal.configurationprofile.ConfigFile.getCfgFilePath
 
  In deployed mode, first the environment variable DATABRICKS_CONFIG_FILE is
  checked. Then the path is checked using which for .databrickscfg.
  Then the path is checked using which for deployed.databrickscfg.
  Then the path ctfroot()/deployed.databrickscfg is used, this file may
  or may not exist.
  Files with a leading "." can be problematic in some deployed cases.
```

#### databricks.internal.configurationprofile.ConfigFile.getDefaultProfile

```text
getDefaultProfile Returns the default profile
  A `.databrickscfg` file supports multiple profiles, which profile to use is selected based on the following priority:
    1. Many functions support an argument or optional argument typically called `profileName`.
    2. The value of the `DATABRICKS_CONFIG_PROFILE` if set.
    3. The `profileName` field in the [`databricks-settings.json`](Setup.md) file.
    4. The profile named `DEFAULT` if present.
    5. The first profile in the file if present.
 
  Otherwise an empty databricks.internal.configurationprofile.Profile
  is returned.
  Profile names are case sensitive.
```

#### databricks.internal.configurationprofile.ConfigFile.getDefaultProfileName

```text
getDefaultProfileName Returns the name of the default profile
  The DATABRICKS_CONFIG_PROFILE environment variable is respected.
  The DATABRICKS_CONFIG_FILE environment variable is respected.
  The DATABRICKS_SETTINGS_FILE environment variable is respected.
  If a settings file value is set it is returned.
  If only one profile is found its name is returned.
  If a profile named DEFAULT is found it is returned.
  If a default cannot be determined an empty string is returned.
  If one has a profile object for the default profile e.g.: profile = getDefaultProfile(obj)
  its .Name can be used as an alternative.
 
  Example:
    defaultProfileName = databricks.internal.configurationprofile.ConfigFile.getDefaultProfileName(cfgFile=cfgFile, verbose=true)
```

#### databricks.internal.configurationprofile.ConfigFile.getEnvVarValue

```text
databricks.internal.configurationprofile.ConfigFile.getEnvVarValue is a function.
    value = getEnvVarValue(key)
    value = getEnvVarValue(___, Name, Value)
```

#### databricks.internal.configurationprofile.ConfigFile.getInstanceDefaultProfileName

```text
getInstanceDefaultProfileName Returns the name of the default profile for the given object
 
  A `.databrickscfg` file supports multiple profiles, which profile to use is selected based on the following priority:
    1. Many functions support an argument or optional argument typically called `profileName`.
    2. The value of the `DATABRICKS_CONFIG_PROFILE` if set.
    3. The `profileName` field in the [`databricks-settings.json`](Setup.md) file.
    4. The profile named `DEFAULT` if present.
    5. The first profile in the file if present.
 
  Otherwise an empty databricks.internal.configurationprofile.Profile
  is returned.
  Profile names are case sensitive.
 
  If one has a profile object for the default profile e.g.: profile = getDefaultProfile(obj)
  its .Name can be used as an alternative.
 
  The static alternative is: databricks.internal.configurationprofile.ConfigFile.getDefaultProfileName
  It calls this method in turn.
```

#### databricks.internal.configurationprofile.ConfigFile.getProfile

```text
getProfile Returns a profile of a given name or the default profile name
  If no matching profile exists an empty profile is returned.
 
  If profile is found and the optional enableEnvVarOverrides flag is true (default)
  then the following fields are overridden by the follow environment variables if
  set:
    account_id      DATABRICKS_ACCOUNT_ID
    client_id       DATABRICKS_CLIENT_ID
    client_secret   DATABRICKS_CLIENT_SECRET
    host            DATABRICKS_HOST
    token           DATABRICKS_TOKEN
    username        DATABRICKS_USERNAME
    password        DATABRICKS_PASSWORD
    cluster_id      DATABRICKS_CLUSTER_ID
 
  Profile names are case sensitive.
```

#### databricks.internal.configurationprofile.ConfigFile.getProfileField

```text
databricks.internal.configurationprofile.ConfigFile.getProfileField is a function.
    value = getProfileField(fieldName)
    value = getProfileField(___, Name, Value)
```

#### databricks.internal.configurationprofile.ConfigFile.isDatabricksCfgFile

```text
isDatabricksCfg Returns true if a .databrickscfg format file is present
  The DATABRICKS_CONFIG_FILE environment variable is applied.
 
  Example:
    [tf, filepath] = databricks.internal.configurationprofile.ConfigFile.isDatabricksCfgFile
```

#### databricks.internal.configurationprofile.ConfigFile.isProfile

```text
isProfile Returns true if a named profile is found otherwise false
  Profile names are case sensitive.
```

#### databricks.internal.configurationprofile.ConfigFile.listProfiles

```text
listProfiles Returns a string array of profile names
  If no profiles are found and empty string array is returned.
  Profile names are case sensitive.
```

#### databricks.internal.configurationprofile.ConfigFile.merge

```text
merge Merges the source and destination array profiles
  If a profile of the same name exists in both profiles the
  source profile is used.
  If the destination is empty the source is returned.
  If the source is empty the destination is returned.
```

#### databricks.internal.configurationprofile.ConfigFile.writeProfileField

```text
writeProfileField Writes a field to a profile in the .databrickscfg format
  A backup file <outputFile>.bak is created by default.
  The default output filename is <home directory>/.databrickscfg
  By default existing profiles are not replaced unless a profile of the
  same name exists in the input, in which case the profiles are merged
  with the incoming field values taking precedence.
```

#### databricks.internal.configurationprofile.ConfigFile.writeProfiles

```text
writeProfile Writes one or more profiles to a .databrickscfg format file
  A backup file <outputFile>.bak is created by default.
  The default output filename is <home directory>/.databrickscfg
  By default existing profiles values are not replaced unless a profile value of the
  same name exists in the input. If replace is true all existing profiles
  are overwritten.
 
  Example:
    myName = "MYPROFILE";
    myKeys = ["key1", "key2"];
    myValues = ["value1", "value2"];
    p = databricks.internal.configurationprofile.Profile(name=myName, keys=myKeys, values=myValues);
    [tf,outputFile] = databricks.internal.configurationprofile.ConfigFile.writeProfiles(p)
```

### databricks.internal.configurationprofile.Profile

```text
Profile Class for working with a blocks of settings
  Profile details can be provided either as:
   * Scalar text containing the header, keys and values as written
     in a configuration file.
   * A name (scalar text), keys (string array) and values (string
     array). The number of keys and values must be equal.
   * A struct with scalar text double integer or logical fields.
 
  If none are provided and empty profile named DEFAULT is returned.
 
  Example:
    myName = "MYPROFILE";
    myKeys = ["key1", "key2"];
    myValues = ["value1", "value2"];
    p = databricks.internal.configurationprofile.Profile(name=myName, keys=myKeys, values=myValues);
```

#### databricks.internal.configurationprofile.Profile.Profile

```text
Profile Class for working with a blocks of settings
  Profile details can be provided either as:
   * Scalar text containing the header, keys and values as written
     in a configuration file.
   * A name (scalar text), keys (string array) and values (string
     array). The number of keys and values must be equal.
   * A struct with scalar text double integer or logical fields.
 
  If none are provided and empty profile named DEFAULT is returned.
 
  Example:
    myName = "MYPROFILE";
    myKeys = ["key1", "key2"];
    myValues = ["value1", "value2"];
    p = databricks.internal.configurationprofile.Profile(name=myName, keys=myKeys, values=myValues);

    Documentation for databricks.internal.configurationprofile.Profile
```

#### databricks.internal.configurationprofile.Profile.getValue

```text
getValue Returns the value for a given key as a string
  If the key does not exists an empty string is returned
```

#### databricks.internal.configurationprofile.Profile.isKey

```text
isKey Returns true if a key exists otherwise false
  The Profile object stores and checks keys based on their lower case value automatically.
```

#### databricks.internal.configurationprofile.Profile.keys

```text
keys Returns a string array of the profiles keys
  Keys are returned in lower case as the Profile object stores keys based on their lower case value automatically.
```

#### databricks.internal.configurationprofile.Profile.remove

```text
remove Removes a named field from the profile
  The fieldname is lower cased automatically.
```

#### databricks.internal.configurationprofile.Profile.setValue

```text
setValue Sets the value for a given key name
  If the key is already set it is overwritten.
  Key names are stored in lower case automatically.
```

#### databricks.internal.configurationprofile.Profile.setValueFromEnvironment

```text
setValueFromEnvironment Override a value with an environment variable if set
  If the environment variable is not set the value returned unchanged
  Values are returned as scalar strings if changed or otherwise their
  original type. Values are returned within the profile.
```

#### databricks.internal.configurationprofile.Profile.toString

```text
toString Returns a profile block including its header as a string
```

#### databricks.internal.configurationprofile.Profile.values

```text
values Returns a string array of the profiles values
```

### databricks.internal.databricksConnect

### databricks.internal.databricksConnect.getDBCClientVersion

```text
GETDBCCLIENTVERSION Returns the version string of the Databricks Connect Python package
 
  Returns a string e.g. 16.4.10 or 16.4
 
  If the package is not installed, an error is raised.
 
  Example:
    ver = databricks.internal.databricksConnect.getDBCClientVersion();
```

### databricks.internal.databricksConnect.getDBCClientVersionImpl

```text
GETDBCCLIENTVERSION Returns the version string of the Databricks Connect Python package
 
  Returns a string e.g. 16.4.10 or 16.4
 
  If the package is not installed, an error is raised.
 
  Example:
    ver = databricks.internal.databricksConnect.getDBCClientVersionImpl();
```

### databricks.internal.databricksConnect.getDBCVersions

```text
getDBCVersions Returns a string array of Databricks Connect Versions
  Order should not be assumed.
  Data is returned from https://pypi.org/pypi/databricks-connect/json
```

### databricks.internal.databricksConnect.getLatestDBCVersion

```text
getLatestDBCVersion Returns the version string for the latest Databricks Connect release
  If no version value is found an empty string is returned.
  A base version can be specified as a string.
 
  A second argument, allVersions, can be passed in to reduce REST calls
  to web service. This makes sense mostly when looping through
  different versions.
 
  Example:
      v = databricks.internal.databricksConnect.getLatestDBCVersion
        v = "14.3.1"
 
      v = databricks.internal.databricksConnect.getLatestDBCVersion("13")
        v = "13.3.1"
 
      allVersions = databricks.internal.databricksConnect.getDBCVersions();
      v = databricks.internal.databricksConnect.getLatestDBCVersion("12.2", allVersions)
        v = "12.2.22"
```

### databricks.internal.databricksConnect.getPyDatabricksConnectVersion

```text
getPyDatabricksConnectVersion Returns version of Databricks Connect from Python environment
```

### databricks.internal.databricksConnect.isDatabricksConnectv2Version

```text
isDatabricksConnectv2Version Returns true if version should use Databricks Connect v2 otherwise false
 
  Example
    tf = databricks.internal.databricksConnect.isDatabricksConnectv2Version("13.3")
```

### databricks.internal.databricksConnect.sortDBVersions

```text
sortDBVersions Returns a sorted lists of Databricks version strings
  Sorts oldest to latest.
  Input should be a string array.
  Two version fields are required.
  The separator is a '.'.
  A third and fourth field are optional.
 
  Assumes:
    * The first two field values are numbers only
    * The 3rd field is of the form <number>b<number or a number only
    * The 4th field is a number only
 
  A string array is returned.
  if no versions are provided an empty string is returned.
  
  This format is Semantic Version compliant.
```

### databricks.internal.files

### databricks.internal.files.download

```text
DOWNLOAD Download a file or directory of files using the Files API
  
  Optional arguments:
    destination: Specify a destination path, otherwise the current directory
                 is used along with the source file/directory name.
 
      overwrite: Overwrite an existing local file or directory.
                 Default: true.
 
      recursive: Recursively download subdirectories.
                 Default: true.
 
        verbose: Enable additional output.
                 Default: true.
 
  Example:
    f = databricks.Files;
    [result, localPath] = databricks.internal.files.download(f, "/volumes/main/default/myvolume/mydirectory")
```

### databricks.internal.genie

### databricks.internal.genie.statementResponse2Table

```text
STATEMENTRESPONSE2TABLE
 
  Example:
    [result, errorResponse] = g.getMsgAttachmentSQLQueryResult(spaceId, conversationId, messageId, attachmentId)
    MATLABTable = databricks.internal.genie.statementResponse2Table(result.StatementResponse);
```

### databricks.internal.instancepool

### databricks.internal.instancepool.cloneFromCluster

```text
CLONEFROMCLUSTER Creates an instance pool based on an existing cluster
  A Databricks user may not have the rights to create an instance pool, in
  which case this function will fail to create a pool.
 
  The cluster's autotermination time is applied to the pool's idleInstanceAutoterminationMinutes
  property if set.
 
  The followings optional named arguments may be specified:
    minIdleInstances : int32, default: 1
         maxCapacity : int32
    idleInstanceAutoterminationMinutes : int32 cluster
                name : string, default "Cloned from cluster: <clusterId>"
          authMethod : matlab.databricks.AuthMethod
         profileName : string, default profile name
 
  Example:
    c = datarbicks.Cluster.findByName("myDesktopCluster");
    [poolId, errorResponse] = databricks.internal.instancepool.cloneFromCluster(c);
 
  Note: Unneeded pools should be removed to reduce costs.
  Example:
    ip = databricks.InstancePools;
    [result, errorResponse] = ip.remove('0826-134312-fops10-pool-qndpush3');
```

### databricks.internal.io

### databricks.internal.io.FileSystemType

```text
FileSystemType Enumeration for File System types
 
  Example:
    type = databricks.internal.io.FileSystemType.DBFS
```

```text
Enumeration values:
  DBFS
  ABFSS
  S3
  WORKSPACE
  VOLUMES

```

#### databricks.internal.io.FileSystemType.FileSystemType

```text
FileSystemType Enumeration for File System types
 
  Example:
    type = databricks.internal.io.FileSystemType.DBFS

    Documentation for databricks.internal.io.FileSystemType
```

### databricks.internal.io.IO

Superclass: databricks.Object

```text
IO Class to provide an interface to the Databricks file APIs
 
  Examples:
    io = databricks.internal.io.IO();
 
    io = databricks.internal.io.IO(authMethod="PAT");
```

#### databricks.internal.io.IO.IO

```text
IO Constructor

    Documentation for databricks.internal.io.IO
```

#### databricks.internal.io.IO.dir

```text
DIR List contents of a directory
  Returns a struct array with file/folder information.
  For folder/directory entries the size will be 0.
  The size field is an int64, it may be empty.
  The date field represents the last modified date and may be an empty
  datetime.
  Supports Volumes, DBFS & Workspace path types.
 
  Examples:
    io = databricks.internal.io.IO;
    result = io.dir("/Volumes/main/default/myvolume")
 
    result = io.dir("/Users/user@example.com/")
```

#### databricks.internal.io.IO.download

```text
DOWNLOAD File system type agnostic file down loader
  Currently supports VOLUMES, DBFS and WORKSPACE type per
  databricks.internal.io.FileSystemType.
 
  Example:
    io = databricks.internal.io.IO(authMethod="PAT");
    [result, localPath] = io.download("/Volumes/main/default/myvolume/mydir/myfile.txt");
 
  In general the use of DBFS is discouraged.
 
  In MATLAB releases older than R2025a a failed download may leave behind a
  destination directory when working with /Volumes.
```

#### databricks.internal.io.IO.fileparts

```text
FILEPARTS Performs fileparts like functionality for databricks.internal.io.IO paths
 
  Examples:
    [path, file, extension] = databricks.internal.io.IO.fileparts("/Workspace/Users/mbrowne@mathworks.com/mycode.m");
```

#### databricks.internal.io.IO.getType

```text
GETTYPE Returns an enumeration based on the type of a path
  If a determination cannot be made an empty value is returned.
  The return type is databricks.internal.io.FileSystemType.
 
  Example:
    ioEnumType = databricks.internal.io.IO.getType(pathStr);
```

#### databricks.internal.io.IO.isfile

```text
ISFILE Filesystem type agnostic check for file existence
  Returns a logical.
  Currently supports VOLUMES, DBFS & WORKSPACE types per
  databricks.internal.io.FileSystemType.
 
  Example:
    io = databricks.internal.io.IO;
    tf = io.isfile("/Volumes/main/default/myvolume/myDir/hello-world.txt")
```

#### databricks.internal.io.IO.isfolder

```text
ISFOLDER Filesystem type agnostic check for directory existence
  Returns a logical.
  Currently supports VOLUMES, DBFS & WORKSPACE types per
  databricks.internal.io.FileSystemType.
 
  Example:
    io = databricks.internal.io.IO;
    tf = io.isfolder("/Volumes/main/default/myvolume/myDir")
```

#### databricks.internal.io.IO.mkdir

```text
mkdir Filesystem type agnostic mkdir
  Returns a logical.
  Currently supports VOLUMES, DBFS & WORKSPACE types per
  databricks.internal.io.FileSystemType.
 
  If using DBFS this method will not work if there exists a file (not a 
  directory) at any prefix of the path.
 
  Example:
    io = databricks.internal.io.IO;
    tf = io.mkdir("/Volumes/main/default/myvolume/myDir");
```

#### databricks.internal.io.IO.stripTrailingSlashes

```text
STRIPTRAILINGSLASHES Strips redundant trailing slashes from paths
 
  Example:
    path = databricks.internal.io.IO.stripTrailingSlashes("/Volumes/main/default/mydir///");
```

#### databricks.internal.io.IO.upload

```text
UPLOAD Filesystem type agnostic file uploader
  Currently supports DBFS, VOLUMES and WORKSPACE type per
  databricks.internal.io.FileSystemType.
 
  The source should be a file.
  The destination should be an absolute file path, and not a directory.
 
  Volumes, Workspaces and DBFS are supported.
  DBFS is deprecated and not recommended.
 
  Example:
    io = databricks.internal.io.IO();
    io.upload(sourcePathVar, destinationPathVar, overwrite=true, verbose=false);
```

### databricks.internal.job

### databricks.internal.job.runNotebookJob

```text
RUNNOTEBOOKJOB Creates and runs a Job to run a Notebook
  If a cluster ID is given that cluster will be used, if not
  if a cluster ID is set via credentials it will be used, otherwise
  a cluster will be created.
  Permission to create a new cluster is required if an existing cluster
  is not used.
 
 
  Required named argument:
       notebook : Full path and name of the notebook to run, including the
                  username where appropriate.
 
  Optional named arguments:
      clusterId : ID of an existing cluster, if not provided a value will be
                  taken from the credentials file if available and otherwise
                  a cluster will be created.
 
           name : Name for notebook job.
 
    autoterminationMinutes : Number of minutes after which a created
                             cluster will auto terminate, default is 60
 
     numWorkers : Number of worker nodes to create, default 0, i.e.
                  single node cluster
 
     authMethod : A matlab.databricks.AuthMethod
 
    profileName : A configuration file profileName value
 
  The job's Job ID and Run ID are returned as int64s.
  The run's status can be queried as follows:
       r = databricks.Run;
       result = r.get(runId);
       result.state
       ans =
         struct with fields:
           life_cycle_state: 'TERMINATED'
               result_state: 'SUCCESS'
              state_message: ''
```

### databricks.internal.job.waitForJob

```text
WAITFORJOB Wait for a job to complete
 
  JobId argument is required and should be of type int64.
 
  An optional timeout named argument can be provided.
  The timeout value is measured in seconds and should be of type int32.
  The default timeout is one hour. If the timeout is exceeded an error is
  thrown.
 
  Possible Job run life_cycle_state values are:
    PENDING
    The run has been triggered. If there is not already an active run of the
    same job, the cluster and execution context are being prepared. If there
    is already an active run of the same job, the run will immediately
    transition into the SKIPPED state without preparing any resources.
   
    RUNNING
    The task of this run is being executed.
   
    TERMINATING
    The task of this run has completed, and the cluster and execution context
    are being cleaned up.
   
    TERMINATED
    The task of this run has completed, and the cluster and execution context
    have been cleaned up. This state is terminal.
   
    SKIPPED
    This run was aborted because a previous run of the same job was already
    active. This state is terminal.
   
    INTERNAL_ERROR
    An exceptional state that indicates a failure in the Jobs service, such
    as network failure over a long period. If a run on a new cluster ends in
    the INTERNAL_ERROR state, the Jobs service terminates the cluster as soon
    as possible. This state is terminal.
 
  The optional named argument targetState can be set to "RUNNING" or "SUCCESS".
  The default is RUNNING. If set to RUNNING the function returns  when the job
  enters a RUNNING state or successfully terminates. When set to SUCCESS the
  function returns only on successfully termination.
  
  Other states are handled as follows:
 
  If the TERMINATING, SKIPPED or INTERNAL_ERROR states are entered an error is
  thrown.
 
  If TERMINATED with result_state not equal to SUCCESS is entered and error is
  thrown.
 
  If PENDING is entered the function waits for a state change or until the time out.
 
  Example:
    databricks.internal.job.waitForJob(jobId, targetState="SUCCESS");
```

### databricks.internal.mlRuntime

### databricks.internal.mlRuntime.getLatestJavabuilder

```text
GETLATESTJAVABUILDER Returns the latest javabuilder jar for a given release
  If no matching file is found an empty string is returned.
```

### databricks.internal.mlRuntime.getLatestRuntime

```text
GETLATESTRUNTIME Returns the most recent release for a given release
  If a release is not specified the current release is used.
  A release should be specified in the form R2024a
  A runtimes directory may be specified otherwise
  databricks-settings.json:interfaceDirectory/runtimes/ is used.
  Only volumes /Volumes/ paths are supported.
  If no match is found or the directory does not exist an empty
  string is returned.
```

### databricks.internal.mlRuntime.getMATLABRuntimeDownloadURL

```text
getMATLABRuntimeDownloadURL Get a download URL for the MATLAB runtime
  The runtime is returned as a string.
  If it cannot be determined and empty string is returned.
  Only the Linux URL is returned.
  If a specific MATLAB release is provided and a value cannot be found in the
  cluster_install.json file an empty string will be returned.
  If a release is not specified the current release will be used. If it cannot
  be found in the cluster_install.json file a dynamically determined value will
  be used. If this is not possible an empty string is returned.
 
  Optional arguments:
            release: A string of the form: R2023b
                     The default is the currently running release
 
             silent: A logical to reduce output
                     The default value is false
 
    useSettingsFile: A logical to use the cluster_install.json if possible
                     The default value is true
                     Using false can useful in certain debug scenarios
                     to get a more recent update
 
  See also: https://www.mathworks.com/products/compiler/matlab-runtime.html
```

### databricks.internal.mlRuntime.runtimeExists

```text
runtimeExists Returns true if runtime for a given URL exists on DBFS
```

### databricks.internal.mlRuntime.runtimeReleaseExists

```text
RUNTIMERELEASEEXISTS Returns true if a runtime .zip for a given release is found
  Otherwise false is returned.
```

### databricks.internal.run

### databricks.internal.run.waitForRunStatus

```text
waitForRunStatus Wait for job lifecycle to end and reports status
```

### databricks.internal.runjobs

### databricks.internal.runjobs.Job

Superclass: handle

```text
Job A class for handling testing of Jobs
```

#### databricks.internal.runjobs.Job.Job

```text
Job A class for handling testing of Jobs

    Documentation for databricks.internal.runjobs.Job
```

#### databricks.internal.runjobs.Job.buildArtifact

```text
buildArtifact Builds the Jar/Wheel artifact
 
  Will iterate over an array of objects if necessary.
```

#### databricks.internal.runjobs.Job.getDBFSFolders

```text
databricks.internal.runjobs.Job/getDBFSFolders is a function.
    folders = getDBFSFolders(obj)
```

#### databricks.internal.runjobs.Job.getDescription

```text
getDescription Returns a description, primarily for jobs
```

#### databricks.internal.runjobs.Job.getLibType

```text
getLibType Returns the lib type for use with tasks
```

#### databricks.internal.runjobs.Job.getNumNotebooks

```text
getNumNotebooks Count notebooks in a job array
```

#### databricks.internal.runjobs.Job.getSuffix

```text
databricks.internal.runjobs.Job/getSuffix is a function.
    suffix = getSuffix(obj)
```

#### databricks.internal.runjobs.Job.getUniqueName

```text
getUniqueName Returns a unique ID, used for task dependencies
```

#### databricks.internal.runjobs.Job.getWorkspaceName

```text
databricks.internal.runjobs.Job/getWorkspaceName is a function.
    workspaceName = getWorkspaceName(obj)
    workspaceName = getWorkspaceName(___, Name, Value)
```

#### databricks.internal.runjobs.Job.isPython

```text
databricks.internal.runjobs.Job/isPython is a function.
    tf = isPython(obj)
```

#### databricks.internal.runjobs.Job.isScala

```text
databricks.internal.runjobs.Job/isScala is a function.
    tf = isScala(obj)
```

#### databricks.internal.runjobs.Job.table

```text
table Utility to display jobs in a table
```

#### databricks.internal.runjobs.Job.uploadArtifact

```text
uploadArtifact Uploads an artifact to DBFS
 
  Will iterate over an array of objects if necessary.
```

#### databricks.internal.runjobs.Job.uploadNotebook

```text
uploadNotebook Uploads a notebook to Databricks Workspace
 
  Will iterate over an array of objects if necessary.
```

### databricks.internal.runjobs.JobTester

Superclass: handle

```text
JobTester A class for handling testing of several
```

#### databricks.internal.runjobs.JobTester.JobTester

```text
JobTester A class for handling testing of several

    Documentation for databricks.internal.runjobs.JobTester
```

#### databricks.internal.runjobs.JobTester.buildAndUploadJobs

```text
buildAndUploadJobs Do the build of the underlying jobs
```

#### databricks.internal.runjobs.JobTester.buildArtifacts

```text
buildArtifacts Build artifacts and store them locally
```

#### databricks.internal.runjobs.JobTester.createJobs

```text
createJobs Create the Job array
```

#### databricks.internal.runjobs.JobTester.createTasksJob

```text
createTasksJob
```

#### databricks.internal.runjobs.JobTester.deployJobs

```text
deployJobs Build, upload and start task
```

#### databricks.internal.runjobs.JobTester.getJobName

```text
getJobName The name to be used by a specific Task Job
 
  The name will have a setting related either to today's date, or a
  gitlab pipeline number.
```

#### databricks.internal.runjobs.JobTester.getOrCreateInstance

```text
getOrCreateInstance Utility method for testing
 
  If a version is loaded, it may still change the prefix for this
  object (not on disk). This is to make it easier to create different
  tests, e.g. dockerized and init-script-based tests.
```

#### databricks.internal.runjobs.JobTester.isEnabled

```text
isEnabled Returns true/false if job is enabled/disabled
 
  The entry "Enabled" in the jobInfo struct can either be a boolean or
  a string. If it's a boolean, return the corresponding value.
 
  If it's a string, it should evaluate to a function or method that can
  be run. Return the result of executing this function.
 
  If there's no "Enabled" entry, return true (default).
```

#### databricks.internal.runjobs.JobTester.saveMatFile

```text
databricks.internal.runjobs.JobTester/saveMatFile is a function.
    saveMatFile(obj)
```

#### databricks.internal.runjobs.JobTester.saveTarFile

```text
databricks.internal.runjobs.JobTester/saveTarFile is a function.
    saveTarFile(obj)
```

#### databricks.internal.runjobs.JobTester.slCompilerEnabled

```text
slCompilerEnabled Decide if SL Compiler can be used here
```

#### databricks.internal.runjobs.JobTester.staticBuildArtifacts

```text
staticBuildArtifacts Build artifacts and store them locally
  A static version of the class/object method
  
  This functions takes a few optional arguments
   paths - The directories where test files are found
   prefix - Just an addition to the name of the job
   runtime - A string that determines where artifacts are saved. 
 
  The last option is called runtime, because there is a difference in
  created artifacts for different runtimes. Typically, runtime will
  take values related to Databricks runtimes, e.g. 10.4, 13.3, etc.
```

#### databricks.internal.runjobs.JobTester.staticDeployPrebuiltJobs

```text
staticDeployPrebuiltJobs Upload artifacts/notebooks and start task
 
  This is a static method that relies on saved artifacts
```

#### databricks.internal.runjobs.JobTester.staticLoadFromMat

```text
staticLoadFromMat Load previously built version
```

#### databricks.internal.runjobs.JobTester.staticVerifyResults

```text
staticVerifyResults Verify the results of the job runs
  
  If the jobs failed, this function should exit with an error, as the
  process exit status is needed in the CI/CD pipeline.
 
  Job run life_cycle_state values:
  PENDING
  The run has been triggered. If there is not already an active run of the
  same job, the cluster and execution context are being prepared. If there
  is already an active run of the same job, the run will immediately
  transition into the SKIPPED state without preparing any resources.
 
  RUNNING
  The task of this run is being executed.
 
  TERMINATING
  The task of this run has completed, and the cluster and execution context
  are being cleaned up.
 
  TERMINATED
  The task of this run has completed, and the cluster and execution context
  have been cleaned up. This state is terminal.
 
  SKIPPED
  This run was aborted because a previous run of the same job was already
  active. This state is terminal.
 
  INTERNAL_ERROR
  An exceptional state that indicates a failure in the Jobs service, such
  as network failure over a long period. If a run on a new cluster ends in
  the INTERNAL_ERROR state, the Jobs service terminates the cluster as soon
  as possible. This state is terminal.
  
  Typical values for the optional arguments:
   prefix - "base", "docker", etc.
   runtime - "10.4", "13.3", "13.3-R2023b"
   timeout - 100 (time in seconds)
```

#### databricks.internal.runjobs.JobTester.uploadArtifactsAndNotebooks

```text
uploadArtifactsAndNotebooks Upload artifacts/notebooks
```

#### databricks.internal.runjobs.JobTester.verifyResults

```text
verifyResults Verify the results of the job runs
```

### databricks.internal.runjobs.Notebook

Superclass: handle

```text
Notebook JobTester notebook helper class
```

#### databricks.internal.runjobs.Notebook.Notebook

```text
Notebook JobTester notebook helper class

    Documentation for databricks.internal.runjobs.Notebook
```

#### databricks.internal.runjobs.Notebook.getDescription

```text
databricks.internal.runjobs.Notebook/getDescription is a function.
    desc = getDescription(obj)
```

#### databricks.internal.runjobs.Notebook.getLocalArtifactLocation

```text
databricks.internal.runjobs.Notebook/getLocalArtifactLocation is a function.
    artifactLocation = getLocalArtifactLocation(obj)
```

#### databricks.internal.runjobs.Notebook.getNotebookTaskData

```text
getNotebookTaskData Retrieve data necessary for a notebook job
```

#### databricks.internal.runjobs.Notebook.getSuffix

```text
databricks.internal.runjobs.Notebook/getSuffix is a function.
    suffix = getSuffix(obj)
```

#### databricks.internal.runjobs.Notebook.getUniqueName

```text
getUniqueName Returns a unique ID, used for task dependencies
```

#### databricks.internal.runjobs.Notebook.getWorkspaceName

```text
databricks.internal.runjobs.Notebook/getWorkspaceName is a function.
    workspaceName = getWorkspaceName(obj)
```

#### databricks.internal.runjobs.Notebook.saveArtifacts

```text
saveArtifacts Save artifacts to local folder
```

#### databricks.internal.runjobs.Notebook.uploadNotebook

```text
uploadNotebook Upload the notebook to the server
```

### databricks.internal.scope

### databricks.internal.scope.exists

```text
EXISTS Returns true if a scope exists otherwise false
```

### databricks.internal.sdk

### databricks.internal.sdk.core

### databricks.internal.sdk.core.Config

Superclass: handle

```text
CONFIG Configuration class for Databricks Python SDK
 
  Example:
    cfg = databricks.internal.sdk.core.Config();
 
  See also (Python): >>> help('databricks.sdk.core.Config')
```

#### databricks.internal.sdk.core.Config.Config

```text
CONFIG Constructor for databricks.internal.sdk.core.Config class

    Documentation for databricks.internal.sdk.core.Config
```

#### databricks.internal.sdk.core.Config.OauthToken

```text
OauthToken Returns the OAuth token from the current credential provider
  Returns a databricks.sdk.oauth.Token.
 
  This method only works when using OAuth-based authentication methods.
  If the current credential provider is an OAuthCredentialsProvider, it reuses
  the existing provider. Otherwise, it raises a ValueError indicating that
  OAuth tokens are not available for the current authentication method.
```

#### databricks.internal.sdk.core.Config.authenticate

```text
databricks.internal.sdk.core.Config/authenticate is a function.
    authHeaders = authenticate(obj)
```

#### databricks.internal.sdk.core.Config.configureAuth

```text
APPLYSETTINGSANDCONFIGURATION Apply settings and configuration options
  Looks at the .databrickscfg file and databricks-settings.json files
  to configure the Config object with the appropriate values.
 
  Optional named arguments:
     useSDKAuth: Use SDK authentication, default: false
    profileName: Profile name from .databrickscfg, default: "DEFAULT"
     authMethod: Authentication method, type: matlab.databricks.AuthMethod
        verbose: Enable additional output, default: true
```

#### databricks.internal.sdk.core.Config.debugString

```text
DEBUGSTRING Get debug string representation of config
```

#### databricks.internal.sdk.core.Config.getAuthCfgMap

```text
GETAUTHCFGMAP Get authentication configuration as a container.Map
 
  Example:
     cm = databricks.internal.sdk.core.Config.getAuthCfgMap(authMethod=matlab.databricks.AuthMethod.PAT, profileName="DEFAULT");
```

#### databricks.internal.sdk.core.Config.getAuthTypeCfgField

```text
GET_AUTH_TYPE_FIELD Get the auth_type field from the .databrickscfg file
  Returns an empty string if the field is not found or the profile does not exist.
  A source value is also returned indicating where the auth_type was found.
 
  Example:
     [auth_type, source] = databricks.internal.sdk.core.Config.getAuthCfgDict.getAuthTypeCfgField()
```

#### databricks.internal.sdk.core.Config.initAuth

```text
databricks.internal.sdk.core.Config/initAuth is a function.
    initAuth(obj)
```

#### databricks.internal.sdk.core.Config.sdkAuth

```text
SDKAUTH Configure authentication using SDK-based authentication
```

#### databricks.internal.sdk.core.Config.toPy

```text
TOPY Convert to Python object
  Returns the Python object representation of this Config
```

### databricks.internal.sdk.core.ConfigImpl

Superclass: handle

```text
CONFIGIMPL Configuration class for Databricks Python SDK
 
  Example:
    cfg = databricks.internal.sdk.core.ConfigImpl();
 
  See also (Python): >>> help('databricks.sdk.core.Config')
```

#### databricks.internal.sdk.core.ConfigImpl.ConfigImpl

```text
CONFIGIMPL Constructor for databricks.internal.sdk.core.ConfigImpl class

    Documentation for databricks.internal.sdk.core.ConfigImpl
```

#### databricks.internal.sdk.core.ConfigImpl.OauthToken

```text
OauthToken Returns the OAuth token from the current credential provider
  Returns a databricks.sdk.oauth.Token.
 
  This method only works when using OAuth-based authentication methods.
  If the current credential provider is an OAuthCredentialsProvider, it reuses
  the existing provider. Otherwise, it raises a ValueError indicating that
  OAuth tokens are not available for the current authentication method.
```

#### databricks.internal.sdk.core.ConfigImpl.authenticate

```text
databricks.internal.sdk.core.ConfigImpl/authenticate is a function.
    authHeaders = authenticate(obj)
```

#### databricks.internal.sdk.core.ConfigImpl.configureAuth

```text
CONFIGUREAUTH Apply settings and configuration options
  Looks at the .databrickscfg file and databricks-settings.json files
  to configure the Config object with the appropriate values.
 
  Optional named arguments:
     useSDKAuth: Use SDK authentication, default: false
    profileName: Profile name from .databrickscfg, default: "DEFAULT"
     authMethod: Authentication method, type: matlab.internal.databricks.AuthMethod
        verbose: Enable additional output, default: true
```

#### databricks.internal.sdk.core.ConfigImpl.debugString

```text
DEBUGSTRING Get debug string representation of config
```

#### databricks.internal.sdk.core.ConfigImpl.getAuthCfgMap

```text
GETAUTHCFGMAP Get authentication configuration as a container.Map
 
  Example:
     cm = databricks.internal.sdk.core.ConfigImpl.getAuthCfgMap(authMethod=matlab.internal.databricks.AuthMethod.PAT, profileName="DEFAULT");
```

#### databricks.internal.sdk.core.ConfigImpl.getAuthTypeCfgField

```text
GETAUTHTYPECFGFIELD Get the auth_type field from the .databrickscfg file
  Returns an empty string if the field is not found or the profile does not exist.
  A source value is also returned indicating where the auth_type was found.
 
  Example:
     [auth_type, source] = databricks.internal.sdk.core.ConfigImpl.getAuthCfgDict.getAuthTypeCfgField()
```

#### databricks.internal.sdk.core.ConfigImpl.initAuth

```text
databricks.internal.sdk.core.ConfigImpl/initAuth is a function.
    initAuth(obj)
```

#### databricks.internal.sdk.core.ConfigImpl.sdkAuth

```text
SDKAUTH Configure authentication using SDK-based authentication
```

#### databricks.internal.sdk.core.ConfigImpl.toPy

```text
TOPY Convert to Python object
  Returns the Python object representation of this Config
```

### databricks.internal.sdk.UserAgent

Superclass: handle

```text
USERAGENT User Agent class for Databricks SDK
 
  Example:
    ua = databricks.internal.sdk.UserAgent();
 
  See also: https://github.com/databricks/databricks-sdk-py#user-agent-request-attribution
```

#### databricks.internal.sdk.UserAgent.UserAgent

```text
USERAGENT Constructor for UserAgent class

    Documentation for databricks.internal.sdk.UserAgent
```

#### databricks.internal.sdk.UserAgent.toPy

```text
TOPY Convert UserAgent object to Python user agent object
```

#### databricks.internal.sdk.UserAgent.withPartner

```text
WITHPARTNER Set the partner for the User Agent
```

#### databricks.internal.sdk.UserAgent.withProduct

```text
WITHPRODUCT Set the product and version for the User Agent
```

### databricks.internal.sdk.UserAgentImpl

Superclass: handle

```text
USERAGENTIMPL User Agent class for Databricks SDK
 
  Example:
    ua = databricks.internal.sdk.UserAgentImpl();
 
  See also: https://github.com/databricks/databricks-sdk-py#user-agent-request-attribution
```

#### databricks.internal.sdk.UserAgentImpl.UserAgentImpl

```text
USERAGENT Constructor for UserAgentImpl class

    Documentation for databricks.internal.sdk.UserAgentImpl
```

#### databricks.internal.sdk.UserAgentImpl.toPy

```text
TOPY Convert UserAgent object to Python user agent object
```

#### databricks.internal.sdk.UserAgentImpl.withPartner

```text
WITHPARTNER Set the partner for the User Agent
```

#### databricks.internal.sdk.UserAgentImpl.withProduct

```text
WITHPRODUCT Set the product and version for the User Agent
```

### databricks.internal.secret

### databricks.internal.secret.create

```text
CREATE Create a secret value, e.g. auth tokens
  The Scope and Secret are persistent and do not need to be recreated unless deleted.
  or the token expires. If the scope does not exist it is created.
  If the secret exists it is overwritten.
  The scope's initialManagePrincipal can be optionally specified and defaults
  to "users".
```

### databricks.internal.settings

### databricks.internal.settings.Settings

```text
Settings Container class for Settings related functionality
  Settings are stored in the databricks-settings.json file
  For more details see: Documentation/Setup.md, Documentation/Authentication.md
```

#### databricks.internal.settings.Settings.Settings

```text
Settings Container class for Settings related functionality
  Settings are stored in the databricks-settings.json file
  For more details see: Documentation/Setup.md, Documentation/Authentication.md

    Documentation for databricks.internal.settings.Settings
```

#### databricks.internal.settings.Settings.editUserSettings

```text
databricks.internal.settings.Settings.editUserSettings is a function.
    editUserSettings
    editUserSettings(Name, Value)
```

#### databricks.internal.settings.Settings.getDefaultSettingsFilePath

```text
defaultSettingsFilePath Returns the default path for the Databricks settings file
  The current name for the file is databricks-settings.json
  The current default directory is given by the prefdir command.
  The value is returned as a character vector.
  To get the path to write settings to use: getSettingsFileWritePath
```

#### databricks.internal.settings.Settings.getSettingsField

```text
getSettingsField Returns a field from user settings if it exists
  If it does not exist an empty string is returned.
  Otherwise the settings field is returned.
  Environment overrides variable will be applied by default.
  The optional enableEnvVarOverrides flag can be set to false to disable this.
  An authMethod field is returned as a matlab.internal.databricks.AuthMethod
 
  Example:
    vendor = databricks.internal.settings.Settings.getSettingsField("vendor");
 
  If a settings struct is provided it is used rather than reading a file and or
  environment variables.
```

#### databricks.internal.settings.Settings.getSettingsFileReadPath

```text
getSettingsFilePath Returns the path to the the Databricks settings file
  First the environment variable DATABRICKS_SETTINGS_FILE is checked,
  then the default location (prefdir) and then the MATLAB path as defined
  by the exist() command.
  The value is returned as a character vector.
  If the file is not found an empty character vector is returned.
  To get the path to write settings to use: getSettingsFileWritePath
 
  Example
    path = databricks.internal.settings.Settings.getSettingsFileReadPath()
```

#### databricks.internal.settings.Settings.getSettingsFileWritePath

```text
getSettingsFileWritePath Returns the default path to write Databricks settings file to
  The current default name for the file is databricks-settings.json and
  the current default directory is given by the prefdir command
  unless the DATABRICKS_SETTINGS_FILE is defined.
  The value is returned as a character vector.
```

#### databricks.internal.settings.Settings.getSettingsStruct

```text
getSettings Retrieve user settings from settings file
  The logical enableEnvVarOverrides (true by default) enables the overrides:
    DATABRICKS_VENDOR overrides vendor
    DATABRICKS_CONFIG_PROFILE overrides profileName
 
  The default settings file path is given by databricks.internal.settings.Settings.getSettingsFileReadPath
  A struct is returned.
 
  Example:
    settings = databricks.internal.settings.Settings.getSettingsStruct()
```

#### databricks.internal.settings.Settings.setSettingsFieldFromEnvironment

```text
setSettingsFieldFromEnvironment Override a settings field with an environment variable if set
  If the environment variable is not set the input struct is returned unchanged
  Fields are returned as scalar strings.
```

#### databricks.internal.settings.Settings.writeDatabricksSettingsFields

```text
writeDatabricksSettingsFields Writes a databricks-settings.json file
  Default output location is given by databricks.internal.settings.Settings.getSettingsFileReadPath
  As is first reads existing values
  Existing values not overridden by optional arguments are retained.
  Overwrite of an existing file by default can be disabled.
  By default environment variable overrides are applied this can be
  disabled using enableEnvVarOverrides
 
  The follow fields can be set using optional arguments:
    autotermination_minutes
    vendor
    username
    notificationEmail
    authMethod
    profileName
    interfaceDirectory
    defaultDatabricksRuntime
 
  True is returned if the operation completes otherwise false.
```

#### databricks.internal.settings.Settings.writeSettingsStruct

```text
writeSettingsStruct Writes a struct of settings to a databricks-settings.json file
  If the file exists and the overwrite flag is not set false is
  returned.
  If the file cannot be written otherwise an error is thrown.
  This function will overwrite all existing settings values.
  The default file path is given by databricks.internal.settings.Settings.getSettingsFileWritePath.
 
  Example:
    s = struct;
    s.username='someuser@example.com';
    s.notificationEmail='notificationAddress@example.com';
    tf = databricks.internal.settings.Settings.writeSettingsStruct(s, overwrite=true);
```

### databricks.internal.statementexecution

### databricks.internal.statementexecution.executeStatement

```text
executeStatement High-level interface to the statement execution API
 
  Example:
    statement = "SELECT * FROM main.default.mytable LIMIT 1000";
    disposition = databricks.statementexecution.models.Disposition.EXTERNAL_LINKS;
    [result, status, statementId, T] = databricks.internal.statementexecution.executeStatement(statement, warehouseId, disposition=disposition, format="CSV")
 
  Note: MATLAB Table population not yet implemented for format type: JSON_ARRAY or ARROW_   STREAM.
        Contact: databricks@mathworks.com
 
  See also: https://docs.databricks.com/api/workspace/statementexecution
```

### databricks.internal.statementexecution.executeStatementResponse2Table

```text
executeStatementResponse2Table Convert an INLINE table response to a MATLAB table
```

### databricks.internal.token

### databricks.internal.token.isTokenValid

```text
isTokenValid Returns true if the REST API can do Cluster.list
```

### databricks.internal.unifiedauthentication

### databricks.internal.unifiedauthentication.DotDatabricksConnect

Superclass: databricks.Object

```text
DotDatabricksConnect Container class for .databricks-connect file related functionality
```

#### databricks.internal.unifiedauthentication.DotDatabricksConnect.DotDatabricksConnect

```text
Constructor

    Documentation for databricks.internal.unifiedauthentication.DotDatabricksConnect
```

#### databricks.internal.unifiedauthentication.DotDatabricksConnect.getDBCCfgField

```text
databricks.internal.unifiedauthentication.DotDatabricksConnect.getDBCCfgField is a function.
    value = getDBCCfgField(fieldName)
    value = getDBCCfgField(___, Name, Value)
```

#### databricks.internal.unifiedauthentication.DotDatabricksConnect.getDBCCfgStruct

```text
databricks.internal.unifiedauthentication.DotDatabricksConnect.getDBCCfgStruct is a function.
    dbcCfg = getDBCCfgStruct
    dbcCfg = getDBCCfgStruct(Name, Value)
```

#### databricks.internal.unifiedauthentication.DotDatabricksConnect.getDBCFilePath

```text
databricks.internal.unifiedauthentication.DotDatabricksConnect.getDBCFilePath is a function.
    dbcFile = databricks.internal.unifiedauthentication.DotDatabricksConnect.getDBCFilePath
```

#### databricks.internal.unifiedauthentication.DotDatabricksConnect.initialize

```text
INITIALIZE Method to initialize the configuration
  Find the .databricks-connect if one exists
```

#### databricks.internal.unifiedauthentication.DotDatabricksConnect.inputProperty

```text
inputProperty Ask for property value, set default otherwise
```

#### databricks.internal.unifiedauthentication.DotDatabricksConnect.isDotDatabricksConnect

```text
isDotDatabricksConnect Returns true if a .databricks-connect format file is present
 
  Example:
    [tf, filepath] = databricks.internal.unifiedauthentication.DotDatabricksConnect.isDotDatabricksConnect
```

#### databricks.internal.unifiedauthentication.DotDatabricksConnect.setCfgFieldFromEnvironment

```text
setCfgFieldFromEnvironment Override a configuration field with an environment variable if set
  If the environment variable is not set the input struct is returned unchanged
  Fields are returned as scalar strings.
```

#### databricks.internal.unifiedauthentication.DotDatabricksConnect.setProperty

```text
Check if this is a property and if not add it
```

#### databricks.internal.unifiedauthentication.DotDatabricksConnect.writeDBCCfgFields

```text
writeDBCCfgFields Write a Databricks Connect configuration file in JSON format
```

#### databricks.internal.unifiedauthentication.DotDatabricksConnect.writeDBCCfgFile

```text
writeDBCCfgFile Write a Databricks Connect configuration file in JSON format
```

### databricks.internal.unifiedauthentication.Oauth

```text
OAUTH Container class for U2M & M2M Oauth related functionality
  Delegates to databricks.internal.unifiedauthentication.OauthImpl
```

#### databricks.internal.unifiedauthentication.Oauth.Oauth

```text
OAUTH Container class for U2M & M2M Oauth related functionality
  Delegates to databricks.internal.unifiedauthentication.OauthImpl

    Documentation for databricks.internal.unifiedauthentication.Oauth
```

#### databricks.internal.unifiedauthentication.Oauth.epochSecondsUTCNow

```text
epochSecondsUTCNow Return epoch time in UTC in seconds as a string and an int64
```

#### databricks.internal.unifiedauthentication.Oauth.genVerifierChallenge

```text
genVerifierChallenge Generate verifier and challenge values of U2M auth
  See: https://docs.databricks.com/en/dev-tools/auth/oauth-u2m.html#language-Profile
```

#### databricks.internal.unifiedauthentication.Oauth.getCachedAccessTokenJWT

```text
databricks.internal.unifiedauthentication.Oauth.getCachedAccessTokenJWT is a function.
    tokenJWT = databricks.internal.unifiedauthentication.Oauth.getCachedAccessTokenJWT(varargin)
```

#### databricks.internal.unifiedauthentication.Oauth.getCachedAccessTokenString

```text
databricks.internal.unifiedauthentication.Oauth.getCachedAccessTokenString is a function.
    tokenString = databricks.internal.unifiedauthentication.Oauth.getCachedAccessTokenString(varargin)
```

#### databricks.internal.unifiedauthentication.Oauth.getCachedValue

```text
getCachedValue Returns a cached token indexed by host field name and auth method
  If caching of tokens is disabled using DISABLE_DATABRICKS_TOKEN_CACHE all
  calls silently return string.empty.
```

#### databricks.internal.unifiedauthentication.Oauth.getDefaultCacheFilePath

```text
databricks.internal.unifiedauthentication.Oauth.getDefaultCacheFilePath is a function.
    cacheFilePath = databricks.internal.unifiedauthentication.Oauth.getDefaultCacheFilePath(authMethod)
```

#### databricks.internal.unifiedauthentication.Oauth.getM2MToken

```text
getM2MToken Gets a structure containing the Oauth token
```

#### databricks.internal.unifiedauthentication.Oauth.getRefreshedToken

```text
databricks.internal.unifiedauthentication.Oauth.getRefreshedToken is a function.
    [tokenStruct, response] = databricks.internal.unifiedauthentication.Oauth.getRefreshedToken(varargin)
```

#### databricks.internal.unifiedauthentication.Oauth.getU2MToken

```text
getU2MToken Gets a structure containing the Oauth token
```

#### databricks.internal.unifiedauthentication.Oauth.getWSAuthCode

```text
getWSAuthCode Use a challenge code to generate an authorization code
  Requires user interaction with a browser.
  Used by U2M auth
  See: https://docs.databricks.com/en/dev-tools/auth/oauth-u2m.html#language-Profile
```

#### databricks.internal.unifiedauthentication.Oauth.isTokenCachingDisabled

```text
isTokenCachingDisabled Return true if DISABLE_DATABRICKS_TOKEN_CACHE is true otherwise false
  Testing of DISABLE_DATABRICKS_TOKEN_CACHE is not case sensitive.
```

#### databricks.internal.unifiedauthentication.Oauth.missingFieldWarning

```text
databricks.internal.unifiedauthentication.Oauth.missingFieldWarning is a function.
    databricks.internal.unifiedauthentication.Oauth.missingFieldWarning(varargin)
```

#### databricks.internal.unifiedauthentication.Oauth.oauthM2MAuth

```text
databricks.internal.unifiedauthentication.Oauth.oauthM2MAuth is a function.
    tokenValue = databricks.internal.unifiedauthentication.Oauth.oauthM2MAuth(varargin)
```

#### databricks.internal.unifiedauthentication.Oauth.oauthU2MAuth

```text
databricks.internal.unifiedauthentication.Oauth.oauthU2MAuth is a function.
    tokenValue = databricks.internal.unifiedauthentication.Oauth.oauthU2MAuth(varargin)
```

#### databricks.internal.unifiedauthentication.Oauth.writeTokenCache

```text
databricks.internal.unifiedauthentication.Oauth.writeTokenCache is a function.
    databricks.internal.unifiedauthentication.Oauth.writeTokenCache(varargin)
```

### databricks.internal.unifiedauthentication.OauthImpl

```text
OAUTHIMPL Container class for U2M & M2M Oauth related functionality
```

#### databricks.internal.unifiedauthentication.OauthImpl.OauthImpl

```text
OAUTHIMPL Container class for U2M & M2M Oauth related functionality

    Documentation for databricks.internal.unifiedauthentication.OauthImpl
```

#### databricks.internal.unifiedauthentication.OauthImpl.epochSecondsUTCNow

```text
epochSecondsUTCNow Return epoch time in UTC in seconds as a string and an int64
```

#### databricks.internal.unifiedauthentication.OauthImpl.genVerifierChallenge

```text
genVerifierChallenge Generate verifier and challenge values of U2M auth
  See: https://docs.databricks.com/en/dev-tools/auth/oauth-u2m.html#language-Profile
```

#### databricks.internal.unifiedauthentication.OauthImpl.getCachedValue

```text
getCachedValue Returns a cached token indexed by host field name and auth method
  If caching of tokens is disabled using DISABLE_DATABRICKS_TOKEN_CACHE all
  calls silently return string.empty.
```

#### databricks.internal.unifiedauthentication.OauthImpl.getDefaultCacheFilePath

```text
databricks.internal.unifiedauthentication.OauthImpl.getDefaultCacheFilePath is a function.
    cacheFilePath = getDefaultCacheFilePath(authMethod)
```

#### databricks.internal.unifiedauthentication.OauthImpl.getM2MToken

```text
getM2MToken Gets a structure containing the Oauth token
```

#### databricks.internal.unifiedauthentication.OauthImpl.getRefreshedToken

```text
databricks.internal.unifiedauthentication.OauthImpl.getRefreshedToken is a function.
    tokenStruct = getRefreshedToken(host, refreshToken)
    tokenStruct = getRefreshedToken(___, Name, Value)
    [tokenStruct, response] = getRefreshedToken(___)
```

#### databricks.internal.unifiedauthentication.OauthImpl.getU2MToken

```text
getU2MToken Gets a structure containing the Oauth token
```

#### databricks.internal.unifiedauthentication.OauthImpl.getWSAuthCode

```text
getWSAuthCode Use a challenge code to generate an authorization code
  Requires user interaction with a browser.
  Used by U2M auth
  See: https://docs.databricks.com/en/dev-tools/auth/oauth-u2m.html#language-Profile
```

#### databricks.internal.unifiedauthentication.OauthImpl.isTokenCachingDisabled

```text
isTokenCachingDisabled Return true if DISABLE_DATABRICKS_TOKEN_CACHE is true otherwise false
  Testing of DISABLE_DATABRICKS_TOKEN_CACHE is not case sensitive.
```

#### databricks.internal.unifiedauthentication.OauthImpl.missingFieldWarning

```text
databricks.internal.unifiedauthentication.OauthImpl.missingFieldWarning is a function.
    missingFieldWarning(s, fieldName)
```

#### databricks.internal.unifiedauthentication.OauthImpl.oauthM2MAuth

```text
databricks.internal.unifiedauthentication.OauthImpl.oauthM2MAuth is a function.
    tokenValue = oauthM2MAuth(host, clientId, clientSecret)
    tokenValue = oauthM2MAuth(___, Name, Value)
```

#### databricks.internal.unifiedauthentication.OauthImpl.oauthU2MAuth

```text
databricks.internal.unifiedauthentication.OauthImpl.oauthU2MAuth is a function.
    tokenValue = oauthU2MAuth(host)
    tokenValue = oauthU2MAuth(___, Name, Value)
```

#### databricks.internal.unifiedauthentication.OauthImpl.writeTokenCache

```text
writeTokenCache Caches a token indexed by host field name and auth method
  If caching of tokens is disabled using DISABLE_DATABRICKS_TOKEN_CACHE this
  function does nothing and returns.
```

### databricks.internal.unifiedauthentication.Provider

Superclass: handle

```text
Provider A class to handle configuration profiles
  Delegates to databricks.internal.unifiedauthentication.ProviderImpl
```

#### databricks.internal.unifiedauthentication.Provider.Provider

```text
Provider A provider chain to acquire authentication details.
  When the class is created it will first attempt to acquire authentication
  credentials and where necessary e.g.if using Oauth authenticate
  using them to acquire a token.
 
  Supported methods are defined by the matlab.databricks.AuthMethod
  enumeration. They are:
 
    PAT - Databricks personal access token authentication
 
    OauthM2M - OAuth machine-to-machine (M2M) authentication
 
    OauthU2M - OAuth user-to-machine (U2M) authentication
 
  The AuthMethod argument is specified as RequestedAuthMethod as Chain
  will result in an actual method to be used which will differ.
 
  If the Chain method is specified then methods are tried in the following
  order: PAT, OauthM2M and OauthU2M.
 
  Chain is used by default.
 
  The default profile name is given by databricks.internal.configurationprofile.ConfigFile.getDefaultProfileName
 
  Examples:
 
    % Use the default authentication method PAT with the DEFAULT profile
    p = databricks.internal.unifiedauthentication.Provider();
 
    % Invoke the provider chain with a profile named MYPROFILE
    p = databricks.internal.unifiedauthentication.Provider(...
        RequestedAuthMethod=matlab.databricks.AuthMethod.Chain,...
        profileName="MYPROFILE")

    Documentation for databricks.internal.unifiedauthentication.Provider
```

#### databricks.internal.unifiedauthentication.Provider.authenticate

```text
AUTHENTICATE Returns a valid token using a given auth method
  Otherwise false is returned.
  The Provider object's Authenticated field is set to the return value.
  The Provider object should first be populated.
```

#### databricks.internal.unifiedauthentication.Provider.chainPop

```text
databricks.internal.unifiedauthentication.Provider/chainPop is a function.
    [tf, actualAuthMethod] = chainPop(obj, varargin)
```

#### databricks.internal.unifiedauthentication.Provider.oauthM2MPop

```text
oauthM2MPop Populate a provider object for OAuth machine-to-machine (M2M) authentication
  Covers both workspace and account-level operations
  See also: https://docs.databricks.com/en/dev-tools/auth/oauth-m2m.html
```

#### databricks.internal.unifiedauthentication.Provider.oauthU2MPop

```text
oauthU2MPop Populate a provider object for OAuth user-to-machine based authentication
  Covers both workspace and account-level operations
  See also: https://docs.databricks.com/en/dev-tools/auth/oauth-u2m.html
```

#### databricks.internal.unifiedauthentication.Provider.patPop

```text
patPop Populate a provider object for Personal Access Token based authentication
  Environment variables are tried first then a named profile.
  If a profile name is not provided DEFAULT is used.
  See: https://docs.databricks.com/en/dev-tools/auth/pat.html#language-Environment
  Returns true if the provider can be populated fully.
  If the host and token are defined in the env vars then the .databrickscfg file will
  be ignored. Otherwise the .databrickscfg file is used to populate the provider object
  if it exists.
```

#### databricks.internal.unifiedauthentication.Provider.populate

```text
populate Populates the object properties used for authentication
  If chain based authentication has been requested then the population will be attempted
  in the order of the provider chain: PAT, OauthM2M and OauthU2M.
  This in turn defines which authentication method will be called.
  A requestedAuthMethod must be set.
  Returns a logical true if authentication values have been populated
  into the object and otherwise false.
```

### databricks.internal.unifiedauthentication.ProviderImpl

Superclass: handle

```text
ProviderImpl A class to handle configuration profiles
```

#### databricks.internal.unifiedauthentication.ProviderImpl.ProviderImpl

```text
Provider A provider chain to acquire authentication details.
  When the class is created it will first attempt to acquire authentication
  credentials and where necessary e.g.if using Oauth authenticate
  using them to acquire a token.
 
  Supported methods are defined by the matlab.internal.databricks.AuthMethod
  enumeration. They are:
 
    PAT - Databricks personal access token authentication
 
    OauthM2M - OAuth machine-to-machine (M2M) authentication
 
    OauthU2M - OAuth user-to-machine (U2M) authentication
 
  The AuthMethod argument is specified as RequestedAuthMethod as Chain
  will result in an actual method to be used which will differ.
 
  If the Chain method is specified then methods are tried in the following
  order: PAT, OauthM2M and OauthU2M.
 
  Chain is used by default.
 
  The default profile name is given by databricks.internal.configurationprofile.ConfigFile.getDefaultProfileName
 
  Examples:
 
    % Use the default authentication method PAT with the DEFAULT profile
    p = databricks.internal.unifiedauthentication.Provider();
 
    % Invoke the provider chain with a profile named MYPROFILE
    p = databricks.internal.unifiedauthentication.Provider(...
        RequestedAuthMethod=matlab.internal.databricks.AuthMethod.Chain,...
        profileName="MYPROFILE");

    Documentation for databricks.internal.unifiedauthentication.ProviderImpl
```

#### databricks.internal.unifiedauthentication.ProviderImpl.authenticate

```text
AUTHENTICATE Returns a valid token using a given auth method
  Otherwise false is returned.
  The Provider object's Authenticated field is set to the return value.
  The Provider object should first be populated.
```

#### databricks.internal.unifiedauthentication.ProviderImpl.chainPop

```text
CHAINPOP Attempts to populate provider in the order  PAT, OauthM2M, OauthU2M
```

#### databricks.internal.unifiedauthentication.ProviderImpl.oauthM2MPop

```text
oauthM2MPop Populate a provider object for OAuth machine-to-machine (M2M) authentication
  Covers both workspace and account-level operations
  See also: https://docs.databricks.com/en/dev-tools/auth/oauth-m2m.html
```

#### databricks.internal.unifiedauthentication.ProviderImpl.oauthU2MPop

```text
oauthU2MPop Populate a provider object for OAuth user-to-machine based authentication
  Covers both workspace and account-level operations
  See also: https://docs.databricks.com/en/dev-tools/auth/oauth-u2m.html
```

#### databricks.internal.unifiedauthentication.ProviderImpl.patPop

```text
patPop Populate a provider object for Personal Access Token based authentication
  Environment variables are tried first then a named profile.
  If a profile name is not provided DEFAULT is used.
  See: https://docs.databricks.com/en/dev-tools/auth/pat.html#language-Environment
  Returns true if the provider can be populated fully.
  If the host and token are defined in the env vars then the .databrickscfg file will
  be ignored. Otherwise the .databrickscfg file is used to populate the provider object
  if it exists.
```

#### databricks.internal.unifiedauthentication.ProviderImpl.populate

```text
populate Populates the object properties used for authentication
  If chain based authentication has been requested then the population will be attempted
  in the order of the provider chain: PAT, OauthM2M and OauthU2M.
  This in turn defines which authentication method will be called.
  A requestedAuthMethod must be set.
  Returns a logical true if authentication values have been populated
  into the object and otherwise false.
```

### databricks.internal.utils

### databricks.internal.utils.deleteDBFSFolders

```text
deleteDBFSFolders Delete folder starting with a certain name
```

### databricks.internal.utils.deleteJobs

```text
deleteJobs Delete jobs starting with a certain name
```

### databricks.internal.utils.deleteUnitTestData

```text
deleteUnitTestData Delete unit-test data
 
  The tests run by JobTester tend to create a large amount of data, as
  well as cluttering workspaces and workflows with notebooks and jobs.
  This is an umbrella function deleting a lot of the old stuff.
 
  For the moment, it just takes one argument, startWith, which gives a
  string that removes all jobs starting with this string.
  Typical arguments here can be "LOCAL", for deleting all jobs started
  from the desktop, or e.g. 613, for all pipeline jobs whose pipeline
  number starts with 613.
 
  The input can also be a vector of startWiths, e.g. ["91", "92"]
```

### databricks.internal.utils.deleteWorkspaces

```text
deleteWorkspaces Delete workspaces starting with a certain name
```

### databricks.internal.utils.largeFileDBFSUpload

```text
LARGEFILEDBFSUPLOAD Upload large files to DBFS using retries and file splitting
  Each upload attempt either for a file or part of a file will be attempted
  3 times.
 
  Optional named parameter:
          split: Split the file to be uploaded into parts, default is true
 
      clusterId: Specific cluster ID to use for command execution
 
     authMethod: A matlab.databricks.AuthMethod
 
    profileName: A configuration file profileName value
 
  A logical true is returned if the upload succeeds otherwise false is returned.
```

### databricks.internal.utils.newVersionCheck

```text
newVersionCheck displays a prompt to download a newer version if available
  Applies semantic versioning based sorting see: https://semver.org
 
  Example:
    tf = databricks.internal.utils.newVersionCheck();
 
  Returns true if a newer version is available and false otherwise.
  If a downloadable version cannot be determined false is returned.
```

### databricks.internal.utils.newVersionCheckImpl

```text
newVersionCheckImpl displays a prompt to download a newer version if available
  Applies semantic versioning based sorting see: https://semver.org
 
  Example:
    tf = databricks.internal.utils.newVersionCheck();
 
  Returns true if a newer version is available and false otherwise.
  If a downloadable version cannot be determined false is returned.
```

### databricks.internal.utils.prettyStackTrace

```text
prettyStackTrace Pretty stack trace output
```

### databricks.internal.utils.runtimeDBFSUpload

```text
RUNTIMEDBFSUPLOAD Uploads a MATLAB runtime to DBFS in parts
  The runtime is first downloaded, then split into parts
  each of which is uploaded with retries, a merge command is then produced
  as a notebook.
  By default the release corresponding to the current MATLAB release is used.
 
  Write access to DBFS is required.
 
  Optional named parameters:
         runtimeURL: URL of the MATLAB runtime to download
 
            retries: Number of times a DBFS upload will be attempted for each part
                     of the split file, default is 3
 
             blocks: The number of block to split a runtime file into, default: 10
 
            release: Default is the current release, example: "R2023b"
 
   localDestination: Location to store the downloaded runtime locally. Default: "<home directory>/Downloads"
 
  remoteDestination: Location to store the runtime on DBFS. Default: "/MathWorks/runtime"
```

### databricks.internal.workspace

### databricks.internal.workspace.download

```text
DOWNLOAD Download a file or directory of files using the Workspaces API
  
  Optional arguments:
    destination: Specify a destination path, otherwise the current directory
                 is used along with the source file/directory name.
 
      overwrite: Overwrite an existing local file or directory.
                 Default: true.
 
      recursive: Recursively download subdirectories.
                 Default: true.
 
        verbose: Enable additional output.
                 Default: true.
 
  Example:
    ws = databricks.Workspace;
    [result, localPath] = databricks.internal.workspace.download(ws, "/Workspace/Users/joe@example.com/myDirectory");
```

### databricks.internal.workspace.exist

```text
exist Returns true if a Workspace object of a given path exists, otherwise false
 
  Example:
    % Creates a Workspace object as required
    tf = databricks.internal.workspace.exist(path);
 
    % Use an existing Workspace
    tf = databricks.internal.workspace.exist(path, workspace=ws);
```

### databricks.internal.BenchmarkRunner

Superclass: handle

```text
BenchmarkRunner Running benchmarks on Databricks
```

#### databricks.internal.BenchmarkRunner.BenchmarkRunner

```text
BenchmarkRunner Running benchmarks on Databricks

    Documentation for databricks.internal.BenchmarkRunner
```

#### databricks.internal.BenchmarkRunner.build

```text
build Run the build for the library to benchmark
```

#### databricks.internal.BenchmarkRunner.createTasks

```text
createTasks
```

#### databricks.internal.BenchmarkRunner.getCluster

```text
getCluster
```

#### databricks.internal.BenchmarkRunner.getConfigurations

```text
Copyright 2022-2026, The MathWorks, Inc.
```

#### databricks.internal.BenchmarkRunner.getJavabuilder

```text
getJavabuilder
```

#### databricks.internal.BenchmarkRunner.getLibraries

```text
getLibraries
```

#### databricks.internal.BenchmarkRunner.getMachineTypes

```text
getMachineTypes
```

#### databricks.internal.BenchmarkRunner.getNotebook

```text
getNotebook
```

#### databricks.internal.BenchmarkRunner.getPkgType

```text
databricks.internal.BenchmarkRunner/getPkgType is a function.
    pkgType = getPkgType(obj)
```

#### databricks.internal.BenchmarkRunner.getWorkspaceName

```text
getWorkspaceName
```

#### databricks.internal.BenchmarkRunner.init

```text
databricks.internal.BenchmarkRunner/init is a function.
    init(obj, jobPath)
```

#### databricks.internal.BenchmarkRunner.runBenchmark

```text
runBenchmark
```

#### databricks.internal.BenchmarkRunner.uploadNotebook

```text
uploadNotebook
```

#### databricks.internal.BenchmarkRunner.uploadPackage

```text
uploadPackage
```

### databricks.internal.Cluster

Superclass: databricks.internal.Object

```text
CLUSTER Databricks Cluster API
  The Clusters API allows you to create, start, edit, list, terminate, and
  delete clusters. The maximum allowed size of a request to the Clusters
  API is 10MB.
 
  Cluster life-cycle methods require a cluster ID, which is returned from
  Create. To obtain a list of clusters, invoke List.
 
  Databricks maps cluster node instance types to compute units known as
  DBUs. See the Databricks instance type pricing page for a list of the
  supported instance types and their corresponding DBUs.
 
    cl = databricks.internal.Cluster;
 
  Will use the standard configuration file for initialization.
  Alternatively, to specify host and token:
 
    cl = databricks.internal.Cluster('Host','https://databrickshost.abc.com', 'Token', 'abc123');
 
  Or, with a specific authentication method and or profile name:
 
    cl = databricks.internal.Cluster('authMethod', matlab.internal.databricks.AuthMethod.PAT, 'profileName', 'DEV');
```

#### databricks.internal.Cluster.Cluster

```text
databricks.internal.Cluster
 
   Create cluster object using default configuration file.
    obj = databricks.internal.Cluster()
 
   Create cluster object using named values.
    obj = databricks.internal.Cluster('Host', 'https://databrickshost.abc.com', 'Token', '123abc')

    Documentation for databricks.internal.Cluster
```

#### databricks.internal.Cluster.findById

```text
FINDBYID Method to find a cluster by id
  Locate a databricks cluster by id
 
  Required argument
    clId    A scalar text cluster Id
 
  Optional named arguments
    authMethod     A matlab.internal.databricks.AuthMethod
    profileName    A configuration file profileName value
 
  For example:
 
  cl = databricks.internal.Cluster.findById('0928-104326-ul6a0cn9')
  cl =
    Cluster with properties:
 
                     cluster_name: 'Mumindalen'
                     node_type_id: 'Standard_DS3_v2'
                    spark_version: '10.4.x-scala2.12'
                       spark_conf: [4x1 containers.Map]
                       start_time: 28-Sep-2022 10:43:26
             last_state_loss_time: 29-Sep-2022 15:11:14
                 azure_attributes: [1x1 struct]
               last_activity_time: 29-Sep-2022 15:10:56
              last_restarted_time: 29-Sep-2022 15:11:14
              driver_node_type_id: 'Standard_DS3_v2'
              enable_elastic_disk: 1
          autotermination_minutes: 120
                      num_workers: 0
                        disk_spec: [1x1 struct]
                  terminated_time: 29-Sep-2022 17:11:00
                   cluster_source: 'UI'
               termination_reason: [1x1 struct]
                     default_tags: [1x1 struct]
     enable_local_disk_encryption: 0
           init_scripts_safe_mode: 0
                  instance_source: [1x1 struct]
                       cluster_id: '0928-104326-ul6a0cn9'
                   spark_env_vars: [1x1 containers.Map]
           driver_instance_source: [1x1 struct]
                      custom_tags: [1x1 struct]
                creator_user_name: 'joeuser@example.com'
                            state: 'TERMINATED'
          effective_spark_version: '10.4.x-scala2.12'
                    state_message: 'Inactive cluster terminated (inactive for 120 minutes).'
                 spark_context_id: 7382155561119740546
```

#### databricks.internal.Cluster.findByName

```text
databricks.internal.Cluster.findByName is a function.
    obj = databricks.internal.Cluster.findByName
```

#### databricks.internal.Cluster.getClusterVersionSemVer

```text
GETCLUSTERVERSIONSEMVER Get the runtime version of the cluster as a semantic version
  If the version cannot be determined an empty SemVer is returned.
```

#### databricks.internal.Cluster.getClusterVersionString

```text
GETCLUSTERRUNTIMEVERSION Returns the numeric form of a cluster runtime e.g. 16.4
  Errors if the cluster is empty.
  Errors if the cluster spark_version property is missing or not set.
```

#### databricks.internal.Cluster.getNodeTypes

```text
databricks.internal.Cluster.getNodeTypes is a function.
    obj = databricks.internal.Cluster.getNodeTypes
```

#### databricks.internal.Cluster.getSparkVersions

```text
databricks.internal.Cluster.getSparkVersions is a function.
    obj = databricks.internal.Cluster.getSparkVersions
```

#### databricks.internal.Cluster.list

```text
LIST Create a list of databricks clusters
  This method can be used to create a list of all available Databricks clusters.
 
    cl = databricks.internal.Cluster.list();
 
  The returned cluster(s) will provide a handle to Databricks.
 
  Optional named arguments
    authMethod     A matlab.internal.databricks.AuthMethod
    profileName    A configuration file profileName value
 
  Example:
 
   clusters = databricks.internal.Cluster.list
   clusters =
     1x32 Cluster array with properties:
 
       cluster_name
       node_type_id
       spark_version
       spark_conf
 
   clusters(1)
   ans =
     Cluster with properties:
 
                       cluster_name: 'Mumindalen'
                       node_type_id: 'Standard_DS3_v2'
                      spark_version: '10.4.x-scala2.12'
                         spark_conf: [2x1 containers.Map]
                         start_time: 30-Sep-2022 08:46:12
               last_state_loss_time: 01-Jan-1970
                   azure_attributes: [1x1 struct]
                 last_activity_time: 30-Sep-2022 09:39:59
                last_restarted_time: 30-Sep-2022 08:52:48
                driver_node_type_id: 'Standard_DS3_v2'
                enable_elastic_disk: 1
                   cluster_log_conf: [1x1 struct]
            autotermination_minutes: 120
                        num_workers: 2
                       init_scripts: [1x1 struct]
                          disk_spec: [1x1 struct]
                    terminated_time: 30-Sep-2022 11:40:28
                     cluster_source: 'UI'
                 cluster_log_status: [1x1 struct]
                 termination_reason: [1x1 struct]
                       default_tags: [1x1 struct]
       enable_local_disk_encryption: 0
             init_scripts_safe_mode: 0
                    instance_source: [1x1 struct]
                         cluster_id: '0930-084612-uurhdujo'
                     spark_env_vars: [2x1 containers.Map]
             driver_instance_source: [1x1 struct]
                  creator_user_name: 'joeuser@example.com'
                              state: 'TERMINATED'
            effective_spark_version: '10.4.x-scala2.12'
                      state_message: 'Inactive cluster terminated (inactive for 120 minutes).'
                   spark_context_id: 7430983140709072285
```

#### databricks.internal.Cluster.setAutoterminationMinutes

```text
SETAUTOTERMINATIONMINUTES Method to set the auto-termination for clusters
  Setting the autotermination minutes for the cluster by setting the
  property on the cluster object. This automatically terminates the cluster
  after it is inactive for this time in minutes.
 
  If not set, this cluster will not be automatically terminated.
  If specified, the threshold must be between 10 and 10000 minutes.
  If this value is set to 0, it will explicitly disable automatic termination.
 
    cl = databricks.internal.Cluster;
    cl.setAutoterminationMinutes(100);
```

#### databricks.internal.Cluster.setPolicyId

```text
SETPOLICYID Method to set a policy_id to a cluster handle
  Set the policy id for a cluster handle.
 
    cl = databricks.internal.Cluster()
    cl.setPolicyId('MY-POLICY-VALUE');
 
  The policy_id can be specified as a string or character vector and is stored
  as a character vector.
 
  A default policy_id can be defined in the databricks-settings.json file.
  This will then be applied to all created clusters unless overwritten.
```

#### databricks.internal.Cluster.setSparkConf

```text
SETSPARKCONF Method to create and update spark_conf for the cluster
  Set custom spark_conf on the Cluster object. This is useful when creating new
  clusters, particularly if creating a single node cluster.
 
  For example:
 
      cl = databricks.internal.Cluster;
      scpCell = {'spark_master', 'local[*,4]'; 'spark_databricks_cluster_profile', 'singleNode'};
      scps = databricks.internal.SparkConfPair(scpCell);
      cl.setSparkConf(scps);
```

#### databricks.internal.Cluster.setSparkEnvVars

```text
SETSPARKENVVARS Method to create and update environment variables for the cluster
  Set spark_env_vars on the Cluster object. This is useful when creating new
  clusters.
 
  For example:
 
      cl = databricks.internal.Cluster;
      var = databricks.internal.SparkEnvPair('SPARK_LOCAL_DIRS','/local_disk0');
      cl.setSparkEnvVars(var);
```

### databricks.internal.DatabricksPathHelper

Superclass: handle

```text
DatabricksPathHelper - Utility class for Databricks paths
```

#### databricks.internal.DatabricksPathHelper.DatabricksPathHelper

```text
DatabricksPathHelper - Utility class for Databricks paths

    Documentation for databricks.internal.DatabricksPathHelper
```

#### databricks.internal.DatabricksPathHelper.ensureEndsWithSlash

```text
databricks.internal.DatabricksPathHelper/ensureEndsWithSlash is a function.
    ensureEndsWithSlash(obj)
```

#### databricks.internal.DatabricksPathHelper.get

```text
fixedPath Return the path
  This method returns the path, and adds some options for
  adapting the output.
 
    stripDBFS will remove dbfs: or dbfs/ at beginning
    onlyFolder will return only the folder name
    onlyName will just return the file name (or last folder)
```

#### databricks.internal.DatabricksPathHelper.getDBFSDirPath

```text
databricks.internal.DatabricksPathHelper/getDBFSDirPath is a function.
    dirPath = getDBFSDirPath(obj)
```

#### databricks.internal.DatabricksPathHelper.init

```text
databricks.internal.DatabricksPathHelper/init is a function.
    init(obj)
```

### databricks.internal.Object

Superclass: dynamicprops

```text
OBJECT Databricks root object
  Properties added to this object will be available on all databricks
  classes.
 
  The Version property refers to the version of the Databricks REST API to
  be used.
 
  For more information on provider chain based authentication details see:
  https://learn.microsoft.com/en-us/azure/databricks/dev-tools/auth#unified-auth
 
  See Documentation for further details: Documentation/Authentication.md
```

#### databricks.internal.Object.Object

```text
OBJECT Databricks root object
  Properties added to this object will be available on all databricks
  classes.
 
  The Version property refers to the version of the Databricks REST API to
  be used.
 
  For more information on provider chain based authentication details see:
  https://learn.microsoft.com/en-us/azure/databricks/dev-tools/auth#unified-auth
 
  See Documentation for further details: Documentation/Authentication.md

    Documentation for databricks.internal.Object
```

#### databricks.internal.Object.addStructureAsDynProps

```text
databricks.internal.Object/addStructureAsDynProps is a function.
    addStructureAsDynProps(obj, S)
```

#### databricks.internal.Object.epochToTimestamp

```text
databricks.internal.Object.epochToTimestamp is a function.
    ts = databricks.internal.Object.epochToTimestamp(epoch)
```

#### databricks.internal.Object.getAuth

```text
getAuth Populates the authentication configuration values in the databricks.internal.Object class
  Sets Host, Profile & Token
```

#### databricks.internal.Object.getAuthorizationField

```text
GETAUTHORIZATIONFIELD Return the authorization field for API
```

#### databricks.internal.Object.getRequestMessage

```text
GETREQUESTMESSAGE Get the request message to call the databricks API
 
     req = obj.getRequestMessage
 
   will return a matlab.net.http.RequestMessage with the correct
   authorization information set.
 
     req = obj.getRequestMessage('POST')
 
   will create a similar RequestMessage with the correct method set too.
```

#### databricks.internal.Object.getURI

```text
getURI Return a matlab.net.URI object
 
  Examples:
   % Return a matlab.net.URI for https://<host>/api/2.0/clusters/list
   u = obj.getURI('clusters', 'list')
 
   % If the function needs parameters, they can be added as pairs
   % Return a matlab.net.URI for https://<host>/api/2.0/clusters/get?cluster_id=123
   u = obj.getURI('clusters', 'get', 'cluster_id', '123')
```

#### databricks.internal.Object.getUserAgent

```text
getUserAgent Returns user agent based on a MATLAB Release value
  Value has the form: MathWorks_MATLAB/25.2.0 for R2025b
  By default the current release is used.
 
  Example:
    userAgent = databricks.internal.Object.getUserAgent(release="R2025b");
```

#### databricks.internal.Object.isPreview

```text
databricks.internal.Object/isPreview is a function.
    tf = isPreview(~, api)
```

#### databricks.internal.Object.rmpropif

```text
rmpropif Remove a property if it exists
```

#### databricks.internal.Object.sanitizeHost

```text
sanitizeHost Cleans up host values
  Leading and trailing white space is removed.
  If the host is of length zero this is returned, with an
  optional warning.
  If the host has a trailing / it is removed.
  If the host does not start with https:// (case insensitive) a
  warning is produced.
```

#### databricks.internal.Object.setprop

```text
setprop Set a property on an object
  If the property doesn't already exist, it will be added
```

### databricks.internal.PySparkSession

Superclasses: matlab.pyspark.sql.session.SparkSession, matlab.mixin.CustomDisplay

```text
PYSPARKSESSION Class to create a PySpark session
```

#### databricks.internal.PySparkSession.PySparkSession

```text
PYSPARKSESSION Constructor for PySparkSession class
 
  This constructor is designed to be called from getDatabricksSession()
  or a similar wrapper function.
 
  Named arguments:
               platform : While Databricks is the primary target platform
                          for this class it may support other platforms
                          in the future, like plain Apache Spark.
                          Currently "databricks" is the default and
                          only supported value.
 
                   mode : Serverless mode is supported. Set the optional
                          named argument mode to "serverless" or "classic"
                          (default).
 
                cluster : A cluster can be given using the named argument
                          cluster of type databricks.Cluster object.
                          The cluster must be in a running state. If using
                          serverless mode a cluster argument should not
                          be given.
 
           dependencies : Can be used to provided a list of Python packages
                          that should be installed in the Python environment
                          before creating the Spark session. This is useful
                          when additional libraries% are required.
 
             authMethod : Used to specify a specific authentication method.
 
            profileName : Used to specify a specific profile.
 
      skipVersionChecks : Set to true to skip version checks for:
                            * Client Python version support.
                            * Client Python serverless support.
                            * MATLAB Python version support.
                            * Client Python version matches the cluster
                              Python version.
                            * Databricks Connect service disabled.
                          The use of this argument is not recommended
                          and is likely to result in errors.
                          However, it may sometimes be useful for testing
                          purposes. Default: false.
 
  clusterRuntimeVersion : Required if using Databricks, e.g. 16.4
 
                verbose : Flag is used to control the verbosity of the output.
                          Default: true.
 
        forceNewSession : When set to true this will create a new Spark
                          Session. If set to false or omitted, it will
                          reuse an existing Spark Session, if available.
                          This is especially useful in development workflows,
                          where a new version of an artifact is uploaded
                          with the addArtifact method. If an old session
                          is reused, the artifact cannot be reused.
                          Default: false.
 
  The timeout when creating a session is 5 minutes.
 
  If the HTTP_PROXY or HTTPS_PROXY environment variables are
  set in the MATLAB process context but the MATLAB proxy is
  setting/preference is not set a warning is produced as this
  is possible source of error for other interfaces. If the
  setting/preference is set a the HTTP(S)_PROXY variable is
  configured in the Python environment context used by the
  Databricks Connect library.
 
  This class only supports Databricks Connect v2, v1 is not supported.
 
  See also Databricks session creation code:
    site-packages\databricks\connect\session.py

    Documentation for databricks.internal.PySparkSession
```

#### databricks.internal.PySparkSession.getPropertyGroups

```text
databricks.internal.PySparkSession/getPropertyGroups is a function.
    groups = getPropertyGroups(obj)
```

### databricks.internal.SparkConfPair

Superclass: databricks.internal.Object

```text
SPARKCONFPAIR Class to specify Spark configuration key-value pairs
  They can also be used pass in a string of extra JVM options
  Keys and value must be character vectors or scalar strings.
  Both keys and values are stored as character arrays.
 
  For example:
 
    cl = databricks.internal.Cluster;
    scp = databricks.internal.SparkConfPair('spark.speculation', 'true');
    cl.setCustomTags(scp);
 
  Optionally, this class accepts a cell array of inputs to specify multiple
  pairs.
 
    scpCell = {'spark.speculation', 'true'; 'myvar','myval'};
    scps = databricks.internal.SparkConfPair(scpCell);
 
  A pair can also be added to an existing SparkConfPair using the add method
    scpCell = {'spark.speculation', 'true'; 'myvar','myval'};
    scps = databricks.internal.SparkConfPair(scpCell);
    scps.add('myNewKey','myNewValue');
 
  Order of insertion is not preserved.
```

#### databricks.internal.SparkConfPair.SparkConfPair

```text
containers.Map is a handle class so set the property in the
  constructor

    Documentation for databricks.internal.SparkConfPair
```

#### databricks.internal.SparkConfPair.add

```text
ADD Adds a Key Value pair to a SparkConfPair object
 
  Example
    scps = databricks.internal.SparkConfPair('key1','value1');
    scps.add('additionalKey', 'additionalValue');
```

### databricks.internal.SparkEnvPair

Superclass: databricks.internal.Object

```text
SPARKENVPAIR Specify environment variables to attach to the create object.
  Use to Spark environment variable key-value pairs on the databricks cluster.
  Keys and values must be character vectors or scalar strings.
  Both keys and values are stored as character arrays.
 
  For example:
 
    cl = databricks.internal.Cluster;
    var = databricks.internal.SparkEnvPair('SPARK_WORKER_MEMORY','28000m');
    cl.setSparkEnvVars(var);
 
  Optionally, this class accepts a cell array of inputs to specify multiple
  tag pairs.
 
    varCell = {'SPARK_WORKER_MEMORY','28000m';'SPARK_LOCAL_DIRS','/local_disk0'};
    vars = databricks.internal.SparkEnvPair(varCell);
 
  A pair can also be added to an existing SparkEnvPair using the add method
    varCell = {'SPARK_WORKER_MEMORY','28000m';'SPARK_LOCAL_DIRS','/local_disk0'};
    vars = databricks.internal.SparkEnvPair(varCell);
    vars.add('myNewKey','myNewValue');
 
  Order of insertion is not preserved.
  When specifying environment variables in a job cluster, the fields in this
  data structure accept only Latin characters (ASCII character set). Using
  non-ASCII characters will return an error. Examples of invalid, non-ASCII
  characters are Chinese, Japanese kanjis, and emojis.
 
  https://docs.databricks.com/dev-tools/api/latest/clusters.html#sparkenvpair
```

#### databricks.internal.SparkEnvPair.SparkEnvPair

```text
containers.Map is a handle class so set the property in the
  constructor

    Documentation for databricks.internal.SparkEnvPair
```

#### databricks.internal.SparkEnvPair.add

```text
ADD Adds a Key Value pair to a SparkEnvPair object
 
  Example
    vars = databricks.internal.SparkEnvPair('key1','value1');
    vars.add('additionalKey', 'additionalValue');
```

### databricks.internal.WorkspaceConf

Superclass: databricks.Object

```text
WORKSPACECONF Allows updating known workspace settings for advanced users
```

#### databricks.internal.WorkspaceConf.WorkspaceConf

```text
WorkspaceConf Constructor

    Documentation for databricks.internal.WorkspaceConf
```

#### databricks.internal.WorkspaceConf.check

```text
CHECK Check configuration status
  TODO API is not sufficiently documented as yet.
 
  Example:
    wsc = databricks.internal.WorkspaceConf
    [result, errorResponse] = wsc.check("enableExportNotebook")
 
  See also: https://docs.databricks.com/api/workspace/workspaceconf/getstatus
```

#### databricks.internal.WorkspaceConf.getOrgId

```text
GETORGID Return the Workspace orgId or an empty string if it is not found
 
  Example:
     wsc = databricks.internal.WorkspaceConf;
     orgId = wsc.getOrgId();
```

### databricks.internal.cleanPath

```text
CLEANPATH Removes references to the package from the MATLAB path
  Changes can be optionally saved to the path.
  A pathdef.m path can optionally be specified.
```

### databricks.internal.downloadNotebooksRecursively

```text
DOWNLOADNOTEBOOKSRECURSIVELY
```

### databricks.internal.edit

```text
edit Edit databricks settings and configuration files based on synonyms
  Synonyms must be provided as a string array.
  By default both the default .databrickscfg and databricks-settings.json
  files are opened.
 
  Examples:
    % Open the default .databrickscfg file
    databricks.internal.edit("cfg")
 
    % Open the default .databricks-settings.json file
    databricks.internal.edit("settings")
 
    % Open both the default .databrickscfg and databricks-settings.json files
    databricks.internal.edit
 
  An string array of file paths is returned, an empty value indicates
  an error.
 
  Deployed mode is not supported.
 
  The following arguments are accepted:
    "configuration", "cfg", "databrickscfg", ".databrickscfg", "config"
    "settings", "databricks-settings", "databricks-settings.json"
    "java", "javaclasspath.txt", "classpath", "javaclasspath"
```

### databricks.internal.getFilteredSparkVersions

```text
GETFILTEREDSPARKVERSIONS Return Spark version information for databricks versions
 
  Example:
 
  filteredVersions = databricks.internal.getFilteredSparkVersions()
  filteredVersions =
    55x11 table
                    key                                               name                                baseVersion     spark     scala      lts      cpu      gpu      ml      photon    aarch64
      ________________________________    ____________________________________________________________    ___________    _______    ______    _____    _____    _____    _____    ______    _______
      "12.2.x-scala2.12"                  "12.2 LTS (includes Apache Spark 3.3.2, Scala 2.12)"              "12.2"       "3.3.2"    "2.12"    true     true     false    false    false      false 
      "11.3.x-photon-scala2.12"           "11.3 LTS Photon (includes Apache Spark 3.3.0, Scala 2.12)"       "11.3"       "3.3.0"    "2.12"    true     true     false    false    true       false 
      "15.3.x-cpu-ml-photon-scala2.12"    "15.3 ML (includes Apache Spark 3.5.0, Scala 2.12)"               "15.3"       "3.5.0"    "2.12"    false    true     false    true     false      false 
      "14.2.x-cpu-ml-scala2.12"           "14.2 ML (includes Apache Spark 3.5.0, Scala 2.12)"               "14.2"       "3.5.0"    "2.12"    false    true     false    true     false      false 
      "15.1.x-cpu-ml-scala2.12"           "15.1 ML (includes Apache Spark 3.5.0, Scala 2.12)"               "15.1"       "3.5.0"    "2.12"    false    true     false    true     false      false 
      "10.4.x-cpu-ml-scala2.12"           "10.4 LTS ML (includes Apache Spark 3.2.1, Scala 2.12)"           "10.4"       "3.2.1"    "2.12"    true     true     false    true     false      false 
      "14.2.x-gpu-ml-scala2.12"           "14.2 ML (includes Apache Spark 3.5.0, GPU, Scala 2.12)"          "14.2"       "3.5.0"    "2.12"    false    false    true     true     false      false 
                     :                                                 :                                       :            :         :         :        :        :        :        :          :   
      "14.1.x-cpu-ml-scala2.12"           "14.1 ML (includes Apache Spark 3.5.0, Scala 2.12)"               "14.1"       "3.5.0"    "2.12"    false    true     false    true     false      false 
      "14.2.x-scala2.12"                  "14.2 (includes Apache Spark 3.5.0, Scala 2.12)"                  "14.2"       "3.5.0"    "2.12"    false    true     false    false    false      false 
      "12.2.x-gpu-ml-scala2.12"           "12.2 LTS ML (includes Apache Spark 3.3.2, GPU, Scala 2.12)"      "12.2"       "3.3.2"    "2.12"    true     false    true     true     false      false 
      "15.2.x-photon-scala2.12"           "15.2 Photon (includes Apache Spark 3.5.0, Scala 2.12)"           "15.2"       "3.5.0"    "2.12"    false    true     false    false    true       false 
      "13.3.x-photon-scala2.12"           "13.3 LTS Photon (includes Apache Spark 3.4.1, Scala 2.12)"       "13.3"       "3.4.1"    "2.12"    true     true     false    false    true       false 
      "10.4.x-gpu-ml-scala2.12"           "10.4 LTS ML (includes Apache Spark 3.2.1, GPU, Scala 2.12)"      "10.4"       "3.2.1"    "2.12"    true     false    true     true     false      false 
      "14.1.x-photon-scala2.12"           "14.1 Photon (includes Apache Spark 3.5.0, Scala 2.12)"           "14.1"       "3.5.0"    "2.12"    false    true     false    false    true       false 
  	Display all 55 rows.
  
  Options enable the selections a subset of Spark versions.
 
  Optional named arguments
    baseVersions   A string array e.g. ["15.4", "13.3"
    cpu            A logical
    gpu            A logical
    ml             A logical
    photon         A logical
    aarch64        A logical
    authMethod     A matlab.databricks.AuthMethod
    profileName    A configuration file profileName value
 
  Example:
    sv = databricks.internal.getFilteredSparkVersions(lts=true, cpu=true, ml=false, photon=true)
    sv =
    1x11 table
               key                                          name                                baseVersion     spark     scala      lts      cpu      gpu      ml      photon    aarch64
    _________________________    ___________________________________________________________    ___________    _______    ______    _____    _____    _____    _____    ______    _______
    "15.4.x-photon-scala2.12"    "15.4 LTS Photon (includes Apache Spark 3.5.0, Scala 2.12)"      "15.4"       "3.5.0"    "2.12"    true     true     false    false    true       false
```

### databricks.internal.getFilteredSparkVersionsImpl

```text
GETFILTEREDSPARKVERSIONSIMPL Return Spark version information for databricks versions
 
  Example:
 
  filteredVersions = databricks.internal.getFilteredSparkVersionsImpl()
 
  Options enable the selections a subset of Spark versions.
 
  Optional named arguments
    baseVersions   A string array e.g. ["15.4", "13.3"
    cpu            A logical
    gpu            A logical
    ml             A logical
    photon         A logical
    aarch64        A logical
    authMethod     A matlab.internal.databricks.AuthMethod
    profileName    A configuration file profileName value
 
  Example:
    sv = databricks.internal.getFilteredSparkVersionsImpl(lts=true, cpu=true, ml=false, photon=true)
```

### databricks.internal.getHTTPOptions

```text
GETHTTPOPTIONS Return HTTP communication options
  Modify the <package>-http.json file to override the settings that the package uses
  for REST based communication. This file must be on the MATLAB path, by default
  it is found in the /Software/MATLAB/config directory.
  If a databricks-http.json file is found on the path it will used.
  If no file is found then MATLAB's default matlab.net.http.HTTPOptions
  will be used.
 
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
 
     opts = databricks.internal.getHTTPOptions(convertResponse=false);
```

### databricks.internal.getHTTPOptionsImpl

```text
GETHTTPOPTIONS Return HTTP communication options
  Modify the <package>-http.json file to override the settings that the package uses
  for REST based communication. This file must be on the MATLAB path, by default
  it is found in the /Software/MATLAB/config directory.
  If a databricks-http.json file is found on the path it will used.
  If no file is found then MATLAB's default matlab.net.http.HTTPOptions
  will be used.
 
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
 
     opts = databricks.internal.getHTTPOptions(convertResponse=false);
```

### databricks.internal.isOnDatabricks

```text
ISONDATABRICKS Returns true if running on Databricks otherwise false
 
  Example:
    tf = databricks.internal.isOnDatabricks()
```

### databricks.internal.isOnDatabricksImpl

```text
ISONDATABRICKSIMPL Returns true if running on Databricks otherwise false
 
  Example:
    tf = databricks.internal.isOnDatabricksImpl()
```

### databricks.internal.runMATLABTask

```text
RUNMATLABTASK Runs a MATLAB batch or runtime task automatically
  Returns a databricks.Run job run. An empty run indicates an error.
  If auto and "... -batch <statement>" the they be these final arguments in an auto value.
 
  Examples:
    jr = databricks.internal.runMATLABTask(command="myCompiledBinary", arguments="3.14");
 
    jr = databricks.internal.runMATLABTask(cluster="1031-081221-u31ejni1",...
                                           statement="disp('Hello World'); exit(0)",...
                                           licenseManager="27000@10.0.0.4");
 
    jr = databricks.internal.runMATLABTask(auto="myCompiledBinary 3.14");
 
    jr = databricks.internal.runMATLABTask(cluster="1031-081221-u31ejni1", auto="disp('Hello World'); exit(0)", licenseManager="27000@10.0.0.4");
 
    jr = databricks.internal.runMATLABTask(cluster="1031-081221-u31ejni1", auto='matlab -c 27000@10.0.0.4 -batch "disp('Hello World'); exit(0)"');
 
 
  Common named arguments:
  =======================
                auto: The function tries to determine if a batch or runtime task is to be called
             cluster: Databricks cluster Id or databricks.Cluster object
      dockerAuthFile: Docker authentication details file see createDatabricksCluster
        preExecPyCmd: See databricks.MATLABRuntimeTask & databricks.MATLABBatchTask
       postExecPyCmd: See databricks.MATLABRuntimeTask & databricks.MATLABBatchTask
        preExecShCmd: See databricks.MATLABRuntimeTask & databricks.MATLABBatchTask
       postExecShCmd: See databricks.MATLABRuntimeTask & databricks.MATLABBatchTask
      baseParameters: See databricks.MATLABRuntimeTask & databricks.MATLABBatchTask
   overwriteNotebook: See databricks.MATLABRuntimeTask & databricks.MATLABBatchTask
          authMethod: See databricks.MATLABRuntimeTask & databricks.MATLABBatchTask
         profileName: See databricks.MATLABRuntimeTask & databricks.MATLABBatchTask
 
  Runtime task specific named arguments:
  ======================================
            command: See databricks.MATLABRuntimeTask
          arguments: See databricks.MATLABRuntimeTask
            mcrRoot: See databricks.MATLABRuntimeTask
      ldLibraryPath: See databricks.MATLABRuntimeTask
 
  Batch task specific named arguments:
  ====================================
         statement: See databricks.MATLABBatchTask
    licenseManager: See databricks.MATLABBatchTask
      licenseToken: See databricks.MATLABBatchTask
       accountName: See databricks.MATLABBatchTask
     MATLABCommand: See databricks.MATLABBatchTask
    licenseTokenSecretKey: See databricks.MATLABBatchTask
  licenseTokenSecretScope: See databricks.MATLABBatchTask
```

### databricks.internal.runSparkPythonTaskExample

```text
runSparkPythonTaskExample Run an example of PythonSparkTask
 
  This is a special function that runs a very simple example. It's used
  for the example output of PythonSparkBuilder
 
  This function needs at least 2 arguments:
 
  [jobRun, job] = runSparkPythonTaskExample(pythonFile, wheelFile),
 
  where the Python file is the file to be run, and the wheel file is
  the compiled MATLAB library. It returns to objects, representing the
  jobRun and the job that were created.
 
  The function also takes additional arguments, which can be added in
  the format 
     runSparkPythonTaskExample(pf, wf, 'arg', argValue)
  or
     runSparkPythonTaskExample(pf, wf, arg=argValue)
 
  The optional arguments are:
  baseFolderDBFS - The folder where the python and wheel files will be
                   uploaded
  overwrite - If true, will overwrite files if they exist
  cluster - The name of an existing cluster, or a uninitialized cluster
            object. If not present, a new job cluster will be created
            automatically.
  openRunPage - A logical value specifying whether the runpage should
                be opened in a browser automatically.
  interfaceDirectory - Non settings file value for the package's directory
  authMethod - A matlab.databricks.AuthMethod
  profileName - A configuration file profileName value
```

### databricks.statementexecution

### databricks.statementexecution.api

### databricks.statementexecution.api.StatementExecution

Superclass: databricks.statementexecution.BaseClient

```text
StatementExecution No description provided
 
  StatementExecution Properties:
 
    serverUri           - Base URI to use when calling the API. Allows using a different server
                          than specified in the original API spec.
    httpOptions         - HTTPOptions used by all requests.
    preferredAuthMethod - If operation supports multiple authentication methods, specified which
                          method to prefer.
    bearerToken         - If Bearer token authentication is used, the token can be supplied 
                          here. Note the token is only used if operations are called for which
                          the API explicitly specified that Bearer authentication is supported.
                          If this has not been specified in the spec but most operations do 
                          require Bearer authentication, consider adding the relevant header to
                          all requests in the preSend method.
    apiKey              - If API key authentication is used, the key can be supplied here. 
                          Note the key is only used if operations are called for which
                          the API explicitly specified that API key authentication is supported.
                          If this has not been specified in the spec but most operations do 
                          require API key authentication, consider adding the API key to all
                          requests in the preSend method.
    httpCredentials     - If Basic or Digest authentication is supported username/password
                          credentials can be supplied here as matlab.net.http.Credentials. Note 
                          these are only actively used if operations are called for which the 
                          API spec has specified they require Basic authentication. If this has
                          not been specified in the spec but most operations do require
                          Basic authentication, consider setting the Credentials property in the
                          httpOptions rather than through httpCredentials.
    cookies             - Cookie jar. The cookie jar is shared across all Api classes in the 
                          same package. All responses are automatically parsed for Set-Cookie
                          headers and cookies are automatically added to the jar. Similarly
                          cookies are added to outgoing requests if there are matching cookies 
                          in the jar for the given request. Cookies can also be added manually
                          by calling the setCookies method on the cookies property. The cookie
                          jar is also saved to disk (cookies.mat in the same directory as 
                          BaseClient) and reloaded in new MATLAB sessions.
 
  StatementExecution Methods:
 
    StatementExecution - Constructor
    cancelExecution - Cancel statement execution
    executeStatement - Execute a SQL statement
    getStatement - Get status, manifest, and result first chunk
    getStatementResultChunkN - Get result chunk by index
 
  See Also: matlab.net.http.HTTPOptions, matlab.net.http.Credentials, 
    CookieJar.setCookies, databricks.statementexecution.BaseClient
```

#### databricks.statementexecution.api.StatementExecution.StatementExecution

```text
StatementExecution Constructor, creates a StatementExecution instance.
  When called without inputs, tries to load configuration
  options from JSON file 'databricks.statementexecution.Client.Settings.json'.
  If this file is not present, the instance is initialized with 
  default configuration option.
  All other properties of the instance can also be overridden 
  using Name-Value pairs where Name equals the property name.
  
  Examples:
 
    % Create a client with default options and serverUri
    % as parsed from OpenAPI spec (if available)
    client = databricks.statementexecution.api.StatementExecution();
 
    % Create a client for alternative server/base URI
    client = databricks.statementexecution.api.StatementExecution("serverUri","https://example.com:1234/api/");
 
    % Create a client with alternative HTTPOptions and an API key
    client = databricks.statementexecution.api.StatementExecution("httpOptions",...
        matlab.net.http.HTTPOptions("ConnectTimeout",42),...
        "apiKey", "ABC123");

    Documentation for databricks.statementexecution.api.StatementExecution
```

#### databricks.statementexecution.api.StatementExecution.cancelExecution

```text
cancelExecution Cancel statement execution
  Requests that an executing statement be canceled. Callers must poll for status to see the terminal state. 
 
  Required parameters:
    statement_id - No description provided, Type: string
 
  No optional parameters
 
  Responses:
    200: Cancel response is empty; receiving response indicates successful receipt.
    0: 
 
  Returns: 
 
  See Also: databricks.statementexecution.models.
```

#### databricks.statementexecution.api.StatementExecution.executeStatement

```text
executeStatement Execute a SQL statement
  Execute a SQL statement, and if flagged as such, await its result for a specified time. 
 
  Required parameters:
    ExecuteStatementRequest - No description provided, Type: ExecuteStatementRequest
        Required properties in the model for this call:
        Optional properties in the model for this call:
            byte_limit
            catalog
            disposition
            format
            on_wait_timeout
            schema
            statement
            wait_timeout
            warehouse_id
 
  No optional parameters
 
  Responses:
    200: 
    0: 
 
  Returns: executeStatement_200_response
 
  See Also: databricks.statementexecution.models.executeStatement_200_response
```

#### databricks.statementexecution.api.StatementExecution.getStatement

```text
getStatement Get status, manifest, and result first chunk
  This request can be used to poll for the statement''s status. When the `status.state` field is `SUCCEEDED` it will also return the result manifest and the first chunk of the result data. When the statement is in the terminal states `CANCELED`, `CLOSED` or `FAILED`, it returns HTTP 200 with the state set. After at least 12 hours in terminal state, the statement is removed from the warehouse and further calls will receive an HTTP 404 response.  **NOTE** This call currently may take up to 5 seconds to get the latest status and result. 
 
  Required parameters:
    statement_id - No description provided, Type: string
 
  No optional parameters
 
  Responses:
    200: 
    0: 
 
  Returns: executeStatement_200_response
 
  See Also: databricks.statementexecution.models.executeStatement_200_response
```

#### databricks.statementexecution.api.StatementExecution.getStatementResultChunkN

```text
getStatementResultChunkN Get result chunk by index
  After the statement execution has `SUCCEEDED`, the result data can be fetched by chunks. Whereas the first chuck with `chunk_index=0` is typically fetched through a `get status` request, subsequent chunks can be fetched using a `get result` request. The response structure is identical to the nested `result` element described in the `get status` request, and similarly includes the `next_chunk_index` and `next_chunk_internal_link` fields for simple iteration through the result set. 
 
  Required parameters:
    statement_id - No description provided, Type: string
    chunk_index - No description provided, Type: int32, Format: int32
 
  No optional parameters
 
  Responses:
    200: Successful return; depending on `disposition` returns chunks of data either inline, or as links.
    0: 
 
  Returns: ResultData
 
  See Also: databricks.statementexecution.models.ResultData
```

### databricks.statementexecution.models

### databricks.statementexecution.models.Chunk

Superclass: databricks.statementexecution.JSONMapper

```text
Chunk No description provided
  
  Chunk Properties:
    byte_count - Number of bytes in the result chunk. - type: int64
    chunk_index - Position within the sequence of result set chunks. - type: int32
    data_array - `JSON_ARRAY` format is an array of arrays of values, where each non-null value is formatted as a string. Null values are encoded as JSON `null`.  - type: array of array
    next_chunk_index - When fetching, gives `chunk_index` for the _next_ chunk; if absent, indicates there are no more chunks. - type: int32
    next_chunk_internal_link - When fetching, gives `internal_link` for the _next_ chunk; if absent, indicates there are no more chunks. - type: string
    row_count - Number of rows within the result chunk. - type: int64
    row_offset - Starting row offset within the result set. - type: int64
```

#### databricks.statementexecution.models.Chunk.Chunk

```text
To allow proper nesting of object, derived objects must
  call the initialize method from their constructor. This 
  also allows objects to be instantiated with Name-Value pairs
  as inputs to set properties to specified values.

    Documentation for databricks.statementexecution.models.Chunk
```

### databricks.statementexecution.models.ChunkInfo

Superclass: databricks.statementexecution.JSONMapper

```text
ChunkInfo Describes metadata for a particular chunk, within a result set; this structure is used both within a manifest, and when fetching individual chunk data or links. 
  
  ChunkInfo Properties:
    byte_count - Number of bytes in the result chunk. - type: int64
    chunk_index - Position within the sequence of result set chunks. - type: int32
    next_chunk_index - When fetching, gives `chunk_index` for the _next_ chunk; if absent, indicates there are no more chunks. - type: int32
    next_chunk_internal_link - When fetching, gives `internal_link` for the _next_ chunk; if absent, indicates there are no more chunks. - type: string
    row_count - Number of rows within the result chunk. - type: int64
    row_offset - Starting row offset within the result set. - type: int64
```

#### databricks.statementexecution.models.ChunkInfo.ChunkInfo

```text
To allow proper nesting of object, derived objects must
  call the initialize method from their constructor. This 
  also allows objects to be instantiated with Name-Value pairs
  as inputs to set properties to specified values.

    Documentation for databricks.statementexecution.models.ChunkInfo
```

### databricks.statementexecution.models.ColumnInfo

Superclass: databricks.statementexecution.JSONMapper

```text
ColumnInfo No description provided
  
  ColumnInfo Properties:
    name - Name of Column. - type: string
    position - Ordinal position of column (starting at position 0). - type: int32
    type_interval_type - Format of interval type. - type: string
    type_name - Name of type (INT, STRUCT, MAP, and so on) - type: string
    type_precision - Digits of precision. - type: int32
    type_scale - Digits to right of decimal. - type: int32
    type_text - Full data type spec, SQL/catalogString text. - type: string
```

#### databricks.statementexecution.models.ColumnInfo.ColumnInfo

```text
To allow proper nesting of object, derived objects must
  call the initialize method from their constructor. This 
  also allows objects to be instantiated with Name-Value pairs
  as inputs to set properties to specified values.

    Documentation for databricks.statementexecution.models.ColumnInfo
```

### databricks.statementexecution.models.ColumnInfoType_nameEnum

Superclass: databricks.statementexecution.JSONEnum

```text
ColumnInfoType_nameEnum No description provided
```

```text
Enumeration values:
  BOOLEAN
  BYTE
  SHORT
  INT
  LONG
  FLOAT
  DOUBLE
  DATE
  TIMESTAMP
  STRING
  BINARY
  DECIMAL
  INTERVAL
  ARRAY
  STRUCT
  MAP
  CHAR
  NULL
  USER_DEFINED_TYPE

```

#### databricks.statementexecution.models.ColumnInfoType_nameEnum.ColumnInfoType_nameEnum

```text
ColumnInfoType_nameEnum No description provided

    Documentation for databricks.statementexecution.models.ColumnInfoType_nameEnum
```

### databricks.statementexecution.models.Disposition

Superclass: databricks.statementexecution.JSONEnum

```text
Disposition The fetch disposition provides two modes of fetching results: `INLINE` and `EXTERNAL_LINKS`.  Statements executed with `INLINE` disposition will return result data inline, in `JSON_ARRAY` format, in a series of chunks. If a given statement produces a result set with a size larger than 16 MiB, that statement execution is aborted, and no result set will be available.  **NOTE** Byte limits are computed based upon internal representations of the result set data, and may not match the sizes visible in JSON responses.  Statements executed with `EXTERNAL_LINKS` disposition will return result data as external links: URLs that point to cloud storage internal to the workspace. Using `EXTERNAL_LINKS` disposition allows statements to generate arbitrarily sized result sets for fetching up to 100 GiB. The resulting links have two important properties:  1. They point to resources _external_ to the Databricks compute; therefore any associated authentication    information (typically a personal access token, OAuth token, or similar) _must be removed_ when fetching from these links.  2. These are presigned URLs with a specific expiration, indicated in the response. The behavior when attempting to use an expired link is cloud specific.
```

```text
Enumeration values:
  INLINE
  EXTERNAL_LINKS

```

#### databricks.statementexecution.models.Disposition.Disposition

```text
Disposition The fetch disposition provides two modes of fetching results: `INLINE` and `EXTERNAL_LINKS`.  Statements executed with `INLINE` disposition will return result data inline, in `JSON_ARRAY` format, in a series of chunks. If a given statement produces a result set with a size larger than 16 MiB, that statement execution is aborted, and no result set will be available.  **NOTE** Byte limits are computed based upon internal representations of the result set data, and may not match the sizes visible in JSON responses.  Statements executed with `EXTERNAL_LINKS` disposition will return result data as external links: URLs that point to cloud storage internal to the workspace. Using `EXTERNAL_LINKS` disposition allows statements to generate arbitrarily sized result sets for fetching up to 100 GiB. The resulting links have two important properties:  1. They point to resources _external_ to the Databricks compute; therefore any associated authentication    information (typically a personal access token, OAuth token, or similar) _must be removed_ when fetching from these links.  2. These are presigned URLs with a specific expiration, indicated in the response. The behavior when attempting to use an expired link is cloud specific.

    Documentation for databricks.statementexecution.models.Disposition
```

### databricks.statementexecution.models.ExecuteStatementRequest

Superclass: databricks.statementexecution.JSONMapper

```text
ExecuteStatementRequest No description provided
  
  ExecuteStatementRequest Properties:
    row_limit - Applies the given row limit to the statement's result set, but unlike the LIMIT clause in SQL, it also sets the truncated field in the response to indicate whether the result was trimmed due to the limit or not. - type: int64
    byte_limit - Applies the given byte limit to the statement''s result size. Byte counts are based on internal representations and may not match measurable sizes in the requested `format`.  - type: int64
    catalog - Sets default catalog for statement execution, similar to [`USE CATALOG`](https://docs.microsoft.com/azure/databricks/sql/language-manual/sql-ref-syntax-ddl-use-catalog.html) in SQL.  - type: string
    disposition - type: Disposition
    format - type: Format
    on_wait_timeout - type: TimeoutAction
    schema - Sets default schema for statement execution, similar to [`USE SCHEMA`](https://docs.microsoft.com/azure/databricks/sql/language-manual/sql-ref-syntax-ddl-use-schema.html) in SQL.  - type: string
    statement - SQL statement to execute - type: string
    wait_timeout - The time in seconds the API service will wait for the statement''s result set as `Ns`, where `N` can be set to 0 or to a value between 5 and 50. When set to ''0s'' the statement will execute in asynchronous mode.\"  - type: string
    warehouse_id - Warehouse upon which to execute a statement. See also [What are SQL warehouses?](https://docs.microsoft.com/azure/databricks/sql/admin/warehouse-type.html)  - type: string
```

#### databricks.statementexecution.models.ExecuteStatementRequest.ExecuteStatementRequest

```text
To allow proper nesting of object, derived objects must
  call the initialize method from their constructor. This 
  also allows objects to be instantiated with Name-Value pairs
  as inputs to set properties to specified values.

    Documentation for databricks.statementexecution.models.ExecuteStatementRequest
```

### databricks.statementexecution.models.ExternalLink

Superclass: databricks.statementexecution.JSONMapper

```text
ExternalLink No description provided
  
  ExternalLink Properties:
    byte_count - Number of bytes in the result chunk. - type: int64
    chunk_index - Position within the sequence of result set chunks. - type: int32
    expiration - Indicates date-time that the given external link will expire and become invalid, after which point a new `external_link` must be requested.  - type: datetime
    external_link - Pre-signed URL pointing to a chunk of result data, hosted by an external service, with a short expiration time (< 1 hour).  - type: string
    next_chunk_index - When fetching, gives `chunk_index` for the _next_ chunk; if absent, indicates there are no more chunks. - type: int32
    next_chunk_internal_link - When fetching, gives `internal_link` for the _next_ chunk; if absent, indicates there are no more chunks. - type: string
    row_count - Number of rows within the result chunk. - type: int64
    row_offset - Starting row offset within the result set. - type: int64
```

#### databricks.statementexecution.models.ExternalLink.ExternalLink

```text
To allow proper nesting of object, derived objects must
  call the initialize method from their constructor. This 
  also allows objects to be instantiated with Name-Value pairs
  as inputs to set properties to specified values.

    Documentation for databricks.statementexecution.models.ExternalLink
```

### databricks.statementexecution.models.Format

Superclass: databricks.statementexecution.JSONEnum

```text
Format Statement execution supports two result formats: `JSON_ARRAY` (default), and `ARROW_STREAM`.  **NOTE**  Currently `JSON_ARRAY` is only available for requests with `disposition=INLINE`, and `ARROW_STREAM` is only available for requests with `disposition=EXTERNAL_LINKS`.  When specifying `format=JSON_ARRAY`, result data will be formatted as an array of arrays of values, where each value is either the *string representation* of a value, or `null`. For example, the output of `SELECT concat(''id-'', id) AS strId, id AS intId FROM range(3)` would look like this:  ``` [   [ \"id-1\", \"1\" ],   [ \"id-2\", \"2\" ],   [ \"id-3\", \"3\" ], ] ```  `INLINE` `JSON_ARRAY` data can be found within `StatementResponse.result.chunk.data_array` or `ResultData.chunk.data_array`.  When specifying `format=ARROW_STREAM`, results fetched through `external_links` will be chunks of result data, formatted as Apache Arrow Stream. See [Apache Arrow Streaming Format](https://arrow.apache.org/docs/format/Columnar.html#ipc-streaming-format) for more details.
```

```text
Enumeration values:
  CSV
  JSON_ARRAY
  ARROW_STREAM

```

#### databricks.statementexecution.models.Format.Format

```text
Format Statement execution supports two result formats: `JSON_ARRAY` (default), and `ARROW_STREAM`.  **NOTE**  Currently `JSON_ARRAY` is only available for requests with `disposition=INLINE`, and `ARROW_STREAM` is only available for requests with `disposition=EXTERNAL_LINKS`.  When specifying `format=JSON_ARRAY`, result data will be formatted as an array of arrays of values, where each value is either the *string representation* of a value, or `null`. For example, the output of `SELECT concat(''id-'', id) AS strId, id AS intId FROM range(3)` would look like this:  ``` [   [ \"id-1\", \"1\" ],   [ \"id-2\", \"2\" ],   [ \"id-3\", \"3\" ], ] ```  `INLINE` `JSON_ARRAY` data can be found within `StatementResponse.result.chunk.data_array` or `ResultData.chunk.data_array`.  When specifying `format=ARROW_STREAM`, results fetched through `external_links` will be chunks of result data, formatted as Apache Arrow Stream. See [Apache Arrow Streaming Format](https://arrow.apache.org/docs/format/Columnar.html#ipc-streaming-format) for more details.

    Documentation for databricks.statementexecution.models.Format
```

### databricks.statementexecution.models.FreeFormObject

Superclass: dynamicprops

```text
Class methods
```

#### databricks.statementexecution.models.FreeFormObject.FreeFormObject

```text
Class methods

    Documentation for databricks.statementexecution.models.FreeFormObject
```

### databricks.statementexecution.models.ResultData

Superclass: databricks.statementexecution.JSONMapper

```text
ResultData Result data chunks are delivered in either the `chunk` field when using `INLINE` disposition, or in the `external_link` field when using `EXTERNAL_LINKS` disposition. Exactly one of these will be set. 
  
  ResultData Properties:
    byte_count - Number of bytes in the result chunk. - type: int64
    chunk_index - Position within the sequence of result set chunks. - type: int32
    data_array - `JSON_ARRAY` format is an array of arrays of values, where each non-null value is formatted as a string. Null values are encoded as JSON `null`.  - type: array of array
    external_links - type: array of ExternalLink
    next_chunk_index - When fetching, gives `chunk_index` for the _next_ chunk; if absent, indicates there are no more chunks. - type: int32
    next_chunk_internal_link - When fetching, gives `internal_link` for the _next_ chunk; if absent, indicates there are no more chunks. - type: string
    row_count - Number of rows within the result chunk. - type: int64
    row_offset - Starting row offset within the result set. - type: int64
```

#### databricks.statementexecution.models.ResultData.ResultData

```text
To allow proper nesting of object, derived objects must
  call the initialize method from their constructor. This 
  also allows objects to be instantiated with Name-Value pairs
  as inputs to set properties to specified values.

    Documentation for databricks.statementexecution.models.ResultData
```

### databricks.statementexecution.models.ResultManifest

Superclass: databricks.statementexecution.JSONMapper

```text
ResultManifest The result manifest provides schema and metadata for the result set.
  
  ResultManifest Properties:
    chunks - Array of result set chunk metadata. - type: array of ChunkInfo
    format - type: Format
    schema - type: ResultSchema
    total_byte_count - Total number of bytes in the result set. - type: int64
    total_chunk_count - Total number of chunks that the result set has been divided into. - type: int32
    total_row_count - Total number of rows in the result set. - type: int64
```

#### databricks.statementexecution.models.ResultManifest.ResultManifest

```text
To allow proper nesting of object, derived objects must
  call the initialize method from their constructor. This 
  also allows objects to be instantiated with Name-Value pairs
  as inputs to set properties to specified values.

    Documentation for databricks.statementexecution.models.ResultManifest
```

### databricks.statementexecution.models.ResultSchema

Superclass: databricks.statementexecution.JSONMapper

```text
ResultSchema Schema is an ordered list of column descriptions.
  
  ResultSchema Properties:
    column_count - type: int32
    columns - type: array of ColumnInfo
```

#### databricks.statementexecution.models.ResultSchema.ResultSchema

```text
To allow proper nesting of object, derived objects must
  call the initialize method from their constructor. This 
  also allows objects to be instantiated with Name-Value pairs
  as inputs to set properties to specified values.

    Documentation for databricks.statementexecution.models.ResultSchema
```

### databricks.statementexecution.models.ServiceError

Superclass: databricks.statementexecution.JSONMapper

```text
ServiceError No description provided
  
  ServiceError Properties:
    error_code - type: ServiceErrorCode
    message - Brief summary of error condition. - type: string
```

#### databricks.statementexecution.models.ServiceError.ServiceError

```text
To allow proper nesting of object, derived objects must
  call the initialize method from their constructor. This 
  also allows objects to be instantiated with Name-Value pairs
  as inputs to set properties to specified values.

    Documentation for databricks.statementexecution.models.ServiceError
```

### databricks.statementexecution.models.ServiceErrorCode

Superclass: databricks.statementexecution.JSONEnum

```text
ServiceErrorCode No description provided
```

```text
Enumeration values:
  UNKNOWN
  INTERNAL_ERROR
  TEMPORARILY_UNAVAILABLE
  IO_ERROR
  BAD_REQUEST
  SERVICE_UNDER_MAINTENANCE
  WORKSPACE_TEMPORARILY_UNAVAILABLE
  DEADLINE_EXCEEDED
  CANCELLED
  RESOURCE_EXHAUSTED
  ABORTED
  NOT_FOUND
  ALREADY_EXISTS
  UNAUTHENTICATED

```

#### databricks.statementexecution.models.ServiceErrorCode.ServiceErrorCode

```text
ServiceErrorCode No description provided

    Documentation for databricks.statementexecution.models.ServiceErrorCode
```

### databricks.statementexecution.models.StatementState

Superclass: databricks.statementexecution.JSONEnum

```text
StatementState Statement execution state: - `PENDING`: waiting for warehouse - `RUNNING`: running - `SUCCEEDED`: execution was successful, result data available for fetch - `FAILED`: execution failed; reason for failure described in accomanying error message - `CANCELED`: user canceled; can come from explicit cancel call, or timeout with `on_wait_timeout=CANCEL` - `CLOSED`: execution successful, and statement closed; result no longer available for fetch
```

```text
Enumeration values:
  PENDING
  RUNNING
  SUCCEEDED
  FAILED
  CANCELED
  CLOSED

```

#### databricks.statementexecution.models.StatementState.StatementState

```text
StatementState Statement execution state: - `PENDING`: waiting for warehouse - `RUNNING`: running - `SUCCEEDED`: execution was successful, result data available for fetch - `FAILED`: execution failed; reason for failure described in accomanying error message - `CANCELED`: user canceled; can come from explicit cancel call, or timeout with `on_wait_timeout=CANCEL` - `CLOSED`: execution successful, and statement closed; result no longer available for fetch

    Documentation for databricks.statementexecution.models.StatementState
```

### databricks.statementexecution.models.StatementStatus

Superclass: databricks.statementexecution.JSONMapper

```text
StatementStatus Status response includes execution state and if relevant, error information.
  
  StatementStatus Properties:
    error - type: ServiceError
    state - type: StatementState
```

#### databricks.statementexecution.models.StatementStatus.StatementStatus

```text
To allow proper nesting of object, derived objects must
  call the initialize method from their constructor. This 
  also allows objects to be instantiated with Name-Value pairs
  as inputs to set properties to specified values.

    Documentation for databricks.statementexecution.models.StatementStatus
```

### databricks.statementexecution.models.TimeoutAction

Superclass: databricks.statementexecution.JSONEnum

```text
TimeoutAction When in synchronous mode with `wait_timeout > 0s` it determines the action taken when the timeout is reached:  `CONTINUE` → the statement execution continues asynchronously and the call returns a statement ID immediately.  `CANCEL` → the statement execution is canceled and the call returns immediately with a `CANCELED` state.
```

```text
Enumeration values:
  CONTINUE
  CANCEL

```

#### databricks.statementexecution.models.TimeoutAction.TimeoutAction

```text
TimeoutAction When in synchronous mode with `wait_timeout > 0s` it determines the action taken when the timeout is reached:  `CONTINUE` → the statement execution continues asynchronously and the call returns a statement ID immediately.  `CANCEL` → the statement execution is canceled and the call returns immediately with a `CANCELED` state.

    Documentation for databricks.statementexecution.models.TimeoutAction
```

### databricks.statementexecution.models.executeStatement_200_response

Superclass: databricks.statementexecution.JSONMapper

```text
executeStatement_200_response No description provided
  
  executeStatement_200_response Properties:
    manifest - type: ResultManifest
    result - type: ResultData
    statement_id - Statement ID is returned upon successfully submitting a SQL statement, and is a required reference for all subsequent calls.  - type: string
    status - type: StatementStatus
```

#### databricks.statementexecution.models.executeStatement_200_response.executeStatement_200_response

```text
To allow proper nesting of object, derived objects must
  call the initialize method from their constructor. This 
  also allows objects to be instantiated with Name-Value pairs
  as inputs to set properties to specified values.

    Documentation for databricks.statementexecution.models.executeStatement_200_response
```

### databricks.statementexecution.BaseClient

Superclasses: handle, matlab.mixin.CustomDisplay

```text
BASECLIENT Base class for RESTful databricks.statementexecution services.
  Includes common initialization and authentication code. Authentication
  code may have to be manually updated after code generation.
 
  This class cannot be instantiated directly, work with classes derived
  from it to actually interact with the RESTful service.
```

#### databricks.statementexecution.BaseClient.BaseClient

```text
databricks.statementexecution.BaseClient constructor to be called from 
  derived classes to allow setting properties upon construction

    Documentation for databricks.statementexecution.BaseClient
```

#### databricks.statementexecution.BaseClient.applyCookies

```text
databricks.statementexecution.BaseClient/applyCookies is a function.
    request = applyCookies(obj, request, uri)
```

#### databricks.statementexecution.BaseClient.getPropertyGroups

```text
Redact properties such that tokens, etc. do not show up
  in Command Window output
```

#### databricks.statementexecution.BaseClient.loadConfigFile

```text
Loads client and http properties from a JSON file
```

#### databricks.statementexecution.BaseClient.postSend

```text
POSTSEND is called by every operation right after sending the
  request. This method can for example be customized to add
  customized error handling if the API responds to errors in a
  consistent way.
 
  If the responses of only a few operations need to be customized
  it is recommended to modify the generated operation methods
  in the Api classes themselves rather than modifying postSend.
 
  By default the generated postSend does not do anything, it just
  returns the response as is.
```

#### databricks.statementexecution.BaseClient.preSend

```text
PRESEND is called by every operation right before sending the
  request. This method can for example be customized to add a
  header to all (or most) requests if needed. 
 
  If the requests of only a few operations need to be customized
  it is recommended to modify the generated operation methods
  in the Api classes themselves rather than modifying preSend.
 
  By default the generated preSend does not do anything, it just
  returns the inputs as is.
```

#### databricks.statementexecution.BaseClient.requestAuth

```text
REQUESTAUTH will be called by operations which require 
  authentication. May have to be extended or modified after code 
  generation. For example, authentication methods not present in the
  service OpenAPI spec or methods not directly supported by the
  generator will have to be added. Generated logic may also not be
  100% correct if the OpenAPI spec contained multiple different 
  authentication methods of the same type.
```

#### databricks.statementexecution.BaseClient.setCookies

```text
databricks.statementexecution.BaseClient/setCookies is a function.
    setCookies(obj, history)
```

### databricks.statementexecution.CookieJar

Superclass: handle

```text
COOKIEJAR helper class in MATLAB Generator for OpenAPI package,
  provides a cookie jar. A cookie jar holds cookies which are typically 
  set by Set-Cookie headers in HTTP(S) requests and it can return the
  cookies which should be included in a request to a given URL.
 
  CookieJar Properties:
    path       - Directory where to save cookies.mat
 
  CookieJar Methods:
    setCookies - Adds cookies to the jar.
    getCookies - Return an array of cookies which match the given URL
 
    persist    - Forces cookie jar to be saved to disk
    load       - Forces cookie jar to be loaded from disk
    purge      - Empties the entire cookie jar and deletes cookies from
                 disk
```

#### databricks.statementexecution.CookieJar.CookieJar

```text
COOKIEJAR helper class in MATLAB Generator for OpenAPI package,
  provides a cookie jar. A cookie jar holds cookies which are typically 
  set by Set-Cookie headers in HTTP(S) requests and it can return the
  cookies which should be included in a request to a given URL.
 
  CookieJar Properties:
    path       - Directory where to save cookies.mat
 
  CookieJar Methods:
    setCookies - Adds cookies to the jar.
    getCookies - Return an array of cookies which match the given URL
 
    persist    - Forces cookie jar to be saved to disk
    load       - Forces cookie jar to be loaded from disk
    purge      - Empties the entire cookie jar and deletes cookies from
                 disk

    Documentation for databricks.statementexecution.CookieJar
```

#### databricks.statementexecution.CookieJar.getCookies

```text
GETCOOKIES returns an array of matlab.net.http.Cookie for the
  given URI which must be provided as first input.
```

#### databricks.statementexecution.CookieJar.load

```text
LOAD forces cookie jar to be loaded from disk. This method is
  also called automatically by the constructor. Can be called
  with a alternative directory as input to force saving
  cookies.mat to this alternative location. The CookieJar
  instance is then also reconfigured to continue working with
  this new location.
```

#### databricks.statementexecution.CookieJar.persist

```text
PERSIST forces cookie jar to be saved to disk. This method is
  also called automatically by setCookies if new cookies are
  added. Can be called with a alternative directory as input to
  force saving cookies.mat to this alternative location. The
  CookieJar instance is then also reconfigured to continue 
  working with this new location.
```

#### databricks.statementexecution.CookieJar.purge

```text
PURGE completely empties the cookie jar and also deletes
  cookies.mat from disk.
```

#### databricks.statementexecution.CookieJar.setCookies

```text
SETCOOKIES Adds cookies to the jar. Expects an array of
  matlab.net.http.CookieInfo as input. This can for example be
  obtained using matlab.net.http.CookieInfo.collectFromLog or
  by manually instantiating matlab.net.http.CookieInfo.
 
  See Also: matlab.net.http.CookieInfo.collectFromLog
```

### databricks.statementexecution.JSONDiscriminator

Superclass: handle

```text
JSONDISCRIMINATOR helper class used by databricks.statementexecution.JSONMapper
```

#### databricks.statementexecution.JSONDiscriminator.JSONDiscriminator

```text
JSONDISCRIMINATOR helper class used by databricks.statementexecution.JSONMapper

    Documentation for databricks.statementexecution.JSONDiscriminator
```

### databricks.statementexecution.JSONEnum

```text
JSONEnum Base class for enumerations when working with databricks.statementexecution.JSONMapper
  When adding enumeration properties to databricks.statementexecution.JSONMapper objects, the custom
  enumeration classes must inherit from this JSONEnum base class. And
  the custom enumeration class must declare string values for each enum
  element, these represent the JSON representation of the enumeration
  values; this is required since not all JSON values are guaranteed to
  be valid MATLAB variable names whereas the actual MATLAB enumeration
  values must be.
 
    Example:
 
      classdef myEnum < JSONEnum
          enumeration
              VAL1 ("VAL.1")
              VAL2 ("VAL.2")
          end
      end
 
  Even if JSON values are valid MATLAB variables, the string value must
  be provided, e.g.:
 
      classdef myEnum < JSONEnum
          enumeration
              VAL1 ("VAL1")
              VAL2 ("VAL2")
          end
      end
```

#### databricks.statementexecution.JSONEnum.JSONEnum

```text
JSONEnum Base class for enumerations when working with databricks.statementexecution.JSONMapper
  When adding enumeration properties to databricks.statementexecution.JSONMapper objects, the custom
  enumeration classes must inherit from this JSONEnum base class. And
  the custom enumeration class must declare string values for each enum
  element, these represent the JSON representation of the enumeration
  values; this is required since not all JSON values are guaranteed to
  be valid MATLAB variable names whereas the actual MATLAB enumeration
  values must be.
 
    Example:
 
      classdef myEnum < JSONEnum
          enumeration
              VAL1 ("VAL.1")
              VAL2 ("VAL.2")
          end
      end
 
  Even if JSON values are valid MATLAB variables, the string value must
  be provided, e.g.:
 
      classdef myEnum < JSONEnum
          enumeration
              VAL1 ("VAL1")
              VAL2 ("VAL2")
          end
      end

    Documentation for databricks.statementexecution.JSONEnum
```

#### databricks.statementexecution.JSONEnum.fromJSON

```text
databricks.statementexecution.JSONEnum/fromJSON is a function.
    v = fromJSON(obj, json)
```

### databricks.statementexecution.JSONMapper

Superclass: handle

```text
databricks.statementexecution.JSONMapper base class - adds JSON serialization and deserialization.
  Derive MATLAB classes from this class to allow them to be
  deserialized from JSON mapping the JSON fields to the class
  properties. To allow proper nesting of object, derived objects must
  call the initialize methods from their constructor:
  
  function obj = myClass(s,inputs)
      arguments
          s {databricks.statementexecution.JSONMapper.ConstructorArgument} = []
          inputs.?myClass
      end
      obj = obj.initialize(s,inputs);
  end
  Make sure to update the class name (myClass in the example) in both
  the function name as well as in the arguments block.
 
  During serialization or deserialization the MATLAB object definition
  is leading. JSON data is converted to MATLAB data types based on the
  type declaration in MATLAB. Therefore all properties of the MATLAB
  class *must* have a type declaration. Also, fields are only
  deserialized if they actually exist on the MATLAB class, any
  additional fields in the JSON input are ignored.
  
  Supported property datatypes: double, float, uint8, int8, uint16,
  int16, uint32, int32, uint64, int64, logical, enum, string, char,
  datetime (must be annotated), containers.Map, classes derived from
  databricks.statementexecution.JSONMapper.
 
  Annotations can be added to properties as "validation functions".
 
  databricks.statementexecution.JSONMapper Methods:
 
    fieldName      - Allows property to be mapped to a JSON field with 
                     different name.
    JSONArray      - Specifies field is a JSON array
    epochDatetime  - For datetime properties specifies in JSON the date
                     time is encoded as epoch. Must be the first
                     attribute if used.
    stringDatetime - For datetime properties specifies in JSON the date
                     time is encoded as string with a particular format.
                     Must be the first attribute if used.
    discriminator  - Indicates that the property acts as a discriminator based
                     upon which the JSON document can be deserialized to a more
                     specific derived class.
    doNotDecode    - For text properties specifies that the value should not
                     be decoded using a JSON parser.
```

#### databricks.statementexecution.JSONMapper.ConstructorArgument

```text
CONSTRUCTORARGUMENT to be used in derived constructors to
  allow string or char arrays as input and allows the
  constructor to be used when working with nested databricks.statementexecution.JSONMapper
  derived classes.
```

#### databricks.statementexecution.JSONMapper.JSONArray

```text
JSONARRAY databricks.statementexecution.JSONMapper Annotation
  Specified that the JSON field is an array.
 
  Ensures that when serializing a MATLAB scalar it is in fact
  encoded as a JSON array rather than a scalar if the property
  has been annotated with this option.
```

#### databricks.statementexecution.JSONMapper.JSONMapper

```text
databricks.statementexecution.JSONMapper Constructor. It is possible to call this from
  derived classes constructors, however in order to be able to
  build deeper class hierarchies it is recommended to call the
  initialize method instead.
 
  function obj = myClass(s,inputs)
      arguments
          s {databricks.statementexecution.JSONMapper.ConstructorArgument} = []
          inputs.?myClass
      end
      obj = obj.initialize(s,inputs);
  end
 
  Make sure to update the class name (myClass in the example) 
  in both the function name as well as in the arguments block.

    Documentation for databricks.statementexecution.JSONMapper
```

#### databricks.statementexecution.JSONMapper.discriminator

```text
DISCRIMINATOR databricks.statementexecution.JSONMapper Annotation
  This indicates that the property is a discriminator. Provide
  a list of value to class mappings as input.
```

#### databricks.statementexecution.JSONMapper.doNotDecode

```text
doNotDecode No-Op function to skip parsing
```

#### databricks.statementexecution.JSONMapper.epochDatetime

```text
EPOCHDATETIME databricks.statementexecution.JSONMapper Annotation
  When working with datetime fields either epochDatetime or
  stringDatetime annotation is required to specify how the
  datetime is encoded in JSON. This must be the first
  annotation.
 
  When called without inputs POSIX time/UNIX timestamp is
  assumed.
  
  Optional Name-Value pairs TimeZone, Epoch and TicksPerSecond
  can be provided (their meaning is the same as when working
  with datetime(d,'ConvertFrom','epochtime', OPTIONS).
 
  Example:
 
    properties
        % start_date is a UNIX timestamp
        start_date {databricks.statementexecution.JSONMapper.epochDatetime}
        % end_date is UNIX timestamp in milliseconds
        end_date {databricks.statementexecution.JSONMapper.epochDatetime(end_date,'TicksPerSecond',1000)}
    end
```

#### databricks.statementexecution.JSONMapper.fieldName

```text
FIELDNAME databricks.statementexecution.JSONMapper Annotation
  This can be added to properties if the MATLAB property name
  and JSON field name differ. For example, when the JSON field
  name is not a valid MATLAB identifier.
 
  Example:
 
    properties
        some_field {databricks.statementexecution.JSONMapper.fieldName(some_field,"some.field")}
    end
```

#### databricks.statementexecution.JSONMapper.fromJSON

```text
databricks.statementexecution.JSONMapper/fromJSON is a function.
    obj = fromJSON(obj, json)
    obj = fromJSON(obj, json, calledFromConstructor)
```

#### databricks.statementexecution.JSONMapper.getArrayPayload

```text
GETARRAYPAYLOAD JSON Encodes a scalar object or an array of
  objects into a JSON *array*.
 
  The method works similar to getPayload only it also works for
  arrays of objects and it also forces a scalar object to
  become a JSON array.
```

#### databricks.statementexecution.JSONMapper.getJSON2NATLABNameMap

```text
GETJSON2NATLABNAMEMAP Maps JSON field names to the corresponding MATLAB names
  Returns a containers.Map.
```

#### databricks.statementexecution.JSONMapper.getMATLAB2JSONNameMap

```text
GETMATLAB2JSONNAMEMAP Maps MATLAB field names to the corresponding JSON names
  Returns a containers.Map.
```

#### databricks.statementexecution.JSONMapper.getPayload

```text
GETPAYLOAD JSON encodes the object taking into account
  required and optional properties.
 
  Verifies that required properties have indeed been set.
  Includes optional properties in the output. All other
  properties are not included in the output.
```

#### databricks.statementexecution.JSONMapper.initialize

```text
INITIALIZE call this from derived classes to properly
  initialize the class instance.
```

#### databricks.statementexecution.JSONMapper.jsonencode

```text
JSONENCODE serializes object as JSON
  Can serialize whole hierarchies of objects if all classes
  in the hierarchy derive from databricks.statementexecution.JSONMapper.
  
  The function should only ever be called with one input: the
  object to be serialized. The second input is only meant to be
  used internally when jsonencode is called recursively.
 
  Example:
 
    json = jsonencode(obj);
```

#### databricks.statementexecution.JSONMapper.stringDatetime

```text
STRINGDATETIME databricks.statementexecution.JSONMapper Annotation
  When working with datetime fields either epochDatetime or
  stringDatetime annotation is required to specify how the
  datetime is encoded in JSON. This must be the first
  annotation.
 
  stringDatetime requires the string format as input.
  
  Optional Name-Value pair TimeZone can be provided.
 
  Example:
 
    properties
        start_date {databricks.statementexecution.JSONMapper.stringDatetime(start_date,'yyyy-MM-dd''T''HH:mm:ss')}
    end
```

### databricks.statementexecution.JSONMapperMap

Superclass: handle

```text
JSONMAPPERMAP Alternative to containers.Map for free-form key-value
  pairs. The advantage of JSONMAPPERMAP over containers.Map is that
  instances are not shared when used as a class property.
```

#### databricks.statementexecution.JSONMapperMap.JSONMapperMap

```text
JSONMAPPERMAP Constructor. Can be called with key value pairs
  as input to initialize the map with those keys and values.

    Documentation for databricks.statementexecution.JSONMapperMap
```

#### databricks.statementexecution.JSONMapperMap.disp

```text
DISP Displays keys and corresponding values in the map.
```

#### databricks.statementexecution.JSONMapperMap.jsonencode

```text
JSONENCODE JSON encodes the map.
```

#### databricks.statementexecution.JSONMapperMap.keys

```text
KEYS Returns the keys for the inner map
```

#### databricks.statementexecution.JSONMapperMap.subsasgn

```text
SUBSASGN Assign or update a key-value pair in the map.
```

#### databricks.statementexecution.JSONMapperMap.subsref

```text
SUBSREF retrieve a key value from the map.
```

#### databricks.statementexecution.JSONMapperMap.toKeyValuePairCell

```text
TOKEYVALUEPAIRCELL Returns a cell array of key value pairs
```

#### databricks.statementexecution.JSONMapperMap.values

```text
VALUES Returns the values for the inner map
```

### databricks.statementexecution.JSONPropertyInfo

Superclass: handle

```text
JSONPROPERTYINFO class used by databricks.statementexecution.JSONMapper internally
```

#### databricks.statementexecution.JSONPropertyInfo.JSONPropertyInfo

```text
JSONPROPERTYINFO class used by databricks.statementexecution.JSONMapper internally

    Documentation for databricks.statementexecution.JSONPropertyInfo
```

#### databricks.statementexecution.JSONPropertyInfo.getPropertyInfo

```text
For all public properties
```

### databricks.Apps

Superclass: databricks.Object

```text
Apps Databricks Apps API
 
  See also: https://docs.databricks.com/api/workspace/apps
```

#### databricks.Apps.Apps

```text
Apps Databricks Apps API
 
  See also: https://docs.databricks.com/api/workspace/apps

    Documentation for databricks.Apps
```

#### databricks.Apps.createApp

```text
CREATEAPP Method to create a new app
```

#### databricks.Apps.createDeployment

```text
CREATEDEPLOYMENT Method to create a new app deployment
 
  Example:
    a = databricks.Apps;
    cdr = databricks.datastructures.apps.CreateDeploymentRequest;
    cdr.sourceCodePath = "/Workspace/Users/mbrowne@mathworks.com/databricks_apps/dbx-hello-world_2026_05_01-11_53/nodejs-fastapi-hello-world-app"
    [result, errorResponse] = a.createDeployment("my-example-app", cdr)
```

#### databricks.Apps.deleteApp

```text
DELETEAPP Method to delete an app
```

#### databricks.Apps.deleteThumbnail

```text
DELETETHUMBNAIL Method to delete an app thumbnail
 
  Example:
    apps = databricks.Apps;
    [result, errorResponse] = deleteThumbnail(apps, "myAppName");
 
  See also: https://docs.databricks.com/api/apps/v1/delete-app-thumbnail
```

#### databricks.Apps.getApp

```text
GETAPP Method to get an app
```

#### databricks.Apps.getDeployment

```text
GETDEPLOYMENT Method to get an app deployment
```

#### databricks.Apps.listAppsPage

```text
listAppsPage Retrieves a list of apps, one page at a time.
  Returns an array of databricks.datastructures.apps.ListAppResult objects and
  a databricks.datastructures.ErrorResponse object.
 
  Example:
    a = databricks.App();
    [result, errorResponse] = a.listAppsPage("myapp");
 
  Optional arguments:
       pageSize: Upper bound for items returned.
      pageToken: Token for pagination
 
  See also: databricks.Apps.listAppsPages
            https://docs.databricks.com/api/workspace/apps/list
```

#### databricks.Apps.listDeploymentPage

```text
listDeploymentPage Retrieves a list of apps, one page at a time.
  Returns an array of databricks.datastructures.apps.ListDeploymentResult objects and
  a databricks.datastructures.ErrorResponse object.
 
  Example:
    a = databricks.App();
    [result, errorResponse] = a.listDeploymentPage("myapp");
 
  Optional arguments:
       pageSize: Upper bound for items returned.
      pageToken: Token for pagination
 
  See also: databricks.Apps.listPages
            https://docs.databricks.com/api/workspace/apps/listdeployments
```

#### databricks.Apps.listDeploymentPages

```text
listDeploymentPages Retrieves a list of all matching app.
  This method supports pagination and will retrieve all pages.
  This may have performance implications for large result sets.
  Returns an array of databricks.datastructures.apps.AppDeployment and
  a databricks.datastructures.ErrorResponse.
 
  Example:
    a = databricks.Apps;
    [result, errorResponse] = a.listDeploymentPages()
 
  Optional arguments:
       pageSize: Upper bound for items returned.
      pageToken: Token for pagination
 
  See also: databricks.Apps.listDeploymentPage
            https://docs.databricks.com/api/workspace/apps/listdeployments
```

#### databricks.Apps.start

```text
START Method to start an app
```

#### databricks.Apps.stop

```text
STOP Method to Stop an app
```

#### databricks.Apps.updateThumbnail

```text
UPDATETHUMBNAIL Method to update an app thumbnail
 
  Images PNG or JPEG format. 250KB or less in size, The recommended size is:
  640 x 360 pixels.
 
    Note the Databricks API does not currently return a thumbnail string as
    documented. However for this method a empty errorResponse can be
    used to indicate success.
 
  Example:
    apps = databricks.Apps;
    [result, errorResponse] = updateThumbnail(apps, "myAppName", "C:\temp\my_thumbnail_604x360.png");
 
  See also: https://docs.databricks.com/api/apps/v1/update-app-thumbnail
```

### databricks.BaseTask

Superclasses: databricks.Object, matlab.mixin.Heterogeneous, matlab.mixin.CustomDisplay

```text
BASETASK Base class for Databricks tasks
 
  This abstract class serves as a base task for concrete Databricks
  tasks, like SparkJarTask, SparkSubmitTask, NotebookTask., MATLABBatchTask
  and MATLABRuntimeTask
 
  SparkSubmitTask is deprecated and should no longer be used see:
  https://docs.databricks.com/aws/en/jobs/spark-submit
  Existing support will be removed in a future release
```

#### databricks.BaseTask.BaseTask

```text
BASETASK Base class for Databricks tasks
 
  This abstract class serves as a base task for concrete Databricks
  tasks, like SparkJarTask, SparkSubmitTask, NotebookTask., MATLABBatchTask
  and MATLABRuntimeTask
 
  SparkSubmitTask is deprecated and should no longer be used see:
  https://docs.databricks.com/aws/en/jobs/spark-submit
  Existing support will be removed in a future release

    Documentation for databricks.BaseTask
```

#### databricks.BaseTask.escapeDoubleBackSlashes

```text
ESCAPEBACKSLASHES Escape \\ with \\\ for shell execution
```

#### databricks.BaseTask.escapeDoubleQuotes

```text
ESCAPEDOUBLEQUOTES Escape " with \" for shell execution
```

#### databricks.BaseTask.escapeSingleQuotes

```text
ESCAPESINGLEQUOTES Single quotes in the scalar string are escaped with slashes
  not additional single quotes.
  This is intended for use with shell commands.
  Double quotes are not altered by this function.
```

#### databricks.BaseTask.getPropertyGroups

```text
GETPROPERTYGROUPS Customize the display of task objects
  Renders the Notebook URL as a clickable link
```

#### databricks.BaseTask.getTaskEntries

```text
databricks.BaseTask/getTaskEntries is a function.
    obj = databricks.BaseTask
```

#### databricks.BaseTask.notebookPath2Link

```text
databricks.BaseTask/notebookPath2Link is a function.
    link = notebookPath2Link(obj)
    link = notebookPath2Link(___, Name, Value)
```

#### databricks.BaseTask.notebookPath2URI

```text
databricks.BaseTask/notebookPath2URI is a function.
    uri = notebookPath2URI(obj)
    uri = notebookPath2URI(___, Name, Value)
```

#### databricks.BaseTask.shellEscape

```text
TODO To be validated
```

### databricks.Cluster

Superclass: databricks.Object

```text
CLUSTER Databricks Cluster API
  The Clusters API allows you to create, start, edit, list, terminate, and
  delete clusters. The maximum allowed size of a request to the Clusters
  API is 10MB.
 
  Cluster life-cycle methods require a cluster ID, which is returned from
  Create. To obtain a list of clusters, invoke List.
 
  Databricks maps cluster node instance types to compute units known as
  DBUs. See the Databricks instance type pricing page for a list of the
  supported instance types and their corresponding DBUs.
 
    cl = databricks.Cluster;
 
  Will use the standard configuration file for initialization.
  Alternatively, to specify host and token:
 
    cl = databricks.Cluster('Host','https://databrickshost.abc.com', 'Token', 'abc123');
 
  Or, with a specific authentication method and or profile name:
 
    cl = databricks.Cluster('authMethod', matlab.databricks.AuthMethod.PAT, 'profileName', 'DEV');
```

#### databricks.Cluster.Cluster

```text
databricks.Cluster
 
   Create cluster object using default configuration file.
    obj = databricks.Cluster()
 
   Create cluster object using named values.
    obj = databricks.Cluster('Host', 'https://databrickshost.abc.com', 'Token', '123abc')

    Documentation for databricks.Cluster
```

#### databricks.Cluster.changeOwner

```text
CHANGEOWNER Change the owner of the cluster.
  
  You must be an admin and the cluster must be terminated to perform this
  operation. The service principal application ID can be supplied as an 
  argument to changeOwner.
 
  Updates the cluster creator_user_name to the assigned name.
  The single_user_name and assigned_principal values are not updated.
  
  Example:
    
    % Change a cluster owner's name
    c = databricks.Cluster.findByName('myClusterName');
    [result, errorResponse] = c.changeOwner("joe@example.com");
```

#### databricks.Cluster.create

```text
CREATE Method to create a new Spark cluster
  Create a new Spark cluster. This method acquires new instances from the
  cloud provider if necessary. This method is asynchronous; the returned
  cluster_id can be used to poll the cluster state.
 
  When this method returns, the cluster is in a PENDING state. The cluster
  is usable once it enters a RUNNING state.
 
    cl = databricks.Cluster();
    cl.cluster_name = 'Test Cluster';
    cl.setNumWorkers([2 10]); % autoscaling cluster
    cl.create();
```

#### databricks.Cluster.edit

```text
EDIT Updates the configuration of a cluster to match the provided attributes
 
  A cluster can be updated if it is in a RUNNING or TERMINATED state.
  If a cluster is updated while in a RUNNING state, it will be restarted so
  that the new attributes can take effect.
  If a cluster is updated while in a TERMINATED state, it will remain
  TERMINATED. The next time it is started using the clusters/start API, the
  new attributes will take effect. Any attempt to update a cluster in any
  other state will be rejected with an INVALID_STATE error code.
  Clusters created by the Databricks Jobs service cannot be edited.
  
  Examples:
    
    % Change a cluster name
    c = databricks.Cluster.findByName('myOldName');
    c.edit('cluster_name', 'myNewName');
 
    % Configure an init script on a cluster
    c = databricks.Cluster.findById('0707-134216-f5g3rsp8');
    installScriptPath = '/Users/username@example.com/MathWorks/1.4.1/runtime/runtime_install_r2023a.sh';
    wsi = databricks.datastructures.WorkspaceStorageInfo(installScriptPath);
    is = databricks.InitScriptInfo;
    is.setDestination(wsi);
    c.edit('init_scripts', is);
 
 
  Supported parameters:
 
              num_workers : Number of worker nodes that this cluster should have
                            Type: int32
 
                autoscale : Automatically scale clusters up and down based on load
                            Type: [min_workers, max_workers], where both values are int32
 
             cluster_name : Cluster name requested by the user
                            Type: char or scalar string
           
            spark_version : The Spark version of the cluster, e.g. 3.3.x-scala2.11
                            Type: char or scalar string
 
               spark_conf : An object containing a set of optional, user-specified Spark configuration key-value pairs
                            Type: databricks.SparkConfPair
 
             node_type_id : VM sku
                            Type: char or scalar string
            
       driver_node_type_id: VM sku
                            Type: char or scalar string
        
         cluster_log_conf : The configuration for delivering spark logs to a long-term storage destination
                            Type: databricks.ClusterLogConf
 
              init_scripts: Array of init script destinations
                            Type: databricks.InitScriptInfo
      
  autotermination_minutes : Terminates the cluster after it is inactive, in minutes
                            Type: int32
 
      enable_elastic_disk : Autoscaling Local Storage
                            Type: logical
 
           cluster_source : Determines how the cluster was created
                            Valid values: "UI" "JOB" "API" "SQL" "MODELS" "PIPELINE" "PIPELINE_MAINTENANCE"
                            Type: char or scalar string
 
         instance_pool_id : The optional ID of the instance pool to which the cluster belongs
                            Type: char or scalar string
 
                policy_id : The ID of the cluster policy used to create the cluster if applicable
                            Type: char or scalar string
 
  enable_local_disk_encryption : Whether to enable LUKS on cluster VMs' local disks
                                 Type: logical
 
  driver_instance_pool_id : The optional ID of the instance pool for the driver of the cluster belongs
                            Type: char or scalar string
 
           runtime_engine : Decides which runtime engine to be use, e.g. Standard vs. Photon
                            Type: char or scalar string, valid values: "NULL" "STANDARD" "PHOTON"
                                  or databricks.datastructures.DataSecurityMode
 
       data_security_mode : Valid values databricks.datastructures.DataSecurityMode.[NONE | SINGLE_USER
                            | USER_ISOLATION | LEGACY_TABLE_ACL | LEGACY_PASSTHROUGH | LEGACY_SINGLE_USER]
                            Type: databricks.datastructures.DataSecurityMode
 
         single_user_name : Single user name if data_security_mode is SINGLE_USER
                            Type: char or scalar string
 
               cluster_id : Required string, ID of the cluster
                            Type: char or scalar string
 
   apply_policy_default_values : This field won't be true for webapp requests
                                 Only API users will check this field
                                 Type: logical
 
 
  Currently unsupported parameters:
     aws_attributes
     ssh_public_keys
     custom_tags
     workload_type
     docker_image
 
  An updated databricks.Cluster object is returned.
 
  For more information see: https://docs.databricks.com/api/workspace/clusters/edit
 
  See Also: databricks.Cluster.create
```

#### databricks.Cluster.enableMATLABRuntime

```text
ENABLEMATLABRUNTIME Configures usage of the MATLAB runtime
 
  Init scripts are not supported on Databricks runtimes 17.0 and later,
  an error will be returned. Use Databricks Container Services (Docker)
  instead.
  
  This method supports a number of optional name value pair parameters.
 
           enableLogging: Set to true to turn on logging of the init scripts
                          including the runtime install. Default is
                          false.
 
                 logDir : The location to which logs are written, the default is:
                          dbfs:/cluster-logs
                          If using /Volumes (Public Preview) additional
                          restrictions apply.
                          See: https://docs.databricks.com/aws/en/compute/configure#compute-log-delivery
 
      interfaceDirectory: /Volumes path under which MathWorks files are stored.
 
          initscriptPath: An init script path, path may begin with /Volumes,
                          /Users, /Shared, s3:// or abfss://.
                          If an initscriptPath is given and the file is not found,
                          an attempt will be made to upload the local copy script
                          included in the package to the specified
                          path. Uploads are only supported to /Volumes,
                          /Users & /Shared.
 
                 release: MATLAB release of the form R2024b for the runtime to install.
                          By default the release of MATLAB in use is used.
 
             runtimePath: Specify a path to a MATLAB runtime .zip file.
                          /Volumes and http paths are supported.
                          Example:
                            /Volumes/main/default/myvolume/MathWorks/runtimes/MATLAB_Runtime_R2024b_glnxa64.zip
 
                 mcrRoot: Path to the installed MATLAB runtime root, default
                          is "/MATLAB_Runtime".
 
              authMethod: A matlab.databricks.AuthMethod
 
             profileName: A configuration file profileName value
 
                 verbose: Enable additional feedback. Default is true.
 
 
  Examples
     % Typical values, enable the runtime init script, enable logging & configure
     % Spark environment variables
     cl = databricks.Cluster;
     cl.enableMATLABRuntime('enableLogging', true);
 
     % Create and install script and upload it, not using default directory to
     % avoid trampling on a production script e.g. if testing a new runtime
     cl = databricks.Cluster;
     cl.enableMATLABRuntime('initscriptPath', '/Users/username@example.com/MathWorks/runtime_install.sh');
```

#### databricks.Cluster.findById

```text
FINDBYID Method to find a cluster by id
  Locate a databricks cluster by id
 
  Required argument
    clId    A scalar text cluster Id
 
  Optional named arguments
    authMethod     A matlab.databricks.AuthMethod
    profileName    A configuration file profileName value
 
  For example:
 
  cl = databricks.Cluster.findById('0928-104326-ul6a0cn9')
  cl =
    Cluster with properties:
 
                     cluster_name: 'Mumindalen'
                     node_type_id: 'Standard_DS3_v2'
                    spark_version: '10.4.x-scala2.12'
                       spark_conf: [4x1 containers.Map]
                       start_time: 28-Sep-2022 10:43:26
             last_state_loss_time: 29-Sep-2022 15:11:14
                 azure_attributes: [1x1 struct]
               last_activity_time: 29-Sep-2022 15:10:56
              last_restarted_time: 29-Sep-2022 15:11:14
              driver_node_type_id: 'Standard_DS3_v2'
              enable_elastic_disk: 1
          autotermination_minutes: 120
                      num_workers: 0
                        disk_spec: [1x1 struct]
                  terminated_time: 29-Sep-2022 17:11:00
                   cluster_source: 'UI'
               termination_reason: [1x1 struct]
                     default_tags: [1x1 struct]
     enable_local_disk_encryption: 0
           init_scripts_safe_mode: 0
                  instance_source: [1x1 struct]
                       cluster_id: '0928-104326-ul6a0cn9'
                   spark_env_vars: [1x1 containers.Map]
           driver_instance_source: [1x1 struct]
                      custom_tags: [1x1 struct]
                creator_user_name: 'joeuser@example.com'
                            state: 'TERMINATED'
          effective_spark_version: '10.4.x-scala2.12'
                    state_message: 'Inactive cluster terminated (inactive for 120 minutes).'
                 spark_context_id: 7382155561119740546
```

#### databricks.Cluster.findByName

```text
FINDBYNAME Method to find a cluster by name
  Locate a Databricks cluster by name.
 
  Required argument
    clName    A scalar text cluster name
 
  Optional named arguments
    authMethod     A matlab.databricks.AuthMethod
    profileName    A configuration file profileName value
 
  Example:
 
    cl = databricks.Cluster.findByName('Databricks Demo');
```

#### databricks.Cluster.getClusterVersionSemVer

```text
GETCLUSTERVERSIONSEMVER Get the runtime version of the cluster as a semantic version
  If the version cannot be determined an empty SemVer is returned.
```

#### databricks.Cluster.getClusterVersionString

```text
GETCLUSTERRUNTIMEVERSION Returns the numeric form of a cluster runtime e.g. 16.4
  Errors if the cluster is empty.
  Errors if the cluster spark_version property is missing or not set.
```

#### databricks.Cluster.getEvents

```text
GETEVENTS Method to list the cluster events
  Retrieve a list of events about the activity of a cluster.
  
  For example:
    
    db = databricks.Cluster;
    db.setClusterId('0712-182938-knows476');
    ev = db.getEvents();
  
    ev =
  
    13x4 table
  
            cluster_id          timestamp              type                details   
      ______________________    __________    _______________________    ____________
  
      '0712-182938-knows476'    1.5632e+12    'DRIVER_HEALTHY'           [1x1 struct]
      '0712-182938-knows476'    1.5632e+12    'RUNNING'                  [1x1 struct]
      '0712-182938-knows476'    1.5632e+12    'INIT_SCRIPTS_FINISHED'    [1x1 struct]
      '0712-182938-knows476'    1.5632e+12    'INIT_SCRIPTS_STARTED'     [1x1 struct]
      '0712-182938-knows476'    1.5632e+12    'STARTING'                 [1x1 struct]
      '0712-182938-knows476'     1.563e+12    'TERMINATING'              [1x1 struct]
      '0712-182938-knows476'     1.563e+12    'DRIVER_UNAVAILABLE'       [1x1 struct]
      '0712-182938-knows476'     1.563e+12    'DRIVER_HEALTHY'           [1x1 struct]
      '0712-182938-knows476'     1.563e+12    'DRIVER_HEALTHY'           [1x1 struct]
      '0712-182938-knows476'     1.563e+12    'RUNNING'                  [1x1 struct]
      '0712-182938-knows476'     1.563e+12    'INIT_SCRIPTS_FINISHED'    [1x1 struct]
      '0712-182938-knows476'     1.563e+12    'INIT_SCRIPTS_STARTED'     [1x1 struct]
      '0712-182938-knows476'     1.563e+12    'CREATING'                 [1x1 struct]
```

#### databricks.Cluster.getNodeTypes

```text
GETNODETYPES Method to get a table of node types
  Return a table of supported Spark node types. These node types can be used
  to launch a cluster.
 
  Optional named arguments
    authMethod     A matlab.databricks.AuthMethod
    profileName    A configuration file profileName value
 
  Example:
 
    nodeList = databricks.Cluster.getNodeTypes;
 
    nodeList =
  367x20 table
   node_type_id      memory_mb     num_cores            description            instance_type_id    is_deprecated          category          support_ebs_volumes    support_cluster_tags    num_gpus    node_instance_type    is_hidden    support_port_forwarding    display_order    is_io_cache_enabled    photon_worker_capable    photon_driver_capable    is_encrypted_in_transit    is_graviton    require_fabric_manager
  ________________    __________    _________    ___________________________    ________________    _____________    ____________________    ___________________    ____________________    ________    __________________    _________    _______________________    _____________    ___________________    _____________________    _____________________    _______________________    ___________    ______________________
  {'r3.xlarge'   }         31232        4        {'r3.xlarge (deprecated)' }    {'r3.xlarge'   }        true         {'Memory Optimized'}           true                   true                0            1x1 struct          true                true                    1                 false                   false                    false                     false                false               false         
  {'r3.2xlarge'  }         62464        8        {'r3.2xlarge (deprecated)'}    {'r3.2xlarge'  }        true         {'Memory Optimized'}           true                   true                0            1x1 struct          true                true                    1                 false                   false                    false                     false                false               false         
  {'r3.4xlarge'  }    1.2493e+05       16        {'r3.4xlarge (deprecated)'}    {'r3.4xlarge'  }        true         {'Memory Optimized'}           true                   true                0            1x1 struct          true                true                    1                 false                   false                    false                     false                false               false         
     [TRUNCATED]
```

#### databricks.Cluster.getPayload

```text
GETPAYLOAD Internal method to create the request payload by removing properties
```

#### databricks.Cluster.getSparkVersions

```text
GETSPARKVERSIONS Method to fetch the available spark versions
  Return the list of available Spark versions. These versions can be used
  to launch a cluster.
 
  Optional named arguments
    authMethod     A matlab.databricks.AuthMethod
    profileName    A configuration file profileName value
 
  Example:
 
    cl = databricks.Cluster;
    sparkVer = cl.getSparkVersions();
 
    sparkVer =
    55x2 table
                    key                                               name                             
      ________________________________    _____________________________________________________________
      "10.4.x-cpu-ml-scala2.12"           "10.4 LTS ML (includes Apache Spark 3.2.1, Scala 2.12)"      
      "10.4.x-gpu-ml-scala2.12"           "10.4 LTS ML (includes Apache Spark 3.2.1, GPU, Scala 2.12)" 
      "10.4.x-photon-scala2.12"           "10.4 LTS Photon (includes Apache Spark 3.2.1, Scala 2.12)"  
      "10.4.x-scala2.12"                  "10.4 LTS (includes Apache Spark 3.2.1, Scala 2.12)"         
      "11.3.x-cpu-ml-scala2.12"           "11.3 LTS ML (includes Apache Spark 3.3.0, Scala 2.12)"      
      "11.3.x-gpu-ml-scala2.12"           "11.3 LTS ML (includes Apache Spark 3.3.0, GPU, Scala 2.12)" 
      "11.3.x-photon-scala2.12"           "11.3 LTS Photon (includes Apache Spark 3.3.0, Scala 2.12)"  
      "11.3.x-scala2.12"                  "11.3 LTS (includes Apache Spark 3.3.0, Scala 2.12)"         
      "12.2.x-cpu-ml-scala2.12"           "12.2 LTS ML (includes Apache Spark 3.3.2, Scala 2.12)"      
      "12.2.x-gpu-ml-scala2.12"           "12.2 LTS ML (includes Apache Spark 3.3.2, GPU, Scala 2.12)" 
      "12.2.x-photon-scala2.12"           "12.2 LTS Photon (includes Apache Spark 3.3.2, Scala 2.12)"  
                     :                                                  :                              
      "15.4.x-photon-scala2.12"           "15.4 LTS Photon (includes Apache Spark 3.5.0, Scala 2.12)"  
      "15.4.x-scala2.12"                  "15.4 LTS (includes Apache Spark 3.5.0, Scala 2.12)"         
      "16.0.x-cpu-ml-photon-scala2.12"    "16.0 ML Beta (includes Apache Spark 3.5.0, Scala 2.12)"     
      "16.0.x-cpu-ml-scala2.12"           "16.0 ML Beta (includes Apache Spark 3.5.0, Scala 2.12)"     
      "16.0.x-gpu-ml-scala2.12"           "16.0 ML Beta (includes Apache Spark 3.5.0, GPU, Scala 2.12)"
      "16.0.x-photon-scala2.12"           "16.0 Photon Beta (includes Apache Spark 3.5.0, Scala 2.12)" 
      "16.0.x-scala2.12"                  "16.0 Beta (includes Apache Spark 3.5.0, Scala 2.12)"        
      "9.1.x-cpu-ml-scala2.12"            "9.1 LTS ML (includes Apache Spark 3.1.2, Scala 2.12)"       
      "9.1.x-gpu-ml-scala2.12"            "9.1 LTS ML (includes Apache Spark 3.1.2, GPU, Scala 2.12)"  
      "9.1.x-photon-scala2.12"            "9.1 LTS Photon (includes Apache Spark 3.1.2, Scala 2.12)"   
      "9.1.x-scala2.12"                   "9.1 LTS (includes Apache Spark 3.1.2, Scala 2.12)"          
      Display all 55 rows.
```

#### databricks.Cluster.getZones

```text
GETZONES Method to get the available zones
  Return a list of availability zones where clusters can be created in 
  (ex: us-west-2a). These zones can be used to launch a cluster.
  
  For example:
  
    cl = databricks.Cluster();
    zoneList = cl.getZones;
  
    zoneList = 
  
        2x1 table
  
             Zones    
          ____________
  
          'us-west-1a'
          'us-west-1c'
```

#### databricks.Cluster.list

```text
LIST Create a list of databricks clusters
  This method can be used to create a list of all available Databricks clusters.
 
    cl = databricks.Cluster.list();
 
  The returned cluster(s) will provide a handle to Databricks.
 
  Optional named arguments
    authMethod     A matlab.databricks.AuthMethod
    profileName    A configuration file profileName value
 
  Example:
 
   clusters = databricks.Cluster.list
   clusters = 
     1x32 Cluster array with properties:
 
       cluster_name
       node_type_id
       spark_version
       spark_conf
 
   clusters(1)
   ans = 
     Cluster with properties:
 
                       cluster_name: 'Mumindalen'
                       node_type_id: 'Standard_DS3_v2'
                      spark_version: '10.4.x-scala2.12'
                         spark_conf: [2x1 containers.Map]
                         start_time: 30-Sep-2022 08:46:12
               last_state_loss_time: 01-Jan-1970
                   azure_attributes: [1x1 struct]
                 last_activity_time: 30-Sep-2022 09:39:59
                last_restarted_time: 30-Sep-2022 08:52:48
                driver_node_type_id: 'Standard_DS3_v2'
                enable_elastic_disk: 1
                   cluster_log_conf: [1x1 struct]
            autotermination_minutes: 120
                        num_workers: 2
                       init_scripts: [1x1 struct]
                          disk_spec: [1x1 struct]
                    terminated_time: 30-Sep-2022 11:40:28
                     cluster_source: 'UI'
                 cluster_log_status: [1x1 struct]
                 termination_reason: [1x1 struct]
                       default_tags: [1x1 struct]
       enable_local_disk_encryption: 0
             init_scripts_safe_mode: 0
                    instance_source: [1x1 struct]
                         cluster_id: '0930-084612-uurhdujo'
                     spark_env_vars: [2x1 containers.Map]
             driver_instance_source: [1x1 struct]
                  creator_user_name: 'joeuser@example.com'
                              state: 'TERMINATED'
            effective_spark_version: '10.4.x-scala2.12'
                      state_message: 'Inactive cluster terminated (inactive for 120 minutes).'
                   spark_context_id: 7430983140709072285
```

#### databricks.Cluster.permanentDelete

```text
PERMANENTDELETE Method to permanently delete a cluster
  Permanently delete a cluster. If the cluster is running, it is terminated
  and its resources are asynchronously removed. If the cluster is terminated,
  then it is immediately removed.
 
  Once permanently deleted, all actions on a permanently deleted cluster
  are disallowed, including retrieval of the cluster’s
  permissions.
 
  A permanently deleted cluster is also no longer returned in the cluster list.
 
  To permanently delete a cluster.
 
    cl = databricks.Cluster;
    cl.setClusterId('0619-223319-surfs255');
    cl.permanentDelete();
```

#### databricks.Cluster.refresh

```text
REFRESH Method to refresh information about a Spark cluster
  Refresh information about a new cluster. This method is asynchronous;
  the returned cluster_id can be used to poll the cluster state.
 
    cl = databricks.Cluster();
    cl.cluster_name = 'Test Cluster';
    cl.setNumWorkers(3); % Number of workers
    cl.create();
    cl.refresh();
 
  The resulting structure contains information about the cluster.
 
    cl =
 
    Cluster with properties:
 
                  cluster_name: 'Test Cluster'
                  node_type_id: 'Standard_DS3_v2'
                 spark_version: '10.4.x-scala2.12'
                    spark_conf: [1x1 struct]
       effective_spark_version: '10.4.x-scala2.12'
                 state_message: ''
                spark_env_vars: [1x1 struct]
                    start_time: 30-May-2022 14:21:07
                        driver: [1x1 struct]
          last_state_loss_time: 01-Jan-1970
                   custom_tags: [1x1 struct]
           last_restarted_time: 30-May-2022 14:24:16
                runtime_engine: 'STANDARD'
              spark_context_id: 6867261915688657682
                     jdbc_port: 10000
                   num_workers: 3
           driver_node_type_id: 'Standard_DS3_v2'
             cluster_memory_mb: 14336
                    cluster_id: '0530-142107-k9i1yrat'
           enable_elastic_disk: 1
                 cluster_cores: 4
                     disk_spec: [1x1 struct]
                         state: 'RUNNING'
                cluster_source: 'UI'
                  default_tags: [1x1 struct]
             creator_user_name: 'user@example.com'
  enable_local_disk_encryption: 0
              azure_attributes: [1x1 struct]
        init_scripts_safe_mode: 0
               instance_source: [1x1 struct]
       autotermination_minutes: 120
        driver_instance_source: [1x1 struct]
```

#### databricks.Cluster.restart

```text
RESTART Method to restart a running databricks cluster
  Restart a running Spark cluster. If the cluster is not in a RUNNING
  state, nothing will happen.
  
  To start a cluster:
    
    cl.restart();
  
  For example,
    
    % List all available clusters
    cl = databricks.Cluster.list();
    
    % Check the state to ensure that it is terminated
    cl(1).state
        
    ans =
  
        'RUNNING'    
  
    % Start the cluster
    cl(1).restart();
```

#### databricks.Cluster.setAutoterminationMinutes

```text
SETAUTOTERMINATIONMINUTES Method to set the auto-termination for clusters
  Setting the autotermination minutes for the cluster by setting the
  property on the cluster object. This automatically terminates the cluster
  after it is inactive for this time in minutes. 
  
  If not set, this cluster will not be automatically terminated. 
  If specified, the threshold must be between 10 and 10000 minutes. 
  If this value is set to 0, it will explicitly disable automatic termination.
  
    cl = databricks.Cluster;
    cl.setAutoterminationMinutes(100);
```

#### databricks.Cluster.setClusterId

```text
SETCLUSTERID Method to set a cluster_id to a cluster handle
  Set the cluster id for a cluster handle.
 
    cl = databricks.Cluster()
    cl.setClusterId('0531-031912-trill440');
 
  The cluster_id uniquely identifies a Databricks cluster and allows future
  operations such as refresh(), start(), terminate() and permanentDelete();
 
  The cluster_id can be specified as a string or character vector and is stored
  as a character vector.
```

#### databricks.Cluster.setClusterLogConf

```text
SETCLUSTERLOGCONF Method to set the location of cluster logs
  Set the location for logs produced by the cluster e.g. during the
  initialization of the cluster.
 
  For example:
 
    cl = databricks.Cluster;
    conf = databricks.ClusterLogConf;
    conf.setDestination("dbfs:/logs/cluster_logs");
 
    cl.setClusterLogConf(conf);
 
  For simplicity, a string can be used, which will create the underlying
  ClusterLogConf object.
 
    cl = databricks.Cluster;
    cl.setClusterLogConf("dbfs:/logs/cluster_logs");
```

#### databricks.Cluster.setCustomTags

```text
SETCUSTOMTAGS Method to create and update custom tags for the cluster
  Set custom tags on the Cluster object. This is useful when creating new
  clusters.
  
  For example:
  
      cl = databricks.Cluster;
      tag = databricks.ClusterTag('owner','myUserName');
      cl.setCustomTags(tag);
```

#### databricks.Cluster.setDataSecurityMode

```text
SETDATASECURITYMODE Configures cluster property for data_security_mode
  mode can be of type character vector, string scalar or
  databricks.datastructures.DataSecurityMode.
```

#### databricks.Cluster.setDockerImage

```text
SETDOCKERIMAGE Set docker image for cluster
 
  A cluster can be started with a Docker image instead of with init scripts
 
  For example:
 
    cl = databricks.Cluster;
    cl.cluster_name = 'docker-test-cluster';
    cl.setNumWorkers(2)
    cl.setDockerImage('img', 'user', 'passwd');
 
    cl.create()
 
    % Or using a databricks.datastructures.DockerImage argument
    cl = databricks.Cluster;
    cl.cluster_name = 'docker-test-cluster';
    cl.setNumWorkers(2)
 
    dbaStruct.username = "myusername"
    dbaStruct.password = "mypassword"
    dba = databricks.datastructures.DockerBasicAuth(dbaStruct)
    diStruct.url = "http://mydockerrepourl.example.com"
    diStruct.basic_auth = dbaStruct
 
    di = databricks.datastructures.DockerImage(diStruct)
    cl.setDockerImage(di);
 
    cl.create()
 
  It is not good practice to include passwords in source code, please 
  consider reading the value from a file or other external source in real
  world code.
```

#### databricks.Cluster.setInitScriptInfo

```text
SETINITSCRIPTINFO Method to set the location of an init script
  Sets one or more init_script objects to execute on the initialization of
  the cluster.
  
  For example:
  
    cl = databricks.Cluster;
    is = databricks.InitScriptInfo;
    is.setDestination("dbfs:/home/init_script");
  
    cl.setInitScriptInfo(is);
```

#### databricks.Cluster.setInstancePoolId

```text
SETINSTANCEPOOLID The optional ID of the instance pool to which the cluster belongs
```

#### databricks.Cluster.setInstanceProfileARN

```text
setInstanceProfileARN Set AWS specific instance_profile_arn attribute.
 
  For example:
 
      cl = databricks.Cluster;
      cl.setInstanceProfileARN("arn:aws:iam::<aws-account-number>:instance-profile/<iam-role-name>");
```

#### databricks.Cluster.setNumWorkers

```text
SETNUMWORKERS Method to specify the number of workers for the cluster
  The number of workers in the cluster can be set with one of two methods.
  Either by setting the number of workers through a single scalar number
  or by specifying autoscaling by providing the min/max number of workers.
 
    setNumWorkers(NUM);
 
  or
 
    setNumWorkers([MIN MAX]);
 
  If num_workers, number of worker nodes that this cluster should have.
  A cluster has one Spark Driver and num_workers Executors for a total of
  num_workers + 1 Spark nodes.
 
    cl = databricks.Cluster();
    cl.setNumWorkers(25);
 
  To specify autoscaling:
 
    cl = databricks.Cluster();
    cl.setNumWorkers([2 10]);
```

#### databricks.Cluster.setPolicyId

```text
SETPOLICYID Method to set a policy_id to a cluster handle
  Set the policy id for a cluster handle.
 
    cl = databricks.Cluster()
    cl.setPolicyId('MY-POLICY-VALUE');
 
  The policy_id can be specified as a string or character vector and is stored
  as a character vector.
 
  A default policy_id can be defined in the databricks-settings.json file.
  This will then be applied to all created clusters unless overwritten.
```

#### databricks.Cluster.setRuntimeEngine

```text
SETRUNTIMEENGINE Configures cluster property for runtime_engine
  Decides which runtime engine to be use, e.g. Standard vs. Photon.
  If unspecified, the runtime engine is inferred from spark_version.
 
  See also runtime_engine property handling in getPayload().
```

#### databricks.Cluster.setSingleNode

```text
SETSINGLENODE Configures cluster properties for a single node cluster
  Calls setNumWorkers(), setCustomTags() & SparkConfPair() with the required
  arguments needed to create a single node cluster.
```

#### databricks.Cluster.setSparkConf

```text
SETSPARKCONF Method to create and update spark_conf for the cluster
  Set custom spark_conf on the Cluster object. This is useful when creating new
  clusters, particularly if creating a single node cluster.
 
  For example:
 
      cl = databricks.Cluster;
      scpCell = {'spark_master', 'local[*,4]'; 'spark_databricks_cluster_profile', 'singleNode'};
      scps = databricks.SparkConfPair(scpCell);
      cl.setSparkConf(scps);
```

#### databricks.Cluster.setSparkEnvVars

```text
SETSPARKENVVARS Method to create and update environment variables for the cluster
  Set spark_env_vars on the Cluster object. This is useful when creating new
  clusters.
 
  For example:
 
      cl = databricks.Cluster;
      var = databricks.SparkEnvPair('SPARK_LOCAL_DIRS','/local_disk0');
      cl.setSparkEnvVars(var);
```

#### databricks.Cluster.start

```text
START Method to start a databricks cluster
  Start a terminated Spark cluster. This is similar to create except:
    * The previous cluster ID and attributes are preserved.
    * The cluster starts with the last specified cluster size. If the previous 
      cluster was an autoscaling cluster, the current cluster starts with 
      the minimum number of nodes.
    * If the cluster is not in a TERMINATED state, nothing will happen.
  
  Clusters launched to run a job cannot be started.
  
  To start a cluster:
    
    cl.start();
  
  For example,
    
    % List all available clusters
    cl = databricks.Cluster.list();
    
    % Check the state to ensure that it is terminated
    cl(1).state
        
    ans =
  
        'TERMINATED'
  
    % Start the cluster
    cl(1).start();
```

#### databricks.Cluster.terminate

```text
TERMINATE Method to delete (terminate) a given cluster
  Terminate a running cluster. For this method to work, the cluster object
  should have a valid cluster_id.
  
    % Fetch the a list of existing databricks clusters
    cl = databricks.Cluster.list();
    
    % Terminate the first cluster
    cl(1).terminate();
  
  This method will not check for the validity of the cluster_id. It is left
  to the user to ensure that a valid cluster_id is specified.
  
  The cluster is removed asynchronously. Once the termination has completed, 
  the cluster will be in a TERMINATED state. If the cluster is already in a 
  TERMINATING or TERMINATED state, nothing will happen.
  
  30 days after a cluster is terminated, it is permanently deleted.
```

### databricks.ClusterLogConf

Superclass: dynamicprops

```text
CLUSTERLOGINFO Location of cluster logs
  Use this to specify the location of the init_scripts. This can point to a
  DBFS (or S3 location when running on AWS).
 
  For example:
 
    conf = databricks.ClusterLogConf;
    conf.setDestination("dbfs:/home/cluster-logs");
```

#### databricks.ClusterLogConf.ClusterLogConf

```text
CLUSTERLOGINFO Location of cluster logs
  Use this to specify the location of the init_scripts. This can point to a
  DBFS (or S3 location when running on AWS).
 
  For example:
 
    conf = databricks.ClusterLogConf;
    conf.setDestination("dbfs:/home/cluster-logs");

    Documentation for databricks.ClusterLogConf
```

#### databricks.ClusterLogConf.setDestination

```text
SETDESTINATION Method to set the destination of the cluster logs
  The location of the init script destination must be provided.
 
  For example:
 
    conf = databricks.ClusterLogConf;
    conf.setDestination("dbfs:/home/cluster_logs");
 
  When running on AWS, an S3 object URL can be used along with a
  destination.
```

### databricks.ClusterPolicy

Superclass: databricks.Object

```text
CLUSTERPOLICY Databricks Cluster Policies API
 
  Class to support working with cluster polices.
 
  Example:
     cp = databricks.ClusterPolicy;
```

#### databricks.ClusterPolicy.ClusterPolicy

```text
Constructor

    Documentation for databricks.ClusterPolicy
```

#### databricks.ClusterPolicy.create

```text
create Creates a Cluster Policy based on a policy definition
  The policy definition is provided as a string.
 
  Required arguments:
    createRequest: A databricks.datastructures.clusterpolicy.CreateRequest
 
  Example:
     cp = databricks.ClusterPolicy;
     cr = databricks.datastructures.clusterpolicy.CreateRequest;
     cr.name = "My Cluster Name";
     cr.definition = '{"spark_conf.spark.databricks.cluster.profile":{"type":"forbidden","hidden":true}}';
     cr.description = "My Policy Description";
     cp.create(cr);
 
  See also: https://docs.databricks.com/administration-guide/clusters/policy-definition.html
```

#### databricks.ClusterPolicy.edit

```text
Edit Cluster Policy
 
  Change a Cluster Policy. Input is provided as a databricks.datastructures.clusterpolicy.PolicyUpdateRequest
 
  Optional named arguments
    verbose        Produce additional output, default is true.
 
  On success an empty databricks.datastructures.clusterpolicy.ErrorResponse
  is returned, otherwise a populated ErrorResponse is returned.
 
  Example:
    cp = databricks.ClusterPolicy();
    pur = databricks.datastructures.clusterpolicy.PolicyUpdateRequest();
    pur.policyId = "D06205EB3700041C";
    pur.definition = string('{"spark_conf.spark.databricks.cluster.profile":{"type":"forbidden","hidden":true}}');
    cp.edit(pur)
```

#### databricks.ClusterPolicy.get

```text
GET Return a cluster policy given the policy Id
 
 
  Example:
    clusterPolicy = databricks.ClusterPolicy;
    clusterPolicy.get("D06205EB3700041C")
 
  Cf. https://docs.databricks.com/dev-tools/api/latest/policies.html
```

#### databricks.ClusterPolicy.getPermissionLevels

```text
GETPERMISSIONLEVELS Gets the permission levels that a user can have on an object
 
  Example:
    clusterPolicy = databricks.ClusterPolicy;
    list = clusterPolicy.list;
    id = list.policies(2).policyId;
    result = clusterPolicy.getPermissionLevels(id);
    result.permissionLevels(1)
    ans = 
    PermissionLevel with properties:
       permissionLevel: "CAN_USE"
         description: "Can use the policy"
 
 
  See: https://docs.databricks.com/api/workspace/clusterpolicies/getpermissionlevels
```

#### databricks.ClusterPolicy.getPolicyPermissions

```text
GETPERMISSIONLEVELS Gets the permissions of a cluster policy
  Cluster policies can inherit permissions from their root object.
 
  Example:
    clusterPolicy = databricks.ClusterPolicy;
    list = clusterPolicy.list;
    id = list.policies(2).policyId;
    result = clusterPolicy.getPolicyPermissions(id);
    result = clusterPolicy.getPolicyPermissions(id)
    result = 
    GetPermissionsResponse with properties:
 
             objectId: "/cluster-policies/0003EAAED5108C80"
           objectType: "cluster-policy"
    accessControlList: [1x2 databricks.datastructures.clusterpolicy.AccessControlList]
 
 
  See: https://docs.databricks.com/api/workspace/clusterpolicies/getpermissions#access_control_list-all_permissions-inherited_from_object
```

#### databricks.ClusterPolicy.list

```text
LIST List Cluster Policies
 
  This method will return a list of the policies defined for this
  Databricks account.
  The return value is a structure with a field total_count. If
  total_count is non-zero, it also contains a field policies.
 
  Optional named arguments
    sort_order     A databricks.datastructures.ListOrder
    sort_column    A databricks.datastructures.PolicySortColumn
 
  Example:
    cp = databricks.ClusterPolicy
    l = cp.list
    l = 
    ListResponse with properties:
        policies: [1x7 databricks.datastructures.clusterpolicy.Policy]
        totalCount: 7
 
  Two additional arguments exist, sort_order and sort_column.
 
  l = cp.list('sort_order', 'ASC')
 
  l = cp.list('sort_column', 'POLICY_NAME')
 
  See: https://docs.databricks.com/dev-tools/api/latest/policies.html
```

#### databricks.ClusterPolicy.remove

```text
REMOVE Delete Cluster Policy given the policy Id
 
  Example:
    cp = databricks.ClusterPolicy();
    cp.remove("D06205EB3700041C");
 
  Cf. https://docs.databricks.com/dev-tools/api/latest/policies.html
```

### databricks.ClusterTag

Superclass: databricks.Object

```text
CLUSTERTAG Class to specify tags to attach to the create object.
  Use to configure Tags on the databricks cluster.
  Keys and values must be character vectors or scalar strings.
  Both keys and values are stored as character arrays.
 
  For example:
 
    cl = databricks.Cluster;
    tags = databricks.ClusterTag('owner','joe');
    cl.setCustomTags(tags);
 
  Optionally, this class accepts a cell array of inputs to specify multiple
  tag pairs.
 
    tagCell = {'owner','joe';'group','engineering'};
    tags = databricks.ClusterTag(tagCell);
 
  A tag pair can also be added to an existing ClusterTag using the add method
    tagCell = {'owner','joe';'group','engineering'};
    tags = databricks.ClusterTag(tagCell);
    tags.add('myNewKey','myNewValue');
 
  Order of insertion is not preserved.
  Databricks allows at most 45 custom tags.
  The key length must be between 1 and 127 UTF-8 characters, inclusive.
  The value length must be less than or equal to 255 UTF-8 characters.
  For further details and restrictions see:
  https://docs.databricks.com/dev-tools/api/latest/clusters.html#clusterclustertag
  https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/Using_Tags.html#tag-restrictions
```

#### databricks.ClusterTag.ClusterTag

```text
containers.Map is a handle class so set the property in the
  constructor

    Documentation for databricks.ClusterTag
```

#### databricks.ClusterTag.add

```text
ADD Adds a Key Value pair to a ClusterTag object
 
  Example
    tags = databricks.ClusterTag('key1','value1');
    tags.add('additionalKey', 'additionalValue');
```

### databricks.CommandExecution

Superclass: databricks.Object

```text
COMMANDEXECUTION MATLAB Class for interacting with the Databricks Command Execution API
  For details see: https://docs.databricks.com/api/workspace/commandexecution
```

#### databricks.CommandExecution.CommandExecution

```text
Command Execution Constructor

    Documentation for databricks.CommandExecution
```

#### databricks.CommandExecution.cancel

```text
cancel Cancels a currently running command within an execution context
  The command ID is obtained from a prior successful call to execute.
 
  Example:
 
    cancelRequest = databricks.datastructures.commandexecution.CancelRequest;
    cancelRequest.clusterId = clusterId;
    cancelRequest.contextId = contextId;
    cancelRequest.commandId = commandId;
    cancelResponse = commandExecution.cancel(cancelRequest);
 
  Required Inputs:
    cancelRequest
        Description:
            Request object to cancel a command
        Type: 
            databricks.datastructures.commandexecution.CancelRequest
        Required Properties in the data structure which must be set:
            contextId
            commandId
            clusterId
 
  Outputs:
    result  
        Description:
            True on success
        Type:
            logical or databricks.datastructures.commandexecution.ErrorResponse
```

#### databricks.CommandExecution.commandsStatus

```text
commandStatus Gets the status of and, if available, the results from a currently executing command
  The command ID is obtained from a prior successful call to execute.
 
  Example:
 
    commandExecution = databricks.CommandExecution;
    commandsStatusResponse = commandExecution.commandsStatus(clusterId, contextId, commandId);
    commandsStatusResponse.status
 
  Required Inputs:
    clusterId
        Description:
            ID of cluster
        Type: 
            string
    contextId
        Description:
            ID of context
        Type: 
            string
    commandId
        Description:
            ID of command
        Type: 
            string
 
  Outputs:
    result
        Description:
            databricks.datastructures.commandexecution.commandsStatusResponse on success
        Type:
            databricks.datastructures.commandexecution.commandsStatusResponse on success
            databricks.datastructures.commandexecution.ErrorResponse on Error
```

#### databricks.CommandExecution.contextsStatus

```text
STATUS Gets the contextsStatus for an execution context
 
  Example:
 
    commandExecution = databricks.CommandExecution;
    contextsStatusResponse = commandExecution.contextsStatus(clusterId, contextId);
    contextsStatusResponse.status
 
  Required Inputs:
    clusterId
        Description:
            ID of cluster
        Type:
            string
    contextId
        Description:
            ID of context
        Type:
            string
 
  Outputs:
    result
        Description:
            databricks.datastructures.commandexecution.ContextsStatusResponse on success
        Type:
            databricks.datastructures.commandexecution.ContextsStatusResponse on success
            databricks.datastructures.commandexecution.ErrorResponse on Error
```

#### databricks.CommandExecution.create

```text
CREATE Creates an execution context for running cluster commands
 
  Example:
    commandExecution = databricks.CommandExecution();
    createRequest = databricks.datastructures.commandexecution.CreateRequest;
    createRequest.clusterId = "1117-171925-4ipnoi3i";
    createRequest.language = databricks.datastructures.commandexecution.Language.python;
    createResponse = commandExecution.create(createRequest);
    if isa(createResponse, 'databricks.datastructures.commandexecution.ErrorResponse')
        error("Context creation failed:\n  %s", createResponse.error);
    else
        contextId = createResponse.id;
    end
 
  Required Inputs:
    createRequest
        Description:
            Request object to create a context
        Type: 
            databricks.datastructures.commandexecution.CreateRequest
        Required Properties in the data structure which must be set:
            clusterId
            language
 
  Outputs:
    result
        Description:
            create ID
        Type:
            databricks.datastructures.commandexecution.CreateResponse
 
  See Also: databricks.datastructures.commandexecution.CreateResponse, databricks.datastructures.commandexecution.CreateRequest
```

#### databricks.CommandExecution.destroy

```text
DESTROY Deletes an execution context
 
  Example:
 
    result = ce.destroy(destroyRequest);
 
  % Required Inputs:
    CreateRequest
        Description:
            Request object to create a context
        Type: 
            databricks.datastructures.commandexecution.CreateRequest
        Required Properties in the data structure which must be set:
            clusterId
            contextId
 
  Outputs:
    result
        Description:
            True on success
        Type:
            logical or databricks.datastructures.commandexecution.ErrorResponse
 
  Example:
    commandExecution = databricks.CommandExecution;
    destroyRequest = databricks.datastructures.commandexecution.DestroyRequest;
    destroyRequest.clusterId = clusterId;
    destroyRequest.contextId = contextId;
    destroyResponse = commandExecution.destroy(destroyRequest);
```

#### databricks.CommandExecution.execute

```text
execute Execute a cluster command in the given execution context, using the provided language
  If successful, it returns an ID for tracking the status of the command's execution.
 
  Example:
    executeRequest = databricks.datastructures.commandexecution.ExecuteRequest;
    executeRequest.clusterId = clusterId;
    executeRequest.contextId = contextId;
    executeRequest.command = pythonCommand;
    executeRequest.language = language;
    executeResponse = commandExecution.execute(executeRequest);
    if isa(executeResponse, 'databricks.datastructures.commandexecution.ErrorResponse')
        error("databricks:executePythonCommand", "Execute failed:\n  %s", executeResponse.error);
    else
        commandId = executeResponse.id;
    end
 
  Required Inputs:
     Properties:
        Description: 
            Request object to execute a command
        Type: 
            databricks.datastructures.commandexecution.ExecuteResult
        Required Properties in the data structure which must be set:
            clusterId
            contextId
            language
            command
 
  Outputs:
    result
        Description:
            databricks.datastructures.commandexecution.ExecuteResponse on success
            containing the id for tracking the status of the command's
            execution. as a string.
        Type:
            databricks.datastructures.commandexecution.ExecuteResponse on success
            databricks.datastructures.commandexecution.ErrorResponse on Error
```

### databricks.CronSchedule

Superclass: databricks.Object

```text
CRONSCHEDULE Quartz Cron schedule object
 
  Example:
    cs = databricks.CronSchedule;
    cs.setQuartzCronExpression("0 15 22 * * ?");
    cs.setPauseStatus("PAUSED");
    cs.setTimezoneId("Ireland/Dublin");
```

#### databricks.CronSchedule.CronSchedule

```text
CRONSCHEDULE Quartz Cron schedule object
 
  Example:
    cs = databricks.CronSchedule;
    cs.setQuartzCronExpression("0 15 22 * * ?");
    cs.setPauseStatus("PAUSED");
    cs.setTimezoneId("Ireland/Dublin");

    Documentation for databricks.CronSchedule
```

#### databricks.CronSchedule.setPauseStatus

```text
setPauseStatus Method to set the timezone of a CronSchedule
  The value must be a a Java timezone ID. The schedule for a job will be
  resolved with respect to this timezone. See Java TimeZone for details:
  https://docs.oracle.com/javase/7/docs/api/java/util/TimeZone.html
  This field is required.
 
  Example:
    cs = databricks.CronSchedule;
    cs.setPauseStatus("UNPAUSED");
```

#### databricks.CronSchedule.setQuartzCronExpression

```text
SETQUARTZCRONEXPRESSION Method to set the timezone of a CronSchedule
  A Cron expression using Quartz syntax that describes the schedule for a job.
  For details see: http://www.quartz-scheduler.org/documentation/quartz-2.3.0/tutorials/crontrigger.html
  This field is required.
 
  For example:
 
    cs = databricks.CronSchedule;
    cs.setQuartzCronExpression("0 15 22 * * ?");
```

#### databricks.CronSchedule.setTimezoneId

```text
SETTIMEZONEID Method to set the timezone of a CronSchedule
  The value must be a a Java timezone ID. The schedule for a job will be
  resolved with respect to this timezone. See Java TimeZone for details:
  https://docs.oracle.com/javase/7/docs/api/java/util/TimeZone.html
  This field is required.
 
  Example:
    cs = databricks.CronSchedule;
    cs.setTimezoneId("Ireland/Dublin");
```

### databricks.CurrentUser

Superclass: databricks.Object

```text
CURRENTUSER Get details about the current method caller's identity
  This API is in Public Preview
 
  Example:
    u = databricks.CurrentUser;
    [userInfo, errorResponse] = u.getCurrentUserInfo();
 
  See also: https://docs.databricks.com/api/workspace/currentuser/me
```

#### databricks.CurrentUser.CurrentUser

```text
Constructor

    Documentation for databricks.CurrentUser
```

#### databricks.CurrentUser.getCurrentUserInfo

```text
GETCURRENTUSERINFO Get details about the current method caller's identity
  This function uses a Databricks public preview API and is subject to change.
 
  Example:
    u = databricks.CurrentUser;
    [userInfo, errorResponse] = u.getCurrentUserInfo();
    userInfo.userName
     ans = 
     "joeuser@example.com"
 
  See also: https://docs.databricks.com/api/workspace/currentuser/me
```

### databricks.DBFS

Superclass: databricks.Object

```text
DBFS Databricks interface to access the DBFS
  Interface to connect to the Databricks file system (DBFS) via the
  databricks 2.0 REST API. Please see the documentation at:
  https://docs.databricks.com/api/latest/index.html
 
  For example:
 
    % Create a databricks DBFS interface
    db = databricks.DBFS();
```

#### databricks.DBFS.DBFS

```text
DBFS Databricks interface to access the DBFS
  Interface to connect to the Databricks file system (DBFS) via the
  databricks 2.0 REST API. Please see the documentation at:
  https://docs.databricks.com/api/latest/index.html
 
  For example:
 
    % Create a databricks DBFS interface
    db = databricks.DBFS();

    Documentation for databricks.DBFS
```

#### databricks.DBFS.download

```text
DOWNLOAD Method to download a file from DBFS
  This method will download an entire file from DBFS. The reading of the
  file from DBFS is performed in approximately 1MB chunks.
 
  For example:
 
    db = databricks.DBFS;
    localFilename = db.download('/example/sample.mat');
 
  The download method can recursively download entire folders of files.
 
    db.download('/example/logs','recurse',true);
```

#### databricks.DBFS.getStatus

```text
GETSTATUS Method to get the file information for a file or directory
  Get the file information of a file or directory. An array of
  databricks.datastructures.FileInfo objects is returned. If the file or directory does
  not exist, this method will return an empty databricks.datastructures.FileInfo array.
 
    db = databricks.DBFS();
    info = db.getStatus('/MATLAB/sample.mat');
 
  The path argument must be provided as a character vector or scalar
  string. By default '/' is used.
```

#### databricks.DBFS.listFiles

```text
LISTFILES Method to return a list of files on DBFS
  List the files on DBFS.
 
    % Create an interface and view all files in the root workspace
    db = databricks.DBFS();
    fileList = db.listFiles();
 
  Optionally, a target path will list the files in a particular folder.
 
    % With an optional directory listing
    fileList = db.listFiles('/MATLAB');
 
  The returned list of FileInfo objects can be viewed as a table.
 
    table(db.listFiles());
```

#### databricks.DBFS.ls

```text
LS Method to list the files on the Databricks file system
  This is similar to the databricks.DBFS/listFiles but provides the result
  in an easy to read table format.
```

#### databricks.DBFS.mkdir

```text
MKDIR Method to make a directory on DBFS
  Create the given directory and necessary parent directories if they do 
  not exist. This method will not work if there exists a file (not a 
  directory) at any prefix of the input path.
  
    db = databricks.DBFS();
    db.mkdir('/MATLAB');
```

#### databricks.DBFS.move

```text
MOVE Move a file from one location to another location within DBFS
  If the source file does not exist, errors with RESOURCE_DOES_NOT_EXIST.
  If there already exists a file in the destination path, error with
  RESOURCE_ALREADY_EXISTS. If the given source path is a directory, the call
  recursively moves all files.
 
  When moving a large number of files the underlying API call will time out
  after approximately 60s, potentially resulting in partially moved data.
  Therefore, for operations that move more than 10k files, Databricks strongly
  discourage using the DBFS REST API. Databricks recommend that such operations
  are performed in the context of a cluster, using File system utilities from a
  notebook, which provides the same functionality without timing out.
 
  The source path of the file or directory may be given as a scalar string or
  character vector. The path should be the absolute DBFS path (e.g. /mnt/foo/) 
  The destination path of the file or directory may be given as a scalar string
  or character vector. The path should be the absolute DBFS path (e.g. /mnt/bar/).
 
  This method is not vectorized.
```

#### databricks.DBFS.read

```text
READ Method to read a file from DBFS
  Reading a file from DBFS is performed in 1MB chunks. The byte array
  returned by this method can be saved to disk for persistence.
 
  For example:
 
    db = databricks.DBFS;
    data = db.read('/example/sample.mat');
 
    % Create a file and save it.
    fid = fopen('sample.mat');
    fwrite(fid, data);
    fclose(fid);
```

#### databricks.DBFS.readFileSection

```text
READFILESECTION Internal method to read a chunk from a DBFS file
 
  For example:
 
    db = databricks.DBFS;
    data = db.read('/example/sample.mat');
 
    % Create a file and save it.
    fid = fopen('sample.mat');
    fwrite(fid, data);
    fclose(fid);
```

#### databricks.DBFS.rm

```text
RM Method to delete a folder or file from DBFS
  Delete the file or directory (optionally recursively delete all files in
  the directory).
 
    rm(ABSOLUTEPATH, RECURSIVEFLAG);
 
  To delete a folder/file:
 
    db = databricks.DBFS();
    db.rm('/Data');
 
  This will delete files and folders as long as they are not empty. To
  delete the entire folder recursively, provide an additional recursive flag
 
    db.rm('/Data', true);
 
  If the specified file or folder does not exist the operation will still
  complete without error, displaying "Delete complete". If the existence of the
  file or folder is significant it should be first checked using the getStatus()
  method.
```

#### databricks.DBFS.upload

```text
UPLOAD Method to upload files into the DBFS
  The amount of data uploaded by single API call cannot exceed 1MB. To
  upload a file that is larger than 1MB to DBFS, this method uses the
  streaming API, which is a combination of create, addBlock, and close.
 
  Example:
 
    db = databricks.DBFS();
    db.upload(which('sample.mat'));
 
  An optional argument allows the user to specify the destination folder for
  the upload. The target filename will be the same as the local
  filename.
 
    db.upload(which('sample.mat'),'/tmp/MATLAB/');
 
  A trailing slash is optional. The upload will overwrite an existing file with
  the same name if one exists in the destination location.
 
  If a file has the same name as a folder in the destination folder an error
  will occur.
 
  If a destination folder does not exist a destination of '/MATLAB/' is used by
  default
```

### databricks.Files

Superclass: databricks.Object

```text
Files Class to provide an interface to the Databricks Files REST API
 
  The Files API is a standard HTTP API that allows you to read, write, list,
  and delete files and directories by referring to their URI.
  The API makes working with file content as raw bytes easier and more efficient.
  The API supports Unity Catalog volumes, where files and directories to
  operate on are specified using their volume URI path, which follows the
  format /Volumes/<catalog_name>/<schema_name>/<volume_name>/<path_to_file>.
  The Files API has two distinct endpoints, one for working with files
  (/fs/files) and another one for working with directories (/fs/directories).
  Both endpoints, use the standard HTTP methods GET, HEAD, PUT, and DELETE
  to manage files and directories specified using their URI path. The path
  is always absolute.
 
  See also: https://docs.databricks.com/api/workspace/files
```

#### databricks.Files.Files

```text
Files Constructor

    Documentation for databricks.Files
```

#### databricks.Files.bigUpload

```text
UPLOAD Uploads a file of size 5 GiB or greater Caution - Relies upon an undocumented Databricks feature
  The method is not supported and may be removed without further notice
  For smaller files use the databricks.Upload method.
 
  On success a logical true is returned with an empty databricks.datastructures.files.ErrorResponse.
  Otherwise false is returned with a populated databricks.datastructures.files.ErrorResponse.
 
  The optional named `overwrite` argument indicates if the destination file
  should be overwritten if it exists. The default is `true`.
 
  Examples:
    f = databricks.Files;
     result = f.bigUpload("myBigFile.zip", "/Volumes/main/default/myvolume/myDir/myBigFile.zip")
     result =
       logical
        1
 
 
    if ispc
        localRuntimePath = fullfile(getenv("%USERPROFILE%"), "Downloads", "MATLAB_Runtime_R2026a_Update_4_glnxa64.zip");
    else
        localRuntimePath = fullfile(getenv("HOME"), "Downloads", "MATLAB_Runtime_R2026a_Update_4_glnxa64.zip");
    end
    [p,n,e] = fileparts(localRuntimePath);
    fname = n + e;
    catalogPath = "/Volumes/main/default/myvolume/MathWorks/runtimes/" + fname;
 
    f = databricks.Files;
    [result, errorResponse] = f.bigUpload(localRuntimePath, catalogPath, overwrite=true)
 
 
  See also: https://docs.databricks.com/api/workspace/files/upload
```

#### databricks.Files.completeUpload

```text
completeUpload Caution - Undocumented Databricks feature
  The method is not supported may be removed without further notice
```

#### databricks.Files.create

```text
CREATE Creates an empty directory
  If necessary, also creates any parent directories of the new, empty directory
  (like the shell command mkdir -p). If called on an existing directory,
  returns a success response; this method is idempotent (it will succeed if
  the directory already exists).
  On success a logical true is returned with an empty databricks.datastructures.files.ErrorResponse.
  Otherwise false is returned with a populated databricks.datastructures.files.ErrorResponse.
 
  Example:
    f = databricks.Files;
    result = f.create("/Volumes/main/default/myvolume/myDir")
    result =
      logical
       1
 
  See also: https://docs.databricks.com/api/workspace/files/createdirectory
```

#### databricks.Files.directoryExists

```text
DIRECTORYEXISTS Check if a directory exists
  If a directory exists a logical true is returned. Otherwise false is
  returned.
 
  The required directoryPath argument is given as an absolute path,
  as a scalar text value.
 
  Example:
    f = databricks.Files;
    tf = f.directoryExists("/Volumes/main/default/myvolume/myDir")
    tf =
        true
 
  See also: https://docs.databricks.com/api/workspace/files/getmetadata
```

#### databricks.Files.directoryMetadata

```text
DIRECTORYMETADATA Gets the metadata of a directory
  On success a databricks.datastructures.files.DirectoryMetadata object
  is returned. On expected error a
  databricks.datastructures.files.ErrorResponse is returned.
 
  The required directoryPath argument is given as an absolute path,
  as a scalar text value.
 
  Example:
    f = databricks.Files;
    md = f.directoryMetadata("/Volumes/main/default/myvolume/myDir")
    md =
        DirectoryMetadata with properties:
          exists: 1
 
  See also: https://docs.databricks.com/api/workspace/files/getdirectorymetadata
```

#### databricks.Files.download

```text
DOWNLOAD Downloads a file of up to 5 GiB
  On success a logical true is returned with an empty databricks.datastructures.files.ErrorResponse.
  Otherwise false is returned with a populated databricks.datastructures.files.ErrorResponse.
 
  The optional logical overwrite flag can be used to prevent
  overwriting a destination file, the default is true i.e. do overwrite
  the destination.
 
  If an optional destination path named argument is provided it is used as the path
  to download to otherwise the name of the file to be downloaded and the current
  directory are used.
 
  The required source argument is given as an absolute path,
  as a scalar text value.
 
  Example:
    f = databricks.Files;
    result = f.download("/Volumes/main/default/myvolume/myDir/hello-world.txt", destination="hw-downloaded.txt")
    result =
      logical
       1
 
  See also: https://docs.databricks.com/api/workspace/files/download
```

#### databricks.Files.escapePath

```text
databricks.Files.escapePath is a function.
    path = escapePath(in)
    [path, pathArray] = escapePath(___)
```

#### databricks.Files.fileExists

```text
FILEEXISTS Check if a file exists
  If a file exists a logical true is returned. Otherwise false is
  returned.
 
  The required filePath argument is given as an absolute path,
  as a scalar text value.
 
  Example:
    f = databricks.Files;
    tf = f.fileExists("/Volumes/main/default/myvolume/myDir/hello-world.txt")
    tf =
        true
 
  See also: https://docs.databricks.com/api/workspace/files/getmetadata
```

#### databricks.Files.fileMetadata

```text
FILEMETADATA Get the metadata of a file
  On success a databricks.datastructures.files.FileMetadata object is
  returned. On expected error a
  databricks.datastructures.files.ErrorResponse is returned.
  The contentLength property is the file size in bytes.
 
  The required filePath argument is given as an absolute path,
  as a scalar text value.
 
  Example:
    f = databricks.Files;
    md = f.fileMetadata("/Volumes/main/default/myvolume/myDir/hello-world.txt")
    md =
        FileMetadata with properties:
            contentType: "application/octet-stream"
          contentLength: 13
           lastModified: 08-Jan-2024 10:27:07
 
  See also: https://docs.databricks.com/api/workspace/files/getmetadata
```

#### databricks.Files.initiateUpload

```text
initiateUpload Caution - Undocumented Databricks feature
  The method is not supported may be removed without further notice
```

#### databricks.Files.list

```text
LIST List files, pages through files to return a complete list
  An optional pageSize int64 argument can be provided that sets the page size
  used the default value is 1000.
  On success a databricks.datastructures.files.ListResponse is returned
  otherwise a databricks.datastructures.files.ErrorResponse is returned.
  To return a page at a time use databricks.Files.listPaginated()
 
  The required directoryPath argument is given as an absolute path,
  as a scalar text value.
 
  Example:
    f = databricks.Files;
    result = f.list('/Volumes/main/default/myvolume/myDir')
      ListResponse with properties:
        contents: [1x5 databricks.datastructures.files.DirectoryEntry]
 
  This method is not recommended for directories with very large file counts
  as runtime may be excessive, other approaches should be considered.
 
  See also: https://docs.databricks.com/api/workspace/files/listdirectorycontents
```

#### databricks.Files.listPaginated

```text
listPaginated List a single 'page' of files potential returning a nextPageToken
  An optional pageSize int64 argument can be provided that sets the page size
  used the default value is 1000.
 
  An optional pageToken scalar text argument can be provided.
  The token being the nextPageToken in the response of the previous request
  to list the contents of this directory. Provide this token to retrieve the
  next page of directory entries. When providing a pagetoken, all other
  parameters provided to the request must match the previous request.
  To list all of the entries in a directory, it is necessary to continue
  requesting pages of entries until the response contains no nextPageToken.
  The number of entries returned must not be used to determine
  when the listing is complete.
  To return all pages at one time also see: databricks.Files.list()
 
  The required directoryPath argument is given as an absolute path,
  as a scalar text value.
  
  On success a databricks.datastructures.files.ListResponse is returned
  otherwise a databricks.datastructures.files.ErrorResponse is returned.
 
  Example:
    f = databricks.Files;
    result = f.list('/Volumes/main/default/myvolume/myDir')
      ListResponse with properties:
        contents: [1x5 databricks.datastructures.files.DirectoryEntry]
 
  See also: https://docs.databricks.com/api/workspace/files/listdirectorycontents
```

#### databricks.Files.rm

```text
RM Deletes a file
  On success a logical true is returned with an empty databricks.datastructures.files.ErrorResponse.
  Otherwise false is returned with a populated databricks.datastructures.files.ErrorResponse.
 
  The required directoryPath argument is given as an absolute path,
  as a scalar text value.
 
  Example:
    f = databricks.Files;
    result = f.rm("/Volumes/main/default/myvolume/myDir/hello-world.txt")
    result =
      logical
       1
 
  See also: https://docs.databricks.com/api/workspace/files/delete
```

#### databricks.Files.rmdir

```text
RMDIR Deletes an empty directory
  To delete a non-empty directory, first delete all of its contents.
  This can be done by listing the directory contents and deleting each file
  and subdirectory recursively.
  On success a logical true is returned with an empty databricks.datastructures.files.ErrorResponse.
  Otherwise false is returned with a populated databricks.datastructures.files.ErrorResponse.
 
  The required directoryPath argument is given as an absolute path,
  as a scalar text value.
 
  Example:
    f = databricks.File;
    result = f.rmdir("/Volumes/main/default/myvolume/myDeleteMeDir")
    result =
      logical
       1
 
  See also: https://docs.databricks.com/api/workspace/files/deletedirectory
```

#### databricks.Files.upload

```text
UPLOAD Uploads a file to /Volumes
  On success a logical true is returned with an empty databricks.datastructures.files.ErrorResponse.
  Otherwise false is returned with a populated databricks.datastructures.files.ErrorResponse.
 
  The optional named `overwrite` argument indicates if the destination file should be overwritten
  if it exists. The default is `true`.
 
  Example:
    f = databricks.Files;
     result = f.upload("hello-world.txt", "/Volumes/main/default/myvolume/myDir/hello-world.txt")
     result =
       logical
        1
 
  File of 5 GiB or larger are uploaded on a 'best effort' basis using an API
  that is not publicly supported by Databricks.
 
  See also: https://docs.databricks.com/api/workspace/files/upload
```

### databricks.Genie

Superclass: databricks.Object

```text
GENIE Databricks Genie API
  Class to support working with Genie.
  This API is in Public Preview
 
  Example:
     g = databricks.Genie;
 
  See also: https://docs.databricks.com/api/workspace/genie
```

#### databricks.Genie.Genie

```text
Constructor

    Documentation for databricks.Genie
```

#### databricks.Genie.createConversationMessage

```text
CREATECONVERSATIONMESSAGE Create new message in a conversation
  The AI response uses all previously created messages in the conversation
  to respond.
 
  Example:
    g = databricks.Genie;
    spaceId = "01f08735906717ac8d15d3dc2b61402e";
    conversationId = "01f08739b4391f709fd65ba3a813ef7d";
    content = "What tables are there and how are they connected? Give me a short summary.";
    [result, errorResponse] = g.createConversationMessage(spaceId, conversationId, content)
```

#### databricks.Genie.deleteConversation

```text
DELETECONVERSATION Delete a conversation
 
  Example:
    g = databricks.Genie;
    [result, errorResponse] = g.deleteConversation("e1ef34712a29169db030324fd0e1df5f", "e1ef34712a29169db030324fd0e1df5f");
 
  See also: https://docs.databricks.com/api/workspace/genie/deleteconversation
```

#### databricks.Genie.deleteConversationMessage

```text
DELETECONVERSATIONMESSAGE Delete a conversation message
 
  Example:
    g = databricks.Genie;
    [result, errorResponse] = g.deleteConversationMessage("e1ef34712a29169db030324fd0e1df5f", "e1ef34712a29169db030324fd0e1df5f", "e1ef34712a29169db030324fd0e1df5f");
 
  See also: https://docs.databricks.com/api/workspace/genie/deleteconversationmessage
```

#### databricks.Genie.execMsgAttachmentSQLQuery

```text
EXECMSGATTACHMENTSQLQUERY Execute the SQL for a message query attachment
  Use this API when the query attachment has expired and needs to be re-executed.
```

#### databricks.Genie.getConversationMessage

```text
GETCONVERSATIONMESSAGE Get message from conversation
 
  Example:
    g = databricks.Genie;
    spaceId = "e1ef34712a29169db030324fd0e1df5f";
    conversationId = "e1ef34712a29169db030324fd0e1df5f";
    messageId = "e1ef34712a29169db030324fd0e1df5f";
    message = g.getConversationMessage(spaceId, conversationId, messageId);
 
  See also: https://docs.databricks.com/api/workspace/genie/getmessage
```

#### databricks.Genie.getMsgAttachmentSQLQueryResult

```text
GETMSGATTACHMENTSQLQUERYRESULT Get the result of SQL query if the message has a query attachment
  This is only available if a message has a query attachment and the message
  status is EXECUTING_QUERY OR COMPLETED.
 
  See also: https://docs.databricks.com/api/workspace/genie/getmessageattachmentqueryresult
```

#### databricks.Genie.getSpace

```text
GETSPACE Retrieve the information for a Genie Space
 
  Example:
    g = databricks.Genie;
    spaceId = "e1ef34712a29169db030324fd0e1df5f";
    space = g.getSpace(spaceId);
 
  See also: https://docs.databricks.com/api/workspace/genie/getspace
```

#### databricks.Genie.listConversationMessages

```text
LISTCONVERSATIONMESSAGES List conversation messages to return a complete list
  An optional pageSize int32 argument can be provided that sets the page size
  used the default value is 20, it must be less than or equal to 100.
  On success a databricks.datastructures.genie.listConversationMessagesResponse
  is returned otherwise a databricks.datastructures.ErrorResponse is returned.
  To return a page at a time use databricks.Genie.listConversationMessagesPage()
 
  Example:
    g = databricks.Genie;
    s = g.listSpaces;
    spaceId = s.spaces(end).spaceId;
    c = g.listConversations(spaceId);
    convsersationId = c.conversations(end).conversationId;
    [result, errorResponse] = g.listConversationMessages(spaceId, convsersationId);
    result.messages(1).content
    ans =
        "Write a query to count the number of rows in the outages table"
 
  See also: https://docs.databricks.com/api/workspace/genie/listConversationmessages
```

#### databricks.Genie.listConversationMessagesPage

```text
LISTCONVERSATIONMESSAGESPAGE List a page of messages in a conversation
```

#### databricks.Genie.listConversations

```text
LISTCONVERSATIONS List Genie conversations to return a complete list
  An optional pageSize int32 argument can be provided that sets the page size
  used the default value is 20, it must be less than or equal to 100.
  On success a databricks.datastructures.genie.listConversationsResponse is returned
  otherwise a databricks.datastructures.ErrorResponse is returned.
  To return a page at a time use databricks.Genie.listConversationsPage()
 
  Example:
    g = databricks.Genie;
    spaceId = "01f08739b4391f709fd65ba3a813ef7d";
    [result, errorResponse] = g.listConversations(spaceId);
 
  See also: https://docs.databricks.com/api/workspace/genie/listConversations
```

#### databricks.Genie.listConversationsPage

```text
LISTCONVERSATIONSPAGE Gets a page of a list of genie conversations
 
  Example:
    g databricks.Genie;
    [result, errorResponse] = g.listConversationsPage;
```

#### databricks.Genie.listSpaces

```text
LISTSPACES List Genie spaces, pages through spaces to return a complete list
  An optional pageSize int32 argument can be provided that sets the page size
  used the default value is 20, it must be less than or equal to 100.
  On success a databricks.datastructures.genie.ListSpacesResponse is returned
  otherwise a databricks.datastructures.ErrorResponse is returned.
  To return a page at a time use databricks.Genie.listSpacesPage()
 
  Example:
    g = databricks.Genie;
    [result, errorResponse] = g.listSpaces();
 
  See also: https://docs.databricks.com/api/workspace/genie/listspaces
```

#### databricks.Genie.listSpacesPage

```text
LISTSPACESPAGE Gets a page of a list of genie spaces
 
  Example:
    g databricks.Genie;
    [result, errorResponse] = g.listSpacesPage;
```

#### databricks.Genie.startConversation

```text
STARTCONVERSATION Start a new conversation
 
  Example:
    g = datebricks.Genie;
    [result, errorResponse] = g.listSpaces;
    spaceId = result.spaces(1).spaceId; % Assume #1
    content = "What is the answer to the ultimate question of Life, the Universe, and Everything?";
    [result, errorResponse] = g.startConversation(spaceId, content);
```

#### databricks.Genie.trashSpace

```text
TRASHSPACE Move a Genie Space to the trash
 
  Example:
    g = databricks.Genie;
    [result, errorResponse] = g.trashSpace("e1ef34712a29169db030324fd0e1df5f");
 
  See also: https://docs.databricks.com/api/workspace/genie/trashspace
```

### databricks.InitScriptInfo

Superclass: databricks.Object

```text
INITSCRIPTINFO Location of init script
  Use this to specify the location of the init_scripts.
  The location can be specified as in the forms:
    dbfs:/<SCRIPTPATH>
    file:/<SCRIPTPATH>
    s3://<SCRIPTPATH>
    abfss://<SCRIPTPATH>
 
  For example:
 
    is = databricks.InitScriptInfo;
    is.setDestination("dbfs:/mydirectory/init_script.sh");
```

#### databricks.InitScriptInfo.InitScriptInfo

```text
INITSCRIPTINFO Location of init script
  Use this to specify the location of the init_scripts.
  The location can be specified as in the forms:
    dbfs:/<SCRIPTPATH>
    file:/<SCRIPTPATH>
    s3://<SCRIPTPATH>
    abfss://<SCRIPTPATH>
 
  For example:
 
    is = databricks.InitScriptInfo;
    is.setDestination("dbfs:/mydirectory/init_script.sh");

    Documentation for databricks.InitScriptInfo
```

#### databricks.InitScriptInfo.setDestination

```text
SETDESTINATION Method to set the destination of the init_script
  The location of the init script destination must be provided.
 
  For example:
 
    is = databricks.InitScriptInfo;
    is.setDestination("dbfs:/home/init_script");
 
  Supported path prefixes are:
    s3://, abfss://, file:/, /Volumes, /Users, /Shared and dbfs:/
 
  Alternatively classes of types: databricks.datastructures.DbfsStorageInfo, databricks.datastructures.FileStorageInfo or databricks.datastructures.S3StorageInfo'
```

### databricks.InstancePools

Superclass: databricks.Object

```text
INSTANCEPOOLS Databricks Instance Pools API
 
  Class to support working with instance pools.
 
  Example:
     ip = databricks.InstancePools;
```

#### databricks.InstancePools.InstancePools

```text
Constructor

    Documentation for databricks.InstancePools
```

#### databricks.InstancePools.create

```text
CREATE Creates an instance pool
 
  Example:
    %% Create a pool:
    ip = databricks.InstancePools;
    settings = databricks.internal.settings.Settings.getSettingsStruct();
    cr = databricks.datastructures.instancepools.CreateRequest();
    cr.nodeTypeId = settings.(settings.vendor).node_type_id;
    cr.instancePoolName = "my pool name";
    [result, errorResponse] = ip.create(cr);
 
    %% Create a MATLAB cluster from a pool using a docker image:
    ip = databricks.InstancePools;
    cr = databricks.datastructures.instancepools.CreateRequest();
    cr.instancePoolName = "MATLAB Web Desktop Pool";
    settings = databricks.internal.settings.Settings.getSettingsStruct();
    cr.nodeTypeId = settings.(settings.vendor).node_type_id;
    cr.minIdleInstances = 2;
    di = databricks.datastructures.instancepools.DockerImage(fileread(databricksRoot("config", "dockerAuth.json")));
    cr.preloadedDockerImages = di;
    %% Make sure the Spark version coincides with the Databricks Runtime
    %% version in the docker image
    cr.preloadedSparkVersions = "16.4.x-scala2.12";
    poolId = ip.create(cr);
 
    % Check pool state
    s = ip.get(poolId)
    s.state
 
    % Create the cluster
    % Explicitly specifying docker auth data
    c = createDatabricksCluster("pool cluster", 0, instancePoolId=poolId, dockerURL=di.url, dockerPassword=di.basicAuth.password, dockerUsername=di.basicAuth.username)
 
      % Using docker auth data from JSON file
    c = createDatabricksCluster("pool cluster", 0, instancePoolId=poolId, dockerAuth=databricksRoot("config", "dockerAuth.json"))
```

#### databricks.InstancePools.get

```text
GET Retrieve the information for an instance pool based on its identifier
 
  Example:
    ip = databricks.InstancePools;
    instancePoolId="1234-567890-fetch12-pool-A3BcdEFg";
    pool = ip.get(instancePoolId)
 
    InstancePool with properties:
 
                           awsAttributes: [0x0 databricks.datastructures.instancepools.AWSAttributes]
                         azureAttributes: [1x1 databricks.datastructures.instancepools.AzureAttributes]
                              customTags: [0x0 JSONMapperMap]
                             defaultTags: [1x1 JSONMapperMap]
                                diskSpec: [0x0 databricks.datastructures.instancepools.DiskSpec]
                       enableElasticDisk: 1
      idleInstanceAutoterminationMinutes: 60
                          instancePoolId: "0826-084204-pots8-pool-7jdm3sfb"
                        instancePoolName: "test pool"
                             maxCapacity: 1
                        minIdleInstances: 1
                              nodeTypeId: "Standard_D4ds_v5"
                   preloadedDockerImages: [0x0 databricks.datastructures.DockerImage]
                  preloadedSparkVersions: "15.4.x-scala2.12"
                                   state: ACTIVE
                                   stats: [1x1 databricks.datastructures.instancepools.Stats]
                                  status: [1x1 databricks.datastructures.instancepools.Status]
```

#### databricks.InstancePools.getPermissions

```text
GETPERMISSIONS Retrieve the information for an instance pool based on its identifier
 
  Example:
    ip = databricks.InstancePools;
    instance_pool_id="1234-567890-fetch12-pool-A3BcdEFg"
    permissions = ip.getPermissions(instance_pool_id)
      permissions = 
 
    Permissions with properties:
 
      accessControlList: [1x2 databricks.datastructures.clusterpolicy.AccessControlList]
               objectId: "/instance-pools/0826-084204-pots8-pool-7jdm3sfb"
             objectType: "instance-pool"
```

#### databricks.InstancePools.list

```text
LIST Gets a list of instance pools with their statistics
```

#### databricks.InstancePools.remove

```text
REMOVE Deletes the instance pool permanently
  The idle instances in the pool are terminated asynchronously.
 
  Example:
    ip = databricks.InstancePools;
    [result, errorResponse] = ip.remove('0826-134312-fops10-pool-qndpush3');
 
  See also: https://docs.databricks.com/api/workspace/instancepools/delete
```

### databricks.JDBCConnection

Superclass: handle

```text
JDBCConnection - Creates a Database Toolbox connection object

    The primary role of this class is to construct the connection URL used
    by the Databricks JDBC driver. Essentially this URL combines a large
    number
    of configuration values. This is error prone to construct by hand.

    The Connection object is stored in the JDBCConnection's Connection
    property.
    By default the class will use the same authentication provider chain as
    used by the REST API interfaces, see Documentation/Authentication.md.

    The following optional named arguments can be used to override the
    values
    obtained from settings & configuration files and defaults.

       Name                       Type      Default
       --------------------------------------------
       % JDBC Driver configuration
       driverClass                string
       "com.databricks.client.jdbc.Driver"
       jarFilePath                string
       databricksRoot('lib','jar','Shaded-Databricks-JDBC-Driver-0.0.2.jar')
       useDriverType              char      Must be either 'oss' or 'simba'

       % Provide the connection string directly
       % connectionURL overrides the complete connection URL value.
       connectionURL              string
       % connectionURLAppend a value appended to the connection URL.
       connectionURLAppend        string

       % Databricks host and port
       % If the DATABRICKS_SERVER_HOSTNAME environment variable value is set
       it will
       % override the host argument. The configuration file host value
       respects the
       % DATABRICKS_HOST environment variable.
       host                       string
       port                       string    "443"

       % Set a schema and catalog
       % schema name of the database/schema to use
       schema                     string    "default"
       % catalog set the Unity Catalog catalog
       catalog                    string

       % Leading and trailing whitespace is removed from unescaped catalog
       and schema\
       % arguments.
       % If a catalog or schema contains a hyphen or space and is not
       already escaped
       % using backticks, the backticks will be added automatically. This
       does not apply
       % if they are named in the SQL statement.

       % Set a specific cluster, should be a databricks.Cluster(scalar) or a
       scalar string/char
       cluster                    databricks.Cluster or Cluster Id

       % Authentication
       % By default the JDBC drivers authentication mechanism is used to
       % retrieve tokens for OAuth2 flows.
       useDriverAuth              logical   true
       % authMethod a matlab.databricks.AuthMethod
       % to force a given authentication method default preferred method
       % is not used. See: Documentation/Authentication.md
       authMethod                 matlab.databricks.AuthMethod    Settings
       file authMethod value
       %  profileName a scalar text name for a profile to be sourced
       % from a .databrickscfg file. See: Documentation/Authentication.md
       profileName                string    Settings file profileName value

       % Oauth2
       % Specify an OAuth service provider
       OauthService               matlab.databricks.OauthService
       matlab.databricks.OauthService.Databricks
       % Client Id for OAuth 2.0 authentication, not the OAuthM2M client_id
       oauth2ClientId             string    "databricks-sql-jdbc"
       % Value for a token that is passed opaquely
       passthroughAccessToken     string
       % Value for a token that is passed opaquely
       passthroughRefreshToken    string
       % set the scope used with OAuth flows
       scope                      string
       % Set the TokenCachePassPhrase argument to a password of your choice.
       % This is used for refresh token encryption when using driver based
       authentication.
       % The default is the user's username, this is NOT secure.
       TokenCachePassPhrase       string
       % Controls caching of tokens when using driver based
       % authentication only
       enableTokenCache           logical
       % cacheFilePath Path used to cache tokens when using the package's
       authentication only.
       % PATs are stored in <home directory>/.databrickscfg by default.
       cacheFilePath              string

       % httpPath overrides the httpPath portion of the connection URL.
       % If the DATABRICKS_HTTP_PATH environment variable is set it
       overrides the
       % argument or derived valued.
       httpPath                   string
       ssl                        logical   true
       thriftTransport            int32

       defaultStringColumnLength Sets the maximum number of characters that
       can be
       contained in STRING columns. By default, the columns metadata for
       Spark does
       not specify a maximum length for STRING columns. In a future MATLAB
       release
       this can be used to address string truncation for long strings > 4000
       characters in length.
       defaultStringColumnLength  int32

       % Database Explorer App Data Source
       % Prevents automatic creation of a Data Source object
       disableSourceCreation      logical   false
       % Set a non default name for the DataSource
       dataSourceName             string    Databricks-<Cluster Id>

       % Write optimization (Simba driver only)
       useNativeQuery                 logical   true
       enableNativeParameterizedQuery logical   false

       % A string text logging level.
       logLevel                   string    "0"
       % A logical flag to enable more or less feedback,
       % default is true.
       verbose                    logical   true

    This class requires the Databricks Simba JDBC driver v2.7.3 and greater,
    or the Databricks OSS JDBC driver v1.0.7 or greater.

    This functionality is independent of the Spark.sql() functionality which
    can also be used to execute SQL commands on Databricks.

    Call the Connection's close method when the connection is no longer
    needed.
    The object's close method will also call the connection's close method.
    This is also called by the object's delete destructor.

    If a connection cannot be created an empty database.jdbc.connection is
    returned
    in the connection property. If a JDBC Driver Error is returned in the
    connection's
    Message property it will be displayed but an error will not be raised
    directly.

    Examples:
       j = databricks.JDBCConnection(schema='myDatabaseName');
       conn = j.Connection;

       j = databricks.JDBCConnection; % Use default schema/database name:
       "default"
       data = fetch(j.Connection, "SELECT * FROM mycatalog.myschema.mytable
       LIMIT 10");

    The connectionURLAppend argument can be used to add further values to
    the
    connection URL. It is appended to the constructed value.

    If using token passthrough an access token obtained by some means is
    passed
    as a named (passthroughAccessToken) argument. A corresponding optional
    passthrough
    refresh token can be passed using the passthroughRefreshToken argument.
    Be aware that these tokens will expire. At which point a new connection
    must
    be made with new tokens.

    The priority order for selecting the authentication mechanism is as
    follows:
      1) A connectionURL is provided is is used first.
      2) A passthroughAccessToken and optional passthroughRefreshToken is
      used second.
      3) If useDriverAuth is set to false then the package's authentication
      is used.
      4) (Default) The drivers authentication support is used.
         If using OAuthU2M the driver authentication is not supported and so
         the
         package's authentication is used.

    If using PAT authentication with MATLAB on Databricks then a token
    automatically
    taken from the user context will not work and PAT value must be
    provided,
    and typically updated in the .databrickscfg configuration file.

    See also:
    https://docs.databricks.com/en/_extras/documents/Databricks-JDBC-Driver-Install-and-Configuration-Guide.pdf

    Logging has not been configured or minimized for the OSS driver by
    default
    at this point for diagnostic purposes.

    By default if using a Java version > 8 and the OSS driver is present it
    will
    be used.

    For OSS driver parameters see:
    https://raw.githubusercontent.com/databricks/databricks-jdbc/refs/heads/main/src/main/java/com/databricks/jdbc/common/DatabricksJdbcUrlParams.java
```

#### databricks.JDBCConnection.JDBCConnection

```text
JDBCConnection - Creates a Database Toolbox connection object

    The primary role of this class is to construct the connection URL used
    by the Databricks JDBC driver. Essentially this URL combines a large
    number
    of configuration values. This is error prone to construct by hand.

    The Connection object is stored in the JDBCConnection's Connection
    property.
    By default the class will use the same authentication provider chain as
    used by the REST API interfaces, see Documentation/Authentication.md.

    The following optional named arguments can be used to override the
    values
    obtained from settings & configuration files and defaults.

       Name                       Type      Default
       --------------------------------------------
       % JDBC Driver configuration
       driverClass                string
       "com.databricks.client.jdbc.Driver"
       jarFilePath                string
       databricksRoot('lib','jar','Shaded-Databricks-JDBC-Driver-0.0.2.jar')
       useDriverType              char      Must be either 'oss' or 'simba'

       % Provide the connection string directly
       % connectionURL overrides the complete connection URL value.
       connectionURL              string
       % connectionURLAppend a value appended to the connection URL.
       connectionURLAppend        string

       % Databricks host and port
       % If the DATABRICKS_SERVER_HOSTNAME environment variable value is set
       it will
       % override the host argument. The configuration file host value
       respects the
       % DATABRICKS_HOST environment variable.
       host                       string
       port                       string    "443"

       % Set a schema and catalog
       % schema name of the database/schema to use
       schema                     string    "default"
       % catalog set the Unity Catalog catalog
       catalog                    string

       % Leading and trailing whitespace is removed from unescaped catalog
       and schema\
       % arguments.
       % If a catalog or schema contains a hyphen or space and is not
       already escaped
       % using backticks, the backticks will be added automatically. This
       does not apply
       % if they are named in the SQL statement.

       % Set a specific cluster, should be a databricks.Cluster(scalar) or a
       scalar string/char
       cluster                    databricks.Cluster or Cluster Id

       % Authentication
       % By default the JDBC drivers authentication mechanism is used to
       % retrieve tokens for OAuth2 flows.
       useDriverAuth              logical   true
       % authMethod a matlab.databricks.AuthMethod
       % to force a given authentication method default preferred method
       % is not used. See: Documentation/Authentication.md
       authMethod                 matlab.databricks.AuthMethod    Settings
       file authMethod value
       %  profileName a scalar text name for a profile to be sourced
       % from a .databrickscfg file. See: Documentation/Authentication.md
       profileName                string    Settings file profileName value

       % Oauth2
       % Specify an OAuth service provider
       OauthService               matlab.databricks.OauthService
       matlab.databricks.OauthService.Databricks
       % Client Id for OAuth 2.0 authentication, not the OAuthM2M client_id
       oauth2ClientId             string    "databricks-sql-jdbc"
       % Value for a token that is passed opaquely
       passthroughAccessToken     string
       % Value for a token that is passed opaquely
       passthroughRefreshToken    string
       % set the scope used with OAuth flows
       scope                      string
       % Set the TokenCachePassPhrase argument to a password of your choice.
       % This is used for refresh token encryption when using driver based
       authentication.
       % The default is the user's username, this is NOT secure.
       TokenCachePassPhrase       string
       % Controls caching of tokens when using driver based
       % authentication only
       enableTokenCache           logical
       % cacheFilePath Path used to cache tokens when using the package's
       authentication only.
       % PATs are stored in <home directory>/.databrickscfg by default.
       cacheFilePath              string

       % httpPath overrides the httpPath portion of the connection URL.
       % If the DATABRICKS_HTTP_PATH environment variable is set it
       overrides the
       % argument or derived valued.
       httpPath                   string
       ssl                        logical   true
       thriftTransport            int32

       defaultStringColumnLength Sets the maximum number of characters that
       can be
       contained in STRING columns. By default, the columns metadata for
       Spark does
       not specify a maximum length for STRING columns. In a future MATLAB
       release
       this can be used to address string truncation for long strings > 4000
       characters in length.
       defaultStringColumnLength  int32

       % Database Explorer App Data Source
       % Prevents automatic creation of a Data Source object
       disableSourceCreation      logical   false
       % Set a non default name for the DataSource
       dataSourceName             string    Databricks-<Cluster Id>

       % Write optimization (Simba driver only)
       useNativeQuery                 logical   true
       enableNativeParameterizedQuery logical   false

       % A string text logging level.
       logLevel                   string    "0"
       % A logical flag to enable more or less feedback,
       % default is true.
       verbose                    logical   true

    This class requires the Databricks Simba JDBC driver v2.7.3 and greater,
    or the Databricks OSS JDBC driver v1.0.7 or greater.

    This functionality is independent of the Spark.sql() functionality which
    can also be used to execute SQL commands on Databricks.

    Call the Connection's close method when the connection is no longer
    needed.
    The object's close method will also call the connection's close method.
    This is also called by the object's delete destructor.

    If a connection cannot be created an empty database.jdbc.connection is
    returned
    in the connection property. If a JDBC Driver Error is returned in the
    connection's
    Message property it will be displayed but an error will not be raised
    directly.

    Examples:
       j = databricks.JDBCConnection(schema='myDatabaseName');
       conn = j.Connection;

       j = databricks.JDBCConnection; % Use default schema/database name:
       "default"
       data = fetch(j.Connection, "SELECT * FROM mycatalog.myschema.mytable
       LIMIT 10");

    The connectionURLAppend argument can be used to add further values to
    the
    connection URL. It is appended to the constructed value.

    If using token passthrough an access token obtained by some means is
    passed
    as a named (passthroughAccessToken) argument. A corresponding optional
    passthrough
    refresh token can be passed using the passthroughRefreshToken argument.
    Be aware that these tokens will expire. At which point a new connection
    must
    be made with new tokens.

    The priority order for selecting the authentication mechanism is as
    follows:
      1) A connectionURL is provided is is used first.
      2) A passthroughAccessToken and optional passthroughRefreshToken is
      used second.
      3) If useDriverAuth is set to false then the package's authentication
      is used.
      4) (Default) The drivers authentication support is used.
         If using OAuthU2M the driver authentication is not supported and so
         the
         package's authentication is used.

    If using PAT authentication with MATLAB on Databricks then a token
    automatically
    taken from the user context will not work and PAT value must be
    provided,
    and typically updated in the .databrickscfg configuration file.

    See also:
    https://docs.databricks.com/en/_extras/documents/Databricks-JDBC-Driver-Install-and-Configuration-Guide.pdf

    Logging has not been configured or minimized for the OSS driver by
    default
    at this point for diagnostic purposes.

    By default if using a Java version > 8 and the OSS driver is present it
    will
    be used.

    For OSS driver parameters see:
    https://raw.githubusercontent.com/databricks/databricks-jdbc/refs/heads/main/src/main/java/com/databricks/jdbc/common/DatabricksJdbcUrlParams.java

    Documentation for databricks.JDBCConnection
```

#### databricks.JDBCConnection.checkDataSources

```text
CHECKDATASOURCES Checks that schema name does not collide with a saved datasource name
```

#### databricks.JDBCConnection.close

```text
close - Close one or more figures

    Syntax
      close
      close(fig)
      close force
      close all
      close all hidden
      close all force
      status = close(___)

    Input Arguments
      fig - Figure to close
        one or more Figure objects, figure numbers, or figure names

    Examples
      openExample('graphics/DeleteASingleFigureExample')
      openExample('graphics/DeleteMultipleFiguresExample')
      openExample('graphics/DeleteFigureWithSpecifiedNumberExample')
      openExample('graphics/DeleteFigureWithSpecifiedNameExample')
      openExample('graphics/VerifyFiguresWasDeletedExample')
      openExample('graphics/DeleteAllFiguresSimultaneouslyExample')
      openExample('graphics/DeleteAllFiguresWithVisibleOrHiddenHandleExample')
      openExample('graphics/DeleteFigureWhoseWindowCannotBeClosedExample')

    See also delete, figure, gcf, Figure

    Introduced in MATLAB before R2006a
    Documentation for close
       doc close
```

#### databricks.JDBCConnection.copyToken

```text
COPYTOKEN Copies the connection password/token to the system clipboard
  Returns true if a value is copied, otherwise false.
```

#### databricks.JDBCConnection.createSourceOpts

```text
CREATESOURCEOPTS Creates data source options for the JDBC connection
```

#### databricks.JDBCConnection.escapeUCName

```text
databricks.JDBCConnection.escapeUCName is a function.
    out = databricks.JDBCConnection.escapeUCName(in)
```

#### databricks.JDBCConnection.getAuthArgs

```text
databricks.JDBCConnection/getAuthArgs is a function.
    [authStr, username, password] = getAuthArgs(obj, varargin)
```

#### databricks.JDBCConnection.getDefaultJarFilePath

```text
GETDEFAULTJARFILEPATH Returns the default jar file path for the driver
```

#### databricks.JDBCConnection.getDriverVersion

```text
GETDRIVERVERSION Returns the driver version as a matlab.utils.SemVer
  Works with both the Simba and OSS driver.
  Does not return the patch version, it will always be 0.
  If the driver is not found on the class path then 0.0.0 is returned.
  An optional driverClass may be provided.
```

#### databricks.JDBCConnection.getEnableTokenCache

```text
GETENABLETOKENCACHE Determines if token caching should be
  enabled based on driver type and version
```

#### databricks.JDBCConnection.getHTTPProxy

```text
SETHTTPPROXY Sets HTTP proxy environment variables for Python
```

#### databricks.JDBCConnection.getHttpPath

```text
GETHTTPPATH Determines the HTTP path for Databricks connection string
```

#### databricks.JDBCConnection.getJavaVersion

```text
GETJAVAVERSION Get java version in numeric form and string form
 
  Uses the result of the java.lang.System.getProperty("java.version") command.
 
  For MATLAB's included Java the full version value is: "1.8.0_202"
 
  numericVersion is the single digit Java version returned as a double.
  For Java 1.8 8 is returned otherwise the number preceding the . returned e.g. 17
 
  The fullVersion is the output of java.lang.System.getProperty("java.version").
 
  If a Java environment is not enabled an error is thrown.
 
  Example:
    [numericVersion, fullVersion] = databricks.JDBCConnection.getJavaVersion()
 
  See also: jenv and matlab_jenv
```

#### databricks.JDBCConnection.getPropertyGroups

```text
GETPROPERTYGROUPS Customize the display of JDBCConnection objects
  Redacts sensitive information from the connection URL.
```

#### databricks.JDBCConnection.getScope

```text
GETSCOPE Returns a scope field as a string
```

#### databricks.JDBCConnection.isOSSDriver

```text
ISOSSDRIVER Returns true if the OSS JDBC driver is on the Java class path
```

#### databricks.JDBCConnection.numberOfClassPathEntries

```text
NUMBEROFCLASSPATHENTRIES Returns number of matching JDBC drivers on the Java class paths
  Both the static and dynamic paths are checked.
  An optional jarFilePath can be specified if the driver .jar naming does not
  match the expected conventions.
  The check looks for both the OSS and Simba drivers.
```

#### databricks.JDBCConnection.resolveDriverType

```text
databricks.JDBCConnection.resolveDriverType is a function.
    driverType = databricks.JDBCConnection.resolveDriverType(varargin)
```

#### databricks.JDBCConnection.saveSource

```text
databricks.JDBCConnection/saveSource is a function.
    dataSourceName = saveSource(obj, varargin)
```

#### databricks.JDBCConnection.testConnection

```text
databricks.JDBCConnection/testConnection is a function.
    [tf, message] = testConnection(obj)
```

#### databricks.JDBCConnection.updateJavaclassPath

```text
UPDATEJAVACLASSPATH Adds the specified jar file to the Java class path
```

#### databricks.JDBCConnection.validateCluster

```text
VALIDATECLUSTER Check the clusters state and Spark version
```

#### databricks.JDBCConnection.validateDriverVersion

```text
VALIDATEDRIVERVERSION Validates that the driver version meets minimum requirements
```

### databricks.JDBCConnectionImpl

Superclasses: databricks.internal.Object, matlab.mixin.CustomDisplay

```text
JDBCConnectionImpl Creates a Database Toolbox connection object
 
  The primary role of this class is to construct the connection URL used
  by the Databricks JDBC driver. Essentially this URL combines a large number
  of configuration values. This is error prone to construct by hand.
 
  The Connection object is stored in the JDBCConnectionImpl's Connection property.
  By default the class will use the same authentication provider chain as
  used by the REST API interfaces, see Documentation/Authentication.md.
 
  The following optional named arguments can be used to override the values
  obtained from settings & configuration files and defaults.
 
     Name                       Type      Default
     --------------------------------------------
     % JDBC Driver configuration
     driverClass                string    "com.databricks.client.jdbc.Driver"
     jarFilePath                string    matlab.internal.databricksRoot('lib','jar','Shaded-Databricks-JDBC-Driver-0.0.2.jar')
     useDriverType              char      Must be either 'oss' or 'simba'
 
     % Provide the connection string directly
     % connectionURL overrides the complete connection URL value.
     connectionURL              string
     % connectionURLAppend a value appended to the connection URL.
     connectionURLAppend        string
 
     % Databricks host and port
     % If the DATABRICKS_SERVER_HOSTNAME environment variable value is set it will
     % override the host argument. The configuration file host value respects the
     % DATABRICKS_HOST environment variable.
     host                       string
     port                       string    "443"
 
     % Set a schema and catalog
     % schema name of the database/schema to use
     schema                     string    "default"
     % catalog set the Unity Catalog catalog
     catalog                    string
 
     % Leading and trailing whitespace is removed from unescaped catalog and schema\
     % arguments.
     % If a catalog or schema contains a hyphen or space and is not already escaped
     % using backticks, the backticks will be added automatically. This does not apply
     % if they are named in the SQL statement.
 
     % Set a specific cluster, should be a databricks.Cluster(scalar) or a scalar string/char
     cluster                    databricks.Cluster or Cluster Id
 
     % Authentication
     % By default the JDBC drivers authentication mechanism is used to
     % retrieve tokens for OAuth2 flows.
     useDriverAuth              logical   true
     % authMethod a matlab.internal.databricks.AuthMethod
     % to force a given authentication method default preferred method
     % is not used. See: Documentation/Authentication.md
     authMethod                 matlab.internal.databricks.AuthMethod    Settings file authMethod value
     %  profileName a scalar text name for a profile to be sourced
     % from a .databrickscfg file. See: Documentation/Authentication.md
     profileName                string    Settings file profileName value
 
     % Oauth2
     % Specify an OAuth service provider
     OauthService               matlab.internal.databricks.OauthService    matlab.internal.databricks.OauthService.Databricks
     % Client Id for OAuth 2.0 authentication, not the OAuthM2M client_id
     oauth2ClientId             string    "databricks-sql-jdbc"
     % Value for a token that is passed opaquely
     passthroughAccessToken     string
     % Value for a token that is passed opaquely
     passthroughRefreshToken    string
     % set the scope used with OAuth flows
     scope                      string
     % Set the TokenCachePassPhrase argument to a password of your choice.
     % This is used for refresh token encryption when using driver based authentication.
     % The default is the user's username, this is NOT secure.
     TokenCachePassPhrase       string
     % Controls caching of tokens when using driver based
     % authentication only
     enableTokenCache           logical
     % cacheFilePath Path used to cache tokens when using the package's authentication only.
     % PATs are stored in <home directory>/.databrickscfg by default.
     cacheFilePath              string
 
     % httpPath overrides the httpPath portion of the connection URL.
     % If the DATABRICKS_HTTP_PATH environment variable is set it overrides the
     % argument or derived valued.
     httpPath                   string
     ssl                        logical   true
     thriftTransport            int32
 
     defaultStringColumnLength Sets the maximum number of characters that can be
     contained in STRING columns. By default, the columns metadata for Spark does
     not specify a maximum length for STRING columns. In a future MATLAB release
     this can be used to address string truncation for long strings > 4000
     characters in length.
     defaultStringColumnLength  int32
 
     % Database Explorer App Data Source
     % Prevents automatic creation of a Data Source object
     disableSourceCreation      logical   false
     % Set a non default name for the DataSource
     dataSourceName             string    Databricks-<Cluster Id>
 
     % Write optimization (Simba driver only)
     useNativeQuery                 logical   true
     enableNativeParameterizedQuery logical   false
 
     % A string text logging level.
     logLevel                   string    "0"
     % A logical flag to enable more or less feedback,
     % default is true.
     verbose                    logical   true
 
  This class requires the Databricks Simba JDBC driver v2.7.3 and greater,
  or the Databricks OSS JDBC driver v1.0.7 or greater.
 
  This functionality is independent of the Spark.sql() functionality which
  can also be used to execute SQL commands on Databricks.
 
  Call the Connection's close method when the connection is no longer needed.
  The object's close method will also call the connection's close method.
  This is also called by the object's delete destructor.
 
  If a connection cannot be created an empty database.jdbc.connection is returned
  in the connection property. If a JDBC Driver Error is returned in the connection's
  Message property it will be displayed but an error will not be raised directly.
 
  Examples:
     j = databricks.JDBCConnectionImpl(schema='myDatabaseName');
     conn = j.Connection;
 
     j = databricks.JDBCConnectionImpl; % Use default schema/database name: "default"
     data = fetch(j.Connection, "SELECT * FROM mycatalog.myschema.mytable LIMIT 10");
 
  The connectionURLAppend argument can be used to add further values to the
  connection URL. It is appended to the constructed value.
 
  If using token passthrough an access token obtained by some means is passed
  as a named (passthroughAccessToken) argument. A corresponding optional passthrough
  refresh token can be passed using the passthroughRefreshToken argument.
  Be aware that these tokens will expire. At which point a new connection must
  be made with new tokens.
 
  The priority order for selecting the authentication mechanism is as follows:
    1) A connectionURL is provided is is used first.
    2) A passthroughAccessToken and optional passthroughRefreshToken is used second.
    3) If useDriverAuth is set to false then the package's authentication is used.
    4) (Default) The drivers authentication support is used.
       If using OAuthU2M the driver authentication is not supported and so the
       package's authentication is used.
 
  If using PAT authentication with MATLAB on Databricks then a token automatically
  taken from the user context will not work and PAT value must be provided,
  and typically updated in the .databrickscfg configuration file.
 
  See also: https://docs.databricks.com/en/_extras/documents/Databricks-JDBC-Driver-Install-and-Configuration-Guide.pdf
 
  Logging has not been configured or minimized for the OSS driver by default
  at this point for diagnostic purposes.
 
  By default if using a Java version > 8 and the OSS driver is present it will
  be used.
 
  For OSS driver parameters see: https://raw.githubusercontent.com/databricks/databricks-jdbc/refs/heads/main/src/main/java/com/databricks/jdbc/common/DatabricksJdbcUrlParams.java
```

#### databricks.JDBCConnectionImpl.JDBCConnectionImpl

```text
JDBCConnectionImpl Creates a Database Toolbox connection object
 
  The primary role of this class is to construct the connection URL used
  by the Databricks JDBC driver. Essentially this URL combines a large number
  of configuration values. This is error prone to construct by hand.
 
  The Connection object is stored in the JDBCConnectionImpl's Connection property.
  By default the class will use the same authentication provider chain as
  used by the REST API interfaces, see Documentation/Authentication.md.
 
  The following optional named arguments can be used to override the values
  obtained from settings & configuration files and defaults.
 
     Name                       Type      Default
     --------------------------------------------
     % JDBC Driver configuration
     driverClass                string    "com.databricks.client.jdbc.Driver"
     jarFilePath                string    matlab.internal.databricksRoot('lib','jar','Shaded-Databricks-JDBC-Driver-0.0.2.jar')
     useDriverType              char      Must be either 'oss' or 'simba'
 
     % Provide the connection string directly
     % connectionURL overrides the complete connection URL value.
     connectionURL              string
     % connectionURLAppend a value appended to the connection URL.
     connectionURLAppend        string
 
     % Databricks host and port
     % If the DATABRICKS_SERVER_HOSTNAME environment variable value is set it will
     % override the host argument. The configuration file host value respects the
     % DATABRICKS_HOST environment variable.
     host                       string
     port                       string    "443"
 
     % Set a schema and catalog
     % schema name of the database/schema to use
     schema                     string    "default"
     % catalog set the Unity Catalog catalog
     catalog                    string
 
     % Leading and trailing whitespace is removed from unescaped catalog and schema\
     % arguments.
     % If a catalog or schema contains a hyphen or space and is not already escaped
     % using backticks, the backticks will be added automatically. This does not apply
     % if they are named in the SQL statement.
 
     % Set a specific cluster, should be a databricks.Cluster(scalar) or a scalar string/char
     cluster                    databricks.Cluster or Cluster Id
 
     % Authentication
     % By default the JDBC drivers authentication mechanism is used to
     % retrieve tokens for OAuth2 flows.
     useDriverAuth              logical   true
     % authMethod a matlab.internal.databricks.AuthMethod
     % to force a given authentication method default preferred method
     % is not used. See: Documentation/Authentication.md
     authMethod                 matlab.internal.databricks.AuthMethod    Settings file authMethod value
     %  profileName a scalar text name for a profile to be sourced
     % from a .databrickscfg file. See: Documentation/Authentication.md
     profileName                string    Settings file profileName value
 
     % Oauth2
     % Specify an OAuth service provider
     OauthService               matlab.internal.databricks.OauthService    matlab.internal.databricks.OauthService.Databricks
     % Client Id for OAuth 2.0 authentication, not the OAuthM2M client_id
     oauth2ClientId             string    "databricks-sql-jdbc"
     % Value for a token that is passed opaquely
     passthroughAccessToken     string
     % Value for a token that is passed opaquely
     passthroughRefreshToken    string
     % set the scope used with OAuth flows
     scope                      string
     % Set the TokenCachePassPhrase argument to a password of your choice.
     % This is used for refresh token encryption when using driver based authentication.
     % The default is the user's username, this is NOT secure.
     TokenCachePassPhrase       string
     % Controls caching of tokens when using driver based
     % authentication only
     enableTokenCache           logical
     % cacheFilePath Path used to cache tokens when using the package's authentication only.
     % PATs are stored in <home directory>/.databrickscfg by default.
     cacheFilePath              string
 
     % httpPath overrides the httpPath portion of the connection URL.
     % If the DATABRICKS_HTTP_PATH environment variable is set it overrides the
     % argument or derived valued.
     httpPath                   string
     ssl                        logical   true
     thriftTransport            int32
 
     defaultStringColumnLength Sets the maximum number of characters that can be
     contained in STRING columns. By default, the columns metadata for Spark does
     not specify a maximum length for STRING columns. In a future MATLAB release
     this can be used to address string truncation for long strings > 4000
     characters in length.
     defaultStringColumnLength  int32
 
     % Database Explorer App Data Source
     % Prevents automatic creation of a Data Source object
     disableSourceCreation      logical   false
     % Set a non default name for the DataSource
     dataSourceName             string    Databricks-<Cluster Id>
 
     % Write optimization (Simba driver only)
     useNativeQuery                 logical   true
     enableNativeParameterizedQuery logical   false
 
     % A string text logging level.
     logLevel                   string    "0"
     % A logical flag to enable more or less feedback,
     % default is true.
     verbose                    logical   true
 
  This class requires the Databricks Simba JDBC driver v2.7.3 and greater,
  or the Databricks OSS JDBC driver v1.0.7 or greater.
 
  This functionality is independent of the Spark.sql() functionality which
  can also be used to execute SQL commands on Databricks.
 
  Call the Connection's close method when the connection is no longer needed.
  The object's close method will also call the connection's close method.
  This is also called by the object's delete destructor.
 
  If a connection cannot be created an empty database.jdbc.connection is returned
  in the connection property. If a JDBC Driver Error is returned in the connection's
  Message property it will be displayed but an error will not be raised directly.
 
  Examples:
     j = databricks.JDBCConnectionImpl(schema='myDatabaseName');
     conn = j.Connection;
 
     j = databricks.JDBCConnectionImpl; % Use default schema/database name: "default"
     data = fetch(j.Connection, "SELECT * FROM mycatalog.myschema.mytable LIMIT 10");
 
  The connectionURLAppend argument can be used to add further values to the
  connection URL. It is appended to the constructed value.
 
  If using token passthrough an access token obtained by some means is passed
  as a named (passthroughAccessToken) argument. A corresponding optional passthrough
  refresh token can be passed using the passthroughRefreshToken argument.
  Be aware that these tokens will expire. At which point a new connection must
  be made with new tokens.
 
  The priority order for selecting the authentication mechanism is as follows:
    1) A connectionURL is provided is is used first.
    2) A passthroughAccessToken and optional passthroughRefreshToken is used second.
    3) If useDriverAuth is set to false then the package's authentication is used.
    4) (Default) The drivers authentication support is used.
       If using OAuthU2M the driver authentication is not supported and so the
       package's authentication is used.
 
  If using PAT authentication with MATLAB on Databricks then a token automatically
  taken from the user context will not work and PAT value must be provided,
  and typically updated in the .databrickscfg configuration file.
 
  See also: https://docs.databricks.com/en/_extras/documents/Databricks-JDBC-Driver-Install-and-Configuration-Guide.pdf
 
  Logging has not been configured or minimized for the OSS driver by default
  at this point for diagnostic purposes.
 
  By default if using a Java version > 8 and the OSS driver is present it will
  be used.
 
  For OSS driver parameters see: https://raw.githubusercontent.com/databricks/databricks-jdbc/refs/heads/main/src/main/java/com/databricks/jdbc/common/DatabricksJdbcUrlParams.java

    Documentation for databricks.JDBCConnectionImpl
```

#### databricks.JDBCConnectionImpl.checkDataSources

```text
CHECKDATASOURCES Checks that schema name does not collide with a saved datasource name
```

#### databricks.JDBCConnectionImpl.close

```text
close - Close one or more figures

    Syntax
      close
      close(fig)
      close force
      close all
      close all hidden
      close all force
      status = close(___)

    Input Arguments
      fig - Figure to close
        one or more Figure objects, figure numbers, or figure names

    Examples
      openExample('graphics/DeleteASingleFigureExample')
      openExample('graphics/DeleteMultipleFiguresExample')
      openExample('graphics/DeleteFigureWithSpecifiedNumberExample')
      openExample('graphics/DeleteFigureWithSpecifiedNameExample')
      openExample('graphics/VerifyFiguresWasDeletedExample')
      openExample('graphics/DeleteAllFiguresSimultaneouslyExample')
      openExample('graphics/DeleteAllFiguresWithVisibleOrHiddenHandleExample')
      openExample('graphics/DeleteFigureWhoseWindowCannotBeClosedExample')

    See also delete, figure, gcf, Figure

    Introduced in MATLAB before R2006a
    Documentation for close
       doc close
```

#### databricks.JDBCConnectionImpl.copyToken

```text
COPYTOKEN Copies the connection password/token to the system clipboard
  Returns true if a value is copied, otherwise false.
```

#### databricks.JDBCConnectionImpl.createSourceOpts

```text
CREATESOURCEOPTS Creates data source options for the JDBC connection
```

#### databricks.JDBCConnectionImpl.delete

```text
delete - Delete files or objects

    Syntax
      delete filename
      delete filename1 ... filenameN
      delete(___,ResolveSymbolicLinks=tf)
      delete(obj)

    Input Arguments
      filename - Name of file to delete
        string array | character vector | cell array of character vectors
      obj - Object
        single object | array of objects
      tf - Remove target of symbolic link
        false or 0 (default) | true or 1

    Examples
      openExample('matlab/DeleteFilesInFolderExample')
      openExample('matlab/DeleteGraphicsObjectsExample')

    See also clear, dir, recycle, rmdir, delete

    Introduced in MATLAB before R2006a
    Documentation for delete
       doc delete
```

#### databricks.JDBCConnectionImpl.escapeUCName

```text
databricks.JDBCConnectionImpl.escapeUCName is a function.
    out = escapeUCName(in)
```

#### databricks.JDBCConnectionImpl.getAuthArgs

```text
databricks.JDBCConnectionImpl/getAuthArgs is a function.
    authStr = getAuthArgs(obj, authSrc, host, driverVersion, useDriverType)
    authStr = getAuthArgs(___, Name, Value)
    [authStr, username] = getAuthArgs(___)
    [authStr, username, password] = getAuthArgs(___)
```

#### databricks.JDBCConnectionImpl.getDefaultJarFilePath

```text
GETDEFAULTJARFILEPATH Returns the default jar file path for the driver
```

#### databricks.JDBCConnectionImpl.getDriverVersion

```text
GETDRIVERVERSION Returns the driver version as a matlab.internal.utils.SemVer
  Works with both the Simba and OSS driver.
  Does not return the patch version, it will always be 0.
  If the driver is not found on the class path then 0.0.0 is returned.
  An optional driverClass may be provided.
```

#### databricks.JDBCConnectionImpl.getEnableTokenCache

```text
GETENABLETOKENCACHE Determines if token caching should be enabled based on driver type and version
```

#### databricks.JDBCConnectionImpl.getHTTPProxy

```text
SETHTTPPROXY Sets HTTP proxy environment variables for Python
```

#### databricks.JDBCConnectionImpl.getHttpPath

```text
GETHTTPPATH Determines the HTTP path for Databricks connection string
```

#### databricks.JDBCConnectionImpl.getJavaVersion

```text
GETJAVAVERSION Get java version in numeric form and string form
 
  Uses the result of the java.lang.System.getProperty("java.version") command.
 
  For MATLAB's included Java the full version value is: "1.8.0_202"
 
  numericVersion is the single digit Java version returned as a double.
  For Java 1.8 8 is returned otherwise the number preceding the . returned e.g. 17
 
  The fullVersion is the output of java.lang.System.getProperty("java.version").
 
  If a Java environment is not enabled an error is thrown.
 
  Example:
    [numericVersion, fullVersion] = databricks.JDBCConnectionImpl.getJavaVersion()
 
  See also: jenv and matlab_jenv
```

#### databricks.JDBCConnectionImpl.getPropertyGroups

```text
GETPROPERTYGROUPS Customize the display of JDBCConnection objects
  Redacts sensitive information from the connection URL.
```

#### databricks.JDBCConnectionImpl.getScope

```text
GETSCOPE Returns a scope field as a string
```

#### databricks.JDBCConnectionImpl.isOSSDriver

```text
ISOSSDRIVER Returns true if the OSS JDBC driver is on the Java class path
```

#### databricks.JDBCConnectionImpl.numberOfClassPathEntries

```text
NUMBEROFCLASSPATHENTRIES Returns number of matching JDBC drivers on the Java class paths
  Both the static and dynamic paths are checked.
  An optional jarFilePath can be specified if the driver .jar naming does not
  match the expected conventions.
  The check looks for both the OSS and Simba drivers.
```

#### databricks.JDBCConnectionImpl.saveSource

```text
SAVESOURCE Saves the data source the Data Explorer app UI
```

#### databricks.JDBCConnectionImpl.testConnection

```text
TESTCONNECTION Tests the JDBC connection
```

#### databricks.JDBCConnectionImpl.updateJavaclassPath

```text
UPDATEJAVACLASSPATH Adds the specified jar file to the Java class path
```

#### databricks.JDBCConnectionImpl.validateCluster

```text
VALIDATECLUSTER Check the clusters state and Spark version
```

#### databricks.JDBCConnectionImpl.validateDriverVersion

```text
VALIDATEDRIVERVERSION Validates that the driver version meets minimum requirements
```

### databricks.Job

Superclass: databricks.Object

```text
JOB Databricks Job API
  The Jobs API allows you to create, edit, and delete jobs. The maximum 
  allowed size of a request to the Jobs API is 10MB.
 
    jh = databricks.Job;
 
  Alternatively, 
 
    jh = databricks.Job('HOST','TOKEN');
    jh.max_retries = 1;                  % Set a non-default value
 
  The default value for max_retries(0) configures the job to never retry. 
  A value of -1 means to retry indefinitely
```

#### databricks.Job.Job

```text
JOB Databricks Job API
  The Jobs API allows you to create, edit, and delete jobs. The maximum 
  allowed size of a request to the Jobs API is 10MB.
 
    jh = databricks.Job;
 
  Alternatively, 
 
    jh = databricks.Job('HOST','TOKEN');
    jh.max_retries = 1;                  % Set a non-default value
 
  The default value for max_retries(0) configures the job to never retry. 
  A value of -1 means to retry indefinitely

    Documentation for databricks.Job
```

#### databricks.Job.create

```text
CREATE Method to create a new job using a new or existing Spark cluster
  The job creation can be configured using the properties and methods of
  this object.
 
  For example, to run a job using a new cluster:
 
    % Setup Cluster configuration
    cl = databricks.Cluster();
    cl.setNumWorkers([2 10]); % autoscaling cluster
 
    % Setup job configuration
    jb = databricks.Job;
    jb.name = 'TestJob';
    jb.setCluster(cl);
    jb.create();
```

#### databricks.Job.getPayload

```text
GETPAYLOAD Internal method to create the request payload by removing properties
```

#### databricks.Job.list

```text
LIST Create a list of databricks jobs.
  This method can be used to create a list of jobs.
 
  Example:
    jl = databricks.Job.list();
 
  The returned job handles can be used to manage the jobs.
```

#### databricks.Job.refresh

```text
REFRESH Method to refresh information about a Spark Job
  Retrieves information about a single job.
  
    jb = databricks.Job();
    jb.setJobId(87);
    jb.refresh();
  
  The resulting structure contains information about the job.
```

#### databricks.Job.remove

```text
REMOVE Method to remove/delete a job
  Remove / delete the job and send an email to the addresses specified in
  JobSettings.email_notifications. No action occurs if the job has already
  been removed. After the job is removed, neither its details or its run
  history is visible via the Jobs UI or API.
 
  The job is guaranteed to be removed upon completion of this request.
  However, runs that were active before the receipt of this request may
  still be active. They will be terminated asynchronously.
 
    jb = databricks.Job;
    jb.setJobId(4);
    jb.remove();
 
  This method in the Databricks API is called delete. It's called
  remove here, to avoid confusion with the built-in MATLAB delete
  method.
```

#### databricks.Job.runNow

```text
RUNNOW Method to run a job now.
  Run a job now populate the details of the job
 
    jb = databricks.Job;
 
    TODO %% Configure & create the job %%
 
    % Run the job
    jb.runNow();
```

#### databricks.Job.setCluster

```text
SETCLUSTER Method to configure the cluster details for a job
  If an existing cluster is to be used then that cluster's cluster_id
  property should be provided. If a new cluster should be created then to
  execute the job the a Cluster object should be provided. Note the Cluster
  object's cluster_id and name should not be set.
 
  When running jobs on an existing cluster, you may need to manually
  restart the cluster if it stops responding. Running jobs
  on new clusters provides greater reliability.
 
  For example, to use an existing cluster:
 
    jb = databricks.Job;
    jb.name = 'Example';
    % Use the cluster_id of an existing Cluster object e.g. cl.cluster_id
    jb.setCluster('0716-182237-eta530');
 
  If a new a cluster is desired, provide a Cluster object:
 
    cl = databricks.Cluster
    cl.setNumWorkers([2 10]);
 
    jb = databricks.Job;
    jb.name = 'Example';
    jb.setCluster(cl);
```

#### databricks.Job.setJobEmailNotifications

```text
SETJOBEMAILNOTIFICATIONS Method to set email notifications
  Sets email address to be notified on job start, success, failure & skipped
 
  For example:
 
    jen = databricks.JobEmailNotifications;
    jen.on_start = {'myaddress@example.com'};
    jen.on_success = {'myaddress@example.com'};
    jen.on_failure = {'myaddress@example.com'};
    jen.no_alert_for_skipped_runs = true;
 
    job = databricks.Job;
    job.setJobEmailNotifications(jen);
 
 
    If a string is provided to this method, it will create a
    databricks.JobEmailNotifications object with 'on_start', 'on_success',
    and 'on_failure' all set to this email address, e.g.
 
    job = databricks.Job;
    job.setJobEmailNotifications('myaddress@example.com');
 
    If multiple addresses are required a cell array of character vectors can be
    provided.
 
    getNotificationEmail can be used to get a preconfigured address in the
    databricks-settings.json configuration file or attempt to derive the user's address:
 
    jen = databricks.JobEmailNotifications;
    notificationEmail = jen.getNotificationEmail;
     or
    notificationEmail = databricks.JobEmailNotifications.getNotificationEmail;
 
    If no argument is provided, an attempt will be made to set the notification
    address for all states automatically:
 
    job.setJobEmailNotifications();
```

#### databricks.Job.setJobId

```text
SETJOBID Method to set the Job ID for a given job
  Setting the Job ID for a given object will initialize the object handle
  to point to a particular job on the databricks system.
  
    j = databricks.Job;
    j.setJobId(3); % sets the job_id to 3
  
  When initialized further operations such as refresh and remove are
  enabled.
```

#### databricks.Job.setLibrary

```text
SETLIBRARY Method to set a library for the current job
  Set the location of the library. The library is specified as a
  databricks.Library object and will allow users to specify the location of
  the library on DBFS or S3.
 
  Use the databricks.DBFS object to upload the output of the MATLAB
  compiler to the storage service. This can then be configured as:
 
    % Create a library definition
    lib = databricks.Library;
    lib.setType('jar');
    lib.jar = 'dbfs:/example/meanArrivalDemoApp.jar'
 
    % Attach the library to the current job
```

#### databricks.Job.setRunAs

```text
SETRUNAS Specifies the user or service principal that the job runs as
  If not specified, the job runs as the user who created the job.
  Only user_name or service_principal_name can be specified as the type.
 
  Type user_name should specify the email of an active workspace user.
  Non-admin users can only set this field to their own email.
 
  Type service_principal_name should specify Application ID of an active
  service principal. Setting this field requires the servicePrincipal/user
  role.
 
  Examples:
    j = databricks.Job;
    j.runAs("user_name", "joe@example.com");
 
    j = databricks.Job;
    j.runAs("service_principal_name", "123bc6d0-ffa3-11ed-be56-1234ac123456");
```

#### databricks.Job.setSchedule

```text
SETSCHEDULE Set an optional periodic schedule for a job
  The default behavior is that the job runs when triggered by the runNow method.
  An argument of type databricks.CronSchedule is required.
 
  For example:
 
    job = databricks.Job;
    cs = databricks.CronSchedule;
    cs.setQuartzCronExpression("0 15 22 * * ?");
    cs.setPauseStatus("PAUSED");
    cs.setTimezoneId("Ireland/Dublin");
    job.setSchedule(cs);
```

#### databricks.Job.setTask

```text
SETTASK Method to attach a task to the configured job
  Attaching a task to a job configures the job to execute the task when
  run. This task can be a configured:
    databricks.SparkJarTask,
    databricks.SparkSubmitTask (Deprecated)
    databricks.NotebookTask
    databricks.SparkPythonTask
 
    % Create a task and attach to a job
    task = databricks.NotebookTask;
    jb = databricks.Job;
    jb.setTask(task);
 
  SparkSubmitTask is deprecated and should no longer be used see:
  https://docs.databricks.com/aws/en/jobs/spark-submit
  Existing support will be removed in a future release
```

#### databricks.Job.setTimeoutSeconds

```text
SETTIMEOUTSECONDS Method to set the timeout on the configured job
  The provided value timeout will be converted to an int32.
  The default value is 3600 seconds.
 
    % Create a Job and set a timeout
    jb = databricks.Job;
    jb.setTimeoutSeconds(1000);
```

#### databricks.Job.submit

```text
SUBMIT Method to submit your workloads directly without having to create a job
 
    jb = databricks.Job;
 
    TODO %% Configure & submit %%
 
    % Run the job
    jb.submit();
```

### databricks.JobEmailNotifications

Superclass: databricks.Object

```text
JOBEMAILNOTIFICATIONS Notifications to be sent for Jobs
  Object properties can be used to set email addresses to be notified on
  job start and other events.
 
  To use this object, please specify email addresses to be notified on
  start, success and failure.
  By default alerts on skipped runs are enabled.
```

#### databricks.JobEmailNotifications.JobEmailNotifications

```text
JOBEMAILNOTIFICATIONS Notifications to be sent for Jobs
  Object properties can be used to set email addresses to be notified on
  job start and other events.
 
  To use this object, please specify email addresses to be notified on
  start, success and failure.
  By default alerts on skipped runs are enabled.

    Documentation for databricks.JobEmailNotifications
```

#### databricks.JobEmailNotifications.getNotificationEmail

```text
GETNOTIFICATIONEMAIL Attempts to get email address(es) for job notifications
  If the notificationEmail field of the databricks-settings.json file has been customized
  this will be returned as a character vector or cell array, otherwise an
  attempt will be made to derive the user's email address based on probable
  sources, if this fails an empty character vector will be returned.
 
  Example:
 
    jen = databricks.JobEmailNotifications;
    notificationEmail = jen.getNotificationEmail;
    if isempty(notificationEmail)
        warning('No email address retrieved, notifications will not be used.');
    else
        jen.on_start = notificationEmail;
        jen.on_success = notificationEmail;
        jen.on_failure = notificationEmail;
        job.setJobEmailNotifications(jen);
    end
 
  In practice a JobEmailNotifications object generally does not need to be
  created manually and job notifications can be configured automatically if
  possible as follows: 
 
    job.setJobEmailNotifications();
```

### databricks.Library

Superclass: databricks.Object

```text
LIBRARY A databricks library
  Contains a specification of libraries required for the Spark job to
  execute.
 
  This allows specification of libraries via either DBFS or S3 URIs.
  If S3 is used, make sure the cluster has read access on the library. You
  may need to launch the cluster with an IAM role to access the S3 URI.
 
      lib = databricks.Library();
      lib.setType('jar');
      lib.jar = 'dbfs:/mnt/libraries/library.jar';
 
  An array of this object can be used to configure a databricks.Job.
```

#### databricks.Library.Library

```text
LIBRARY A databricks library
  Contains a specification of libraries required for the Spark job to
  execute.
 
  This allows specification of libraries via either DBFS or S3 URIs.
  If S3 is used, make sure the cluster has read access on the library. You
  may need to launch the cluster with an IAM role to access the S3 URI.
 
      lib = databricks.Library();
      lib.setType('jar');
      lib.jar = 'dbfs:/mnt/libraries/library.jar';
 
  An array of this object can be used to configure a databricks.Job.

    Documentation for databricks.Library
```

#### databricks.Library.getClusterStatus

```text
GETCLUSTERSTATUS Method to get status of libraries
  Get the status of libraries on a cluster. A status will be available for
  all libraries installed on the cluster via the API or the libraries UI as
  well as libraries set to be installed on all clusters via the libraries
  UI. If a library has been set to be installed on all clusters,
  is_library_for_all_clusters will be true, even if the library was also
  installed on the cluster.
 
    lib = databricks.Library;
    lib.getClusterStatus(myCluster.cluster_id);
      ans =
    Library with properties:
     status: 'INSTALLED'
        jar: 'dbfs:/tmp/javabuilder.jar'
 
  Please see:
  https://docs.databricks.com/dev-tools/api/latest/libraries.html
```

#### databricks.Library.getPayload

```text
GETPAYLOAD Method to create a payload for the request
  Internal use only
```

#### databricks.Library.getType

```text
GETTYPE Method to return the type of the library
  If the type is unknown an empty character vector is returned.
  Known types are: jar, egg, whl, pypi, maven, cran & requirements
```

#### databricks.Library.install

```text
INSTALL Method to install a library on a cluster
  Install libraries on a cluster. The installation is asynchronous - it
  completes in the background after the request.
 
    lib = databricks.Library;
    lib.setType('jar');
    lib.jar = 'dbfs:/mylibraries/mylibrary.jar';
 
    clusterId = '1211-151034-4ee14cnm'
    lib.install(clusterId);
 
   If the current configuration for Databricks is pointing to the
   correct cluster, the installation can be done without an argument,
   i.e. 
    lib.install();
 
   A verbose flag can be used to suppress output:
    verbose = false;
    lib.install(clusterId, verbose);
```

#### databricks.Library.setType

```text
SETTYPE Method to specify what kind of Library
  Changing the type of library will empty the current value to reduce the
  chance of misconfiguration.
 
    lib = databricks.Libary();
    lib.setType('jar');
 
  The type of the library can be:
    'jar'           Java Library
    'egg'           Python zip compressed egg file
    'whl'           Python package in the Wheel format
    'pypi'          PyPi coordinates
    'maven'         Maven coordinates
    'cran'          CRAN coordinates
    'requirements'  Requirements specifications
 
  Only one can be specified. If you need multiple libraries, please create
  an array of these objects.
```

#### databricks.Library.table

```text
TABLE Method to list the table data as a table.
  Overloaded method to cast the object as a MATLAB table
```

#### databricks.Library.uninstall

```text
UNINSTALL Method to uninstall a library
  Uninstall a library from a Databricks Cluster
 
    lib = databricks.Library;
    lib.setType('jar');
    lib.jar = 'dbfs:/mylibraries/mylibrary.jar';
 
    clusterId = '0000-000000-demo000'
    lib.uninstall(clusterId);
```

### databricks.MATLABBatchTask

Superclass: databricks.BaseTask

```text
MATLABBATCHTASK Definition of a MATLAB batch mode task
 
  Required Argument
  =================
  statement:
  A scalar string that is the MATLAB code to be executed.
  Typically this invokes a script that encompasses the more
  complex functionality making the statement handling less error prone. An
  exit value of non zero returned to Databricks will be cause the job to fail.
  
  Previously some manual escaping of the statement was required depending on
  its content. This is now automatic and statements should not be
  escaped, aside from conventional escaping of single and double quotes
  as normal to yield a valid MATLAB string.
 
  The MATLAB executing the statement runs as the user given by accountName,
  see below.
 
  Optional Named Arguments
  ========================
  notebookPath:
  If a notebook path is not provided one is created and used for the
  dynamically generated notebook. The Workspace path has the form:
     /Users/username@example.com/tmp/MATLABBatchTask-<UUID>.py
  On completion of the task the file should be deleted. This is not done
  automatically.
  By default an existing notebook of the same name will be overwritten.
  A /Volumes path may also be provided.
 
  If provided the path of the notebook should be an absolute path.
 
  baseParameters:
  Optional base parameters can be passed as a struct. Values must be specified
  as scalar text and can be retrieved by the MATLAB code at runtime using:
    valueString = getenv('structFieldName');
 
  preExecPyCmd, postExecPyCmd, preExecShCmd and postExecShCmd:
  Optional preExecPyCmd, postExecPyCmd, preExecShCmd and postExecShCmd arguments
  can be used to add Python code and shell commands to the notebook that are
  invoked before and or after the MATLAB code. This may be useful "house keeping"
  or invoking other workflows. The order of execution is:
    1. preExecPyCmd
    2. preExecShCmd
    3. MATLAB statement
    4. postExecShCmd
    5. postExecPyCmd
  Shell commands are appended to a "%%sh" magic prefix.
  These commands run as root and must adjust permissions for the accountName
  user accordingly for file access.
 
  A temporary file is created and its name can be retrieved from the environment
  variable MW_RESULT_TEMPFILE This file can be appended to in steps 1,2,4 & 5
  along with the results from step 3.  The first 1 MB of output can be retrieved
  from the job run when the task finishes.
 
  The pre and post execution commands run as root.
  Newlines are automatically appended to each string element of Python and shell
  string array commands when building the underlying the notebook.
 
  MATLABCommand:
  The MATLABCommand argument is the command used to run MATLAB. By default
  this is "matlab -batch". Alternatives may be:
  1)  "matlab -nodesktop -r" is a preferences directory required and provisioned.
 
  2)  "matlab-batch" if working with batch token based licensing, Not to be
      confused with "matlab -batch".
 
  licenseManager:
  The licenseManager argument is used to specify where MATLAB should get its
  license. If specified the `MLM_LICENSE_FILE` environment variable is set to
  the provided value in the notebook. If this value is already set in the docker
  image or cluster definition it is not required at this point.
 
  If using batch token based licensing for CI/CD workflows the argument is still
  used in the normal way if provided, however the value will be ignored.
 
  licenseToken:
  Provide a Batch Token Licensing value. The argument should have the form:
  "user@email.com::encodedToken". When set this values causes the MATLABCommand
  to be set to: "matlab-batch -licensetoken user@email.com::encodedToken"
  rather than the default "matlab -batch". If a specific MATLABCommand argument
  is provided that value is used. License tokens must use the matlab-batch binary.
  This must be included in the MATLAB docker file image at build time.
  The token will be included in the notebook as plain text. The use of secrets
  is therefore the recommended alternative.
 
  licenseTokenSecretKey & licenseTokenSecretScope:
  These arguments allow a Batch Token Licensing value to be retrieved from
  a Databricks secret at runtime.
  If both a secret and licenseToken are specified the secret is used.
 
  If neither a token or secret is specified but the MLM_LICENSE_TOKEN environment
  variable is preferred and if configured in the docker image, cluster definition
  or preExec*Cmd options specify the MATLABCommand option as just "matlab-batch"
  and it will be used automatically.
 
  accountName:
  accountName is the name of user account that is dynamically created on the
  cluster to run the MATLAB task. By default and where possible it will be
  based on the account name on the system used to submit the job. This argument
  allows this value to be specified.
 
  The environment variable `MW_ACCOUNTNAME` can be used to query the account
  name at runtime. The is set in the MATLAB statement section and the pre & post
  exec command sections.
 
  skipAccountNameCheck:
  skipAccountNameCheck is a logical argument, when set to false (default) the
  accountName is validated to check if it is a valid Linux account name. Setting
  this value to true enables the use of accountName values such as "$MYACCOUNTNAME"
  such that the relevant shell cells in the generated notebook use an environment
  variable, that might be defined in a Databricks Asset Bundle, or otherwise at
  runtime. E.g. corresponding to a service principal identity used for scheduled
  workloads.
  Default: false
 
  installDatabricksInterface:
  Logical flag to install the MATLAB Databricks Interface package.
  The package is installed and configured prior to the execution of the MATLAB
  statement. If true and the interface directory or interface package
  is not found the installation will be skipped but the task will still
  be created with a warning.
  Default: true.
 
  installDatabricksDir:
  The directory where the Databricks interface will be installed.
  Default: "/local_disk0/<accountName>/matlab-interface-for-databricks";
 
  installDatabricksOverwrite:
  Logical flag to decide if the Databricks interface should be overwritten,
  in the case it was already installed here.
  Default: false
 
  interfaceDirectory:
  Path to a directory containing a subdirectory "Versions" which contains
  MATLAB Databricks Interface packages in semantically versioned directories.
 
  overwriteNotebook:
  A logical flag that is true by default, meaning that if the created
  notebook will be overwritten if it already exists.
 
  authMethod:
  The authentication method to use for REST API calls.
 
  profileName:
  The name of the profile to use from the .databrickscfg configuration file.
 
  For details on docker file registry access & authentication see:
  Documentation/Authentication.md
 
  Note that only Linux startup options apply in the case of Databricks.
  See also: https://mathworks.com/help/matlab/ref/matlablinux.html
 
  Example:
    baseParameters = struct('massLow', '1200', 'massHigh', '1400');
    t = databricks.MATLABBatchTask("disp('hello world'); disp(getenv('massHigh'))", baseParameters=baseParameters);
 
    t = databricks.MATLABBatchTask("disp(""Hello world""); exit(0)",...
                                    baseParameters=struct('massLow', '1200', 'massHigh', '1400'),...
                                    notebookPath="/Workspace/Users/joe@example.com/MATLABBatchTask.py",...
                                    preExecPyCmd='print("Running preExec")',...
                                    postExecPyCmd='print("Running postExec")',...
                                    preExecShCmd='echo "Running preExec Shell"',...
                                    postExecShCmd='echo "Running postExec Shell"',...
                                    licenseManager="27000@10.0.0.4");
    
    % Specify a cluster to be created when the job runs as a databricks.Cluster object
    % A cluster name is assigned at runtime.
    % Using a policy Id simplifies the cluster configuration by adopting settings defined
    % centrally in the policy.
    c = createDatabricksCluster("", 0, policyId=<policyId, create=false);
 
    % Retrieve the cluster ID from the configuration profile DEFAULT for the current cluster
    clusterId = databricks.internal.configurationprofile.ConfigFile.getProfileField("cluster_id", profileName="DEFAULT");
    jb = databricks.Job;
    jb.name = "my-job-name";
    Assign the cluster to the job
    jb.setCluster(clusterId);
 
    jb.setTask(t);
    jb.create();
    jobRun = jb.runNow();
 
    output = jobRun.getOutput
    output =
      struct with fields:
             metadata: [1x1 databricks.Run]
      notebook_output: [1x1 databricks.datastructures.NotebookOutput]
    output.notebook_output
      ans =
        NotebookOutput with properties:
           result: "['Hello world\n']"
        truncated: 0
```

#### databricks.MATLABBatchTask.MATLABBatchTask

```text
MATLABBATCHTASK Definition of a MATLAB batch mode task
 
  Required Argument
  =================
  statement:
  A scalar string that is the MATLAB code to be executed.
  Typically this invokes a script that encompasses the more
  complex functionality making the statement handling less error prone. An
  exit value of non zero returned to Databricks will be cause the job to fail.
  
  Previously some manual escaping of the statement was required depending on
  its content. This is now automatic and statements should not be
  escaped, aside from conventional escaping of single and double quotes
  as normal to yield a valid MATLAB string.
 
  The MATLAB executing the statement runs as the user given by accountName,
  see below.
 
  Optional Named Arguments
  ========================
  notebookPath:
  If a notebook path is not provided one is created and used for the
  dynamically generated notebook. The Workspace path has the form:
     /Users/username@example.com/tmp/MATLABBatchTask-<UUID>.py
  On completion of the task the file should be deleted. This is not done
  automatically.
  By default an existing notebook of the same name will be overwritten.
  A /Volumes path may also be provided.
 
  If provided the path of the notebook should be an absolute path.
 
  baseParameters:
  Optional base parameters can be passed as a struct. Values must be specified
  as scalar text and can be retrieved by the MATLAB code at runtime using:
    valueString = getenv('structFieldName');
 
  preExecPyCmd, postExecPyCmd, preExecShCmd and postExecShCmd:
  Optional preExecPyCmd, postExecPyCmd, preExecShCmd and postExecShCmd arguments
  can be used to add Python code and shell commands to the notebook that are
  invoked before and or after the MATLAB code. This may be useful "house keeping"
  or invoking other workflows. The order of execution is:
    1. preExecPyCmd
    2. preExecShCmd
    3. MATLAB statement
    4. postExecShCmd
    5. postExecPyCmd
  Shell commands are appended to a "%%sh" magic prefix.
  These commands run as root and must adjust permissions for the accountName
  user accordingly for file access.
 
  A temporary file is created and its name can be retrieved from the environment
  variable MW_RESULT_TEMPFILE This file can be appended to in steps 1,2,4 & 5
  along with the results from step 3.  The first 1 MB of output can be retrieved
  from the job run when the task finishes.
 
  The pre and post execution commands run as root.
  Newlines are automatically appended to each string element of Python and shell
  string array commands when building the underlying the notebook.
 
  MATLABCommand:
  The MATLABCommand argument is the command used to run MATLAB. By default
  this is "matlab -batch". Alternatives may be:
  1)  "matlab -nodesktop -r" is a preferences directory required and provisioned.
 
  2)  "matlab-batch" if working with batch token based licensing, Not to be
      confused with "matlab -batch".
 
  licenseManager:
  The licenseManager argument is used to specify where MATLAB should get its
  license. If specified the `MLM_LICENSE_FILE` environment variable is set to
  the provided value in the notebook. If this value is already set in the docker
  image or cluster definition it is not required at this point.
 
  If using batch token based licensing for CI/CD workflows the argument is still
  used in the normal way if provided, however the value will be ignored.
 
  licenseToken:
  Provide a Batch Token Licensing value. The argument should have the form:
  "user@email.com::encodedToken". When set this values causes the MATLABCommand
  to be set to: "matlab-batch -licensetoken user@email.com::encodedToken"
  rather than the default "matlab -batch". If a specific MATLABCommand argument
  is provided that value is used. License tokens must use the matlab-batch binary.
  This must be included in the MATLAB docker file image at build time.
  The token will be included in the notebook as plain text. The use of secrets
  is therefore the recommended alternative.
 
  licenseTokenSecretKey & licenseTokenSecretScope:
  These arguments allow a Batch Token Licensing value to be retrieved from
  a Databricks secret at runtime.
  If both a secret and licenseToken are specified the secret is used.
 
  If neither a token or secret is specified but the MLM_LICENSE_TOKEN environment
  variable is preferred and if configured in the docker image, cluster definition
  or preExec*Cmd options specify the MATLABCommand option as just "matlab-batch"
  and it will be used automatically.
 
  accountName:
  accountName is the name of user account that is dynamically created on the
  cluster to run the MATLAB task. By default and where possible it will be
  based on the account name on the system used to submit the job. This argument
  allows this value to be specified.
 
  The environment variable `MW_ACCOUNTNAME` can be used to query the account
  name at runtime. The is set in the MATLAB statement section and the pre & post
  exec command sections.
 
  skipAccountNameCheck:
  skipAccountNameCheck is a logical argument, when set to false (default) the
  accountName is validated to check if it is a valid Linux account name. Setting
  this value to true enables the use of accountName values such as "$MYACCOUNTNAME"
  such that the relevant shell cells in the generated notebook use an environment
  variable, that might be defined in a Databricks Asset Bundle, or otherwise at
  runtime. E.g. corresponding to a service principal identity used for scheduled
  workloads.
  Default: false
 
  installDatabricksInterface:
  Logical flag to install the MATLAB Databricks Interface package.
  The package is installed and configured prior to the execution of the MATLAB
  statement. If true and the interface directory or interface package
  is not found the installation will be skipped but the task will still
  be created with a warning.
  Default: true.
 
  installDatabricksDir:
  The directory where the Databricks interface will be installed.
  Default: "/local_disk0/<accountName>/matlab-interface-for-databricks";
 
  installDatabricksOverwrite:
  Logical flag to decide if the Databricks interface should be overwritten,
  in the case it was already installed here.
  Default: false
 
  interfaceDirectory:
  Path to a directory containing a subdirectory "Versions" which contains
  MATLAB Databricks Interface packages in semantically versioned directories.
 
  overwriteNotebook:
  A logical flag that is true by default, meaning that if the created
  notebook will be overwritten if it already exists.
 
  authMethod:
  The authentication method to use for REST API calls.
 
  profileName:
  The name of the profile to use from the .databrickscfg configuration file.
 
  For details on docker file registry access & authentication see:
  Documentation/Authentication.md
 
  Note that only Linux startup options apply in the case of Databricks.
  See also: https://mathworks.com/help/matlab/ref/matlablinux.html
 
  Example:
    baseParameters = struct('massLow', '1200', 'massHigh', '1400');
    t = databricks.MATLABBatchTask("disp('hello world'); disp(getenv('massHigh'))", baseParameters=baseParameters);
 
    t = databricks.MATLABBatchTask("disp(""Hello world""); exit(0)",...
                                    baseParameters=struct('massLow', '1200', 'massHigh', '1400'),...
                                    notebookPath="/Workspace/Users/joe@example.com/MATLABBatchTask.py",...
                                    preExecPyCmd='print("Running preExec")',...
                                    postExecPyCmd='print("Running postExec")',...
                                    preExecShCmd='echo "Running preExec Shell"',...
                                    postExecShCmd='echo "Running postExec Shell"',...
                                    licenseManager="27000@10.0.0.4");
    
    % Specify a cluster to be created when the job runs as a databricks.Cluster object
    % A cluster name is assigned at runtime.
    % Using a policy Id simplifies the cluster configuration by adopting settings defined
    % centrally in the policy.
    c = createDatabricksCluster("", 0, policyId=<policyId, create=false);
 
    % Retrieve the cluster ID from the configuration profile DEFAULT for the current cluster
    clusterId = databricks.internal.configurationprofile.ConfigFile.getProfileField("cluster_id", profileName="DEFAULT");
    jb = databricks.Job;
    jb.name = "my-job-name";
    Assign the cluster to the job
    jb.setCluster(clusterId);
 
    jb.setTask(t);
    jb.create();
    jobRun = jb.runNow();
 
    output = jobRun.getOutput
    output =
      struct with fields:
             metadata: [1x1 databricks.Run]
      notebook_output: [1x1 databricks.datastructures.NotebookOutput]
    output.notebook_output
      ans =
        NotebookOutput with properties:
           result: "['Hello world\n']"
        truncated: 0

    Documentation for databricks.MATLABBatchTask
```

#### databricks.MATLABBatchTask.createPyNotebook

```text
CREATEPYNOTEBOOK Create a Python notebook task to execute a MATLAB task
```

#### databricks.MATLABBatchTask.getTaskEntries

```text
databricks.MATLABBatchTask/getTaskEntries is a function.
    entries = getTaskEntries(obj)
```

### databricks.MATLABRuntimeTask

Superclass: databricks.BaseTask

```text
MATLABRUNTIMETASK Definition of a MATLAB runtime task
 
  Required Argument
  =================
  Command:
  A scalar string specifying the compiled code to be executed.
 
  Optional Named Arguments
  ========================
  arguments:
  Arguments passed to the compiled code as a scalar string.
  No enclosing quotes will be added.
  Previously some manual escaping of the Arguments was required depending on
  its content. This is no longer necessary and statements should not be
  escaped, aside from conventional escaping of single and double quotes
  as normal to yield a valid MATLAB string. Note that the resulting arguments
  are used as bash arguments and should be quotes appropriately. A leading
  space will be added.
 
  notebookPath:
  If a notebook path is not provided one is created and used for the
  dynamically generated notebook. The Workspace path has the form:
     /Users/username@example.com/tmp/MATLABRuntimeTask-<UUID>.py
  On completion of the task the file should be deleted. This is not done
  automatically.
  By default an existing notebook of the same name will be overwritten.
  A /Volumes path may also be provided.
 
  If provided the path of the notebook should be an absolute path.
 
  baseParameters:
  Optional base parameters can be passed as a struct. Values must be specified
  as scalar text and can be retrieved by the MATLAB code at runtime using:
    valueString = getenv('structFieldName');
 
  preExecPyCmd, postExecPyCmd, preExecShCmd and postExecShCmd:
  Optional preExecPyCmd, postExecPyCmd, preExecShCmd and postExecShCmd arguments
  can be used to add Python code and shell commands to the notebook that are
  invoked before and or after the MATLAB code. This may be useful "house keeping"
  or invoking other workflows. The order of execution is:
    1. preExecPyCmd
    2. preExecShCmd
    3. Compiled MATLAB command
    4. postExecShCmd
    5. postExecPyCmd
  Shell commands are appended to a "%%sh" magic prefix.
 
  A temporary file is created and its name can be retrieved from the environment
  variable MW_RESULT_TEMPFILE This file can be appended to in steps 1,2,4 & 5
  along with the results from step 3.  The first 1 MB of output can be retrieved
  from the job run when the task finishes.
 
  mcrRoot:
  The path to the root of the MATLAB runtime installation, if set this is used
  to build up the LD_LIBRARY_PATH environment variable and set the MCRROOT
  environment variable. By default it is expected that this is set in the
  Cluster definition or docker file.
 
  ldLibraryPath:
  Used to the set the LD_LIBRARY_PATH environment variable, if set this overrides
  a value which may have been set based on mcrRoot. By default it is expected
  that this is set in the Cluster definition or docker file.
 
  overwriteNotebook:
  A logical flag that is true by default, meaning that if the created
  notebook will be overwritten if it already exists.
 
  authMethod:
  The authentication method to use for REST API calls.
 
  profileName:
  The name of the profile to use from the .databrickscfg configuration file.
 
  For details on docker file registry access & authentication see:
  Documentation/Authentication.md
 
  Example:
    t = databricks.MATLABRuntimeTask("/Workspace/Users/joe@example.com/myCompiledCode",...
                                   arguments="3.14",...
                                   baseParameters=struct('massLow', '1200', 'massHigh', '1400'),...
                                   notebookPath="/Workspace/Users/joe@example.com/MATLABRuntimeTask.py",...
                                   preExecPyCmd='print("Running preExec Python")',...
                                   postExecPyCmd='print("Running postExec Python")',...
                                   preExecShCmd='echo "Running preExec Shell"',...
                                   postExecShCmd='echo "Running postExec Shell"');
 
    c = createDatabricksCluster("runtimeTestCluster", 0, dockerAuthFile="C:\myDir\dockerAuth.json");
 
    jb = databricks.Job;
    jb.name = "my-job-name";
 
    Assign the cluster to the job
    jb.setCluster(c);
 
    jb.setTask(t);
    jb.create();
    jobRun = jb.runNow();
 
    output = jobRun.getOutput
      output = 
        struct with fields:
             metadata: [1x1 databricks.Run]
      notebook_output: [1x1 databricks.datastructures.NotebookOutput]
    output.notebook_output
      ans = 
        NotebookOutput with properties:
           result: "['Input: 3.140000\n', 'Output: 6.280000\n']"
        truncated: 0
 
  A license is not required for MATLAB runtime based tasks.
```

#### databricks.MATLABRuntimeTask.MATLABRuntimeTask

```text
MATLABRUNTIMETASK Definition of a MATLAB runtime task
 
  Required Argument
  =================
  Command:
  A scalar string specifying the compiled code to be executed.
 
  Optional Named Arguments
  ========================
  arguments:
  Arguments passed to the compiled code as a scalar string.
  No enclosing quotes will be added.
  Previously some manual escaping of the Arguments was required depending on
  its content. This is no longer necessary and statements should not be
  escaped, aside from conventional escaping of single and double quotes
  as normal to yield a valid MATLAB string. Note that the resulting arguments
  are used as bash arguments and should be quotes appropriately. A leading
  space will be added.
 
  notebookPath:
  If a notebook path is not provided one is created and used for the
  dynamically generated notebook. The Workspace path has the form:
     /Users/username@example.com/tmp/MATLABRuntimeTask-<UUID>.py
  On completion of the task the file should be deleted. This is not done
  automatically.
  By default an existing notebook of the same name will be overwritten.
  A /Volumes path may also be provided.
 
  If provided the path of the notebook should be an absolute path.
 
  baseParameters:
  Optional base parameters can be passed as a struct. Values must be specified
  as scalar text and can be retrieved by the MATLAB code at runtime using:
    valueString = getenv('structFieldName');
 
  preExecPyCmd, postExecPyCmd, preExecShCmd and postExecShCmd:
  Optional preExecPyCmd, postExecPyCmd, preExecShCmd and postExecShCmd arguments
  can be used to add Python code and shell commands to the notebook that are
  invoked before and or after the MATLAB code. This may be useful "house keeping"
  or invoking other workflows. The order of execution is:
    1. preExecPyCmd
    2. preExecShCmd
    3. Compiled MATLAB command
    4. postExecShCmd
    5. postExecPyCmd
  Shell commands are appended to a "%%sh" magic prefix.
 
  A temporary file is created and its name can be retrieved from the environment
  variable MW_RESULT_TEMPFILE This file can be appended to in steps 1,2,4 & 5
  along with the results from step 3.  The first 1 MB of output can be retrieved
  from the job run when the task finishes.
 
  mcrRoot:
  The path to the root of the MATLAB runtime installation, if set this is used
  to build up the LD_LIBRARY_PATH environment variable and set the MCRROOT
  environment variable. By default it is expected that this is set in the
  Cluster definition or docker file.
 
  ldLibraryPath:
  Used to the set the LD_LIBRARY_PATH environment variable, if set this overrides
  a value which may have been set based on mcrRoot. By default it is expected
  that this is set in the Cluster definition or docker file.
 
  overwriteNotebook:
  A logical flag that is true by default, meaning that if the created
  notebook will be overwritten if it already exists.
 
  authMethod:
  The authentication method to use for REST API calls.
 
  profileName:
  The name of the profile to use from the .databrickscfg configuration file.
 
  For details on docker file registry access & authentication see:
  Documentation/Authentication.md
 
  Example:
    t = databricks.MATLABRuntimeTask("/Workspace/Users/joe@example.com/myCompiledCode",...
                                   arguments="3.14",...
                                   baseParameters=struct('massLow', '1200', 'massHigh', '1400'),...
                                   notebookPath="/Workspace/Users/joe@example.com/MATLABRuntimeTask.py",...
                                   preExecPyCmd='print("Running preExec Python")',...
                                   postExecPyCmd='print("Running postExec Python")',...
                                   preExecShCmd='echo "Running preExec Shell"',...
                                   postExecShCmd='echo "Running postExec Shell"');
 
    c = createDatabricksCluster("runtimeTestCluster", 0, dockerAuthFile="C:\myDir\dockerAuth.json");
 
    jb = databricks.Job;
    jb.name = "my-job-name";
 
    Assign the cluster to the job
    jb.setCluster(c);
 
    jb.setTask(t);
    jb.create();
    jobRun = jb.runNow();
 
    output = jobRun.getOutput
      output = 
        struct with fields:
             metadata: [1x1 databricks.Run]
      notebook_output: [1x1 databricks.datastructures.NotebookOutput]
    output.notebook_output
      ans = 
        NotebookOutput with properties:
           result: "['Input: 3.140000\n', 'Output: 6.280000\n']"
        truncated: 0
 
  A license is not required for MATLAB runtime based tasks.

    Documentation for databricks.MATLABRuntimeTask
```

#### databricks.MATLABRuntimeTask.createPyNotebook

```text
databricks.MATLABRuntimeTask/createPyNotebook is a function.
    createPyNotebook(obj, command)
    createPyNotebook(___, Name, Value)
```

#### databricks.MATLABRuntimeTask.getTaskEntries

```text
databricks.MATLABRuntimeTask/getTaskEntries is a function.
    entries = getTaskEntries(obj)
```

### databricks.NotebookTask

Superclass: databricks.BaseTask

```text
NOTEBOOKTASK Definition of a notebook task
  This class can be used to define a notebook task that can be attached
  to a databricks.Job for execution on a Spark Cluster.
 
      NT = databricks.NotebookTask();
      nbPath = '/Shared/UnitTests/Simulink_3DOFs';
      baseParams = struct('massLow', '1200', 'massHigh', '1400');
      NT.notebook_path = nbPath;
      NT.base_parameters = baseParams;
 
  The notebook parameter can also be given to the constructor.
      NT = databricks.NotebookTask(nbPath);
      baseParams = struct('massLow', '1200', 'massHigh', '1400');
  
  As can both parameters
      NT = databricks.NotebookTask(nbPath, baseParams);
```

#### databricks.NotebookTask.NotebookTask

```text
NOTEBOOKTASK Definition of a notebook task
  This class can be used to define a notebook task that can be attached
  to a databricks.Job for execution on a Spark Cluster.
 
      NT = databricks.NotebookTask();
      nbPath = '/Shared/UnitTests/Simulink_3DOFs';
      baseParams = struct('massLow', '1200', 'massHigh', '1400');
      NT.notebook_path = nbPath;
      NT.base_parameters = baseParams;
 
  The notebook parameter can also be given to the constructor.
      NT = databricks.NotebookTask(nbPath);
      baseParams = struct('massLow', '1200', 'massHigh', '1400');
  
  As can both parameters
      NT = databricks.NotebookTask(nbPath, baseParams);

    Documentation for databricks.NotebookTask
```

#### databricks.NotebookTask.getTaskEntries

```text
databricks.NotebookTask/getTaskEntries is a function.
    entries = getTaskEntries(obj)
```

### databricks.ODBCConnection

Superclasses: databricks.Object, matlab.mixin.CustomDisplay

```text
ODBCConnection Creates a Database Toolbox connection object using ODBC
 
  The primary role of this class is to construct the dsnless string used
  by the Databricks ODBC driver. Essentially this string combines a large number
  of configuration values. This is error prone to construct by hand.
 
  The Connection object is stored in the ODBCConnection's Connection property.
  By default the class will use the same authentication provider chain as
  used by the REST API interfaces, see Documentation/Authentication.md.
 
  The following optional named arguments can be used to override the values
  obtained from settings & configuration files and defaults.
 
     Name                       Type      Default
     --------------------------------------------
     % ODBC Driver configuration
     driver                     string
 
     % Provide the complete dsnless connection string directly
     dsnless                    string
     % Append to a generated dsnless string
     dsnlessAppend              string
 
     % Databricks host and port
     host                       string
     port                       string    "443"
 
     % Set a schema and catalog
     schema                     string    "default"
     catalog                    string
 
     % Set a specific cluster, should be a databricks.Cluster object or scalar text
     cluster                    databricks.Cluster or string
 
     % Authentication
     useDriverAuth              logical   true;
     authMethod                 matlab.databricks.AuthMethod    Settings file authMethod value
     profileName                string    Settings file profileName value
 
     % Oauth2
     OauthService               matlab.databricks.OauthService    matlab.databricks.OauthService.Databricks
     OAuth2ClientId             string    "databricks-sql-odbc"
     passthroughAccessToken     string
     passthroughRefreshToken    string
     scope                      string
     % Set the TokenCachePassPhrase argument to a password of your choice.
     % This is used for refresh token encryption when using driver based authentication.
     % The default is the user's username, this is NOT secure.
     tokenCachePassPhrase       string
     enableTokenCache           logical
     cacheFilePath              string
 
     httpPath                   string
     ssl                        logical   true
     thriftTransport            int32     2
     defaultStringColumnLength  int32
 
     logLevel                   string    "1"
     verbose                    logical   true
 
   Descriptions
   ------------
   schema name of the database/schema to use.
 
   catalog set the Unity Catalog catalog.
 
   Leading and trailing whitespace is removed from unescaped catalog and schema\
   arguments.
   If a catalog or schema contains a hyphen or space and is not already escaped
   using backticks, the backticks will be added automatically. This does not apply
   if they are named in the SQL statement.
 
   authMethod a matlab.databricks.AuthMethod
   to force a given authentication method default preferred method
   is not used. See: Documentation/Authentication.md
 
   profileName a scalar text name for a profile to be sourced
   from a .databrickscfg file. See: Documentation/Authentication.md
 
   passthroughAccessToken value for a token that is passed opaquely.
 
   tokenCachePassPhrase, on non Windows systems an insecure default is applied
   On Windows system this is not required.
 
   scope set the scope used with Oauth flows.
 
   OauthService specify an Oauth service provider.
 
   dsnless overrides the complete connection string value.
 
   dsnlessAppend a value appended to the connection string.
 
   httpPath overrides the httpPath portion of the connection string.
 
   defaultStringColumnLength Sets the maximum number of characters that can be
   contained in STRING columns. By default, the columns metadata for Spark does
   not specify a maximum length for STRING columns. In a future MATLAB release
   this can be used to address string truncation for long strings > 4000
   characters in length.
 
   logLevel a string text logging level, the default value is: "1".
 
   verbose a logical flag to enable more or less feedback,
   default is true.
 
  This class uses the Databricks ODBC driver v2.8.2 and greater.
 
  This functionality is independent of the Spark.sql() functionality which
  can also be used to execute SQL commands on Databricks.
 
  Call the Connection's close method when the connection is no longer needed.
  The object's close method will also call the connection's close method.
 
  If a connection cannot be created an empty database.odbc.connection is returned
  in the connection property. If an ODBC Driver Error is returned in the connection's
  Message property it will be displayed but an error will not be raised directly.
 
  Saving a Data Source, for use with Database Explorer App, is not supported
  for ODBC connections, if this is required use a JDBC based connection instead.
 
  Testing a connection, using testConnection(), is not supported for ODBC
  based connections, if this is required use a JDBC based connection instead.
 
  Examples:
     o = databricks.ODBCConnection(schema='myDatabaseName');
     conn = o.Connection;
 
     o = databricks.ODBCConnection; % Use default schema/database name: "default"
     conn = o.Connection;
 
  The dsnlessAppend argument can be used to add further values to the
  dsnless connection string. It is appended to the constructed value.
 
  If using token passthrough an access token obtained by some means is passed
  as a named (passthroughAccessToken) argument. Be aware that access tokens
  typically expire after a certain amount of time, after which you must
  either refresh the token or obtain a new one from the server.
 
  See also:
    https://www.databricks.com/spark/odbc-drivers-download
    https://docs.databricks.com/en/integrations/odbc/authentication.html
    https://docs.databricks.com/en/_extras/documents/Simba-Apache-Spark-ODBC-Connector-Install-and-Configuration-Guide.pdf
    https://www.databricks.com/legal/jdbc-odbc-driver-license
```

#### databricks.ODBCConnection.ODBCConnection

```text
ODBCConnection Creates a Database Toolbox connection object using ODBC
 
  The primary role of this class is to construct the dsnless string used
  by the Databricks ODBC driver. Essentially this string combines a large number
  of configuration values. This is error prone to construct by hand.
 
  The Connection object is stored in the ODBCConnection's Connection property.
  By default the class will use the same authentication provider chain as
  used by the REST API interfaces, see Documentation/Authentication.md.
 
  The following optional named arguments can be used to override the values
  obtained from settings & configuration files and defaults.
 
     Name                       Type      Default
     --------------------------------------------
     % ODBC Driver configuration
     driver                     string
 
     % Provide the complete dsnless connection string directly
     dsnless                    string
     % Append to a generated dsnless string
     dsnlessAppend              string
 
     % Databricks host and port
     host                       string
     port                       string    "443"
 
     % Set a schema and catalog
     schema                     string    "default"
     catalog                    string
 
     % Set a specific cluster, should be a databricks.Cluster object or scalar text
     cluster                    databricks.Cluster or string
 
     % Authentication
     useDriverAuth              logical   true;
     authMethod                 matlab.databricks.AuthMethod    Settings file authMethod value
     profileName                string    Settings file profileName value
 
     % Oauth2
     OauthService               matlab.databricks.OauthService    matlab.databricks.OauthService.Databricks
     OAuth2ClientId             string    "databricks-sql-odbc"
     passthroughAccessToken     string
     passthroughRefreshToken    string
     scope                      string
     % Set the TokenCachePassPhrase argument to a password of your choice.
     % This is used for refresh token encryption when using driver based authentication.
     % The default is the user's username, this is NOT secure.
     tokenCachePassPhrase       string
     enableTokenCache           logical
     cacheFilePath              string
 
     httpPath                   string
     ssl                        logical   true
     thriftTransport            int32     2
     defaultStringColumnLength  int32
 
     logLevel                   string    "1"
     verbose                    logical   true
 
   Descriptions
   ------------
   schema name of the database/schema to use.
 
   catalog set the Unity Catalog catalog.
 
   Leading and trailing whitespace is removed from unescaped catalog and schema\
   arguments.
   If a catalog or schema contains a hyphen or space and is not already escaped
   using backticks, the backticks will be added automatically. This does not apply
   if they are named in the SQL statement.
 
   authMethod a matlab.databricks.AuthMethod
   to force a given authentication method default preferred method
   is not used. See: Documentation/Authentication.md
 
   profileName a scalar text name for a profile to be sourced
   from a .databrickscfg file. See: Documentation/Authentication.md
 
   passthroughAccessToken value for a token that is passed opaquely.
 
   tokenCachePassPhrase, on non Windows systems an insecure default is applied
   On Windows system this is not required.
 
   scope set the scope used with Oauth flows.
 
   OauthService specify an Oauth service provider.
 
   dsnless overrides the complete connection string value.
 
   dsnlessAppend a value appended to the connection string.
 
   httpPath overrides the httpPath portion of the connection string.
 
   defaultStringColumnLength Sets the maximum number of characters that can be
   contained in STRING columns. By default, the columns metadata for Spark does
   not specify a maximum length for STRING columns. In a future MATLAB release
   this can be used to address string truncation for long strings > 4000
   characters in length.
 
   logLevel a string text logging level, the default value is: "1".
 
   verbose a logical flag to enable more or less feedback,
   default is true.
 
  This class uses the Databricks ODBC driver v2.8.2 and greater.
 
  This functionality is independent of the Spark.sql() functionality which
  can also be used to execute SQL commands on Databricks.
 
  Call the Connection's close method when the connection is no longer needed.
  The object's close method will also call the connection's close method.
 
  If a connection cannot be created an empty database.odbc.connection is returned
  in the connection property. If an ODBC Driver Error is returned in the connection's
  Message property it will be displayed but an error will not be raised directly.
 
  Saving a Data Source, for use with Database Explorer App, is not supported
  for ODBC connections, if this is required use a JDBC based connection instead.
 
  Testing a connection, using testConnection(), is not supported for ODBC
  based connections, if this is required use a JDBC based connection instead.
 
  Examples:
     o = databricks.ODBCConnection(schema='myDatabaseName');
     conn = o.Connection;
 
     o = databricks.ODBCConnection; % Use default schema/database name: "default"
     conn = o.Connection;
 
  The dsnlessAppend argument can be used to add further values to the
  dsnless connection string. It is appended to the constructed value.
 
  If using token passthrough an access token obtained by some means is passed
  as a named (passthroughAccessToken) argument. Be aware that access tokens
  typically expire after a certain amount of time, after which you must
  either refresh the token or obtain a new one from the server.
 
  See also:
    https://www.databricks.com/spark/odbc-drivers-download
    https://docs.databricks.com/en/integrations/odbc/authentication.html
    https://docs.databricks.com/en/_extras/documents/Simba-Apache-Spark-ODBC-Connector-Install-and-Configuration-Guide.pdf
    https://www.databricks.com/legal/jdbc-odbc-driver-license

    Documentation for databricks.ODBCConnection
```

#### databricks.ODBCConnection.checkDataSources

```text
CHECKDATASOURCES Checks that schema name does not collide with a saved datasource name
```

#### databricks.ODBCConnection.checkDriverVersion

```text
databricks.ODBCConnection/checkDriverVersion is a function.
    checkDriverVersion(obj, requiredVersion)
    checkDriverVersion(obj, requiredVersion, errorOnLt)
```

#### databricks.ODBCConnection.close

```text
close - Close one or more figures

    Syntax
      close
      close(fig)
      close force
      close all
      close all hidden
      close all force
      status = close(___)

    Input Arguments
      fig - Figure to close
        one or more Figure objects, figure numbers, or figure names

    Examples
      openExample('graphics/DeleteASingleFigureExample')
      openExample('graphics/DeleteMultipleFiguresExample')
      openExample('graphics/DeleteFigureWithSpecifiedNumberExample')
      openExample('graphics/DeleteFigureWithSpecifiedNameExample')
      openExample('graphics/VerifyFiguresWasDeletedExample')
      openExample('graphics/DeleteAllFiguresSimultaneouslyExample')
      openExample('graphics/DeleteAllFiguresWithVisibleOrHiddenHandleExample')
      openExample('graphics/DeleteFigureWhoseWindowCannotBeClosedExample')

    See also delete, figure, gcf, Figure

    Introduced in MATLAB before R2006a
    Documentation for close
       doc close
```

#### databricks.ODBCConnection.copyToken

```text
COPYTOKEN Copies the connection password/token to the system clipboard
  Returns true if a value is copied, otherwise false.
```

#### databricks.ODBCConnection.delete

```text
if isprop(obj, 'Connection') && ~isempty(obj.Connection) && isa(obj.Connection, 'database.odbc.connection')
      obj.Connection.close();
  end
```

#### databricks.ODBCConnection.escapeUCName

```text
databricks.ODBCConnection.escapeUCName is a function.
    out = escapeUCName(in)
```

#### databricks.ODBCConnection.generateDSNFile

```text
GENERATEDSNFILE Generates a DSN file based Databricks configuration details
  The path to the file is returned.
  If no path is provided <tempdir>/odbc.ini is used and overwritten if present.
  If a path is provided the file is appended to if it already exists.
  On Linux a [ODBC Data Sources] section is included.
  Only PAT authentication is currently supported.
 
  See also: https://docs.databricks.com/aws/en/integrations/odbc/dsn
 
  Example:
    path = databricks.ODBCConnection.generateDSNFile()
 
  Note this file cannot be used by Database Toolbox to create a connection.
```

#### databricks.ODBCConnection.getAuthArgs

```text
databricks.ODBCConnection/getAuthArgs is a function.
    authStr = getAuthArgs(obj, authSrc, host)
    authStr = getAuthArgs(___, Name, Value)
    [authStr, username] = getAuthArgs(___)
    [authStr, username, password] = getAuthArgs(___)
```

#### databricks.ODBCConnection.getDefaultDriver

```text
databricks.ODBCConnection.getDefaultDriver is a function.
    driver = databricks.ODBCConnection.getDefaultDriver
```

#### databricks.ODBCConnection.getHTTPProxy

```text
SETHTTPPROXY Sets HTTP proxy environment variables for Python
```

#### databricks.ODBCConnection.getHttpPath

```text
databricks.ODBCConnection.getHttpPath is a function.
    httpPath = getHttpPath
    httpPath = getHttpPath(Name, Value)
    [httpPath, clusterId] = getHttpPath
    [httpPath, clusterId, warehouseId] = getHttpPath
```

#### databricks.ODBCConnection.getPropertyGroups

```text
databricks.ODBCConnection/getPropertyGroups is a function.
    groups = getPropertyGroups(obj)
```

#### databricks.ODBCConnection.getScope

```text
getScope Returns a scope field as a string
```

#### databricks.ODBCConnection.validateCluster

```text
validateCluster Check the clusters state and Spark version
```

### databricks.Object

Superclass: dynamicprops

```text
OBJECT Databricks root object
  Properties added to this object will be available on all databricks
  classes.
 
  The Version property refers to the version of the Databricks REST API
  to be used.
 
  For more information on provider chain based authentication details see:
  https://learn.microsoft.com/en-us/azure/databricks/dev-tools/auth#unified-auth
 
  See Documentation for further details: Documentation/Authentication.md
```

#### databricks.Object.Object

```text
OBJECT Databricks root object
  Properties added to this object will be available on all databricks
  classes.
 
  The Version property refers to the version of the Databricks REST API
  to be used.
 
  For more information on provider chain based authentication details see:
  https://learn.microsoft.com/en-us/azure/databricks/dev-tools/auth#unified-auth
 
  See Documentation for further details: Documentation/Authentication.md

    Documentation for databricks.Object
```

#### databricks.Object.addStructureAsDynProps

```text
databricks.Object/addStructureAsDynProps is a function.
    addStructureAsDynProps(obj, S)
```

#### databricks.Object.epochToTimestamp

```text
databricks.Object.epochToTimestamp is a function.
    ts = databricks.Object.epochToTimestamp(epoch)
```

#### databricks.Object.getAuth

```text
getAuth Populates the authentication configuration values in the databricks.Object class
  Sets Host, Profile & Token
```

#### databricks.Object.getAuthorizationField

```text
GETAUTHORIZATIONFIELD Return the authorization field for API
```

#### databricks.Object.getRequestMessage

```text
GETREQUESTMESSAGE Get the request message to call the databricks API
 
     req = obj.getRequestMessage
 
   will return a matlab.net.http.RequestMessage with the correct
   authorization information set.
 
     req = obj.getRequestMessage('POST')
 
   will create a similar RequestMessage with the correct method set too.
```

#### databricks.Object.getURI

```text
getURI Return a matlab.net.URI object
 
  Examples:
   % Return a matlab.net.URI for https://<host>/api/2.0/clusters/list
   u = obj.getURI('clusters', 'list')
 
   % If the function needs parameters, they can be added as pairs
   % Return a matlab.net.URI for https://<host>/api/2.0/clusters/get?cluster_id=123
   u = obj.getURI('clusters', 'get', 'cluster_id', '123')
```

#### databricks.Object.getUserAgent

```text
getUserAgent Returns user agent based on a MATLAB Release value
  Value has the form: MathWorks_MATLAB/25.2.0 for R2025b
  By default the current release is used.
 
  Example:
    userAgent = databricks.Object.getUserAgent(release="R2025b");
```

#### databricks.Object.isPreview

```text
databricks.Object/isPreview is a function.
    tf = isPreview(obj, varargin)
```

#### databricks.Object.rmpropif

```text
rmpropif Remove a property if it exists
```

#### databricks.Object.sanitizeHost

```text
sanitizeHost Cleans up host values
  Leading and trailing white space is removed.
  If the host is of length zero this is returned, with an
  optional warning.
  If the host has a trailing / it is removed.
  If the host does not start with https:// (case insensitive) a
  warning is produced.
```

#### databricks.Object.setprop

```text
setprop Set a property on an object
  If the property doesn't already exist, it will be added
```

### databricks.PySparkSession

Superclasses: matlab.pyspark.sql.session.SparkSession, matlab.mixin.CustomDisplay

```text
PYSPARKSESSION Class to create a PySpark session
```

#### databricks.PySparkSession.PySparkSession

```text
PYSPARKSESSION Constructor for PySparkSession class
 
  This constructor is designed to be called from getDatabricksSession()
  or a similar wrapper function.
 
  Named arguments:
               platform : While Databricks is the primary target platform
                          for this class it may support other platforms
                          in the future, like plain Apache Spark.
                          Currently "databricks" is the default and
                          only supported value.
 
                   mode : Serverless mode is supported. Set the optional
                          named argument mode to "serverless" or "classic"
                          (default).
 
                cluster : A cluster can be given using the named argument
                          cluster of type databricks.Cluster object.
                          The cluster must be in a running state. If using
                          serverless mode a cluster argument should not
                          be given.
 
           dependencies : Can be used to provided a list of Python packages
                          that should be installed in the Python environment
                          before creating the Spark session. This is useful
                          when additional libraries% are required.
 
             authMethod : Used to specify a specific authentication method.
 
            profileName : Used to specify a specific profile.
 
      skipVersionChecks : Set to true to skip version checks for:
                            * Client Python version support.
                            * Client Python serverless support.
                            * MATLAB Python version support.
                            * Client Python version matches the cluster
                              Python version.
                            * Databricks Connect service disabled.
                          The use of this argument is not recommended
                          and is likely to result in errors.
                          However, it may sometimes be useful for testing
                          purposes. Default: false.
 
  clusterRuntimeVersion : Required if using Databricks, e.g. 16.4
 
                verbose : Flag is used to control the verbosity of the output.
                          Default: true.
 
        forceNewSession : When set to true this will create a new Spark
                          Session. If set to false or omitted, it will
                          reuse an existing Spark Session, if available.
                          This is especially useful in development workflows,
                          where a new version of an artifact is uploaded
                          with the addArtifact method. If an old session
                          is reused, the artifact cannot be reused.
                          Default: false.
 
  The timeout when creating a session is 5 minutes.
 
  If the HTTP_PROXY or HTTPS_PROXY environment variables are
  set in the MATLAB process context but the MATLAB proxy is
  setting/preference is not set a warning is produced as this
  is possible source of error for other interfaces. If the
  setting/preference is set a the HTTP(S)_PROXY variable is
  configured in the Python environment context used by the
  Databricks Connect library.
 
  This class only supports Databricks Connect v2, v1 is not supported.
 
  See also Databricks session creation code:
    site-packages\databricks\connect\session.py

    Documentation for databricks.PySparkSession
```

#### databricks.PySparkSession.getPropertyGroups

```text
databricks.PySparkSession/getPropertyGroups is a function.
    groups = getPropertyGroups(obj)
```

### databricks.Run

Superclass: databricks.Object

```text
RUN Class for interacting with specific runs of jobs
```

#### databricks.Run.Run

```text
RUN Class for interacting with specific runs of jobs

    Documentation for databricks.Run
```

#### databricks.Run.cancel

```text
CANCEL Cancel a job run
 
  Because the run is canceled asynchronously, the run may still be running
  when this request completes. The run will be terminated shortly.
  If the run is already in a terminal life_cycle_state, this method
  does nothing.
 
  Examples:
 
    runObj = job.runNow()
    runObj.cancel()
 
    Or:
 
    runObj = databricks.Run()
    runObj.cancel(123456)
 
  If a run does not exist an error is thrown.
```

#### databricks.Run.export

```text
EXPORT Export and retrieve the job run task
 
  Only notebook runs can be exported in HTML format. Exporting runs of
  other types will fail.
 
  Examples:
 
    runObj = job.runNow()
    % export can now be called to retrieve the views of this Run
    % object.
    runData = runObj.export()
 
  A run_id can also be used with a newly created Run object
    runObj = databricks.Run()
    runData = runObj.export(12345)
```

#### databricks.Run.get

```text
GET Returns the metadata of a Job run
 
  Can be called using a previously retrieved/created Run object, in
  which case it will use this Run object's 'run_id'. 
    % job is a databricks.Job
    runObj = job.runNow()
    runObj.get()
 
  A run_id can also be used with a newly created Run object
    runObj = databricks.Run()
    runObj.get(12345)
```

#### databricks.Run.getOutput

```text
GETOUTPUT Retrieve the output and metadata of a single task run
 
  This function returns metadata for a Job run, corresponding to a Run
  object. I can also return details of run errors in an error and or
  error_trace field.
 
  If a run produces notebook output this is returned in a field called
  notebook_output as a NotebookOutput object.
 
  Examples:
    % Using an existing Run object, in which case it's 'run_id' is
    % queried
    runObj = job.runNow()
    % export can now be called to retrieve the views of this Run
    % object.
    runObj.get()
 
  A run_id can also be used with a newly created Run object
    runObj = databricks.Run()
    runObj.get(12345)
```

#### databricks.Run.list

```text
LIST List runs in databricks cluster
 
  This method lists runs in a Databricks cluster. It takes 6 optional
  arguments:
   job_id - Only runs for a certain job (int64)
   active_only - Only active runs (logical)
   completed_only - Only completed runs (logical)
   offset - Needed for paging (see limit) (int32)
   limit - Maximum number to return (int32)
   run_type - what Databricks run_type to accept (string/char)
 
  Further information is available from Databricks, see
   https://docs.databricks.com/dev-tools/api/2.0/jobs.html#runs-list
 
  Examples:
   % Read 20 latest runs:
   runs = databricks.Run.list()
 
   % Read only 5 runs:
   runs = databricks.Run.list(limit=5)
 
   % Read 10 runs, starting at 100:
   runs = databricks.Run.list(offset=100,limit=10)
 
   % Only read active runs
   runs = databricks.Run.list(active_only=true)
```

### databricks.SCIM

Superclass: databricks.Object

```text
SCIM Class to provide an interface to the Databricks Files REST API
 
  See also: https://docs.databricks.com/api/workspace/currentuser/me
```

#### databricks.SCIM.SCIM

```text
SCIM Constructor

    Documentation for databricks.SCIM
```

#### databricks.SCIM.me

```text
ME Get details about the current method caller's identity
  On success a  databricks.datastructures.scim.MeResponse is returned with an
  empty databricks.datastructures.files.ErrorResponse.
  Otherwise an empty databricks.datastructures.scim.MeResponse is returned with
  a populated databricks.datastructures.files.ErrorResponse.
 
  Example:
    s = databricks.SCIM;
    result = s.me
    result = MeResponse with properties:
         schemas: [2x1 string]
              id: "1234567890123456"
        userName: "joeuser@example.com"
          emails: [1x1 databricks.datastructures.scim.emails]
            name: [1x1 databricks.datastructures.scim.name]
     displayName: "Joe User"
          groups: [1x1 databricks.datastructures.scim.groups]
           roles: [0x0 databricks.datastructures.scim.roles]
    entitlements: [1x2 databricks.datastructures.scim.entitlements]
      externalId: "d1234ae5-ebec-1234-12eb-1234f56e7a89"
          active: 1
 
  See also: https://docs.databricks.com/api/workspace/currentuser/me
```

### databricks.SQLWarehouse

Superclasses: databricks.Object, matlab.databricks.StructOrCellDeserializable

```text
SQLWarehouse Databricks interface to manipulate SQL Warehouses
  via the databricks 2.0 REST API. Please see the documentation at:
  https://docs.databricks.com/sql/api/sql-endpoints.html
 
  To obtain a list of existing end-points call the static list method
 
    warehouses = databricks.SQLWarehouse.list()
 
  When called without inputs, constructs an entirely empty SQLWarehouse
  instance. One can then for example assign the ID of a known existing
  warehouse and call refresh to see its status:
 
    >> warehouse = databricks.SQLWarehouse();
    >> warehouse.id = "qfufxboufejuuibuxbz";
    >> warehouse.refresh
    >> warehouse
 
    warehouse =
 
        SQLWarehouse with properties:
 
                             id: "qfufxboufejuuibuxbz"
                           name: "mywarehouse"
                   cluster_size: "2X-Small"
                 auto_stop_mins: 10
           spot_instance_policy: COST_OPTIMIZED
                   num_clusters: 1
               min_num_clusters: 1
               max_num_clusters: 1
            num_active_sessions: 0
                          state: RUNNING
                   creator_name: "user@company.com"
                     creator_id: "3141592653589793"
                       jdbc_url: "jdbc:spark://adb-42424242424242.1.azuredatabricks.net:443/default;transportMode=http;ssl=1;AuthMech=3;httpPath=/sql/1.0/warehouses/qfufxboufejuuibuxbz;"
                    odbc_params: [1x1 databricks.datastructures.ODBCParams]
                           tags: [1x1 databricks.datastructures.WarehouseTags]
                         health: [1x1 databricks.datastructures.WarehouseHealth]
                  enable_photon: 1
      enable_serverless_compute: 0
                        channel: [1x1 databricks.datastructures.Channel]
 
  Or this can be used to create a new warehouse:
 
    % Create an empty SQLWarehouse
    warehouse = databricks.SQLWarehouse();
    % Set all required properties for creating a new instance
    warehouse.name = "myNewInstance"
    warehouse.cluster_size = "Small";
    warehouse.min_num_clusters = 1;
    warehouse.max_num_clusters = 2;
    % Create the new warehouse
    warehouse.create();
 
  If an SQLWarehouse instance has a valid id set (either manually or
  obtained through the list() method), the SQLWarehouse can be started,
  stopped or deleted:
 
    warehouse.start()
    warehouse.stop()
    warehouse.remove()
 
  And if Database Toolbox as well as the Databricks JDBC Driver have
  been installed a Database Toolbox connection to the Warehouse can be
  made:
 
    conn = warehouse.connect();
 
  The refresh, start, stop and remove methods can also be used
  on an array of SQLWarehouse to perform these operations on multiple
  SQLWarehouses in a single call.
 
  The Databricks JDBC driver v2.6.36 or greater is required.
 
  See also: https://docs.databricks.com/en/_extras/documents/Databricks-JDBC-Driver-Install-and-Configuration-Guide.pdf
```

#### databricks.SQLWarehouse.SQLWarehouse

```text
SQLWarehouse Constructor

    Documentation for databricks.SQLWarehouse
```

#### databricks.SQLWarehouse.connect

```text
CONNECT Create a Database Toolbox connection using the
  Databricks JDBC Driver for the specified SQL warehouse.
  
  Positional argument:
  The database name can be provided as the first (excl. warehouse
  object) positional argument, if not provided a default value
  of "default" is used.
 
  Named arguments:
  The following optional named arguments can be used to override the values
  obtained from settings & configuration files and defaults.
 
   Name                    Type    Default
   ---------------------------------------
   mode                    string  "JDBC"
   port                    string  "443"
   ssl                     logical true
   thriftTransport         int32
   catalog                 string
   httpPath                string
   authMethod              matlab.databricks.AuthMethod  Settings file authMethod value
   profileName             string  Configuration file profileName value
   passthroughAccessToken  string
   scope                   string
   OauthService            matlab.databricks.OauthService  matlab.databricks.OauthService.Databricks
   logLevel                string  "0"
   verbose                 logical true
 
   JDBC specific:
   jarFilePath             string  databricksRoot('lib','jar','Shaded-Databricks-JDBC-Driver-0.0.2.jar')
   driverClass             string  "com.databricks.client.jdbc.Driver"
   connectionURL           string
   connectionURLAppend     string
   useNativeQuery          logical true
   enableNativeParameterizedQuery logical false
 
   ODBC specific:
   dsnless                 string
   driver                  string
   dsnlessAppend           string
 
 
   mode set the connection type to "JDBC" or "ODBC".
 
   catalog set the unity catalog catalog.
 
   httpPath overrides the httpPAth portion of the connection URL.
 
   authMethod a matlab.databricks.AuthMethod
   to force a given authentication method default preferred method
   is not used. See: Documentation/Authentication.md
  
   profileName a scalar text name for a profile to be source
   from a .databrickscfg file. See: Documentation/Authentication.md
 
   passthroughAccessToken value for a token that is passed opaquely.
   
   scope set the scope used with Oauth flows.
 
   OauthService specify an Oauth service provider.
 
   logLevel a string text logging level, the default value is: "0"
 
   verbose a logical flag to enable more or less feedback,
   default is true
 
   JDBC specific:
   connectionURL overrides the complete connection URL value.
 
   connectionURLAppend a value appended to the connection URL.
 
 
   ODBC specific:
 
   dsnless overrides the complete connection string value.
 
   driver path for the driver file or dsn identifier.
 
   dsnlessAppend a value appended to the connection string.
 
 
  Previous (prior to release 4.0.0) support for the AUTHMECH arguments
  should be updated as follows:
 
    PersonalAccessToken argument use should be adapted to use
    authMethod=matlab.databricks.AuthMethod.PAT
    where the token is sourced from a .databrickcfg file or
    environment variable inline with the unified authentication
    approach. See Documentation/Authentication.md for more
    details. Generally the preferred authentication method is
    defined in the databricks-settings.json file. See:
    Documentation/setup.md for details.
 
    AzureADToken argument use should be adapted to use OauthU2M
    or OauthM2M flows or if necessary the passthroughAccessToken
    named argument. Use a OauthService argument set to:
    matlab.databricks.OauthService.Databricks.
    Again see Documentation/Authentication.md &
    Documentation/setup.md for details.
    
  For further details on alternative SQL connection approaches
  see:
    Documentation/JDBCWorkflow.md
    Documentation/SQLWarehousesAPI.md
    Documentation/StatementExecution.md
 
  Examples:
 
    % Specify warehouse settings
    warehouse = databricks.SQLWarehouse;
    warehouse.id = "qfufxboufejuuibuxbz";
    
    % Connect to database "default" using the default
    % authentication method
    conn = warehouse.connect()
 
    % Or, to connect to database "other" using
    % Machine-to-Machine auth detailed in a profile myM2MProfile
    conn = warehouse.connect("other",authMethod=matlab.databricks.AuthMethod.OauthM2M, profileName="myM2MProfile");
```

#### databricks.SQLWarehouse.create

```text
CREATE creates a new SQL warehouse based on the configured
  properties. The following properties are required:
      "name"
      "cluster_size"
      "min_num_clusters"
      "max_num_clusters"
  The following properties are optional:
      "auto_stop_mins"
      "tags"
      "spot_instance_policy"
      "enable_photon"
      "enable_serverless_compute"
      "channel"
  Any other properties which might have been set will be
  ignored.
```

#### databricks.SQLWarehouse.edit

```text
EDIT Change settings of the SQL warehouse
```

#### databricks.SQLWarehouse.list

```text
LIST Queries Databricks for a list of known SQL warehouses.
  Returns an array of SQLWarehouse
```

#### databricks.SQLWarehouse.performAction

```text
PERFORMACTION Shared code for start and stop
```

#### databricks.SQLWarehouse.refresh

```text
refresh - Redraw current figure

    Syntax
      refresh
      refresh(h)

    Introduced in MATLAB before R2006a
    Documentation for refresh
       doc refresh
```

#### databricks.SQLWarehouse.remove

```text
REMOVE deletes the SQL warehouse entirely
 
  This method in the Databricks API is called delete. It's called
  remove here, to avoid confusion with the built-in MATLAB delete
  method.
```

#### databricks.SQLWarehouse.start

```text
START starts the SQL warehouse
```

#### databricks.SQLWarehouse.stop

```text
STOP stops the SQL warehouse
```

### databricks.Scope

Superclass: databricks.Object

```text
Scope as used by Databricks Secrets API
  scopes and initial_manage_principal values will be stored as character
  vectors. Scope names must be unique within a workspace. They must consist
  of alphanumeric characters, dashes, underscores, and periods, and may not
  exceed 128 characters. The names are readable by all users of a workspace.
  A workspace is limited to a maximum of 100 scopes. Scopes are typically
  created with the initial_manage_principal set to 'users', consult
  Databricks documentation for options which may vary with Databricks plan
  type.
 
  Example
     scope = databricks.Scope;
     scope.scope = 'myScope';
     scope.initial_manage_principal = 'users';
     scope.create;
     scopes = scope.list;
     scope.delete('myScope');
```

#### databricks.Scope.Scope

```text
Scope as used by Databricks Secrets API
  scopes and initial_manage_principal values will be stored as character
  vectors. Scope names must be unique within a workspace. They must consist
  of alphanumeric characters, dashes, underscores, and periods, and may not
  exceed 128 characters. The names are readable by all users of a workspace.
  A workspace is limited to a maximum of 100 scopes. Scopes are typically
  created with the initial_manage_principal set to 'users', consult
  Databricks documentation for options which may vary with Databricks plan
  type.
 
  Example
     scope = databricks.Scope;
     scope.scope = 'myScope';
     scope.initial_manage_principal = 'users';
     scope.create;
     scopes = scope.list;
     scope.delete('myScope');

    Documentation for databricks.Scope
```

#### databricks.Scope.create

```text
CREATE Create a Databricks secret scope in which secrets are stored
  Secrets are stored in Databricks-managed storage and encrypted.
  Errors with RESOURCE_ALREADY_EXISTS if a scope with the given name already
  exists. Errors with RESOURCE_LIMIT_EXCEEDED if maximum number of scopes in the
  workspace is exceeded (100). Errors with INVALID_PARAMETER_VALUE if the scope
  name is invalid. This method support vectorization.
 
  Example
    scope = databricks.Scope;
    scope.scope = 'myScope';
    scope.initial_manage_principal = 'users';
    scope.create
    Created scope: myScope
```

#### databricks.Scope.delete

```text
DELETE Delete a Databricks secret scope
  Errors with RESOURCE_DOES_NOT_EXIST if the scope does not exist or
  PERMISSION_DENIED if the user does not have permission to make the call.
  The scope name to delete should be provided as an argument
  regardless of whether are set in the underlying Scope object.
 
  Example
     scope.delete('myScope')
     Deleted scope: myScope
```

#### databricks.Scope.list

```text
LIST Lists secret scopes
  Lists all secret scopes available in the workspace. Returns a MATLAB table
  on success. Errors with PERMISSION_DENIED if the caller does not have
  permission to make the call. If no scopes are defined an empty table is
  returned. Table entries are returned as scalar strings.
 
  Example:
    scope = databricks.Scope;
    scopes = scope.list
    scopes =
      2x2 table
          name       backend_type
        _________    ____________
        "aScope"     "DATABRICKS"
        "myScope"    "DATABRICKS"
```

#### databricks.Scope.validateScope

```text
databricks.Scope/validateScope is a function.
    scope = validateScope(~, val)
```

### databricks.Secret

Superclass: databricks.Object

```text
SECRET Databricks Secrets API
  The Secrets API allows you to create, and manage secrets. The key must
  consist of alphanumeric characters, dashes, underscores and periods only
  and cannot exceed 128 characters. The maximum allowed secret value size is
  128KB. The maximum number of secrets in a given scope is 1000. The secret
  value may be a character vector or byte array of type uint8.
 
   Example
     secret = databricks.Secret;
     secret.scope = 'myScope';
     secret.key = 'myKey';
     secret.setValue('mySecretValue');
     secret.put
     secretTable = secret.list;
     secret.delete('myScope','myKey');
```

#### databricks.Secret.Secret

```text
SECRET Databricks Secrets API
  The Secrets API allows you to create, and manage secrets. The key must
  consist of alphanumeric characters, dashes, underscores and periods only
  and cannot exceed 128 characters. The maximum allowed secret value size is
  128KB. The maximum number of secrets in a given scope is 1000. The secret
  value may be a character vector or byte array of type uint8.
 
   Example
     secret = databricks.Secret;
     secret.scope = 'myScope';
     secret.key = 'myKey';
     secret.setValue('mySecretValue');
     secret.put
     secretTable = secret.list;
     secret.delete('myScope','myKey');

    Documentation for databricks.Secret
```

#### databricks.Secret.delete

```text
DELETE Delete a Databricks secret
  Errors with RESOURCE_DOES_NOT_EXIST if the scope does not exist or
  PERMISSION_DENIED if the user does not have permission to make the call.
  The scope and key pair to delete should be provided as arguments
  regardless of whether are set in the underlying Secret object.
 
  Example
     secret.delete('myScope','myKey')
     Deleted secret: myScope : myKey
```

#### databricks.Secret.list

```text
LIST List the secret keys that are stored at this scope
  Only metadata is returned. Secret values cannot be retrieved using this API.
  If no secrets are defined an empty table is returned. Timestamps are returned
  as MATLAB datetime values in UTC. Keys are returns as strings and
  timestamps as datetimes with the table. If there are no secrets an
  empty table is returned.
 
  Example:
    result = secret.list
    result = 2x2 table
      key       last_updated_timestamp
    ________    ______________________
    "myKey1"     14-Oct-2024 11:19:37 
    "myKey2"     14-Oct-2024 11:20:08
```

#### databricks.Secret.put

```text
PUT Put a secret in the provided scope with the given name
  This method supports vectorization. The key must consist of alphanumeric
  characters, dashes, underscores and periods only and cannot exceed 128
  characters. The maximum allowed secret value size is 128KB.
  The maximum number of secrets in a given scope is 1000. The secret value may
  be a character vector or byte array of type uint8.
 
  Example
    secret = databricks.Secret;
    secret.scope = 'myScope';
    secret.key = 'myKey';
    secret.value = 'mySecretValue';
    secret.put
    Put secret:  myScope : myKey
 
  If a secret object's value property is of type character vector the resulting
  value will be stored in UTF-8 format. If the value is of type unit8 the value
  is stored as a byte value other. Otherwise the method will error.
```

#### databricks.Secret.setValue

```text
SETVALUE Sets a Secret object secret value
  This method permits the secret value property of the Secret object to have
  attributes hidden and private to limit the potential for accidental
  disclosure of the value e.g. via log files. Variables holding the secret value
  should be cleared when no longer needed.
```

#### databricks.Secret.validateKey

```text
databricks.Secret/validateKey is a function.
    key = validateKey(~, val)
```

#### databricks.Secret.validateScope

```text
databricks.Secret/validateScope is a function.
    scope = validateScope(~, val)
```

### databricks.SparkConfPair

Superclass: databricks.Object

```text
SPARKCONFPAIR Class to specify Spark configuration key-value pairs
  They can also be used pass in a string of extra JVM options 
  Keys and value must be character vectors or scalar strings.
  Both keys and values are stored as character arrays.
 
  For example:
    
    cl = databricks.Cluster;
    scp = databricks.SparkConfPair('spark.speculation', 'true');
    cl.setCustomTags(scp);
  
  Optionally, this class accepts a cell array of inputs to specify multiple
  pairs.
  
    scpCell = {'spark.speculation', 'true'; 'myvar','myval'};
    scps = databricks.SparkConfPair(scpCell);
 
  A pair can also be added to an existing SparkConfPair using the add method
    scpCell = {'spark.speculation', 'true'; 'myvar','myval'};
    scps = databricks.SparkConfPair(scpCell);
    scps.add('myNewKey','myNewValue');
 
  Order of insertion is not preserved.
```

#### databricks.SparkConfPair.SparkConfPair

```text
containers.Map is a handle class so set the property in the
  constructor

    Documentation for databricks.SparkConfPair
```

#### databricks.SparkConfPair.add

```text
ADD Adds a Key Value pair to a SparkConfPair object
 
  Example
    scps = databricks.SparkConfPair('key1','value1');
    scps.add('additionalKey', 'additionalValue');
```

### databricks.SparkEnvPair

Superclass: databricks.Object

```text
SPARKENVPAIR Specify environment variables to attach to the create object.
  Use to Spark environment variable key-value pairs on the databricks cluster.
  Keys and values must be character vectors or scalar strings.
  Both keys and values are stored as character arrays.
 
  For example:
 
    cl = databricks.Cluster;
    var = databricks.SparkEnvPair('SPARK_WORKER_MEMORY','28000m');
    cl.setSparkEnvVars(var);
 
  Optionally, this class accepts a cell array of inputs to specify multiple
  tag pairs.
 
    varCell = {'SPARK_WORKER_MEMORY','28000m';'SPARK_LOCAL_DIRS','/local_disk0'};
    vars = databricks.SparkEnvPair(varCell);
 
  A pair can also be added to an existing SparkEnvPair using the add method
    varCell = {'SPARK_WORKER_MEMORY','28000m';'SPARK_LOCAL_DIRS','/local_disk0'};
    vars = databricks.SparkEnvPair(varCell);
    vars.add('myNewKey','myNewValue');
 
  Order of insertion is not preserved.
  When specifying environment variables in a job cluster, the fields in this
  data structure accept only Latin characters (ASCII character set). Using
  non-ASCII characters will return an error. Examples of invalid, non-ASCII
  characters are Chinese, Japanese kanjis, and emojis.
 
  https://docs.databricks.com/dev-tools/api/latest/clusters.html#sparkenvpair
```

#### databricks.SparkEnvPair.SparkEnvPair

```text
containers.Map is a handle class so set the property in the
  constructor

    Documentation for databricks.SparkEnvPair
```

#### databricks.SparkEnvPair.add

```text
ADD Adds a Key Value pair to a SparkEnvPair object
 
  Example
    vars = databricks.SparkEnvPair('key1','value1');
    vars.add('additionalKey', 'additionalValue');
```

### databricks.SparkJarTask

Superclass: databricks.BaseTask

```text
SPARKJARTASK Definition of a spark JAR task
    
  This class can be used to define a spark-jar task that can be attached
  to a databricks.Job for execution on a Spark Cluster.
 
    job = databricks.Job;
    job.setCluster("1101-121324-qweuiozn")
    task = databricks.SparkJarTask;
    task.Application = "/dfbs/example/runSLModel.jar";
    task.Arguments = [...
        inputLocation,...
        outputLocation];
    task.main_class_name = 'com.mathworks.example.3DOFExample';
    task = databricks.SparkSubmitTask;
    task.Application = "/dbfs/example/meanArrivalDemo.jar"
    task.Arguments = {"/MATLAB_Runtime",...
                      "/dbfs/data/airlinesmall.csv",...
                      "/dbfs/output/"};
    job.setTask(job);
```

#### databricks.SparkJarTask.SparkJarTask

```text
SPARKJARTASK Definition of a spark JAR task
    
  This class can be used to define a spark-jar task that can be attached
  to a databricks.Job for execution on a Spark Cluster.
 
    job = databricks.Job;
    job.setCluster("1101-121324-qweuiozn")
    task = databricks.SparkJarTask;
    task.Application = "/dfbs/example/runSLModel.jar";
    task.Arguments = [...
        inputLocation,...
        outputLocation];
    task.main_class_name = 'com.mathworks.example.3DOFExample';
    task = databricks.SparkSubmitTask;
    task.Application = "/dbfs/example/meanArrivalDemo.jar"
    task.Arguments = {"/MATLAB_Runtime",...
                      "/dbfs/data/airlinesmall.csv",...
                      "/dbfs/output/"};
    job.setTask(job);

    Documentation for databricks.SparkJarTask
```

#### databricks.SparkJarTask.getTaskEntries

```text
Create the library entry
```

### databricks.SparkPythonTask

Superclass: databricks.BaseTask

```text
SPARKPYTHONTASK Definition of a spark JAR task
 
  This class can be used to define a Spark Python task that can be attached
  to a databricks.Job for execution on a Spark Cluster.
 
  spt = databricks.SparkPythonTask('python_file', 'dbfs:/example/databricks/pi.py', 'parameters', "4");
 
  job = databricks.Job();
  job.name = sprintf('pi-calc-%s', datestr(now, 30));
  job.setCluster(cluster);
  job.setTask(spt);
 
  job.create();
  jobRun = job.runNow();
```

#### databricks.SparkPythonTask.SparkPythonTask

```text
SPARKPYTHONTASK Definition of a spark JAR task
 
  This class can be used to define a Spark Python task that can be attached
  to a databricks.Job for execution on a Spark Cluster.
 
  spt = databricks.SparkPythonTask('python_file', 'dbfs:/example/databricks/pi.py', 'parameters', "4");
 
  job = databricks.Job();
  job.name = sprintf('pi-calc-%s', datestr(now, 30));
  job.setCluster(cluster);
  job.setTask(spt);
 
  job.create();
  jobRun = job.runNow();

    Documentation for databricks.SparkPythonTask
```

#### databricks.SparkPythonTask.getTaskEntries

```text
Create the spark python entry
```

### databricks.SparkSubmitTask

Superclass: databricks.BaseTask

```text
SPARKSUBMITTASK Definition of a spark-submit task
  This class can be used to define a spark-submit task that can be attached
  to a databricks.Job for execution on a Spark Cluster.
 
  An object of this class is configured using its properties and attached
  to a job using the setTask() method of the Job.
  
   Example:
    cl = databricks.Cluster;
    cl.setNumWorkers(4)
    job = databricks.Job;
    job.setCluster(cl)
    task = databricks.SparkSubmitTask;
    task.Application = "/dbfs/example/myDemo.jar"
    task.Arguments = {"/MATLAB_Runtime",...
                      "/dbfs/data/airlinesmall.csv",...
                      "/dbfs/output/"};
   job.setTask(job);
 
  SparkSubmitTask is deprecated and should no longer be used see:
  https://docs.databricks.com/aws/en/jobs/spark-submit
  Existing support will be removed in a future release
```

#### databricks.SparkSubmitTask.SparkSubmitTask

```text
SPARKSUBMITTASK Definition of a spark-submit task
  This class can be used to define a spark-submit task that can be attached
  to a databricks.Job for execution on a Spark Cluster.
 
  An object of this class is configured using its properties and attached
  to a job using the setTask() method of the Job.
  
   Example:
    cl = databricks.Cluster;
    cl.setNumWorkers(4)
    job = databricks.Job;
    job.setCluster(cl)
    task = databricks.SparkSubmitTask;
    task.Application = "/dbfs/example/myDemo.jar"
    task.Arguments = {"/MATLAB_Runtime",...
                      "/dbfs/data/airlinesmall.csv",...
                      "/dbfs/output/"};
   job.setTask(job);
 
  SparkSubmitTask is deprecated and should no longer be used see:
  https://docs.databricks.com/aws/en/jobs/spark-submit
  Existing support will be removed in a future release

    Documentation for databricks.SparkSubmitTask
```

#### databricks.SparkSubmitTask.getParameters

```text
databricks.SparkSubmitTask/getParameters is a function.
    strArray = getParameters(obj)
```

#### databricks.SparkSubmitTask.getTaskEntries

```text
databricks.SparkSubmitTask/getTaskEntries is a function.
    entries = getTaskEntries(obj)
```

### databricks.Tasks

Superclass: databricks.BaseTask

```text
Tasks an entry for orchestration jobs
 
  The new 2.1 REST API from Databricks supports jobs with several
  tasks, with dependencies between them. This class captures this
  functionality.
 
  To use this form, first create the concrete tasks to be part of the
  job. See doc for the different task types for more information on how
  to configure these.
    T1 = databricks.SparkJarTask()
    T2 = databricks.NotebookTask()
 
  Now create the Tasks object
    tasks = databricks.Tasks()
 
  Add the different tasks, adding information about where to run (e.g.
  if on a new cluster or an existing one), if the tasks depend on each
  other, etc. The clusters mentioned here were created with the
  databricks.Custer class, see corresponding documentation.
 
   tasks.addTask(T1, "task_key_1", ...
      "description", "My SparkJar task", ...
      "new_cluster", cl1);
   tasks.addTask(T2, "task_key_2", ...
      "description", "My Notebook task", ...
      "depends_on", ["task_key_1"], ...
      "existing_cluster_id", "1101-140344-qwerquor");
 
  Finally, set the 'tasks' as the task for the job
   job.setTask(tasks)
 
  No error checking is done to verify if correct settings are used, as
  the Databricks API will respond to this.
```

#### databricks.Tasks.Tasks

```text
Tasks an entry for orchestration jobs
 
  The new 2.1 REST API from Databricks supports jobs with several
  tasks, with dependencies between them. This class captures this
  functionality.
 
  To use this form, first create the concrete tasks to be part of the
  job. See doc for the different task types for more information on how
  to configure these.
    T1 = databricks.SparkJarTask()
    T2 = databricks.NotebookTask()
 
  Now create the Tasks object
    tasks = databricks.Tasks()
 
  Add the different tasks, adding information about where to run (e.g.
  if on a new cluster or an existing one), if the tasks depend on each
  other, etc. The clusters mentioned here were created with the
  databricks.Custer class, see corresponding documentation.
 
   tasks.addTask(T1, "task_key_1", ...
      "description", "My SparkJar task", ...
      "new_cluster", cl1);
   tasks.addTask(T2, "task_key_2", ...
      "description", "My Notebook task", ...
      "depends_on", ["task_key_1"], ...
      "existing_cluster_id", "1101-140344-qwerquor");
 
  Finally, set the 'tasks' as the task for the job
   job.setTask(tasks)
 
  No error checking is done to verify if correct settings are used, as
  the Databricks API will respond to this.

    Documentation for databricks.Tasks
```

#### databricks.Tasks.addJobCluster

```text
addJobCluster Add a job-level cluster to this task
 
  Arguments
     clusterKey A string denoting this cluster
     clusterObject An object representing a cluster to run
  Example:
   T = databricks.Tasks();
   cl1 = createDatabricksCluster(...
       '', ...  No name for this kind of cluster
       2, ... Two workers
       'create', false ... Don't create the cluster
       );
   cl2 = createDatabricksCluster(...
       '', ...  No name for this kind of cluster
       0, ... Single-node cluster
       'create', false ... Don't create the cluster
       );
   T.addJobCluster('cl1', cl1);
   T.addJobCluster('cl2', cl2);
```

#### databricks.Tasks.addTask

```text
addTask Add a task to a Jobs 2.1 API job
 
  Arguments
     task  A task object. Supported types are
           databricks.SparkSubmitTask, databricks.SparkJarTask
           databricks.NotebookTask, SparkPythonTask
     task_key A text string for identifying a task
  Optional arguments (different tasks may need different
  arguments)
     description A simple description of the task
     new_cluster A databricks.Cluster object (not created)
     timeout_seconds An integer number
     max_retries An integer number
     min_retry_interval_millis A number
     retry_on_timeout "true"/"false"
 
  A new_cluster for a task may not have autotermination set. If it's
  set, it will be removed automatically.
 
  SparkSubmitTask is deprecated and should no longer be used see:
  https://docs.databricks.com/aws/en/jobs/spark-submit
  Existing support will be removed in a future release
```

#### databricks.Tasks.getTaskEntries

```text
databricks.Tasks/getTaskEntries is a function.
    entries = getTaskEntries(obj)
```

### databricks.Token

Superclasses: databricks.Object, matlab.mixin.CustomDisplay

```text
TOKEN Databricks API token
  A databricks Token allows creation, list, revocation of Personal Access Tokens
  (PATs) the can be used to authenticate and access Databricks REST APIs if
  enabled.
 
  Optional arguments:
 
    verbose: Enable additional output
 
  Example:
  t = databricks.Token()
  l = t.list();
```

#### databricks.Token.Token

```text
TOKEN Databricks API token
  A databricks Token allows creation, list, revocation of Personal Access Tokens
  (PATs) the can be used to authenticate and access Databricks REST APIs if
  enabled.
 
  Optional arguments:
 
    verbose: Enable additional output
 
  Example:
  t = databricks.Token()
  l = t.list();

    Documentation for databricks.Token
```

#### databricks.Token.create

```text
CREATE Create a databricks token with a specified lifetime
  This call returns the error QUOTA_EXCEEDED if the caller exceeds the token
  quota, which is 600. The token object is updated with a created value.
 
    create(durationInSeconds, commentString);
 
  Example:
 
    % Create a handle to the Token interface
    token = databricks.Token();
    token.create(100, 'Sample Comment');
 
  Following create the token object will contain the ID, creation time, expiry
  time and value required to work with the databricks API.
 
    token =
          Token with properties:
            token_value: "<REDACTED>"
             token_info: [1x1 struct]
 
    token.token_info is a struct with fields:
 
           comment: "Sample Comment"
     creation_time: 05-Aug-2026 11:32:04
       expiry_time: 05-Aug-2026 11:33:44
            scopes: [0x0 string]
          token_id: "f5db25c85b5c21b7a042b728ebba57c7c866f57a29a1959a41a6c4944bae618d"
 
  Create a token with specific scopes using a named argument `scopes` set to a character
  vector, string or string array.
 
    token = databricks.Token();
    token.create(100, 'Sample Comment', scopes=["unity-catalog", "clusters"]);
 
  The first argument `lifetime_seconds` can also be specified as a MATLAB duration
  and it will be converted accordingly.
```

#### databricks.Token.getPropertyGroups

```text
GETPROPERTYGROUPS Redacts sensitive information from the object display
```

#### databricks.Token.list

```text
LIST Method to list existing tokens on the Databricks interface
  List the existing tokens on databricks account using the REST API.
 
  Example:
    t = databricks.Token()
    l = t.list();
```

#### databricks.Token.revoke

```text
REVOKE Method to revoke a databricks token
  Revoke an API access token using the REST API.
 
  Example:
 
    tokenInterface = databricks.Token();
    tokenInterface.revoke();
```

#### databricks.Token.table

```text
TABLE Method to convert a list of tokens to a MATLAB table
  Convert a list of tokens showing the ID and info and omitting the value
  that is available on the createToken interface.
  If no tokens are found an error results.
 
  Deprecated: This method will be removed in a future release
 
  Example:
    token = databricks.Token();
    list = token.list();
    t = table(list);
```

### databricks.UnityCatalog

Superclass: databricks.Object

```text
UNITYCATALOG MATLAB Class for interacting with the Databricks Unity
  Catalog Management API as documented on:
 
    https://api-docs.databricks.com/rest/latest/unity-catalog-api-specification-2-1.html
 
  UnityCatalog Methods:
 
    createCatalog                - Creates a new catalog.
    createExternalLocation       - Creates a new external location.
    createMetastore              - Creates a new metastore.
    createMetastoreAssignment    - Creates meta store assignments.
    createProvider               - Creates a delta sharing provider.
    createRecipient              - Creates a new delta sharing recipient.
    createSchema                 - Creates a new schema.
    createShare                  - Creates new delta sharing share.
    createStorageCredential      - Creates a new storage credential.
    deleteCatalog                - Deletes a catalog. 
    deleteExternalLocation       - Deletes an external location.
    deleteMetastore              - Deletes a metastore.
    deleteMetastoreAssignment    - Deletes a metastore assignment.
    deleteProvider               - Deletes a delta sharing provider.
    deleteRecipient              - Deletes a delta sharing recipient.
    deleteSchema                 - Deletes a schema.
    deleteShare                  - Deletes delta sharing share.
    deleteStorageCredential      - Deletes a storage credential.
    deleteTable                  - Deletes a table.
    getArtifactAllowlists        - Gets the artifact allowlist of a certain artifact type.
    getCatalog                   - Gets catalog information.
    getExternalLocation          - Gets external location information.
    getMetastore                 - Gets metastore information.
    getMyGroups                  - Gets group membership information of the user.
    getMyInfo                    - Retrieves current user information as it relates to Unity Catalog.
    getPermissions               - Gets permissions as set for a given object.
    getProvider                  - Gets delta sharing provider information.
    getRecipient                 - Gets delta sharing recipient information.
    getRecipientSharePermissions - Gets permissions for the given delta.
    getSchema                    - Gets schema information.
    getShare                     - Gets delta sharing share information.
    getSharePermissions          - Gets permissions of specified delta sharing share.
    getStorageCredential         - Gets storage credential information.
    getTable                     - Gets table information.
    listCatalogs                 - Gets list of catalogs.
    listExternalLocations        - Gets list of external locations.
    listFiles                    - List files in an external URL.
    listMetastores               - Lists metastores.
    listProviders                - Lists delta sharing providers.
    listProviderShares           - Lists delta sharing shares for a given provider.
    listRecipients               - Lists delta sharing recipients.
    listSchemas                  - Lists schemas in a given catalog.
    listShares                   - Lists delta sharing shares.
    listStorageCredentials       - Lists storage credentials.
    listTables                   - Lists tables in a given catalog and schema.
    listTableSummaries           - Lists high level table information for tables in a given catalog.
    rotateRecipientToken         - Rotates the token for an external recipient.
    setArtifactAllowlist         - Set the artifact allowlist of a certain artifact type.
    updateCatalog                - Updates catalog settings.
    updateExternalLocation       - Updates external location settings.
    updateMetastore              - Updates metastore settings.
    updateMetastoreAssignment    - Updates metastore assignment on a given workspace.
    updatePermissions            - Updates permissions on a given object.
    updateProvider               - Updates delta sharing provider settings.
    updateRecipient              - Updates delta sharing recipient settings.
    updateSchema                 - Updates schema settings.
    updateShare                  - Updates delta sharing share settings.
    updateShareObjects           - Updates objects on a given delta sharing share.
    updateSharePermissions       - Updates permissions on a delta sharing share.
    updateStorageCredential      - Updates store credential settings.
```

#### databricks.UnityCatalog.UnityCatalog

```text
Unity Catalog Constructor

    Documentation for databricks.UnityCatalog
```

#### databricks.UnityCatalog.createCatalog

```text
CREATECATALOG creates a new catalog.
 
  Example:
 
    result = uc.createCatalog(cataloginfo);
 
  Required Inputs:
    cataloginfo  
        Description:
            settings/configuration for the new catalog
        Type:
            databricks.datastructures.unitycatalog.CatalogInfo
        Required Properties in the data structure which must be set:
            name
        Optional Properties in the data structure which can be set:
            comment
            ucproperties
            provider_name
            share_name
 
  Outputs:
    result  
        Description:
            settings/configuration of the created catalog
        Type:
            databricks.datastructures.unitycatalog.CatalogInfo
 
  See Also: databricks.datastructures.unitycatalog.CatalogInfo
```

#### databricks.UnityCatalog.createConnection

```text
CREATECONNECTION creates a new connection.
 
  Examples:
    result = uc.createConnection(connectionInfo);
 
    connectionInfo =  databricks.datastructures.unitycatalog.ConnectionInfo();
    connectionInfo.connection_type = databricks.datastructures.unitycatalog.ConnectionType.HTTP;
    connectionInfo.name = "my_connection";
    connectionInfo.comment = "test connection to example.com";
    connectionInfo.options = JSONMapperMap( ...
      "host", "https://example.com", ...
      "port", "443", ...
      "bearer_token", "abcdREDACTEDefgh", ...
      "is_mcp_connection", "false", ...
      "base_path", "/my/base/path/");
    connectionInfo.read_only = false;
    result = uc.createConnection(connectionInfo);
 
  Required Inputs:
    connectionInfo
        Description:
            settings/configuration for the new connection
        Type:
            databricks.datastructures.unitycatalog.ConnectionInfo
        Required Properties in the data structure which must be set:
            connection_type
            name
            options
        Optional Properties in the data structure which can be set:
            comment
            connectionProperties
            read_only
 
  Outputs:
    result
        Description:
            settings/configuration of the created connection
        Type:
            databricks.datastructures.unitycatalog.Connection
 
  See Also: databricks.datastructures.unitycatalog.Connection
            https://docs.databricks.com/api/workspace/connections/create
```

#### databricks.UnityCatalog.createExternalLocation

```text
CREATEEXTERNALLOCATION creates a new external location.
 
  Example:
 
    result = uc.createExternalLocation(externallocationinfo);
 
  Required Inputs:
    externallocationinfo  
        Description: 
            settings/configuration for the new external location
        Type: 
            databricks.datastructures.unitycatalog.ExternalLocationInfo
        Required Properties in the data structure which must be set:
            name
            url
            credential_name
        Optional Properties in the data structure which can be set:
            comment
            read_only
 
  Outputs:
    result  
        Description:
            settings/configuration of the created external location
        Type:
            databricks.datastructures.unitycatalog.ExternalLocationInfo    
 
  See Also: databricks.datastructures.unitycatalog.ExternalLocationInfo
```

#### databricks.UnityCatalog.createMetastore

```text
CREATEMETASTORE creates a new metastore
 
  Example:
 
    result = uc.createMetastore(metastoreinfo);    
 
  Required Inputs:
    metastoreinfo  
        Description: 
            settings/configuration for the new metastore
        Type: 
            databricks.datastructures.unitycatalog.MetastoreInfo
        Required Properties in the data structure which must be set:
            name
            storage_root
 
  Outputs:
    result  
        Description:
            settings/configuration of the created metastore
        Type:
            databricks.datastructures.unitycatalog.MetastoreInfo
 
  See Also: databricks.datastructures.unitycatalog.MetastoreInfo
```

#### databricks.UnityCatalog.createMetastoreAssignment

```text
CREATEMETASTOREASSIGNMENT creates meta store assignments which
  assigns meta stores to workspaces.
 
  Example:
 
    result = uc.createMetastoreAssignment(workspace_id, metastoreassignment);
 
  Required Inputs:
    workspace_id
        Description:
            ID of the workspace to create assignment for
        Type:
            int64
    metastoreassignment
        Description:
            settings/configuration for the assignment
        Type:
            databricks.datastructures.unitycatalog.MetastoreAssignment
        Required Properties in the data structure which must be set:
            metastore_id
            default_catalog_name
 
  Outputs:
    result
        Description:
            settings/configuration of the created metastore assignment
        Type:
            databricks.datastructures.unitycatalog.MetastoreAssignment
 
  See Also: databricks.datastructures.unitycatalog.MetastoreAssignment
```

#### databricks.UnityCatalog.createProvider

```text
CREATEPROVIDER creates a delta sharing provider.
 
  Example:
 
    result = uc.createProvider(providerinfo);
 
  Required Inputs:
    providerinfo  
        Description: 
            settings/configuration for the new provider
        Type: 
            databricks.datastructures.unitycatalog.ProviderInfo
        Required Properties in the data structure which must be set:
            name
            authentication_type
        Optional Properties in the data structure which can be set:
            comment
            recipient_profile_str
 
  Outputs:
    result  
        Description:
            settings/configuration of the created provider
        Type:
            databricks.datastructures.unitycatalog.ProviderInfo
 
  See Also: databricks.datastructures.unitycatalog.ProviderInfo
```

#### databricks.UnityCatalog.createRecipient

```text
CREATERECIPIENT creates a new delta sharing recipient.
 
  Example:
 
    result = uc.createRecipient(recipientinfo);    
 
  Required Inputs:
    recipientinfo  
        Description: 
            settings/configuration for the new recipient
        Type: 
            databricks.datastructures.unitycatalog.RecipientInfo
        Required Properties in the data structure which must be set:
            name
            authentication_type
        Optional Properties in the data structure which can be set:
            comment
            data_recipient_global_metastore_id
            ip_access_list
 
  Outputs:
    result  
        Description:
            settings/configuration of the created recipient
        Type:
            databricks.datastructures.unitycatalog.RecipientInfo      
 
  See Also: databricks.datastructures.unitycatalog.RecipientInfo
```

#### databricks.UnityCatalog.createSchema

```text
CREATESCHEMA creates a new schema.
 
  Example:
 
    result = uc.createSchema(schemainfo);
 
  Required Inputs:
    schemainfo
        Description:
            settings/configuration for the new schema
        Type:
            databricks.datastructures.unitycatalog.SchemaInfo
        Required Properties in the data structure which must be set:
            name
            catalog_name
        Optional Properties in the data structure which can be set:
            comment
            ucproperties
 
  See Also: databricks.datastructures.unitycatalog.SchemaInfo
```

#### databricks.UnityCatalog.createShare

```text
CREATESHARE creates new delta sharing share. Use this to first create
  a new share with only a name (and possibly comment) set. Then use
  updateShareObjects to add objects to the share and
  updateSharePermissions to grant access to recipients.
 
  Example:
 
    result = uc.createShare(shareinfo);
 
  Required Inputs:
    shareinfo  
        Description: 
            settings/configuration for the new share
        Type: 
            databricks.datastructures.unitycatalog.ShareInfo
        Required Properties in the data structure which must be set:
            name
        Optional Properties in the data structure which can be:
            comment
 
  Outputs:
    result  
        Description:
            settings/configuration of the created share
        Type:
            databricks.datastructures.unitycatalog.ShareInfo    
 
  See Also: databricks.datastructures.unitycatalog.ShareInfo,
            updateShareObjects, updateSharePermissions
```

#### databricks.UnityCatalog.createStorageCredential

```text
CREATESTORAGECREDENTIAL creates a new storage credential.
 
  Example:
 
    result = uc.createStorageCredential(storagecredentialinfo);
 
  Required Inputs:
    storagecredentialinfo  
        Description: 
            settings/configuration for the new storage credential
        Type: 
            databricks.datastructures.unitycatalog.StorageCredentialInfo
        Required Properties in the data structure which must be set:
            name
            aws_iam_role OR azure_service_principal OR gcp_service_account_key
        Optional Properties in the data structure which can be set:
            comment
            skip_validation
 
  Outputs:
    result  
        Description:
            settings/configuration of the created storage credential
        Type:
            databricks.datastructures.unitycatalog.StorageCredentialInfo
 
  See Also: databricks.datastructures.unitycatalog.StorageCredentialInfo
```

#### databricks.UnityCatalog.createVolume

```text
CREATEVOLUME Creates a new volume.
  Creates either an external volume or a managed volume.
  An external volume will be created in the specified external location,
  while a managed volume will be located in the default location which
  is specified by the parent schema, or the parent catalog, or the Metastore.
 
  For the volume creation to succeed, the user must satisfy following conditions:
   * The caller must be a metastore admin, or be the owner of the parent
     catalog and schema, or have the USE_CATALOG privilege on the parent
     catalog and the USE_SCHEMA privilege on the parent schema.
 
   * The caller must have CREATE VOLUME privilege on the parent schema.
 
  For an external volume, following conditions also need to satisfy:
   * The caller must have CREATE EXTERNAL VOLUME privilege on the external location.
 
   * There are no other tables, nor volumes existing in the specified storage location.
 
   * The specified storage location is not under the location of other tables,
     nor volumes, or catalogs or schemas.
 
  Example:
 
    result = uc.createShare(shareinfo);
 
  Required Inputs:
    catalog_name
        Description: 
            The identifier of the catalog
        Type:
            string
    schema_name
        Description:
            The identifier of the schema
        Type:
            string
    name
        Description:
            Volume name
        Type:
            string
    volume_type
        Description:
            Type of volume e.g. EXTERNAL or MANAGED
        Type:
            databricks.datastructures.unitycatalog.VolumeType
    storage_location
        Description:
            Underlying volume storage location
            If creating a volume of type MANAGED then the
            storage_location value is not used and "" can be
            specified for this argument
        Type:
            string
    comment
        Description:
            Comment field, user-supplied free-form text
        Type:
            string
 
  Outputs:
    result  
        Description:
            settings/configuration of the created share
        Type:
            databricks.datastructures.unitycatalog.VolumeInfo
 
  See Also: databricks.datastructures.unitycatalog.VolumeInfo,
 
            https://docs.databricks.com/api/workspace/volumes/create
```

#### databricks.UnityCatalog.deleteCatalog

```text
DELETECATALOG deletes a catalog. Note it is not possible to delete
  non-empty catalogs. If needed, use deleteSchema first to delete all
  schemas in the catalog.
 
  Example:
 
    result = uc.deleteCatalog(name);
 
  Required Inputs:
    name  
        Description: 
            name of the catalog to delete
        Type: 
            string
  Outputs:
    result
        Description:
            true is successful, never returns false (throws error if 
            unsuccessful)
        Type:
            logical
 
  See Also: deleteSchema
```

#### databricks.UnityCatalog.deleteConnection

```text
DELETECONNECTION deletes a Connection.
 
  Example:
 
    result = uc.deleteConnection(name);
 
  Required Inputs:
    name  
        Description: 
            name of the catalog to delete
        Type: 
            string
  Outputs:
    result
        Description:
            true is successful, never returns false (throws error if 
            unsuccessful)
        Type:
            logical
 
  See Also: https://docs.databricks.com/api/workspace/connections/delete
```

#### databricks.UnityCatalog.deleteExternalLocation

```text
DELETEEXTERNALLOCATION deletes an external location.
 
  Example:
 
    result = uc.deleteExternalLocation(name);
    result = uc.deleteExternalLocation(name,true);
 
  Required Inputs:
    name  
        Description: 
            name of the external location to delete
        Type: 
            string
 
  Optional Inputs:
    force
        Description:
            force delete
        Type:
            logical
        Default value:
            false
 
  Outputs:
    result
        Description:
            true is successful, never returns false (throws error if 
            unsuccessful)
        Type:
            logical
```

#### databricks.UnityCatalog.deleteMetastore

```text
DELETEMETASTORE deletes a metastore.
 
  Example:
 
    result = uc.deleteMetastore(id);    
    result = uc.deleteMetastore(id,true);    
 
  Required Inputs:
    id  
        Description: 
            id of the metastore to delete
        Type: 
            string
 
  Optional Inputs:
    force
        Description:
            force delete
        Type:
            logical
        Default value:
            false
 
  Outputs:
    result
        Description:
            true is successful, never returns false (throws error if 
            unsuccessful)
        Type:
            logical
```

#### databricks.UnityCatalog.deleteMetastoreAssignment

```text
DELETEMETASTOREASSIGNMENT deletes a metastore assignment.
 
  Example:
 
    result = uc.deleteMetastoreAssignment(workspace_id, metastoreassignment);
 
  Required Inputs:
    workspace_id
        Description:
            ID of the workspace to delete assignment from
        Type:
            int64    
    metastoreassignment  
        Description: 
            Data structure with 'metastore_id' property set to specify
            which assignment to delete
        Type:
            databricks.datastructures.unitycatalog.MetastoreAssignment
 
  Outputs:
    result
        Description:
            true is successful, never returns false (throws error if 
            unsuccessful)
        Type:
            logical
 
  See Also: databricks.datastructures.unitycatalog.MetastoreAssignment
```

#### databricks.UnityCatalog.deleteProvider

```text
DELETEPROVIDER deletes a delta sharing provider.
 
  Example:
 
    result = uc.deleteProvider(name);    
 
  Required Inputs:
    name  
        Description: 
            name of the provider to delete
        Type: 
            string
 
  Outputs:
    result
        Description:
            true is successful, never returns false (throws error if 
            unsuccessful)
        Type:
            logical
```

#### databricks.UnityCatalog.deleteRecipient

```text
DELETERECIPIENT deletes a delta sharing recipient.
 
  Example:
 
    result = uc.deleteRecipient(name);
 
  Required Inputs:
    name  
        Description: 
            name of the recipient to delete
        Type: 
            string
 
  Outputs:
    result
        Description:
            true is successful, never returns false (throws error if 
            unsuccessful)
        Type:
            logical
```

#### databricks.UnityCatalog.deleteSchema

```text
DELETESCHEMA deletes a schema.
 
  Example:
 
    result = uc.deleteSchema(name);
 
  Required Inputs:
    name  
        Description: 
            name of the schema to delete
        Type: 
            string
 
  Outputs:
    result
        Description:
            true is successful, never returns false (throws error if 
            unsuccessful)
        Type:
            logical
```

#### databricks.UnityCatalog.deleteShare

```text
DELETESHARE deletes delta sharing share.
 
  Example:
 
    result = uc.deleteShare(name);
 
  Required Inputs:
    name  
        Description: 
            name of the share to delete
        Type: 
            string
 
  Outputs:
    result
        Description:
            true is successful, never returns false (throws error if 
            unsuccessful)
        Type:
            logical
```

#### databricks.UnityCatalog.deleteStorageCredential

```text
DELETESTORAGECREDENTIAL deletes a storage credential.
 
  Example:
 
    result = uc.deleteStorageCredential(name);
    result = uc.deleteStorageCredential(name,true);
 
  Required Inputs:
    name
        Description:
            name of the storage credential to delete
        Type:
            string
 
  Optional Inputs:
    force
        Description:
            force delete
        Type:
            logical
        Default value:
            false
 
  Outputs:
    result
        Description:
            true is successful, never returns false (throws error if 
            unsuccessful)
        Type:
            logical
```

#### databricks.UnityCatalog.deleteTable

```text
DELETETABLE deletes a table.
 
  Example:
 
    result = uc.deleteTable(name);
 
  Required Inputs:
    name
        Description:
            name of the table to delete
        Type:
            string
 
  Outputs:
    result
        Description:
            true is successful, never returns false (throws error if 
            unsuccessful)
        Type:
            logical
```

#### databricks.UnityCatalog.deleteVolume

```text
DELETEVOLUME deletes a volume.
 
  Example:
 
    result = uc.deleteVolume(name);
 
  Required Inputs:
    name  
        Description: 
            The three-level (fully qualified) name of the volume
            e.g.: "main.default.my_volume"
        Type: 
            string
 
  Outputs:
    result
        Description:
            true is successful, never returns false (throws error if 
            unsuccessful)
        Type:
            logical
```

#### databricks.UnityCatalog.genTempVolumeCredential

```text
GENTEMPVOLUMECREDENTIAL Generate a temporary volume credential
 
  Required Inputs:
    operation
        Description: 
            The operation performed against the volume data, either READ_VOLUME or WRITE_VOLUME.
        Type: 
            databricks.datastructures.unitycatalog.Operation
 
    volume_id
        Description: 
            Id of the volume to read or write.
        Type: 
            string
  Outputs:
    result  
        Description:
            A short-lived credential for directly accessing the volume data on cloud storage. 
        Type:
            databricks.datastructures.unitycatalog.GenTempColCredsResp
 
 
  Examples:
    % Basic form
    result = uc.genTempVolumeCredential(operation, volume_id);
 
 
    % Get an Azure SAS to allow a read from MATLAB using copyfile rather than databricks.Files
    volName = "main.default.myvolume"
    uc = databricks.UnityCatalog;
    volInfo = uc.getVolume(volName);
    volumeId = volInfo.volume_id;
    operation = "READ_VOLUME";
    result = uc.genTempVolumeCredential(operation, volumeId);
    setenv("MW_WASB_SAS_TOKEN", "?"+result.azure_user_delegation_sas.sas_token);
    catalogPath = replace(volName, ".", "/") + "/MathWorks/runtimes/runtime_install.sh"
    [p,n,e] = fileparts(catalogPath);
    fname = n + e;
    dst = fullfile(pwd, fname);
    % Convert URL from abfss to wasbs and append the path
    % e.g. wasbs://container@account/path_to_file/file.ext
    wasbsUrl = replace(result.url, "abfss://", "wasbs://");
    wasbsUrl = replace(wasbsUrl, "" + ".dfs.", ".blob.");
    wasbsUrl = wasbsUrl + catalogPath;
    copyfile(wasbsUrl, dst);
 
    % To write the volume use: operation = "WRITE_VOLUME"
    % Note that write are only supported to external volumes , not managed volumes
 
    See also https://learn.microsoft.com/en-us/azure/databricks/external-access/credential-vending
             databricks.datastructures.unitycatalog.GenTempColCredsResp
```

#### databricks.UnityCatalog.getArtifactAllowlists

```text
getArtifactAllowlists Get the artifact allowlist of a certain artifact type
  The caller must be a metastore admin or have the MANAGE ALLOWLIST privilege
  on the metastore.
 
  Example:
 
    uc = databricks.UnityCatalog;
    artifact_type = databricks.datastructures.unitycatalog.ArtifactType.INIT_SCRIPT;
    result = uc.getArtifactAllowlists(artifact_type);
 
  Outputs:
    result  
        Description:
            object which lists artifact allowlist of a certain artifact type
        Type:
            databricks.datastructures.unitycatalog.GetArtifactAllowlistsResp
 
  Throws an error if the specified metastore cannot be found.
 
  If no artifacts are present a databricks.datastructures.unitycatalog.GetArtifactAllowlistsResp
  is returned with the metastore_id field populated and the other
  fields having default values, e.g:
 
    x = matlab.databricks.unitycatalog.getArtifactAllowListItems('LIBRARY_MAVEN')
    x = GetArtifactAllowListsResp with properties:
          artifact_matchers: [0x0 databricks.datastructures.unitycatalog.ArtifactMatchers]
          metastore_id: "3ce438d4-321c-49ec-9ac1-626acb9c0be3"
          created_by: ""
          created_at: [0x0 datetime]
 
  See Also: databricks.datastructures.unitycatalog.GetArtifactAllowlistsResp
```

#### databricks.UnityCatalog.getCatalog

```text
GETCATALOG gets catalog information.
 
  Example:
 
    result = uc.getCatalog(name);
 
  Required Inputs:
    name
        Description:
            name of the catalog
        Type:
            string
 
  Outputs:
    result
        Description:
            settings/configuration of the catalog
        Type:
            databricks.datastructures.unitycatalog.CatalogInfo
 
  Throws an error if the specified catalog cannot be found.
 
  See Also: databricks.datastructures.unitycatalog.CatalogInfo
```

#### databricks.UnityCatalog.getConnection

```text
GETCONNECTION gets connection information.
 
  Example:
 
    result = uc.getConnection(name);
 
  Required Inputs:
    name
        Description:
            name of the connection
        Type:
            string
 
  Outputs:
    result
        Description:
            settings/configuration of the connection
        Type:
            databricks.datastructures.unitycatalog.Connection
 
  Throws an error if the specified connection cannot be found.
 
  See Also: databricks.datastructures.unitycatalog.Connection
```

#### databricks.UnityCatalog.getExternalLocation

```text
GETEXTERNALLOCATION gets external location information.
 
  Example:
 
    result = uc.getExternalLocation(name);
 
  Required Inputs:
    name
        Description:
            name of the external location
        Type:
            string
 
  Outputs:
    result
        Description:
            settings/configuration of the external location
        Type:
            databricks.datastructures.unitycatalog.ExternalLocationInfo
 
  Throws an error if the specified external location cannot be found.
 
  See Also: databricks.datastructures.unitycatalog.ExternalLocationInfo
```

#### databricks.UnityCatalog.getMetastore

```text
GETMETASTORE gets metastore information.
 
  Example:
 
    result = uc.getMetastore(id);
 
  Required Inputs:
    id
        Description:
            id of the metastore
        Type:
            string
 
  Outputs:
    result
        Description:
            settings/configuration of the metastore
        Type:
            databricks.datastructures.unitycatalog.MetastoreInfo
 
  Throws an error if the specified metastore cannot be found.
 
  See Also: databricks.datastructures.unitycatalog.MetastoreInfo
```

#### databricks.UnityCatalog.getMyGroups

```text
GETMYGROUPS gets group membership information of the user.
 
  Example:
 
    result = uc.getMyGroups();
 
  Outputs:
    result
        Description:
            object with group_names which contains the group names
        Type:
            databricks.datastructures.unitycatalog.GetMyGroupsResp
 
  Throws an error if the specified metastore cannot be found.
 
  See Also: databricks.datastructures.unitycatalog.GetMyGroupsResp
```

#### databricks.UnityCatalog.getMyInfo

```text
GETMYINFO retrieves current user information as it relates to Unity
  Catalog. Which is really just one piece of information: whether the
  user is a metastore administrator or not.
 
  Example:
 
    result = uc.getMyInfo();
 
  Outputs:
    result  
        Description:
            object with is_metastore_admin property which indicates
            whether user is metastore administrator or not
        Type:
            databricks.datastructures.unitycatalog.GetMyInfoResp
 
  Throws an error if the specified metastore cannot be found.
 
  See Also: databricks.datastructures.unitycatalog.GetMyInfoResp
```

#### databricks.UnityCatalog.getPermissions

```text
GETPERMISSIONS gets permissions as set for a given object.
 
  Example:
 
    result = uc.getPermissions(sec_type, sec_full_name,principal);
 
  Required Inputs:
    sec_type
        Description:
            Type of object to retrieve permissions for
        Type:
            string
        Allowed Values:
            "metastore","catalog","schema","table",
            "storage-credential","external-location","view","function"
    sec_full_name  
        Description:
            full name of the object to retrieve permissions for
        Type:
            string
 
  Optional Inputs:
    principal
        Description:
            Principal of interest, if set only return permissions for
            this user/group.
        Type:
            string
        Default Value:
            <empty>
 
  Outputs:
    result
        Description:
            List with permissions
        Type:
            databricks.datastructures.unitycatalog.PermissionsList
 
  Throws an error if the specified object cannot be found.
 
  See Also: databricks.datastructures.unitycatalog.PermissionsList
```

#### databricks.UnityCatalog.getProvider

```text
GETPROVIDER gets delta sharing provider information.
 
  Example:
 
    result = uc.getProvider(name);
 
  Required Inputs:
    name
        Description:
            name of the provider
        Type:
            string
 
  Outputs:
    result
        Description:
            settings/configuration of the provider
        Type:
            databricks.datastructures.unitycatalog.ProviderInfo
 
  Throws an error if the specified provider cannot be found.
 
  See Also: databricks.datastructures.unitycatalog.ProviderInfo
```

#### databricks.UnityCatalog.getRecipient

```text
GETRECIPIENT gets delta sharing recipient information.
 
  Example:
 
    result = uc.getRecipient(name);
 
  Required Inputs:
    name
        Description:
            name of the recipient
        Type:
            string
 
  Outputs:
    result
        Description:
            settings/configuration of the recipient
        Type:
            databricks.datastructures.unitycatalog.RecipientInfo
 
  Throws an error if the specified recipient cannot be found.
 
  See Also: databricks.datastructures.unitycatalog.RecipientInfo
```

#### databricks.UnityCatalog.getRecipientSharePermissions

```text
GETRECIPIENTSHAREPERMISSIONS gets permissions for the given delta share recipient.
 
  Example:
 
    result = uc.getRecipientSharePermissions(name);
 
  Required Inputs:
    name
        Description:
            name of the recipient
        Type:
            string
 
  Outputs:
    result
        Description:
            share permissions for each share shared with the specified
            recipient
        Type:
            databricks.datastructures.unitycatalog.ShareToPrivilegeAssignmentList
 
  Throws an error if the specified recipient cannot be found.
 
  See Also: databricks.datastructures.unitycatalog.ShareToPrivilegeAssignmentList
```

#### databricks.UnityCatalog.getSchema

```text
GETSCHEMA gets schema information.
 
  Example:
 
    result = uc.getSchema(name);
 
  Required Inputs:
    name
        Description:
            name of the schema
        Type:
            string
 
  Outputs:
    result
        Description:
            settings/configuration of the schema
        Type:
            databricks.datastructures.unitycatalog.SchemaInfo
 
  Throws an error if the specified schema cannot be found.
 
  See Also: databricks.datastructures.unitycatalog.SchemaInfo
```

#### databricks.UnityCatalog.getShare

```text
GETSHARE gets delta sharing share information.
 
  Example:
 
    result = uc.getShare(name);
 
  Required Inputs:
    name
        Description:
            name of the share
        Type:
            string
 
  Outputs:
    result
        Description:
            settings/configuration of the share
        Type:
            databricks.datastructures.unitycatalog.ShareInfo
 
  Throws an error if the specified share cannot be found.
 
  See Also: databricks.datastructures.unitycatalog.ShareInfo
```

#### databricks.UnityCatalog.getSharePermissions

```text
GETSHAREPERMISSIONS gets permissions of specified delta sharing share.
 
  Example:
 
    result = uc.getSharePermissions(name);
 
  Required Inputs:
    name
        Description:
            name of the share
        Type:
            string
 
  Outputs:
    result
        Description:
            permissions on the share
        Type:
            databricks.datastructures.unitycatalog.PermissionsList
 
  Throws an error if the specified share cannot be found.
 
  See Also: databricks.datastructures.unitycatalog.PermissionsList
```

#### databricks.UnityCatalog.getStorageCredential

```text
GETSTORAGECREDENTIAL gets storage credential information.
 
  Example:
 
    result = uc.getStorageCredential(name);
 
  Required Inputs:
    name
        Description:
            name of the storage credential
        Type:
            string
 
  Outputs:
    result
        Description:
            settings/configuration of the storage credential
        Type:
            databricks.datastructures.unitycatalog.StorageCredentialInfo
 
  Throws an error if the specified storage credential cannot be found.
 
  See Also: databricks.datastructures.unitycatalog.StorageCredentialInfo
```

#### databricks.UnityCatalog.getTable

```text
GETTABLE gets table information.
 
  Example:
 
    result = uc.getTable(name);
 
  Required Inputs:
    name
        Description:
            name of the table
        Type:
            string
 
  Outputs:
    result
        Description:
            settings/configuration of the table
        Type:
            databricks.datastructures.unitycatalog.TableInfo
 
  Throws an error if the specified table cannot be found.
 
  See Also: databricks.datastructures.unitycatalog.TableInfo
```

#### databricks.UnityCatalog.getVolume

```text
GETVOLUME gets volume information.
 
  Example:
 
    result = uc.getVolume(name);
 
  Required Inputs:
    name
        Description:
            The three-level (fully qualified) name of the volume
            e.g.: "main.default.my_volume"
        Type:
            string
 
  Outputs:
    result
        Description:
            settings/configuration of the volume
        Type:
            databricks.datastructures.unitycatalog.VolumeInfo
 
  Returns an empty databricks.datastructures.unitycatalog.VolumeInfo
  if the specified volume cannot be found. In other cases an error is
  thrown.
 
  See Also: databricks.datastructures.unitycatalog.VolumeInfo
```

#### databricks.UnityCatalog.listCatalogs

```text
LISTCATALOGS gets list of catalogs.
 
  Example:
 
    result = uc.listCatalogs();
 
  Outputs:
    result
        Description:
            list of catalogs
        Type:
            databricks.datastructures.unitycatalog.CatalogInfoList
 
  See Also: databricks.datastructures.unitycatalog.CatalogInfoList
```

#### databricks.UnityCatalog.listConnections

```text
listConnections gets list of connections.
 
  Example:
 
    result = uc.listConnections();
 
  Outputs:
    result
        Description:
            list of connections
        Type:
            databricks.datastructures.unitycatalog.Connection
 
  See Also: databricks.datastructures.unitycatalog.Connection
            https://docs.databricks.com/api/workspace/connections/list
```

#### databricks.UnityCatalog.listConnectionsPage

```text
LISTCONNECTIONSPAGE gets list of connections.
 
  Example:
 
    result = uc.listConnectionsPage();
 
  Outputs:
    result
        Description:
            list of catalogs
        Type:
            databricks.datastructures.unitycatalog.ListConnectionsResp
 
  See Also: databricks.datastructures.unitycatalog.ListConnectionsResp
            https://docs.databricks.com/api/workspace/connections/list
```

#### databricks.UnityCatalog.listExternalLocations

```text
LISTEXTERNALLOCATIONS gets list of external locations.
 
  Example:
 
    result = uc.listExternalLocations();
 
  Outputs:
    result
        Description:
            list of external locations
        Type:
            databricks.datastructures.unitycatalog.ExternalLocationInfoList
 
  See Also: databricks.datastructures.unitycatalog.ExternalLocationInfoList
```

#### databricks.UnityCatalog.listFiles

```text
LISTFILES list files in an external URL.
 
  Example:
 
    result = uc.listFiles(url);
    result = uc.listFiles(url,'max_results',10);
 
  Required Inputs:
    url  
        Description:
            URL of the external location. Note: not the name of an
            external location in Unity Catalog but the actual URL of
            where the data exists externally. If a corresponding
            external location exists in the catalog, its credentials
            are used. Alternatively, refer to other storage credentials
            in the catalog through credential_name Name-Value pair.
        Type:
            string
 
  Optional Inputs Provided as Name-Value Pairs:
    'credential_name'
        Description:
           Name of Storage Credential to use for accessing the URL.
        Type:
            string
    'max_results'
        Description:
            Limit on number of results to return
        Type:
            int32
 
  Outputs:
    result  
        Description:
            list of files
        Type:
            databricks.datastructures.unitycatalog.ListFilesResp
 
  Throws an error if the specified URL cannot be accessed.
 
  See Also: databricks.datastructures.unitycatalog.ListFilesResp
```

#### databricks.UnityCatalog.listMetastores

```text
LISTMETASTORES lists metastores.
 
  Example:
 
    result = uc.listMetastores();
 
  Outputs:
    result  
        Description:
            list of metastores
        Type:
            databricks.datastructures.unitycatalog.MetastoreInfoList
 
  See Also: databricks.datastructures.unitycatalog.MetastoreInfoList
```

#### databricks.UnityCatalog.listProviderShares

```text
LISTPROVIDERSHARES lists delta sharing shares for a given provider.
 
  Example:
 
    result = uc.listProviderShares(name);
 
  Required Inputs:
    name
        Description:
            Provider name
        Type:
            string
 
  Outputs:
    result
        Description:
            list of shares
        Type:
            databricks.datastructures.unitycatalog.ProviderShareList
 
  See Also: databricks.datastructures.unitycatalog.ProviderShareList
```

#### databricks.UnityCatalog.listProviders

```text
LISTPROVIDERS lists delta sharing providers.
 
  Example:
 
    result = uc.listProviders();
 
  Outputs:
    result
        Description:
            list of providers
        Type:
            databricks.datastructures.unitycatalog.ProviderInfoList
 
  See Also: databricks.datastructures.unitycatalog.ProviderInfoList
```

#### databricks.UnityCatalog.listRecipients

```text
LISTRECIPIENTS lists delta sharing recipients.
 
  Example:
 
    result = uc.listRecipients();
 
  Outputs:
    result
        Description:
            list of recipients
        Type:
            databricks.datastructures.unitycatalog.RecipientInfoList
 
  See Also: databricks.datastructures.unitycatalog.RecipientInfoList
```

#### databricks.UnityCatalog.listSchemas

```text
LISTSCHEMAS lists schemas in a given catalog.
 
  Example:
 
    result = uc.listSchemas(catalog_name);
 
  Required Inputs:
    catalog_name  
        Description:
            Catalog name
        Type:
            string
 
  Outputs:
    result  
        Description:
            list of schemas
        Type:
            databricks.datastructures.unitycatalog.SchemaInfoList
 
  See Also: databricks.datastructures.unitycatalog.SchemaInfoList
```

#### databricks.UnityCatalog.listShares

```text
LISTSHARES lists delta sharing shares.
 
  Example:
 
    result = uc.listShares();
 
  Outputs:
    result  
        Description:
            list of shares
        Type:
            databricks.datastructures.unitycatalog.ShareInfoList
 
  See Also: databricks.datastructures.unitycatalog.ShareInfoList
```

#### databricks.UnityCatalog.listStorageCredentials

```text
LISTSTORAGECREDENTIALS lists storage credentials.
 
  Example:
 
    result = uc.listStorageCredentials();
 
  Outputs:
    result
        Description:
            list of storage credentials
        Type:
            databricks.datastructures.unitycatalog.StorageCredentialInfoList
 
  See Also: databricks.datastructures.unitycatalog.StorageCredentialInfoList
```

#### databricks.UnityCatalog.listTableSummaries

```text
LISTTABLESUMMARIES lists high level table information for tables in a
  given catalog. Allows searching for tables based on schema name
  patterns and table name patterns. 
 
  The output may be paged. listTableSummaries does *not* automatically
  retrieve all pages. Call the method again with a 'page_token'
  Name-Value pair to manually retrieve the pages as desired.
 
  Example:
 
    result = uc.listTableSummaries(catalog_name);    
    result = uc.listTableSummaries(catalog_name,'table_name_pattern','SomePat%');        
 
  Required Inputs:
    catalog_name  
        Description:
            Name of the catalog
        Type:
            string
 
  Optional Inputs Provided as Name-Value Pairs:
    'schema_name_pattern'
        Description:
           SQL LIKE style pattern to search for tables based on
           (partial) schema name.
        Type:
            string
    'table_name_pattern'
        Description:
           SQL LIKE style pattern to search for tables based on
           (partial) table name.
        Type:
            string
    'max_results'
        Description:
            Limit on number of results to return
        Type:
            int32
    'page_token'
        Description:
            Page token. If a previous output of listTableSummaries
            contained a next_page_token, this next_page_token can be
            provided here as page_token to retrieve the next page of
            results.
        Type:
            string
 
  Outputs:
    result  
        Description:
            list of tables
        Type:
            databricks.datastructures.unitycatalog.TableSummariesResp
 
  See Also: databricks.datastructures.unitycatalog.TableSummariesResp
```

#### databricks.UnityCatalog.listTables

```text
LISTTABLES lists tables in a given catalog and schema.
 
  Example:
 
    result = uc.listTables(catalog_name,schema_name);
 
  Required Inputs:
    catalog_name  
        Description:
            Catalog name
        Type:
            string
    schema_name  
        Description:
            Schema name
        Type:
            string
 
  Outputs:
    result  
        Description:
            list of tables
        Type:
            databricks.datastructures.unitycatalog.TableInfoList
 
  See Also: databricks.datastructures.unitycatalog.TableInfoList
```

#### databricks.UnityCatalog.listVolumes

```text
LISTVOLUMES lists volumes for the current metastore under the parent catalog and schema.
 
  Example:
 
    result = uc.listVolumes('main', 'default');
 
  Required Inputs:
    'catalog_name'
        Description:
            The identifier of the catalog
        Type:
            string
    'schema_name'
        Description:
            The identifier of the schema
        Type:
            string
 
  Optional Inputs Provided as Name-Value Pairs:
    'page_token'
        Description:
           Opaque token returned by a previous request. It must be
           included in the request to retrieve the next page of results
           (pagination).
        Type:
            string
    'max_results'
        Description:
            Limit on number of results to return
        Type:
            int32
    'include_browse'
        Description:
            Whether to include volumes in the response for which the principal
            can only access selective metadata for
        Type:
            logical
 
  Outputs:
    result  
        Description:
            list of volumes
        Type:
            databricks.datastructures.unitycatalog.ListVolumesResp
 
  See Also: databricks.datastructures.unitycatalog.ListVolumesResp
```

#### databricks.UnityCatalog.metastoreSummary

```text
METASTORESUMMARY Gets information about a metastore.
 
  Example:
 
    result = uc.metastoreSummary();
 
  Outputs:
    result
        Description:
            Summary of metastore information
        Type:
            databricks.datastructures.unitycatalog.MetastoreInfo
 
  See Also: databricks.datastructures.unitycatalog.MetastoreInfo
```

#### databricks.UnityCatalog.rotateRecipientToken

```text
ROTATERECIPIENTTOKEN rotates the token for an external delta sharing recipient.
  (TOKEN not DATABRICKS based)
 
  Example:
 
    result = uc.rotateRecipientToken(name, rotaterecipienttoken);
 
  Required Inputs:
    name
        Description:
            name of recipient
        Type:
            string
    rotaterecipienttoken
        Description:
            Specifies when the previous token expires. This can make
            the token expire sooner not move its expiry further into
            the future. Set existing_token_expire_in_seconds to 0 to
            expire immediately.
        Type:
            databricks.datastructures.unitycatalog.RotateRecipientToken
        Required Properties in the data structure which must be set:
            existing_token_expire_in_seconds
 
  Outputs:
    result
        Description:
            updated recipient information
        Type:
            databricks.datastructures.unitycatalog.RecipientInfo
 
  See Also: databricks.datastructures.unitycatalog.RotateRecipientToken,
            databricks.datastructures.unitycatalog.RecipientInfo
```

#### databricks.UnityCatalog.setArtifactAllowlist

```text
setArtifactAllowlist Set the artifact allowlist of a certain artifact type
  The whole artifact allowlist is replaced with the new allowlist.
  The caller must be a metastore admin or have the MANAGE ALLOWLIST
  privilege on the metastore.
 
  Example:
 
    uc = databricks.UnityCatalog;
    matcher = databricks.datastructures.unitycatalog.ArtifactMatchers;
    matcher.artifact = "/Volumes/main/default/myvolume/myDir/runtime_install.sh";
    matcher.match_type = "PREFIX_MATCH";
    alr = databricks.datastructures.unitycatalog.AllowlistRequest;
    alr.artifact_matchers = matcher
    artifact_type = databricks.datastructures.unitycatalog.ArtifactType.INIT_SCRIPT;
    setResult = uc.setArtifactAllowlist(artifact_type, alr)
 
  Required Inputs:
    artifact_type
        Description:
            The artifact type of the allowlist
        Type:
            databricks.datastructures.unitycatalog.ArtifactType
    allowlistRequest
        Description:
            A list of allowed artifact match patterns
        Type:
            databricks.datastructures.unitycatalog.AllowlistRequest
        Required Properties in the data structure which must be set:
            artifact_matchers
 
  Outputs:
    result  
        Description:
            List of the matching type of configured allow lists
        Type:
            databricks.datastructures.unitycatalog.SetArtifactAllowlistResp
 
  See Also: databricks.datastructures.unitycatalog.SetArtifactAllowlistResp
```

#### databricks.UnityCatalog.updateCatalog

```text
UPDATECATALOG updates catalog settings.
 
  Only the values which are actually set in the data structure will be
  updated. To not update/change a value leave the property entirely
  empty in the data structure.
 
  Example:
 
    result = uc.updateCatalog(name, cataloginfo);
 
  Required Inputs:
    name
        Description:
            (current) name of catalog
        Type:
            string
    cataloginfo
        Description:
            Information to update
        Type:
            databricks.datastructures.unitycatalog.CatalogInfo
        Optional Properties in the data structure which can be updated:
            name
            comment
            ucproperties
            owner
 
  Outputs:
    result
        Description:
            updated catalog settings/configuration
        Type:
            databricks.datastructures.unitycatalog.CatalogInfo
 
  See Also: databricks.datastructures.unitycatalog.CatalogInfo
```

#### databricks.UnityCatalog.updateConnection

```text
UPDATECONNECTION updates catalog settings.
 
  Only the values which are actually set in the data structure will be
  updated. To not update/change a value leave the property entirely
  empty in the data structure.
 
  Examples:
    result = uc.updateConnection(name, updateConnection);
 
    connectionUpdateRequest = databricks.datastructures.unitycatalog.ConnectionUpdateRequest();
    connectionUpdateRequest.new_name = "my_new_connection_name";
    connectionUpdateRequest.options = JSONMapperMap("host", "https://new.example.com", "bearer_token", "abcdefgh");
    result = uc.updateConnection("my_connection", connectionUpdateRequest);
 
  Required Inputs:
    name
        Description:
            (current) name of connection
        Type:
            string
    connectionUpdateRequest
        Description:
            Information to update
        Type:
            databricks.datastructures.unitycatalog.ConnectionUpdateRequest
        Required Properties
            options
        Optional Properties in the data structure which can be updated:
            new_name
            options
            owner
 
  Outputs:
    result
        Description:
            updated connection settings/configuration
        Type:
            databricks.datastructures.unitycatalog.Connection
 
  See Also: databricks.datastructures.unitycatalog.Connection
            https://docs.databricks.com/api/workspace/connections/update
```

#### databricks.UnityCatalog.updateExternalLocation

```text
UPDATEEXTERNALLOCATION updates external location settings.
 
  Only the values which are actually set in the data structure will be
  updated. To not update/change a value leave the property entirely
  empty in the data structure.
 
  Example:
 
    result = uc.updateExternalLocation(name, externallocationinfo);
 
  Required Inputs:
    name
        Description:
            (current) name of external location
        Type:
            string
    externallocationinfo
        Description:
            Information to update
        Type:
            databricks.datastructures.unitycatalog.ExternalLocationInfo
        Optional Properties in the data structure which can be updated:
            name
            comment
            owner
            url
            credential_name
            read_only
            force
            skip_validation
 
  Outputs:
    result
        Description:
            updated external location settings/configuration
        Type:
            databricks.datastructures.unitycatalog.ExternalLocationInfo
 
  See Also: databricks.datastructures.unitycatalog.ExternalLocationInfo
```

#### databricks.UnityCatalog.updateMetastore

```text
UPDATEMETASTORE updates metastore settings.
 
  Only the values which are actually set in the data structure will be
  updated. To not update/change a value leave the property entirely
  empty in the data structure.
 
  Example:
 
    result = uc.updateMetastore(id, metastoreinfo);
 
  Required Inputs:
    name  
        Description:
            (current) name of metastore
        Type:
            string
    metastoreinfo
        Description:
            Information to update
        Type:
            databricks.datastructures.unitycatalog.MetastoreInfo
        Optional Properties in the data structure which can be updated:
            name
            storage_root_credential_id
            owner
            delta_sharing_scope
            delta_sharing_recipient_token_lifetime_in_seconds
            delta_sharing_organization_name
            privilege_model_version
 
  Outputs:
    result
        Description:
            updated metastore settings/configuration
        Type:
            databricks.datastructures.unitycatalog.MetastoreInfo
 
  See Also: databricks.datastructures.unitycatalog.MetastoreInfo
```

#### databricks.UnityCatalog.updateMetastoreAssignment

```text
UPDATEMETASTOREASSIGNMENT updates metastore assignment on a given workspace
 
  Only the values which are actually set in the data structure will be
  updated. To not update/change a value leave the property entirely
  empty in the data structure.
 
  Example:
 
    result = uc.updateMetastoreAssignment(workspace_id, metastoreassignment);
 
  Required Inputs:
    workspace_id
        workspace_id:
            id of the workspace
        Type:
            int64
    metastoreassignment
        Description:
            Information to update
        Type:
            databricks.datastructures.unitycatalog.MetastoreAssignment
        Optional Properties in the data structure which can be updated:
            metastore_id
            default_catalog_name
 
  Outputs:
    result
        Description:
            updated metastore settings/configuration
        Type:
            databricks.datastructures.unitycatalog.MetastoreAssignment
 
  See Also: databricks.datastructures.unitycatalog.MetastoreAssignment
```

#### databricks.UnityCatalog.updatePermissions

```text
UPDATEPERMISSIONS updates permissions on a given object.
 
  The changes are specified through a PermissionsDiff object which has 
  a changes property. changes in turn has an add and remove property,
  use these to indeed add or remove permissions. UPDATEPERMISSIONS does 
  not fully overwrite/replace existing permissions it really adds and 
  removes the specified permissions to/from the existing ones.
 
  Example:
 
    result = uc.updatePermissions(sec_type, sec_full_name, permissionsdiff);
 
  Required Inputs:
    sec_type
        Description:
            Type of object to retrieve permissions for
        Type:
            string
        Allowed Values:
            "metastore","catalog","schema","table",
            "storage-credential","external-location","view","function"
    sec_full_name  
        Description:
            full name of the object to retrieve permissions for
        Type:
            string
    permissionsdiff
        Description:
            Information to update
        Type:
            databricks.datastructures.unitycatalog.PermissionsDiff
 
  Outputs:
    result
        Description:
            updated permissions
        Type:
            databricks.datastructures.unitycatalog.PermissionsList
 
  See Also: databricks.datastructures.unitycatalog.PermissionsDiff,
            databricks.datastructures.unitycatalog.PermissionsList
```

#### databricks.UnityCatalog.updateProvider

```text
UPDATEPROVIDER updates delta sharing provider settings.
 
  Only the values which are actually set in the data structure will be
  updated. To not update/change a value leave the property entirely
  empty in the data structure.
 
  Example:
 
    result = uc.updateProvider(name, providerinfo);
 
  Required Inputs:
    name
        Description:
            (current) name of provider
        Type:
            string
    providerinfo
        Description:
            Information to update
        Type:
            databricks.datastructures.unitycatalog.ProviderInfo
        Optional Properties in the data structure which can be updated:
            name
            comment
            owner
            recipient_profile_str
 
  Outputs:
    result
        Description:
            updated provider settings/configuration
        Type:
            databricks.datastructures.unitycatalog.ProviderInfo
 
  See Also: databricks.datastructures.unitycatalog.ProviderInfo
```

#### databricks.UnityCatalog.updateRecipient

```text
UPDATERECIPIENT updates delta sharing recipient settings.
 
  Only the values which are actually set in the data structure will be
  updated. To not update/change a value leave the property entirely
  empty in the data structure.
 
  Example:
 
    result = uc.updateRecipient(name, recipientinfo);
 
  Required Inputs:
    name  
        Description:
            (current) name of recipient
        Type:
            string
    recipientinfo
        Description:
            Information to update
        Type:
            databricks.datastructures.unitycatalog.RecipientInfo
        Optional Properties in the data structure which can be updated:
            name
            comment
            owner
            ip_access_list
 
  Outputs:
    result
        Description:
            updated recipient settings/configuration
        Type:
            databricks.datastructures.unitycatalog.RecipientInfo
 
  See Also: databricks.datastructures.unitycatalog.RecipientInfo
```

#### databricks.UnityCatalog.updateSchema

```text
UPDATESCHEMA updates schema settings.
 
  Only the values which are actually set in the data structure will be
  updated. To not update/change a value leave the property entirely
  empty in the data structure.
 
  Example:
 
    result = uc.updateSchema(name, schemainfo);
 
  Required Inputs:
    name
        Description:
            (current) name of schema
        Type:
            string
    schemainfo
        Description:
            Information to update
        Type:
            databricks.datastructures.unitycatalog.SchemaInfo
        Optional Properties in the data structure which can be updated:
            name
            comment
            owner
            ucproperties
 
  Outputs:
    result
        Description:
            updated schema settings/configuration
        Type:
            databricks.datastructures.unitycatalog.SchemaInfo
 
  See Also: databricks.datastructures.unitycatalog.SchemaInfo
```

#### databricks.UnityCatalog.updateShare

```text
UPDATESHARE updates delta sharing share settings.
 
  Only the values which are actually set in the data structure will be
  updated. To not update/change a value leave the property entirely
  empty in the data structure.
 
  Objects cannot be updated with this method, use updateShareObjects
  for this instead.
 
  Example:
 
    result = uc.updateShare(name, shareinfo);
 
  Required Inputs:
    name
        Description:
            (current) name of share
        Type:
            string
    shareinfo
        Description:
            Information to update
        Type:
            databricks.datastructures.unitycatalog.ShareInfo
        Optional Properties in the data structure which can be updated:
            name
            comment
            owner
 
  Outputs:
    result
        Description:
            updated share settings/configuration
        Type:
            databricks.datastructures.unitycatalog.ShareInfo
 
  See Also: databricks.datastructures.unitycatalog.ShareInfo,
            updateShareObjects
```

#### databricks.UnityCatalog.updateShareObjects

```text
UPDATESHAREOBJECTS updates objects on a given delta sharing share.
 
  The changes are specified through a ObjectsDiff object which has an
  updates property. updates is an array of ObjectsChange objects. In
  each ObjectsChange object you specify the action, ADD or REMOVE to
  add or remove an object respectively and provide a data_object which
  describes the actual object to share. UPDATESHARE does not fully
  overwrite/replace existing objects, it really adds and removes the
  specified objects to/from a share.
 
  Example:
 
    result = uc.updateShareObjects(name, shareinfo);
 
  Required Inputs:
    name  
        Description:
            name of the share
        Type:
            string
    shareinfo
        Description:
            Information to update
        Type:
            databricks.datastructures.unitycatalog.ObjectsDiff
    
  Outputs:
    result  
        Description:
            updated permissions
        Type:
            databricks.datastructures.unitycatalog.ShareInfo
 
  See Also: databricks.datastructures.unitycatalog.ObjectsDiff,
            databricks.datastructures.unitycatalog.ShareInfo
```

#### databricks.UnityCatalog.updateSharePermissions

```text
UPDATESHAREPERMISSIONS updates permissions on a delta sharing share.
 
  The changes are specified through a PermissionsDiff object which has
  a changes property. changes in turn has an add and remove property,
  use these to indeed add or remove permissions. UPDATESHAREPERMISSIONS
  does not fully overwrite/replace existing permissions it really adds
  and removes the specified permissions to/from the existing ones.
 
  Example:
 
    result = updateSharePermissions(name, permissionsdiff);
 
  Required Inputs:
    name
        Description:
            share name
        Type:
            string
    permissionsdiff
        Description:
            Information to update
        Type:
            databricks.datastructures.unitycatalog.PermissionsDiff
    
  Outputs:
    result
        Description:
            updated permissions
        Type:
            databricks.datastructures.unitycatalog.PermissionsList
 
  See Also: databricks.datastructures.unitycatalog.PermissionsDiff,
            databricks.datastructures.unitycatalog.PermissionsList
```

#### databricks.UnityCatalog.updateStorageCredential

```text
UPDATESTORAGECREDENTIAL updates store credential settings.
 
  Only the values which are actually set in the data structure will be
  updated. To not update/change a value leave the property entirely
  empty in the data structure.
 
  Example:
 
    result = uc.updateStorageCredential(name, storagecredentialinfo);
 
  Required Inputs:
    name
        Description:
            (current) name of storage credential
        Type:
            string
    storagecredentialinfo
        Description:
            Information to update
        Type:
            databricks.datastructures.unitycatalog.StorageCredentialInfo
        Optional Properties in the data structure which can be updated:
            name
            comment
            skip_validation
            owner
            aws_iam_role
            azure_service_principal
            gcp_service_account_key
 
  Outputs:
    result
        Description:
            updated storage credential settings/configuration
        Type:
            databricks.datastructures.unitycatalog.StorageCredentialInfo
 
  See Also: databricks.datastructures.unitycatalog.StorageCredentialInfo
```

#### databricks.UnityCatalog.updateVolume

```text
UPDATEVOLUME updates volume settings.
 
  Updates the specified volume under the specified parent catalog and
  schema. The caller must be a metastore admin or an owner of the volume.
  For the latter case, the caller must also be the owner or have the
  USE_CATALOG privilege on the parent catalog and the USE_SCHEMA privilege
  on the parent schema. Currently only the name, the owner or the comment
  of the volume could be updated.
 
  Example:
 
    result = uc.updateVolume(name, volumeInfo);
 
  Required Inputs:
    name
        Description:
            The three-level (fully qualified) current name of the volume
            e.g.: "main.default.my_volume"
        Type:
            string
 
    volumeInfo
        Description:
            Information to update
        Type:
            databricks.datastructures.unitycatalog.VolumeInfo
        Optional Properties in the data structure which can be updated:
            name
            comment
            owner
 
  Outputs:
    result
        Description:
            Updated volume settings/configuration
        Type:
            databricks.datastructures.unitycatalog.VolumeInfo
 
  See Also: databricks.datastructures.unitycatalog.VolumeInfo,
            updateShareObjects
```

### databricks.Workspace

Superclass: databricks.Object

```text
WORKSPACE Databricks interface to manipulate Workspaces
  Interface to connect to Databricks Workspaces via the
  databricks 2.0 REST API. Please see the documentation at:
  https://docs.databricks.com/api/latest/index.html
 
  For example:
 
    % Create a Databricks Workspace
    ws = databricks.Workspace();
```

#### databricks.Workspace.Workspace

```text
WORKSPACE Databricks interface to manipulate Workspaces
  Interface to connect to Databricks Workspaces via the
  databricks 2.0 REST API. Please see the documentation at:
  https://docs.databricks.com/api/latest/index.html
 
  For example:
 
    % Create a Databricks Workspace
    ws = databricks.Workspace();

    Documentation for databricks.Workspace
```

#### databricks.Workspace.delete

```text
DELETE Delete an object or a directory
  Delete an object or a directory (and optionally recursively deletes
  all objects in the directory). If path does not exist errors with
  RESOURCE_DOES_NOT_EXIST. If path is a non-empty directory and
  logical recursive argument is set to false errors with
  DIRECTORY_NOT_EMPTY. Object deletion cannot be undone and deleting
  a directory recursively is not atomic.
 
  Example
     ws = databricks.Workspace();
     path = '/Users/joe@example.com/myproject';
     recurse = true;
     ws.delete(path, recurse)
```

#### databricks.Workspace.directoryExists

```text
DIRECTORYEXISTS Checks if a Workspace directory exists
  Returns logical true is a directory exists otherwise false.
```

#### databricks.Workspace.export

```text
EXPORT Export a notebook or contents of an entire directory
  If path does not exist, errors with RESOURCE_DOES_NOT_EXIST. A directory can
  only be exported in DBC format. If the exported data exceeds the size
  limit, errors with MAX_NOTEBOOK_SIZE_EXCEEDED. Exporting a library is not
  supported. 
 
  Example:
    ws = databricks.Workspace;
    result = ws.export('/Users/joe@example.com/myPythonWS', 'SOURCE', false);
    result.content
    ans =
      '# Databricks notebook source
       print("Hello World")'
```

#### databricks.Workspace.fileExists

```text
FILEEXISTS Checks if a Workspace file exists
  Returns logical true is a file exists otherwise false.
 
  Example:
    ws = databricks.Workspace();
    ws.fileExists("/Workspace/Users/joe@example.com/mydirectorymyfile.txt");
```

#### databricks.Workspace.getStatus

```text
GETSTATUS Gets the status of an object or a directory
  If path does not exist it errors with RESOURCE_DOES_NOT_EXIST.
  Returns a struct on on success.
  The returned value may or may not contain a create_at and modified_at
  time stamp.
 
  Example:
    ws = databricks.Workspace;
    p = '/Users/joe@example.com/my-workspace-directory';
    status = ws.getStatus(p)
      status =
      struct with fields:
        object_type: 'DIRECTORY'
               path: '/Users/joe@example.com/my-workspace-directory'
          object_id: 3325061472565282
```

#### databricks.Workspace.import

```text
IMPORT Import a file into /Workspace
  
  Required named arguments:
        path: The absolute path of the notebook or directory. Importing
              directory is only supported for DBC format. This field is required.
 
    language: If format is set to SOURCE, this field is required, otherwise it
              will be ignored. Valid values are SCALA, PYTHON, SQL or R
              This argument is case sensitive.
 
     content: Notebook content. This value has a size limit of 10MB. If the limit
              is exceeded an error is thrown. It will be base-64 encoded by this
              method. It should be scalar text.
 
        file: If content is not set then a local file path for upload must be
              provided. The maximum supported file size is 500MB.
 
  Only one of file and content should be set at a time.
 
  Optional named arguments:
      format: Specifies the format of the file to be imported.
              It may be one of: SOURCE, HTML, JUPYTER, DBC, R_MARKDOWN, AUTO or RAW.
              The default value is SOURCE.
              Using AUTO is often preferable to SOURCE.
              This argument is case sensitive.
 
 
   overwrite: Logical that specifies whether to overwrite an existing object.
              For DBC format, overwrite is not supported since it may contain
              a directory. The default value is false. If path already exists
              and overwrite is set to false, this call errors with
              RESOURCE_ALREADY_EXISTS.
 
 
  A non empty databricks.datastructures.ErrorResponse errorResponse indicates
  an error.
 
  A logical true result indicates successful completion otherwise false is
  expected.
 
 
  Example
     % Import a string to a notebook
     ws = databricks.Workspace;
     [result, errorResponse] = ws.import('path', '/Users/joe@example.com/myPythonWS', ...
               'format', 'SOURCE', 'language', 'PYTHON', ...
               'content', 'print("Hello World")', 'overwrite', true);
 
     % Import a local file to a notebook
     ws = databricks.Workspace;
     [result, errorResponse] = ws.import('path', '/Users/joe@example.com/myNotebook', ...
               'format', 'SOURCE', 'language', 'PYTHON', ...
               'file', '/myPath/myFile.py', 'overwrite', true);
```

#### databricks.Workspace.list

```text
LIST Lists contents of Databricks workspace directory or object.
 
  Returns a cell array of object structs on on success.
  If no objects are defined an empty cell array is returned.
 
  If no argument is required a top level listing for the current user is
  returned equivalent to ws.list('/Users/user@example.com/')
  The username is configured in the databricks-settings.json file
 
  Example:
    ws = databricks.Workspace;
    wsArray = ws.list('/Users/user@example.com/')
    wsArray = 
      1x65 ObjectInfo array with properties:
        object_type
        object_id
        path
        language
 
    % Examine object of type NOTEBOOK
    wsArray(1)
    ans =
      ObjectInfo with properties:
        object_type: NOTEBOOK
        object_id: 203885482887083
        path: "/Users/user@example.com/myNotebook"
        language: "PYTHON"
 
    % Examine object of type DIRECTORY
    wsArray(4)
    ans =
    struct with fields:
      object_type: 'DIRECTORY'
             path: '/Users/user@example.com/my-workspace-directory'
        object_id: 3325061472565282
```

#### databricks.Workspace.ls

```text
LS Lists contents of Databricks workspace directory or object as table.
 
  Returns a the result of Workspace/list as a table.
 
  Example:
  W = databricks.Workspace
  T = W.ls()
  T =
    22x4 table
         Type                                  Path                                   ObjectID        Language
      ___________    _________________________________________________________    ________________    ________
      "NOTEBOOK"     "/Users/someone@example.com/mapMATLABFunctions"              21340560191488      "SCALA"
      "NOTEBOOK"     "/Users/someone@example.com/testing_wheel_21b"               81214135215911      "PYTHON"
      "DIRECTORY"    "/Users/someone@example.com/Simulink"                        243123252753716     ""
           :                                     :                                        :               :
```

#### databricks.Workspace.mkdirs

```text
MKDIRS Create a directory and necessary parent directories
  Create a directory and necessary parent directories if they do not exist.
  If there exists an object (not a directory) at any prefix of the input
  Errors with RESOURCE_ALREADY_EXISTS. If this operation fails it may have
  succeeded in creating some of the necessary parent directories.
 
  Before creating a directory, the status will be checked. If this path
  is already a directory, it will not be `re-created'.
 
  Example
     ws = databricks.Workspace;
     pathArg = '/Users/joe@example.com/myproject';
     tf = ws.mkdirs(pathArg);
 
   Adding verbose option will produce some output
 
     ws.mkdirs(pathArg, verbose=true);
```

### databricks.Zerobus

Superclass: databricks.Object

```text
Zerobus REST API client
  Only JSON payloads are currently supported.
 
  Required Named Arguments:
         catalog - Databricks catalog name
          schema - Databricks schema name
           table - Databricks table name
        clientId - Service principal OAuth client ID
    clientSecret - Service principal OAuth client secret
 
  Optional Named Arguments:
        endpoint - Override for the ingest endpoint URL
     profileName - Name of the Databricks configuration profile
         verbose - Display verbose output (default: true)
 
  Example:
    % First create a table created in this case using SQL in a Notebook
    %sql
    CREATE TABLE main.default.air_quality (device_name STRING, temp INT, humidity LONG);
    
    % Create a service principal and enable permissions for the table.
    % See: databricks Documentation linked below.
 
    % Create a Zerobus object that will authenticate as the service principal.
    % All of the named arguments shown are required.
    z = databricks.Zerobus(catalog="main", schema="default", table="air_quality", clientId="a<REDACTED>1", clientSecret="d<REDACTED>5")
 
    % Create a JSON payload array of 2 sets values, corresponding to 2 table rows
    payload = ['[{ "device_name": "device_num_1", "temp": 28, "humidity": 60 },', newline ...
                '{ "device_name": "device_num_2", "temp": 25, "humidity": 55 }]'];
 
    % Insert the data into the table
    [result, errorResponse] = z.insert(payload);
 
  See also:
    https://www.databricks.com/product/data-engineering/lakeflow-connect/zerobus-ingest
    https://docs.databricks.com/aws/en/ingestion/zerobus-ingest?language=REST%C2%A0API
```

#### databricks.Zerobus.Zerobus

```text
Zerobus REST API client
  Only JSON payloads are currently supported.
 
  Required Named Arguments:
         catalog - Databricks catalog name
          schema - Databricks schema name
           table - Databricks table name
        clientId - Service principal OAuth client ID
    clientSecret - Service principal OAuth client secret
 
  Optional Named Arguments:
        endpoint - Override for the ingest endpoint URL
     profileName - Name of the Databricks configuration profile
         verbose - Display verbose output (default: true)
 
  Example:
    % First create a table created in this case using SQL in a Notebook
    %sql
    CREATE TABLE main.default.air_quality (device_name STRING, temp INT, humidity LONG);
    
    % Create a service principal and enable permissions for the table.
    % See: databricks Documentation linked below.
 
    % Create a Zerobus object that will authenticate as the service principal.
    % All of the named arguments shown are required.
    z = databricks.Zerobus(catalog="main", schema="default", table="air_quality", clientId="a<REDACTED>1", clientSecret="d<REDACTED>5")
 
    % Create a JSON payload array of 2 sets values, corresponding to 2 table rows
    payload = ['[{ "device_name": "device_num_1", "temp": 28, "humidity": 60 },', newline ...
                '{ "device_name": "device_num_2", "temp": 25, "humidity": 55 }]'];
 
    % Insert the data into the table
    [result, errorResponse] = z.insert(payload);
 
  See also:
    https://www.databricks.com/product/data-engineering/lakeflow-connect/zerobus-ingest
    https://docs.databricks.com/aws/en/ingestion/zerobus-ingest?language=REST%C2%A0API

    Documentation for databricks.Zerobus
```

#### databricks.Zerobus.getAccessToken

```text
databricks.Zerobus/getAccessToken is a function.
    accessToken = getAccessToken(obj, catalog, schema, table, clientId, clientSecret)
    accessToken = getAccessToken(___, Name, Value)
    [accessToken, expiryTime] = getAccessToken(___)
    [accessToken, expiryTime, errorResponse] = getAccessToken(___)
```

#### databricks.Zerobus.insert

```text
insert inserts a payload into the catalog.schema.table defined in the Zerobus object
  Currently only JSON payloads are supported.
 
  Example:
    % First create a table created in this case using SQL in a Notebook
    %sql
    CREATE TABLE main.default.air_quality (device_name STRING, temp INT, humidity LONG);
    
    % Create a service principal and enable permissions for the table.
    % See: databricks Documentation linked below.
 
    % Create a Zerobus object that will authenticate as the service principal
    z = databricks.Zerobus(catalog="main", schema="default", table="air_quality", clientId="a<REDACTED>1", clientSecret="d<REDACTED>5")
 
    % Create a JSON payload array of 2 sets values, corresponding to 2 table rows
    payload = ['[{ "device_name": "device_num_1", "temp": 28, "humidity": 60 },', newline ...
                '{ "device_name": "device_num_2", "temp": 25, "humidity": 55 }]'];
 
    % Insert the data into the table
    [result, errorResponse] = z.insert(payload);
 
  See also:
    https://www.databricks.com/product/data-engineering/lakeflow-connect/zerobus-ingest
    https://docs.databricks.com/aws/en/ingestion/zerobus-ingest?language=REST%C2%A0API
```

#### databricks.Zerobus.requireNamedArg

```text
databricks.Zerobus/requireNamedArg is a function.
    requireNamedArg(obj, options, name)
```

### matlab.databricks

### matlab.databricks.cluster

### matlab.databricks.cluster.DesktopClusterConfigurator

Superclasses: handle, matlab.mixin.CustomDisplay

```text
DESKTOPCLUSTERCONFIGURATOR Configures an existing Databricks Cluster Desktop MATLAB
 
  Typically called from: Software\Docker\MATLABDesktop\createMATLABDesktopCluster.m
  Demonstrates the post creation steps necessary to configure a Databricks Cluster
  for MATLAB Desktop usage.
```

#### matlab.databricks.cluster.DesktopClusterConfigurator.DesktopClusterConfigurator

```text
Configure properties with creation arguments

    Documentation for matlab.databricks.cluster.DesktopClusterConfigurator
```

#### matlab.databricks.cluster.DesktopClusterConfigurator.configureCluster

```text
matlab.databricks.cluster.DesktopClusterConfigurator/configureCluster is a function.
    configureCluster(obj)
    configureCluster(___, Name, Value)
```

#### matlab.databricks.cluster.DesktopClusterConfigurator.delete

```text
delete - Delete files or objects

    Syntax
      delete filename
      delete filename1 ... filenameN
      delete(___,ResolveSymbolicLinks=tf)
      delete(obj)

    Input Arguments
      filename - Name of file to delete
        string array | character vector | cell array of character vectors
      obj - Object
        single object | array of objects
      tf - Remove target of symbolic link
        false or 0 (default) | true or 1

    Examples
      openExample('matlab/DeleteFilesInFolderExample')
      openExample('matlab/DeleteGraphicsObjectsExample')

    See also clear, dir, recycle, rmdir, delete

    Introduced in MATLAB before R2006a
    Documentation for delete
       doc delete
```

#### matlab.databricks.cluster.DesktopClusterConfigurator.execPySubcmd

```text
EXECPYSUBCMD Calls executePythonCommand for a largely default set of arguments
  The aim is to provide a more concise function call.
  Hardwired executePythonSubprocess arguments:
         blocking: true
        clusterId: obj.Cluster.cluster_id
        contextId: obj.ExecContext
    retainContext: true
          verbose: false
            shell: true
 
  The command Id is not returned.
  A command can be provided.
```

#### matlab.databricks.cluster.DesktopClusterConfigurator.execPySubproc

```text
EXECPYSUBPROC Calls executePythonSubprocess for a largely default set of arguments
  The aim is to provide a more concise function call.
  Hardwired executePythonSubprocess arguments:
         blocking: true
        clusterId: obj.Cluster.cluster_id
        contextId: obj.ExecContext
    retainContext: true
          verbose: false
            shell: true
 
  The command Id is not returned.
  A command can be provided.
```

#### matlab.databricks.cluster.DesktopClusterConfigurator.getPropertyGroups

```text
matlab.databricks.cluster.DesktopClusterConfigurator/getPropertyGroups is a function.
    groups = getPropertyGroups(obj)
```

#### matlab.databricks.cluster.DesktopClusterConfigurator.refresh

```text
refresh - Redraw current figure

    Syntax
      refresh
      refresh(h)

    Introduced in MATLAB before R2006a
    Documentation for refresh
       doc refresh
```

#### matlab.databricks.cluster.DesktopClusterConfigurator.stopTimerCallBack

```text
matlab.databricks.cluster.DesktopClusterConfigurator/stopTimerCallBack is a function.
    stopTimerCallBack(obj, timerObj, event)
```

### matlab.databricks.cluster.MATLABEnableExistingCluster

```text
MATLABENABLEEXISTINGCLUSTER Updates the configuration of a cluster to support MATLAB
 
  This method uses the databricks.Cluster.edit method to update aspects of
  a cluster's configuration. Calls to edit can *restart* a cluster potentially
  disrupting service for other users, see the Databricks documentation linked
  below for further details
 
  The updates enable the cluster to run deployed MATLAB workloads similarly
  to if the cluster was create using the createDatabricksCluster function.
 
  Supported parameters:
 
    existingCluster : An existing databricks.Cluster object use Cluster.findById
                      or Cluster.findByName to get a cluster object if required.
                      This is a required value.
                      
     initscriptPath : An optional name-value parameter to set a non default
                      init script path.
 
      enableLogging : Set to true to turn on logging of the init scripts
                      including the runtime install. Default is false.
 
             logDir : An optional name-value parameter to set log file destination.
                      The default value is: "dbfs:/cluster_logs"
                      If using /Volumes (Public Preview) additional restrictions apply.
                      See: https://docs.databricks.com/aws/en/compute/configure#compute-log-delivery
 
 
       cluster_name : An optional name-value parameter to set the new name for the
                      cluster, the cluster's ID remains the same.
 
         authMethod : A matlab.databricks.AuthMethod
 
        profileName : A configuration file profileName value
  
  An updated databricks.Cluster object is returned.
 
  For more information see: https://docs.databricks.com/api/workspace/clusters/edit
 
  This function does not currently support enabling an existing cluster to use Docker.
  Only init scripts are supported.
 
  Example:
    existingCluster = databricks.Cluster.findById("0708-093802-38njgrhw"); % Or use findByName()
    updatedCluster = matlab.databricks.cluster.MATLABEnableExistingCluster(existingCluster);
  
  See Also: databricks.Cluster.create
```

### matlab.databricks.cluster.deleteDesktopCluster

```text
DELETEDESKTOPCLUSTER Deletes the current Databricks cluster used for MATLAB Desktop
 
  Warning: unsaved work may be lost!
 
  Requires the MW_CLUSTER_ID environment variable to be set.
  Returns false if the cluster cannot be found or the MATLAB is not on Databricks.
  By default calls finish before deleting the cluster which will not gracefully
  shutdown MATLAB.
 
  Example:
    tf = matlab.databricks.cluster.deleteDesktopCluster()
```

### matlab.databricks.cluster.getClusterMATLABRelease

```text
GETCLUSTERMATLABRELEASE Get the value of the MW_RUNTIME_RELEASE Spark Environment Variable
  The result is returned as a string.
  If the variable is not defined an empty string is returned.
  The required cluster argument can be specified as a scalar text or as a
  databricks.Cluster object.
 
  Example:
    release = matlab.databricks.cluster.getClusterMATLABRelease(cluster=clusterId)
```

### matlab.databricks.cluster.setPyenvForCluster

```text
SETPYENVFORCLUSTER Set a pyenv based on the Spark version of a cluster
  In the case of an error an empty double is returned.
  If successful a matlab.pyclient.PythonEnvironment is returned, this
  should be checked before use.
 
  If a Software/MATLAB/Connect/<Spark version> directory exists it will
  be used, if a configured venv exists therein.
 
  If an exact major.minor match is not found the latest major number match
  will be used if that exists.
 
  The cluster can be provided as a clusterId string/character vector or
  as a databricks.Cluster object. If a cluster value is not provided
  the value in the .databrickscfg file will be used if set.
 
  Example:
    result = matlab.databricks.cluster.setPyenvForCluster(cluster="1006-200022-cv9r8lwc")
    result = 
  PythonEnvironment with properties:
  
          Version: "3.11"
       Executable: "/home/username/databricks/Software/MATLAB/Connect/15.4/venv/bin/python3"
          Library: "/home/username/.pyenv/versions/3.11.10/lib/libpython3.11.so"
             Home: "/home/username/databricks/Software/MATLAB/Connect/15.4/venv"
           Status: NotLoaded
    ExecutionMode: OutOfProcess
```

### matlab.databricks.connect

### matlab.databricks.connect.getDatabricksRuntimePythonVersion

```text
GETDATABRICKSRUNTIMEPYTHONVERSION Gets the Python version used by a Databricks Runtime
 
  Example:
    pyVersion = matlab.databricks.connect.getDatabricksRuntimePythonVersion("16.4.1")
    pyVersion =
       "3.12"
```

### matlab.databricks.connect.getVenvPythonPath

```text
GETVENVPYTHONPATH Get a path to for a python3.x in the corresponding venv
  Searches the Software/MATLAB/Connect/<major>.<minor>/venv directory
  Returns a pythonw.exe path on Windows.
  Returns a python3 path on Linux & macOS.
  Returns and empty string if a Python is not found.
```

### matlab.databricks.connect.setPyenv

```text
SETPYENV Set a pyenv based on a Databricks runtime version, Python path or Cluster
  In the case of an error an empty double is returned.
  If successful a matlab.pyclient.PythonEnvironment is returned, this
  should be checked before use.
 
  If a Software/MATLAB/Connect/<Major version>.<minor version > directory exists, 
  it will be used, provided a configured venv exists therein.
 
  If an exact major & minor match is not found, the latest major number match
  will be used if that exists.
 
  If the current pyenv is InProcess, it cannot be changed with restarting MATLAB.
 
  If neither a version python path or cluster object/id is provided a check is
  made for a preconfigured default clusterId in the configuration file.
 
  Examples:
    result = matlab.databricks.connect.setPyenv();
 
    result = matlab.databricks.connect.setPyenv("cluster","0507-105823-i0lkd9gn");
 
    result = matlab.databricks.connect.setPyenv("pythonPath","/home/someuser/databricks/Software/MATLAB/Connect/15.4/venv/bin/python3");
 
    result = matlab.databricks.connect.setPyenv("version","15.4")
    result = 
  PythonEnvironment with properties:
  
          Version: "3.11"
       Executable: "/home/username/databricks/Software/MATLAB/Connect/15.4/venv/bin/python3"
          Library: "/home/username/.pyenv/versions/3.11.10/lib/libpython3.11.so"
             Home: "/home/username/databricks/Software/MATLAB/Connect/15.4/venv"
           Status: NotLoaded
    ExecutionMode: OutOfProcess
```

### matlab.databricks.demodata

### matlab.databricks.demodata.loadFires

```text
loadFires Helper function to load Databricks demo data
 
  This function assumes the corresponding example dataset is available
  on the Databricks cluster used.
```

### matlab.databricks.demodata.loadNYCTaxiTable

```text
loadNYCTaxiTable Helper function to load Databricks demo data
 
  This function assumes the corresponding example dataset is available
  on the Databricks cluster used.
```

### matlab.databricks.environment

### matlab.databricks.environment.Manager

Superclass: handle

```text
MANAGER Manage files and serialization
```

#### matlab.databricks.environment.Manager.Manager

```text
MANAGER Manage files and serialization

    Documentation for matlab.databricks.environment.Manager
```

#### matlab.databricks.environment.Manager.getPrefDir

```text
matlab.databricks.environment.Manager.getPrefDir is a function.
    pd = getPrefDir
    pd = getPrefDir(Name, Value)
```

#### matlab.databricks.environment.Manager.writePrefs

```text
matlab.databricks.environment.Manager.writePrefs is a function.
    writePrefs
    writePrefs(Name, Value)
```

### matlab.databricks.genie

### matlab.databricks.genie.Conversation

Superclass: handle

```text
genie Conversation helper class
```

#### matlab.databricks.genie.Conversation.Conversation

```text
genie Conversation helper class

    Documentation for matlab.databricks.genie.Conversation
```

#### matlab.databricks.genie.Conversation.delete

```text
Deletes a underlying conversation if an instance is deleted
```

#### matlab.databricks.genie.Conversation.prompt

```text
PROMPT Send a prompt to a conversation
  Note the first prompt to a given conversation is send by the create conversation call
  at the Space level.
```

### matlab.databricks.genie.Genie

Superclasses: handle, matlab.mixin.Scalar

```text
genie Genie helper class
```

#### matlab.databricks.genie.Genie.Genie

```text
genie Genie helper class

    Documentation for matlab.databricks.genie.Genie
```

#### matlab.databricks.genie.Genie.chat

```text
CHAT Initiates a chat session with the user, allowing for prompts and responses.
```

#### matlab.databricks.genie.Genie.cleanupConversation

```text
matlab.databricks.genie.Genie/cleanupConversation is a function.
    cleanupConversation(obj)
    cleanupConversation(___, Name, Value)
```

#### matlab.databricks.genie.Genie.prompt

```text
PROMPT prompt the user for prompts
```

#### matlab.databricks.genie.Genie.saveTable

```text
SAVETABLE Save a table to the base workspace under a given name
```

### matlab.databricks.genie.Message

Superclass: handle

```text
genie Message helper class
```

#### matlab.databricks.genie.Message.Message

```text
genie Message helper class

    Documentation for matlab.databricks.genie.Message
```

#### matlab.databricks.genie.Message.displayMessage

```text
matlab.databricks.genie.Message/displayMessage is a function.
    displayMessage(obj)
```

#### matlab.databricks.genie.Message.showAttachments

```text
matlab.databricks.genie.Message/showAttachments is a function.
    showAttachments(obj)
```

### matlab.databricks.genie.Response

Superclass: handle

```text
genie Response helper class
 
  Deals both with CreateConversationMessageResponse and StartConversationResponse
```

#### matlab.databricks.genie.Response.Response

```text
genie Response helper class
 
  Deals both with CreateConversationMessageResponse and StartConversationResponse

    Documentation for matlab.databricks.genie.Response
```

#### matlab.databricks.genie.Response.containsMessage

```text
CONTAINSMESSAGE Returns true if the response contains non empty Message property
```

#### matlab.databricks.genie.Response.containsQuery

```text
CONTAINSQUERY Returns true if there is a MEssage with a non empty query attachment
```

#### matlab.databricks.genie.Response.containsText

```text
CONTAINSTEXT Returns true if there is a MEssage with a non empty text attachment
```

#### matlab.databricks.genie.Response.executeQuery

```text
EXECUTEQUERY Execute a query
```

#### matlab.databricks.genie.Response.updateMessage

```text
UPDATEMESSAGE Get an updated conversation message
```

#### matlab.databricks.genie.Response.updateQuery

```text
UPDATEQUERY Get an updated query message
```

#### matlab.databricks.genie.Response.updateResponse

```text
UPDATERESPONSE Update a response query if present and otherwise the text
```

#### matlab.databricks.genie.Response.waitForCompletedMessage

```text
WAITFORCOMPLETEDMESSAGE Updates a message until it completes, fails or times out
```

#### matlab.databricks.genie.Response.waitForCompletedQuery

```text
WAITFORCOMPLETEDQUERY Updates a query message until it completes, fails or times out
```

#### matlab.databricks.genie.Response.waitForCompletedResponse

```text
WAITFORCOMPLETEDRESPONSE Wait for a
```

### matlab.databricks.genie.Space

Superclass: handle

```text
genie Space helper class
```

#### matlab.databricks.genie.Space.Space

```text
genie Space helper class

    Documentation for matlab.databricks.genie.Space
```

#### matlab.databricks.genie.Space.delete

```text
delete - Delete files or objects

    Syntax
      delete filename
      delete filename1 ... filenameN
      delete(___,ResolveSymbolicLinks=tf)
      delete(obj)

    Input Arguments
      filename - Name of file to delete
        string array | character vector | cell array of character vectors
      obj - Object
        single object | array of objects
      tf - Remove target of symbolic link
        false or 0 (default) | true or 1

    Examples
      openExample('matlab/DeleteFilesInFolderExample')
      openExample('matlab/DeleteGraphicsObjectsExample')

    See also clear, dir, recycle, rmdir, delete

    Introduced in MATLAB before R2006a
    Documentation for delete
       doc delete
```

#### matlab.databricks.genie.Space.deleteConversation

```text
matlab.databricks.genie.Space/deleteConversation is a function.
    deleteConversation(obj)
    deleteConversation(___, Name, Value)
```

#### matlab.databricks.genie.Space.prompt

```text
Get the initial response which is very likely to not be complete
```

#### matlab.databricks.genie.Space.startConversation

```text
matlab.databricks.genie.Space/startConversation is a function.
    response = startConversation(obj, content)
    response = startConversation(___, Name, Value)
```

### matlab.databricks.genie.StatementResponse

Superclass: handle

```text
genie StatementResponse helper class
```

#### matlab.databricks.genie.StatementResponse.StatementResponse

```text
genie StatementResponse helper class

    Documentation for matlab.databricks.genie.StatementResponse
```

### matlab.databricks.internal

### matlab.databricks.internal.pkgsettings

### matlab.databricks.internal.pkgsettings.getPkgSettings

```text
GETPKGSETTINGS Returns settings relating to the package's internal operation
  This is generally not updated by end users.
  The operation and of this feature and the corresponding settings file is
  subject to change without notice.
 
  Example:
    defaultDatabricksRuntime = matlab.databricks.internal.pkgsettings.getPkgSettings(field="defaultDatabricksRuntime")
 
    allSettings = matlab.databricks.internal.pkgsettings.getPkgSettings
```

### matlab.databricks.internal.pkgsettings.writePkgSettings

```text
WRITEPKGSETTINGS Write a JSON file with package settings
  Build the JSON from a MATLAB struct.
  The JSON file Software/MATLAB/config/package-settings.json
  is the "source of truth" not this file which is just used to bootstrap the
  JSON content during execution.
 
  Example
     matlab.databricks.internal.pkgsettings.writePkgSettings
```

### matlab.databricks.internal.Mltbx

```text
MLTBX Class to help working with and packaging .mltbx files
 
  Examples:
    [result, mltbxFile] = matlab.databricks.internal.Mltbx.build("C:\local\databricks\matlab-databricks-v6.0.3.zip")
 
    [result, mltbxFile] = matlab.databricks.internal.Mltbx.build("C:\git\databricks")
 
    result = matlab.databricks.internal.Mltbx.install("/home/someuser/git/databricks/matlab-databricks-v6.0.5.mltbx")
 
    matlab.databricks.internal.Mltbx.uninstallAll(...)
 
    matlab.databricks.internal.Mltbx.uninstall(version="6.0.3")
 
    T = matlab.databricks.internal.Mltbx.listInstalledVersions()
 
    T = matlab.databricks.internal.Mltbx.listEnabledVersions()
 
    tf = matlab.databricks.internal.Mltbx.isInstalled(...)
 
    tf = matlab.databricks.internal.Mltbx.isEnabled(...)
 
    tf = matlab.databricks.internal.Mltbx.isMoreThanOneEnabled()
 
    matlab.databricks.internal.Mltbx.enableVersion("6.0.3")
 
    matlab.databricks.internal.Mltbx.disableVersion("6.0.3")
 
    matlab.databricks.internal.Mltbx.disableAll(...)
 
    matlab.databricks.internal.Mltbx.disableOtherVersions("6.0.3")
```

#### matlab.databricks.internal.Mltbx.Mltbx

```text
MLTBX Class to help working with and packaging .mltbx files
 
  Examples:
    [result, mltbxFile] = matlab.databricks.internal.Mltbx.build("C:\local\databricks\matlab-databricks-v6.0.3.zip")
 
    [result, mltbxFile] = matlab.databricks.internal.Mltbx.build("C:\git\databricks")
 
    result = matlab.databricks.internal.Mltbx.install("/home/someuser/git/databricks/matlab-databricks-v6.0.5.mltbx")
 
    matlab.databricks.internal.Mltbx.uninstallAll(...)
 
    matlab.databricks.internal.Mltbx.uninstall(version="6.0.3")
 
    T = matlab.databricks.internal.Mltbx.listInstalledVersions()
 
    T = matlab.databricks.internal.Mltbx.listEnabledVersions()
 
    tf = matlab.databricks.internal.Mltbx.isInstalled(...)
 
    tf = matlab.databricks.internal.Mltbx.isEnabled(...)
 
    tf = matlab.databricks.internal.Mltbx.isMoreThanOneEnabled()
 
    matlab.databricks.internal.Mltbx.enableVersion("6.0.3")
 
    matlab.databricks.internal.Mltbx.disableVersion("6.0.3")
 
    matlab.databricks.internal.Mltbx.disableAll(...)
 
    matlab.databricks.internal.Mltbx.disableOtherVersions("6.0.3")

    Documentation for matlab.databricks.internal.Mltbx
```

#### matlab.databricks.internal.Mltbx.build

```text
BUILD Builds a .mltbx package for the MATLAB Interface for Databricks
  A .zip path can be provided or a path to a previously extracted .zip
  file or a currently in use (on the path) Databricks Interface.
  Sources are evaluated in that order.
 
  Optional arguments:
      outputDirectory: Output location for .mltbx file.
                       Default: Current directory.
 
  retainTempDirectory: Delete a temporary working directory if created.
                       Default: false.
 
  Example:
    matlab.databricks.internal.Mltbx.build("C:\local\databricks\matlab-databricks-v6.0.3.zip")
```

#### matlab.databricks.internal.Mltbx.disableAll

```text
matlab.databricks.internal.Mltbx.disableAll is a function.
    disableAll
    disableAll(Name, Value)
```

#### matlab.databricks.internal.Mltbx.disableOtherVersions

```text
matlab.databricks.internal.Mltbx.disableOtherVersions is a function.
    disableOtherVersions(version)
    disableOtherVersions(___, Name, Value)
```

#### matlab.databricks.internal.Mltbx.disableVersion

```text
matlab.databricks.internal.Mltbx.disableVersion is a function.
    disableVersion(version)
    disableVersion(___, Name, Value)
```

#### matlab.databricks.internal.Mltbx.doPackage

```text
matlab.databricks.internal.Mltbx/doPackage is a function.
    tf = doPackage(obj, workDir, outputDir, version)
    [tf, mltbxFile] = doPackage(___)
```

#### matlab.databricks.internal.Mltbx.enableVersion

```text
matlab.databricks.internal.Mltbx.enableVersion is a function.
    enableVersion(version)
    enableVersion(___, Name, Value)
```

#### matlab.databricks.internal.Mltbx.install

```text
INSTALL Alternative installation method to the Addon Manager UI
  Returns true if the package installation completes. Otherwise false,
  including if the package is already installed.
 
  The path to the .mltbx file is provided as an argument.
```

#### matlab.databricks.internal.Mltbx.isEnabled

```text
matlab.databricks.internal.Mltbx.isEnabled is a function.
    tf = isEnabled
    tf = isEnabled(Name, Value)
```

#### matlab.databricks.internal.Mltbx.isInstalled

```text
matlab.databricks.internal.Mltbx.isInstalled is a function.
    tf = isInstalled
    tf = isInstalled(Name, Value)
```

#### matlab.databricks.internal.Mltbx.isMoreThanOneEnabled

```text
matlab.databricks.internal.Mltbx.isMoreThanOneEnabled is a function.
    tf = isMoreThanOneEnabled
    tf = isMoreThanOneEnabled(Name, Value)
```

#### matlab.databricks.internal.Mltbx.listEnabledVersions

```text
matlab.databricks.internal.Mltbx.listEnabledVersions is a function.
    T = matlab.databricks.internal.Mltbx.listEnabledVersions
```

#### matlab.databricks.internal.Mltbx.listInstalledVersions

```text
matlab.databricks.internal.Mltbx.listInstalledVersions is a function.
    T = matlab.databricks.internal.Mltbx.listInstalledVersions
```

#### matlab.databricks.internal.Mltbx.uninstall

```text
UNINSTALL Alternative uninstall method to the Addon Manager UI
  Returns true if the package is uninstalled or is not already
  installed, otherwise false.
```

#### matlab.databricks.internal.Mltbx.uninstallAll

```text
matlab.databricks.internal.Mltbx.uninstallAll is a function.
    uninstallAll
    uninstallAll(Name, Value)
```

#### matlab.databricks.internal.Mltbx.versionLimits

```text
matlab.databricks.internal.Mltbx/versionLimits is a function.
    tf = versionLimits(obj)
```

### matlab.databricks.internal.deployedInputError

```text
DEPLOYEDINPUTERROR Errors if in deployed mode where input will cause an apparent hang
  The default errID is: "DATABRICKS:INPUT"
  The default msg is: "Unexpected interactive input request in deployed mode"
```

### matlab.databricks.internal.docLink

```text
DOCLINK Returns a HTML or Markdown link to a /Documentation file
  In the case of Markdown in deployed mode a path path is returned.
 
  Example:
    link = matlab.databricks.internal.docLink("DBConnect");
```

### matlab.databricks.internal.getMetastoreURL

```text
GETMETASTOREURL Returns the URL to configure a Workspace Metastore
  Can be used to configure allowlists.
  Sample metastore portal url:
    https://adb-1234567890.1.azuredatabricks.net/explore/metastore?o=1234567890
  A matlab.net.URI is returned.
 
  Example:
    metastoreURL = matlab.databricks.internal.getMetastoreURL()
```

### matlab.databricks.internal.htmlLink

```text
HTMLLINK Returns a link to a Documentation/html/<file>.html file
 
  Example:
    link = matlab.databricks.internal.htmlLink("DBConnect")
```

### matlab.databricks.internal.mdLink

```text
MDLINK Returns an edit link to a Documentation/<file>.md file
  In deployed mode a path path is returned.
 
  Example:
    link = matlab.databricks.internal.mdLink("DBConnect")
```

### matlab.databricks.internal.responseError

```text
RESPONSEERROR Handles a HTTP response error
  customErrorMsg is message to provide context from the calling function
```

### matlab.databricks.internal.runParallelTasksJob

```text
runParallelTasksJob Simple interface to run some parallel job.
 
  Imagine a set of N tasks, and a M clusters (and in this example with
  N>M). Let tasks run like this:
 
   CL_1        CL_2        ...     CL_M
   --------------------------------------
   Task_1      Task_2      ...     Task_M
   Task_M+1                        Task_2M
   ...
   Task_N-1    Task_N
 
  Further assume that each task is dependent on the task before, so
  this decides when they can start.
  This function makes it a little easier to start a task like this.
 
  This also supports a use case where instead of a list of tasks, there
  is a matrix of tasks, where each column should run on a specific
  cluster.
```

### matlab.databricks.internal.uploadArtifactsCICD

```text
uploadArtifactsCICD Uploads artifacts as part of build process
```

### matlab.databricks.notebook

### matlab.databricks.notebook.Notebook

Superclass: handle

```text
Notebook - Helper class to create Databricks notebooks
```

#### matlab.databricks.notebook.Notebook.Notebook

```text
Notebook - Helper class to create Databricks notebooks

    Documentation for matlab.databricks.notebook.Notebook
```

#### matlab.databricks.notebook.Notebook.addInstallMavenSection

```text
matlab.databricks.notebook.Notebook/addInstallMavenSection is a function.
    addInstallMavenSection(obj)
    addInstallMavenSection(obj, isTop)
    addInstallMavenSection(obj, isTop, useAPT)
```

#### matlab.databricks.notebook.Notebook.addSectionFromFile

```text
matlab.databricks.notebook.Notebook/addSectionFromFile is a function.
    addSectionFromFile(obj, title, fileName)
    addSectionFromFile(obj, title, fileName, isTop)
```

#### matlab.databricks.notebook.Notebook.addSectionHeader

```text
matlab.databricks.notebook.Notebook/addSectionHeader is a function.
    addSectionHeader(obj, sectionTitle)
    addSectionHeader(obj, sectionTitle, isTop)
```

#### matlab.databricks.notebook.Notebook.addSectionLine

```text
matlab.databricks.notebook.Notebook/addSectionLine is a function.
    addSectionLine(obj, cmdStr)
    addSectionLine(obj, cmdStr, varargin)
```

#### matlab.databricks.notebook.Notebook.addShellSectionHeader

```text
matlab.databricks.notebook.Notebook/addShellSectionHeader is a function.
    addShellSectionHeader(obj, sectionTitle)
    addShellSectionHeader(obj, sectionTitle, isTop)
```

#### matlab.databricks.notebook.Notebook.addShellSectionLine

```text
matlab.databricks.notebook.Notebook/addShellSectionLine is a function.
    addShellSectionLine(obj, cmdStr)
    addShellSectionLine(obj, cmdStr, varargin)
```

#### matlab.databricks.notebook.Notebook.comment

```text
matlab.databricks.notebook.Notebook/comment is a function.
    comment(obj, commentStr)
    comment(obj, commentStr, varargin)
```

#### matlab.databricks.notebook.Notebook.getString

```text
matlab.databricks.notebook.Notebook/getString is a function.
    str = getString(obj)
```

#### matlab.databricks.notebook.Notebook.importNotebookToWorkspace

```text
matlab.databricks.notebook.Notebook/importNotebookToWorkspace is a function.
    importNotebookToWorkspace(obj, wsPath)
    importNotebookToWorkspace(___, Name, Value)
```

#### matlab.databricks.notebook.Notebook.init

```text
matlab.databricks.notebook.Notebook/init is a function.
    init(obj)
```

### matlab.databricks.notebook.NotebookType

```text
NotebookType Enumeration for notebook types in Databricks
```

```text
Enumeration values:
  PYTHON
  SCALA

```

#### matlab.databricks.notebook.NotebookType.NotebookType

```text
NotebookType Enumeration for notebook types in Databricks

    Documentation for matlab.databricks.notebook.NotebookType
```

### matlab.databricks.setup

### matlab.databricks.setup.internal

### matlab.databricks.setup.internal.checkDBCJCP

```text
CHECKDBCJCP Check if there is a legacy Databricks Connect entry on the static class path
```

### matlab.databricks.setup.internal.configureAllowlist

```text
CONFIGUREALLOWLIST Configures the allowlist for javabuilder and the init script
  Assume interactive use.
```

### matlab.databricks.setup.internal.dbcCreateVenv

```text
DBCCREATEVENV Create a Python virtual environment for a given DBC version
 
  Optional arguments:
         pe: Python environment, if not specified the python environment returned
             by pyenv() will be used.
 
    version: Databricks Connect versions to support. A corresponding
             directory is expected in Software/MATLAB/Connect e.g.
             Software/MATLAB/Connect/15.4/
             By default the supported versions in Software/MATLAB/Connect
             are used.
 
    venvDir: Directory containing the virtual environment, the default is:
             Software/MATLAB/Connect/<version>/venv
 
    verbose: Produce additional output. Default is true.
 
  Python is invoked using a system call.
  A logical true is returned on success, otherwise false.
 
  venv or virtualenv is required, venv is preferred.
  pip is required.
 
  Example:
    tf = matlab.databricks.setup.internal.dbcCreateVenv(pe=mypyenv, version="15.4");
```

### matlab.databricks.setup.internal.depthReport

```text
depthReport
```

### matlab.databricks.setup.internal.initScriptMetastoreMsg

```text
INITSCRIPTMETASTOREMSG Shows a message and link to update the allowlist
 
  Example:
    matlab.databricks.setup.internal.initScriptMetastoreMsg(path="/Volumes/main/default/myvolume/MathWorks/runtimes/runtime_install.sh")
```

### matlab.databricks.setup.internal.isClusterLocal

```text
isClusterLocal Returns true if clusterId is same as local cluster
 
  Example
    tf = matlab.databricks.setup.internal.isClusterLocal('0825-123456-abcdde')
```

### matlab.databricks.setup.internal.javabuilderMetastoreMsg

```text
JAVABUILDERMETASTOREMSG Shows a message and link to update the allowlist
 
  Example:
    matlab.databricks.setup.internal.javabuilderMetastoreMsg(path="/Volumes/main/default/myvolume/MathWorks/runtimes/javabuilder")
```

### matlab.databricks.setup.internal.pipDownload

```text
PIPDOWNLOAD Uses pip to download .whls to a directory
  The package argument specifies the PyPi package(s).
  If package is scalar text that ends in "requirements.txt" it will be
  treated as a requirements file.
  The whlsDir argument specifies the download destination directory.
  If the directory does not exist an attempt will be made to create it.
  True is returned on success otherwise false is returned.
 
  The version of Python and pip is determined based on the current
  pyenv's executable.
 
  Optional named arguments:
 
         pythonCmd: Path to a Python executable, the default is that given
                    by the pyenv command.
 
   alternativeRepo: URL for an alternative library source e.g. Artifactory.
 
           verbose: Produce additional output. Default is true.
 
  Example:
    tf = matlab.databricks.setup.internal.pipDownload("databricks-connect", "/home/username/databricks/Software/MATLAB/Connect/15.4/whls/");
```

### matlab.databricks.setup.internal.pipInstallFromDir

```text
pipInstallFromDir Install .whls from a directory of .whls
 
  Required argument
      package: Name(s) of package to install, if the name ends with
               "requirements.txt" then that will be used as a requirements file.
               This can be an array of package names.
 
      whlsDir: Directory of the .whl files.
 
  Optional arguments
    pythonCmd: Path to a Python executable, the default is the venv
               based on the version argument.
 
 
      verbose: Produce additional output. Default is true.
 
  Example:
    tf = matlab.databricks.setup.internal.pipInstallFromDir("databricks-connect", "/myDownloads");
```

### matlab.databricks.setup.internal.pipPkgCheck

```text
PIPPKGCHECK Returns true if a package is found, returns false otherwise
  Uses a system command to call the python with -m pip show <package>: arguments.
  Requires that the pip package is installed.
  Can be used without an python environment using an absolute path.
 
  Returns false if the Python environment, if used, executable property is not
  correctly configured.
  If a matlab.pyclient.PythonEnvironment or PythonPath is not provided just
  "python" or "python.exe" will be called. This is not recommended due to a
  high chance of failure.
 
  The function cannot be used to check for the presence of pip itself.
  
  Example:
    % Check if pip is databricks-connect
    tf = matlab.databricks.setup.internal.pipPkgCheck("databricks-connect", pyenv=mypyenv)
```

### matlab.databricks.setup.internal.pyModuleCheck

```text
PYMODULECHECK Returns true if a Python module/package is found, otherwise returns false
  Uses: importlib.util.find_spec(module)
  A functional Python environment is required.
 
  Example:
    tf = matlab.databricks.setup.internal.pyModuleCheck("pip")
```

### matlab.databricks.setup.acceptRuntimeTCs

```text
ACCEPTRUNTIMETCS Accepts or not the MATLAB runtime license terms
  true is returned if accepted otherwise false.
  The agreeToLicense= value is updated to yes or no in the init script.
  The default script path is Software/MATLAB/script/runtime_install.sh
  The init script must be uploaded to Databricks for this to take effect.
```

### matlab.databricks.setup.archiveSettingsFiles

```text
archiveSettingsFiles Archives
  For certain major version migration or for experimentation purposes
  it maybe required or useful to archive settings and configuration
  files for future reference.
 
  The archived files are:
    [home directory]/.databricks-connect
    [home directory]/.databrickscfg
    [prefdir]/.databricks-settings.json
 
  For details of prefdir see: doc prefdir
 
  Optional named arguments:
 
      dryRun: If set to true then the function will report its planned actions
              but will not move files. No archive will be made.
              Default is false.
 
   outputDir: Specify an alternative output directory.
              Default is: [home directory]/databricks-settings-archive
              If the directory does not exist it will be created.
              If the directory contains a previous archive files
              will be overwritten.
 
  Example:
    matlab.databricks.setup.archiveSettingsFiles(dryRun=true)
```

### matlab.databricks.setup.askForReleaseList

```text
ASKFORRELEASELIST Ask the user for a list or MATLAB releases to support
```

### matlab.databricks.setup.configureDBC

```text
CONFIGUREDBC Installs Databricks Connect libraries
  This function downloads required libraries or uses an existing
  configured Python.
 
  The system Python installation must support virtual environments,
  Python 3 typically supports virtual environments.
 
  Python 3.10 is required for 13.3 & 14.3.
  Python 3.11 is required for 15.4.
  Python 3.12 is required for 16.4 & 17.3
 
  This function expects interactive input.
 
  Optional arguments
       dbcVersions: Databricks Connect versions to support. A corresponding
                    directory is expected in Software/MATLAB/Connect e.g.
                    Software/MATLAB/Connect/15.4/
                    By default the supported versions in Software/MATLAB/Connect
                    are used.
 
   alternativeRepo: URL for an alternative library source e.g. Artifactory.
 
  pythonExecutable: Version argument for pyenv command to specify the
                    Python used to create the virtual environments.
                    Can be used if Python is not found on the system path.
 
        acceptance: Accept default responses to create virtual environments
                    and download dependencies.
 
           venvDir: Base directory for optional virtual environment creation
                    as an alternative to the default Software/MATLAB/Connect.
 
           verbose: Produce additional output. Default is true.
 
  Example:
    % Run setup step in a standalone fashion
    tf = matlab.databricks.setup.configureDBC();
```

### matlab.databricks.setup.configureJDBC

```text
CONFIGUREJDBC Queries acceptance of Databricks JDBC Driver licenses
  If the licenses are not accepted the drivers are renamed such that they are
  not automatically configured for use.
 
  Returns false if the license is not accepted or if a driver file is not found.
 
  Example
    tf = matlab.databricks.setup.configureJDBC();
```

### matlab.databricks.setup.configureRuntimes

```text
CONFIGURERUNTIMES Provision MATLAB runtimes and associated files on Databricks
```

### matlab.databricks.setup.configureSettingsAndCfg

```text
CONFIGURESETTINGSANDCFG Write databricks-settings.json and .databrickscfg files
 
  Example:
    [tf, settingsFile, cfgFile] = matlab.databricks.setup.configureSettingsAndCfg();
```

### matlab.databricks.setup.createClusterPolicies

```text
CREATECLUSTERPOLICIES Writes a file containing cluster policy details
 
 
  Example policy init script based definition for Databricks runtimes < 17:
  {
    "init_scripts.0.volumes.destination":{"type":"fixed", "value":"/Volumes/main/default/myvolume/MathWorks/runtimes/runtime_install.sh"},
    "spark_env_vars.LD_LIBRARY_PATH": {
      "type": "fixed",
      "value":"/MATLAB_Runtime/runtime/glnxa64:/MATLAB_Runtime/bin/glnxa64:/MATLAB_Runtime/sys/os/glnxa64:/MATLAB_Runtime/sys/opengl/lib/glnxa64:/MATLAB_Runtime/extern/bin/glnxa64"},
    "spark_env_vars.MW_RUNTIME_ZIP": {
      "type": "fixed",
      "value": "/Volumes/main/default/myvolume/MathWorks/runtimes/MATLAB_Runtime_R2025b_glnxa64.zip"
    },
    "spark_env_vars.MW_RUNTIME_RELEASE": {
      "type": "fixed",
      "value": "R2025b"
    },
    "spark_conf.spark.databricks.isv.product": {
      "type": "fixed",
      "value": "MathWorks_MATLAB/25.2.0"
    },
    "spark_version":{"type":"allowlist", "values":[
      "16.4.x-scala2.13",
      "16.4.x-scala2.12",
      "15.4.x-scala2.12",
      "14.3.x-scala2.12",
      "13.3.x-scala2.12"]
    }
  }
 
 
  Example:
    matlab.databricks.setup.createClusterPolicies()
```

### matlab.databricks.setup.deleteAuthTokens

```text
DELETEAUTHTOKENS Deletes default OauthM2M & OauthU2M token caches and any specified cache files
 
  Example:
     matlab.databricks.setup.deleteAuthTokens();
```

### matlab.databricks.setup.depthCheck

```text
DEPTHCHECK
 
  See also: https://learn.microsoft.com/en-us/windows/win32/fileio/maximum-file-path-limitation
```

### matlab.databricks.setup.generateVolumeURL

```text
GENERATEVOLUMEURL Returns the Databricks portal URL for the destination
  If the destination is not writable then the higher-level path is provided e.g.:
    https://adb-123456789.azuredatabricks.net/explore/data?o=123456789
  A matlab.net.URI object is returned.
  Only /Volumes destination paths are supported.
```

### matlab.databricks.setup.provisionJavabuilderJars

```text
PROVISIONJAVABUILDERJARS Attempts to upload a set of javabuilder jar files
  Requires permissions to create the javabuilder directory if it does not already exist.
  The javabuilder path is <interfaceDirectory settings field>/runtimes/javabuilder
  Instructions for portal use are provided.
 
  This function is intended to be run interactively.
 
  Example:
    matlab.databricks.setup.provisionJavabuilderJars(interfaceDirectory="/Volumes/main/default/myvolume/MathWorks")
```

### matlab.databricks.setup.provisionMATLABRuntimes

```text
PROVISIONMATLABRUNTIMES Provision MATLAB runtimes in the Databricks environment
  Requires permissions to create the destination directory if it does not already exist.
  The default destination is the <interfaceDirectory settings field>/runtimes
  Instructions for portal and notebook based use are provided.
  
  This function is intended to be run interactively.
```

### matlab.databricks.setup.rmUnusedWhls

```text
RMUNUSEDWHLS Remove .whl files & directory for other architectures
  Confirmation is not requested.
 
  This function should no longer be needed and will removed without further
  notice in a future release.
 
  Example:
    matlab.databricks.setup.rmUnusedWhls();
```

### matlab.databricks.setup.testCredentialsClusterList

```text
TESTCREDENTIALSCLUSTERLIST Check if credentials can be used by listing clusters
```

### matlab.databricks.setup.uploadInitscript

```text
UPLOADINITSCRIPT Uploads an init script to <interfaceDirectory settings field>/runtimes
  This should come after the provisioning of runtimes and assumes a directory
  exists for the runtimes.
  The optional destination argument is the directory the runtime_install.sh file
  will be copied to not the full path of copied file.
```

### matlab.databricks.unitycatalog

### matlab.databricks.unitycatalog.addArtifactAllowlistItem

```text
addArtifactAllowlistItem Add an artifact to the allowlist
 
  Add an artifact to the Allowlist. This function will first retrieve
  the existing list. If this element is already on the list, no changes
  will be made. If it's not on the list, it will be added.
 
  artifactPath = "abfss://mycontainer@mystorage.dfs.core.windows.net/runtime_install_r2023b.sh"
  matlab.databricks.unitycatalog.addArtifactAllowlistItem("INIT_SCRIPT", artifactPath, "PREFIX_MATCH")
  
  At the time of writing, "PREFIX_MATCH" is the only matchType, so this
  can be omitted, i.e.
 
 
  Optional named arguments
    authMethod     A matlab.databricks.AuthMethod
    profileName    A configuration file profileName value
 
  matlab.databricks.unitycatalog.addArtifactAllowlistItem("INIT_SCRIPT", artifactPath)
```

### matlab.databricks.unitycatalog.findArtifactInAllowlist

```text
findArtifactInAllowlist Find an artifact in the allowlist
 
  This function will see if an artifact is a member of a certain
  allowlist. It's a utility function used by
  matlab.databricks.unitycatalog.addArtifactAllowlistItem and
  matlab.databricks.unitycatalog.removeArtifactAllowlistItem.
 
  PREFIX_MATCH is currently the only supported matchType.
 
  Example:
    artifacts = matlab.databricks.unitycatalog.getArtifactAllowlistItems("INIT_SCRIPT")
    result = matlab.databricks.unitycatalog.findArtifactInAllowlist(artifacts.artifact_matchers, "/Volumes/main/default/myvolume/MathWorks/runtimes/runtime_install.sh", "PREFIX_MATCH")
 
  See also: https://docs.databricks.com/en/data-governance/unity-catalog/manage-privileges/allowlist.html
```

### matlab.databricks.unitycatalog.getArtifactAllowlistItems

```text
getArtifactAllowlistItems Get list of artifacts from the allowlist
 
  % Optional named arguments
    authMethod     A matlab.databricks.AuthMethod
    profileName    A configuration file profileName value
 
  Only artifacts of one specific type will be returned. The
  artifactType argument is of type
  databricks.datastructures.unitycatalog.ArtifactType, e.g.
  databricks.datastructures.unitycatalog.ArtifactType.INIT_SCRIPT
 
    result = matlab.databricks.unitycatalog.getArtifactAllowlistItems(...
      databricks.datastructures.unitycatalog.ArtifactType.INIT_SCRIPT);
    
  A shorter form of the same is
 
    result = matlab.databricks.unitycatalog.getArtifactAllowlistItems("INIT_SCRIPT")
```

### matlab.databricks.unitycatalog.removeArtifactAllowlistItem

```text
removeArtifactAllowlistItem Remove an artifact from the allowlist
 
  Remove an artifact from the Allowlist. This function will first retrieve
  the existing list. If this element isn't on the list, no changes
  will be made. If it is on the list, it will be removed.
 
  artifactPath = "abfss://mycontainer@mystorage.dfs.core.windows.net/runtime_install_r2023b.sh"
  matlab.databricks.unitycatalog.removeArtifactAllowlistItem("INIT_SCRIPT", artifactPath, "PREFIX_MATCH")
  
  At the time of writing, "PREFIX_MATCH" is the only matchType, so this
  can be omitted, i.e.
 
  matlab.databricks.unitycatalog.removeArtifactAllowlistItem("INIT_SCRIPT", artifactPath)
```

### matlab.databricks.vendor

### matlab.databricks.vendor.Vendor

```text
Vendor Supported public Cloud Vendors
  Google/CGP is not currently supported.
```

```text
Enumeration values:
  AWS
  AZURE

```

#### matlab.databricks.vendor.Vendor.Vendor

```text
Vendor Supported public Cloud Vendors
  Google/CGP is not currently supported.

    Documentation for matlab.databricks.vendor.Vendor
```

### matlab.databricks.vendor.getVendor

```text
GETVENDOR Get a Vendor value using a provider chain approach
 
  A matlab.databricks.vendor.Vendor enumeration is returned. If a value
  cannot be determined an empty matlab.databricks.vendor.Vendor is returned.
  This first non empty value is returned and further checks are skipped.
 
  Host values should start with: https://
 
  The function will try to determine a vendor in the order using subject to
  the associated "try" flag.
 
  1. If an optional named argument host is provided.
 
  2. Check the DATABRICKS_VENDOR environment variable.
 
  3. Check the databrcks-settings.json file, this options should not be used
     during setup. An existing vendor value is used if set.
 
  4. The .databrickscfg file host value will be used.
 
  5. The databricks.Cluster REST API will be used, requiring authentication
     using the optional authMethod and profileName arguments.
 
  6. Finally a value will be interactively requested from the user.
     This is mainly intended for use during setup and will require interactive
     input.
 
  Example
    v = matlab.databricks.vendor.getVendor()
```

### matlab.databricks.vendor.getVendorFromAPI

```text
getVendorFromAPI Use the Unity Catalog API to determine a vendor
  A matlab.databricks.vendor.Vendor enumeration is returned.
  An empty vendor value is returned in the case of an error.
  An optional authentication method and profile name can be provided.
 
  Example:
    v = matlab.databricks.vendor.getVendorFromAPI()
```

### matlab.databricks.vendor.getVendorFromCfgHost

```text
GETVENDORFROMCFGHOST Returns vendor based on the cfg file host value
 
  Returns a matlab.databricks.vendor.Vendor enumeration.
  If no value is defined an empty matlab.databricks.vendor.Vendor enumeration
  value is returned.
 
  Example
    v = matlab.databricks.vendor.getVendorFromCfgHost();
```

### matlab.databricks.vendor.getVendorFromEnvironment

```text
getVendorFromEnvironment Gets a vendor from the DATABRICKS_VENDOR environment variable
  A matlab.databricks.vendor.Vendor enumeration is returned.
 
  If an invalid value is provided a message is optionally displayed
  An empty value is returned.
 
  The variable value is case insensitive.
 
  Example
    v = matlab.databricks.vendor.getVendorFromEnvironment()
```

### matlab.databricks.vendor.getVendorFromHost

```text
getVendorFromHost Determine the vendor based on the Databricks host if possible
  A matlab.databricks.vendor.Vendor enumeration is returned.
  If a vendor cannot be determined a empty value is returned.
  The host argument is expected to start with "https://".
 
  Example
    v = matlab.databricks.vendor.getVendorFromHost("https://adb-123456789123456.6.azuredatabricks.net")
```

### matlab.databricks.vendor.getVendorFromSettings

```text
GETVENDORFROMSETTINGS Returns the vendor value stored in the settings file
 
  Returns a matlab.databricks.vendor.Vendor enumeration.
  If no default value is defined an empty enumeration value is returned.
  The DATABRICKS_VENDOR environment variable is respected.
 
  An optional named argument settingsFile may be provided for non default
  file locations.
 
  Example
    v = matlab.databricks.vendor.getVendorFromSettings();
```

### matlab.databricks.vendor.setVendor

```text
SETVENDOR Convenience function to set the vendor settings field.
  Returns true on success otherwise false.
  This function is not case sensitive, a lowercase value is stored.
 
  Example:
    tf = matlab.databricks.vendor.setVendor("azure");
```

### matlab.databricks.vendor.userRequestVendor

```text
userRequestVendor Interactively asks the user for the vendor
  If an invalid value is provided a message is displayed and an empty value
  is returned.
  A matlab.databricks.vendor.Vendor enumeration is returned.
  Input is case insensitive.
 
  Example
    v = matlab.databricks.vendor.userRequestVendor()
```

### matlab.databricks.workspace

### matlab.databricks.workspace.getNotebookLink

```text
getNotebookLink Return URL and optional link for a notebook
 
  Examples:
    url = matlab.databricks.workspace.getNotebookLink("/Workspace/Users/joe@example.com/myNotebook")
 
    [url, link] = matlab.databricks.workspace.getNotebookLink("/Workspace/Users/joe@example.com/myNotebook")
```

### matlab.databricks.workspace.import

```text
import Import file to workspace
 
  This is a helpful utility, that removes some of the details of the
  official methods in the databricks.Workspace class
 
    matlab.databricks.workspace.import("demo.py", "/Users/user@example.com/Demos")
 
  This will import the file demo.py into the workspace with the name
  without extension:
 
    "/Users/jdoe@example.com/Demos/demo"
 
  The destination folder given as the second argument to the function
  will be created if it doesn't exist already.
 
  If called with an output argument, it will return a URL for opening
  the notebook in the Databricks portal.
 
    url = matlab.databricks.workspace.import("demo.py", "/Shared")
```

### matlab.databricks.AuthMethod

```text
AuthMethod Enumeration of authentication methods
  DotDatabricksConnect & Basic are no longer supported and will be removed from
  this class in a future release without notice.
```

```text
Enumeration values:
  Chain
  DotDatabricksConnect
  PAT
  Basic
  OauthM2M
  OauthU2M

```

#### matlab.databricks.AuthMethod.AuthMethod

```text
AuthMethod Enumeration of authentication methods
  DotDatabricksConnect & Basic are no longer supported and will be removed from
  this class in a future release without notice.

    Documentation for matlab.databricks.AuthMethod
```

#### matlab.databricks.AuthMethod.authMethod2AuthType

```text
AUTHMETHOD2AUTHTYPE Convert AuthMethod enum or string to auth_type string
  authTypes are returned in lower case.
  If authMethod is not recognized, a error is raised.
```

### matlab.databricks.OauthService

```text
OauthService Enumeration of Oauth service provider
```

```text
Enumeration values:
  Databricks
  EntraID
  Unspecified

```

#### matlab.databricks.OauthService.OauthService

```text
OauthService Enumeration of Oauth service provider

    Documentation for matlab.databricks.OauthService
```

### matlab.databricks.ReleaseConfig

Superclass: handle

```text
ReleaseConfig Helper class for MATLAB and Databricks releases
 
  Examples:
    cfg = matlab.databricks.ReleaseConfig.defaultConfig();
 
    matlabReleases = matlab.databricks.ReleaseConfig.adaptMATLABReleases("all", cfg);
    There is an exception for R2025a, which will only be returned if explicitly
    mentioned.
 
    databricksRuntimes = matlab.databricks.ReleaseConfig.adaptDatabricksRuntimes("all", "R2025b", cfg);
 
    tf = matlab.databricks.ReleaseConfig.matlabDatabricksCombinationSupported("R2024b", "17.3", cfg);
 
    ubuntuVersion = matlab.databricks.ReleaseConfig.getUbuntuVersion("17.3");
```

#### matlab.databricks.ReleaseConfig.ReleaseConfig

```text
ReleaseConfig Helper class for MATLAB and Databricks releases
 
  Examples:
    cfg = matlab.databricks.ReleaseConfig.defaultConfig();
 
    matlabReleases = matlab.databricks.ReleaseConfig.adaptMATLABReleases("all", cfg);
    There is an exception for R2025a, which will only be returned if explicitly
    mentioned.
 
    databricksRuntimes = matlab.databricks.ReleaseConfig.adaptDatabricksRuntimes("all", "R2025b", cfg);
 
    tf = matlab.databricks.ReleaseConfig.matlabDatabricksCombinationSupported("R2024b", "17.3", cfg);
 
    ubuntuVersion = matlab.databricks.ReleaseConfig.getUbuntuVersion("17.3");

    Documentation for matlab.databricks.ReleaseConfig
```

#### matlab.databricks.ReleaseConfig.adaptDatabricksRuntimes

```text
adaptDatabricksRuntimes Allow the keyword "all" for databricks runtimes
```

#### matlab.databricks.ReleaseConfig.adaptMATLABReleases

```text
adaptMATLABReleases Allow the keyword "all" for all supported releases
 
  There is an exception for R2025a, which will only be returned if explicitly
  mentioned.
```

#### matlab.databricks.ReleaseConfig.defaultConfig

```text
defaultConfig Return the normal runtime-info configuration
```

#### matlab.databricks.ReleaseConfig.getUbuntuVersion

```text
getUbuntuVersion Return Ubuntu version for Databricks Runtime
```

#### matlab.databricks.ReleaseConfig.matlabDatabricksCombinationSupported

```text
matlabDatabricksCombinationSupported Check if release combination is ok
```

### matlab.databricks.ResponseException

Superclass: MException

```text
RESPONSEEXCEPTION Exception class for throwing exceptions related to
  failed REST calls. The failed HTTP Response and a customErrorMsg are
  provided as inputs and the class then automatically forms an
  infomative error message. The error message is the same as formed by
  matlab.databricks.internal.responseError but ResponseException also preserves the full response
  body which can for example be used in unit tests to verify a specific
  expected error occurred.
```

#### matlab.databricks.ResponseException.ResponseException

```text
RESPONSEEXCEPTION Constructor

    Documentation for matlab.databricks.ResponseException
```

### matlab.databricks.SimulinkTempFileManager

Superclass: handle

```text
SimulinkTempFileManager Helper class for compiled Simulink
 
  This class is intended for use with Simulink Compiler in the context of
  running libraries on Databricks. When running a Simulink model, certain
  data will be saved to the hard disk, and on a system like Databricks, 
  where workers are running in parallel, and potentially a large number of
  simulations are run, this can cause disk space issues. This class helps
  manage these issues by:
 
    Enabling temporary directory rewiring to redirect temp files to a local
    disk directory, in this case `"/local_disk0/tmp`
 
    Changing the current working directory to a temporary directory which is
    deleted after the simulation completes.
 
    Clearing the Simulink Data Inspector (SDI) after simulation. This doesn't
    delete the SDI data completely, but will reduce its size.
 
    Rewiring the Simulink Data Dictionary Cache (SLDDC) cache path to a
    local disk directory.
 
    Furthermore, an option can be used to show disk usage at different stages.
    This is more for debugging purposes, and the output can be found on the
    cluster logs.
```

#### matlab.databricks.SimulinkTempFileManager.SimulinkTempFileManager

```text
SimulinkTempFileManager Helper class for compiled Simulink
 
  This class is intended for use with Simulink Compiler in the context of
  running libraries on Databricks. When running a Simulink model, certain
  data will be saved to the hard disk, and on a system like Databricks, 
  where workers are running in parallel, and potentially a large number of
  simulations are run, this can cause disk space issues. This class helps
  manage these issues by:
 
    Enabling temporary directory rewiring to redirect temp files to a local
    disk directory, in this case `"/local_disk0/tmp`
 
    Changing the current working directory to a temporary directory which is
    deleted after the simulation completes.
 
    Clearing the Simulink Data Inspector (SDI) after simulation. This doesn't
    delete the SDI data completely, but will reduce its size.
 
    Rewiring the Simulink Data Dictionary Cache (SLDDC) cache path to a
    local disk directory.
 
    Furthermore, an option can be used to show disk usage at different stages.
    This is more for debugging purposes, and the output can be found on the
    cluster logs.

    Documentation for matlab.databricks.SimulinkTempFileManager
```

#### matlab.databricks.SimulinkTempFileManager.delete

```text
Clean up resources or perform necessary actions before deletion
```

#### matlab.databricks.SimulinkTempFileManager.log

```text
log - Natural logarithm

    Syntax
      Y = log(X)

    Input Arguments
      X - Input array
        scalar | vector | matrix | multidimensional array | table |
        timetable

    Output Arguments
      Y - Logarithm values
        scalar | vector | matrix | multidimensional array | table |
        timetable

    Examples
      openExample('matlab/NaturalLogarithmofNegativeNumberExample')

    See also log1p, log2, log10, exp, logm, reallog, loglog, semilogx,
      semilogy

    Introduced in MATLAB before R2006a
    Documentation for log
       doc log
```

#### matlab.databricks.SimulinkTempFileManager.setup

```text
matlab.databricks.SimulinkTempFileManager/setup is a function.
    setup(obj)
```

### matlab.databricks.StructOrCellDeserializable

Superclass: handle

```text
matlab.databricks.StructOrCellDeserializable Base class for objects whose properties
  can be set through a structure or cell-array as typically obtained by
  JSON decoding a (Databricks) REST response.
```

#### matlab.databricks.StructOrCellDeserializable.StructOrCellDeserializable

```text
matlab.databricks.StructOrCellDeserializable Constructor. Call this from
  derived classes constructors:
 
    function obj = SomeDerivedClass(varargin)
        obj@matlab.databricks.StructOrCellDeserializable(varargin{:})
    end

    Documentation for matlab.databricks.StructOrCellDeserializable
```

#### matlab.databricks.StructOrCellDeserializable.fromStructOrCell

```text
For all properties in the *class* (not the struct)
```

### matlab.databricks.cli

```text
CLI Wrapper to the Databricks CLI
  The Databricks command-line interface (CLI) provides an easy-to-use
  interface to the Databricks platform. For more details, please see:
  https://docs.databricks.com/dev-tools/api/latest/index.html#rest-api-v2
 
  Usage: cli([Options])
  Options:
    -v, --version
    -h, --help
 
  Usage: cli([GROUP], [GROUP_OPTIONS], GROUP_COMMAND, [GROUP_ARGS],...)
  GROUP : fs
          workspace
          groups
          clusters
          jobs
  To find out about [GROUP_OPTIONS] and GROUP_COMMAND
  databricks('GROUP -h')
 
   Group Usage: cli('fs', 'cp', 'a.txt', 'dbfs:/MATLAB_cli')
```

### matlab.databricks.databricksDiagnostics

```text
DATABRICKSDIAGNOSTICS Run diagnostics for MATLAB Interface for Databricks
  Returns false if any potential issues are detected otherwise true.
  Output is useful for initial tech support diagnostics.
 
  Example:
    tf = matlab.databricks.databricksDiagnostics()
```

### matlab.databricks.databricksPackageVersion

```text
DATABRICKSPACKAGEVERSION Returns the version of the package as string
  If the version cannot be determined an empty string is returned.
 
  Example
    v = matlab.databricks.databricksPackageVersion()
```

### matlab.databricks.detectProxy

```text
DETECTPROXY Detects if a HTTP proxy to be used and is configured
  If the databricks-http.json UseProxy flag is set to 1 (default) then
  the following options are checked in order to determine the HTTP proxy URI:
     databricks-http.json ProxyURI field
     MATLAB Proxy preferences
     System proxy preferences (Windows only, & requires Java support)
 
  If the proxy is set to be used and a proxy is configured a logical true is
  returned, otherwise false.
 
  The proxy URI is optionally returned. the URI is returned as a
  matlab.net.URI, if no URI is available or the proxy is not set to be used
  an empty URI is returned.
 
  If the databricks-http.json UseProxy flag is set to 0 the false and an empty
  URI are returned.
 
  The URI is returned with a HTTPS scheme if the value is derived from the
  MATLAB preferences/settings.
 
  Example:
    [tf, proxyURI] = matlab.databricks.detectProxy()
```

### matlab.databricks.doc

```text
DOC Opens index.html in a browser or otherwise README.md in MATLAB
  If a specific case sensitive filename without extension is provided it will
  be opened, favouring the html form over the markdown form. If an extension
  is provided that document type will be opened. HTML files are opened in a browser tab,
  Markdown files are opened in MATLAB.
 
  Examples:
    matlab.databricks.doc
 
    matlab.databricks.help('Files')
 
  See also: matlab.databricks.help
```

### matlab.databricks.finish

```text
finish - Runs at the end of a MATLAB session
 
  This function runs at the end of MATLAB session, and will only be
  active when it's running on a Databricks node.
 
  It's controlled by the environment variables MW_STARTUP_SHUTDOWN_CONFIG,
  which contains the JSON-file with the startup/shutdown configuration.
```

### matlab.databricks.getDefaultRuntimeJars

```text
GETDEFAULTRUNTIMEJARS Return a default jars for the Spark submission task
 
    jars = getDefaultRuntimeJars();
 
  The return array of jars can be used for configuring a databricks.Job
  object.
```

### matlab.databricks.getMATLABInterfacePackage

```text
getMATLABInterfacePackage Get a specified package version or the semantically latest
 
  Example:
    pkgFile = matlab.databricks.getMATLABInterfacePackage()
```

### matlab.databricks.help

```text
help Get help from the Databricks Documentation directory
  Passes request through to matlab.databricks.doc()
  A filename with or without a .html or .md extension can be given as an argument.
 
  Examples
    matlab.databricks.help()
 
    matlab.databricks.help('Files')
 
  See also: matlab.databricks.doc
```

### matlab.databricks.startGenieChat

```text
STARTGENIECHAT Start a Genie chat
 
  Example:
    matlab.databricks.startGenieChat();
```

### addDatabricksPaths

```text
ADDDATABRICKSPATHS - Script to add paths to MATLAB path
  This script will add the paths below the Databricks root directory into the MATLAB path.
  I.E. /Software/MATLAB
 
  Optional argument
    verbose: Logical to enable additional output, default is true.
```

### createDatabricksCluster

```text
CREATEDATABRICKSCLUSTER Helper function to create a cluster
 
  This function is an easy way to create a cluster in a Databricks
  subscription. It relies on the databricks.Cluster class, and its
  methods and helper functions. It's an easy way to create a cluster,
  and it offers a few options. If there's a need for more fine grained
  control of the cluster creation options, please use the underlying
  class and its APIs directly.
 
  Arguments:
              name : The name of the cluster.
 
        numWorkers : The number of workers in the cluster. This can be a
                     single number or an array of lower and upper bound,
                     e.g. for a cluster between 2 and 10 workers the value
                     should be [2, 10]. If 0 is used then a single node cluster
                     will be created, as distinct from a cluster of size 1.
 
         useMATLAB : Optional argument to install MATLAB runtime on the
                     cluster. Default is true. If a Docker Image URL is
                     provided this option is ignored.
 
            create : Optional argument to set to true if the cluster should
                     be created immediately. If set to false, the function
                     will only return an object that can be used for
                     creating a cluster. This is useful for creating Spark
                     jobs. Default is true.
 
    dockerAuthFile : The name of a file containing docker information,
                     image URL, user name, and password. This can be
                     used to easily use docker settings when creating a
                     cluster. The filename can be an absolute path or
                     relative path. Currently, only no password or
                     basic_auth is supported.
                     The "spark_version" field is optional, but is
                     helpful for determining spark_version. It's
                     required if the image tag doesn't reflect the
                     Databricks runtime version.
 
                      {
                        "url": "some.repo.com/matlab/databricks/desktop:r2025a-dbx15.4",
                        "basic_auth": {
                          "username": "b304<REDACTED>40",
                          "password": "ol_8<REDACTED>qr"
                        },
                        "spark_version": "15.4.x-scala2.12"
                      }
 
                     If the repository doesn't need authentication, the
                     file may consist of only the url.
                     The file path may be a local or remote path e.g.
                     Workspace or Volumes.
 
         dockerURL : Optional argument to specify the URL of a Docker Image.
                     When using Docker the spark conf spark.databricks.unityCatalog.volumes.enabled
                     property will be set to "true".
 
    dockerUsername : Optional argument to specify the container registry username.
 
    dockerPassword : Optional argument to specify the container registry password.
 
  instanceProfileARN : Optional argument to specify an instance profile ARN.
                     This is a feature that only has effect on AWS
                     clusters. It can be used to provide access to the
                     docker repository used for the image.
 
      sparkVersion : Set this to set a given spark_version otherwise
                     a version based on the current default Databricks Runtime
                     will be used. This value is the Databricks Cluster API
                     spark_version field and is not strictly the version of Spark
                     used. It has the form: 17.3.x-scala2.13. The specific value
                     for a given Databricks runtime can be verified in the
                     Databricks UI.
 
        nodeTypeId : Set this to pick a different node type than what
                     is set in the users default settings.
 
    initScriptPath : Specify a non default init script path.
                     If not specified and the default script is not present
                     the local script will be uploaded to the user's workspace.
                     % By default the init script is stored in:
                     <settings: interfaceDirectory>/runtimes/runtime_install.sh
 
  interfaceDirectory : /Volumes path under which MathWorks files can be stored.
 
           release : MATLAB release of the form R2024b for the runtime to install.
                     By default the release of MATLAB in use is used.
 
       runtimePath : Specify a path to to a MATLAB runtime .zip file.
                     /Volumes, DBFS and http paths are supported.
 
        policyName : Set the name of the cluster policy used to create the cluster.
 
          policyId : Set the ID of the cluster policy used to create the cluster.
 
                ML : Selects a Databricks Runtime version with ML functionality
                     enabled.
 
               GPU : Selects a Databricks Runtime version with GPU functionality
                     enabled.
 
            photon : Selects a Databricks Runtime version with Photon functionality
                     enabled.
 
        accessMode : Data security mode decides what data governance model to
                     use when accessing data from a cluster.
                     Default: databricks.datastructures.DataSecurityMode.SINGLE_USER
 
       sparkConfig : Additional Spark Conf pair settings to apply to a cluster
                     e.g. databricks.SparkConfPair({'mykey', 'myvalue'})
 
      sparkEnvPair : Additional environment variable(s) to apply to a cluster
                     e.g. databricks.SparkEnvPair('MyVariable','MyValue')
                     To set multiple values:
                     databricks.SparkEnvPair({'SPARK_WORKER_MEMORY','28000m';'SPARK_LOCAL_DIRS','/local_disk0'})
 
        clusterTag : Additional ClusterTags to apply to a cluster
                     e.g. databricks.ClusterTag('myKey', 'myValue');
 
  autoterminationMinutes : Specifies the number of minutes of idle time after
                           which the cluster will be stopped.
 
    instancePoolId : The optional ID of the instance pool to which the cluster belongs.
 
        authMethod : A matlab.databricks.AuthMethod.
 
       profileName : A configuration file profileName value.
 
     enableLogging : Enables logging of the initscript and other steps.
                     The default is false.
 
            logDir : The location to which logs are written, the default is:
                     dbfs:/cluster-logs
                     If using /Volumes (Public Preview) additional restrictions
                     apply. See: https://docs.databricks.com/aws/en/compute/configure#compute-log-delivery
 
   updateClusterId : Update the cluster Id value stored in the default
                     or specified cluster. The default is false.
                     If the create argument is false the updateClusterId argument
                     is ignored.
 
    waitForCluster : Waits for the cluster to reach a RUNNING state before returning.
                     The default is false.
                     A timeout of 12 minutes is applied.
 
           verbose : Enable additional feedback. Default is true.
 
  Examples:
  Create a cluster with 4 workers that installs the MATLAB runtime
    cl = createDatabricksCluster('my-cluster', 4);
 
  Create a cluster without a MATLAB runtime installed. This cluster
  can still be used for interactively handling a Databricks session
  from within MATLAB, but no compiled MATLAB code can run on the
  cluster.
    cl = createDatabricksCluster('plain-cluster', 4, useMATLAB = false);
 
  Unity Catalog requires that an access mode mode is specified and set to
  SINGLE_USER or USER_ISOLATION. Be default clusters are created with using
  SINGLE_USER. The accessMode is set using an enumeration of type:
  databricks.datastructures.DataSecurityMode.
 
  Details of the other modes can be found in the databricks.datastructures.DataSecurityMode
  help.
 
  Create a USER_ISOLATION (Shared) cluster using an init script stored in
  Azure Data Lake Storage (ABFSS). This requires a Databricks runtime version
  13.3 or greater.
 
  Add an ABFSS scope
    scope.scope = 'ABFSS_Scope';
    scope.initial_manage_principal = 'users';
    scope.create
 
  Read in the sensitive value
    s = jsondecode(fileread("abfsskey.json"));
 
  Create a secret in the scope using the secret
    secret = databricks.Secret;
    secret.scope = 'ABFSS_Scope';
    secret.key = 'ABFSS_Key';
    secret.setValue(s.abfsskey);
    secret.put
 
  The Scope and Secret are persistent and do not need to be recreated unless deleted.
 
  Create a Spark Conf Pair that uses the secret
    scps = databricks.SparkConfPair({'spark.hadoop.fs.azure.account.key.mystorageaccount.dfs.core.windows.net', '{{secrets/ABFSS_Scope/ABFSS_Key}}'});
 
  Add a custom init script to the allow list - requires administrative privileges
    matlab.databricks.unitycatalog.addArtifactAllowlistItem('INIT_SCRIPT', "abfss://mycontainer@mystorageaccount.dfs.core.windows.net/package_version/runtime_install.sh");
 
  Create the cluster
    c = createDatabricksCluster("myCluster", 1, sparkConfig=scps, initScriptPath=initScriptPath, sparkVersion="17.3.x-scala2.13");
```

### databricksRoot

```text
DATABRICKSROOT Function to return the root folder for the Databricks interface
 
  databricksRoot alone will return the root for the MATLAB code in the
  project.
 
  databricksRoot with additional arguments will add these to the path
  
   funDir = databricksRoot('app', 'functions')
 
   The special argument of a negative number will move up folders, e.g.
   the following call will move up two folders, and then into
   Documentation.
 
   docDir = databricksRoot(-2, 'Documentation')
```

### finish

```text
finish - Runs at the end of a MATLAB session
 
  This function runs at the end of MATLAB session, and will only be
  active when it's running on a Databricks node.
```

### getDatabricksSession

```text
GETDATABRICKSSESSION Returns a Databricks Connect Spark Session.
 
  Optional named arguments:
    cluster - A cluster id, or an instance of a databricks.Cluster
        object. If a cluster Id argument is not provided, the default or
        provided profile will be checked for a cluster Id. This is required
        if not using serverless.
 
    serverless - Set to true to use serverless. If set to true, any
        cluster argument will be ignored. Default: false.
 
    skipVersionChecks - Set to true to skip version checks for:
            * Client Python version support.
            * Client Python serverless support.
            * MATLAB Python version support.
            * Client Python version matches the cluster Python version.
            * Databricks Connect service disabled.
        The use of this argument is not recommended and is likely to result
        in errors. However, it may sometimes be useful for testing purposes.
        Default: false.
 
    dependencies - Used to provided a list of Python packages that should be
        installed in the Python environment before creating the Spark session.
        This is useful when additional libraries are required.
 
    profileName - Used to optionally specify a profile name.
 
    authMethod - Used to optionally specify an authentication method.
 
    logging - set this to a different logging level for Spark. The
        logging argument can be one of the following:
        "debug", "error", "fatal", "info", "warn". The function
        tries to reset the value after returning from this function, but
        the value seems to be cached by the underlying Spark library. In
        these cases, it may be necessary to either restart the Python
        environment if using the 'OutOfProcess' configuration, or
        restart MATLAB if using the 'InProcess' configuration.
 
    verbose - Set to true will output more information. Default: true.
 
    forceNewSession - If set to true, this will create a new Spark
         Session. If set to false or omitted, it will reuse an existing
         Spark Session, if available.
         This is especially useful in development workflows, where a
         new version of an artifact is uploaded with the addArtifact
         method. If an old session is reused, the artifact cannot be
         replaced. Default: false.
 
  A serverless compute session times out after 10 minutes of inactivity.
  Connection creation failures time out after 5 minutes.
 
  Serverless compute will be used if:
    * The serverless argument is set to true.
    * The environment variable DATABRICKS_SERVERLESS_COMPUTE_ID is set to auto.
    * The configuration profile has serverless_compute_id set to auto.
    * The configuration profile should not contain a cluster_id field.
 
 
  Example:
    % Use default cluster Id from profile
    spark = getDatabricksSession()
 
    % Use a specific cluster Id
    spark = getDatabricksSession(cluster='my-cluster-id')
 
  See also: https://docs.databricks.com/aws/en/dev-tools/databricks-connect/requirements
 
  This function only supports Databricks Connect v2, v1 is not supported.
```

### onDatabricksSetup

```text
ONDATABRICKSSETUP Top-level function to step through the interface's setup process
  This function takes the role of setup.m in a desktop based scenario.
  It is designed to be invoked at startup by the Web Proxy such that the
  support package is automatically configured prior to end user access.
 
  This function automatically accepts the software license agreement for the
  Databricks JDBC driver and the MATLAB runtime on the user's behalf.
 
  Optional arguments:
    settingsFile: Path to settings configuration file
    cfgFile: Path to configuration file
    interfaceDirectory: Interface directory path
    forceCfgAndSettingsUpdate: force updates to exiting settings or configuration files.
 
    preExecScript : Path to script to execute before setup
    postExecScript: Path to script to execute after setup
 
    authMethod: Authentication method
    profileName: Profile name for configuration
    deleteCachedTokens: Deletes cached authentication tokens (default: false)
    cachedTokenPaths: Path to cached authentication tokens
 
    skipPathCheck: Skip path depth check, has no effect on Linux or macOS (default: true)
    skipUpdateCheck: Skip check for updated version
    verbose: Enables additional output (default: true)
    startupFolder: Folder to changed to once setup is complete
    runDiagnostics: Runs diagnostics after setup (default: false)
 
  The function may be invoked repeatedly with the same input arguments. However,
  if in the mean time the user has changed settings or configuration, those
  changes would be overwritten. Thus if the settings or configuration files
  exist they will not be altered unless the forceCfgAndSettingsUpdate flag is
  set to true. By default it is false.
 
  The idempotence of preExecScript & postExecScript is the responsibility of
  the caller.
```

### updateClusterId

```text
updateClusterId Updates cluster_id and or serverless_compute_id fields in the.databrickscfg file
  The DATABRICKS_CLUSTER_ID environment variable is not updated.
 
  The fields are set in the default profile if the profileName named
  argument is not set.
 
  If an Id argument of "serverless" (case insensitive) is provided then
  the serverless_compute_id will be added if needed and set to "auto". This 
  can be used with Databricks Connect. If present a cluster_id field will be
  removed.
 
  If a cluster Id or cluster object is provided, the cluster_id field will be
  set to the cluster Id. If present a serverless_compute_id field will be
  removed.
 
  Example:
    % Update the default profile with a cluster Id
    updateClusterId("1204-203818-01j3wxif")
 
    % Update the default profile with a cluster object
    updateClusterId(myDatabricksClusterObject)
 
    % Update the default profile to use serverless compute
    updateClusterId("serverless");
 
  An optional nondefault profile name can also be provided.
```

------

**Copyright 2019-2026 The MathWorks Inc.**

[//]: # (Documentation generation settings: )
[//]: # (* Including class level help text )
[//]: # (* Including constructor help text )
[//]: # (* Excluding inherited methods )
[//]: # (* Excluding default MATLAB classes )
[//]: # (* Generated: 24-Sep-2026 13:05:06 )
