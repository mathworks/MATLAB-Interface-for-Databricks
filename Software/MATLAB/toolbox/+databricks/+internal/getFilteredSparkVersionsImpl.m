function filtered = getFilteredSparkVersionsImpl(options)
    % GETFILTEREDSPARKVERSIONSIMPL Return Spark version information for databricks versions
    %
    % Example:
    %
    % filteredVersions = databricks.internal.getFilteredSparkVersionsImpl()
    %
    % Options enable the selections a subset of Spark versions.
    %
    % Optional named arguments
    %   baseVersions   A string array e.g. ["15.4", "13.3"
    %   cpu            A logical
    %   gpu            A logical
    %   ml             A logical
    %   photon         A logical
    %   aarch64        A logical
    %   authMethod     A matlab.internal.databricks.AuthMethod
    %   profileName    A configuration file profileName value
    %
    % Example:
    %   sv = databricks.internal.getFilteredSparkVersionsImpl(lts=true, cpu=true, ml=false, photon=true)

    % Copyright 2022-2026 The MathWorks, Inc.

    arguments
        options.baseVersions string
        options.lts (1,1) logical
        options.cpu (1,1) logical
        options.gpu (1,1) logical
        options.ml (1,1) logical
        options.photon (1,1) logical
        options.aarch64 (1,1) logical = false % Default to false as effectively unused for now
        options.authMethod (1,1) matlab.internal.databricks.AuthMethod
        options.profileName string {mustBeTextScalar, mustBeNonzeroLengthText}
    end

    % Call the REST API to get all available versions
    args = matlab.internal.utils.addArgs(options, ["authMethod", "profileName"]);
    % Returns just two columns key and name
    allVersionsNarrow = databricks.internal.Cluster.getSparkVersions(args{:});

    % Parse the value to extract logical values for the feature set
    [allVersions, tableTypes] = widenTable(allVersionsNarrow);

    % Create an array for the first filter base with the expanded rows
    baseFiltered = table('Size', [0, width(allVersions)], 'VariableTypes', tableTypes, 'VariableNames', allVersions.Properties.VariableNames);

    % Keep only the specified base versions if no base versions are
    % specified then keep them all
    if ~isfield(options, "baseVersions")
        baseFiltered = allVersions;
    else
        for n = 1:height(allVersions)
            for m = 1:numel(options.baseVersions)
                if any(matches(allVersions.baseVersion(n), options.baseVersions(m)))
                    baseFiltered(end+1, :) = allVersions(n, :); %#ok<AGROW>
                end
            end
        end
    end

    % Filter based on the logical arguments
    filtered = table('Size', [0, width(allVersions)], 'VariableTypes', tableTypes, 'VariableNames', allVersions.Properties.VariableNames);
    logicalFields = ["lts", "cpu", "gpu", "ml", "photon", "aarch64"];

    % for each of the previously filtered results i.e. the base version(s) are matched
    for n = 1:height(baseFiltered)
        % Set a flag, all rows are retained until filtered away
        keepRow = true;
        for m = 1:numel(logicalFields) % For all of the logical arguments
            % Check further if the flag is enabled i.e. has been set as an option,
            % otherwise we don't care about it and it should not be used to decide on
            % row retention
            if isfield(options, logicalFields(m))
                % If the argument is true keep the row if the value is true
                % If the argument is false keep the value if the value is false
                if options.(logicalFields(m)) ~= baseFiltered.(logicalFields(m))(n)
                    keepRow = false;
                    % Break because no point checking other arguments
                    break;
                end
            end
        end
        if keepRow
            filtered(end+1, :) = baseFiltered(n, :); %#ok<AGROW>
        end
    end
end


function [wide, wideTypes] = widenTable(narrow)
    arguments
        narrow table
    end

    errTag = "DATABRICKS:getFilteredSparkVersionsImpl:widenTable";
    if width(narrow) < 2
        error(errTag, "Expected source table to have at least two columns.");
    end
    if ~any(matches(narrow.Properties.VariableNames, "key"))
        error(errTag, "No key column found in source table.");
    end
    if ~any(matches(narrow.Properties.VariableNames, "name"))
        error(errTag, "No name column found in source table.");
    end

    wideNames = {'key', 'name', 'baseVersion', 'spark', 'scala', 'lts' 'cpu', 'gpu', 'ml', 'photon', 'aarch64'};
    wideTypes = {'string', 'string', 'string', 'string', 'string', 'logical', 'logical', 'logical', 'logical', 'logical', 'logical'};
    wideSize = [height(narrow), numel(wideNames)];
    wide = table('Size', wideSize, 'VariableTypes', wideTypes, 'VariableNames', wideNames);

    for n = 1:height(wide)
        wide.key(n) = string(narrow.key(n));
        wide.name(n) = string(narrow.name(n));
        % Default to missing if not found
        baseVersion = getBaseVersion(narrow.name(n));
        if ~isempty(baseVersion)
            wide.baseVersion(n) = baseVersion;
        end
        spark = getSpark(narrow.name(n));
        if ~isempty(spark)
            wide.spark(n) = spark;
        end
        scala = getScala(narrow.name(n));
        if ~isempty(scala)
            wide.scala(n) = scala;
        end
        wide.lts(n) = contains(narrow.name(n), " LTS ");
        wide.gpu(n) = contains(narrow.name(n), " GPU, ");
        wide.cpu(n) = ~wide.gpu(n);
        wide.ml(n) = contains(narrow.name(n), " ML ");
        wide.photon(n) = contains(narrow.name(n), " Photon ");
        wide.aarch64(n) = contains(narrow.name(n), " aarch64 ");
    end
end


function baseVersion = getBaseVersion(fullName)
    arguments
        fullName string {mustBeTextScalar, mustBeNonzeroLengthText}
    end
    pat = textBoundary("start") + digitsPattern(1,2) + "." + digitsPattern(1,2);
    baseVersion = extract(fullName, pat);
end


function spark = getSpark(fullName)
    arguments
        fullName string {mustBeTextScalar, mustBeNonzeroLengthText}
    end
    pat = "Apache Spark " + digitsPattern(1) + "." + digitsPattern(1,2) + "." + digitsPattern(1,2);
    spark = extractAfter(extract(fullName, pat), "Apache Spark ");
end


function scala = getScala(fullName)
    arguments
        fullName string {mustBeTextScalar, mustBeNonzeroLengthText}
    end
    pat = "Scala " + digitsPattern(1) + "." + digitsPattern(1,2);
    scala = extractAfter(extract(fullName, pat), "Scala ");
end
