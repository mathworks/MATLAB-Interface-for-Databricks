function startGenieChat(varargin)
    % STARTGENIECHAT Start a Genie chat
    %
    % Example:
    %   matlab.databricks.startGenieChat();

    % Copyright 2025 The MathWorks, Inc.

    genie = matlab.databricks.genie.Genie(varargin{:});
    genie.chat();

end
