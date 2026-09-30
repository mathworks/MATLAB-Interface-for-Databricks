function generateFunctionSignature(funcName, IN, options)
    % GENERATEFUNCTIONSIGNATURE generates function signature YAML-file
    % for specified function based on example in and outputs. If the
    % outputs are omitted, the function is actually called with the 
    % provided example inputs to obtain example outputs.
    
    % Copyright 2023 MathWorks, Inc.
    arguments
        funcName string
        IN cell
        options.OUT cell
        options.SaveExample logical = true
        options.ExactDimensions = false
        options.NParams = 0
    end

    [~,funcName] = fileparts(which(funcName));

    
    [yamlFile,exampleFile] = compiler.build.mlflow.internal.getYAMLName(funcName);

    % If no OUT argument was given, try generating this
    if ~isfield(options,'OUT')
        nOut = nargout(funcName);
        OUT = cell(1,nOut);
        [OUT{1:nOut}] = feval(funcName, IN{:});
    else
        OUT = options.OUT;
    end

    [inArgNames, outArgNames] = compiler.build.mlflow.internal.getArgNames(which(funcName));

    % Verify types
    if numel(IN) - options.NParams > 1 && any(cellfun(@istable,IN))
        error("When working with table inputs, only one input is allowed (additional parameters are supported).")
    end
    if numel(OUT) > 1 && any(cellfun(@istable,OUT))
        error("When working with table outputs, only one output is allowed.")
    end

    % Generate input spec
    if istable(IN{1})
        [inputs,example] = tableSchema(IN{1});
    else
        [inputs,example] = tensorSchema(IN(1:end-options.NParams),inArgNames(1:end-options.NParams));
    end

    % Generate input params
    if options.NParams > 0
        [params,param_example] = paramSchema(IN(end-options.NParams+1:end),inArgNames(end-options.NParams+1:end));
        example = {example,param_example};
    else
        params = py.None;
    end

    % Generate output spec
    if istable(OUT{1})
        outputs = tableSchema(OUT{1});
    else
        outputs = tensorSchema(OUT,outArgNames);
    end

    yamldata = py.dict;

    if options.SaveExample && ~isempty(example)
        t = py.importlib.import_module('mlflow.models.utils');
        e = py.getattr(t,'_Example');
        ex = e(example);
        [p,fn,e] = fileparts(exampleFile);
        ex.info{'artifact_path'} = fn + e;
        ex.save(p);
        yamldata{'saved_input_example_info'} = ex.info;
    end

    signature = py.mlflow.models.ModelSignature(inputs,outputs,params);
    yamldata{'signature'} = signature.to_dict;

    f = fopen(yamlFile,"w");
    fwrite(f,string(py.yaml.dump(yamldata)));
    fclose(f);

function [schema,example] = tableSchema(t)
    names = t.Properties.VariableNames;
    schema = cell(1,length(names));
    example = py.dict;
    for i = 1:length(names)
        name = names{i};
        var = t{1,name};
        schema{i} = py.mlflow.types.ColSpec(name=name,type=getMLflowType(var));
        example{name} = py.numpy.array(ensurePDArray(t{:,name}));
    end
    schema = py.mlflow.types.Schema(py.list(schema));
    example = py.pandas.DataFrame(example);
end
function data = ensurePDArray(data)
    if isdatetime(data)
        data = convertTo(data,"epochtime","Epoch",1000000000);
    end
    if isstring(data)
        data = cellstr(data)';
    elseif isscalar(data)
        data = {data};
    else
        data = num2cell(data)';
    end
end
function data = ensureArray(data)
    if isdatetime(data)
        data = convertTo(data,"epochtime","Epoch",1000000000);
    end
    if isstring(data)
        data = cellstr(data);
    elseif isscalar(data)
        data = {{data}};
    elseif isvector(data)
        data = {data};
    end
end
function [schema, example] = tensorSchema(data,names)
    schema = cell(1,length(data));
    example = py.dict;
    for i = 1:length(data)
        var = data{i};
        name = names{i};
        t = getNumpyType(var);
        schema{i} = py.mlflow.types.TensorSpec(type=t,shape=getShape(var),name=name);
        example{name} = py.numpy.array(ensureArray(var),dtype=t);
    end
    schema = py.mlflow.types.Schema(py.list(schema));
end
function [schema, example] = paramSchema(data,names)
    schema = cell(1,length(data));
    example = py.dict;
    for i = 1:length(data)
        var = data{i};
        name = names{i};
        t = getMLflowType(var);
        schema{i} = py.mlflow.types.ParamSpec(dtype=t,shape=getParamShape(var),name=name,default=getDefaultParam(var));
        example{name} = getDefaultParam(var);
    end
    schema = py.mlflow.types.ParamSchema(py.list(schema));
end
function s = getParamShape(var)
    if isscalar(var)
        s = py.None;
    else
        s = {-1};
    end
end
function var = getDefaultParam(var)
    if ~isscalar(var)
        if isdatetime(var)
            var = py.list(num2cell(var));
        else
            var = py.list(var);
        end
    end
end
function t = getMLflowType(var)
    switch class(var)
        case "double"
            t = "double";
        case "single"
            t = "float";
        case {"uint8", "int8","uint16","int16"}
            warning("mlflow ColSpec does not have an uint8, int8, uint16 nor int16, these will be upcasted to 32-bit signed integer.")
            t = "integer";
        case "int32"
            t =  "integer";
        case "uint32"
            warning("mlflow ColSpec does not have an uint32, MATLAB uint32 will be upcasted to 64-bit signed long.")
            t = "long";
        case "int64"
            t = "long";
        case "uint64"
            warning("mlflow ColSpec does not support uint64, MATLAB uint64 will be casted to 64-bit signed long.")
            t = "long";
        case "string"
            t = "string";
        case {"char","cell"}
            error("Char arrays and cell arrays of char arrays are not supported, please work with string or arrays of string.")            
        case "logical"
            t = "boolean";
        case "datetime"
            t = "datetime";
        otherwise
            error("MATLAB type %s is not supported.",class(var))            
    end
end
function t = getNumpyType(var)
    switch class(var)
        case "double"
            t = py.numpy.dtype('float64');
        case "single"
            t = py.numpy.dtype('float32');
        case {"int8","uint8","uint16","int16","uint32","int32","uint64","int64"}
            t = py.numpy.dtype(class(var));
        case "string"
            t = py.numpy.dtype('str_');
        case {"char","cell"}
            error("Char arrays and cell arrays of char arrays are not supported, please work with string or arrays of string.")
        case "logical"
            t = py.numpy.dtype('bool_');
        case "datetime"
            t = py.numpy.dtype('datetime64[ns]');
        otherwise
            error('Unsupported MATLAB type %s.',class(var))
    end
end
function s = getShape(var)
    if isstring(var)
        s = {int32(-1)};
        return
    end
    if options.ExactDimensions
        s = num2cell(int32(size(var)));
    else
        s = repmat({int32(-1)},1,ndims(var));
    end
end

end
