function deleteJobs(startWith, options)
    % deleteJobs Delete jobs starting with a certain name

    %  Copyright 2023 MathWorks, Inc.

    arguments
        startWith (1,1) string
        options.authMethod string {mustBeTextScalar, mustBeNonzeroLengthText}
        options.profileName string {mustBeTextScalar, mustBeNonzeroLengthText} = databricks.internal.configurationprofile.ConfigFile.getDefaultProfileName
    end

    args = matlab.utils.addArgs(options, ["authMethod", "profileName"]);
    jobs = databricks.Job.list(args{:});

    jobNames = string({jobs.name});

    idcs = jobNames.startsWith(startWith);
    
    jobs = jobs(idcs);

    jobs.remove()

end