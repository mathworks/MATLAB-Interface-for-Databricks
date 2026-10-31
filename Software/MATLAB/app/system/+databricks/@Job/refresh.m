function refresh(obj, varargin) 
% REFRESH Method to refresh information about a Spark Job
% Retrieves information about a single job.
% 
%   jb = databricks.Job();
%   jb.setJobId(87);
%   jb.refresh();
% 
% The resulting structure contains information about the job. 

%  (c) 2019-2022 MathWorks, Inc.

%% Describe a spark job on databricks 
jobsURI = obj.getURI('jobs', 'get', 'job_id', obj.job_id);
request = obj.getRequestMessage('GET');

% Call databricks
resp = request.send(jobsURI, obj.HTTPOptions);


%% Process the results
if resp.StatusCode == matlab.net.http.StatusCode.OK
   resp.Body.Data = mlflow.jsondecode(resp.Body.Data, false,...
       {'job_id'}, 'int64',...
       {'created_time'}, 'int64');
   if ~isempty(fieldnames(resp.Body.Data))
        % We have a non-empty response
        curJob = resp.Body.Data;
        
        % Valid response so package and send back to user
        sPropList = fieldnames(curJob.settings);
            
        % Populate the structure with the settings
        for pCount = 1:numel(sPropList)
            % create the properties on the object
            if ~isprop(obj,sPropList{pCount})
                addprop(obj,sPropList{pCount});
            end
            
            % populate the information about the object
            obj.(sPropList{pCount}) = curJob.settings.(sPropList{pCount});
        end
            
        % Get the fieldnames for the job omitting the settings that we
        % have already handled.
        propList = setdiff(fieldnames(curJob),'settings');
        
        % Populate the structure the job details
        for pCount = 1:numel(propList)
            if ~isprop(obj,propList{pCount})
                addprop(obj,propList{pCount});
            end
            
            % populate the information about the object
            obj.(propList{pCount}) = curJob.(propList{pCount});
        end
   else
       error('DATABRICKS:ERROR', 'Failed to describe job: %s\n%s', num2str(obj.job_id), char(resp.Body.Data));
   end
else 
    error('DATABRICKS:ERROR', 'Failed to describe job: %s\n%s', num2str(obj.job_id), char(resp.Body.Data));
end

end %function
