function clean(obj)
    % clean Clean the build

    % Copyright 2022 The MathWorks, Inc.

    if isfolder(obj.OutputDir)
        fprintf("Removing %s to ensure clean build ...\n", obj.OutputDir);
        outDir = obj.OutputDir;
        paths = split(string(path), pathsep);
        idcs = find(paths.startsWith(outDir));
        for k=1:length(idcs)
            p = paths(idcs(k));
            fprintf("Removing path: %s\n", p);
            rmpath(p);
        end
        rmdir(obj.OutputDir, 's');
    end

end
