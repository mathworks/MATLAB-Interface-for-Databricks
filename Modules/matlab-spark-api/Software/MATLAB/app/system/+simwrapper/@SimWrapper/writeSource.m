function cName = writeSource(swo)
    % writeSource Write source file for wrapper

    % Copyright 2024-2025 MathWorks, Inc.

    arguments
        swo (1,1) simwrapper.SimWrapper
    end

    cName = swo.WrapperName + ".c";
    hName = swo.WrapperName + ".h";

    cw = matlab.sparkutils.StringWriter(cName);


    cw.pf("/* %s\n", cName);
    cw.pf(" * Wrapper for easily simulate from Python.\n")
    cw.pf(" */\n\n");

    cw.pf('#include "%s"\n\n', hName);

    cw.pf("#include <stdlib.h>\n\n");

    cw.pf("/* Get new instance of model */\n")
    cw.pf("%s\n", swo.getInstantiateSignature());
    cw.pf("{\n");
    cw.indent();
    rtmT = swo.getRTModelType();
    extUT = swo.getExtUType();
    extYT = swo.getExtYType();

    mallocCode(cw, "rtm", rtmT);
    mallocCode(cw, "extU", extUT);
    mallocCode(cw, "extY", extYT);
    if swo.hasStates
        statesT = swo.getStatesType();
        mallocCode(cw, "dw", statesT);
    end
    cw.pf("\n");

    if swo.hasStates
        cw.pf("if (rtm == NULL || extU == NULL || extY == NULL || dw == NULL)\n")
    else
        cw.pf("if (rtm == NULL || extU == NULL || extY == NULL)\n")
    end
    cw.pf("{\n");
    cw.indent();
    cw.pf("/* Cleanup and return NULL */\n");
    deallocCode(cw, "rtm");
    deallocCode(cw, "extU");
    deallocCode(cw, "extY");
    if swo.hasStates
        deallocCode(cw, "dw");
    end
    cw.unindent();
    cw.pf("} else {\n");
    cw.indent();
    cw.pf("rtm->inputs = extU;\n")
    cw.pf("rtm->outputs = extY;\n")
    if swo.hasStates
        cw.pf("rtm->dwork = dw;\n")
    end
    cw.unindent();
    cw.pf("}\n\n");
    cw.pf("return rtm;\n");
    cw.unindent();
    cw.pf("}\n\n");

    cw.pf("/* Release instance of model */\n")
    cw.pf("%s\n", swo.getReleaseInstanceSignature());
    cw.pf("{\n");
    cw.indent();
    cw.pf("if (rtm != NULL)\n");
    cw.pf("{\n");
    cw.indent();

    % Inputs?
    cw.pf("if (rtm->inputs != NULL)\n")
    cw.pf("{\n");
    cw.indent();
    cw.pf("free(rtm->inputs);\n")
    cw.unindent();
    cw.pf("}\n");

    % Outputs?
    cw.pf("if (rtm->outputs != NULL)\n")
    cw.pf("{\n");
    cw.indent();
    cw.pf("free(rtm->outputs);\n")
    cw.unindent();
    cw.pf("}\n");


    if swo.hasStates
        % States?
        cw.pf("if (rtm->dwork != NULL)\n")
        cw.pf("{\n");
        cw.indent();
        cw.pf("free(rtm->dwork);\n")
        cw.unindent();
        cw.pf("}\n");
    end

    
    cw.pf("free(rtm);\n");
    cw.unindent();
    cw.pf("}\n");
    cw.unindent();
    cw.pf("}\n\n");


    cw.pf("/* Setter implementations */\n");
    extUType = swo.getExtUType();
    for k=1:numel(swo.Inputs)
        IP = swo.Inputs(k);
        cw.pf("%s\n", IP.getSetterSignature());
        cw.pf("{\n");
        cw.indent();
        cw.pf("%s *inputs_ = (%s *)rtm->inputs;\n", extUType, extUType);
        cw.pf("inputs_->%s = val;\n", IP.Name);
        cw.unindent();
        cw.pf("}\n\n");       
    end
    cw.pf("\n");

    
    % 
    cw.pf("/* Getter implementations */\n");
    extYType = swo.getExtYType();
    for k=1:numel(swo.Outputs)
        OP = swo.Outputs(k);
        cw.pf("%s\n", OP.getGetterSignature())
        cw.pf("{\n");
        cw.indent();
        cw.pf("%s *outputs_ = (%s *)rtm->outputs;\n", extYType, extYType);
        cw.pf("return outputs_->%s;\n", OP.Name);
        cw.unindent();
        cw.pf("}\n\n");
    end
    cw.pf("\n");


    cw.pf("%s {\n", swo.getCSimSignature())
    cw.indent();
    cw.pf("/* Initialize a model instance */\n")
    cw.pf("%s * rtm = %s();\n\n", swo.getRTModelType(), swo.getInstantiateName());

    cw.pf("/* Initialize the model */\n")
    cw.pf("%s_initialize(rtm);\n\n", swo.Name);

    cw.pf("for (int row=0; row<numRows; ++row) {\n");
    cw.indent();

    for k=1:swo.NumInputs
        DP = swo.Inputs(k);
        cw.pf("rtm->inputs->%s = %s_[row];\n", DP.Name, DP.Name);
    end

    cw.pf("\n");
    cw.pf("/* Run a simulation step */\n");
    cw.pf("%s_step(rtm);\n\n", swo.Name);

    for k=1:swo.NumOutputs
        DP = swo.Outputs(k);
        cw.pf("%s_[row] = rtm->outputs->%s;\n", DP.Name, DP.Name);
    end
    cw.pf("\n");

    cw.unindent();
    cw.pf("}\n\n")

    cw.pf("/* Terminate the model */\n")
    cw.pf("%s_terminate(rtm);\n\n", swo.Name);
    cw.unindent();
    cw.pf("}\n\n")

    cw.pf("/* End of file: %s */\n\n", cName);
end

function mallocCode(cw, varName, typeName)
    cw.pf("%s * %s = (%s *)malloc(sizeof(%s));\n", typeName, varName, typeName, typeName);
end
function deallocCode(cw, varName)

    cw.pf("if (%s != NULL) {\n", varName);
    cw.indent();
    cw.pf("free(%s);\n", varName)
    cw.pf("%s = NULL;\n", varName)
    cw.unindent();
    cw.pf("}\n")
    
end