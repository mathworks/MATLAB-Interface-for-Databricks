classdef SimWrapper < handle
    % SimWrapper Class for handling the build of Simulation wrappers
    %
    % This solution is based on the using Pandas Dataframes as input to shared
    % objects generated from Simulink models.

    % Copyright 2024-2025 MathWorks, Inc.

    properties (Dependent, SetAccess=private)
        ModelName (1,1) string
        NumInputs  (1,1) int32
        NumOutputs (1,1) int32
    end
    properties (SetAccess=private)
        BaseFolder (1,1) string
        CI RTW.ComponentInterface
        BI RTW.BuildInfo
        Inports simwrapper.InPort
        Outports simwrapper.OutPort
        Inputs matlab.coder.pandas.data.DataType
        Outputs matlab.coder.pandas.data.DataType
        Schema compiler.build.spark.schema.mathworks.CompilerType = compiler.build.spark.schema.mathworks.CompilerType.empty
        WrapperName (1,1) string
        RTModel RTW.DataInterface
        ExtU RTW.DataInterface
        ExtY RTW.DataInterface
        States RTW.DataInterface
        PyPackageName (1,1) string
    end
    properties (SetAccess=private, Hidden)
        pyPlainName = "simpandas"        
    end
    properties (SetAccess=private, Dependent)
        Name (1,1) string
        ArtifactName (1,1) string
    end

    methods
        function obj = SimWrapper(options)
            arguments
                options.startPath (1,1) string {mustBeFolder}
                options.packageName (1,1) string
                options.buildInfo (1,1) RTW.BuildInfo
            end

            if isfield(options, 'startPath')
                old = cd(options.startPath);
                goBack = onCleanup(@() cd(old));
            end
            obj.BaseFolder = pwd;

            if isfield(options, 'buildInfo' )
                obj.BI = options.buildInfo;
            else
                load('./buildInfo.mat'); %#ok<LOAD>
                obj.BI = buildInfo;
            end
            load('./codeInfo.mat'); %#ok<LOAD>
            obj.CI = codeInfo;
            init(obj);
            if isfield(options, 'packageName')
                obj.PyPackageName = options.packageName;
            else
                [pn, hasValue] = simwrapper.Properties.getProp("packageName");
                if hasValue
                    obj.PyPackageName = pn;
                else
                    obj.PyPackageName = "simutil." + obj.WrapperName;
                end
            end

            obj.deduceSparkSchema();
        end

        function str = getRTModelType(obj)
            str = obj.RTModel.Implementation.Type.BaseType.Identifier;
        end
        function str = getExtUType(obj)
            str = obj.ExtU.Implementation.Type.BaseType.Identifier;
        end
        function str = getExtYType(obj)
            str = obj.ExtY.Implementation.Type.BaseType.Identifier;
        end
        function str = getStatesType(obj)
            str = obj.States.Implementation.Type.BaseType.Identifier;
        end
        function tf = hasStates(obj)
            tf = ~isempty(obj.States);
        end

        function str = getInstantiateName(obj)
            str =  obj.WrapperName + "_instantiate";
        end
        
        function str = getInstantiateSignature(obj)
            str = obj.getRTModelType() + "* " + obj.getInstantiateName() + "()";
        end

        function str = getReleaseInstanceName(obj)
            str = obj.WrapperName + "_releaseInstance";
        end
        function str = getReleaseInstanceSignature(obj)
            rtmT = obj.getRTModelType(); 
            str =  "void " + obj.getReleaseInstanceName() + "(" + rtmT + "* rtm)";
        end
        function str = getFullPyPkgName(obj)
            str = obj.PyPackageName + "." + obj.pyPlainName;
        end

        function str = getCSimName(obj)
            str = sprintf("%s_c_sim", obj.Name);
        end
        function str = getCSimSignature(obj)
            argsIn = strings(1, obj.NumInputs);
            for k=1:obj.NumInputs
                O = obj.Inputs(k);
                argsIn(k) = sprintf("const %s * %s_", O.DT, O.Name);
            end
            argsOut = strings(1, obj.NumOutputs);
            for k=1:obj.NumOutputs
                O = obj.Outputs(k);
                argsOut(k) = sprintf("%s * %s_", O.DT, O.Name);
            end
            argsStr = join(["int numRows", argsIn, argsOut], ", ");
            str = sprintf("int %s(%s)", obj.getCSimName(), argsStr);
        end

        function str = getSparkOutputSchema(obj)
            parts = strings(1, obj.NumOutputs);
            for k=1:obj.NumOutputs
                P = obj.Outputs(k);
                parts(k) = P.Name + " "  + P.SparkType;
            end
            str = "'" + join(parts, ", ") + "'";
        end

        function generateArtifact(obj)
            pgkParts = split(obj.PyPackageName, ".");
            zipStr = "zip -r " + obj.ArtifactName + " " + pgkParts(1);
            system(zipStr, '-echo');
        end

        function tf = isMATLAB(obj)
            tf = ~obj.isSimulink();
        end
        function tf = isSimulink(obj)
            % TODO: Unclear if this is always true
            tf = isfolder(fullfile(obj.BaseFolder, 'tmwinternal'));
        end

        function [fullName, plainName] = getWheelFile(obj)
            wheels = dir(fullfile(obj.BaseFolder, "dist", "*.whl"));
            if isscalar(wheels)
                fullName = string(fullfile(wheels.folder, wheels.name));
                if nargout > 1
                    [~, p1, p2] = fileparts(fullName);
                    plainName = p1 + p2;
                end
            else
                error("There was not exactly one generated wheel file. Please make a clean build.")
            end
        end

        function str = getPDFSimName(obj)
            str = sprintf("%s_applyInPandas", obj.Name);
        end

        function str = getPDFSimIterName(obj)
            str = sprintf("%s_mapInPandas", obj.Name);
        end
    end

    methods % Dependent methods
        function name = get.Name(obj)
            name = string(obj.CI.Name);
        end
        function name = get.ArtifactName(obj)
            name = obj.Name + "_artifact.zip";
        end
    end

    methods (Access=private)
        function init(obj)
            for k=1:numel(obj.CI.Inports)
                obj.Inports(k) = simwrapper.InPort(k, obj.CI.Inports(k), obj);
                obj.Inputs(k) = matlab.coder.pandas.data.DataType.createFromDataInterface(obj.CI.Inports(k));
                obj.Inputs(k).Parent = obj;
            end
            for k=1:numel(obj.CI.Outports)
                obj.Outports(k) = simwrapper.OutPort(k, obj.CI.Outports(k), obj);
                obj.Outputs(k) = matlab.coder.pandas.data.DataType.createFromDataInterface(obj.CI.Outports(k));
                obj.Outputs(k).Parent = obj;
            end
            obj.WrapperName = obj.CI.Name + "_wrapper";

            % Find the internal data entries
            graphNames = string({obj.CI.InternalData.GraphicalName});
            rtIdx = find(graphNames == "RTModel");
            obj.RTModel = obj.CI.InternalData(rtIdx);
            rtIdx = find(graphNames == "ExternalInput");
            obj.ExtU = obj.CI.InternalData(rtIdx);
            rtIdx = find(graphNames == "ExternalOutput");
            obj.ExtY= obj.CI.InternalData(rtIdx);
            rtIdx = find(graphNames == "Block states");
            obj.States = obj.CI.InternalData(rtIdx);
        end
    end

    methods % Dependent methods
        function name = get.ModelName(obj)
            name = obj.CI.Name;
        end
        function N = get.NumInputs(obj)
            N = numel(obj.Inputs);
        end
        function N = get.NumOutputs(obj)
            N = numel(obj.Outputs);
        end

    end
end