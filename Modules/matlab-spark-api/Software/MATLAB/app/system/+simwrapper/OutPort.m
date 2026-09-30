classdef OutPort < simwrapper.Port
    % OutPort Outport class for code generation

    properties
    end
    methods
        function obj = OutPort(idx, po, parent)
            obj@simwrapper.Port(idx, po, parent)
        end
    end
end