classdef InPort < simwrapper.Port
    % InPort Inport class for code generation

    properties
    end
    methods
        function obj = InPort(idx, po, parent)
            obj@simwrapper.Port(idx, po, parent)
        end
    end
end
