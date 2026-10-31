function setType(obj, libType, varargin)
    % SETTYPE Method to specify what kind of Library
    % Changing the type of library will empty the current value to reduce the
    % chance of misconfiguration.
    %
    %   lib = databricks.Libary();
    %   lib.setType('jar');
    %
    % The type of the library can be:
    %   'jar'           Java Library
    %   'egg'           Python zip compressed egg file
    %   'whl'           Python package in the Wheel format
    %   'pypi'          PyPi coordinates
    %   'maven'         Maven coordinates
    %   'cran'          CRAN coordinates
    %   'requirements'  Requirements specifications
    %
    % Only one can be specified. If you need multiple libraries, please create
    % an array of these objects.

    %   (c) 2019-2024 MathWorks, Inc.

    validOption = @(x) strcmpi(x,{'jar','egg','whl','pypi','maven','cran', 'requirements'});

    if (ischar(libType)||isstring(libType)) && any(validOption(libType))
        % Valid option
        iClearAndAddProperty(obj,char(lower(libType)))
    else
        % Invalid string/char
        error('DATABRICKS:INVALID','Specify the library type as jar, egg, whl, pypi, mavenm, cran or requirements');
    end


end %function

function iClearAndAddProperty(obj,libCandidate)
    props = fieldnames(obj);
    for pCount=1:numel(props)
        candidateProp = props{pCount};
        if any(strcmpi(candidateProp,{'jar','egg','whl','pypi','maven','cran', 'requirements'}))
            prop = findprop(obj, candidateProp);
            delete(prop);
        end
    end
    addprop(obj,libCandidate);
    obj.(libCandidate)='';
end
