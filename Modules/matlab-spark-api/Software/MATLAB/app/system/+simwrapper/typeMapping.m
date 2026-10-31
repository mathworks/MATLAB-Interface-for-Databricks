function S = typeMapping(options)
    % typeMapping Returns type and mappings
    %
    % This function is used to create a database of different datatypes,
    % and how they are interpreted in different contexts.
    %
    % Used without arguments, it will return the table. 
    %
    % Used with arguments, it will do a conversion from a certain category,
    % and with a particular name, will choose a specific row. 
    %
    % The following examples looks for the MATLAB type named int32.
    %
    % simwrapper.typeMapping(from="ML", name="int32")
    % ans =
    %   1×6 table
    %       ML        PY         PYC          RTW       Spark      NP
    %     _______    _____    _________    _________    _____    _______
    %     "int32"    "int"    "c_int32"    "int32_T"    "int"    "int32"
    %
    % With an additional argument, to, one certain column can be chosen.
    % Here PYC is chosen.
    %
    % simwrapper.typeMapping(from="ML", name="int32", to="PYC")
    % ans =
    %     "c_int32"
    %
    % The different categories are:
    %   ML    - matlab
    %   PY    - python
    %   PYC   - cpython
    %   RTW   - MATLAB code generation
    %   Spark - Apache Spark types
    %   NP    - NumPy

    % Copyright 2024 The MathWorks, Inc.

    arguments
        options.from string
        options.name string
        options.to string
    end
    persistent TM
    if isempty(TM)
        TM = initTM();
    end
    
    if isfield(options, 'from') && isfield(options, 'name')
        idx = options.name == TM.(options.from);
        S = TM(idx,:);
        if isfield(options, 'to')
            S = S.(options.to);
        end
    else
        S = TM;
    end
    

end


function TM = initTM()
    ML = ["double", "single", "int64", "int32", "int16", "logical"]';
    PY = ["float", "float", "int", "int", "int", "bool"]';
    PYC = ["c_double", "c_float", "c_int64", "c_int32", "c_int16", "c_bool"]';
    RTW = ["real_T", "real32_T", "int64_T", "int32_T", "int16_T", "boolean_T"]';
    Spark = ["double", "float", "long", "int", "short", "boolean"]';
    NP = ["float64", "float32", "int64", "int32", "int16", "bool"]';

    TM = table(ML, PY, PYC, RTW, Spark, NP);
end