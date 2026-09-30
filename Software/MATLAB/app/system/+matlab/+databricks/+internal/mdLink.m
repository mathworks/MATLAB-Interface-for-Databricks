function link = mdLink(doc)
    % MDLINK Returns an edit link to a Documentation/<file>.md file
    % In deployed mode a path path is returned.
    %
    % Example:
    %   link = matlab.databricks.internal.mdLink("DBConnect")

    % Copyright 2024 The MathWorks, Inc.

    arguments
        doc string {mustBeTextScalar, mustBeNonzeroLengthText}
    end
    docPath = databricksRoot(-2, "Documentation", doc + ".md");
    link = matlab.utils.editLink(docPath);
end
