function data = readDiabetesFile(filename)
    % READDIABETESFILE Read and format data from .csv file

    % Copyright 2021-2026 The MathWorks, Inc.

    % Import options object and configuration
    opts = delimitedTextImportOptions("NumVariables", 17);

    % Specify range and delimiter
    opts.DataLines = [2, Inf];
    opts.Delimiter = ";";

    % Specify column names and types
    opts.VariableNames = ["age", "gender", "polyuria", "polydipsia", "sudden_weight_loss", "weakness", "polyphagia", "genital_thrush", "visual_blurring", "itching", "irritability", "delayed_healing", "partial_paresis", "muscle_stiffness", "alopecia", "obesity", "class"];
    opts.VariableTypes = ["int32", "string", repelem("int32", 1, 15)];

    % Specify file level properties
    opts.ExtraColumnsRule = "ignore";
    opts.EmptyLineRule    = "read";

    % Specify variable properties
    opts = setvaropts(opts, ["gender", "polyuria", "polydipsia", "sudden_weight_loss", "weakness", "polyphagia", "genital_thrush", "visual_blurring", "itching", "irritability", "delayed_healing", "partial_paresis", "muscle_stiffness", "alopecia", "obesity", "class"], "EmptyFieldRule", "auto");

    % Import the data
    data = readtable(filename, opts);
end