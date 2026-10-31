classdef SemVer
    % SEMVER Class to support semantic versioning
    % See: https://semver.org
    % Assumes numeric field are non negative.
    % Numeric fields stored as int32 values.
    % Supports PR label strings e.g. 1.2.3-beta and +<metadata> values.
    %
    % Examples:
    %   % No arguments, returns a value of 0.0.0
    %   x = matlab.internal.utils.SemVer();
    %
    %   % Overrides for > < >= <= ==
    %   x = matlab.internal.utils.SemVer("1.2.3");
    %   y = matlab.internal.utils.SemVer("1.2.4");
    %   >> x > y
    %   ans =
    %     logical
    %      0
    %
    %   >> gt(x,y)
    %   ans =
    %     logical
    %      0
    %
    %   % Use a single numeric value, double and single values will be cast to an int32
    %   % i.e. 3.14 is taken to mean v4 not v3.14.0
    %   x = matlab.internal.utils.SemVer(3.14)
    %   x = 
    %   SemVer with properties:
    %         major: 3
    %         minor: 0
    %         patch: 0
    %    prerelease: ""
    %      metadata: ""

    % Copyright 2022-2026 The MathWorks, Inc.

    % TODO
    % Consider performance

    properties
        major int32 = 0
        minor int32 = 0
        patch int32 = 0
        prerelease string = ""
        metadata string = ""
    end

    properties (Hidden)
        baseErrorPrefix = "MATLAB:UTILS:SEMVER"
    end

    methods
        function obj = SemVer(varargin)
            if nargin == 1
                % Input of type semver, a character vector or scalar string or string array
                % A string array will be joined with no delimiters
                switch class(varargin{1})
                    case 'matlab.internal.utils.SemVer'
                        obj = varargin{1};

                    case 'char'
                        [major,minor,patch,prerelease,metadata] = str2SemVer(obj, varargin{1});
                        obj.major = major;
                        obj.minor = minor;
                        obj.patch = patch;
                        obj.prerelease = prerelease;
                        obj.metadata = metadata;

                    case 'string'
                        for n = 1:numel(varargin{1})
                            [major,minor,patch,prerelease,metadata] = str2SemVer(obj, varargin{1}(n));
                            obj(n).major = major; %#ok<AGROW>
                            obj(n).minor = minor; %#ok<AGROW>
                            obj(n).patch = patch; %#ok<AGROW>
                            obj(n).prerelease = prerelease; %#ok<AGROW>
                            obj(n).metadata = metadata; %#ok<AGROW>
                        end
                    
                    case {'double', 'single', 'uint32', 'int32', 'uint8', 'int8', 'uint64', 'int64' }
                        if ~isscalar(varargin{1})
                            error(obj.baseErrorPrefix+":SCALAR", "Numeric argument must be scalar.");
                        end
                        if ~isreal(varargin{1})
                            error(obj.baseErrorPrefix+":REAL", "Numeric argument must be real.");
                        end
                        if ~isfinite(varargin{1})
                            error(obj.baseErrorPrefix+":FINITE", "Numeric argument must be finite.");
                        end
                        if varargin{1} > intmax("int32")
                            error(obj.baseErrorPrefix+":TOOBIG", "Argument is greater than the maximum permitted version: %d", intmax("int32"));
                        end
                        if varargin{1} < 0
                            error(obj.baseErrorPrefix+":NEGATIVE", "Argument is less than 0.");
                        end
                        obj.major = int32(varargin{1});

                        % TODO error(obj.baseErrorPrefix, 'Single string arguments must be scalar.');

                    otherwise
                        error(obj.baseErrorPrefix, 'Unexpected argument type: %s', class(varargin{1}));
                end
            elseif nargin == 0
                % Do nothing, default class instance, 0.0.0
            else
                error(obj.baseErrorPrefix, 'Unsupported number of varargin arguments: %d', length(varargin));
            end

            % Some minimal validation
            for n = 1:numel(obj)
                if isempty(obj(n).major)...
                        || isempty(obj(n).minor)...
                        || isempty(obj(n).patch)...
                        || isempty(obj(n).prerelease)...
                        || isempty(obj(n).metadata)
                    error(obj(n).baseErrorPrefix, 'SemVer object has an empty property.');
                end
            end
        end


        function tf = inRange(obj, lowerVer, upperVer)
            % INRANGE Returns true if version is >= lowerVer and <= upperVer

            arguments
                obj (1,1)
                lowerVer (1,:)
                upperVer (1,:)
            end

            lowerVer = matlab.internal.utils.SemVer(lowerVer);
            upperVer = matlab.internal.utils.SemVer(upperVer);

            if obj.ge(lowerVer) && obj.le(upperVer)
                tf = true;
            else
                tf = false;
            end
        end


        function tf = eq(obj, ver)
            % EQ Returns true if the version is equal to the object's value
            arguments
                obj (1,1)
                ver (1,:)
            end

            ver = matlab.internal.utils.SemVer(ver);
            result = matlab.internal.utils.SemVer.compareVersions(obj, ver);

            if result == 0
                tf = true;
            else
                tf = false;
            end
        end


        function tf = ne(obj, ver)
            % NE Returns true if the version is not equal to the object's value
            arguments
                obj (1,1)
                ver (1,:)
            end

            tf = ~obj.eq(ver);
        end


        function tf = lt(obj, ver)
            % LT Returns true if the version is less than the object's value
            arguments
                obj (1,1)
                ver (1,:)
            end

            ver = matlab.internal.utils.SemVer(ver);
            result = matlab.internal.utils.SemVer.compareVersions(obj, ver);

            if result == -1
                tf = true;
            else
                tf = false;
            end
        end


        function tf = le(obj, ver)
            % LE Returns true if the version is less than or equal to the object's value
            arguments
                obj (1,1)
                ver (1,:)
            end

            ver = matlab.internal.utils.SemVer(ver);
            result = matlab.internal.utils.SemVer.compareVersions(obj, ver);

            if result == -1 || result == 0
                tf = true;
            else
                tf = false;
            end
        end


        function tf = gt(obj, ver)
            % GT Returns true if the version is greater than the object's value
            arguments
                obj (1,1)
                ver (1,:)
            end

            ver = matlab.internal.utils.SemVer(ver);
            result = matlab.internal.utils.SemVer.compareVersions(obj, ver);

            if result == 1
                tf = true;
            else
                tf = false;
            end
        end


        function tf = ge(obj, ver)
            % GE Returns true if the version is greater than or equal to the object's value
            arguments
                obj (1,1)
                ver (1,:)
            end

            ver = matlab.internal.utils.SemVer(ver);
            result = matlab.internal.utils.SemVer.compareVersions(obj, ver);

            if result == 1 || result == 0
                tf = true;
            else
                tf = false;
            end
        end


        function str = toString(obj)
            % TOSTRING Returns the version as a field separated string, metadata is included if present
            arguments
                obj (1,1)
            end

            str = string(sprintf('%d.%d.%d', obj.major, obj.minor, obj.patch));
            if strlength(obj.prerelease) > 0
                str = str + "-" + obj.prerelease;
            end
            if strlength(obj.metadata) > 0
                str = str + "+" + obj.metadata;
            end
        end

        function str = string(obj)
            % STRING Returns the version as a field separated string, metadata is included if present
            arguments
                obj matlab.internal.utils.SemVer
            end
            if isscalar(obj)
                str = obj.toString;
            else
                str = arrayfun(@(x) x.toString, obj, 'UniformOutput', true);
            end
        end
    end


    methods(Hidden)
        function obj = strArray2SemVer(obj, str)
            arguments
                obj (1,1)
                str string {mustBeNonzeroLengthText}
            end

            if numel(str) == 0 || numel(str) > 5
                error(obj.baseErrorPrefix, 'Invalid version value: %s', str);
            end

            if numel(str) >= 1
                obj.major = obj.conv2int32(str(1));
            end
            if numel(str) >= 2
                obj.minor = obj.conv2int32(str(2));
            end
            if numel(str) >= 3
                obj.patch = obj.conv2int32(str(3));
            end
            if numel(str) >= 4
                obj.prerelease = str(4);
            end
            if numel(str) == 5
                obj.metadata = str(5);
            end
        end


        function [major,minor,patch,prerelease,metadata] = str2SemVer(obj, str)
            arguments
                obj
                str string {mustBeTextScalar, mustBeNonzeroLengthText}
            end

            major = int32(0);
            minor = int32(0);
            patch = int32(0);
            prerelease = ""; %#ok<NASGU>
            metadata = "";

            % strip any + and following fields
            if contains(str, '+')
                prePlusStr = extractBefore(str, '+');
                if strlength(prePlusStr) == 0
                    error(obj.baseErrorPrefix, 'Invalid version value: %s', str);
                end
                metadata = extractAfter(str, '+');
            else
                prePlusStr = str;
            end

            if startsWith(prePlusStr, '-')
                error(obj.baseErrorPrefix, 'Invalid version value: %s', str);
            end

            if contains(prePlusStr, '-')
                prerelease = extractAfter(prePlusStr, '-');
                mmpStr = extractBefore(prePlusStr, '-');
            else
                prerelease = "";
                mmpStr = prePlusStr;
            end

            verFields = split(mmpStr, '.')';
            if numel(verFields) == 0 || numel(verFields) > 3
                % A true sematic version should not have 4 dotted fields
                % e.g. 1.2.3.4
                error(obj.baseErrorPrefix, 'Invalid version value: %s', str);
            end
            if numel(verFields) >= 1
                major = obj.conv2int32(verFields(1));
            end
            if numel(verFields) >= 2
                minor = obj.conv2int32(verFields(2));
            end
            if numel(verFields) >= 3
                patch = obj.conv2int32(verFields(3));
            end
        end
    end


    methods(Static)
        function result = compareVersions(ver1, ver2)
            % compareVersions Compares two Semantic Version values
            % If they are equal 0 is returned
            % If ver1 is less than v2 -1 is returned
            % If ver1 is greater than v2 1 is returned

            arguments
                ver1 (1,1)
                ver2 (1,1)
            end

            ver1 = matlab.internal.utils.SemVer(ver1);
            ver2 = matlab.internal.utils.SemVer(ver2);

            result = matlab.internal.utils.SemVer.compareOneNumericLevel(ver1.major, ver2.major);
            if result ~= 0
                return;
            end

            result = matlab.internal.utils.SemVer.compareOneNumericLevel(ver1.minor, ver2.minor);
            if result ~= 0
                return;
            end

            result = matlab.internal.utils.SemVer.compareOneNumericLevel(ver1.patch, ver2.patch);
            if result ~= 0
                return;
            end

            result = matlab.internal.utils.SemVer.comparePR(ver1.prerelease, ver2.prerelease);
        end


        function result = sort(verVals, direction)
            % sort Sort an array of Sematic Version values
            % direction can be either ascending or descending.
            % The default is ascending.
            % An array of matlab.internal.utils.SemVer is returned.

            % Crude implementation intended for sorting small arrays only where
            % performance is not a primary concern

            arguments
                verVals (1,:)
                direction (1,1) string {mustBeTextScalar, mustBeNonzeroLengthText}= "ascending"
            end

            baseErrorPrefix = "MATLAB:UTILS:SEMVER";
            if strcmpi(direction, 'ascending')
                ascending = true;
            elseif strcmpi(direction, 'descending')
                ascending = false;
            else
                error(baseErrorPrefix, 'Sorting direction must be: ascending or descending');
            end

            if isstring(verVals)
                result = matlab.internal.utils.SemVer(verVals);
            elseif isa(verVals, 'matlab.internal.utils.SemVer')
                result = verVals;
            else
                error(baseErrorPrefix, 'Argument must be of type matlab.internal.utils.SemVer, string');
            end

            for n = 1:numel(result)
                for m = 1:numel(result)-1
                    if ascending
                        if result(m).gt(result(m+1))
                            tempVal = result(m+1);
                            result(m+1) = result(m);
                            result(m) = tempVal;
                        end
                    else
                        if result(m).lt(result(m+1))
                            tempVal = result(m+1);
                            result(m+1) = result(m);
                            result(m) = tempVal;
                        end
                    end
                end
            end
        end

        function result = compareAlpha(ver1, ver2)
            % comparAlpha Compares two Semantic Version values
            % If they are equal 'eq' is returned as a character vector
            % If ver1 is less than v2 'lt' is returned as a character vector
            % If ver1 is greater than v2 'gt' is returned as a character vector

            arguments
                ver1 (1,1)
                ver2 (1,1)
            end

            ver1 = matlab.internal.utils.SemVer(ver1);
            ver2 = matlab.internal.utils.SemVer(ver2);

            resultNumeric = matlab.internal.utils.SemVer.compareVersions(ver1, ver2);

            if resultNumeric == 0
                result = 'eq';
            elseif resultNumeric == 1
                result = 'gt';
            elseif resultNumeric == -1
                result = 'lt';
            else
                error('MATLAB:UTILS:SEMVER', 'Comparison failed: %f', resultNumeric);
            end
        end
    end


    methods(Static, Hidden)
        function result = compareOneNumericLevel(v1, v2)
            arguments
                v1 (1,1) int32
                v2 (1,1) int32
            end

            if v1 < v2
                result = -1;
            elseif v1 > v2
                result = 1;
            else
                result = 0;
            end
        end


        function result = comparePR(pr1, pr2)
            arguments
                pr1 string {mustBeTextScalar}
                pr2 string {mustBeTextScalar}
            end

            % Short circuit cases where there is only one value
            % no need to look at the values

            % Simple check for equality, also covers "" == ""
            % pr1 == pr2
            if strcmp(pr1, pr2)
                result = 0;
                return;
            end

            % No prerelease has higher precedence than a release
            % pr1 > pr2
            if strlength(pr1) == 0 && strlength(pr2) > 0
                result = 1;
                return;
            end
            % pr1 < pr2
            if strlength(pr1) > 0 && strlength(pr2) == 0
                result = -1;
                return;
            end

            %% full comparison needed

            pr1fields = split(pr1, '.');
            pr2fields = split(pr2, '.');
            leastFields = min(numel(pr1fields), numel(pr2fields));

            % Stop comparing when the first PR runs out of fields
            result = [];
            for n = 1:leastFields
                cmp = matlab.internal.utils.SemVer.comparePRField(pr1fields(n), pr2fields(n));
                if cmp == 1
                    result = 1;
                    break
                elseif cmp == -1
                    result = -1;
                    break
                elseif cmp == 0
                    % keep going through fields, no break
                    result = 0;
                else
                    baseErrorPrefix = "MATLAB:UTILS:SEMVER";
                    error(baseErrorPrefix, "Invalid return from comparePRField().");
                end
            end
            if result == 0
                if numel(numel(pr1fields)) > numel(pr2fields)
                    result = 1;
                elseif numel(numel(pr1fields)) < numel(pr2fields)
                    result = -1;
                elseif numel(numel(pr1fields)) == numel(pr2fields)
                    result = 0;
                else
                    baseErrorPrefix = "MATLAB:UTILS:SEMVER";
                    error(baseErrorPrefix, "Invalid state.");
                end
            end
        end


        function result = comparePRField(prf1, prf2)
            arguments
                prf1 string {mustBeTextScalar}
                prf2 string {mustBeTextScalar}
            end
            baseErrorPrefix = "MATLAB:UTILS:SEMVER";
            alphaNumericExp = "[a-zA-Z0-9-]";

            prf1IsNumeric = any(matches(prf1, digitsPattern));
            prf2IsNumeric = any(matches(prf2, digitsPattern));

            if prf1IsNumeric
                % If it is numeric it is also alpha numeric
                prf1IsAlphaNumeric = true;
            else
                if strlength(prf1) == numel(regexp(prf1, alphaNumericExp))
                    prf1IsAlphaNumeric = true;
                else
                    prf1IsAlphaNumeric = false;
                end
            end

            if prf2IsNumeric
                % If it is numeric it is also alpha numeric
                prf2IsAlphaNumeric = true;
            else
                if strlength(prf2) == numel(regexp(prf2, alphaNumericExp))
                    prf2IsAlphaNumeric = true;
                else
                    prf2IsAlphaNumeric = false;
                end
            end

            % Sanity check, it must be one or both of
            if ~prf1IsNumeric && ~prf1IsAlphaNumeric
                error(baseErrorPrefix, 'Invalid prerelease field: %s', prf1);
            end
            if ~prf2IsNumeric && ~prf2IsAlphaNumeric
                error(baseErrorPrefix, 'Invalid prerelease field: %s', prf2);
            end

            % Numeric identifiers always have lower precedence than non-numeric identifiers
            if prf1IsNumeric && prf1IsAlphaNumeric
                result = -1;
                return;
            end
            if prf1IsAlphaNumeric && prf2IsNumeric
                result = 1;
                return;
            end

            % Identifiers consisting of only digits are compared numerically.
            if prf1IsNumeric && prf2IsNumeric
                result =  matlab.internal.utils.SemVer.compareOneNumericLevel(matlab.internal.utils.SemVer.conv2int32(prf1), matlab.internal.utils.SemVer.conv2int32(prf2));
                return;
            end

            % Identifiers with letters or hyphens and possibly numbers are compared lexically in ASCII sort order.
            if prf1IsAlphaNumeric && prf2IsAlphaNumeric
                % pr1 > pr2
                if strlength(prf1) == 0 && strlength(prf2) > 0
                    result = 1;
                    return;
                end
                % pr1 < pr2
                if strlength(prf1) > 0 && strlength(prf2) == 0
                    result = -1;
                    return;
                end

                if prf1 > prf2
                    result = 1;
                elseif prf1 < prf2
                    result = -1;
                elseif prf1 == prf2
                    result = 0;
                else
                    error(baseErrorPrefix, 'Invalid state.');
                end
                return;
            end

            % Should not get here
            error(baseErrorPrefix, 'Unable to compare: %s and %s', prf1, prf2);
        end


        function tf = preq(v1, v2)
            arguments
                v1 string {mustBeTextScalar, mustBeNonzeroLengthText}
                v2 string {mustBeTextScalar, mustBeNonzeroLengthText}
            end
            tf = strcmp(v1, v2);
        end


        function result = conv2int32(input)
            arguments
                input string {mustBeTextScalar, mustBeNonzeroLengthText}
            end

            val = double(input);
            if isnan(val)
                result = int32(0);
            else
                result = int32(val);
            end
        end
    end
end
