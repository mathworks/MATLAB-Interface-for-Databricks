function tf = isValidUnixUserName(name, options)
    % isValudUnixUserName Attempt to validate if a username is a valid Unix username
    % Checks based on the Linux adduser requirements.
    % Currently non system user requirements are applied.
    %
    % Example:
    %   tf = matlab.utils.isValidUnixUserName("joeuser");
    %
    % An optional useSystemNames named argument can be provided to use the
    % system account check rather than the regular user account check.
    
    % The adduser command validates a username.
    % The conf file /etc/adduser.conf has two variables that control usernames.
    % NAME_REGEX for normal users & NAME_REGEX_SYSTEM: for system users.
    % By default are set to ^[a-z][-a-z0-9_]*\$?$
    % That is: 
    %     1) Start with a lowercase letter
    %     2) Contain only lowercase letters, numbers, underscores, & hyphens
    %     3) Optionally end with a dollar sign

    % Copyright 2025 MathWorks, Inc.

    arguments
        name string {mustBeTextScalar, mustBeNonzeroLengthText}
        options.useSystemNames (1,1) logical = false
        options.maxLength (1,1) int32 = 32
    end

    tf = false;
    
    if strlength(name) > options.maxLength
        return;
    end

    if options.useSystemNames
        pat = '^[A-Za-z_][-A-Za-z0-9_]*\$?$';
    else
        pat = '^[a-z][-a-z0-9_]*\$?$';
    end
    
    % Validate the username against the regex pattern
    [sIdx, eIdx] = regexp(name, pat, 'once');

    if isempty(sIdx) || isempty(eIdx)
        return;
    end

    if ~isscalar(sIdx) || ~isscalar(eIdx)
        return;
    end
   
    if sIdx ~= 1 || eIdx ~= strlength(name)
        return;
    end

    tf = true;
end
