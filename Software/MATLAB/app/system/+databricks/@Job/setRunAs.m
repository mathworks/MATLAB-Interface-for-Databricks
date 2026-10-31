function setRunAs(obj, type, value)
    % SETRUNAS Specifies the user or service principal that the job runs as
    % If not specified, the job runs as the user who created the job.
    % Only user_name or service_principal_name can be specified as the type.
    %
    % Type user_name should specify the email of an active workspace user.
    % Non-admin users can only set this field to their own email.
    %
    % Type service_principal_name should specify Application ID of an active
    % service principal. Setting this field requires the servicePrincipal/user
    % role.
    %
    % Examples:
    %   j = databricks.Job;
    %   j.runAs("user_name", "joe@example.com");
    %
    %   j = databricks.Job;
    %   j.runAs("service_principal_name", "123bc6d0-ffa3-11ed-be56-1234ac123456");

    % (c) 2024 MathWorks, Inc.

    arguments
        obj (1,1) databricks.Job
        type string {mustBeMember(type,{'user_name','service_principal_name'})}
        value string {mustBeTextScalar, mustBeNonzeroLengthText}
    end

    s = struct;
    s.(type) = value;
    
    % Add the runtime_engine property and then set it
    if ~isprop(obj,'run_as')
        obj.addprop('run_as');
    end

    obj.run_as = s;
end