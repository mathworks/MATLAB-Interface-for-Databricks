classdef Disposition < JSONEnum
    % Disposition Fetch disposition for statement results
    % INLINE returns result data inline in JSON_ARRAY format. EXTERNAL_LINKS
    % returns presigned links to result data in cloud storage.

    % Copyright 2023-2026, MathWorks Inc.

    enumeration
        INLINE ("INLINE")
        EXTERNAL_LINKS ("EXTERNAL_LINKS")
    end
end
