function obj = list(varargin)
% LIST Method to list existing experiments
% An optional argument allows users to list only active, deleted or all
% (default) experiments.
%
% Example:
%
%   mle = mlflow.Experiment('all');
%   mle = mlflow.Experiment('active_only');
%   mle = mlflow.Experiment('deleted_only');

%  (c) 2020 MathWorks, Inc.

%% Create a new Experiment object
obj = mlflow.Experiment;

% Check if a viewtype is specified
if nargin==1 && (isstr(varargin{1}) || ischar(varargin{1}))
    % Valid input
    clusterURI = obj.getURI('experiments', 'list','view_type',upper(varargin{1}));

else
    % No arguments
    clusterURI = obj.getURI('experiments', 'list');

end

% Create the request
request = obj.getRequestMessage('GET');



% Call MLFlow endpoint
resp = request.send(clusterURI, getHTTPOptions);


%% Process the results
if resp.StatusCode == matlab.net.http.StatusCode.OK

    if ~isempty(fieldnames(resp.Body.Data))
        % We have a non-empty response

        % Create an object for each experiment
        for cCount = 1:numel(resp.Body.Data.experiments)


            % Add code to check for cell output
            expItem = resp.Body.Data.experiments(cCount);
            if iscell(expItem)
                % Extract contents
                expStruct = expItem{1};
            else
                expStruct = expItem;
            end

            % Create an output experiment object
            obj(cCount) = mlflow.Experiment.initFromStruct(expStruct);

        end
    else
        % We have an empty response
        obj = [];
    end

else
    % Could not list experiments
    error('MLFLOW:ERROR', 'Failed to list experiments');
end

end %function
