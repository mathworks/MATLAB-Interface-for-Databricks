classdef SparkConfPair < databricks.Object
% SPARKCONFPAIR Class to specify Spark configuration key-value pairs
% They can also be used pass in a string of extra JVM options 
% Keys and value must be character vectors or scalar strings.
% Both keys and values are stored as character arrays.
%
% For example:
%   
%   cl = databricks.Cluster;
%   scp = databricks.SparkConfPair('spark.speculation', 'true');
%   cl.setCustomTags(scp);
% 
% Optionally, this class accepts a cell array of inputs to specify multiple
% pairs.
% 
%   scpCell = {'spark.speculation', 'true'; 'myvar','myval'};
%   scps = databricks.SparkConfPair(scpCell);
%
% A pair can also be added to an existing SparkConfPair using the add method
%   scpCell = {'spark.speculation', 'true'; 'myvar','myval'};
%   scps = databricks.SparkConfPair(scpCell);
%   scps.add('myNewKey','myNewValue');
%
% Order of insertion is not preserved.
 
%  (c) 2020-2021 MathWorks, Inc.

properties
    % containers.Map can support types other that strings and character vectors
    % but there is no known use case for these as spark conf pairs where json encoded
    % strings are expected to only character vector and scalar strings are accepted
    % An array of pairs can also be provided.
    % Scalar strings are converted to character vectors for use with containers.Map
    pairs;
end

methods
	%% Constructor 
	function obj = SparkConfPair(varargin)
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
                obj.pairs = containers.Map(keys, values, 'UniformValues', true);
            end
        elseif nargin == 2
            % Input is a string/char pair
            obj.pairs = containers.Map('KeyType','char','ValueType','char');
            obj.add(varargin{1}, varargin{2});
        else
            error('DATABRICKS:ERROR','Unexpected inputs');
        end
    end %function
end %methods

end %class
