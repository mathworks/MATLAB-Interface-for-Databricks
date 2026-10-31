function type = getType(obj)
% GETTYPE Method to return the type of the library
% If the type is unknown an empty character vector is returned.
% Known types are: jar, egg, whl, pypi, maven, cran & requirements

% (c) 2020-2024 MathWorks, Inc.

% Get prop 
for prop = {'jar','egg','whl','pypi','maven','cran', 'requirements'}
    if isprop(obj,prop{1})
        type = prop{1};
        return;
    else
        type = '';
    end
end

end %function
