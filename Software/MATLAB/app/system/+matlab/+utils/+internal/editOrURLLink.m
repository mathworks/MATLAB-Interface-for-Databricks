function link = editOrURLLink(baseFileName)
    % EDITORURLLINK Returns and editor link or a HTML link
    % HTML is preferred.
    % Returns a string.
    % Assumes the default Documentation directory structure.
    %
    % Example:
    %   link = matlab.utils.internal.editOrURLLink("InitScripts");

    %  (c) 2024 MathWorks, Inc.

    arguments
        baseFileName string {mustBeTextScalar, mustBeNonzeroLengthText}
    end

    docPath = databricksRoot(-2, "Documentation", "html", baseFileName + ".html");
    if isfile(docPath)
        link = matlab.utils.URL2Link(docPath);
    else
        docPath = databricksRoot(-2, "Documentation", baseFileName + ".md");
        if isfile(docPath)
            link = matlab.utils.editLink(docPath);
        else
            link = sprintf("File not found: %s", docPath);
            fprintf(2, "%s\n", link);
        end
    end
end