function setInstanceProfileARN(obj, instanceProfileARN)
    % setInstanceProfileARN Set AWS specific instance_profile_arn attribute.
    %
    % For example:
    %
    %     cl = databricks.Cluster;
    %     cl.setInstanceProfileARN("arn:aws:iam::<aws-account-number>:instance-profile/<iam-role-name>");

    %  (c) 2026 MathWorks, Inc.

    arguments
        obj (1,1) databricks.Cluster
        instanceProfileARN (1,1) string {mustBeNonzeroLengthText}
    end

    if ~isprop(obj,'aws_attributes')
        addprop(obj,'aws_attributes');
        obj.aws_attributes = struct('instance_profile_arn', instanceProfileARN);
    else
        obj.aws_attributes.instance_profile_arn = instanceProfileARN;
    end

end %function
