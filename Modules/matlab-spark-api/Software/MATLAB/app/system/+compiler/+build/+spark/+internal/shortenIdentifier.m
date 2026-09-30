function [shortName, fullName] = shortenIdentifier(name)
    % shortenIdentifier Shorten identifier if necessary

    % Copyright 2025 The MathWorks, Inc.

    arguments
        name (1,1) string
    end

    if strlength(name) > 60
        digest = compiler.build.spark.internal.calcDigest(name);
        N = strlength(digest);
        cutOff = 60-N;
        shortName = extractBefore(name, cutOff) + "_" + digest;
        fullName = name;
    else
        shortName = name;
        fullName = name;
    end
end