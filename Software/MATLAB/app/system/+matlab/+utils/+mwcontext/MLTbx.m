classdef MLTbx < matlab.utils.mwcontext.Operation
    % MLTbx Class for MATLAB Toolbox Installer of mw_context
    %
    % This class is used to install a custom MATLAB Toolbox (.mltbx) at
    % startup. No attempt is made to uninstall the toolbox at shutdown. The
    % reason for not doing this is that the clusters where this is used
    % are, in general, ephemeral.

    % Copyright 2026 The MathWorks, Inc.

    properties
        mltbxLocation string {JSONMapper.fieldName(mltbxLocation, "mltbx_location")}
        agreeToLicense logical {JSONMapper.fieldName(agreeToLicense, "agree_to_license")} = false
        context string
    end

    methods
        function obj = MLTbx(s, inputs)
            arguments
                s {JSONMapper.ConstructorArgument} = []
                inputs.?matlab.utils.mwcontext.MLTbx
            end
            obj = obj.initialize(s,inputs);
        end

        function startup(obj)
            fprintf("\tInstalling toolbox from %s\n", obj.mltbxLocation);
            try
                infoTbx = matlab.addons.toolbox.installToolbox(obj.mltbxLocation, obj.agreeToLicense);
                fprintf("\tInstalled %s (version %s)\n", infoTbx.Name, infoTbx.Version);
            catch ME
                fprintf(2, "Failed to install toolbox %s\n", obj.mltbxLocation);
                fprintf(2, "Error: %s\n", ME.message);
            end

        end

    end
end
