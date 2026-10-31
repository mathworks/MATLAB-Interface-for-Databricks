function path = toolboxDir(tbname)
    % toolboxDir Returns toolbox path based on the built in toolboxdir function
    % directory if it exists and otherwise returns an empty char array.
    % see: doc toolboxdir for more details
    % If a path is not found e.g. a toolbox is not installed this function
    % will not throw an error.

    arguments
        tbname (1,1) string
    end

    % Copyright 2023 The MathWorks, Inc.

    % can't use {mustBeTextScalar} & nonempty for < 20b 
    if strlength(tbname) == 0
        error('Databricks:toolboxDir', 'Expected tbname to be a scalar string or character array of length greater than 0');
    end

    try
        path = toolboxdir(tbname);
    catch ME
        if (strcmp(ME.identifier,'MATLAB:toolboxdir:DirectoryNotFound'))
            path = '';
        else
            rethrow(ME);
        end
    end
end
