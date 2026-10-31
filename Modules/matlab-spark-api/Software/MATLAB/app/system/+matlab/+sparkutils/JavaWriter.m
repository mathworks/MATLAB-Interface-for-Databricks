classdef JavaWriter < matlab.sparkutils.FileWriter
    % JavaWriter - Helper class for creating a Java file
    
    % Copyright 2021, The MathWorks Inc.
    
    properties(SetAccess=private)
    end
    properties
        Encoders struct
        ClassInheritance string
    end
    
    methods
        function this = JavaWriter(varargin)

            this@matlab.sparkutils.FileWriter(varargin{:})
        end
       
        function addEncoder(obj, entry)
            % addEncoder Adds an encoder. 
            %
            % The encoder info is created by a method in the File class,
            
            if isempty(obj.Encoders)
                obj.Encoders = entry;
            else
                obj.Encoders(end+1) = entry;
            end
        end
        
        function addVariable(obj, str, varargin)
            % addVariable Adds a member variable to the class
            % JW.addVariable("public int num");
            % printf arguments can also be used, i.e.
            % JW.addVariable("public %s %s", typeName, memberName);
           obj.Variables(end+1) = string(sprintf(str, varargin{:}));
        end
       
        function name = getMCRFactoryName(obj)
            pkg = lastPackageLevel(obj);
            pkg(1) = upper(pkg(1));
            name = [pkg, 'MCRFactory'];
        end
        
        function delete(obj)
            writeFile(obj);
        end
    end
    
    % Real methods for abstract ones
    methods
        function writeFile(obj)
            
            SW = matlab.sparkutils.StringWriter(obj.FileName);
            
            SW.pf("/*\n * %s.%s\n */\n\n", obj.Package, obj.ClassName);
            SW.pf("package %s;\n\n", obj.Package);

            obj.addImport("java.io.Serializable");

            uniqueImports = sort(unique(obj.Imports, 'stable'));
            for k=1:length(uniqueImports)
               SW.pf("import %s;\n", uniqueImports(k)); 
            end
            
            % Class definition
            SW.pf("\n");

            SW.pf("public class %s %s implements Serializable {\n", obj.ClassName, obj.ClassInheritance);
            SW.indent();
            
            NV = length(obj.Variables);
            if NV > 0
                SW.pf("\n");
                SW.pf("/* Variables */\n\n");
                for k=1:NV
                    SW.pf("%s;\n", obj.Variables(k));
                end
            end
            
            NV = length(obj.Encoders);
            JM = obj.newMethod();
            JM.pf("/** initEncoders\n");
            JM.pf(" * This method initializes the encoders needed\n");
            JM.pf(" * @param spark An active SparkSession object\n");
            JM.pf(" */\n");
            JM.pf("public static void initEncoders(SparkSession spark) {\n");
            JM.indent();
            if NV > 0
                SW.pf("\n");
                SW.pf("/* Encoders */\n\n");
                for k=1:NV
                    E = obj.Encoders(k);
                    SW.pf("public static Encoder<%s> %s;\n", E.EncType, E.Name);
                    JM.pf("%s = %s;\n", E.Name, E.Constructor);
                end
            else
                JM.pf("/* No encoders present, no need to call this function. */\n");
            end
            JM.unindent();
            JM.pf("}\n");
            obj.addMethod(JM, true);
            
            NV = length(obj.Methods);
            if NV > 0
                SW.pf("\n");
                SW.pf("/* Methods */\n\n");
                for k=1:NV
                    SW.insertLines(obj.Methods(k));
                    SW.pf("\n");
                end
            end
            
            SW.unindent();
            SW.pf("\n} /* End of %s */\n\n", obj.ClassName);

            % Add stuff for PostClass
            SW.pf("\n%s\n", obj.PostClass);

            SW.pf("/* End of file: %s */\n", obj.escape(obj.FileName));
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
            fileName = sprintf("%s.java", fullfile(filePath, obj.ClassName));
        end        
    end

end
