classdef (Abstract) BaseType < handle & matlab.mixin.Heterogeneous
    % BaseType Implementation for types in Compiler workflow

    % Copyright 2024 The MathWorks, Inc.
    properties
        type (1,1) string = ""
    end
    properties (Hidden)
        Parent
    end
    methods
        function obj = BaseType(varargin)
            if nargin > 0
                S = varargin{1};
                if isa(S, 'compiler.build.spark.schema.DataType')
                    obj.type = S.type;
                else
                    error("SPARKAPI:bad_dbasetype_constructor_argument", ...
                        "Bad constructor argument in basetype");
                end
                if nargin > 1
                    obj.Parent = varargin{2};
                end
            end
        end

        function parent = getFileParent(obj)
            parent = obj.Parent;
            if isempty(parent)
                error("SPARKAPI:badly_constructed_datatypes", ...
                    "Parent not set for datatype object");
            end
            if ~isa(parent, 'compiler.build.spark.PythonFileV2')
                % Recurse upwards
                parent = getFileParent(parent);
            end
        end
    end
end
