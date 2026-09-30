classdef Table < matlab.pyspark.internal.PyWrapper
    % Table - A pyspark Catalog Table

    % (c) 2024 MathWorks, Inc.

    properties (Hidden)
        ctable
    end

    methods
        function obj = Table(table_)
            obj.ctable = table_;
        end

        function pyObj = toPy(obj)
            pyObj = obj.ctable;
        end

        function T = toTable(obj)
            arguments
                obj matlab.pyspark.sql.catalog.Table
            end

            % Example:
            % Table(name='sorting_1_27may2024_015847_956', catalog='hive_metastore', namespace=['default'], description=None, tableType='MANAGED', isTemporary=False)
            % cols = {'name', 'catalog', 'namespace', 'description', 'tableType', 'isTemporary', 'count', 'database', 'index'};
            cols = {'name', 'catalog', 'namespace', 'description', 'tableType', 'isTemporary'};
            types = {'string', 'string', 'string', 'string', 'string', 'logical'};
            NROWS = numel(obj);
            NCOLS = numel(cols);
            T = table('Size', [NROWS, NCOLS], 'VariableNames', cols, 'VariableTypes', types);
            for k=1:numel(obj)
                tc = obj(k);
                tcp = tc.toPy;
                T{k, 'name'} = strOrNone(tcp.name);
                T{k, 'catalog'} = strOrNone(tcp.catalog);
                T{k, 'namespace'} = strOrNone(tcp.namespace);
                T{k, 'description'} = strOrNone(tcp.description);
                T{k, 'tableType'} = strOrNone(tcp.tableType);
                T{k, 'isTemporary'} = tcp.isTemporary;
            end

        end

    end

end

function str = strOrNone(val)
    cval = class(val);
    switch cval
        case 'py.str'
            str = string(val);
        case 'py.NoneType'
            str = "";
        case 'py.list'
            str = string(py.str(val));
        otherwise
            error('PYSPARK:CATALOG_TABLE', 'Unknown catalog type');
    end
end