classdef Token < databricks.Object & matlab.mixin.CustomDisplay
    % TOKEN Databricks API token
    % A databricks Token allows creation, list, revocation of Personal Access Tokens
    % (PATs) the can be used to authenticate and access Databricks REST APIs if
    % enabled.
    %
    % Optional arguments:
    %
    %   verbose: Enable additional output
    %
    % Example:
    % t = databricks.Token()
    % l = t.list();
    
    %  (c) 2019-2026 MathWorks, Inc.

    properties
        token_value
        token_info
    end

    methods
        % Constructor
        function obj = Token(varargin)
            obj.getAuth(varargin{:});
        end
    end

    methods(Access = protected)
        function groups = getPropertyGroups(obj)
            % GETPROPERTYGROUPS Redacts sensitive information from the object display
            if isscalar(obj)
                groups = getPropertyGroups@matlab.mixin.CustomDisplay(obj);
                if ~isempty(obj.token_value) && strlength(obj.token_value) > 0
                    groups.PropertyList.token_value =  "<REDACTED>";
                end
            else
                % Nonscalar case: call superclass method
                groups = getPropertyGroups@matlab.mixin.CustomDisplay(obj);
            end
        end
    end
end