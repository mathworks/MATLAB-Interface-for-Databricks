function finish()
    % finish - Runs at the end of a MATLAB session
    %
    % This function runs at the end of MATLAB session, and will only be
    % active when it's running on a Databricks node.

    % Copyright 2025 The MathWorks, Inc.

    matlab.databricks.finish();

end