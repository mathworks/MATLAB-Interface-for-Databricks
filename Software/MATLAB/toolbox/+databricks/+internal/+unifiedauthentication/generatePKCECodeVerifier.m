function verifier = generatePKCECodeVerifier()
%GENERATEPKCECODEVERIFIER New PKCE code_verifier.
%   VERIFIER = GENERATEPKCECODEVERIFIER() returns a new RFC 7636
%   code_verifier: a 43-character string scalar made from 32 secure random
%   bytes (256 bits), Base64URL-encoded by GENERATESECURERANDOMBASE64URL.
%   This is the construction RFC 7636 section 4.1 recommends, and 43
%   characters is the minimum length it allows (the maximum is 128).
%
%   Use a new verifier for every authorization request and keep it secret:
%   send only its code_challenge in the authorization request, and the
%   verifier itself only in the token request.
%
%   Example:
%     verifier = generatePKCECodeVerifier();
%
%   Error identifiers:
%     generateSecureRandomBase64URL:*   the OS random source failed; see
%                                       GENERATESECURERANDOMBASE64URL
%
%   See also GENERATEOAUTH2STATE, GENERATESECURERANDOMBASE64URL.

    % Copyright 2026 The MathWorks, Inc.

    verifier = databricks.internal.unifiedauthentication.generateSecureRandomBase64URL(verifierBytes());
end

function n = verifierBytes()
    n = 32;                         % ceil(4*32/3) = 43 characters (RFC 7636 minimum)
end
