function args = addArgs(varargin)
% addArgs Builds a named argument cell array
%
% Returns a 1D cell array of pairs of argument names followed by
% values.
% Argument names are returned as strings.
%
% If the structure options contains a field named in the string array
% argNames the name and value are added to the result.
%
% Duplicate arguments are overwritten.
% Named option arguments overwrite initial arguments.
% In both initial arguments the last entry is used.
% In named arguments repeated name values have no effect as the struct can
% only have one field with a given name.
%
% Initial arguments must be provided as a 1D cell array with pair of scalar
% text labels followed by argument values.
%
% Examples:
%   args = matlab.utils.addArgs(options, ["authMethod", "profileName"]);
%   x = myFunc(args{:});

% TODO Consider extending to allow populating based on named object properties in
% addition to struct fields

%   (c) 2024-2026 MathWorks, Inc.

args = matlab.internal.utils.addArgs(varargin{:});
end
