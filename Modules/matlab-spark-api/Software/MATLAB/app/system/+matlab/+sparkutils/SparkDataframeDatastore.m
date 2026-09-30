classdef SparkDataframeDatastore < matlab.io.Datastore
    % SparkDataframeDatastore Class to help build the javaclasspath necessary for Spark
    
    % Copyright 2021-2024 The MathWorks, Inc.
    
    properties% (Access = private)
        CurrentIndex double
        SparkDatasets matlab.spark.sql.Dataset
        BaseDataset matlab.spark.sql.Dataset
        FullCount double
        NumSets double
        CurrentDatasetIdx double
        BatchSize double
    end
    
    methods
        function obj = SparkDataframeDatastore(sparkDataset, varargin)
            
            validNumber =  @(x) validateattributes(x, {'numeric'}, {'nonempty', 'scalar', '>', 0});

            p = inputParser;
            p.addParameter('BatchSize',20000,validNumber);       %Start at the beginning
            
            % Parse and setup the parameters
            p.parse(varargin{:});
            obj.BatchSize = p.Results.BatchSize;
            
            obj.BaseDataset = sparkDataset;
            
            
            
            obj.FullCount = obj.BaseDataset.count();
            % Create a suitable size of datasets. Let's assume we pick at
            % most 20000 elements per batch
            obj.NumSets = ceil(obj.FullCount/obj.BatchSize);
            
            obj.SparkDatasets = obj.BaseDataset.randomSplit(ones(1, obj.NumSets));
            reset(obj);
        end
        
        function tf = hasdata(obj)
            tf = ~isempty(obj.SparkDatasets) && (obj.CurrentDatasetIdx <= obj.NumSets);
        end
        
        function reset(obj)
            fprintf('Resetting Spark Dataset\n');
            obj.CurrentDatasetIdx = 1;
        end
        
        function [data,info] = read(obj)
            if ~hasdata(obj)
                error(sprintf([...
                    'No more data to read.\nUse the reset ',...
                    'method to reset the datastore to the start of ' ,...
                    'the data. \nBefore calling the read method, ',...
                    'check if data is available to read ',...
                    'by using the hasdata method.']))
            end
            
            curDS = obj.SparkDatasets(obj.CurrentDatasetIdx);
            obj.CurrentDatasetIdx = obj.CurrentDatasetIdx + 1;
            t0 = tic;
            data = table(curDS);
            t1 = toc(t0);
            N = curDS.count();
            fprintf('Time to read dataset [%d/%d] %.1f sec., #%d entries.\n', ...
                obj.CurrentDatasetIdx-1, obj.NumSets, t1, N);
            if nargout > 1
                info.Size = curDS.count();
            end
            
        end
        
        function data = preview(obj)
            %PREVIEW   Preview the data contained in the datastore.
            %   Returns a small amount of data from the start of the datastore.
            %   This is the default implementation of the preview method,
            %   subclasses can implement an efficient version of this method
            %   by returning a smaller subset of the data directly from the
            %   read method. Subclasses should also consider implementing a
            %   more efficient version of this method for improved tall
            %   array construction performance. The datatype of the output
            %   should be the same as that of the read method. In the
            %   provided default implementation, a copy of the datastore is
            %   first reset. The read method is called on this copied
            %   datastore. The first 8 rows in the output from the read
            %   method call are returned as output of the preview method.
            %
            %   See also matlab.io.Datastore, read, hasdata, reset, readall,
            %   progress.
            sds = obj.SparkDatasets(1);
            numRows = min(8, sds.count());
            data = table(sds.limit(numRows));
        end
        
    end
    
    methods (Hidden = true)
        function frac = progress(obj)
            % Determine percentage of data read from datastore
            if hasdata(obj)
                frac = obj.CurrentDatasetIdx / obj.NumSets;
            else
                frac = 1;
            end
        end
    end
    
end
