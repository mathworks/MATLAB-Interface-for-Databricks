classdef ClusterTag < databricks.Object
    % CLUSTERTAG Class to specify tags to attach to the create object.
    % Use to configure Tags on the databricks cluster.
    % Keys and values must be character vectors or scalar strings.
    % Both keys and values are stored as character arrays.
    %
    % For example:
    %
    %   cl = databricks.Cluster;
    %   tags = databricks.ClusterTag('owner','joe');
    %   cl.setCustomTags(tags);
    %
    % Optionally, this class accepts a cell array of inputs to specify multiple
    % tag pairs.
    %
    %   tagCell = {'owner','joe';'group','engineering'};
    %   tags = databricks.ClusterTag(tagCell);
    %
    % A tag pair can also be added to an existing ClusterTag using the add method
    %   tagCell = {'owner','joe';'group','engineering'};
    %   tags = databricks.ClusterTag(tagCell);
    %   tags.add('myNewKey','myNewValue');
    %
    % Order of insertion is not preserved.
    % Databricks allows at most 45 custom tags.
    % The key length must be between 1 and 127 UTF-8 characters, inclusive.
    % The value length must be less than or equal to 255 UTF-8 characters.
    % For further details and restrictions see:
    % https://docs.databricks.com/dev-tools/api/latest/clusters.html#clusterclustertag
    % https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/Using_Tags.html#tag-restrictions

    %  (c) 2019-2021 MathWorks, Inc.
    
    properties
        % containers.Map can support types other that strings and character vectors
        % but there is no known use case for these as cluster tags where json encoded
        % strings are expected to only character vector and scalar strings are accepted
        % An array of pairs can also be provided.
        % Scalar strings are converted to character vectors for use with containers.Map
        tags
    end
    
    methods
        %% Constructor
        function obj = ClusterTag(varargin)
            % containers.Map is a handle class so set the property in the
            % constructor
            
            if nargin == 1 && iscell(varargin{1})
                % Input is a cell array
                % Check for 2 columns of elements in the cell array
                if size(varargin{1},2) ~= 2
                    error('DATABRICKS:ERROR','Keys and values must be provided as pairs');
                else
                    % cellstr converts to char
                    keys = cellstr(varargin{1}(:,1));
                    values = cellstr(varargin{1}(:,2));
                    obj.tags = containers.Map(keys, values, 'UniformValues', true);
                end
            elseif nargin == 2
               % Input is a string/char pair
               obj.tags = containers.Map('KeyType','char','ValueType','char');
               obj.add(varargin{1}, varargin{2});
            else
                error('DATABRICKS:ERROR','Unexpected inputs');
            end
        end %function
    end %methods

end %class
