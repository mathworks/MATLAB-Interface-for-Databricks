function link = URL2Link(varargin)
% URL2LINK Returns a URL value as a href'd link
% Non HTTP links should be absolute paths.
% UNC paths are not currently supported.
%
% Example:
%   link = matlab.utils.URL2Link("https://mathworks.com");

%  (c) 2024-2026 MathWorks, Inc.

link = matlab.internal.utils.URL2Link(varargin{:});
end
