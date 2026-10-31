classdef SparkSession < matlab.pyspark.internal.PyWrapper
    % SparkSession - Base class for a Python SparkSession

    % Copyright 2024-2026 The MathWorks, Inc.

    properties(Access=public, Hidden=true)
        sparkSession;
    end

    methods
        function obj = SparkSession(sparkSess)
            if nargin == 0
                % This is a special case, where the sparkSession field will
                % be set later. It's in general used by classes inheriting
                % from this class.
                return;
            end
            if isa(sparkSess, 'py.pyspark.sql.connect.session.SparkSession') || ...
                    isa(sparkSess, 'py.pyspark.sql.session.SparkSession')
                obj.sparkSession = sparkSess;
            else
                error('PYSPARK:SPARKSESSION_CREATION', ...
                    "SparkSession expects a py.pyspark.sql.connect.session.SparkSession or py.pyspark.sql.session.SparkSession objects as an input argument.")
            end

        end

        function df = table(obj, tableStr)
            % table Read table from Spark context

            arguments
                obj (1,1) matlab.pyspark.sql.session.SparkSession
                tableStr (1,1) string
            end

            df = matlab.pyspark.sql.dataframe.Dataframe(obj.toPy.table(tableStr));
        end

        function V = version(obj)
            % V Return spark version

            arguments
                obj (1,1) matlab.pyspark.sql.session.SparkSession
            end

            V = string(obj.toPy.version);
        end

        function V = session_id(obj)
            % V Return spark session_id

            arguments
                obj (1,1) matlab.pyspark.sql.session.SparkSession
            end

            V = string(obj.toPy.session_id);
        end

        function pyObj = toPy(obj)
            pyObj = obj.sparkSession;
        end

        function sparkCatalog = catalog(obj)
            arguments
                obj (1,1) matlab.pyspark.sql.session.SparkSession
            end
            sparkCatalog = matlab.pyspark.sql.catalog.Catalog(obj.toPy.catalog);
        end
        
        function delete(obj)
            obj.stop();
        end

        function stop(obj)
            if ~isempty(obj.sparkSession)
                fprintf('Clearing spark session.\n')
                obj.sparkSession = [];
            end
        end
    end
end