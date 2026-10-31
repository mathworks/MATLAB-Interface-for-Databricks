function jsonName = getJSONName(fullFileName)
    % getJSONName Get the JSON name for a helper file

    % Copyright 2022-2024 The MathWorks, Inc.
    arguments
        fullFileName (1,1) string
    end

    jsonName = regexprep(fullFileName, "(.*)\.m$", "$1_signature.json");
end
