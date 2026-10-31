classdef MATLABWriter < matlab.sparkutils.StringWriter
    % MATLABWriter A class for writing a MATLAB function
    %
    % This function is based on the general StringWriter class, but has some
    % additional methods for handling sub-functions in consistent manner.

    % Copyright 2025, The MathWorks Inc.

    properties
        SubFuns string
    end

    methods
        function obj = MATLABWriter(varargin)
            obj@matlab.sparkutils.StringWriter(varargin{:});
        end

        function addSubFun(obj, subfun)
            if isa(subfun, 'matlab.sparkutils.StringWriter')
                obj.SubFuns(end+1) = subfun.getString();
            elseif isstring(subfun) || ischar(subfun)
                obj.SubFuns(end+1) = string(subfun);
            else
                error("MATLAB:SPARKAPI", "Unknown argument type");
            end
        end


        function delete(obj)
            for k=1:numel(obj.SubFuns)
                obj.insertLines(obj.SubFuns(k));
            end
        end
    end
end