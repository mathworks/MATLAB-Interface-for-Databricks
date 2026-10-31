classdef LibraryType < JSONEnum
    % LIBRARYTYPE Enumeration of Databricks library types
    
    % (c) 2025 The MathWorks Inc.

    enumeration
        CRAN ("CRAN")
        EGG ("EGG")
        JAR ("JAR")
        MAVEN ("MAVEN")
        WHL ("WHL")
        PYPI ("PYPI")
        REQUIREMENTS ("REQUIREMENTS")
    end
end

