% UploadTestDataToAWS Upload the test dataset to AWS
% 
% (c)2020 MathWorks, Inc.

fList = dir('tmp/*.parquet');
for fCount = 1:numel(fList)
    
    file = fList(fCount);
    disp(['Uploading: ',file.name]);
    
end


% DEAD CODE
% tic;
% s3.putObject('mathworks-databricks/oregon-prod/1339781257718886/test/randomdata','sample002.parquet')
% toc;
% tic;
% s3.putObject('mathworks-databricks/oregon-prod/1339781257718886/test/randomdata','sample003.parquet')
% toc;
% tic;
% s3.putObject('mathworks-databricks/oregon-prod/1339781257718886/test/randomdata','sample004.parquet')
% toc;
% tic;
% s3.putObject('mathworks-databricks/oregon-prod/1339781257718886/test/randomdata','sample005.parquet')
% toc;