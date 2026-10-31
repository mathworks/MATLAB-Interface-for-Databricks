classdef Row < matlab.pyspark.internal.PyWrapper ...
        & matlab.mixin.indexing.RedefinesDot
    % Row Pyspark Row wrapper
    %
    % This class is a wrapper for the pyspark Row class.
    %
    % MATLAB strings used to create Row names and or values will be returned
    % as character vectors, e.g.:
    %   row = matlab.pyspark.sql.row.Row("name", 'age')
    %   row =
    %    <Row('name', 'age')>
    %
    %
    % bracket() can be used to access Row values by name, equivalent
    % to row['name'] or row["name"], e.g.:
    %   row.bracket('name')
    %       'Alice'
    %
    % Examples:
    %   % Create a row from a pair of name-value cell arrays:
    %   row = matlab.pyspark.sql.row.Row({"name", "age", "eyecolour"}, {"Alice", 11, "green"})
    %
    %   % Create a row from a containers.Map
    %   cm = containers.Map({'name','age'}, {"Alice", int64(11)});
    %   row = matlab.pyspark.sql.row.Row(cm);
    %
    %   % A Row can be created from a py.pyspark.sql.types.Row object:
    %   row = matlab.pyspark.sql.row.Row(<py.pyspark.sql.types.Row object>);
    %
    %   % Rows also can be used to create another Row like class,
    %   % then it could be used to create Row objects, such as
    %   row = matlab.pyspark.sql.row.Row("name", "age");
    %
    %   % Create a Row containing a row
    %   subrow = matlab.pyspark.sql.row.Row({"name", "age"}, {"a", 2});
    %   row = matlab.pyspark.sql.row.Row({"key", "value"}, {1, subrow});
    %   d = row.asDict;
    %   d = row.asDict(true); % Recursively create dictionaries
    %
    % See also: https://spark.apache.org/docs/latest/api/python/reference/pyspark.sql/api/pyspark.sql.Row.html

    % (c) 2026 MathWorks, Inc.

    properties (Hidden)
        row
    end

    methods
        function obj = Row(varargin)
            if nargin==1
                switch class(varargin{1})
                    case 'py.pyspark.sql.types.Row'
                        obj.row = varargin{1};

                    case 'containers.Map'
                        kvStr = matlab.pyspark.sql.row.Row.containersMapToKVStr(varargin{1});
                        obj.row = pyrun(sprintf('from pyspark.sql.types import Row; a = Row(%s)', kvStr), "a");

                    case {'string','char'}
                        obj.row = py.pyspark.sql.types.Row(varargin{1});

                        % TODO, consider other argument possibilities, e.g.:
                        % Untested concepts - not working code
                        % case'py.str'
                        %     dataPy = pyrun(sprintf("a = %s", string(varargin{1})), "a");
                        %     obj.row = py.pyspark.sql.types.Row(dataPy);
                        %
                        % case'py.dict'
                        %     obj.row = py.pyspark.sql.types.Row(varargin{1});
                        %
                        % case 'cell'
                        %     dataPy = py.list(varargin{1});
                        %     obj.row = py.pyspark.sql.types.Row(dataPy);

                    otherwise
                        error('sparkapi:row_constructor', 'Unexpected scalar argument class: %s', class(varargin{1}));
                end
            elseif nargin==2 && iscell(varargin{1}) && iscell(varargin{2})
                if numel(varargin{1}) ~= numel(varargin{2})
                    error('sparkapi:cell_row_constructor',...
                        "Expected cell array inputs to have the same number of elements.");
                end
                pyArgsCellArray = reshape([varargin{1}; cellfun(@matToPy, varargin{2}, 'UniformOutput', false)], 1, []);
                obj.row = py.pyspark.sql.types.Row(pyargs(pyArgsCellArray{:}));
            else
                if all(cellfun(@(x) (ischar(x) && isrow(x)) || (isstring(x)), varargin))
                    obj.row = py.pyspark.sql.types.Row(varargin{:});
                else
                    error('sparkapi:rowassign', ...
                        'Invalid arguments for Row construction. All arguments must be scalar text or use two cell arrays of equal length.');
                end
            end
        end

        function pyObj = toPy(obj)
            pyObj = obj.row;
        end

        function disp(obj)
            nObjs = numel(obj);
            if nObjs > 1
                result = "[";
            else
                result = "";
            end
            for n = 1:nObjs
                str = formattedDisplayText(obj(n).row);
                lines = split(strip(str), newline);
                lastLine = strip(lines(end));
                result = result + lastLine;
                if n ~= nObjs
                    result = result + ", ";
                end
            end
            if nObjs > 1
                result = result + "]";
            end
            fprintf("%s\n", result);
        end
    end


    methods (Access=protected)
        function obj = dotAssign(obj,indexOp,varargin) %#ok<INUSD>
            error('sparkapi:rowassign', ...
                'Values cannot be assigned to a Row.');
        end

        function n = dotListLength(obj,indexOp,indexContext) %#ok<INUSD>
            % Assuming our methods will always return a value
            % assert(eq(listLength(obj.AddedFields, indexOp, indexContext), 1),...
            %     'sparkapi:bad_list_length',...
            %     'Expected dotListLength to return 1.');
            n = 1;
        end

        function varargout = dotReference(obj,indexOp)
            if numel(indexOp) == 1 %#ok<ISCL>
                if indexOp(1).Type == "Dot"
                    pyOut = obj.row(indexOp(1).Name);
                    varargout{1} = matlab.pyspark.sql.row.Row.pyToMATLAB(pyOut);
                else
                    error("sparkapi:rowassign:dotreference",...
                        "Only indexOp Dot is currently supported by Row.");
                end
            elseif numel(indexOp) == 2
                if indexOp(1).Type == "Dot" && indexOp(1).Name == "bracke" && indexOp(2).Type == "Paren"
                    if numel(indexOp(2).Indices) == 1 %#ok<ISCL>
                        pyOut = obj.row(index(2).Indices{1});
                        varargout{1} = matlab.pyspark.sql.row.Row.pyToMATLAB(pyOut);
                    else
                        error("sparkapi:rowassign:dotreference",...
                            "Unexpected index for Row.");
                    end
                else
                    error("sparkapi:rowassign:dotreference",...
                        "Unexpected bracket index for Row.");
                end
            else
                error("sparkapi:rowassign:dotreference",...
                    "Only 1 or 2 indexOps is currently supported by Row.");
            end
        end
    end


    methods(Hidden)
        function result = bracket(obj, arg)
            % bracket Implement the row[arg] method
            %
            % This function is not targeted at general usage. It is
            % intended to handle bracket ([]) operations in Python in MATLAB.
            % For example:
            %   Python - row['a']
            %   MATLAB - row.bracket('a')
            %
            % Examples:
            %   % row foo
            %   row.bracket('foo')
            %   % row foo
            %   row.bracket("foo")
            %
            % If the object is empty [] is returned.
            %
            % If called on an array of matlab.pyspark.sql.row.Row a cell
            % array of results are returned.

            arguments (Input)
                obj matlab.pyspark.sql.row.Row
                arg
            end
            arguments (Output)
                result
            end

            if isempty(obj)
                result = [];
                return;
            elseif isscalar(obj)
                if isscalar(arg) || (ischar(arg) && isrow(arg))
                    switch class(arg)
                        case 'char'
                            pyOut = obj.row(arg);
                            result = matlab.pyspark.sql.row.Row.pyToMATLAB(pyOut);

                        case 'string'
                            if isscalar(arg)
                                pyOut = obj.row(arg);
                                result = matlab.pyspark.sql.row.Row.pyToMATLAB(pyOut);
                            else
                                error("sparkapi:non_scalar_string_argument", ...
                                    "String arguments to the Row bracket method must be scalar.");
                            end

                        otherwise
                            error("sparkapi:bad_bracket_argument", ...
                                "The Row bracket method does not take arguments of type '%s'.", class(arg));
                    end
                else
                    error("sparkapi:nonscalar_bracket_argument", ...
                        "Expected arg argument to be scalar,");
                end
            elseif isvector(obj)
                result = cell(size(obj));
                for n = 1:numel(obj)
                    result{n} = obj(n).bracket(arg);
                end
            else
                error("sparkapi:bad_bracket_row_argument", ...
                    "Expected an empty, scalar, or vector matlab.pyspark.sql.row.Row.");
            end
        end
    end


    methods (Hidden, Static)
        function out = pyToMATLAB(in)
            % pyToMATLAB Converts some base Python types to MATLAB equivalents.
            %
            % Example:
            %   out = matlab.pyspark.sql.row.Row.pyToMATLAB(py.str("hello"))

            switch class(in)
                % Existing MATLAB types do nothing, have previously been converted
                case {'logical', 'char', 'string', 'double', 'single'}
                    out = in;

                case {'int8' , 'int16', 'int32', 'int64', 'uint8', 'uint16', 'uint32', 'uint64'}
                    out = in;

                case 'py.str'
                    out = char(in);

                case 'py.int'
                    out = int64(in);

                case 'py.float'
                    out = double(in);

                case 'py.bool'
                    out = logical(in);

                case 'py.tuple'
                    out = cell(in);

                case 'py.dict'
                    out = dictionary(in);

                otherwise
                    error("sparkapi:rowassign:dotreference:noconvert",...
                        "Conversion of type: %s, is not currently supported by Row.", class(in));
            end
        end

        function kvStr = containersMapToKVStr(cm)
            % containersMapToKVStr Converts a containers.Map to a Python key-pair arguments string
            % Example:
            %   name="Alice", age=11
            %   keySet = {'name','age'};
            %   valueSet = {"Alice", int64(11)};
            %   cm = containers.Map(keySet, valueSet);
            %   kvStr = matlab.pyspark.sql.row.Row.containersMapToKVStr(cm)
            %   kvStr =
            %       "age=11, name=Alice"

            arguments (Input)
                cm containers.Map
            end
            arguments (Output)
                kvStr string {mustBeTextScalar}
            end

            kvStr = "";
            keys = cm.keys;
            for n = 1:numel(keys)
                kvStr = kvStr + string(keys{n}) + "=";
                if isStringScalar(cm(keys{n})) || ischar(cm(keys{n}))
                    if contains(cm(keys{n}), '"')
                        error("sparkapi:row:containersMapToKVStr:quotes",...
                            "String values containing double quotes are not current;ly supported.");
                    else
                        kvStr = kvStr + """" + string(cm(keys{n})) + """";
                    end
                elseif isa(cm(keys{n}), 'string') && isvector(cm(keys{n}))
                    error("sparkapi:row:containersMapToKVStr:vector",...
                        "Assignment of non scalar string values is not currently supported.");
                %elseif isa(cm(keys{n}), 'matlab.pyspark.sql.row.Row')
                %    kvStr = kvStr + matlab.pyspark.sql.row.Row.containersMapToKVStr(cm(keys{n}));
                else
                    kvStr = kvStr + string(cm(keys{n}));
                end
                if n ~= numel(keys)
                    kvStr = kvStr + ", ";
                end
            end
        end
    end
end


function out = matToPy(in)
    if isa(in, 'matlab.pyspark.sql.row.Row')
        out = in.toPy();
    else
        out = in;
    end
end