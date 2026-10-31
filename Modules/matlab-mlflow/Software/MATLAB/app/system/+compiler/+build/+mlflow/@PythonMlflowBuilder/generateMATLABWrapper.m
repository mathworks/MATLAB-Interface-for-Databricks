function filename = generateMATLABWrapper(obj)
    % generateMATLABWrapper generates the MATLAB part of the wrapper

    % Copyright 2023 MathWorks, Inc.

    % Generate a temporary file
    td = tempname;
    mkdir(td)
    filename = fullfile(td,'mlflow_wrapper.m');
    SW = compiler.build.mlflow.internal.StringWriter(filename);
    % Write the main function signagure
    SW.pf("function out = mlflow_wrapper(in)\n");
    SW.indent();


    inputs = obj.Signature.inputs;
    outputs = obj.Signature.outputs;
    params = obj.Signature.params;

    % input preprocessing (e.g.) timestamp processing
    names = string(inputs.input_names);
    types = inputs.numpy_types;
    for i = 1:length(names)
        switch types{i}
            case py.numpy.dtype("str_")
                SW.pf("in.%s = string(in.%s);\n",names{i},names{i});                
            case py.numpy.dtype("datetime64[ns]")
                SW.pf("in.%s = datetime(in.%s,'ConvertFrom','epochtime','TicksPerSecond',1000000000,'TimeZone','UTC');\n",names{i},names{i});                
        % TODO add additional types
        end
    end
    % params preprocessing (e.g.) timestamp processing
    if params ~= py.None
        for p = params.params
            param = p{1};
            switch param.dtype
                case py.mlflow.types.schema.DataType(6) % string
                    SW.pf("in.%s = string(in.%s);\n",param.name,param.name);                    
                case py.mlflow.types.schema.DataType(8) % datetime
                    SW.pf("in.%s = datetime(in.%s,'ConvertFrom','epochtime','TimeZone','UTC');\n",param.name,param.name);
            end
        end
    end
    % output arguments
    if outputs.is_tensor_spec % numpy
        SW.pf("[%s] = ", ...
            strjoin(strcat("out.",obj.OutArgs),', '));
    else % pandas
        SW.pf("out = ");
    end

    % input arguments
    if inputs.is_tensor_spec % numpy
        SW.pf("%s(%s);\n", ...
            obj.MainFunction, ...
            strjoin(strcat("in.",obj.InArgs),', '));
    else %pandas
        if params ~= py.None
            pnames = cellfun(@(x)string(x.name),cell(params.params));
            ps = ", " + strjoin(strcat("in.",pnames),", ");
        else
            ps = "";
        end
        SW.pf("%s(table(%s,'VariableNames',[%s])%s);\n", ...
            obj.MainFunction, ...
            strjoin(strcat("in.",names,"'"),", "), ...
            strjoin(strcat('"',names,'"'),", "), ...
            ps);
        SW.pf("out = table2struct(out,'ToScalar',true);\n",obj.MainFunction);
    end

    % output postprocessing (e.g.) timestamp processing or table processing
    % input preprocessing (e.g.) timestamp processing
    names = string(outputs.input_names);
    types = outputs.numpy_types;
    for i = 1:length(names)
        switch types{i}
            case py.numpy.dtype("datetime64[ns]")
                SW.pf("out.%s = convertTo(out.%s,'epochtime','TicksPerSecond',1000000000);\n",names{i},names{i});                
        % TODO add additional types
        end
    end

    
end