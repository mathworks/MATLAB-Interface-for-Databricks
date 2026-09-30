function pyName = writePythonExample(swo)
    % writePythonExample Write example in Python to call DLL

    % Copyright 2024 MathWorks, Inc.

    arguments
        swo (1,1) simwrapper.SimWrapper
    end

    pyName = string(swo.CI.Name) + "_python_example.py";

    sw = matlab.sparkutils.StringWriter(pyName);

    sw.pf("# %s\n", pyName);
    sw.pf("# Example to call SO from Python.\n\n");

    sw.pf("import numpy as np\n");
    sw.pf("import pandas as pd\n\n");

    sw.pf("import %s as swo\n\n", swo.getFullPyPkgName);

    inputExFuncs = strings(1, swo.NumInputs);
    for k=1:swo.NumInputs
        inputExFuncs(k) = swo.Inputs(k).genPythonExampleFunction(sw);
    end

    sw.pf("def make_pdf(N):\n")
    sw.indent()
    sw.pf("R__ = range(N)\n")
    for k=1:swo.NumInputs
        P = swo.Inputs(k);
        sw.pf("col_%s = np.asarray([%s(x) for x in R__], dtype='%s')\n", P.Name, inputExFuncs(k), P.NPType);
    end
    sw.pf("\n");

    sw.pf("# Create DataFrame for input data\n")
    inParts(swo.NumInputs) = "";
    for k=1:swo.NumInputs
        P = swo.Inputs(k);
        inParts(k) = sprintf("'%s': col_%s", P.Name, P.Name);
    end
    sw.pf("pdf = pd.DataFrame(data={%s})\n\n", inParts.join(", "));

    sw.pf("return pdf\n\n")
    sw.unindent()

    sw.pf("def main():\n");
    sw.indent();
    sw.pf("N = 100\n\n");

    sw.pf("pdf_in = make_pdf(N)\n");
    sw.pf("print(f'pdf_in:\\n{pdf_in}')\n\n");

    sw.pf("# Run simulation\n")
    sw.pf("pdf_out = swo.run_c_sim(pdf_in)\n\n");

    sw.pf("# Print the output\n")
    sw.pf("print(f'pdf_out:\\n{pdf_out}')\n\n");

    sw.pf("# Now try with an iterator\n")
    sw.pf("N_10 = int(N/10)\n")
    sw.pf("pdfs = [make_pdf(N), make_pdf(N+1*N_10), make_pdf(N+2*N_10), make_pdf(N+3*N_10)]\n\n")

    sw.pf("big_pdf = swo.run_c_sim_iter(iter(pdfs))\n\n")

    sw.pf("for idx, pdf in enumerate(big_pdf):\n")
    sw.indent();
    sw.pf("print(f'pdf #{idx}: {pdf}')\n")
    sw.unindent();
    sw.pf("\n");

    sw.unindent();

    sw.pf('if __name__ == "__main__":\n');
    sw.indent();
    sw.pf('main()\n\n');
    sw.unindent();

    sw.pf("# End of file: %s \n\n", pyName);
end