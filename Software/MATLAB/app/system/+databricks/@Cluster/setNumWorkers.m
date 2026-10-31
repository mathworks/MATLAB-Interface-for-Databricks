function setNumWorkers(obj, varargin)
% SETNUMWORKERS Method to specify the number of workers for the cluster
% The number of workers in the cluster can be set with one of two methods.
% Either by setting the number of workers through a single scalar number
% or by specifying autoscaling by providing the min/max number of workers.
%
%   setNumWorkers(NUM);
%
% or
%
%   setNumWorkers([MIN MAX]);
%
% If num_workers, number of worker nodes that this cluster should have.
% A cluster has one Spark Driver and num_workers Executors for a total of
% num_workers + 1 Spark nodes.
%
%   cl = databricks.Cluster();
%   cl.setNumWorkers(25);
%
% To specify autoscaling:
%
%   cl = databricks.Cluster();
%   cl.setNumWorkers([2 10]);

%   (c) 2019-2022 MathWorks, Inc.

% Initialization
p = inputParser;
p.KeepUnmatched = false;
p.addRequired('NumWorkers',@isnumeric);

% Parse & Retrieve default & input values
p.parse(varargin{:});
numWorkers = p.Results.NumWorkers;

% Check if the input/outputs are specified
if numel(numWorkers)==1
    % Set the number of workers
    % Remove any num_workers property
    if isprop(obj,'autoscale')
        prop = findprop(obj, 'autoscale');
        delete(prop);
    end

    % Add the autoscale property and then set it
    if ~isprop(obj,'num_workers')
        obj.addprop('num_workers');
    end
    obj.num_workers = numWorkers;

elseif numel(numWorkers)==2
    % Set the cluster autoscaling
    clusterSize.min_workers=numWorkers(1);
    clusterSize.max_workers=numWorkers(2);

    % Remove any num_workers property
    if isprop(obj,'num_workers')
        prop = findprop(obj, 'num_workers');
        delete(prop);
    end

    % Add the autoscale property and then pack it
    if ~isprop(obj,'autoscale')
        obj.addprop('autoscale');
    end

    obj.autoscale = clusterSize;
else
    error('DATABRICKS:INVALID','Incorrect number of workers specified.');
end

end %function
