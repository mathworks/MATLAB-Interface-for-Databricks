function tbl = table(obj, varargin)
    % TABLE Method to list the table data as a table.
    % Overloaded method to cast the object as a MATLAB table

    %  (c) 2020-2023 MathWorks, Inc.

    N = numel(obj);
    % Assemble the table
    for oCount = N:-1:1

        curObj = obj(oCount);

        tblStruct(oCount) = getLibStats(curObj);

    end

    tbl = struct2table(tblStruct);

end %function

function stats = getLibStats(lib)
    ps = string(properties(lib));
    statIdx = find(ps == "status");
    if isempty(statIdx)
        Status = "UNKNOWN";
    else
        Status = string(lib.status);
        ps(statIdx) = [];
    end
    if numel(ps) ~= 1
        error('Databricks:Library', 'Too many properties');
    else
        Type = ps;
        URI = string(lib.(ps));
    end
    stats = struct(...
        'Type', Type, ...
        'Status', Status, ...
        'URI', URI);
end