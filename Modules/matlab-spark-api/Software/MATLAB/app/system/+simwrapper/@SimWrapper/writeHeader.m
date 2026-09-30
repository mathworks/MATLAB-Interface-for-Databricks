function hName = writeHeader(swo)
    % writeHeader Write header file for wrapper

    % Copyright 2024-2025 MathWorks, Inc.

    arguments
        swo (1,1) simwrapper.SimWrapper
    end

    hName = swo.WrapperName + ".h";
    mdlName = swo.CI.Name;

    % cw = StringWriter(cName);
    hw = matlab.sparkutils.StringWriter(hName);

    defName = sprintf('%s.def', mdlName);
    defH = fopen(defName, 'a');
    if defH < 0
        error('SIM_PANDAS:DEF_FILE_REWRITE', 'Error appending exports to def file');
    end
    closeDefAter = onCleanup(@() fclose(defH));


    hw.pf("/* %s\n", hName);
    hw.pf(" * Wrapper for easily simulating from within Python.\n")
    hw.pf(" */\n\n");

    hw.pf('#include "%s.h"\n\n', mdlName)
    hw.pf('#include "%s_private.h"\n\n', mdlName)

    fprintf(defH, '\n');

    fprintf(defH, '%s\n', swo.getInstantiateName());
    hw.pf("/* Get new instance of model */\n")
    hw.pf("extern %s;\n\n", swo.getInstantiateSignature());

    fprintf(defH, '%s\n', swo.getReleaseInstanceName());
    hw.pf("/* Release instance of model */\n")
    hw.pf("extern %s;\n\n", swo.getReleaseInstanceSignature());

    hw.pf("/* Setter signatures */\n");
    for k=1:numel(swo.Inputs)
        IP = swo.Inputs(k);
        fprintf(defH, '%s\n', IP.SetterName);
        hw.pf("extern %s;\n", IP.getSetterSignature())
    end
    hw.pf("\n");

    hw.pf("/* Getter signatures */\n");
    for k=1:numel(swo.Outputs)
        OP = swo.Outputs(k);
        fprintf(defH, '%s\n', OP.GetterName);
        hw.pf("extern %s;\n", OP.getGetterSignature())
    end
    hw.pf("\n");

    fprintf(defH, '%s\n', swo.getCSimName());
    hw.pf("extern %s;\n", swo.getCSimSignature());
    hw.pf("\n");

    hw.pf("/* End of file: %s */\n\n", hName);
end