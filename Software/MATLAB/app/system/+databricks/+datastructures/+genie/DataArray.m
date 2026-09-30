classdef DataArray
    % DATAARRAY

    % Copyright 2025 The MathWorks, Inc.

    properties
        rawData string
        data string
    end

    methods
        function obj = DataArray(rawData)
            arguments
                rawData string {mustBeNonzeroLengthText, mustBeTextScalar}
            end
            
            obj.rawData = rawData;
            obj.data = obj.toEntries();
        end

        function data = toEntries(obj)
            json = com.google.gson.JsonParser().parse(obj.rawData);

            % Ensure input is always an array
            if (~json.isJsonArray())
                j = com.google.gson.JsonArray();
                j.add(json);
                json = j;
            end

            % For all elements in the JSON array
            N = json.size();

            % For an empty array
            if N == 0
                data = string.empty;
                return
            else
                data = strings(N, 1);
            end

            for arrayIndex = 1:N
                curElement = json.get(arrayIndex-1);
                if curElement.isJsonNull
                    data(arrayIndex) = missing;
                else
                    data(arrayIndex) = string(curElement.toString);
                end
            end
        end
    end
end
