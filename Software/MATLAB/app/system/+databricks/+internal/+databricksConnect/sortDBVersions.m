function result = sortDBVersions(versions)
    % sortDBVersions Returns a sorted lists of Databricks version strings
    % Sorts oldest to latest.
    % Input should be a string array.
    % Two version fields are required.
    % The separator is a '.'.
    % A third and fourth field are optional.
    %
    % Assumes:
    %   * The first two field values are numbers only
    %   * The 3rd field is of the form <number>b<number or a number only
    %   * The 4th field is a number only
    %
    % A string array is returned.
    % if no versions are provided an empty string is returned.
    % 
    % This format is Semantic Version compliant.

    % Copyright 2023 The MathWorks, Inc.

    arguments
        versions string
    end

    numVers = numel(versions);
    if numVers == 0
        result = string.empty;
        return;
    elseif numVers == 1
        result = versions;
        return;
    end

    entry = struct('major', "", 'minor', "", 'patch', "", 'build', "");
    tmp = entry; %#ok<NASGU>
    entries(numVers, 1) = entry;

    for n = 1:numVers
        fields = split(string(strip(versions(n), 'both')), '.');
        numFields = numel(fields);
        if numFields > 0
            entries(n).major = fields(1);
        end
        if numFields > 1
            entries(n).minor = fields(2);
        end
        if numFields > 2
            entries(n).patch = fields(3);
        else
            entries(n).patch = "";
        end
        if numFields > 3
            entries(n).build = fields(4);
        else
            entries(n).build = "";
        end
    end

    for n = 1:numVers
        swapped = false;
        for m = 1:numVers-1
            if  entryGt(entries(m), entries(m+1))
                tmp = entries(m);
                entries(m) = entries(m+1);
                entries(m+1) = tmp;
                swapped = true;
            end
        end
        if ~swapped
            break;
        end
    end

    result = strings(numVers,1);
    for n = 1:numVers
        result(n) = entries(n).major + "." + entries(n).minor;
        if strlength(entries(n).patch) > 0
            result(n) = result(n) + "." + entries(n).patch;
        end
        if strlength(entries(n).build) > 0
            result(n) = result(n) + "." + entries(n).build;
        end
    end
end


function tf = compareEntry(e1, e2, comparison) %#ok<DEFNU>
    % Switch yard for operator
    switch lower(char(comparison))
        case 'gt'
            tf = entryGt(e1, e2);

        case 'eq'
            tf = entryEq(e1, e2);

        otherwise
            error('DATABRICKS:ERROR','Unknown comparison methods: %s', comparison);
    end
end


function tf = entryEq(e1, e2)
    if patchEq(e1.patch, e2.patch) && ...
       buildEq(e1.build, e2.build) && ...
       minorEq(e1.minor, e2.minor) && ...
       majorEq(e1.major, e2.major)
        tf = true;
    else
        tf = false;
    end
end


function tf = entryGt(e1, e2)
    if majorGt(e1.major, e2.major)
        tf = true;
    elseif majorEq(e1.major, e2.major)
        if minorGt(e1.minor, e2.minor)
            tf = true;
        elseif minorEq(e1.minor, e2.minor)
            if patchGt(e1.patch, e2.patch)
                tf = true;
            elseif patchEq(e1.patch, e2.patch)
                if buildGt(e1.build, e2.build)
                    tf = true;
                else
                    tf = false;
                end
            else
                tf = false;
            end
        else
            tf = false;
        end
    else
        tf = false;
    end
end


function tf = minorGt(m1, m2)
    if str2double(m1) > str2double(m2)
        tf = true;
    else
        tf = false;
    end
end


function tf = minorEq(m1, m2)
    tf = strcmp(m1, m2);
end


function tf = majorGt(m1, m2)
    if str2double(m1) > str2double(m2)
        tf = true;
    else
        tf = false;
    end
end


function tf = majorEq(m1, m2)
    tf = strcmp(m1, m2);
end


function tf = patchEq(p1, p2)
    tf = strcmp(p1, p2);
end


function tf = patchGt(p1, p2)
    p1Fields = split(string(p1), 'b');
    p2Fields = split(string(p2), 'b');

    if numel(p1Fields) == 1 %#ok<ISCL>
        p1Major = p1Fields(1);
        p1Minor = '0';
    elseif numel(p1Fields) == 2
        p1Major = p1Fields(1);
        p1Minor = p1Fields(2);
    else
        error('DATABRICKS:ERROR','Unexpected patch value: %s', p1);
    end

    if numel(p2Fields) == 1 %#ok<ISCL>
        p2Major = p2Fields(1);
        p2Minor = '0';
    elseif numel(p2Fields) == 2
        p2Major = p2Fields(1);
        p2Minor = p2Fields(2);
    else
        error('DATABRICKS:ERROR','Unexpected patch value: %s', p2);
    end

    p1MajorVal = str2double(p1Major);
    if isnan(p1MajorVal)
        error('DATABRICKS:ERROR','Unexpected patch value: %s', p1);
    end
    p1MinorVal = str2double(p1Minor);
    if isnan(p1MinorVal)
        error('DATABRICKS:ERROR','Unexpected patch value: %s', p1);
    end

    p2MajorVal = str2double(p2Major);
    if isnan(p2MajorVal)
        error('DATABRICKS:ERROR','Unexpected patch value: %s', p2);
    end
    p2MinorVal = str2double(p2Minor);
    if isnan(p2MinorVal)
        error('DATABRICKS:ERROR','Unexpected patch value: %s', p2);
    end

    if p1MajorVal > p2MajorVal
        tf = true;
    elseif p1MajorVal == p2MajorVal
        if p2MinorVal > p1MinorVal
            tf = true;
        else
            tf = false;
        end
    else
        tf = false;
    end
end


function tf = buildGt(b1, b2)
    b1Val = build2double(b1);
    b2Val = build2double(b2);

    if b1Val > b2Val
        tf = true;
    else
        tf = false;
    end
end


function tf = buildEq(b1, b2)
    b1Val = build2double(b1);
    b2Val = build2double(b2);

    if b1Val == b2Val
        tf = true;
    else
        tf = false;
    end
end


function bVal = build2double(b)
    if strlength(b) == 0
        bVal = 0;
    else
        bDouble = str2double(b);
        if isnan(bDouble)
            warning('DATABRICKS:WARNING','Unexpected build value: %s', b);
        else
            bVal = str2double(b);
        end
    end
end
