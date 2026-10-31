function result = getJsonValue(varargin)
    % GETJSONVALUE returns a JSON value as a specified type
    % The following arguments are required:
    %         json: Input JSON as a string or character vector or a
    %               com.google.gson.JsonArray, com.google.gson.JsonPrimitive or
    %               com.google.gson.JsonObject as an output of the gson parser e.g:
    %                  jParser = javaObject('com.google.gson.JsonParser');
    %                  json = jParser.parse(jsonString);
    %
    %    valueName: Cell array of hierarchical fields naming a single value
    %               e.g.: valueName = {"level1", "level2", "myPrimitiveField"};
    %               An unnamed primitive value is denoted by ""
    %               If a field is an array a single index can be provided as a
    %               numeric value, e.g.: {"levelA", "arrayB", 4, "myPrimitiveField"};
    %               Array entries are indexed from 1.
    %
    %     typeName: int64 or string specified as a string or character vector
    %
    % Returning non scalar value results is currently not supported.
    %
    % Examples:
    %
    %   % An int64 value as a json primitive with no name/key
    %   primitiveStr = jsonencode(1234);
    %   result = getJsonValue(primitiveStr, {""}, "int64")
    %   result =
    %     int64
    %      1234
    %
    %   % A hierarchical structure
    %   s = struct;
    %   s.a = int64(123);
    %   s.b = "String1";
    %   ss.c = "String2";
    %   ss.d = int64(456);
    %   s.f = ss;
    %   jsonStr = jsonencode(s);
    %   result = getJsonValue(jsonStr, {"b"}, "string")
    %   result =
    %       "String1"
    %   result = getJsonValue(jsonStr, {"f", "d"}, "int64")
    %   result =
    %     int64
    %      456
    %
    %   % Access using an array index
    %   s = struct;
    %   a = struct;
    %   for n=1:5
    %       a(n).s = ['abc', num2str(n)];
    %       a(n).i = int64(n);
    %    end
    %   s.a = a;
    %   jsonStr = jsonencode(s)
    %   result = getJsonValue(jsonStr, {"a",2,"s"}, "string")
    %   result =
    %      "abc2"

    %  (c) 2021-2022 MathWorks, Inc.

    errPrefix = 'ERROR:JSONERROR';

    p = inputParser;
    p.CaseSensitive = false;

    p.addRequired('json', @(x)validateattributes(x,{'char','string','com.google.gson.JsonArray','com.google.gson.JsonPrimitive','com.google.gson.JsonObject'}, {'scalar'}));
    p.addRequired('valueName', @(x)validateattributes(x,{'cell'}, {'row'}))
    p.addRequired('typeName', @(x)validateattributes(x,{'char','string'},{'scalartext'}));
    
    p.parse(varargin{:});

    typeName = p.Results.typeName;
    valueName = p.Results.valueName;

    switch class(p.Results.json)
        case 'string'
            if isStringScalar(p.Results.json)
                jParser = javaObject('com.google.gson.JsonParser');
                objj = jParser.parse(p.Results.json);
            else
                error(errPrefix,'Error expected json string to be a scalar value')
            end
            
        case 'char'
            jParser = javaObject('com.google.gson.JsonParser');
            objj = jParser.parse(p.Results.json);

        case {'com.google.gson.JsonArray','com.google.gson.JsonPrimitive', 'com.google.gson.JsonObject'}
            objj = p.Results.json;

        otherwise
            error(errPrefix,'Error unexpected type: %s, only char, string, com.google.gson.JsonArray, com.google.gson.JsonPrimitive and com.google.gson.JsonObject are currently supported', class(p.Results.json));
    end

    % Go through the fields to get the last named element
    for n = 1:numel(valueName)
        if isStringScalar(valueName{n}) || ischar(valueName{n})
            if (strlength(valueName{n}) == 0) && objj.isJsonPrimitive()
                % field has no expected name the and have reached a primitive
                % so do not try to go deeper, try to return a result
                break;
            else
                objj = objj.getAsJsonObject().get(valueName{n});
            end
        elseif iscell(valueName{n})
            if isnumeric(valueName{n}{1})
                index = valueName{n}{1}; % assuming 1d for now so only one index
                if ~isscalar(index)
                    error(errPrefix,'Error expected scalar numeric index');
                end
                if objj.isJsonObject()
                    if index ~= 1
                        error(errPrefix,'Error expected JsonObject type when using an index other than 1');
                    else
                        % Index addressing being used against a 1 element array will
                        % just return the object not an array so effectively
                        % objj = objj;
                    end
                elseif objj.isJsonArray()
                    % offset by -1 for Java indexing
                    objj = objj.get(index-1);
                else
                    error(errPrefix,'Error unexpected Java object type: %s', class(objj));
                end
            else
                error(errPrefix,'Error unexpected nested cell array field type: %s, expected numeric', class(objj));
            end
        else
            error(errPrefix,'Error unexpected cell array field type: %s', class(objj));
        end
    end

    switch lower(char(typeName))
        case 'string'
            if objj.isJsonPrimitive()
                % return scalar string
                result = string(objj.getAsString());
            else
                % Array parsing could be added, array must be parsed to
                % determine dimensionality
                error(errPrefix,'Error only JSON primitive (scalar) values are currently supported');
            end

        case 'int64'
            if objj.isJsonPrimitive()
                charVal = char(objj.getAsString());
                result = sscanf(charVal, '%ld');
            else
                % Array parsing could be added, array must be parsed to
                % determine dimensionality
                error(errPrefix,'Error only JSON primitive (scalar) values are currently supported');
            end

        otherwise
            error(errPrefix,'Error unexpected type: %s, only string and int64 are currently supported', char(typeName));
    end

end
