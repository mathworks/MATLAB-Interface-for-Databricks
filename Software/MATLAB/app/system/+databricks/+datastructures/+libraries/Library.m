classdef Library < JSONMapper
    % LIBRARY Represents a cluster library
    
    % Copyright 2024 The MathWorks, Inc.

    properties
        cran databricks.datastructures.libraries.Cran
        egg string
        jar string
        maven databricks.datastructures.libraries.Maven
        whl string
        pypi databricks.datastructures.libraries.Pypi
        requirements string
    end

    properties (Hidden)
        subType databricks.datastructures.libraries.LibraryType
    end

    methods
        function obj = Library(s, inputs)
            arguments
                s {JSONMapper.ConstructorArgument} = []
                inputs.?databricks.datastructures.libraries.Library
            end
            obj@JSONMapper(s, inputs);
        end

        
        function obj = setLibrary(obj, typedLib)
            % SETLIBRARY Create a Library from a sub type e.g. Jar
            %
            % Example:
            % j = databricks.datastructures.libraries.Jar;
            % j.jar = "/Volumes/main/myvolume/myDirectory/myJarFile.jar";
            % l = databricks.datastructures.libraries.Library;
            % l.setLibrary(j);
            
            arguments
                obj databricks.datastructures.libraries.Library
                typedLib (1,1)
            end            

            % First make sure no properties are set and the subtype is
            % empty
            obj.resetProperties();

            switch class(typedLib)
                case "databricks.datastructures.libraries.Cran"
                    obj.subType = databricks.datastructures.libraries.LibraryType.CRAN;
                    obj.cran = typedLib;

                case "databricks.datastructures.libraries.Egg"
                    obj.subType = databricks.datastructures.libraries.LibraryType.EGG;
                    obj.egg = typedLib.egg;
                
                case "databricks.datastructures.libraries.Jar"
                    obj.subType = databricks.datastructures.libraries.LibraryType.JAR;
                    obj.jar = typedLib.jar;

                case "databricks.datastructures.libraries.Maven"
                    obj.subType = databricks.datastructures.libraries.LibraryType.MAVEN;
                    obj.maven = typedLib;

                case "databricks.datastructures.libraries.Whl"
                    obj.subType = databricks.datastructures.libraries.LibraryType.WHL;
                    obj.whl = typedLib.whl;

                case "databricks.datastructures.libraries.Pypi"
                    obj.subType = databricks.datastructures.libraries.LibraryType.PYPI;
                    obj.pypi = typedLib;

                case "databricks.datastructures.libraries.Requirements"
                    obj.subType = databricks.datastructures.libraries.LibraryType.REQUIREMENTS;
                    obj.requirements = typedLib.requirements;

                otherwise
                    error("DATABRICKS:LIBRARY:SETLIBRARY", "Invalid Library type: %s", class(typedLib));
            end      
        end

       
        function obj = fromJSON_HIDDEN(obj, input)
            arguments
                obj databricks.datastructures.libraries.Library
                input
            end

            if isa(input, "com.google.gson.JsonArray")
                for n = 1:size(input)
                    curElement = input.get(n-1); % n-1 due to Java indexing
                    keysJ = curElement.keySet;
                    if numel(keysJ) ~= 1
                        error("DATABRICKS:LIBRARY:FROMJSON", "Expected 1 key only, found: %d", numel(keysJ));
                    else
                        keyArray = keysJ.toArray;
                        if numel(keyArray) ~= 1
                            error("DATABRICKS:LIBRARY:FROMJSON", "Expected 1 keyArray value only, found: %d", numel(keyArray));
                        end
                        key = string(keyArray(1));
                        obj(n).subType = databricks.datastructures.libraries.LibraryType(key);

                        classCaseKey = databricks.datastructures.libraries.Library.toClassCase(key);
                        if obj(n).subType == databricks.datastructures.libraries.LibraryType.JAR || ...
                                obj(n).subType == databricks.datastructures.libraries.LibraryType.EGG || ...
                                obj(n).subType == databricks.datastructures.libraries.LibraryType.REQUIREMENTS || ...
                                obj(n).subType == databricks.datastructures.libraries.LibraryType.WHL
                            obj(n).(lower(key)) = string(curElement.get(lower(string(obj(n).subType))).getAsString);
                        else
                            obj(n).(lower(key)) = databricks.datastructures.libraries.(classCaseKey)(curElement.get(key));
                        end
                    end
                end
            elseif ischar(input) || isStringScalar(input)
                if ischar(input)
                    input = string(input);
                end

                s = jsondecode(input);

                if isstruct(s)
                    [tmpProp, obj.subType] = databricks.datastructures.libraries.Library.structToProperty(s);
                    obj.(lower(string(obj.subType))) = tmpProp;
                elseif iscell(s)
                    for n = 1:numel(s)
                        if ~isstruct(s{n})
                            error("DATABRICKS:LIBRARY:FROMJSON", "Expected a struct or cell array of structs only.")
                        end
                        [tmpProp, obj(n).subType] = databricks.datastructures.libraries.Library.structToProperty(s{n});
                        obj(n).(lower(string(obj(n).subType))) = tmpProp;
                    end
                end
            else
                error("DATABRICKS:LIBRARY:FROMJSON", "Unexpected input type in databricks.datastructures.libraries.Library.fromJSON: %s", class(input))
            end

            % Sanity check the result
            if ~onePropOnly(obj)
                error("Library configuration problem found by onePropOnly()");
            end
        end


        function json = getPayload_HIDDEN(obj, requiredProperties, optionalProperties, raw)
            arguments
                obj
                requiredProperties string
                optionalProperties string
                raw (1,1) logical = false
            end

            if ~isprop(obj, "subType")
                error("DATABRICKS:LIBRARY:GETPAYLOAD", "Expected databricks.datastructures.libraries.Library object to have a subType property");
            end

            if ~onePropOnly(obj)
                error("Library configuration problem found by onePropOnly()");
            end

            if isempty(requiredProperties)
                requiredProperties = "";
            end

            if numel(obj) > 1
                json = '[';
            else
                json = '';
            end

            for m = 1:numel(obj)
                subProp = lower(string(obj(m).subType));

                if obj(m).subType == databricks.datastructures.libraries.LibraryType.JAR || ...
                        obj(m).subType == databricks.datastructures.libraries.LibraryType.EGG || ...
                        obj(m).subType == databricks.datastructures.libraries.LibraryType.REQUIREMENTS || ...
                        obj(m).subType == databricks.datastructures.libraries.LibraryType.WHL

                    for n = 1:numel(requiredProperties)
                        if strlength(requiredProperties(n)) > 0
                            if ~strcmp(requiredProperties(n), subProp)
                                fprintf(2, "Required property not found: %s in type: %s\n", requiredProperties(n), string(obj(m).subType));
                            end
                        end
                    end

                    json = [json, '{"', char(subProp), '":"', char(obj(m).(subProp)), '"}']; %#ok<AGROW>
                else
                    if nargin<4
                        raw = false;
                    end

                    subClass = obj(m).(subProp);
                    pkgProperties = string(properties(subClass));
                    if isempty(optionalProperties) || all(strlength(optionalProperties) > 0)
                        optionalProperties = pkgProperties;
                    else
                        optionalProperties = optionalProperties + pkgProperties;
                    end
                    innerJson = subClass.getPayload(requiredProperties, optionalProperties, raw);

                    json = [json, '{"', char(subProp), '":', char(innerJson), '}']; %#ok<AGROW>
                end

                if m ~= numel(obj)
                    json = [json, ',']; %#ok<AGROW>
                end
            end
            if numel(obj) > 1
                json = [json, ']'];
            end
        end
    end


    methods(Hidden)

        function resetProperties(obj)
            
            % Props should be the same for all objs so ok to have this
            % outside the outer loop
            props = string(properties(obj));
            
            for m = 1:numel(obj)
                for n = 1:numel(props)
                    if ~isempty(obj(m).(props(n)))
                        if isstring(obj(m).(props(n)))
                            obj(m).(props(n)) = string.empty;
                        else
                            propClass = char(class(obj(m).(props(n))));
                            obj(m).(props(n)) = eval([propClass, '.empty']);
                        end
                    end
                end
                obj(m).subType = databricks.datastructures.libraries.LibraryType.empty;
            end            
        end


        function tf = onePropOnly(obj, options)
            arguments
                obj
                options.verbose (1,1) logical = true
            end
           
            % Props should be the same for all objs so ok to have this
            % outside the outer loop
            props = string(properties(obj));

            oneFoundOnly = true; % Failure if set to false at any point
            subTypeOk = true;

            for n = 1:numel(obj)
                emptyCountScalar = 0;
                for m = 1:numel(props)
                    if ~isempty(obj(n).(props(m)))
                        emptyCountScalar = emptyCountScalar + 1;
                    end                
                end

                if emptyCountScalar ~= 1
                    oneFoundOnly = false;
                end

                if emptyCountScalar == 1 && isempty(obj(n).subType)
                    subTypeOk = false;
                end                
            end

            if ~oneFoundOnly && options.verbose
                fprintf(2, "Unexpected state, more than one property of a databricks.datastructures.libraries.Library is populated.\n");
            end

            if ~subTypeOk && options.verbose
                fprintf(2, "Unexpected state, subType is not set for a populated databricks.datastructures.libraries.Library.\n");
            end
                            
            tf = subTypeOk && oneFoundOnly;
        end
    end


    methods(Static, Hidden)

        function result = toClassCase(str)
            arguments
                str string {mustBeTextScalar, mustBeNonzeroLengthText}
            end

            str = char(lower(str));
            str(1) = upper(str(1));
            result = string(str);
        end


        function [propertyValue, subType] = structToProperty(s)
            arguments
                s (1,1) struct
            end

            fields = fieldnames(s);
            if numel(fields) ~= 1
                error("DATABRICKS:LIBRARY:STRUCTTOPROPERTY", "Expected a single library type field only.");
            end

            try
                subType = databricks.datastructures.libraries.LibraryType(fields{1});
            catch
                error("DATABRICKS:LIBRARY:STRUCTTOPROPERTY", "Unsupported library enumeration type: %s", fields{1});
            end

            if subType == databricks.datastructures.libraries.LibraryType.JAR || ...
                    subType == databricks.datastructures.libraries.LibraryType.EGG || ...
                    subType == databricks.datastructures.libraries.LibraryType.REQUIREMENTS || ...
                    subType == databricks.datastructures.libraries.LibraryType.WHL

                propertyValue = s.(lower(string(subType)));
            else
                classCase = databricks.datastructures.libraries.Library.toClassCase(string(subType));
                subLib = databricks.datastructures.libraries.(classCase);
                subStructFields = fieldnames(s.(fields{1}));
                for n = 1:numel(subStructFields)
                    if isprop(subLib, subStructFields{n})
                        subLib.(subStructFields{n}) = s.(fields{1}).(subStructFields{n});
                    else
                        fprintf(2, "Matching property not found for field: %s in class: %s, skipping.\n", subStructFields{n}, class(subLib));
                    end
                end
                propertyValue= subLib;
            end
        end
    end
end
