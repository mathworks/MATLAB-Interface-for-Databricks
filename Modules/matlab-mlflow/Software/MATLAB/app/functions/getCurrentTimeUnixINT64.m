function [ts] = getCurrentTimeUnixINT64()
    % GETCURRENTTIMEUNIXINT64 Return the current Unix time in milliseconds
    % Returns an INT64 timestamp in the number of milliseconds since the start
    % of the Unix time in the current timezone.
    %
    % This is equivalent to:
    % int64(posixtime(datetime('now','TimeZone','local'))*1e3)

    %  (c) 2020-2024 MathWorks, Inc.

    ts = int64(posixtime(datetime('now','TimeZone','local'))*1e3);

end %function
