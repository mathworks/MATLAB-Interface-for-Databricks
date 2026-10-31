function tf = checkDBCJCP()
    % CHECKDBCJCP Check if there is a legacy Databricks Connect entry on the static class path

    % Copyright 2024 The MathWorks, Inc.

    arguments
    end

    staticP = javaclasspath('-static');
    dbcPat = "matlab-databricks-connect" + wildcardPattern(6,20) + ".jar";
    
    if any(contains(staticP, dbcPat))
        fprintf("\n");
        fprintf("Checking Java class path for legacy Databricks Connect jar files\n");
        fprintf("----------------------------------------------------------------\n");
        fprintf(2, "A legacy Databricks Connect .jar has been detected on MATLAB's Java static class path.\n");
        fprintf("From v5.0.0 Databricks Connect (v2) uses Python based libraries.\n");
        classpathPath = fullfile(prefdir, "javaclasspath.txt");
        if isfile(classpathPath)
            fprintf("The classpath entry can be removed, or commented out using a '#', in:\n  %s\n", matlab.utils.editLink(classpathPath));
        else
            fprintf("The classpath entry can be removed, or commented out using a '#', from the non default javaclasspath.txt file.\n");
        end
        tf = true;
    else
        tf = false;
    end
end
