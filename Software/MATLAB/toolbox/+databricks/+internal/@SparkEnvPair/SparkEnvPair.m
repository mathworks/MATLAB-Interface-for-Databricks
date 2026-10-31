classdef SparkEnvPair < databricks.internal.Object
    % SPARKENVPAIR Specify environment variables to attach to the create object.
    % Use to Spark environment variable key-value pairs on the databricks cluster.
    % Keys and values must be character vectors or scalar strings.
    % Both keys and values are stored as character arrays.
    %
    % For example:
    %
    %   cl = databricks.internal.Cluster;
    %   var = databricks.internal.SparkEnvPair('SPARK_WORKER_MEMORY','28000m');
    %   cl.setSparkEnvVars(var);
    %
    % Optionally, this class accepts a cell array of inputs to specify multiple
    % tag pairs.
    %
    %   varCell = {'SPARK_WORKER_MEMORY','28000m';'SPARK_LOCAL_DIRS','/local_disk0'};
    %   vars = databricks.internal.SparkEnvPair(varCell);
    %
    % A pair can also be added to an existing SparkEnvPair using the add method
    %   varCell = {'SPARK_WORKER_MEMORY','28000m';'SPARK_LOCAL_DIRS','/local_disk0'};
    %   vars = databricks.internal.SparkEnvPair(varCell);
    %   vars.add('myNewKey','myNewValue');
    %
    % Order of insertion is not preserved.
    % When specifying environment variables in a job cluster, the fields in this
    % data structure accept only Latin characters (ASCII character set). Using
    % non-ASCII characters will return an error. Examples of invalid, non-ASCII
    % characters are Chinese, Japanese kanjis, and emojis.
    %
    % https://docs.databricks.com/dev-tools/api/latest/clusters.html#sparkenvpair

    % Copyright 2022-2026 The MathWorks, Inc.

    properties
        % containers.Map can support types other that strings and character vectors
        % but there is no known use case for these as environment variables where json encoded
        % strings are expected to only character vector and scalar strings are accepted
        % An array of pairs can also be provided.
        % Scalar strings are converted to character vectors for use with containers.Map
        envVarPairs
    end

    methods
        %% Constructor
        function obj = SparkEnvPair(varargin)
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
                    obj.envVarPairs = containers.Map(keys, values, 'UniformValues', true);
                end
            elseif nargin == 2
               % Input is a string/char pair
               obj.envVarPairs = containers.Map('KeyType','char','ValueType','char');
               obj.add(varargin{1}, varargin{2});
            else
                error('DATABRICKS:ERROR','Unexpected inputs');
            end
        end %function
    end %methods

end %class
