function setJobId(obj, jobId, varargin)
% SETJOBID Method to set the Job ID for a given job
% Setting the Job ID for a given object will initialize the object handle
% to point to a particular job on the databricks system.
% 
%   j = databricks.Job;
%   j.setJobId(3); % sets the job_id to 3
% 
% When initialized further operations such as refresh and remove are
% enabled.

%                 (c) 2019 MathWorks, Inc.

% Check if the id is numerics
if isnumeric(jobId)
    
    % Set the property and value
    if ~isprop(obj,'job_id')
        addprop(obj,'job_id');
    end
    obj.job_id = jobId;

else
    error('DATABRICKS:ERROR','Failed to set the numeric job id');
end

end %function
