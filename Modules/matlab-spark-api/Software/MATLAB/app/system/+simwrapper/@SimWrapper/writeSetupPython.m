function cName = writeSetupPython(swo)
    % writeSetupPython Generate setup file for wheel creation

    % Copyright 2025 MathWorks, Inc.

    arguments
        swo (1,1) simwrapper.SimWrapper
    end

    pkg = swo.PyPackageName;
    pkgParts = split(pkg, ".");
    N_PARTS = numel(pkgParts);
    pkgTop = pkgParts(1);

    mdl = string(swo.CI.Name);
    soSrc = fullfile("..", mdl + ".so");
    soDst = fullfile(pwd, join(pkgParts, filesep));
    copyfile(soSrc, soDst);

    fileName = "setup.py";
    SW = matlab.sparkutils.StringWriter(fileName);

    SW.pf("## Copyright, 2015-2025 The MathWorks, Inc.\n\n");

    SW.pf("from setuptools import setup\n\n");

    SW.pf("if __name__ == '__main__':\n\n");
    SW.indent();
    SW.pf("setup(\n");
    SW.indent();
    SW.pf("name='%s',\n", pkg);
    SW.pf("version='%s',\n", getRelease());
    SW.pf("description='A Python interface to %s',\n", pkgTop);
    SW.pf("author='MathWorks',\n");
    SW.pf("url='https://www.mathworks.com/',\n");
    % TODO: Change platforms to show only the one it's currently on, or
    % maybe the one it's compiled for, if we open up for cross compilation.
    % For Spark/Databricks, the interest will focus on Linux.
    SW.pf("platforms=['Linux'],\n");
    SW.pf("packages=[\n");
    SW.indent();
    comma = ",";
    for k=1:N_PARTS
        if k==N_PARTS, comma = ""; end
        tmpParts = pkgParts(1:k);
        SW.pf("'%s'%s\n", join(tmpParts, "."), comma);
    end
    SW.unindent();
    SW.pf("],\n");
    SW.pf("package_data={'%s': ['*.so']}\n", pkg);
    SW.unindent();

    SW.pf(")\n\n");
    SW.unindent();

    SW.pf("## End of file: %s \n\n", fileName);
end

function R = getRelease()
    x = ver('matlab');
    R = string(x.Version) + ".0";
end
