function filename = generatePythonWrapper(obj)
    % generatePythonWrapper generates the Python part of the wrapper

    % Copyright 2023 MathWorks, Inc.

    % Create the file
    dirname = fullfile(obj.BuildOptions.OutputDir,strrep(obj.BuildOptions.PackageName,'.',filesep));
    filename = fullfile(dirname,'mlflow.py');
    SW = compiler.build.mlflow.internal.StringWriter(filename);
    % Write the main function signature
    SW.pf("def wrapper(obj, input, params):\n");
    SW.indent();
    SW.pf("import matlab\n");
    SW.pf("import numpy\n");
    % Input processing
    inputs = obj.Signature.inputs;
    names = string(inputs.input_names);
    % Always use numpy types such that numpy and pandas processing is
    % actually the same
    types = inputs.numpy_types;
    if inputs.is_tensor_spec % numpy
        datetime_conversion = "";
    else
        datetime_conversion = "astype('int64').";
    end    
    SW.pf("ml_input = {}\n");
    % for all input arguments
    for i = 1:length(names)
        switch types{i}
            case py.numpy.dtype("float64")
                SW.pf("ml_input['%s'] = matlab.double(input['%s'].tolist())\n",names(i),names(i));
            case py.numpy.dtype("float32")
                SW.pf("ml_input['%s'] = matlab.single(input['%s'].tolist())\n",names(i),names(i));
            case py.numpy.dtype("uint8")
                SW.pf("ml_input['%s'] = matlab.uint8(input['%s'].tolist())\n",names(i),names(i));
            case py.numpy.dtype("int8")
                SW.pf("ml_input['%s'] = matlab.int8(input['%s'].tolist())\n",names(i),names(i));
            case py.numpy.dtype("uint16")
                SW.pf("ml_input['%s'] = matlab.uint16(input['%s'].tolist())\n",names(i),names(i));
            case py.numpy.dtype("int16")
                SW.pf("ml_input['%s'] = matlab.int16(input['%s'].tolist())\n",names(i),names(i));
            case py.numpy.dtype("uint32")
                SW.pf("ml_input['%s'] = matlab.uint32(input['%s'].tolist())\n",names(i),names(i));
            case py.numpy.dtype("int32")
                SW.pf("ml_input['%s'] = matlab.int32(input['%s'].tolist())\n",names(i),names(i));
            case py.numpy.dtype("uint64")
                SW.pf("ml_input['%s'] = matlab.uint64(input['%s'].tolist())\n",names(i),names(i));
            case py.numpy.dtype("int64")
                SW.pf("ml_input['%s'] = matlab.int64(input['%s'].tolist())\n",names(i),names(i));
            case py.numpy.dtype("bool_")
                SW.pf("ml_input['%s'] = matlab.logical(input['%s'].tolist())\n",names(i),names(i));                
            case py.numpy.dtype("str_")
                SW.pf("ml_input['%s'] = input['%s'].tolist()\n",names(i),names(i));
            case py.numpy.dtype("datetime64[ns]")
                SW.pf("ml_input['%s'] = matlab.int64(input['%s'].%stolist())\n",names(i),names(i),datetime_conversion);             
        end
    end

    % Parameter processing, add to inputs
    params = obj.Signature.params;
    if params ~= py.None
        params = cell(params.params);
        for p = params
            param = p{1};
            param_name = string(param.name);
            switch param.dtype
                case py.mlflow.types.schema.DataType(1) % boolean
                    SW.pf("ml_input['%s'] = matlab.logical(params['%s'])\n",param_name,param_name);
                case py.mlflow.types.schema.DataType(2) % integer
                    SW.pf("ml_input['%s'] = matlab.int32(params['%s'])\n",param_name,param_name);
                case py.mlflow.types.schema.DataType(3) % long
                    SW.pf("ml_input['%s'] = matlab.int64(params['%s'])\n",param_name,param_name);
                case py.mlflow.types.schema.DataType(4) % float
                    SW.pf("ml_input['%s'] = matlab.single(params['%s'])\n",param_name,param_name);
                case py.mlflow.types.schema.DataType(5) % double
                    SW.pf("ml_input['%s'] = matlab.double(params['%s'])\n",param_name,param_name);                    
                case py.mlflow.types.schema.DataType(6) % string
                    SW.pf("ml_input['%s'] = params['%s']\n",param_name,param_name);                    
                case py.mlflow.types.schema.DataType(7) % binary
                    SW.pf("ml_input['%s'] = matlab.uint8(params['%s'])\n",param_name,param_name);
                case py.mlflow.types.schema.DataType(8) % datetime
                    if param.shape == py.None
                        SW.pf("ml_input['%s'] = matlab.double(params['%s'].timestamp())\n",param_name,param_name);
                    else
                        SW.pf("ml_input['%s'] = matlab.double([d.timestamp() for d in params['%s']])\n",param_name,param_name);
                    end
            end
        end
    end
    % Function call
    SW.pf("output = obj.mlflow_wrapper(ml_input)\n");

    % Output Processing
    outputs = obj.Signature.outputs;
    names = string(outputs.input_names);
    % Always use numpy types such that numpy and pandas processing is
    % actually the same
    types = outputs.numpy_types;
    % With the exception of the tables needing to be flattened
    if outputs.is_tensor_spec % numpy
        flatten = "";
    else
        flatten = ".flatten()";
    end

    for i = 1:length(names)
        switch types{i}
            case py.numpy.dtype("float64")
                SW.pf("output['%s'] = numpy.float64(output['%s'])%s\n",names(i),names(i),flatten);
            case py.numpy.dtype("float32")
                SW.pf("output['%s'] = numpy.float32(output['%s'])%s\n",names(i),names(i),flatten);
            case py.numpy.dtype("uint8")
                SW.pf("output['%s'] = numpy.uint8(output['%s'])%s\n",names(i),names(i),flatten);
            case py.numpy.dtype("int8")
                SW.pf("output['%s'] = numpy.int8(output['%s'])%s\n",names(i),names(i),flatten);
            case py.numpy.dtype("uint16")
                SW.pf("output['%s'] = numpy.uint16(output['%s'])%s\n",names(i),names(i),flatten);
            case py.numpy.dtype("int16")
                SW.pf("output['%s'] = numpy.int16(output['%s'])%s\n",names(i),names(i),flatten);
            case py.numpy.dtype("uint32")
                SW.pf("output['%s'] = numpy.uint32(output['%s'])%s\n",names(i),names(i),flatten);
            case py.numpy.dtype("int32")
                SW.pf("output['%s'] = numpy.int32(output['%s'])%s\n",names(i),names(i),flatten);
            case py.numpy.dtype("uint64")
                SW.pf("output['%s'] = numpy.uint64(output['%s'])%s\n",names(i),names(i),flatten);
            case py.numpy.dtype("int64")
                SW.pf("output['%s'] = numpy.int64(output['%s'])%s\n",names(i),names(i),flatten);
            case py.numpy.dtype("bool_")
                SW.pf("output['%s'] = numpy.bool_(output['%s'])%s\n",names(i),names(i),flatten);                
            case py.numpy.dtype("str_")
                SW.pf("output['%s'] = numpy.array(output['%s'],'str_')%s\n",names(i),names(i),flatten);                
            case py.numpy.dtype("datetime64[ns]")
                SW.pf("output['%s'] = numpy.array(output['%s'],'datetime64[ns]')%s\n",names(i),names(i),flatten);                
        end
    end
    
    % And in the pandas case,do turn the dict into a("DataFra")
    if ~outputs.is_tensor_spec   
        SW.pf("import pandas\n");
        SW.pf("output = pandas.DataFrame(output)\n");
    end

    % Return output
    SW.pf("return output");
end

