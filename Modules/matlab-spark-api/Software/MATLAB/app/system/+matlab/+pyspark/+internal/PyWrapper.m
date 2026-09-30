classdef PyWrapper < handle
    % PyWrapper - Having a common wrapper for Python objects

    % (c) 2024 MathWorks, Inc.

    methods (Abstract)
        pyObj = toPy(obj)
    end
end