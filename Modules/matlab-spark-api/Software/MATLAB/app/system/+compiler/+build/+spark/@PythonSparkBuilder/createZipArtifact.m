function createZipArtifact(obj)
    % createZipArtifact Create a zip-file that will work with zipimporter
    %

    % Copyright 2024-2025 The MathWorks, Inc.

    % TODO: This is currently only in use for Databricks, although Apache
    % Spark with spark-connect might profit from it too.

    arguments
        obj (1,1) compiler.build.spark.PythonSparkBuilder
    end

    old = cd(obj.OutputDir);
    goBackUp = onCleanup(@() cd(old));

    pkgParts = split(obj.PkgName, ".");
    zipTmp = fullfile(pwd, "ZIP_TMP");
    if isfolder(zipTmp)
        rmdir(zipTmp, 's');
    end
    mkdir(zipTmp);
    removeZipTmpAfter = onCleanup(@() rmdir(zipTmp, 's'));

    topPackage = fullfile(pwd, pkgParts(1));
    copyfile(topPackage, fullfile(zipTmp, pkgParts(1)) );
    zipName = fullfile(pwd, obj.PkgName + "_Artifact.zip");
    obj.ZipArtifactName = zipName;

    pkgPartsPath = join(pkgParts, filesep);

    thisFileLoc = fileparts(mfilename('fullpath'));
    deployPkgFile = fullfile(thisFileLoc, "deployablepackagezip.py");
    copyfile(deployPkgFile, fullfile(zipTmp, pkgPartsPath));

    initPyFile = fullfile(zipTmp, pkgPartsPath, '__init__.py');
    rewriteInitPackage(obj, initPyFile);

    cd(zipTmp);
    zippedFiles = zip(zipName, pkgParts(1));

end

function rewriteInitPackage(obj, initPyFile)
    arguments
        obj
        initPyFile string {mustBeTextScalar, mustBeNonzeroLengthText}
    end

    SW = matlab.sparkutils.StringWriter();

    SW.indent();
    SW.pf("def initialize_package(self):\n");
    SW.indent();
    % SW.pf("# package_handle = self.mr_handle.DeployablePackage(self, self.PACKAGE_NAME, __file__)\n");
    SW.pf("print(f'self.PACKAGE_NAME: {self.PACKAGE_NAME}')\n");
    SW.pf("print(f' __file__: { __file__}')\n");
    SW.pf("from %s.deployablepackagezip import DeployablePackageZip\n", obj.PkgName);
    SW.pf("package_handle = DeployablePackageZip(self, self.PACKAGE_NAME, __file__)\n");
    SW.pf("self.instances_of_this_package.add(weakref.ref(package_handle))\n");
    SW.pf("package_handle.initialize()\n");
    SW.pf("return package_handle\n");
    SW.unindent();
    SW.unindent();
    SW.pf('\n');

    ipFunLines = SW.getLines();

    content = readlines(initPyFile);
    lineDefIP = find(contains(content, "def initialize_package"));

    lineDefs = find(contains(content, "def "));

    idxStart = find(lineDefIP==lineDefs);
    toLine = lineDefIP - 1;
    fromLine = lineDefs(idxStart + 1);

    newContent = join([content(1:toLine); ipFunLines; content(fromLine:end)], newline);

    [fh, errmsg] = fopen(initPyFile, 'w');
    if fh < 0
        error('SPARKAPI:REWRITE_INIT_PY_FILE', ...
            'Error writing to file: %s\nMessage: %s\n', initPyFile, errmsg);
    else
        fprintf(fh, '%s\n', newContent);
        whenDone = onCleanup(@() fclose(fh));
    end
end
