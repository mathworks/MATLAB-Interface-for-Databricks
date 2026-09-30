function uploadArtifactsCICD()
    % uploadArtifactsCICD Uploads artifacts as part of build process

    % (c) 2026 MathWorks, Inc.

    verDir = "/Volumes/main/default/myvolume/MathWorks/Versions";
    curVer = matlab.databricks.databricksPackageVersion();
    curVerDir = verDir + "/" + curVer;

    io = databricks.internal.io.IO();

    if ~io.isfolder(curVerDir)
        fprintf("Directory %s does not exist. Creating it.\n", curVerDir);
        io.mkdir(curVerDir);
    else
        fprintf("Directory %s already exists..\n", curVerDir);
    end

    zip_file = dir(databricksRoot(-2, "Internal", "Release", "matlab-databricks-v"+curVer+ ".zip"));

    if isscalar(zip_file)
        artifacts = string(fullfile(zip_file.folder, zip_file.name));
    else
        fprintf(2, "zip_file is not scalar:\n%s\n", formattedDisplayText(zip_file));
        artifacts = string.empty;
    end

    mltbx_file = dir(databricksRoot("matlab-databricks-v" + curVer + ".mltbx"));
    if isscalar(mltbx_file)
        artifacts(end+1) = string(fullfile(mltbx_file.folder, mltbx_file.name));
    else
        fprintf(2, "mltbx_file is not scalar:\n%s\n", formattedDisplayText(mltbx_file));
    end

    for k=1:numel(artifacts)
        [~, f, e] = fileparts(artifacts(k));
        plainName = f + e;
        fprintf("Uploading %s to %s ...", plainName, curVerDir);
        t0=tic;
        io.upload(artifacts(k), curVerDir + "/" + plainName);
        fprintf(" done (%.1f sec.).\n", toc(t0));

    end
end
