function s = generateSecureRandomBase64URL(n)
%GENERATESECURERANDOMBASE64URL Secure random string, Base64URL-encoded.
%   S = GENERATESECURERANDOMBASE64URL() returns a string scalar made from
%   32 secure random bytes (256 bits), Base64URL-encoded: 43 characters.
%
%   S = GENERATESECURERANDOMBASE64URL(N) uses N random bytes, where N is a
%   whole number from 32 to 96. The result has ceil(4*N/3) characters (43
%   to 128), so every result is also a valid PKCE code_verifier (RFC 7636
%   section 4.1: 43 to 128 characters from [A-Z a-z 0-9 - . _ ~]).
%
%   Callers should normally use the public functions GENERATEOAUTH2STATE
%   and GENERATEPKCECODEVERIFIER, which both call this function with a
%   fixed 32 bytes (43 characters).
%
%   Encoding: Base64URL (RFC 4648 section 5) without '=' padding, so the
%   string uses only A-Z, a-z, 0-9, '-' and '_' and needs no escaping in
%   URLs. Everything is plain MATLAB (no Java, Python or MEX).
%
%   Random bytes come directly from the operating system's CSPRNG:
%     Linux >= 5.6  /dev/random  (blocks only until the kernel CRNG is
%                                 initialized at boot, like getrandom()).
%                                 Never falls back to /dev/urandom, which
%                                 does not wait for initialization (same
%                                 policy as OpenSSL's getrandom() path)
%     Linux < 5.6   /dev/urandom (old /dev/random blocks on an entropy
%                                 estimate and can hang). Once per MATLAB
%                                 session, 1 byte is first read from
%                                 /dev/random to wait until the kernel has
%                                 been seeded (as OpenSSL does on old
%                                 kernels); see waitForKernelSeeding
%     Linux, kernel version unreadable
%                   /dev/random  (may block on old kernels, but never
%                                 returns bytes from an unseeded pool)
%     macOS         /dev/urandom (identical to /dev/random)
%     Windows       .NET RNGCryptoServiceProvider -> Windows system RNG
%
%   On Linux/macOS, a read that returns no data is retried; the call fails
%   after 3 consecutive empty reads (as in OpenSSL). Any read that makes
%   progress resets the count.
%
%   The function keeps no random state between calls; reseeding and fork
%   safety are handled by the OS. Keep it that way: do not cache a file
%   handle or pre-generate a pool of bytes in a persistent/global variable,
%   and do not expand the output with your own generator or use it to seed
%   RNG/RAND.
%
%   Limitations:
%     - Returned values live in MATLAB memory, which cannot be reliably
%       wiped. Intermediate buffers are cleared on a best-effort basis.
%     - A restored VM snapshot can repeat OS RNG output unless the
%       hypervisor exposes a VM generation ID.
%     - On Windows, .NET is not available on thread-based workers
%       (parpool("Threads"), backgroundPool). Calls there fail with
%       generateSecureRandomBase64URL:noDotNet, or, in releases that refuse
%       to load this file on a thread worker (e.g. R2022b), with MATLAB's
%       own parallel:threadpool:* error. Use the client or process workers.
%
%   Generate a new value for every authorization request; never reuse one.
%
%   Error identifiers (all generateSecureRandomBase64URL:<id>):
%     badLength     N is outside 32..96
%     noDotNet      .NET is not available (Windows), including on
%                   thread-based workers
%     dotNetFailed  a .NET call failed (Windows); see the cause
%     noDevice      the OS random device could not be opened (Linux/macOS)
%     shortRead     the OS random device stopped returning bytes (after
%                   retries)
%     badOutput     the OS returned data that is clearly not random (all
%                   bytes equal)
%   Invalid N (not a real, numeric, whole-number scalar) raises
%   MATLAB:generateSecureRandomBase64URL:* from VALIDATEATTRIBUTES.
%
%   See also GENERATEOAUTH2STATE, GENERATEPKCECODEVERIFIER.

    % Copyright 2026 The MathWorks, Inc.

    if nargin < 1
        n = 32;
    end
    validateattributes(n, {'numeric'}, {'scalar', 'real', 'integer'}, ...
                       mfilename, 'N', 1);
    n = full(double(n));            % integer types saturate; sparse breaks .NET calls
    if n < minBytes() || n > maxBytes()
        error('generateSecureRandomBase64URL:badLength', ...
              ['%s needs between %d and %d random bytes (you asked for %.0f). ', ...
               'This keeps every result a valid PKCE code_verifier (43 to 128 ', ...
               'characters). Use the default of 32 bytes unless a longer value ', ...
               'is needed.'], ...
              mfilename, minBytes(), maxBytes(), n);
    end

    bytes = generateSecureRandomBytes(n);
    s = string(base64UrlEncode(bytes));
    bytes(:) = 0; %#ok<NASGU>                              best-effort wipe
end

% ---- Base64URL encoding ----------------------------------------------------

function c = base64UrlEncode(bytes)
%BASE64URLENCODE Encode a uint8 row as unpadded Base64URL (RFC 4648 section 5).
    alphabet = ['A':'Z', 'a':'z', '0':'9', '-', '_'];
    nBytes = numel(bytes);

    % Pad to a whole number of 3-byte groups; the extra characters this
    % produces are dropped at the end instead of being written as '='.
    padLen = mod(-nBytes, 3);
    groups = reshape([double(bytes(:)); zeros(padLen, 1)], 3, []);

    % Each 3-byte group is 24 bits, split into four 6-bit alphabet indices.
    bits24 = groups(1, :) * 65536 + groups(2, :) * 256 + groups(3, :);
    idx = [floor(bits24 / 262144); ...
           mod(floor(bits24 / 4096), 64); ...
           mod(floor(bits24 / 64), 64); ...
           mod(bits24, 64)];
    c = alphabet(idx(:)' + 1);
    c = c(1 : ceil(4 * nBytes / 3));

    groups(:) = 0; bits24(:) = 0; idx(:) = 0; %#ok<NASGU> best-effort wipe
end

% ---- OS random bytes -------------------------------------------------------

function b = generateSecureRandomBytes(n)
%GENERATESECURERANDOMBYTES N secure random bytes (1-by-N uint8) from the OS CSPRNG.
%   N is already validated by the caller (32..96).
    if ispc
        b = windowsRandomBytes(n);
    else
        b = unixRandomBytes(n);
    end

    if numel(b) ~= n
        error('generateSecureRandomBase64URL:shortRead', ...
              ['The operating system''s secure random number source returned only ', ...
               '%.0f of the %.0f bytes requested, so no value was returned. ', ...
               'Please try again. If this keeps happening, contact your system ', ...
               'administrator.'], numel(b), n);
    end
    checkOutput(b);
end

function b = windowsRandomBytes(n)
    % On thread-based workers (parpool("Threads"), backgroundPool)
    % NET.isNETSupported returns false in some releases (e.g. R2025a) and
    % throws in others (R2026b: parallel:threadpool:DisallowedSyntax), so
    % treat an error as "not supported". The message covers both causes.
    % (R2022b refuses to load this file on a thread worker, so this code
    % never runs there.)
    netCause = [];
    try
        netSupported = NET.isNETSupported;
    catch netCause
        netSupported = false;
    end
    if ~netSupported
        err = MException('generateSecureRandomBase64URL:noDotNet', ...
              ['Secure random numbers on Windows need the Microsoft .NET ', ...
               'Framework, which MATLAB cannot use here. If this code runs on a ', ...
               'thread-based pool (parpool("Threads") or backgroundPool), run it in ', ...
               'the MATLAB client or on a process-based pool (parpool("Processes")) ', ...
               'instead. Otherwise, install or enable .NET Framework 4.x (included ', ...
               'with Windows 10 and 11) and restart MATLAB.']);
        if ~isempty(netCause)
            err = addCause(err, netCause);
        end
        throw(err);
    end
    try
        % Construct the class directly rather than RandomNumberGenerator.Create(),
        % which resolves through CryptoConfig and can be remapped in machine.config.
        gen = System.Security.Cryptography.RNGCryptoServiceProvider();
        cleanupGen = onCleanup(@() gen.Dispose());
        buf = NET.createArray('System.Byte', n);
        cleanupBuf = onCleanup(@() System.Array.Clear(buf, 0, buf.Length));
        gen.GetBytes(buf);
        b = reshape(uint8(buf), 1, []);
    catch e
        err = MException('generateSecureRandomBase64URL:dotNetFailed', ...
            ['Windows could not generate secure random numbers, so no value ', ...
             'was returned. Please try again. If this keeps happening, contact ', ...
             'your system administrator. Details: %s'], e.message);
        err = addCause(err, e);
        throw(err);
    end
end

function b = unixRandomBytes(n)
    dev = randomDevice();
    if strcmp(dev, '/dev/urandom') && ~ismac
        waitForKernelSeeding();             % Linux < 5.6 only; see below
    end
    b = readDevice(dev, n);
end

function waitForKernelSeeding()
%WAITFORKERNELSEEDING Once per MATLAB session, block until the kernel has entropy.
%   Why: on Linux < 5.6 this code reads /dev/urandom, which never blocks
%   and, early in boot, can return bytes before the kernel CRNG has been
%   seeded. Such bytes look random but can be predictable, and nothing in
%   MATLAB can detect it. The proper check, getrandom(), is not callable
%   from MATLAB without a MEX file.
%
%   What: read and discard 1 byte from /dev/random. On these kernels that
%   read blocks until the kernel reports entropy available. After it
%   succeeds once, use /dev/urandom for the rest of the session. This is
%   OpenSSL's approach (wait_random_seeded() in rand_unix.c).
%
%   Alternatives considered:
%     - /dev/random for every read: on Linux < 5.6 it blocks whenever the
%       entropy estimate is low, even long after boot, and can hang MATLAB.
%     - MEX file calling getrandom(): the correct fix, but needs a compiled
%       binary per platform. This code is pure MATLAB by design.
%     - Checking entropy_avail, dmesg ("crng init done") or uptime:
%       unreliable or often not readable by unprivileged users.
%
%   Limitations:
%     - On kernels 4.8-5.5 a readable /dev/random is a strong hint but not
%       a guarantee that the CRNG behind /dev/urandom is seeded (OpenSSL
%       notes the same and relies on getrandom() there).
%     - The first call in a session can block if the system has only just
%       booted; MATLAB may not respond to Ctrl+C during that wait.
%     - If /dev/random cannot be opened, the call fails
%       (generateSecureRandomBase64URL:noDevice) rather than skipping the check.
%
%   The "seeded" flag is safe to cache: it is neither secret nor RNG state.
%   Clearing functions resets it, which only causes one more check.
    persistent seeded
    if isempty(seeded)
        probe = readDevice('/dev/random', 1);
        probe(:) = 0; %#ok<NASGU>                          discard; best-effort wipe
        seeded = true;
    end
end

function b = readDevice(dev, n)
%READDEVICE Read exactly N bytes from a random device, retrying empty reads.
    % No fallback to /dev/urandom: it does not wait for the kernel CRNG to be
    % initialized, so a missing /dev/random is an error, not a reason to
    % downgrade.
    [fid, msg] = fopen(dev, 'r');
    if fid < 0
        error('generateSecureRandomBase64URL:noDevice', ...
              ['MATLAB could not open the operating system''s secure random ', ...
               'number source (%s). Check that the device exists and that MATLAB ', ...
               'has permission to read it. In a container, make sure %s is ', ...
               'available. Details: %s'], dev, dev, msg);
    end
    cleanupFid = onCleanup(@() fclose(fid));   % never keep the handle open

    % Loop until all bytes arrive: a read can return fewer bytes than
    % requested. Retry empty reads, giving up after maxEmptyReads() in a row.
    b = zeros(1, n, 'uint8');
    pos = 0;
    emptyReads = 0;
    while pos < n
        chunk = fread(fid, n - pos, '*uint8');
        if isempty(chunk)
            emptyReads = emptyReads + 1;
            if emptyReads >= maxEmptyReads()
                details = ferror(fid);
                if isempty(details)
                    details = 'the device reported end of file';
                end
                error('generateSecureRandomBase64URL:shortRead', ...
                      ['The operating system''s secure random number source (%s) ', ...
                       'stopped responding after %.0f of the %.0f bytes requested ', ...
                       '(%d attempts in a row returned nothing), so no value was ', ...
                       'returned. Please try again. If this keeps happening, contact ', ...
                       'your system administrator. Details: %s'], ...
                      dev, pos, n, emptyReads, details);
            end
            pause(retryDelaySeconds());
            continue
        end
        emptyReads = 0;                                    % progress: reset the count
        b(pos+1 : pos+numel(chunk)) = chunk;
        pos = pos + numel(chunk);
        chunk(:) = 0; %#ok<NASGU>                          best-effort wipe
    end
end

function checkOutput(b)
%CHECKOUTPUT Catch catastrophic failures, e.g. the device mapped to /dev/zero.
%   Not a statistical test; that is the OS's job. False alarm odds for
%   random input: 2^(-8*(numel(b)-1)), at most 2^-248 for 32 bytes.
    if all(b == b(1))
        error('generateSecureRandomBase64URL:badOutput', ...
              ['The operating system''s secure random number source returned data ', ...
               'that is clearly not random (%.0f identical bytes), so it was not ', ...
               'used. This usually means the random device is misconfigured, for ', ...
               'example replaced by /dev/zero in a container. Contact your system ', ...
               'administrator. Details: every byte was 0x%02X.'], numel(b), b(1));
    end
end

function dev = randomDevice()
%RANDOMDEVICE Use /dev/random where it only blocks until boot-time init.
%   Only a kernel positively identified as < 5.6 gets /dev/urandom; if the
%   version cannot be determined, /dev/random is used (fail safe: it may
%   block, but never returns bytes from an unseeded pool).
%   Caching the device path is safe: it is neither secret nor RNG state.
    persistent cached
    if isempty(cached)
        if ismac
            cached = '/dev/urandom';
        else
            cached = '/dev/random';
            try
                rel = fileread('/proc/sys/kernel/osrelease');   % e.g. '6.8.0-45-generic'
                v = sscanf(rel, '%d.%d', 2);
                if numel(v) == 2 && (v(1) < 5 || (v(1) == 5 && v(2) < 6))
                    cached = '/dev/urandom';
                end
            catch
                % /proc not readable: keep /dev/random
            end
        end
    end
    dev = cached;
end

% ---- Constants -------------------------------------------------------------

function c = minBytes()
    c = 32;                         % ceil(4*32/3) = 43 characters (RFC 7636 minimum)
end

function c = maxBytes()
    c = 96;                         % ceil(4*96/3) = 128 characters (RFC 7636 maximum)
end

function c = maxEmptyReads()
    c = 3;                          % consecutive empty reads before failing (as OpenSSL)
end

function c = retryDelaySeconds()
    c = 0.05;
end
