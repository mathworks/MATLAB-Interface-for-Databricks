classdef testFiles < matlab.unittest.TestCase
    % TESTFILES Unit tests for the DBFS operations
    % Contains unit tests for testing the Files API
    %
    %   t = testFiles;
    %   run(t);
    %
    % Tests in this suite rely on the authentication being provided.

    %  (c) 2024 MathWorks, Inc.
    properties
        FixtureDir
    end

    methods (TestClassSetup)
        function tcSetup(testCase)
            obj = databricks.Object();
            obj.getAuth();
        end
    end

    methods (TestMethodSetup)
        function testSetup(testCase)
            import matlab.unittest.fixtures.TemporaryFolderFixture;
            import matlab.unittest.fixtures.CurrentFolderFixture;

            % Create a temporary folder and make it the current working
            % folder.
            tempFolder = testCase.applyFixture(TemporaryFolderFixture);
            testCase.applyFixture(CurrentFolderFixture(tempFolder.Folder));
            testCase.FixtureDir = '/Volumes/main/default/myvolume/UnitTestFilesFixtureDir/';

        end
    end

    methods (TestMethodTeardown)
        function testTearDown(testCase) %#ok<MANU>
        end
    end

    methods (Test)
        function testConstructor(testCase)
            disp("Running testConstructor");
            % Default constructor
            f1 = databricks.Files;
            testCase.verifyInstanceOf(f1, 'databricks.Files');

            % Use host/token constructor
            f2 = databricks.Files("Host", f1.Host, "Token", f1.Token, "Org_id", f1.Org_id);

            % Verify
            testCase.verifyEqual(f1.Host, f2.Host);
            testCase.verifyEqual(f1.Token, f2.Token);
            testCase.verifyEqual(f1.Org_id, f2.Org_id);
        end

        function testPropertyInitialization(testCase)
            disp("Running testPropertyInitialization");
            % Create a databricks Files interface
            f = databricks.Files();

            % Set the host
            f.Host = 'https://dbc-8c2a59a7-10f3.cloud.databricks.com';

            % Check that the interface found the token file correctly
            testCase.assertNotEmpty(f.Token);
        end

        function testListFiles(testCase)
            disp("Running testListFiles");            
            % Assumes '<testCase.FixtureDir>/listTest/<file01-file10>.txt'
            
            % Create a databricks DBFS interface
            f = databricks.Files();

            % List the contents of the unit test dir root
            fileList = f.list(testCase.FixtureDir);
            testCase.verifyClass(fileList, "databricks.datastructures.files.ListResponse");
            testCase.verifyTrue(isprop(fileList, 'contents'));
            testCase.verifyNotEmpty(fileList.contents);
            testCase.verifyClass(fileList.contents(1), "databricks.datastructures.files.DirectoryEntry");

            fileList = f.list(sprintf('%s/%s', testCase.FixtureDir , 'listTest'));
            testCase.verifyEqual(numel(fileList.contents), 10);
    
            pFileList = f.listPaginated(sprintf('%s/%s', testCase.FixtureDir, 'listTest'), pageSize=int64(5));
            testCase.verifyTrue(isprop(pFileList, 'contents'));
            testCase.verifyNotEmpty(pFileList.contents);
            testCase.verifyClass(pFileList.contents(1), "databricks.datastructures.files.DirectoryEntry");
            testCase.verifyEqual(numel(pFileList.contents), 5);
            
            testCase.verifyTrue(isprop(pFileList, 'nextPageToken'));
            testCase.verifyClass(pFileList.nextPageToken, "string");
            testCase.verifyTrue(strlength(pFileList.nextPageToken) > 0);

            pFileList2 = f.listPaginated(sprintf('%s/%s', testCase.FixtureDir , 'listTest'), pageSize=int64(5), pageToken=pFileList.nextPageToken);
            testCase.verifyTrue(isprop(pFileList2, 'contents'));
            testCase.verifyNotEmpty(pFileList2.contents);
            testCase.verifyClass(pFileList2.contents(1), "databricks.datastructures.files.DirectoryEntry");
            testCase.verifyEqual(numel(pFileList2.contents), 5);
            
            testCase.verifyTrue(isprop(pFileList2, 'nextPageToken'));
            testCase.verifyClass(pFileList2.nextPageToken, "string");
            testCase.verifyEmpty(pFileList2.nextPageToken);
        end

        function testCreateRmDirectory(testCase)
            disp("Running testCreateRmDirectory");
            % Create a databricks DBFS interface
            f = databricks.Files();

            tmpPath = testCase.FixtureDir + string((java.util.UUID.randomUUID));
            testCase.assertTrue(f.create(tmpPath));

            % List contents of the newly created folder
            fileList = f.list(tmpPath);
            testCase.assertEmpty(fileList.contents);

            % Remove the temporary folder
            testCase.assertTrue(f.rmdir(tmpPath));
        end


        function testUploadDownload(testCase)
            disp("Running testUploadDownload");
            % Tune this to stress test the upload
            % Array Size
            arraySize = 500; % will create 500x500 array ~1.9Mb.
            % arraySize = 1000; % will create 1000x1000 array ~7.1Mb.

            % Create a databricks DBFS interface
            f = databricks.Files();

            % Create a test folder (assumes that /tmp exists)
            tmpRemoteFolder = testCase.FixtureDir + "/tmp/" + string(java.util.UUID.randomUUID);
            testCase.assertTrue(f.create(tmpRemoteFolder));

            % Create a dummy file locally
            localPath = [tempname,'.mat'];
            % Put some dummy data into it
            data = rand(arraySize,arraySize); % sized accordingly
            save(localPath,'data');

            % Upload the file
            remoteFile = tmpRemoteFolder + "/uploadedfile.mat";
            testCase.assertTrue(f.upload(localPath, remoteFile));

            % TODO pending ls fixes
            % % Ensure that we can see the file
            % testFile = db.ls(tmpFolder).path;
            % testCase.assertNotEmpty(testFile);

            % download the file
            % Ensure that what we sent up is what we got back
            downloadFile = [tempname,'.mat'];
            testCase.assertTrue(f.download(remoteFile, destination=downloadFile));

            % Remove the temporary folder
            testCase.assertTrue(f.rm(remoteFile));
            testCase.assertTrue(f.rmdir(tmpRemoteFolder));

            outData = load(downloadFile);
            testCase.assertEqual(data, outData.data);

            % Cleanup local file
            delete(downloadFile);
            delete(localPath);
        end


        function testDirectoryMetadata(testCase)
            disp("Running testDirectoryMetadata");
            % Create a databricks Files interface
            f = databricks.Files();

            % Call the getStatus
            remoteFolder = testCase.FixtureDir;
            md = f.directoryMetadata(remoteFolder);

            % This is a new folder so we can assert a few things
            testCase.verifyNotEmpty(md);
            testCase.verifyEqual(md.exists, true);
        end


        function testFileMetadata(testCase)
            disp("Running testFileMetadata");
            arraySize = 5;
            % Create a dummy file locally
            localPath = [tempname,'.mat'];
            % Put some dummy data into it
            data = rand(arraySize,arraySize); % sized accordingly
            save(localPath,'data');
            cleanup = onCleanup(@() delete(localPath));

            % Create a databricks DBFS interface
            f = databricks.Files();
            % Create a test folder
            tmpRemoteFolder = testCase.FixtureDir + "/tmp/" + string(java.util.UUID.randomUUID);
            testCase.assertTrue(f.create(tmpRemoteFolder));
            remoteFile = tmpRemoteFolder + "/tmp.mat";
            testCase.assertTrue(f.upload(localPath, remoteFile));

            % Call the getStatus
            md = f.fileMetadata(remoteFile);

            % This is a new folder so we can assert a few things
            testCase.verifyNotEmpty(md);
            testCase.verifyEqual(md.contentType, "application/octet-stream");
            testCase.verifyTrue(isprop(md, "contentLength"));
            testCase.verifyClass(md.contentLength, "int64");
            testCase.verifyGreaterThan(md.contentLength, int64(100));
            testCase.verifyTrue(isprop(md, "lastModified"));
            testCase.verifyClass(md.lastModified, "datetime");

            % Remove the temporary folder
            testCase.assertTrue(f.rm(remoteFile));
            testCase.assertTrue(f.rmdir(tmpRemoteFolder));
        end
    end % methods
end % class
