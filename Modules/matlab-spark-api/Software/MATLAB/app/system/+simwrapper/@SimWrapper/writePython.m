function pyName = writePython(swo)
    % writePython Write python wrapper file for simulation

    % Copyright 2024-2025 MathWorks, Inc.

    arguments
        swo (1,1) simwrapper.SimWrapper
    end

    mdl = swo.CI.Name;
    pkgName = swo.PyPackageName;

    pkgs = split(pkgName, ".");
    pgkPath = join(pkgs, filesep);
    if ~isfolder(pgkPath)
        mkdir(pgkPath);
    end
    plainName = "simpandas.py";
    pyName = fullfile(pgkPath, plainName);

    numPkgs = numel(pkgs);
    % cw = StringWriter(cName);
    pw = matlab.sparkutils.StringWriter(pyName);


    numIn = numel(swo.Inputs);
    numOut = numel(swo.Outputs);
    allPYCTypes = unique(["c_int32", swo.Inputs.PYCType, swo.Outputs.PYCType]);
    pw.pf("# %s\n", plainName);
    pw.pf("# Wrapper for easily simulate from Python.\n\n");

    pw.pf("import numpy as np\n");
    pw.pf("import pandas as pd\n");
    pw.pf("import os\n");
    pw.pf("from typing import Iterator\n");
    pw.pf("from ctypes import cdll, pointer, c_void_p, %s\n\n", allPYCTypes.join(", "));

    pw.pf("def is_zip_file():\n");
    pw.indent();
    pw.pf("return '.zip' in __file__\n\n");
    pw.unindent();

    pw.pf("def is_on_serverless():\n");
    pw.indent();
    pw.pf("return '/.ephemeral_nfs/' in __file__\n\n");
    pw.unindent();


    pw.pf("def base_dir():\n");
    pw.indent();
    baseDir = "__file__";
    for k=1:(2+numPkgs)
        baseDir = "os.path.dirname(" + baseDir + ")";
    end
    pw.pf('base_dir_ = %s\n', baseDir)
    pw.pf("if is_on_serverless():\n")
    pw.indent();
    pw.pf("base_dir_ = os.path.join(os.path.dirname(base_dir_), 'files')\n")
    pw.unindent();
    pw.pf("return base_dir_\n\n");
    pw.unindent();


    switch computer('arch')
        case 'win64'
            soName = sprintf("%s_win64.dll", mdl);
        case 'glnxa64'
            soName = sprintf("%s.so", mdl);
        otherwise
            error("SIMPANDAS:TARGET_TYPE", "SimPandas not yet implemented for %s architecture.", computer('arch'));
    end
    pw.pf("def get_dll_name():\n");
    pw.indent();
    pw.pf("if is_zip_file():\n");
    pw.indent();
    pw.pf("return os.path.join(base_dir(), 'states_one.so')\n")
    pw.unindent();
    pw.pf("else:\n");
    pw.indent();
    pw.pf("return os.path.join(os.path.dirname(__file__), '%s')\n", soName);
    pw.unindent();
    pw.unindent();
    pw.pf('\n')
    
    pw.pf('def get_%s_output_schema():\n', swo.CI.Name);
    pw.indent();
    pw.pf('""" A helper function to return the output schema for this model"""\n')
    pw.pf('return %s\n', swo.getSparkOutputSchema())
    pw.unindent();
    pw.pf('\n\n')

    pw.pf("def run_sim(pdf_in: pd.DataFrame):\n")
    pw.indent()
    pw.pf('""" run_sim\n')
    pw.pf('This function will run a Simulink simulation with inputs from\n');
    pw.pf('the Pandas DataFrame argument """\n')
    pw.pf("# First prepare outputs\n")
    pw.pf("numRows = pdf_in.shape[0]\n")
    for k=1:numOut
        OP = swo.Outputs(k);
        pw.pf("col_%s = np.asarray(range(numRows), '%s')\n", OP.Name, OP.NPType() );
    end

    pw.pf("hDLL = cdll.LoadLibrary(get_dll_name())\n")
    % pw.pf("print(f'Remove later: hDLL {hDLL}')\n\n")

    pw.pf("init_fun = hDLL.%s_initialize\n", mdl)
    pw.pf("term_fun = hDLL.%s_terminate\n", mdl)
    pw.pf("step_fun = hDLL.%s_step\n", mdl)
    pw.pf("instantiate_fun = hDLL.%s_instantiate\n", swo.WrapperName)
    pw.pf("instantiate_fun.restype = c_void_p\n")
    pw.pf("release_fun = hDLL.%s_releaseInstance\n\n", swo.WrapperName)

    pw.pf("# Setter functions\n")
    for k=1:numIn
        PD = swo.Inputs(k);
        pw.pf("set_%s = hDLL.%s\n", PD.Name, PD.SetterName);
    end
    pw.pf('\n');

    pw.pf("# Getter functions\n")
    for k=1:numOut
        PD = swo.Outputs(k);
        pw.pf("get_%s = hDLL.%s\n", PD.Name, PD.GetterName);
        pw.pf("get_%s.restype = %s\n", PD.Name, PD.PYCType);
    end
    pw.pf('\n');

    pw.pf("# Keep local variables for sim\n")
    for k=1:numIn
        PD = swo.Inputs(k);
        pw.pf("vec%s = pdf_in['%s'].tolist()\n", PD.Name, PD.Name);
    end
    pw.pf('\n');

    pw.pf("# Get a data instance and initialize model\n");
    pw.pf("mdlPtr = instantiate_fun()\n")
    pw.pf("mdlPtr_c = c_void_p(mdlPtr)\n")
    pw.pf("init_fun(mdlPtr_c)\n\n")

    pw.pf("# Run simulation\n")
    pw.pf("for r in range(numRows):\n")
    pw.indent();

    pw.pf("# Set the inputs\n")
    for k=1:numIn
        PD = swo.Inputs(k);
        pw.pf("set_%s(mdlPtr_c, %s(vec%s[r]))\n", PD.Name, PD.PYCType, PD.Name);
    end
    pw.pf('\n');

    pw.pf("# Run one step\n")
    pw.pf("step_fun(mdlPtr_c)\n\n")

    pw.pf("# Retrieve the outputs\n")
    for k=1:numOut
        PD = swo.Outputs(k);
        pw.pf("col_%s[r] = get_%s(mdlPtr_c)\n", PD.Name, PD.Name);
    end
    pw.pf('\n');


    pw.unindent(); % for r in range

    pw.pf("# Release simulation resources\n")
    pw.pf("term_fun(mdlPtr_c)\n")
    pw.pf("release_fun(mdlPtr_c)\n\n")

    pw.pf("# Create dataframe for output\n")
    outParts(numOut) = "";
    for k=1:numOut
        PD = swo.Outputs(k);
        outParts(k) = sprintf("'%s': col_%s", PD.Name, PD.Name);
    end
    pw.pf("pdf_out = pd.DataFrame(data={%s})\n", outParts.join(", "));
    pw.pf("return pdf_out\n");

    pw.pf('\n');

    pw.unindent() % run_sim
    pw.pf('\n\n');



    pw.pf("def run_sim_iter(iterator):\n");
    pw.indent();
    pw.pf('""" A function to be used with mapInPandas.\n');
    pw.pf('It takes an argument an iterator over Pandas DataFrames"""\n');
    pw.pf("for pdf in iterator:\n");
    pw.indent();
    pw.pf("yield run_sim(pdf)\n");
    pw.unindent();
    pw.unindent();
    pw.pf('\n\n');

    pw.pf("def run_c_sim(pdf_in: pd.DataFrame) -> pd.DataFrame:\n")
    pw.indent()
    pw.pf('"""Simulate a Pandas Dataframe, by sending the whole PDF''s columns to C"""\n\n');

    pw.pf("numRows = pdf_in.shape[0]\n")
    pw.pf("hDLL = cdll.LoadLibrary(get_dll_name())\n")
    pw.pf("csim_fun = hDLL.%s\n\n", swo.getCSimName)

    pw.pf("# Prepare return arguments\n");
    for k=1:swo.NumOutputs
        O = swo.Outputs(k);
        pw.pf("%s_t_ = %s * numRows\n", O.Name, O.PYCType);
        pw.pf("%s = %s_t_()\n\n", O.Name, O.Name);
    end

    pw.pf("# Call the simulation function\n");
    pw.pf("csim_fun(\n");
    pw.indent();
    pw.pf("c_int32(numRows),\n")
    for k=1:swo.NumInputs
        I = swo.Inputs(k);
        pw.pf("np.ctypeslib.as_ctypes(pdf_in['%s'].to_numpy()),\n", I.Name);
    end
    comma = ",";
    for k=1:swo.NumOutputs
        if k==swo.NumOutputs, comma=""; end
        O = swo.Outputs(k);
        pw.pf("pointer(%s)%s\n", O.Name, comma);
    end
    pw.unindent()
    pw.pf(")\n\n");


    pw.pf("pdf_out = pd.DataFrame(data={\n");
    pw.indent()
    comma = ",";
    for k=1:swo.NumOutputs
        if k==swo.NumOutputs, comma=""; end
        O = swo.Outputs(k);
        pw.pf("'%s': np.ctypeslib.asarray(%s)%s\n", O.Name, O.Name, comma);
    end
    
    pw.unindent()
    pw.pf("})\n\n");
    pw.pf("return pdf_out\n");


    pw.unindent()
    pw.pf('\n\n');


    
    pw.pf("def run_c_sim_iter(iterator: Iterator[pd.DataFrame]) -> Iterator[pd.DataFrame]:\n");
    pw.indent();
    pw.pf('""" A function to be used with mapInPandas.\n');
    pw.pf('It takes an argument an iterator over Pandas DataFrames"""\n');
    pw.pf("for pdf in iterator:\n");
    pw.indent();
    pw.pf("yield run_c_sim(pdf)\n");
    pw.unindent();
    pw.unindent();
    pw.pf('\n\n');

    pw.pf("# Create aliases in Spark lingo\n")
    pw.pf("%s_applyInPandas = run_c_sim\n", swo.Name)
    pw.pf("%s_mapInPandas = run_c_sim_iter\n", swo.Name)

    pw.pf('\n\n');

    pw.pf("# End of file: %s \n\n", plainName);


end