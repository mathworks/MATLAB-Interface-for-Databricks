function uploadDownloadFiles()
    % uploadDownloadFiles Upload test data
    %
    % These files are used in the test 'testDBFS/testRecursiveDownload'.

    % (c)2021 MathWorks, Inc.

    dbfsBase = '/MathWorks/unit-test/downloads';

    here = fileparts(mfilename('fullpath'));
    folder = fullfile(here, 'download');
    files = dir(folder);

    db = databricks.DBFS();
    recursiveUpload(db, files, folder, dbfsBase);


end

function recursiveUpload(db, files, baseFolder, dbfsBase)

    for k=1:length(files)
        F = files(k);
        if strcmp(F.name, '.') || strcmp(F.name, '..')
            continue;
        end
        fullName = fullfile(F.folder, F.name);
        if F.isdir
            subFiles = dir(fullName);
            recursiveUpload(db, subFiles, baseFolder, dbfsBase);
        else
            partName = fullName(length(baseFolder)+1:end);
            partFolder = fileparts(partName);
            dbfsDest = [dbfsBase, partFolder];
            db.upload(fullName, dbfsDest)
        end
    end
end