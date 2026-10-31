classdef PythonWriter < matlab.sparkutils.FileWriter
    % PythonWriter A class for writing a Python file
    %
    % This function is based on the general StringWriter class, but has some
    % additional methods for handling sub-functions in consistent manner.

    % Copyright 2024-2025, The MathWorks Inc.

    properties (SetAccess=private)
        Bulk string = string.empty
    end

    methods
        function PW = PythonWriter(varargin)
            PW@matlab.sparkutils.FileWriter(varargin{:})
        end

        function delete(obj)
            writeFile(obj);
        end

    end
    methods
        function writeFile(obj)
            
            SW = matlab.sparkutils.StringWriter(obj.FileName);
            
            if strlength(obj.Package) == 0
                SW.pf("# %s\n\n\n", obj.ClassName);
            else
                SW.pf("# %s.%s\n\n\n", obj.Package, obj.ClassName);
            end
            uniqueImports = unique(obj.Imports, 'stable');
            for k=1:length(uniqueImports)
               SW.pf("%s\n", uniqueImports(k)); 
            end
            
            
            NV = length(obj.Variables);
            if NV > 0
                SW.pf("# Variables \n");
                for k=1:NV
                    SW.pf("%s\n", obj.Variables(k));
                end
                SW.pf("\n");
            end

            NV = length(obj.Blocks);
            if NV > 0
                for k=1:NV
                    SW.insertLines(obj.Blocks(k));
                end
            end

            NV = length(obj.Methods);
            if NV > 0
                SW.pf("# Methods \n");
                for k=1:NV
                    SW.insertLines(obj.Methods(k));
                    SW.pf("\n");
                end
                SW.pf("\n");
            end
            
            % Add stuff for PostClass
            SW.pf("\n%s\n", obj.PostClass);

            for k=1:numel(obj.Bulk)
                SW.insertLines(obj.Bulk(k));
                SW.pf("\n");
            end

            SW.pf("# End of file: %s */\n\n", obj.escape(obj.plainFileName));
        end

        function addBulk(obj, bulk)
            if isa(bulk, 'matlab.sparkutils.StringWriter')
                bulk = bulk.getString();
            end

            obj.Bulk(end+1) = bulk;
        end

        function fileName = getFileName(obj)
            pkgParts = split(obj.Package, ".");
            if isempty(obj.PathPrepend)
                filePath = fullfile(pkgParts{:});
            else
                filePath = fullfile(obj.PathPrepend, pkgParts{:});
            end
            if ~exist(filePath, 'dir')
                mkdir(filePath);
            end
            fileName = sprintf("%s.py", fullfile(filePath, lower(obj.ClassName)));
        end        
    end

end 