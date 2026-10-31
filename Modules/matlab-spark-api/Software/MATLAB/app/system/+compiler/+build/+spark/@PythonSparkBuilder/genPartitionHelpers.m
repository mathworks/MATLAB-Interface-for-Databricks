function genPartitionHelpers(obj)
    % genPartitionHelpers 

    % Copyright 2022 The MathWorks, Inc.

    if ~isfolder(obj.OutputDir)
        mkdir(obj.OutputDir);
        % Make OutputDir an absolute path
        back = cd(obj.OutputDir);
        obj.OutputDir = pwd;
        cd(back);
    end

    obj.GenMatlabDir = fullfile(obj.OutputDir, 'matlab_helpers');
    if ~exist(obj.GenMatlabDir, 'dir')
        mkdir(obj.GenMatlabDir);
    end

    obj.HelperFiles = string.empty;

    for k=1:length(obj.Files)

        F = obj.Files(k);
        mtCandidates = [...
            compiler.build.spark.MethodType.plain, ...
            compiler.build.spark.MethodType.mapPartitions, ...
            compiler.build.spark.MethodType.mapPartitionsTable, ...
            compiler.build.spark.MethodType.applyInPandas, ...
            compiler.build.spark.MethodType.pandasSeries, ...
            ];

        fprintf("### Testing %s: %s\n", F.funcName, join(string(F.MethodTypes), ", "));
        for mt=F.MethodTypes
            if ismember(mt, mtCandidates)
                mhFuncName = string(mt) + "_PythonMATLABHelper";
                fprintf("\t### Found one, running %s generation for %s\n", mhFuncName, F.funcName);
                newFile = feval(mhFuncName, F);

                obj.HelperFiles(end+1) = newFile;
            end
        end
            
    end
end
