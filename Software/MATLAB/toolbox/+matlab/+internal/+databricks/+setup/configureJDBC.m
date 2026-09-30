function tf = configureJDBC(options)
    % CONFIGUREJDBC Queries acceptance of Databricks JDBC Driver licenses
    % If the licenses are not accepted the drivers are renamed such that they are
    % not automatically configured for use.
    %
    % Returns false if the license is not accepted or if a driver file is not found.
    %
    % Example
    %   tf = matlab.internal.databricks.setup.configureJDBC();

    % Copyright 2024-2026 The MathWorks, Inc.

    arguments (Input)
        options.acceptance (1,1) logical
        options.verbose (1,1) logical = true
    end
    arguments (Output)
        tf (1,1) logical
    end

    jdbcSimbaJarFile = matlab.internal.databricksRoot("lib", "jar", "Shaded-Databricks-JDBC-Driver-0.0.2.jar");
    jdbcOSSJarFile = matlab.internal.databricksRoot("lib", "jar", "Databricks-JDBC-OSS-Driver-0.0.1.jar");

    simbaJarFound = isfile(jdbcSimbaJarFile);
    ossJarFound = isfile(jdbcOSSJarFile);

    if isfield(options, "acceptance")
        if options.acceptance
            if options.verbose
                dispLicenses();
                fprintf("Licenses accepted.\n");
            end
            if simbaJarFound || ossJarFound
                tf = true;
            else
                fprintf(2, "Databricks JDBC drivers not found, expected one or both of:\n");
                fprintf(2, "  %s\n", jdbcSimbaJarFile);
                fprintf(2, "  %s\n", jdbcOSSJarFile);
                tf = false;
            end
        else
            if options.verbose
                fprintf("\nDatabricks JDBC driver licenses are not accepted and should not be used.\n");
                dispLicenses();
            end
            tf = false;
        end
    else
        dispLicenses();
        reply = strip(input('Accept the Databricks license terms? Y/N [Y]: ','s'));
        if strcmpi(reply,'y') || strlength(reply) == 0
            fprintf("Licenses accepted.\n");
            tf = true;
        else
            fprintf("\nDatabricks JDBC driver licenses are not accepted and should not be used.\n");
            tf = false;
        end

        if options.verbose
          msg = onCleanup(@() ODBCFileMessage()); %#ok<NASGU>
        end
    end
end


function ODBCFileMessage()
    ODBCUrl = matlab.internal.utils.URL2Link("https://www.databricks.com/spark/odbc-drivers-download");
    fprintf("\nThe Databricks ODBC driver is also supported and can be downloaded from:\n");
    fprintf("  %s\n", ODBCUrl);
end


function dispLicenses(inError)
    arguments
        inError (1,1) logical = false
    end

    if inError
        fid = 2;
    else
        fid = 1;
    end

    simbaLicURL = "https://www.databricks.com/legal/jdbc-odbc-driver-license";
    simbaLicPath = matlab.internal.databricksRoot(-2, "3rdPartyLicenses", "Databricks_JDBC_ODBC_driver_license.pdf");
    ossLicURL = "https://github.com/databricks/databricks-jdbc/blob/main/LICENSE";
    ossLicPath = matlab.internal.databricksRoot(-2, "3rdPartyLicenses", "Databricks_JDBC_OSS_driver_license.txt");

    fprintf(fid, "Databricks JDBC driver licenses:\n");
    fprintf(fid, "  Simba: %s\n", matlab.internal.utils.URL2Link(simbaLicURL));
    fprintf(fid, "         %s\n", simbaLicPath);
    fprintf(fid, "    OSS: %s\n", matlab.internal.utils.URL2Link(ossLicURL));
    fprintf(fid, "         %s\n", ossLicPath);
end
