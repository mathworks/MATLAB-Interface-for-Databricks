function deleteUnitTestData(startWiths, options)
    % deleteUnitTestData Delete unit-test data
    %
    % The tests run by JobTester tend to create a large amount of data, as
    % well as cluttering workspaces and workflows with notebooks and jobs.
    % This is an umbrella function deleting a lot of the old stuff.
    %
    % For the moment, it just takes one argument, startWith, which gives a
    % string that removes all jobs starting with this string.
    % Typical arguments here can be "LOCAL", for deleting all jobs started
    % from the desktop, or e.g. 613, for all pipeline jobs whose pipeline
    % number starts with 613.
    %
    % The input can also be a vector of startWiths, e.g. ["91", "92"]

    % Copyright 2022-2024 The MathWorks, Inc.
    
    arguments
        startWiths string
        options.authMethod string {mustBeTextScalar, mustBeNonzeroLengthText}
        options.profileName string {mustBeTextScalar, mustBeNonzeroLengthText} = databricks.internal.configurationprofile.ConfigFile.getDefaultProfileName
    end

    args = matlab.utils.addArgs(options, ["authMethod", "profileName"]);

    for startWith=startWiths

        databricks.internal.utils.deleteDBFSFolders('/unit-tests', startWith, args{:})

        databricks.internal.utils.deleteWorkspaces('/Shared/UnitTests', startWith, args{:})

        databricks.internal.utils.deleteJobs("basesparkbuilder_test_" + startWith, args{:});

    end
end
