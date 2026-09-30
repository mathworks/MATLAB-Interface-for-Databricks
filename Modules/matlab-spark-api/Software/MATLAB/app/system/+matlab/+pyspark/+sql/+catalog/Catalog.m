classdef Catalog < matlab.pyspark.internal.PyWrapper
    % Catalog - A pyspark Catalog

    % (c) 2024 MathWorks, Inc.

    properties (Hidden)
        catalog
    end

    methods
        function obj = Catalog(catalog_)
            obj.catalog = catalog_;
        end

        function pyObj = toPy(obj)
            pyObj = obj.catalog;
        end

        function str = currentCatalog(obj)
            str = string(obj.toPy.currentCatalog);
        end

        function str = currentDatabase(obj)
            str = string(obj.toPy.currentDatabase);
        end

        function tf = databaseExists(obj, dbName)
            arguments
                obj (1,1) matlab.pyspark.sql.catalog.Catalog
                dbName (1,1) string {mustBeNonzeroLengthText}
            end
            tf = obj.toPy.databaseExists(dbName);
        end

        function tf = dropGlobalTempView(obj, viewName)
            arguments
                obj (1,1) matlab.pyspark.sql.catalog.Catalog
                viewName (1,1) string {mustBeNonzeroLengthText}
            end
            tf = obj.toPy.dropGlobalTempView(viewName);
        end

        function tf = dropTempView(obj, viewName)
            arguments
                obj (1,1) matlab.pyspark.sql.catalog.Catalog
                viewName (1,1) string {mustBeNonzeroLengthText}
            end
            tf = obj.toPy.dropTempView(viewName);
        end

        % function tf = listDatabases(obj, viewName)
        %     arguments
        %         obj (1,1) matlab.pyspark.sql.catalog.Catalog
        %         viewName (1,1) string
        %     end
        %     tf = obj.toPy.listDatabases(viewName);
        % end
        
        function tables = listTables(obj, options)
            arguments
                obj (1,1) matlab.pyspark.sql.catalog.Catalog
                options.dbName (1,1) string
                options.pattern(1,1) string
            end
            pyTables = obj.toPy.listTables();
            cTables = cell(pyTables);
            N = numel(cTables);
            tables = matlab.pyspark.sql.catalog.Table.empty;
            for k=1:N
                tables(k) = matlab.pyspark.sql.catalog.Table(cTables{k});
            end
        end

        
    end


end