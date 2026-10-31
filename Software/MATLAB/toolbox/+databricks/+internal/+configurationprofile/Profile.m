classdef Profile
    % Profile Class for working with a blocks of settings
    % Profile details can be provided either as:
    %  * Scalar text containing the header, keys and values as written
    %    in a configuration file.
    %  * A name (scalar text), keys (string array) and values (string
    %    array). The number of keys and values must be equal.
    %  * A struct with scalar text double integer or logical fields.
    %
    % If none are provided and empty profile named DEFAULT is returned.
    %
    % Example:
    %   myName = "MYPROFILE";
    %   myKeys = ["key1", "key2"];
    %   myValues = ["value1", "value2"];
    %   p = databricks.internal.configurationprofile.Profile(name=myName, keys=myKeys, values=myValues);

    % Copyright 2024-2026 The MathWorks, Inc.

    properties
        Name string = ""
    end

    properties (Hidden)
        Fields
    end

    methods
        function obj = Profile(options)
            arguments
                options.name string {mustBeTextScalar, mustBeNonzeroLengthText}
                options.text string {mustBeTextScalar, mustBeNonzeroLengthText}
                options.keys string {mustBeNonzeroLengthText}
                options.values string {mustBeNonzeroLengthText}
                options.structCfg struct
                options.verbose (1,1) logical = true
            end

            obj.Fields = containers.Map.empty;

            if isfield(options, 'text')
                if isfield(options, 'keys') || isfield(options, 'values')
                    warning("DATABRICKS:Profile:Args", "Using text argument ignoring keys and or values.");
                end

                % profile of >100 characters is likely an error
                identifierPat = asManyOfPattern(alphanumericsPattern(1) | "_" | "-" | "+" | " ", 1);
                pat = "[" + whitespacePattern(0,100) + identifierPat + whitespacePattern(0,100) + "]";
                emptyPat = "[" + whitespacePattern(0,inf) + "]";
                inputText =  strtrim(char(options.text));
                headers = extract(inputText, pat);
                for n = 1:numel(headers)
                    if matches(headers{n}, emptyPat)
                        error("DATABRICKS:Profile:Header:emptyHeader","Empty profile names are not supported.");             
                    end
                end
                if ~iscellstr(headers)
                    error("DATABRICKS:Profile:Header","Expected profile header to be a cell array of character vectors.");
                end
                if numel(headers) > 1
                    error("DATABRICKS:Profile:Text","Expected profile text to have only one header.");
                end

                header = strtrim(headers{1});
                header = strip(header, 'left', '[');
                header = strip(header, 'right', ']');
                header = strtrim(header);
                if isfield(options, 'name')
                    obj.Name = strtrim(options.name);
                else
                    obj.Name = header;
                end

                lines = split(inputText, pat);
                if ~iscellstr(lines) %#ok<ISCLSTR>
                    error("DATABRICKS:Profile:CharCell","Expected profile to be a cell array of character vectors");
                end

                lines = strtrim(lines{end});
                if ~isempty(lines) && strlength(lines) > 0
                    splitLines = split(lines, newline);
                    kvLines = {};
                    for m = numel(splitLines):-1:1
                        % Ignore empty lines and comments, i.e. starting with ;
                        if ~isempty(strtrim(splitLines{m})) && ~startsWith(strtrim(splitLines{m}), ";")
                            kvLines{end+1} = splitLines{m};
                        end
                    end
                    for m = 1:numel(kvLines)
                        if contains(kvLines{m}, ";")
                            nonComment = extractBefore(kvLines{m}, ";");
                        else
                            nonComment = kvLines{m};
                        end
                        lineKey = strtrim(extractBefore(nonComment, "="));
                        lineValue = strtrim(extractAfter(nonComment, "="));
                        obj.Fields(lineKey) = lineValue;
                    end
                end
            elseif isfield(options, 'keys') && isfield(options, 'values')
                if ~isfield(options, 'name')
                    if options.verbose
                        fprintf("Profile name not defined using: DEFAULT\n");
                    end
                    obj.Name = "DEFAULT";
                else
                    obj.Name = strtrim(options.name);
                end

                if numel(options.keys) ~= numel(options.values)
                    error("DATABRICKS:Profile:NKeys", "The number of keys must equal the number of values.");
                end

                obj.Fields = containers.Map(lower(options.keys), options.values);
            elseif isfield(options, 'structCfg')
                if ~isfield(options, 'name')
                    if options.verbose
                        fprintf("Profile name not defined using: DEFAULT\n");
                    end
                    obj.Name = "DEFAULT";
                else
                    obj.Name = strtrim(options.name);
                end

                fields = fieldnames(options.structCfg);
                for n = 1:numel(fields)
                    if isStringScalar(options.structCfg.(fields{n})) || ischar(options.structCfg.(fields{n}))
                        value = string(options.structCfg.(fields{n}));
                    elseif isa(options.structCfg.(fields{n}), "double") || isinteger(options.structCfg.(fields{n}))
                        value = string(num2str(options.structCfg.(fields{n})));
                    elseif islogical(options.structCfg.(fields{n}))
                        value = string(options.structCfg.(fields{n}));
                    else
                        error("DATABRICKS:Profile:StructVals", "Struct values must be scalar text, a scalar double, integer or logical.");
                    end
                    obj.Fields(fields{n}) = value;
                end
            else
                if ~isfield(options, 'name')
                    % Should not arise in the case of no argument don't
                    % warn about the name as just creating an unpopulated
                    % default profile
                    if isfield(options, 'text') || isfield(options, 'keys') || isfield(options, 'values') || isfield(options, 'structCfg')
                        if options.verbose
                            fprintf("Profile name not defined using: DEFAULT\n");
                        end
                    end
                    obj.Name = "DEFAULT";
                else
                    obj.Name = strtrim(options.name);
                end
            end
        end


        function tf = isKey(obj, keyName)
            % isKey Returns true if a key exists otherwise false
            % The Profile object stores and checks keys based on their lower case value automatically.
            
            arguments
                obj databricks.internal.configurationprofile.Profile
                keyName string {mustBeTextScalar, mustBeNonzeroLengthText}
            end

            if isempty(obj)
                tf = false;
            else
                tf = isKey(obj.Fields, lower(keyName));
            end
        end


        function result = keys(obj)
            % keys Returns a string array of the profiles keys
            % Keys are returned in lower case as the Profile object stores keys based on their lower case value automatically.
            arguments
                obj databricks.internal.configurationprofile.Profile
            end

            if isempty(obj)
                result = string.empty;
            else
                if iscellstr(obj.Fields.keys) || all(cellfun(@(x) isStringScalar(x), obj.Fields.keys))
                    result = string(obj.Fields.keys);
                else
                    error("DATABRICKS:Profile:Keys", "Expected a cell array of character vectors or scalar strings.");
                end
            end
        end


        function remove(obj, fieldName, options)
            % remove Removes a named field from the profile
            % The fieldname is lower cased automatically.
            arguments
                obj databricks.internal.configurationprofile.Profile
                fieldName string {mustBeTextScalar, mustBeNonzeroLengthText}
                options.verbose (1,1) logical = true
            end

            fieldName = lower(fieldName);

            if isempty(obj)
                error("DATABRICKS:Profile:remove","Cannot remove a field on an empty profile.");
            else
                if obj.Fields.isKey(fieldName)
                    obj.Fields.remove(fieldName);
                else
                    if options.verbose
                        fprintf(2, "Field: %s not found in profile: '%s'\n", fieldName, obj.Name);
                    end
                end
            end
        end


        function result = values(obj)
            % values Returns a string array of the profiles values
            arguments
                obj databricks.internal.configurationprofile.Profile
            end

            if isempty(obj)
                result = string.empty;
            else
                if iscellstr(obj.Fields.values) || all(cellfun(@(x) isStringScalar(x), obj.Fields.values))
                    result = string(obj.Fields.values);
                else
                    error("DATABRICKS:Profile:values", "Expected a cell array of character vectors or or scalar strings.");
                end
            end
        end


        function result = getValue(obj, keyName)
            % getValue Returns the value for a given key as a string
            % If the key does not exists an empty string is returned
            arguments
                obj databricks.internal.configurationprofile.Profile
                keyName string {mustBeTextScalar, mustBeNonzeroLengthText}
            end

            if isempty(obj)
                result = string.empty;
            else
                if isKey(obj, keyName)
                    result = string(obj.Fields(lower(keyName)));
                else
                    result = string.empty;
                end
            end
        end


        function setValue(obj, keyName, value)
            % setValue Sets the value for a given key name
            % If the key is already set it is overwritten.
            % Key names are stored in lower case automatically.
            arguments
                obj databricks.internal.configurationprofile.Profile
                keyName string {mustBeTextScalar, mustBeNonzeroLengthText}
                value string {mustBeTextScalar, mustBeNonzeroLengthText}
            end

            if isempty(obj)
                error("DATABRICKS:Profile:setValue","Cannot set a key/value on an empty profile.");
            else
                obj.Fields(lower(keyName)) = value;
            end
        end


        function result = toString(obj)
            % toString Returns a profile block including its header as a string
            if isempty(obj)
                error("DATABRICKS:Profile:toString","Cannot set a key/value on an empty profile.");
            else
                result = "[" + obj.Name + "]" + newline;
                keys = obj.keys;
                for n = 1:numel(keys)
                    result = result + keys(n) + " = " + obj.getValue(keys(n)) + newline;
                end
            end
        end


        function obj = setValueFromEnvironment(obj, key, variableName, options)
            % setValueFromEnvironment Override a value with an environment variable if set
            % If the environment variable is not set the value returned unchanged
            % Values are returned as scalar strings if changed or otherwise their
            % original type. Values are returned within the profile.

            arguments
                obj databricks.internal.configurationprofile.Profile
                key string {mustBeTextScalar, mustBeNonzeroLengthText}
                variableName string {mustBeTextScalar, mustBeNonzeroLengthText}
                options.verbose (1,1) logical = true
            end

            if isempty(obj)
                error("DATABRICKS:Profile:setValueFromEnvironment","Cannot set a key/value on an empty profile.");
            end

            envVarValue = getenv(variableName);
            if ~isempty(envVarValue)
                if isKey(obj, key)
                    if ~strcmp(obj.getValue(key), envVarValue)
                        if options.verbose
                            fprintf("Overriding profile value: %s, with %s environment variable value: %s\n",...
                                key, variableName, envVarValue);
                        end
                        obj.setValue(key, string(envVarValue));
                    end
                else
                    if options.verbose
                        fprintf("Setting key: %s based on environment variable: %s, value %s\n", key, variableName, envVarValue);
                    end
                    obj.setValue(key, string(envVarValue));
                end
            end
        end
    end
end