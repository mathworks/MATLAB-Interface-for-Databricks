
classdef Format < JSONEnum
    % FORMAT Data type enum
    %
    % Example:
    %   f = databricks.datastructures.genie.Format.CSV;
    %
    % See also: https://docs.databricks.com/api/workspace/genie/executemessageattachmentquery#statement_response-manifest

    % (c) 2025 The MathWorks Inc.

    enumeration
        JSON_ARRAY ("JSON_ARRAY")
        ARROW_STREAM ("ARROW_STREAM")
        CSV ("CSV")
    end
end
