classdef NotebookWriter < matlab.sparkutils.StringWriter
    % NotebookWriter - Helper class for writing Databricks Notebooks
    
    % Copyright 2025, The MathWorks Inc.
    
    properties(SetAccess=private)
        IsFirst (1,1) logical = true
        CommentChar (1,1) string = "#"
    end
    
    methods
        function obj = NotebookWriter( varargin )
            obj@matlab.sparkutils.StringWriter(varargin{:});
        end

        function addHeader(obj, sectionTitle)
            if obj.IsFirst
                obj.IsFirst = false;
                obj.comment('Databricks notebook source');
            else
                obj.pf('\n');
                obj.comment('COMMAND ----------');
                obj.pf('\n');
            end
            obj.comment('DBTITLE 1,%s', sectionTitle);

        end

        function comment(obj, commentStr, varargin)
            arguments
                obj (1,1) matlab.sparkutils.NotebookWriter
                commentStr (1,1) string
            end
            arguments (Repeating)
                varargin
            end


            obj.pf('%s%s\n', obj.CommentChar, sprintf(char(commentStr), varargin{:}));

        end

        function magic(obj, commentStr, varargin)
            arguments
                obj (1,1) matlab.sparkutils.NotebookWriter
                commentStr (1,1) string
            end
            arguments (Repeating)
                varargin
            end


            obj.pf('%s MAGIC %s\n', obj.CommentChar, sprintf(char(commentStr), varargin{:}));

        end

    end
end
