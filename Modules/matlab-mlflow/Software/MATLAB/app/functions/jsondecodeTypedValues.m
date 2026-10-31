function result = jsondecodeTypedValues(txt, allowMissing, varargin)
    % JSONDECODETYPEDVALUES Converts JSON extracting named values as specified types
    % This allows a named int64 scalar value in a JSON to be returned as part of a
    % struct as a int64 typed field without conversion to a double.
    %
    % MATLAB's Builtin jsondecode() is used to decode all other fields.
    %
    % Only scalar values of type string, int32 and int64 are currently supported as
    % named values.
    %
    % Once decoded field names which do not conform to MATLAB's naming rules are made
    % valid using matlab.lang.makeValidName, as per builtin jsondecode. If field
    % name alteration is problematic consider using getJsonValue to directly access
    % the JSON value without decoding the larger json text,
    %
    % A single numeric array index can be provided per field name. Where a
    % pattern requires array expansion a ':' can be used to denote a field to
    % be expanded
    %
    % If only a JSON text argument is provided the built in function is
    % called directly by this function without alteration of inputs or outputs.
    %
    % The allowMissing argument is a logical value used to indicate if the
    % the absence of a field in the json should be considered an error.
    % To allow missing fields set this value to true.
    %
    % Examples:
    %
    %   s = struct;
    %   s.a = int64(123);
    %   s.b = "String1";
    %   ss.c = "String2";
    %   ss.d = int64(456);
    %   s.f = ss;
    %   jsonStr = jsonencode(s);
    %   allowMissing = true;
    %   result = jsondecodeTypedValues(jsonStr, allowMissing, {"f","d"}, "int64", {"a"}, "int64")
    %   result =
    %     struct with fields:
    %       a: 123
    %       b: 'String1'
    %       f: [1x1 struct]
    %   result.f.d
    %      ans =
    %        int64
    %         456
    %   result.a
    %      ans =
    %        int64
    %         123
    %
    %   % Decode a scalar value with no name
    %   scalarResult = jsondecodeTypedValues('1234', allowMissing, {""}, "int64");
    %   result =
    %     int64
    %      1234
    %
    %   % Address using an array index
    %   s = struct;
    %   v = struct;
    %   for n=1:3
    %      v(n).c = ['abc', num2str(n)];
    %      v(n).i = int64(n);
    %   end
    %   s.v = v;
    %   jsonStr = jsonencode(s);
    %
    %   % Expand and array index
    %   result = jsondecodeTypedValues(jsonStr, allowMissing, {"v",{':'},"i"}, "int64")
    %   result.v.i
    %   ans =
    %     int64
    %      1
    %   ans =
    %     int64
    %      2
    %   ans =
    %     int64
    %      3
    %   result.v(3).i
    %   ans =
    %     int64
    %      3

    %  (c) 2021-2022 MathWorks, Inc.

    % Check the incoming unprocessed JSON string type
    if ~(isStringScalar(txt) || ischar(txt))
        error('ERROR:JSONERROR','Error expected txt input of type character vector or scalar string');
    end

    if nargin == 1
        % Only a JSON text argument, pass straight through to built in jsondecode function
        result = builtin('jsondecode', txt);
        return;
    end
    if mod(length(varargin), 2) ~= 0
        error('ERROR:JSONERROR','Error expected argument pairs of value names and types');
    end

    % Check for pairs of field specifier and value arguments

    if ~islogical(allowMissing)
        error('ERROR:JSONERROR','Expected allowMissing to of type logical');
    end

    % Pass through to built in jsondecode function to decode any non named values
    % Updated values will overwrite fields in the result struct
    result = builtin('jsondecode', txt);

    % Parse the text with gson just once
    jParser = javaObject('com.google.gson.JsonParser');
    gsonObj = jParser.parse(txt);

    rules = prepareArguments(allowMissing, varargin{:});

    for k=1:length(rules)
        result = applyRule(result, gsonObj, rules(k));
    end

end %function

