function tf = checkLeadingDBFS(varargin)
% CHECKLEADINGDBFS Checks if a value is begins with /dbfs of dbfs:
% form a databricks.matlab.utils.LocationForm enumeration is used to denote if
% the value is of PATH or URI form. PATH corresponds to /dbfs and URI to dbfs:
% In the case of PATH the value is checked for lower case. In the case of URI
% check is case insensitive. Value can be a character vector or scalar string.
% A logical true is returned if the condition is met otherwise a false is
% returned.
%
% Example
%    tf = checkLeadingDBFS('DBFS:', LocationForm.URI);

%   (c) 2020 The MathWorks, Inc.

p = inputParser;
p.CaseSensitive = false;
validString = @(x) ischar(x) || isStringScalar(x);
p.FunctionName = mfilename;
addRequired(p, 'value', validString);
addRequired(p, 'form', @(x)isa(x,'matlab.utils.LocationForm'));
parse(p, varargin{:});

cValue = char(p.Results.value);
if p.Results.form == matlab.utils.LocationForm.PATH
    if strcmp(cValue(1:5), '/dbfs')
        tf = true;
    else
        tf = false;
    end
elseif p.Results.form == matlab.utils.LocationForm.URI
    if strcmpi(cValue(1:5), 'dbfs:')
        tf = true;
    else
        tf = false;
    end
else
    error('DATABRICKS:ERROR', 'Unsupported matlab.utils.LocationForm');
end

end
