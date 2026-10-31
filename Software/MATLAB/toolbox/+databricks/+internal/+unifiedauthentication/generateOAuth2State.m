function state = generateOAuth2State()
%GENERATEOAUTH2STATE New OAuth 2.0 "state" value.
%   STATE = GENERATEOAUTH2STATE() returns a 43-character string scalar
%   made from 32 secure random bytes (256 bits), Base64URL-encoded by
%   GENERATESECURERANDOMBASE64URL. RFC 6749 section 10.12 requires "state"
%   to be non-guessable but sets no length. The usual figure comes from
%   RFC 6749 section 10.10, written for generated tokens and credentials:
%   the chance of guessing MUST be at most 2^-128 and SHOULD be at most
%   2^-160. 256 bits exceeds both. The characters (A-Z, a-z, 0-9, '-',
%   '_') need no escaping in URLs.
%
%   Use a new value for every authorization request. Store it with the
%   user's session before redirecting; on the callback, check that the
%   returned state matches exactly, then discard it. RFC 9700 requires a
%   CSRF token carried in "state" to be single-use and bound to the user
%   agent. Compare with ISEQUAL, not ~=: if the returned value is
%   string.empty, "returned ~= stored" is empty and an IF treats it as
%   false, so the check would be silently skipped.
%
%     if ~isequal(string(returnedState), storedState)
%         error("OAuth state mismatch");
%     end
%
%   Example:
%     state = generateOAuth2State();
%
%   Error identifiers:
%     generateSecureRandomBase64URL:*   the OS random source failed; see
%                                       GENERATESECURERANDOMBASE64URL
%
%   See also GENERATEPKCECODEVERIFIER, GENERATESECURERANDOMBASE64URL.

    % Copyright 2026 The MathWorks, Inc.

    state = databricks.internal.unifiedauthentication.generateSecureRandomBase64URL(stateBytes());
end

function n = stateBytes()
    n = 32;                         % ceil(4*32/3) = 43 characters, 256 bits
end
