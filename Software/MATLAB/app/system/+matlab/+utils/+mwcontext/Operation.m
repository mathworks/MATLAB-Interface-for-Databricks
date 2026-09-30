classdef Operation < JSONMapper & matlab.mixin.Heterogeneous
    % Operation Class for operations of mw_context
    %
    % This class is the heterogeneous parent of the subclasses actually
    % doing any operations. The currently existing subclasses can be seen
    % in the discriminator list in the properties.

    % Copyright 2026 The MathWorks, Inc.

    properties
        type string {JSONMapper.discriminator(type, "Copy", "matlab.utils.mwcontext.Copy", "MLTbx", "matlab.utils.mwcontext.MLTbx")}
    end

    methods
        function obj = Operation(s, inputs)
            arguments
                s {JSONMapper.ConstructorArgument} = []
                inputs.?matlab.utils.mwcontext.Operation
            end
            obj = obj.initialize(s,inputs);
        end

        function str = string(obj)
            str = sprintf("Operation<%s>", obj.type);
        end
        function startup(obj)
            fprintf("\tNo startup for %s in MATLAB\n", string(obj));
        end
        function shutdown(obj)
            fprintf("\tNo shutdown for %s in MATLAB\n", string(obj));
        end
    end

end