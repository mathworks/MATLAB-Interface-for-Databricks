classdef KeyValue < handle
    % KeyValue Base class for Tag and Param classes
   
    %  Copyright 2020-2022 MathWorks, Inc.

    properties
        key   (1,1) string 
        value (1,1) string
    end

    methods
        function obj = KeyValue(varargin)
            if nargin == 1 && isstruct(varargin{1})
                data = varargin{1};
                N = length(data);
                for k=N:-1:1
                    obj(k).key = data(k).key;
                    obj(k).value = data(k).value;
                end
            else
                N = nargin;
                assert(rem(N, 2) == 0, 'Key value arguments must come in pairs');
                idx = 1;
                for k=1:2:N
                    obj(idx).key = varargin{k}; %#ok<AGROW>
                    obj(idx).value = varargin{k+1}; %#ok<AGROW>
                    idx = idx + 1;
                end
            end
        end

        function S = toStruct(obj)
            N = length(obj);
            if N == 0
                S = struct("key", {}, "value", {});
            else
                for k = N:-1:1
                    S(k) = struct(...
                        "key", obj(k).key, ...
                        "value", obj(k).value);
                end
            end
        end

        function T = toTable(obj)
            T = struct2table(toStruct(obj));
        end
    end
end