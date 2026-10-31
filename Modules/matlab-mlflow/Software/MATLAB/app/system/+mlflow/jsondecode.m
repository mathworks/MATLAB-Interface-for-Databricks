function varargout = jsondecode(varargin)
% JSONDECODE Overrides builtin jsondecode, adds field type support see jsondecodeTypedValues

%  (c) 2021 MathWorks, Inc. 

[varargout{1:nargout}] = jsondecodeTypedValues(varargin{:});

end