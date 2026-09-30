classdef testDBFS < matlab.unittest.TestCase
    % TESTDBFS Unit tests for the DBFS operations
    % Contains unit tests for testing the Cluster API
    %
    %   t = testDBFS;
    %   run(t);
    %
    % Tests in this suite rely on the authentication being provided.
    
    %  (c) 2019-2022 MathWorks, Inc.
    
    methods (TestMethodSetup)
        function testSetup(testCase)
            import matlab.unittest.fixtures.TemporaryFolderFixture;
            import matlab.unittest.fixtures.CurrentFolderFixture;
            
            % Create a temporary folder and make it the current working
            % folder.
            tempFolder = testCase.applyFixture(TemporaryFolderFixture);
            testCase.applyFixture(CurrentFolderFixture(tempFolder.Folder));
            
        end
    end
    
    methods (TestMethodTeardown)
        function testTearDown(testCase) %#ok<MANU>
            
        end
    end
    
    methods (Test)
        function testConstructor(testCase)
            % Default constructor
            db1 = databricks.DBFS;
            testCase.verifyInstanceOf(db1, 'databricks.DBFS');
            
            % Use host/token constructor
            if isempty(db1.Org_id) || strlength(db1.Org_id) == 0
                db2 = databricks.DBFS(Host=db1.Host, Token=db1.Token);
            else
                db2 = databricks.DBFS(Host=db1.Host, Token=db1.Token, Org_id=db1.Org_id);
            end

            % Verify
            testCase.verifyEqual(db1, db2);
        end
        
        function testPropertyInitialization(testCase)
            % Create a databricks DBFS interface
            db = databricks.DBFS();
            
            % Set the host
            db.Host = 'https://dbc-8c2a59a7-10f3.cloud.databricks.com';
            
            % Check that the interface found the token file correctly
            testCase.assertNotEmpty(db.Token);
            
        end
        
        function testListFiles(testCase)
            % Create a databricks DBFS interface
            db = databricks.DBFS();
            
            % List the contents of the root system
            fileList = db.ls();
            testCase.assertClass(fileList,'table');
            
            % With a path
            fileList = db.ls('/');
            testCase.assertClass(fileList,'table');
            
            % Return as an object
            fileObj = db.listFiles('/');
            testCase.assertClass(fileObj,'databricks.datastructures.FileInfo');
        end
        
        function testMakeRemoveFolder(testCase)
            % Create a databricks DBFS interface
            db = databricks.DBFS();
            
            % Create a test folder (assumes that the /tmp folder exists)
            tmpFolder = ['/tmp/' char(java.util.UUID.randomUUID)];
            db.mkdir(tmpFolder);
            
            % List contents of the newly created folder
            fileList = db.ls(tmpFolder);
            testCase.assertEmpty(fileList);
            
            % Remove the temporary folder
            db.rm(tmpFolder)
        end
        
        function testUploadRecursiveDelete(testCase)
            % Create a databricks DBFS interface
            db = databricks.DBFS();
            
            % Create a test folder (assumes that /tmp exists)
            tmpFolder = ['/tmp/' char(java.util.UUID.randomUUID)];
            db.mkdir(tmpFolder);
            
            % Create a dummy file locally
            fullPath = [tempname,'.mat'];
            
            % Throw some dummy data into it
            data = rand(500,500); % 1.9Mb approx
            save(fullPath,'data');
            
            % Upload the file into DBFS
            db.upload(fullPath,tmpFolder);
            
            % List status of the uploaded file
            uploadedFile = db.ls(tmpFolder).path;
            testCase.assertNotEmpty(uploadedFile);
            
            % Remove the temporary folder (and contents recursively)
            db.rm(tmpFolder, true);
        end
        
        function testUploadDownload(testCase)
            % Tune this to stress test the upload
            % Array Size
            arraySize = 500; % will create 500x500 array ~1.9Mb.
            % arraySize = 1000; % will create 1000x1000 array ~7.1Mb.
            
            % Create a databricks DBFS interface
            db = databricks.DBFS();
            
            % Create a test folder (assumes that /tmp exists)
            tmpFolder = ['/tmp/' char(java.util.UUID.randomUUID)];
            db.mkdir(tmpFolder);
            
            % Create a dummy file locally
            fullPath = [tempname,'.mat'];
            
            % Throw some dummy data into it
            data = rand(arraySize,arraySize); % sized accordingly
            save(fullPath,'data');
            
            % Upload the file into DBFS
            db.upload(fullPath,tmpFolder);
            
            % Ensure that we can see the file
            testFile = db.ls(tmpFolder).path;
            testCase.assertNotEmpty(testFile);
            
            % download the file
            db.download(testFile);
            
            % Remove the temporary folder
            db.rm(tmpFolder, true);
            
            % Ensure that what we sent up is what we got back
            [~,filename,ext]=fileparts(testFile);
            downloadFile = filename + ext;
            
            outData = load(downloadFile);
            testCase.assertEqual(data,outData.data);
            
            % Cleanup local file
            delete(downloadFile);
            delete(fullPath);
        end

        function testUploadDownloadSilent(testCase)
            % Tune this to stress test the upload
            % Array Size
            arraySize = 500; % will create 500x500 array ~1.9Mb.
            % arraySize = 1000; % will create 1000x1000 array ~7.1Mb.
            
            % Create a databricks DBFS interface
            db = databricks.DBFS();
            
            % Create a test folder (assumes that /tmp exists)
            tmpFolder = ['/tmp/' char(java.util.UUID.randomUUID)];
            db.mkdir(tmpFolder);
            
            % Create a dummy file locally
            fullPath = [tempname,'.mat'];
            
            % Throw some dummy data into it
            data = rand(arraySize,arraySize); % sized accordingly
            save(fullPath,'data');
            
            % Upload the file into DBFS
            db.upload(fullPath,tmpFolder,'silent',true);
            
            % Ensure that we can see the file
            testFile = db.ls(tmpFolder).path;
            testCase.assertNotEmpty(testFile);
            
            % download the file
            db.download(testFile,'silent',true);
            
            % Remove the temporary folder
            db.rm(tmpFolder, true);
            
            % Ensure that what we sent up is what we got back
            [~,filename,ext]=fileparts(testFile);
            downloadFile = filename + ext;
            
            outData = load(downloadFile);
            testCase.assertEqual(data,outData.data);
            
            % Cleanup local file
            delete(downloadFile);
            delete(fullPath);
        end
        
        function testRecursiveDownload(testCase)
            % assumes /test/unit-test-data/download exists
            dlBase = '/MathWorks/unit-test/downloads';
            db = databricks.DBFS();
            
            folders = db.ls(dlBase);
            H = height(folders);
            testCase.assertEqual(sum(folders.is_dir), H, 'There should be only folders');
            testCase.assertEqual(sum(~folders.is_dir), 0, 'There shouldn''t be any files');
            
            tmpFolder = 'mytmp';
            srcFolder = dlBase;

            outFiles = db.download(srcFolder, 'outfolder', tmpFolder, 'recurse', true);
            testCase.verifyNotEqual(exist(tmpFolder, 'dir'), 0, ...
                'The outfolder should have been created');
            testCase.verifyTrue(isstring(outFiles), 'The list of files should be a string array');
            testCase.verifyTrue(length(outFiles) > 1, 'The list of files should have more than one entry');
            
            % Check that it works when the folder has an ending slash
            srcFolder = [srcFolder,'/'];
            tmpFolder = 'other';

            outFiles = db.download(srcFolder, 'outfolder', tmpFolder, 'recurse', true);
            testCase.verifyNotEqual(exist(tmpFolder, 'dir'), 0, ...
                'The outfolder should have been created');
            testCase.verifyTrue(isstring(outFiles), 'The list of files should be a string array');
            testCase.verifyTrue(length(outFiles) > 1, 'The list of files should have more than one entry');
           
            % Check that a cell array can be download recursively
            tmpFolder = 'third';
            srcFolders = {...
                [dlBase, '/a/b/M5.mat'], ...
                [dlBase, '/c/M5.parquet'], ...
                };
            outFiles = db.download(srcFolders, 'outfolder', tmpFolder, 'recurse', true);
            testCase.verifyNotEqual(exist(tmpFolder, 'dir'), 0, ...
                'The outfolder should have been created');
            testCase.verifyTrue(isstring(outFiles), 'The list of files should be a string array');
            testCase.verifyTrue(length(outFiles) > 1, 'The list of files should have more than one entry');
        end
        
        function testGetStatus(testCase)            
            % Create a databricks DBFS interface
            db = databricks.DBFS();
            
            % Create a test folder (assumes that the /tmp folder exists)
            tmpFolder = ['/tmp/' char(java.util.UUID.randomUUID)];
            db.mkdir(tmpFolder);
            
            % Call the getStatus
            fileStatus = db.getStatus(tmpFolder);
            
            % This is a new folder so we can assert a few things
            testCase.verifyNotEmpty(fileStatus.path);
            testCase.verifyEqual(fileStatus.is_dir, true); % directory
            testCase.verifyEqual(fileStatus.file_size, int64(0)); % empty
            
            % Clean up
            db.rm(tmpFolder);
        end
        
        function testVectorizedDownloadTableCell(testCase)            
            try
                % Small files
                arraySize = 10;
                vectorSize = 10;
                
                % Create a databricks DBFS interface
                db = databricks.DBFS();
                
                % Create a test folder (assumes that the /tmp folder exists)
                tmpFolder = ['/tmp/' char(java.util.UUID.randomUUID)];
                db.mkdir(tmpFolder);
                
                fullPath = cell(vectorSize,1);
                
                % Create a number of small upload files
                for vCount = 1:vectorSize
                    % Create a dummy file locally
                    fullPath{vCount} = [tempname,'.mat'];
                    
                    % Throw some dummy data into it
                    data = rand(arraySize,arraySize); % sized accordingly
                    save(fullPath{vCount},'data');
                end
                
                % Push up the files into DBFS (vectorized)
                db.upload(fullPath, tmpFolder);
                
                % Delete all local content
                for uCount = 1:numel(fullPath)
                    delete(fullPath{uCount});
                end
                
                % Vectorized download
                tableList = db.ls(tmpFolder);
                downloadList = db.download(tableList);
                
                % Clean up
                for dCount = 1:numel(downloadList)
                    delete(downloadList{dCount});
                end
            catch ME
                testCase.assertTrue(false, ['Something went wrong with list of uploads/downloads', ME.message]);
            end            
        end

        function testUploadEdgeCases(testCase)
            % create a small tmp file
            data = rand(50); 
            fullLocalPath = [tempname,'.mat'];
            save(fullLocalPath,'data');
                
            % Create a databricks DBFS interface
            db = databricks.DBFS();
                            
            % Test upload with no destination folder
            % Assumes can write to /MATLAB/ and create it if required
            db.upload(fullLocalPath);
            [~, fname, ext] = fileparts(fullLocalPath);
            info = db.getStatus(['/MATLAB/', fname, ext]);
            testCase.assertNotEmpty(info);
            testCase.verifyTrue(isa(info, 'databricks.datastructures.FileInfo'));
            testCase.verifyTrue(strcmp(info.path, ['/MATLAB/', fname, ext]));
            % cleanup 
            db.rm(['/MATLAB/', fname, ext]);
            
            % Create a test folder (assumes that /tmp exists and is writable)
            % upload a file with no trailing slash
            % Also validates a folder is created if required
            tmpDBFolder = ['/tmp/' char(java.util.UUID.randomUUID)];
            % db.mkdir(tmpFolder); % a folder should be created if required
            db.upload(fullLocalPath, tmpDBFolder);
            info = db.getStatus([tmpDBFolder, '/' fname, ext]);
            testCase.assertNotEmpty(info);
            testCase.verifyTrue(isa(info, 'databricks.datastructures.FileInfo'));
            testCase.verifyTrue(strcmp(info.path, [tmpDBFolder, '/', fname, ext]));
            testCase.verifyFalse(info.is_dir);
            % Remove the temporary folder & contents
            db.rm(tmpDBFolder, true);

            % Test that there is an error if file would overwrite a directory
            % Create folder with the same name as the sample file
            db.mkdir([tmpDBFolder,'/', fname, ext]);
            info = db.getStatus([tmpDBFolder,'/', fname, ext]);
            testCase.assertNotEmpty(info);
            testCase.verifyTrue(isa(info, 'databricks.datastructures.FileInfo'));
            testCase.verifyTrue(info.is_dir);
            testCase.verifyEqual(info.file_size, int64(0));
            try
                db.upload(fullLocalPath, tmpDBFolder);
            catch ME
                testCase.verifyTrue(contains(ME.message, 'RESOURCE_ALREADY_EXISTS'));
                testCase.verifyTrue(contains(ME.message, 'A file or directory already exists at the input path'));                                  
            end
            % Remove the temporary folder & contents
            db.rm(tmpDBFolder, true);
                
            delete(fullLocalPath);
        end
                
    end % methods
    
end % class
