classdef LogSaveInputs < handle
    %LogSaveInputs input arguments shared by save_model and log_model
    
    % Copyright 2023 MathWorks, Inc.    
    properties
        FunctionFile string
        MATLABFiles string
        AdditionalFiles string
        Network
        IncludeMPSCTF logical = false
        IncludeMATLABMLflowModule = true
        Path string
        SubFlavor string {mustBeMember(SubFlavor, ...
            ["none","onnx","compiler_sdk_python","coder"])}
        PackageName string
        ExampleInputs cell
        ExampleOutputs cell
        NParams int32 = 0
        ExactDimensions logical = false
        SaveExample logical = true
        MLflowOptions cell = {}
        RegisteredModelName string
    end

    methods
        function opts = LogSaveInputs(options)
            for p = string(fieldnames(options))'
                opts.(p) = options.(p);
            end
        end
    end

end