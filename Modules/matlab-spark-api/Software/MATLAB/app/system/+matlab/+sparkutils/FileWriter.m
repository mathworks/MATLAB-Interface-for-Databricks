classdef FileWriter < handle
    % FileWriter - Helper class for creating a File
    % 
    % This is inherited in two other classes, JavaWriter and PythonWriter.
    %
    % These are not generic utilities, but targeted at the needs of this project.

    % Copyright 2021-2024, The MathWorks Inc.
    
    properties(SetAccess=private)
    end
    properties
        Package string
        ClassName string
        Imports string
        Variables string
        Methods string
        PostClass string = ""
        PathPrepend string
        Blocks string
    end
    
    properties(Dependent=true,SetAccess=private)
        FileName
    end
    
    methods
        function this = FileWriter(pkgName, className, options)
            arguments
                pkgName (1,1) string
                className (1,1) string
                options.pathPrepend string = string.empty
            end
            this.Package = pkgName;
            this.ClassName = className;
            if ~isempty(options.pathPrepend)
                this.PathPrepend = options.pathPrepend;
            end
        end
        
        function addImport(obj, importStr)
            % addImport Adds an import string
            % addImport("my.fine.Class")
            % will produce the line
            % import my.fine.Class;
            obj.Imports(end+1) = importStr;
        end
        
        function SW = newMethod(~)
            % newMethod Return a StringWriter for a method
            SW = matlab.sparkutils.StringWriter();
        end
        
        function addMethod(obj, str, atStart)
            if nargin < 3
                atStart = false;
            end
            if isa(str, 'matlab.sparkutils.StringWriter')
                str = str.getString();
            end
            if atStart
                obj.Methods = [string(str), obj.Methods];
            else
                obj.Methods(end+1) = string(str);
            end
        end
        
        function addBlockFromFile(obj, fileName)
            obj.Blocks(end+1) = fileread(fileName);
        end

        function addVariable(obj, str, varargin)
            % addVariable Adds a member variable to the class
            % JW.addVariable("public int num");
            % printf arguments can also be used, i.e.
            % JW.addVariable("public %s %s", typeName, memberName);
            obj.Variables(end+1) = string(sprintf(str, varargin{:}));
        end
        
        function addPostClass(obj, str)
            if isa(str, 'matlab.sparkutils.StringWriter')
                str = str.getString();
            end
            obj.PostClass = obj.PostClass + string(str);
        end
        
        function name = lastPackageLevel(obj)
            pkgParts = split(string(obj.Package), ".");
            name = char(pkgParts(end));
        end
        
        function str = escape(~, str)
            str = strrep(str, '\', '\\');
        end
        
        function ret = isPython(obj)
            ret = isa(obj, 'matlab.sparkutils.PythonWriter');
        end
        
        function pfn = plainFileName(obj)
            [~, f, e] = fileparts(obj.FileName);
            pfn = sprintf("%s%s", f, e);
        end
    end
    
    
    % Set/Get
    methods
        
        function fileName = get.FileName(obj)
            fileName = obj.getFileName();
        end
    end
    
    methods (Abstract)
        fileName = getFileName(obj)
        writeFile(obj)
    end
    
end
