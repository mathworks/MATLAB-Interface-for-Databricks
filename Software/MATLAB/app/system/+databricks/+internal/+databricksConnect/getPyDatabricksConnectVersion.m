function [VER, SPLIT] = getPyDatabricksConnectVersion()
    % getPyDatabricksConnectVersion Returns version of Databricks Connect from Python environment

    % TODO dump move to semver

    % Copyright 2024 The MathWorks, Inc.

    try
        try
            VER = string(py.importlib.metadata.version('databricks.connect'));
        catch E
            dcm = py.importlib.import_module('databricks.connect');
            v=py.getattr(dcm.version, '__dbconnect_version__');
            VER = string(v);
        end
    catch ME
        fprintf("No Databricks Connect Python package found.\n");
        fprintf("See: databricks.setup.configure.DBC & %s\n", matlab.utils.editLink(databricksRoot(-2, "Documentation", "DBConnect.md")));
        VER = [];
        SPLIT = [];
        return;
    end

    if nargout > 1
        S = split(VER, ".");
        N = numel(S);
        if N > 0
            SPLIT.Major = getNum(S(1));
        end
        if N > 1
            SPLIT.Minor = getNum(S(2));
        end
        if N > 2
            SPLIT.Patch = getNum(S(3));
        end
        if N > 3
            SPLIT.REST = arrayfun(@getNum, S(4:end), 'UniformOutput',false);
        end

        SPLIT.BaseVersion = S(1) + "." + S(2);
        SPLIT.IsDBCv2 = databricks.internal.databricksConnect.isDatabricksConnectv2Version(SPLIT.BaseVersion);
    end
end


function V = getNum(str)
    V = str2double(str);
    if isnan(V)
        V = str;
    end
end
