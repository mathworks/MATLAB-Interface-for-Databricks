classdef RunInfo < handle
    % RUNINFO Metadata of a single run
    % The run_uuid field is deprecated and not supported use run_id instead.
    % The user_id field is deprecated and not supported use a mlflow.user tag instead.
    % The run_name field is returned on Databricks and is undocumented.

    %  Copyright 2021-2022 MathWorks, Inc.
    
    properties
        run_id           string
        experiment_id    string
        user_id          string
        status           mlflow.RunStatus
        start_time       int64
        end_time         int64
        artifact_uri     string
        lifecycle_stage  string % "active” or “deleted”
        run_name         string % undocumented on Datarbicks
    end
    
    methods
        % Constructor
        function obj = RunInfo(varargin)
            % Support construction from a struct as might be
            % returned from REST call post JSON conversion
            if nargin == 1 && isstruct(varargin{1})
                inputStruct = varargin{1};

                fn = fieldnames(inputStruct);
                for k=1:length(fn)
                    FN = fn{k};
                    switch FN
                        case 'run_uuid'
                            % Just ignore run_uuid
                        otherwise
                            if isprop(obj, FN)
                                obj.(FN) = inputStruct.(FN);
                            else
                                disp(['Skipping unexpected RunInfo field: ', FN]);
                            end
                    end
                end

            elseif nargin == 0
                % Create and empty RunInfo to allow the properties to be set
                % e.g. for unit testing
            else
                error('MLFLOW:INVALID','Invalid input specified');
            end
            
        end %function
        
    end %methods
end %class