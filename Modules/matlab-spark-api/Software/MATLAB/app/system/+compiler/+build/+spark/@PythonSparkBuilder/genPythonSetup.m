function genPythonSetup(obj)
    % genPythonSetup Create new setup.py file for install/dist/etc.

    % Copyright 2022-2026 The MathWorks, Inc.

    checkBuildTag(obj);

    outFolder = obj.BuildResults.Options.OutputDir;
    setupFile = fullfile(outFolder, 'setup.py');

    if isfile(setupFile)
        % Delete old version of file, don't care about backup
        delete(setupFile);
    end
    
    SW = matlab.sparkutils.StringWriter(setupFile);
    writeHeader(SW);

    pkgName = string(obj.BuildResults.Options.PackageName);
    SW.pf("name='%s',\n", pkgName);
    
    if ~isempty(obj.versionTag)
        SW.pf("version='%s',\n", obj.versionTag);
    else
        SW.pf("version='%s',\n", getRelease());
    end

    SW.pf("description='A Python interface to %s',\n", obj.BuildResults.Options.PackageName);
    SW.pf("author='MathWorks',\n");
    SW.pf("url='https://www.mathworks.com/',\n");

    if ~isempty(obj.platformsTag)
        SW.pf("platforms=['%s'],\n", join(obj.platformsTag, "', '"))
    else
        % TODO use wheel scan to be more specific
        SW.pf("platforms=['Linux', 'Windows', 'MacOS'],\n");
    end
    
    if checkForOptions(obj)
        writeOptions(SW, obj);
    end

    % Package section - TODO make a separate function
    SW.pf("packages=[\n");
    pkgParts = split(pkgName, ".");
    numPkgParts = length(pkgParts);
    SW.indent();
    for k=1:numPkgParts
        if k==numPkgParts
            delim = '';
        else
            delim = ',';
        end
        SW.pf("'%s'%s\n", join(pkgParts(1:k), "."), delim);
    end
    SW.unindent();
    SW.pf("],\n");
    SW.pf("package_data={'%s': ['*.ctf']}\n", pkgName);
    SW.unindent();

    writeFooter(SW);
end

function R = getRelease()
    v = version;
    T = regexp(v, '(\d+\.\d+\.\d+)', 'tokens', 'once');
    R = T{1};
end


function writeOptions(SW, obj)
    SW.pf("options={\n");
    SW.indent();
    SW.pf('"bdist_wheel": {\n');
    SW.indent();
    if ~isempty(obj.buildTag)
        SW.pf('"build_number": "%s",\n', obj.buildTag);
    end
    SW.unindent();
    SW.pf("},\n");
    SW.unindent();
    SW.pf("},\n");
end

function writeHeader(SW)
    yearStr = datestr(now, 'YYYY');
    SW.pf("# Copyright 2015-%s The MathWorks, Inc.\n\n", yearStr);
    SW.pf("from setuptools import setup\n\n");
    SW.pf("if __name__ == '__main__':\n\n");
    SW.indent();
    SW.pf("setup(\n");
    SW.indent();
end


function writeFooter(SW)
    SW.pf(")\n\n");    
    SW.unindent();
    SW.pf("# End of file\n");
end


function tf = checkForOptions(obj)
    tf = false;
    if ~isempty(obj.buildTag)
        tf = true;
        return;
    end
end

function checkBuildTag(obj)
    if ~isempty(obj.buildTag)
        pat = digitsPattern(1) + wildcardPattern;
        if ~matches(obj.buildTag, pat)
            error("genPythonSetup:buildtag","A build string tag should begin with a digit.");
        end
    end
end