classdef (Abstract) Transformer < handle

    properties (SetAccess=private)
        SW      matlab.sparkutils.StringWriter
        JW      matlab.sparkutils.JavaWriter
        F       compiler.build.spark.File
        % Parent
    end

    methods
        function obj = Transformer(file)
            obj.F = file;
            % if file.isPythonBuild
            %     obj.Parent = file.Parent;
            %     obj.SW = Parent.SW;
            % else
            %     obj.Parent = file.
        end
    end

    % Functions that must be implemented by subclasses
    % methods (Abstract)
    % end

end