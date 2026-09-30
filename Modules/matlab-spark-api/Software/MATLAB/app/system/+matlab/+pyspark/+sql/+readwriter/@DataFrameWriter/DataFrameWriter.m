classdef DataFrameWriter < matlab.pyspark.internal.PyWrapper
    % DATAFRAMEWRITER Interface to write datasets to external storage systems
    %  This object can be used to write to external storage systems such as
    % file systems, key-value stores, etc.
    %
    % Use SparkSession.write() to access this.


    % Copyright 2024 MathWorks, Inc.

    properties(Hidden)
        dataFrameWriter;
    end

    methods
        %% Constructor
        function obj = DataFrameWriter(writer)
            % Store the handle if provided
            if nargin==1
                obj.dataFrameWriter = writer;
            end
        end

        function pyObj = toPy(obj)
            pyObj = obj.dataFrameWriter;
        end

    end
end %class