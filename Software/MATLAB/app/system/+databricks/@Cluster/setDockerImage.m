function setDockerImage(obj, varargin)
    % SETDOCKERIMAGE Set docker image for cluster
    %
    % A cluster can be started with a Docker image instead of with init scripts
    %
    % For example:
    %
    %   cl = databricks.Cluster;
    %   cl.cluster_name = 'docker-test-cluster';
    %   cl.setNumWorkers(2)
    %   cl.setDockerImage('img', 'user', 'passwd');
    %
    %   cl.create()
    %
    %   % Or using a databricks.datastructures.DockerImage argument
    %   cl = databricks.Cluster;
    %   cl.cluster_name = 'docker-test-cluster';
    %   cl.setNumWorkers(2)
    %
    %   dbaStruct.username = "myusername"
    %   dbaStruct.password = "mypassword"
    %   dba = databricks.datastructures.DockerBasicAuth(dbaStruct)
    %   diStruct.url = "http://mydockerrepourl.example.com"
    %   diStruct.basic_auth = dbaStruct
    %
    %   di = databricks.datastructures.DockerImage(diStruct)
    %   cl.setDockerImage(di);
    %
    %   cl.create()
    %
    % It is not good practice to include passwords in source code, please 
    % consider reading the value from a file or other external source in real
    % world code.


    %   (c) 2022 MathWorks, Inc.
  
    % Retain support for passing cl.setDockerImage('img', 'user', 'passwd'); style arguments
    % that predate databricks.datastructures.DockerImage
    if length(varargin) == 3
        imageURL = varargin{1};
        username = varargin{2};
        password = varargin{3};

        if ~(ischar(username) || isStringScalar(username))
            error('DATABRICKS:SETDOCKERIMAGE', 'Expected username to be of type character vector or scalar string');
        end
        if ~(ischar(password) || isStringScalar(password))
            error('DATABRICKS:SETDOCKERIMAGE', 'Expected password to be of type character vector or scalar string');
        end

        auth = struct("username", string(username), "password", string(password));

        if ~(ischar(imageURL) || isStringScalar(imageURL))
            error('DATABRICKS:SETDOCKERIMAGE', 'Expected imageURL to be of type character vector or scalar string');
        end
        data = struct("url", string(imageURL), "basic_auth", auth);
        setprop(obj, "docker_image", data);
    elseif length(varargin) == 1 %#ok<ISCL>
        dockerImage = varargin{1};

        if ~isa(dockerImage, 'databricks.datastructures.DockerImage')
            error('DATABRICKS:SETDOCKERIMAGE', 'Expected dockerImage to be of type databricks.datastructures.DockerImage');
        end

        if ~isempty(dockerImage.basic_auth)
            auth = struct("username", dockerImage.basic_auth.username, "password", dockerImage.basic_auth.password);
            data = struct("url", dockerImage.url, "basic_auth", auth);
        else
            data = struct("url", dockerImage.url);
        end
        setprop(obj, "docker_image", data);
    else
        error('DATABRICKS:SETDOCKERIMAGE', 'Unexpected number of arguments');
    end
    
end %function
