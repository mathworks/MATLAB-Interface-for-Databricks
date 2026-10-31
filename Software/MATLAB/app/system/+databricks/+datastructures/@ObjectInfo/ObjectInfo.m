classdef ObjectInfo < handle
    % ObjectInfo Databricks structure for Workspaces

    % Copyright 2022 The MathWorks, Inc.


    properties
        object_type (1,1) databricks.datastructures.ObjectType
        object_id   (1,1) int64
        path        (1,1) string
        language    (1,1) string
    end

    methods
        function obj = ObjectInfo(ot, oid, p, lang)
            obj.object_type = ot;
            obj.object_id = oid;
            obj.path = p;
            if nargin > 3
                obj.language = lang;
            end
        end
    end
    methods(Static)
        function obj = fromJSON(jsonStr)
            % May return empty JSON {} if there are no files
            allowMissing = false;

            OT = jsondecodeTypedValues(jsonStr, allowMissing, {"objects", {':'}, "object_id"}, "int64");

            if numel(fieldnames(OT))~=0 % empty structure
                % GET request response
                N = numel(OT.objects);
                useCells = iscell(OT.objects);
                for oCount = 1:N
                    if useCells
                        OTE = OT.objects{oCount};
                    else
                        OTE = OT.objects(oCount);
                    end
                    if isfield(OTE, 'language')
                        obj(oCount) = databricks.datastructures.ObjectInfo(...
                            OTE.object_type, OTE.object_id, OTE.path, OTE.language); %#ok<*AGROW>
                    else
                        obj(oCount) = databricks.datastructures.ObjectInfo(...
                            OTE.object_type, OTE.object_id, OTE.path); %#ok<*AGROW>
                    end
                end
            else
                obj = databricks.datastructures.ObjectInfo.empty;
            end

        end %function
    end
end