function strs = getImports(obj, options)
    % getImports Return imports from files

    % Copyright 2024 The MathWorks, Inc.

    arguments
        obj (1,1) compiler.build.spark.PythonSparkBuilder
        options.debug (1,1) logical = false
    end

    for k=1:length(obj.Files)
        if k==1
            strs = getImports(obj.Files(k), debug=options.debug);
        else
            strs = [strs; getImports(obj.Files(k), debug=options.debug)]; %#ok<AGROW>
        end
    end

    if nargout == 0
        fprintf("%s\n", strs);
        clear('strs');
    end

end



