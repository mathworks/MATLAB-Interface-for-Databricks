classdef Properties < handle
    % Properties
    %
    % Helper class to keep properties available in different functions
    % throughout build.

    % Copyright 2025-2026 MathWorks, Inc.

    properties (Access = private)
        Data dictionary = configureDictionary("string", "string");
    end

    methods (Access = private)
        % Private constructor prevents external instantiation
        function obj = Properties()
            % obj.Data = rand();  % Example initialization
        end
    end
    methods (Static)
        function obj = getInstance()
            persistent uniqueInstance
            if isempty(uniqueInstance) || ~isvalid(uniqueInstance)
                uniqueInstance = simwrapper.Properties();
            end
            obj = uniqueInstance;
        end

        function clearData()
            obj = simwrapper.Properties.getInstance();
            obj.Data = configureDictionary("string", "string");  % Initialize Data as an empty dictionary
        end

        function [val, found] = getProp(key)
            arguments
                key (1,1) string
            end

            obj = simwrapper.Properties.getInstance();
            found = isKey(obj.Data, key);
            if found
                val = obj.Data(key);
                val = val{1};
            else
                val = [];  % Return empty if key is not found
            end
        end

        function setProp(key, value)
            arguments
                key (1,1) string
                value 
            end

            obj = simwrapper.Properties.getInstance();
            obj.Data(key) = {value};  % Set the property in the dictionary
        end

        function props = getProps()
            obj = simwrapper.Properties.getInstance();
            if obj.Data.isConfigured
                props = keys(obj.Data);  % Retrieve all keys from the dictionary
            else
                props = string.empty;
            end
        end

        function showProps()
            obj = simwrapper.Properties.getInstance();
            disp(obj.Data);
        end

    end

end

