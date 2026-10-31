function varargout = cli(varargin)
% CLI Wrapper to the Databricks CLI
% The Databricks command-line interface (CLI) provides an easy-to-use
% interface to the Databricks platform. For more details, please see:
% https://docs.databricks.com/dev-tools/api/latest/index.html#rest-api-v2
%
% Usage: cli([Options])
% Options:
%   -v, --version
%   -h, --help
%
% Usage: cli([GROUP], [GROUP_OPTIONS], GROUP_COMMAND, [GROUP_ARGS],...)
% GROUP : fs
%         workspace
%         groups
%         clusters
%         jobs
% To find out about [GROUP_OPTIONS] and GROUP_COMMAND
% databricks('GROUP -h')
%
%  Group Usage: cli('fs', 'cp', 'a.txt', 'dbfs:/MATLAB_cli')

% (c) 2019-2024 MathWorks, Inc. 

%%
try
% Pass through and check if user wants a display
    if nargout==0
        echoFlag = '-echo';
    else
        echoFlag ='';
    end
% clusters cli command
cli_cmd = 'databricks';

% Pass User inputs
[varargout{1},varargout{2}] = system([cli_cmd,' ',strjoin(varargin)],echoFlag);

% Handle output for easy parsing e.g. --output JSON which will be a MATLAB
% structure to parse

% Get all input args
splitargs = strsplit(strjoin(varargin));
% Check for specified output arg --output-format
% if table or text output is requested and and output variable is
% provided then a char object if an output type is not provided JSON
% is the default which is decoded to a struct if an output variable is
% provided
if length(splitargs) > 1
    if strcmpi(splitargs{end-1},'--output')
    % if json argout provided decode it else just leave varargout{2} as is
        if strcmpi(splitargs{end},'JSON')
            % Decode the output
            if nargout==2
                try
                    varargout{2} = jsondecode(varargout{2});
                catch ME
                    fprintf('Check whether output is a supported JSON format \n');
                    fprintf('Try databricks %s -h to know more about the syntax \n',string(splitargs{1,1}));
                    rethrow(ME);
                end
            end
        end
    else
    % no --output argument provided, thus JSON by default
    % Decode the output

        if nargout==2
            %varargout{2} = jsondecode(varargout{2});
            formatSpec = 'If you want to see the result in a JSON format, pass --output JSON or for tabular format pass --output TABLE\n';
            fprintf(formatSpec);
        end
    end
end
catch ME
   % setenv('LD_LIBRARY_PATH',ldPath);
    rethrow(ME);
end

end
