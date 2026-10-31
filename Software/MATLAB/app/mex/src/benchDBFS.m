function T = benchDBFS(N)
    % benchDBFS Benchmark for base64 with DBFS
    % Note: does not support profileName and authMethod arguments

    % Copyright 2020-2022 MathWorks, Inc.

    if nargin == 0
        N = 7;
    end

    tmpDir = tempname;
    mkdir(tmpDir);
    old = cd(tmpDir);
    goBack = onCleanup(@() cleanupDirectory(old, tmpDir));

    [fileNames,sz] = createTestFiles(N);

    % TODO - Support auth arguments
    db = databricks.DBFS;
    benchmarkFolder = '/benchmark-data';

    %% Create directory for benchmark-data
    db.rm(benchmarkFolder, true);
    db.mkdir(benchmarkFolder);

    for k=1:N
        %% Upload
        fprintf('%02d:\n\tUploading %d bytes with mex ...\n', k, sz(k));
        matlab.net.base64('setconfig', 'mex');
        t0 = tic;
        db.upload(fileNames{k}, benchmarkFolder);
        t1MXUp = toc(t0);

        fprintf('\tUploading %d bytes with shipping ...\n', sz(k));
        matlab.net.base64('setconfig', 'shipping');
        t0 = tic;
        db.upload(fileNames{k}, benchmarkFolder);
        t1ShipUp = toc(t0);

        %% Download
        fprintf('%02d:\n\tDownloading %d bytes with mex ...\n', k, sz(k));
        matlab.net.base64('setconfig', 'mex');
        fn = [benchmarkFolder, '/', fileNames{k}];
        t0 = tic;
        db.download(fn);
        t1MXDown = toc(t0);

        fprintf('\tDownloading %d bytes with shipping    ...\n', sz(k));
        matlab.net.base64('setconfig', 'shipping');
        t0 = tic;
        db.download(fn);
        t1ShipDown = toc(t0);

        S(k) = struct(...
            'Size', sz(k), ...
            'MX_Upload', t1MXUp, ...
            'Ship_Upload', t1ShipUp, ...
            'Ratio_Upload', t1ShipUp/t1MXUp, ...
            'MX_Download', t1MXDown, ...
            'Ship_Download', t1ShipDown, ...
            'Ratio_Download', t1ShipDown/t1MXDown); %#ok<AGROW>
        T = struct2table(S);
    end

    T = struct2table(S);

    db.rm(benchmarkFolder, true);

end

function [fileNames,sz] = createTestFiles(N)
    sz = 10.^(1:N);
    fileNames = cell(N,1);
    for k=1:N
        d = randi(256,1,sz(k),'uint8');
        fileNames{k} = sprintf('data%02d.mat', k);
        save(fileNames{k}, 'd');
    end

end

function cleanupDirectory(old, tmpDir)
    cd(old);
    rmdir(tmpDir, 's');
end
