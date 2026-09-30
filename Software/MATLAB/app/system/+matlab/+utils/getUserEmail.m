function email = getUserEmail()
    % GETUSEREMAIL Try to retrieve the email address of the current user
    % A character vector is returned.

    % Copyright 2020-2021 MathWorks, Inc

    persistent EMAIL
    if isempty(EMAIL)
        email = getEmailFromGit();

        if isempty(email)
            % Try using nslookup on Linux or WMIC or similar on Windows and
            % some basic assumptions
            email = getEmailFromSystem();
        end

        EMAIL = email;
    end
    email = char(EMAIL);

end

function email = getEmailFromGit()
    [r,s] = system('git config --get user.email');
    if r~=0
        email = '';
    else
        email = strip(s);
    end
end

function email = getEmailFromSystem()
    user = getUserName();
    domain = getDomainName();
    if isempty(user) || isempty(domain)
        email = '';
    else
        email = [user, '@', domain];
    end
end

function domainname = getDomainName()
    if isunix()
        [r,s] = system('nslookup localhost | grep Name | cut -d: -f2');
        if r~=0
            domainname = '';
        else
            domainname = strip(s);
        end
    else
        [r,s] = system('wmic computersystem get domain');
        if r~=0
            domainname = '';
        else
            domainname = strip(s);
        end
    end
    domainname = cleanDomainName(domainname);
end

function domainname = cleanDomainName(domainname)
   domainname = regexprep(domainname, '^ad\.', '');
   domainname = regexprep(domainname, '^localhost\.', '');
end

function username = getUserName()
    username = getenv('USER');
    if isempty(username)
        username = getenv('USERNAME');
    end
    username = strip(username);
end
