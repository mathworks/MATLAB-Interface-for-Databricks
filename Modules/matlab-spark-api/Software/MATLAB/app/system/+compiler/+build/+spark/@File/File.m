classdef (Abstract) File < handle & matlab.mixin.Heterogeneous
    % File A class for describing files for Spark compiler

    % Copyright 2021-2025 The MathWorks, Inc.

    properties
        name string
        funcName string
        nArgIn
        nArgOut
        Args
        ExcludeFromWrapper = false
        API (1,1) struct
        MethodTypes compiler.build.spark.MethodType = compiler.build.spark.MethodType.empty
    end

    properties (SetAccess = protected)
        TableInterface (1,1) logical  = false
        ScopedTables   (1,1) logical = false
        PandaSeries    (1,1) logical = false
    end

    % Some properties that are used during build, but can be hidden later
    properties %(Hidden)
        Parent % Can be JavaClass or PythonSparkBuilder
    end

    methods
        function obj = File(fileName)
            % Constructor for File class

            obj.name = fileName;
            [funFolder, funName] = fileparts(obj.name);
            obj.funcName = funName;

        end

        function initWithCellArgs(obj, inArgs, outArgs)
            funFolder = fileparts(obj.name);
            if strlength(funFolder) > 0
                oldDir = cd(funFolder);
                goBack = onCleanup(@() cd(oldDir));
            end

            if nargin == 3
                obj.nArgIn = numel(inArgs);
                if iscell(inArgs)
                    for k=1:obj.nArgIn
                        arg = inArgs{k};
                        if iscell(arg)
                            % obj.InTypes(k) = compiler.build.spark.types.ArgType.instantiate(arg{:});
                            obj.InTypes(k) = createArgument(obj, arg{:});
                        else
                            % obj.InTypes(k) = compiler.build.spark.types.ArgType.instantiate(arg);
                            obj.InTypes(k) = createArgument(obj, arg);
                        end
                    end
                else
                    for k=1:obj.nArgIn
                        % obj.InTypes(k) = compiler.build.spark.types.ArgType.instantiate(inArgs(k));
                        obj.InTypes(k) = createArgument(obj, inArgs(k));
                    end
                end
                obj.nArgOut = numel(outArgs);
                if iscell(outArgs)
                    for k=1:obj.nArgOut
                        arg = outArgs{k};
                        if iscell(arg)
                            % obj.OutTypes(k) = compiler.build.spark.types.ArgType.instantiate(arg{:});
                            obj.OutTypes(k) = createArgument(obj, arg{:});
                        else
                            % obj.OutTypes(k) = compiler.build.spark.types.ArgType.instantiate(arg);
                            obj.OutTypes(k) = createArgument(obj, arg);
                        end
                    end
                else
                    for k=1:obj.nArgOut
                        % obj.OutTypes(k) = compiler.build.spark.types.ArgType.instantiate(outArgs(k));
                        obj.OutTypes(k) = createArgument(obj, outArgs(k));
                    end
                end
            end

            obj.fillEmptyNames();
            % This is needed to deduce if it should be used with MATLAB
            % tables
            obj.setTableProperties();

        end


        function addMethodType(obj, mt)
            % addMethodType Add a MethodType to array
            % This is done to keep account of what methods are generated,
            % and what wrappers and helpers need to be generated.
            %
            % mt can be a string or an instance of MethodType
            obj.MethodTypes(end+1) = mt;
        end

        function retType = getReturnType(obj)
            if obj.TableInterface
                if isa(obj.OutTypes(1), 'compiler.build.spark.types.Table')
                    ota = obj.OutTypes(1).TableCols;
                else
                    ota = obj.OutTypes;
                end
                nOut = length(ota);
                if nOut == 1
                    retType = getReturnType(ota);
                else
                    types = getReturnTypes(ota);
                    retType = sprintf("scala.Tuple%d<%s>", nOut, ...
                        types.join(", "));
                end
            else
                nOut = obj.nArgOut;
                if  nOut == 0
                    retType = "void";
                elseif nOut == 1
                    retType = getReturnType(obj.OutTypes);
                else
                    types = string.empty;
                    for k=1:nOut
                        types(k) = getReturnType(obj.OutTypes(k));
                    end
                    retType = sprintf("scala.Tuple%d<%s>", nOut, ...
                        types.join(", "));

                end
            end
        end

        function entry = getEncoderStruct(obj)
            entry = struct(...
                'Name', obj.funcName + "_encoder", ...
                'EncType', obj.getReturnType, ...
                'Constructor', obj.getEncoderCreator);
        end

        function enc = getEncoderCreator(obj)
            %  getEncoderCreator Encoder for output of map
            if obj.TableInterface
                if isa(obj.OutTypes(1), 'compiler.build.spark.types.Table')
                    ota = obj.OutTypes(1).TableCols;
                else
                    ota = obj.OutTypes;
                end
            else
                ota = obj.OutTypes;
            end
            encEntries = ota.getEncoderCreator;

            if length(encEntries) == 1
                enc = encEntries;
            else
                enc =  sprintf("MWEncoders.tuple(%s)", encEntries.join(", "));
            end
        end

        function [outType, outTypeDefinition] = getOutSparkType(obj)
            sparkTypes = [obj.OutTypes.SparkType];

            if obj.nArgOut == 1
                if obj.OutTypes.isScalarData
                    outType = "DataTypes." + sparkTypes(1);
                else
                    outType = "DataTypes.createArrayType(DataTypes." + sparkTypes(1) + ")";
                end
                outTypeDefinition = "";


            else
                outType = obj.funcName + "_SparkType";
                SW = matlab.sparkutils.StringWriter();
                N = obj.nArgOut;
                SW.pf("/* StructType '%s' needed for UDF registration */\n", outType);
                SW.pf("List<StructField> fields = new ArrayList<StructField>();\n");
                for kf = 1:N
                    if obj.OutTypes(kf).isScalarData
                        tmpOT = sprintf("DataTypes.%s", sparkTypes(kf));
                    else
                        tmpOT = sprintf("DataTypes.createArrayType(DataTypes.%s)", sparkTypes(kf));
                    end
                    SW.pf("fields.add(DataTypes.createStructField(""a%d"", %s, false));\n", ...
                        kf, tmpOT);
                end
                SW.pf("StructType " + outType + " = DataTypes.createStructType(fields);\n\n");
                outTypeDefinition = SW.getString();
            end
        end

        function names = generateArgNames(obj, direction, base)
            sprintfStr = sprintf("%s%%d", base);
            switch lower(direction)
                case 'in'
                    names = arrayfun(@(x) sprintf(sprintfStr, x), (1:obj.nArgIn));
                case 'out'
                    names = arrayfun(@(x) sprintf(sprintfStr, x), (1:obj.nArgOut));
                otherwise
                    error('SparkBuilder:ArgError', 'Only supported for "in" or "out"');
            end
        end

        function names = generateNameList(~, base, num)
            if num <= 0
                names = string.empty;
            else
                sprintfStr = sprintf("%s%%d", base);
                names = arrayfun(@(x) sprintf(sprintfStr, x), (1:num));
            end
        end

        function [names, namesArray] = generatePythonInputArgs(obj, opts)
            arguments
                obj (1,1) compiler.build.spark.File
                opts.withNargout (1,1) logical = false
                opts.convertArgs (1,1) logical = false
            end

            inTypes = obj.getInputElements(table=obj.TableInterface,individual=~obj.TableInterface);

            if opts.convertArgs
                namesArray = string.empty;
                for k=1:length(inTypes)
                    namesArray(k) = convertPythonValueForMW(inTypes(k), "arg_" + inTypes(k).Name);
                end
            else
                % Prefix the argument names to avoid name clashes with
                % reserved words.
                namesArray = "arg_" + [inTypes.Name];
            end
            names = join(namesArray, ", ");
            if opts.withNargout && obj.nArgOut > 1
                names = sprintf("%s, nargout=%d", names, obj.nArgOut);
            end
        end

        function names = generatePythonRowInputArgs(obj, varName)
            % formatStr = sprintf("%s[%%d]", varName);
            names = string.empty();
            for k=1:obj.nArgIn
                indexedName = sprintf('%s[%d]', varName, k-1);
                % names(k) = convertPythonValueForMW(IT, indexedName);
                names(k) = indexedName;
                % if IT.pythonInputArgumentNeedsCasting()
                %     names(k) = sprintf("matlab.%s(%s)", IT.MATLABType, names(k));
                % end
            end
            names = join(names, ", ");
        end

        function str = generatePythonRowIteratorArgs(obj)
            if obj.TableInterface
                ARGS = obj.InTypes(1).TableCols;
            else
                ARGS = obj.InTypes;
            end
            N = length(ARGS);
            rowElems = string.empty;
            for k=1:N
                varName = sprintf("row[%d]", k-1);
                rowElems(end+1) = convertPythonValueForMW(ARGS(k), varName);
            end
            str = "[" + join(rowElems, ", ") + "]";
        end

        function [args, types, funcDefinitionArgs] = getArgArray(obj, direction, base)
            %  getArgArray Create array of arguments and their types
            %
            % [a,b,c] = f.getArgArray('in', 'arg')
            % a =
            %   1×2 string array
            %     "arg1"    "arg2"
            % b =
            %   1×2 string array
            %     "Double"    "Double"
            % c =
            %     "Double arg1, Double arg2"

            sprintfStr = sprintf("%s%%d", base);
            switch lower(direction)
                case 'in'
                    args = arrayfun(@(x) sprintf(sprintfStr, x), (1:obj.nArgIn));

                    types = getPrimitiveJavaType(obj.InTypes);
                case 'out'
                    args = arrayfun(@(x) sprintf(sprintfStr, x), (1:obj.nArgOut));
                    types = getPrimitiveJavaType(obj.OutTypes);
                otherwise
                    error('SPARK:ERROR', 'Only supported for ''in'' or ''out''');
            end
            if numel(types)==0
                typeAndArgs = string.empty;
            else
                typeAndArgs = arrayfun(@(t,a) t + " " + a, types, args);
            end
            funcDefinitionArgs = join(typeAndArgs, ", ");

        end

        function writeMethodComment(obj, funcName, SW)
            SW.pf("/** Function: %s\n", funcName);
            SW.pf(" * Num arg in: %d\n", obj.nArgIn);
            SW.pf(" * Num arg out: %d */\n", obj.nArgOut);
        end

        function [udfName, udfType, callTypes, UDF] = getUDFInfo(obj)
            udfName = sprintf("UDF%d", obj.nArgIn);
            UDF.FuncName = udfName;
            callTypes = string.empty;
            convCode = string.empty;
            argNames = string.empty;
            convArgs = string.empty;
            for k=1:obj.nArgIn
                CA = obj.InTypes(k);
                argNames(k) = "arg" + k;
                if CA.isScalarData
                    callTypes(k) = CA.getReturnType;
                    convCode(k) = "";
                    convArgs(k) = argNames(k);
                else
                    callTypes(k) = "WrappedArray<Object>";
                    convName = "conv" + k;
                    convCode(k) = CA.getRowInputValue(argNames(k), convName);
                    convArgs(k) = convName;
                end
            end
            UDF.CallTypes = callTypes;
            UDF.ConvCode = convCode;
            UDF.ConvArgs = convArgs;
            types = [callTypes, obj.getReturnType];
            udfType = sprintf("%s<%s>", udfName, types.join(", "));
            UDF.UDFType = udfType;
        end



    end

    methods (Abstract)
        % TODO: Activate this later (maybe)
        % codeOut = convertExternalToIntermediate(obj, codeIn)
    end

    methods(Access=private)
        function init(obj)

            for k=1:obj.nArgIn
                if k==1
                    obj.Args.In = getArgEntry('double', 1);
                else
                    obj.Args.In(k) = getArgEntry('double', 1);
                end
            end
            for k=1:obj.nArgOut
                if k==1
                    obj.Args.Out = getArgEntry('double', 1);
                else
                    obj.Args.Out(k) = getArgEntry('double', 1);
                end
            end
        end

        function arg = createArgument(obj, varargin)
            arg = compiler.build.spark.types.ArgType.instantiate(varargin{:});
            arg.setParent(obj);
        end


        % Function to deduce table settings
        setTableProperties(obj)
    end
end

function entry = getArgEntry(mwArgType, argSize)
    entry = matlab.sparkutils.datatypeMapper('matlab', mwArgType);

    entry.Size = argSize;
end

% Some internal information on what dataclasses are part of MWClassID, and
% what getFunctions are available in Spark.
% MWClassID.
% CELL   DOUBLE     INT16   INT64   LOGICAL   OPAQUE   STRING   UINT16   UINT64   UNKNOWN
% CHAR   FUNCTION   INT32   INT8    OBJECT    SINGLE   STRUCT   UINT32   UINT8
%
% d1.get
% getByte         getFloatData      getImagDoubleData   getImagLongData    getLongData
% getByteData     getImag           getImagFloat        getImagShort       getShort
% getClass        getImagByte       getImagFloatData    getImagShortData   getShortData
% getDouble       getImagByteData   getImagInt          getInt
% getDoubleData   getImagData       getImagIntData      getIntData
% getFloat        getImagDouble     getImagLong         getLong

