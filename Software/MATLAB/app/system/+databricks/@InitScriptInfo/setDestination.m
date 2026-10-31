function setDestination(obj, varargin)
    % SETDESTINATION Method to set the destination of the init_script
    % The location of the init script destination must be provided.
    %
    % For example:
    %
    %   is = databricks.InitScriptInfo;
    %   is.setDestination("dbfs:/home/init_script");
    %
    % Supported path prefixes are:
    %   s3://, abfss://, file:/, /Volumes, /Users, /Shared and dbfs:/
    %
    % Alternatively classes of types: databricks.datastructures.DbfsStorageInfo, databricks.datastructures.FileStorageInfo or databricks.datastructures.S3StorageInfo'

    % (c) 2019-2023 MathWorks, Inc.

    if length(varargin) < 1
        error('DATABRICKS:INITSCRIPTINFO', 'Expected destination of the form file:/<PATH>, dbfs:/<PATH>, s3://<PATH> or abfss://<PATH>, or a databricks.datastructures.DbfsStorageInfo, databricks.datastructures.FileStorageInfo or databricks.datastructures.S3StorageInfo');
    else
        arg1 = varargin{1};
        arg1class = class(arg1);

        switch arg1class

            case {'char', 'string'}
                if isstring(arg1)
                    if isscalar(arg1)
                        destination = char(arg1);
                    else
                        error('DATABRICKS:INITSCRIPTINFO', 'Expected destination string to be scalar');
                    end
                else
                    destination = arg1;
                end

                if ~startsWith(destination, ["s3://", "abfss://", "dbfs:/", "/Volumes", "/Users", "/Shared"])
                    error('DATABRICKS:INVALIDPROTOCOL', 'Unsupported destination protocol, expected destination of the form dbfs:/<PATH>, s3://<PATH>, abfss://<PATH>, /Users, or /Shared');
                end

                % Remove all properties as there may be a properties from an
                % alternative StorageInfo type
                obj = deleteAllProps(obj);

                if startsWith(lower(destination), 'dbfs')
                    % Deprecated by Databricks
                    % Create a struct that conforms to DbfsStorageInfo
                    addprop(obj, 'dbfs');
                    % Populate the structure
                    obj.dbfs.destination = destination;
                elseif startsWith(destination, '/Volumes')
                    % Create a struct that conforms to DbfsStorageInfo
                    addprop(obj, 'volumes');
                    % Populate the structure
                    obj.volumes.destination = destination;
                elseif startsWith(lower(destination), 's3')
                    % Create a struct that conforms to S3StorageInfo
                    % For now just support destination and region
                    addprop(obj, 's3');
                    warning('DATARBICKS:INITSCRIPTINFO', 'Not all fields supported, consider using a configured databricks.datastructures.S3StorageInfo object as input');
                    obj.s3.destination = destination;
                    if length(varargin) > 1
                        % Legacy support for region as a second argument
                        % S3StorageInfo should be used in future
                        if ischar(varargin{2}) || isStringScalar(varargin{2})
                            obj.s3.region = char(varargin{2});
                        else
                            error('DATABRICKS:INITSCRIPTINFO', 'Expected region string to be scalar');
                        end
                    else
                        warning('DATARBICKS:INITSCRIPTINFO', 'No region value provided, consider using a configured databricks.datastructures.S3StorageInfo object as input');
                    end
                elseif startsWith(lower(destination), 'abfss')
                    addprop(obj, 'abfss');
                    obj.abfss.destination = destination;

                elseif startsWith(lower(destination), 'file')
                    % Create a struct the conforms to FileStorageInfo
                    addprop(obj, 'file');
                    obj.file.destination = destination;
                elseif (startsWith(destination, "/Users") || startsWith(destination, "/Shared"))
                    x = databricks.datastructures.WorkspaceStorageInfo(destination);
                    % Do a recursive call
                    obj.setDestination(x);
                else
                    error('DATABRICKS:INVALIDPROTOCOL','Unsupported destination protocol %s', destination);
                end

            case 'databricks.datastructures.S3StorageInfo'
                checkS3Destination(arg1);
                obj = deleteAllProps(obj);
                addprop(obj, 's3');
                obj.s3 = copyPropsToStruct(arg1);

            case 'databricks.datastructures.FileStorageInfo'
                checkDestination(arg1);
                obj = deleteAllProps(obj);
                addprop(obj, 'file');
                obj.file = copyPropsToStruct(arg1);

            case 'databricks.datastructures.DbfsStorageInfo'
                checkDestination(arg1);
                obj = deleteAllProps(obj);
                addprop(obj, 'dbfs');
                obj.dbfs = copyPropsToStruct(arg1);

            case 'databricks.datastructures.WorkspaceStorageInfo'
                checkDestination(arg1);
                obj = deleteAllProps(obj);
                addprop(obj, 'workspace');
                obj.workspace = copyPropsToStruct(arg1);

            otherwise
                error('DATABRICKS:INITSCRIPTINFO', 'Expected destination of the form file:/<PATH>, dbfs:/<PATH>, s3://<PATH> or abfss://<PATH>, or a databricks.datastructures.DbfsStorageInfo, databricks.datastructures.FileStorageInfo or databricks.datastructures.S3StorageInfo');
        end


    end
end


function checkS3Destination(storageInfo)
    if ~isprop(storageInfo, 'destination')
        error('DATABRICKS:INITSCRIPTINFO', 'destination property not found in databricks.datastructures.S3StorageInfo');
    end
    if strlength(storageInfo.destination) == 0
        error('DATABRICKS:INITSCRIPTINFO', 'destination value not set in databricks.datastructures.S3StorageInfo');
    end
    if ~isprop(storageInfo, 'region') && ~isprop(storageInfo, 'endpoint')
        error('DATABRICKS:INITSCRIPTINFO', 'region or endpoint property must exist in databricks.datastructures.S3StorageInfo');
    end
    if strlength(storageInfo.region) == 0 && strlength(storageInfo.endpoint)
        error('DATABRICKS:INITSCRIPTINFO', 'region property value or endpoint property value must be set in databricks.datastructures.S3StorageInfo');
    end
end

function checkDestination(storageInfo)
    if ~isprop(storageInfo, 'destination')
        error('DATABRICKS:INITSCRIPTINFO', 'destination property not found in databricks.datastructures.<Type>StorageInfo');
    end
    if strlength(storageInfo.destination) == 0
        error('DATABRICKS:INITSCRIPTINFO', 'destination field not set in databricks.datastructures.<Type>StorageInfo');
    end
end


% Remove property values that cannot coexist with the one to be set
% i.e there can be only one destination type
function obj = deleteProp(obj, names)
    for n = 1:numel(names)
        if isprop(obj, names{n})
            prop = findprop(obj, names{n});
            delete(prop);
        end
    end
end

% Call deleteProp on each property
function obj = deleteAllProps(obj)
    if isscalar(obj)
        props = properties(obj);
        obj = deleteProp(obj, props);
    else
        error('DATABRICKS:INITSCRIPTINFO', 'deleteAllProps supports scalar input only');
    end
end

% Copy public properties only
function dst = copyPropsToStruct(src)
    props = properties(src);
    dst = struct;
    for n = 1:numel(props)
        dst.(props{n}) = src.(props{n});
    end
end
