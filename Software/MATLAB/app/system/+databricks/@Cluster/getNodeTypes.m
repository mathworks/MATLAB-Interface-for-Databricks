function nodeList = getNodeTypes(options)
    % GETNODETYPES Method to get a table of node types
    % Return a table of supported Spark node types. These node types can be used
    % to launch a cluster.
    %
    % Optional named arguments
    %   authMethod     A matlab.databricks.AuthMethod
    %   profileName    A configuration file profileName value
    %
    % Example:
    %
    %   nodeList = databricks.Cluster.getNodeTypes;
    %
    %   nodeList =
    % 367x20 table
    %  node_type_id      memory_mb     num_cores            description            instance_type_id    is_deprecated          category          support_ebs_volumes    support_cluster_tags    num_gpus    node_instance_type    is_hidden    support_port_forwarding    display_order    is_io_cache_enabled    photon_worker_capable    photon_driver_capable    is_encrypted_in_transit    is_graviton    require_fabric_manager
    % ________________    __________    _________    ___________________________    ________________    _____________    ____________________    ___________________    ____________________    ________    __________________    _________    _______________________    _____________    ___________________    _____________________    _____________________    _______________________    ___________    ______________________
    % {'r3.xlarge'   }         31232        4        {'r3.xlarge (deprecated)' }    {'r3.xlarge'   }        true         {'Memory Optimized'}           true                   true                0            1×1 struct          true                true                    1                 false                   false                    false                     false                false               false         
    % {'r3.2xlarge'  }         62464        8        {'r3.2xlarge (deprecated)'}    {'r3.2xlarge'  }        true         {'Memory Optimized'}           true                   true                0            1×1 struct          true                true                    1                 false                   false                    false                     false                false               false         
    % {'r3.4xlarge'  }    1.2493e+05       16        {'r3.4xlarge (deprecated)'}    {'r3.4xlarge'  }        true         {'Memory Optimized'}           true                   true                0            1×1 struct          true                true                    1                 false                   false                    false                     false                false               false         
    %    [TRUNCATED]
    
    %     (c) 2019-2026 MathWorks, Inc.

    arguments
        options.authMethod (1,1) matlab.databricks.AuthMethod
        options.profileName string {mustBeTextScalar, mustBeNonzeroLengthText} = databricks.internal.configurationprofile.ConfigFile.getDefaultProfileName
    end

    args = matlab.utils.addArgs(options, ["authMethod", "profileName"]);

    %% Get information about nodes
    obj = databricks.Cluster(args{:});
    clusterURI = obj.getURI('clusters', 'list-node-types');
    request = obj.getRequestMessage('GET');

    % Call databricks
    resp = request.send(clusterURI, databricks.internal.getHTTPOptions(convertResponse=true));

    %% Process the results
    if resp.StatusCode == matlab.net.http.StatusCode.OK
        % Valid response so package and send back to user
        % Struct totable is not robust enough for some updated Databricks responses
        % nodeList = struct2table(resp.Body.Data.node_types);
        nodeList = buildNodeTypeTable(resp.Body.Data.node_types);
    else
        error('DATABRICKS:INVALIDRESPONSE',char(resp));
    end

end %function

function t = buildNodeTypeTable(nodeTypes)
    % Workaround pending conversion to JSONMAPPER solution in a future release
    if isstruct(nodeTypes)
        % If it is a struct then just convert directly
        t = struct2table(nodeTypes);
    elseif iscell(nodeTypes)
        % Build two string arrays holding the field names and types for
        % table creation
        allFields = string.empty;
        allTypes = string.empty;
        for n = 1:numel(nodeTypes)
            if ~isstruct(nodeTypes{n})
                error('DATABRICKS:INVALIDRESPONSE', 'Expected nodeTypes{%d} to be of type struct', n);
            end
            currFields = fieldnames(nodeTypes{n});
            % For each field in each entry add it to the list of fields if
            % not previously recorded
            for m = 1:numel(currFields)
                count = matches(allFields, currFields{m});
                sumCount = sum(count);
                if (sumCount) > 1
                    % This should not arise
                    error('DATABRICKS:INVALIDRESPONSE', 'The number of matches should not exceed 1');
                elseif sumCount == 1
                    % do nothing, it has already been recorded
                else
                    % Add field name and type, the first type found is
                    % assumed to be the valid one for a given field
                    allFields(end+1) = currFields{m}; %#ok<AGROW>
                    allTypes(end+1) = class(nodeTypes{n}.(currFields{m})); %#ok<AGROW>
                end
            end
        end
        % This is a small table and the function is called rarely, this can
        % be ignored
        warning('off', 'MATLAB:table:PreallocateCharWarning');
        % We know the size, names and types
        t = table('Size',[numel(nodeTypes), numel(allFields)], 'VariableTypes', allTypes, 'VariableNames', allFields);
        warning('on', 'MATLAB:table:PreallocateCharWarning');

        for n = 1:numel(nodeTypes) % for each row
            for m = 1:numel(allFields) % for each struct field
                if isfield(nodeTypes{n}, allFields{m}) % If the field is found
                    % Check the type is as expected
                    if ~isa(nodeTypes{n}.(allFields{m}), allTypes{m})
                        error('DATABRICKS:INVALIDRESPONSE','Expected field of type: %s, found: %s, Row: %d, Name: %s', allTypes{m}, class(nodeTypes{n}.(allFields{m})), n, allFields{m});
                    end
                    if iscell(t.(allFields{m})(n))
                        % if the field in the table is expecting a cell
                        % array populate it with {}
                        t.(allFields{m})(n) = {nodeTypes{n}.(allFields{m})};
                    else
                        % There are some cases where fields a one level
                        % deep structs populate the fields directly to
                        % avoid: Unable to perform assignment because the left and right sides have a different number of elements.
                        % More complex entries can fail, when needed this
                        % should be done with a JSONMAPPER conversion of
                        % @Cluster
                        if isstruct(nodeTypes{n}.(allFields{m}))
                            sfields = fieldnames(nodeTypes{n}.(allFields{m}));
                            for p = 1:numel(sfields)
                                t.(allFields{m})(n).(sfields{p}) = nodeTypes{n}.(allFields{m}).(sfields{p});
                            end
                        else
                            % The field is just a field to assign directly
                            t.(allFields{m})(n) = nodeTypes{n}.(allFields{m});
                        end
                    end
                else
                    % If the fields is not there it will be set as missing
                    % this does not arise in the striaght call to
                    % struct2table case
                    if iscell(t.(allFields{m})(n))
                        t.(allFields{m})(n) = {missing};
                    elseif islogical(t.(allFields{m})(n))
                        t.(allFields{m})(n) = false;
                    else
                        t.(allFields{m})(n) = missing;
                    end
                end
            end
        end
    else
        % Not a struct array or a cell array so something likely went
        % wrong on the server side or the spec has changed
        error('DATABRICKS:INVALIDRESPONSE', 'Expected nodeTypes to be of type cell array or struct array');
    end
end

