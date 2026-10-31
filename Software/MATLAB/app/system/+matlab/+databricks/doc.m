function doc(varargin)
    % DOC Opens index.html in a browser or otherwise README.md in MATLAB
    % If a specific case sensitive filename without extension is provided it will
    % be opened, favouring the html form over the markdown form. If an extension
    % is provided that document type will be opened. HTML files are opened in a browser tab,
    % Markdown files are opened in MATLAB.
    %
    % Examples:
    %   matlab.databricks.doc
    %
    %   matlab.databricks.help('Files')
    %
    % See also: matlab.databricks.help

    % Copyright 2026 The MathWorks, Inc.

    if isdeployed
        fprintf(2, "Not supported in deployed mode\n.");
        return;
    end

    if nargin == 0
        htmlPath = databricksRoot(-2, "Documentation", "html", "index.html");
        if isfile(htmlPath)
            web(htmlPath, "-browser");
        else
            mdPath = databricksRoot(-2, "Documentation", "README.md");
            if isfile(mdPath)
                edit(mdPath);
            else
                fprintf(2, "Documentation not found: %s\n", mdPath);
            end
        end
    else
        % Handle specific filename argument
        if endsWith(varargin{1}, ".html")
            if isfile(varargin{1})
                htmlPath = varargin{1};
            else
                htmlPath = databricksRoot(-2, "Documentation", "html", varargin{1});
            end
            if isfile(htmlPath)
                web(htmlPath, "-browser");
            else
                fprintf(2, "Documentation not found: %s\n", htmlPath);
            end
        elseif endsWith(varargin{1}, ".md")
            if isfile(varargin{1})
                mdPath = varargin{1};
            else
                mdPath = databricksRoot(-2, "Documentation", varargin{1});
            end
            if isfile(mdPath)
                edit(mdPath);
            else
                fprintf(2, "Documentation not found: %s\n", mdPath);
            end
        else
            if isfile(string(varargin{1})+".html")
                htmlPath = string(varargin{1})+".html";
            else
                htmlPath = databricksRoot(-2, "Documentation", "html", string(varargin{1})+".html");
            end
            if isfile(htmlPath)
                web(htmlPath, "-browser");
            else
                if isfile(string(varargin{1})+".md")
                    mdPath = string(varargin{1})+".md";
                else
                    mdPath = databricksRoot(-2, "Documentation", string(varargin{1})+".md");
                end
                if isfile(mdPath)
                    edit(mdPath);
                else
                    fprintf(2, "Documentation not found: %s\n", varargin{1});
                end
            end
        end
    end
end