function setDestination(obj, varargin)
    % SETDESTINATION Method to set the destination of the cluster logs
    % The location of the init script destination must be provided.
    %
    % For example:
    %
    %   conf = databricks.ClusterLogConf;
    %   conf.setDestination("dbfs:/home/cluster_logs");
    %
    % When running on AWS, an S3 object URL can be used along with a
    % destination.

    % (c) 2020-2024 MathWorks, Inc.

    % Validator
    validString = @(x) ischar(x) || isstring(x);

    % Parse inputs
    p = inputParser;
    p.KeepUnmatched = false;
    p.addRequired('destination',validString);
    p.addOptional('region', '', validString);

    % Parse & Retrieve default & input values
    p.parse(varargin{:});
    dstString = p.Results.destination;
    dstRegion = p.Results.region;

    % Handle the destination
    dstParts = split(dstString,':/');

    % Are we dealing with AWS or DBFS
    switch lower(dstParts{1})
        case 'dbfs'
            if isprop(obj, 's3')
                prop = findprop(obj, 's3');
                delete(prop);
            end

            if ~isprop(obj, 'dbfs')
                addprop(obj, 'dbfs');
            end

            % Populate the structure
            out.destination = dstString;
            obj.dbfs = out;

        case 's3'
            if isprop(obj, 'dbfs')
                prop = findprop(obj, 'dbfs');
                delete(prop);
            end

            if ~isprop(obj, 's3')
                addprop(obj, 's3');
            end

            % Populate the structure
            out.destination = dstString;
            out.region = dstRegion;

            % Set the object properties
            obj.s3 = out;

        otherwise
            error('DATABRICKS:InvalidProtocol','Unsupported destination protocol');
    end


end %function
