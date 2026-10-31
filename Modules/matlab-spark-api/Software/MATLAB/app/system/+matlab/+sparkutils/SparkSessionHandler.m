classdef SparkSessionHandler < handle
    % SparkSessionHandler Class to handle Spark sessions
    %
    % This class will make it easier to reuse different Spark sessions,
    % without always recreating them.
    
    % Copyright 2020-2024 The MathWorks, Inc.

    properties
        SessionMasters string
        % SessionNames
        Sessions cell
    end
    
    methods (Access = private)
        function obj = SparkSessionHandler()
        end
        
        function idx = findSession(obj, sparkMaster)
            arguments
                obj (1,1) matlab.sparkutils.SparkSessionHandler
                sparkMaster (1,1) string
            end

            idx = [];
            for k=1:length(obj.SessionMasters)
                if sparkMaster == obj.SessionMasters(k)
                    idx = k;
                    break;
                end
            end
        end
        
        function idx = addSession(obj, sparkMaster, sparkSession)
            arguments
                obj (1,1) matlab.sparkutils.SparkSessionHandler
                sparkMaster (1,1) string
                sparkSession (1,1)
            end
            if isempty(obj.SessionMasters)
                obj.SessionMasters = sparkMaster;
                obj.Sessions= {sparkSession};
            else
                obj.SessionMasters(end+1) = sparkMaster;
                obj.Sessions{end+1} = sparkSession;
            end
            idx = length(obj.Sessions);
        end

        function deleteOneSession(obj, sparkMaster)
            arguments
                obj (1,1) matlab.sparkutils.SparkSessionHandler
                sparkMaster (1,1) string
            end
            idx = findSession(obj, sparkMaster);
            if isempty(idx)
                fprintf('No session found with name %s\n', sparkMaster);
            else
                fprintf('Deleting session %s\n', sparkMaster);
                obj.SessionMasters(idx) = [];
                obj.Sessions(idx) = [];
            end
        end
    end
    
    methods (Static, Access = private)
        function SH = getSessionHandler()
            persistent SessionHandler
            if isempty(SessionHandler)
                SessionHandler = matlab.sparkutils.SparkSessionHandler();
            end
            SH = SessionHandler;
        end
    end

    methods (Static)
        function spark = getSession(sparkMaster)
            arguments
                sparkMaster (1,1) string
            end

            SH = matlab.sparkutils.SparkSessionHandler.getSessionHandler();
            idx = SH.findSession(sparkMaster);
            if isempty(idx)
                if isDatabricksEnvironment
                    spark = databricks.PySparkSession(clusterId=sparkMaster);
                else
                    spark = getDefaultSparkSession(...
                        ['matlab-spark-', datestr(now,30)], ...
                        sparkMaster); %#ok<DATST,TNOW1>
                end
                idx = SH.addSession(sparkMaster, spark); %#ok<NASGU>
            else
                spark = SH.Sessions{idx};
            end
        end
        
        function deleteSession(sparkMaster)
            SH = matlab.sparkutils.SparkSessionHandler.getSessionHandler();
            deleteOneSession(SH, sparkMaster);
        end

        function sessions = listSessions()
            SH = matlab.sparkutils.SparkSessionHandler.getSessionHandler();
            if nargout == 0
                N = length(SH.SessionMasters);
                if N == 0
                    fprintf('No Spark sessions\n');
                else
                    fprintf('Spark sessions:\n%s', ...
                        sprintf('\t%s\n', SH.SessionMasters{:}));
                end
            else
                sessions = SH.SessionMasters;
            end
        end
        
        function deleteSessions()
            SH = matlab.sparkutils.SparkSessionHandler.getSessionHandler();
            SH.SessionMasters = {};
            SH.Sessions = {};
        end
    end
end
