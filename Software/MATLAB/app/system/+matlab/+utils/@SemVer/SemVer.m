classdef SemVer
    % SEMVER Class to support semantic versioning
    % See: https://semver.org
    % Assumes numeric field are non negative.
    % Numeric fields stored as int32 values.
    % Supports PR label strings e.g. 1.2.3-beta and +<metadata> values.
    %
    % Examples:
    %   % No arguments, returns a value of 0.0.0
    %   x = matlab.utils.SemVer();
    %
    %   % Overrides for > < >= <= ==
    %   x = matlab.utils.SemVer("1.2.3");
    %   y = matlab.utils.SemVer("1.2.4");
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
    %   x = matlab.utils.SemVer(3.14)
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

    % Copyright 2022-2026 The MathWorks, Inc.

    properties(Dependent)
        major int32
        minor int32
        patch int32
        prerelease string
        metadata string
    end

    properties(SetAccess = private)
        semverImpl matlab.internal.utils.SemVer;
    end

    methods
        function val = get.major(obj)
            val = obj.semverImpl.major;
        end

        function obj = set.major(obj, val)
            obj.semverImpl.major = val;
        end

        function val = get.minor(obj)
            val = obj.semverImpl.minor;
        end

        function obj = set.minor(obj, val)
            obj.semverImpl.minor = val;
        end

        function val = get.patch(obj)
            val = obj.semverImpl.patch;
        end

        function obj = set.patch(obj, val)
            obj.semverImpl.patch = val;
        end

        function val = get.prerelease(obj)
            val = obj.semverImpl.prerelease;
        end

        function obj = set.prerelease(obj, val)
            obj.semverImpl.prerelease = val;
        end

        function val = get.metadata(obj)
            val = obj.semverImpl.metadata;
        end

        function obj = set.metadata(obj, val)
            obj.semverImpl.metadata = val;
        end

        function obj = SemVer(varargin)
            if nargin == 0
                obj.semverImpl = matlab.internal.utils.SemVer();
            elseif nargin == 1 && isa(varargin{1}, 'matlab.utils.SemVer')
                obj.semverImpl = varargin{1}.semverImpl;
            else
                internalObjs = matlab.internal.utils.SemVer(varargin{:});
                for n = numel(internalObjs):-1:1
                    obj(n).semverImpl = internalObjs(n);
                end
            end
        end


        function tf = inRange(obj, lowerVer, upperVer)
            if isa(lowerVer, 'matlab.utils.SemVer'), lowerVer = lowerVer.semverImpl; end
            if isa(upperVer, 'matlab.utils.SemVer'), upperVer = upperVer.semverImpl; end
            tf = obj.semverImpl.inRange(lowerVer,upperVer);
        end


        function tf = eq(obj, ver)
            if isa(ver, 'matlab.utils.SemVer'), ver = ver.semverImpl; end
            tf = obj.semverImpl.eq(ver);
        end


        function tf = ne(obj, ver)
            if isa(ver, 'matlab.utils.SemVer'), ver = ver.semverImpl; end
            tf  = obj.semverImpl.ne(ver);
        end


        function tf = lt(obj, ver)
            if isa(ver, 'matlab.utils.SemVer'), ver = ver.semverImpl; end
            tf = obj.semverImpl.lt(ver);
        end


        function tf = le(obj, ver)
            if isa(ver, 'matlab.utils.SemVer'), ver = ver.semverImpl; end
            tf = obj.semverImpl.le(ver);
        end


        function tf = gt(obj, ver)
            if isa(ver, 'matlab.utils.SemVer'), ver = ver.semverImpl; end
            tf = obj.semverImpl.gt(ver);
        end


        function tf = ge(obj, ver)
            if isa(ver, 'matlab.utils.SemVer'), ver = ver.semverImpl; end
            tf = obj.semverImpl.ge(ver);
        end


        function str = toString(obj)
            str = obj.semverImpl.toString();
        end

        function str = string(obj)
            str = obj.semverImpl.string();
        end
    end


    methods(Hidden)
        function obj = strArray2SemVer(obj, str)
            obj = obj.semverImpl.strArray2SemVer(str);
        end


        function [major,minor,patch,prerelease,metadata] = str2SemVer(obj, str)
            [major,minor,patch,prerelease,metadata] = obj.semverImpl.str2SemVer(str);
        end
    end


    methods(Static)
        function result = compareVersions(ver1, ver2)
            if isa(ver1, 'matlab.utils.SemVer'), ver1 = ver1.semverImpl; end
            if isa(ver2, 'matlab.utils.SemVer'), ver2 = ver2.semverImpl; end
            result = matlab.internal.utils.SemVer.compareVersions(ver1, ver2);
        end

        function result = sort(verVals, varargin)
            if isa(verVals, 'matlab.utils.SemVer')
                verVals = arrayfun(@(x) x.semverImpl, verVals);
            end

            resultArray = matlab.internal.utils.SemVer.sort(verVals,varargin{:});
            result = arrayfun(@(x) matlab.utils.SemVer(x), resultArray);
        end

        function result = compareAlpha(ver1, ver2)
            if isa(ver1, 'matlab.utils.SemVer'), ver1 = ver1.semverImpl; end
            if isa(ver2, 'matlab.utils.SemVer'), ver2 = ver2.semverImpl; end
            result = matlab.internal.utils.SemVer.compareAlpha(ver1, ver2);
        end
    end


    methods(Static, Hidden)
        function result = compareOneNumericLevel(v1, v2)
            if isa(v1, 'matlab.utils.SemVer'), v1 = v1.semverImpl; end
            if isa(v2, 'matlab.utils.SemVer'), v2 = v2.semverImpl; end
            result = matlab.internal.utils.SemVer.compareOneNumericLevel(v1,v2);
        end


        function result = comparePR(pr1, pr2)
            if isa(pr1, 'matlab.utils.SemVer'), pr1 = pr1.semverImpl; end
            if isa(pr2, 'matlab.utils.SemVer'), pr2 = pr2.semverImpl; end
            result = matlab.internal.utils.SemVer.comparePR(pr1,pr2);
        end


        function result = comparePRField(prf1, prf2)
            if isa(prf1, 'matlab.utils.SemVer'), prf1 = prf1.semverImpl; end
            if isa(prf2, 'matlab.utils.SemVer'), prf2 = prf2.semverImpl; end
            result = matlab.internal.utils.SemVer.comparePRField(prf1, prf2);
        end


        function tf = preq(v1, v2)
            if isa(v1, 'matlab.utils.SemVer'), v1 = v1.semverImpl; end
            if isa(v2, 'matlab.utils.SemVer'), v2 = v2.semverImpl; end
            tf = matlab.internal.utils.SemVer.comparePRField(v1,v2);
        end


        function result = conv2int32(input)
            if isa(input, 'matlab.utils.SemVer'), input = input.semverImpl; end
            result = matlab.internal.utils.SemVer.conv2int32(input);
        end
    end
end
