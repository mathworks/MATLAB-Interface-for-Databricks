function link = htmlLink(doc)
    % HTMLLINK Returns a link to a Documentation/html/<file>.html file
    %
    % Example:
    %   link = matlab.databricks.internal.htmlLink("DBConnect")

    % Copyright 2024 The MathWorks, Inc.

    arguments
        doc string {mustBeTextScalar, mustBeNonzeroLengthText}
    end
    docPath = databricksRoot(-2, "Documentation", "html", doc + ".html");
    link = matlab.utils.URL2Link(docPath);
end