function rules = prepareArguments(allowMissing, varargin)
    rules = struct('FieldType', {}, 'Entries', {}, 'AllowMissing', {});
    for n = 1:2:length(varargin)
        % Convert all scalar string field names to their valid form
        % cell arrays e.g. indexes are not altered
        rawValueName = varargin{n};
        fieldType = varargin{n+1};

        % Validate field types only support string int32 and int64 for now
        if ~(strcmpi(char(fieldType), 'int64') || strcmpi(char(fieldType), 'int32') || strcmpi(char(fieldType), 'string'))
            error('ERROR:JSONERROR','Error expected "int64", "int32" or "string" type specifier');
        end

        % Convert the raw names to the valid names
        entries = struct('Type', {}, 'RawString', {}, 'ValidStr', {});
        for m = 1:numel(rawValueName)
            rawVal = rawValueName{m};
            if (isStringScalar(rawVal) || ischar(rawVal))
                rawVal = string(rawVal);
                if strlength(rawVal) == 0
                    entries(end+1) = struct('Type', "Empty", 'RawString', rawVal, 'ValidStr', ""); %#ok<AGROW>
                else
                    % Convert all char to scalar string for more consistent
                    % indexing later
                    validValueName = string(matlab.lang.makeValidName(rawVal));
                    entries(end+1) = struct('Type', "Field", 'RawString', rawVal, 'ValidStr', validValueName);%#ok<AGROW>
                end
            elseif iscell(rawVal)
                entries(end+1) = struct('Type', "Index", 'RawString', rawVal, 'ValidStr', ""); %#ok<AGROW>
            end
        end
        rules(end+1) = struct('FieldType', fieldType, 'Entries', entries, 'AllowMissing', allowMissing); %#ok<AGROW>
    end
end

function result = applyRule(result, gsonObj, rule)
    result = applyRuleEntry(result, gsonObj, rule, 1);
end

function result = applyRuleEntry(result, gsonObj, rule, entryIdx)
    numEntries = length(rule.Entries);
    entry = rule.Entries(entryIdx);
    isLastEntry = entryIdx == numEntries;
    switch entry.Type
        case "Field"
            if isfield(result, entry.ValidStr)
                gsonElem = gsonObj.get(entry.RawString);
                if isLastEntry
                    % This is the last index, so convert the value
                    result.(entry.ValidStr) = convertWithGson(gsonElem, rule.FieldType);
                else
                    result.(entry.ValidStr) = applyRuleEntry(result.(entry.ValidStr), gsonElem, rule, entryIdx + 1);
                end
            else
                if rule.AllowMissing
                    % This is ok, just ignore conversion
                else
                    error('ERROR:JSONERROR', "allowMissing is false, and a field element is missing: %s", entry.ValidStr);
                end
            end
        case "Index"
            useCell = iscell(result);
            numElems = numel(result);
            gsonIsArray = gsonObj.isJsonArray;
            if isLastEntry
                for k=1:numElems
                    % Do this later
                    error('ERROR:JSONERROR', '"Last level" arrays not yet implemented.')
                end
            else
                for k=1:numElems
                    % In the case of an "array of one element", gson may
                    % reduce this to simply the element.
                    if gsonIsArray
                        gsonElem = gsonObj.get(k-1);
                    else
                        gsonElem = gsonObj;
                    end
                    if useCell
                        result{k} = applyRuleEntry(result{k}, gsonElem, rule, entryIdx+1);
                    else
                        result(k) = applyRuleEntry(result(k), gsonElem, rule, entryIdx+1);
                    end
                end
            end
        case "Empty"
            result = convertWithGson(gsonObj, rule.FieldType);

        otherwise
            error('ERROR:JSONERROR', 'Unknown entry type for conversion.')
    end
end

function result = convertWithGson(gsonElem, fieldType)
    switch fieldType
        case "int64"
            if gsonElem.isJsonPrimitive()
                charVal = char(gsonElem.getAsString());
                result = sscanf(charVal, '%ld');
            else
                % Array parsing could be added, array must be parsed to
                % determine dimensionality
                error('ERROR:JSONERROR', 'Error only JSON primitive (scalar) values are currently supported');
            end
        case "int32"
            if gsonElem.isJsonPrimitive()
                charVal = char(gsonElem.getAsString());
                result = int32(sscanf(charVal, '%ld'));
            else
                % Array parsing could be added, array must be parsed to
                % determine dimensionality
                error('ERROR:JSONERROR', 'Error only JSON primitive (scalar) values are currently supported');
            end
        case "string"
            if gsonElem.isJsonPrimitive()
                result = string(gsonElem.getAsString());
            else
                % Array parsing could be added, array must be parsed to
                % determine dimensionality
                error('ERROR:JSONERROR', 'Error only JSON primitive (scalar) values are currently supported');
            end
        otherwise
            error('ERROR:JSONERROR', 'Unexpected error')
    end

end