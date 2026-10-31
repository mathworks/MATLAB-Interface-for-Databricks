classdef StructType < compiler.build.spark.schema.DataType
    % StructType Structure class for Spark schema types

    % Copyright 2024 The MathWorks, Inc.

    properties
        fields compiler.build.spark.schema.StructField
        names string
    end
    methods
        function obj = StructType(initVal, options)
            arguments
                initVal = []
                % This is only used when initializing from a value
                options.parentIsArray (1,1) logical = false
            end
            obj@compiler.build.spark.schema.DataType();
            obj.type = 'struct';
            if isempty(initVal)
                return;
            end
            if isa(initVal, 'py.pyspark.sql.types.StructType')
                fields = cell(initVal.fields);
                names = string(initVal.names);
                for k=1:numel(fields)
                    F = fields{k};
                    fieldSchema = compiler.build.spark.schema.DataType.createSchema(F);
                    obj.add(names(k), fieldSchema);
                end

            else              
                if options.parentIsArray
                    FN = string(fieldnames(initVal{1}));
                    for k=1:numel(FN)
                        curFN = FN(k);
                        numRows = numel(initVal);
                        firstVal = initVal{1}.(curFN); % Will discard later array entries
                        clazz = class(firstVal);
                        isSubArray = false;
                        for r=1:numRows
                            rVal = initVal{r};
                            if any(arrayfun(@(x) numel(x.(curFN)), rVal, 'UniformOutput', true) > 1)
                                isSubArray = true;
                                break;
                            end
                        end
                        % isSubArray = any(cellfun(@(x) numel([x.(curFN)]), initVal, 'UniformOutput', true) > 1);
                        if isSubArray
                            tmpCol = cellfun(@(x) [x.(curFN)], initVal, 'UniformOutput', false);
                            colSchema = compiler.build.spark.schema.ArrayType(tmpCol);
                        else
                            % If the type is complex, i.e. struct or map,
                            % this must be handled differently
                            switch clazz
                                case 'struct'
                                    for r=1:numRows
                                        rVal = initVal{r};
                                        if r==1
                                            colVal = [rVal.(curFN)];
                                        else
                                            colVal = [colVal, rVal.(curFN)];
                                        end
                                    end
                                    colSchema = compiler.build.spark.schema.DataType.matlabClassToSchema_col(colVal, clazz);
                                case 'dictinoary'
                                    exp(pi)-pi
                                otherwise
                                    tmpCol = cellfun(@(x) x.(curFN), initVal, 'UniformOutput', true);
                                    colSchema = compiler.build.spark.schema.DataType.matlabClassToSchema_col(tmpCol, clazz);
                            end
                        end
                        obj.add (curFN, colSchema);                        
                    end
                else
                    FN = string(fieldnames(initVal));
                    for k=1:numel(FN)
                        curFN = FN(k);
                        isSubArray = any(arrayfun(@(x) numel(x.(curFN)), initVal, 'UniformOutput', true) > 1);
                        if isSubArray
                            colSchema = compiler.build.spark.schema.ArrayType({initVal.(curFN)});
                        else                            
                            tmpCol = [initVal.(curFN)];
                            clazz = obj.getClassTS(tmpCol);
                            colSchema = compiler.build.spark.schema.DataType.matlabClassToSchema_col(tmpCol, clazz);
                        end
                        obj.add (curFN, colSchema);
                    end
                end
            end
        end

        function st = add(st, fieldName, datatype, options )
            arguments
                st (1,1) compiler.build.spark.schema.StructType
                fieldName (1,1) string
                datatype (1,1)
                options.nullable (1,1) logical = true
                options.metadata
            end

            st.names(end+1) = fieldName;
            % TODO: Right now, assume a real Python StructField is used as argument
            if isa(datatype, 'compiler.build.spark.schema.StructField')
                st.fields(end+1) = datatype;
            else
                st.fields(end+1) = compiler.build.spark.schema.StructField(fieldName, datatype, options.nullable);
            end

        end

        function so = toStruct(obj)
            % toStruct Create struct object suitable for JSON conversion
            % Default implementation for atomic types is a string of the type
            
            localFields = arrayfun(@(x) x.toStruct(), obj.fields);
            so = struct("fields", localFields, "type", obj.type);
        end

        function PI = pythonInitCode(obj)
            % pythonInitCode Return python init code
            % This will be something like LongType() for atomic types. For
            % compound types, this method must be overridden.
            PT = obj.pythonType();
            PI = PT + "([" + ...
                join(arrayfun(@(x) x.pythonInitCode, obj.fields), ", ") + ...
                "])";
        end

         function obj = fromVal(obj, val)
             for k=1:numel(val.fields)
                 F = val.fields(k);
                 elemType = compiler.build.spark.schema.mathworks.CommonBase.instanceFromVal(F.type);
                 obj.add(F.name, elemType, nullable=F.nullable, metadata=F.metadata);
             end
         end

         function str = pythonSchemaType(obj)
             % pythonSchemaType Return schema type
             % Base case is just the type name. Override if necessary
             arguments
                 obj (1,1) compiler.build.spark.schema.StructType
             end
             N = numel(obj.fields);
             subTypes = strings(1,N);
             for k=1:N
                SUB = obj.fields(k).dataType;
                 subTypes(k) = sprintf("%s:%s", obj.names(k), pythonSchemaType(SUB));
             end
             str = "struct<" + join(subTypes, ",") + ">";
         end

    end

end