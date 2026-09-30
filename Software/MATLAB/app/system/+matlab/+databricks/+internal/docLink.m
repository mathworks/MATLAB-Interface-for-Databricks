function link = docLink(doc)
    % DOCLINK Returns a HTML or Markdown link to a /Documentation file
    % In the case of Markdown in deployed mode a path path is returned.
    %
    % Example:
    %   link = matlab.databricks.internal.docLink("DBConnect");

    % Copyright 2024 The MathWorks, Inc.

    arguments
        doc string {mustBeTextScalar, mustBeNonzeroLengthText}
    end

    docPath = databricksRoot(-2, "Documentation", "html", doc + ".html");
    if isfile(docPath)
        link = matlab.databricks.internal.htmlLink(doc);
    else
        link = matlab.databricks.internal.mdLink(doc);
    end
end