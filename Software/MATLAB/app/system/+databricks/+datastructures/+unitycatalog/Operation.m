classdef Operation < JSONEnum
    % Operation The operation performed against the volume data
    % Either READ_VOLUME or WRITE_VOLUME. If WRITE_VOLUME is specified, the credentials
    % returned will have write permissions, otherwise, it will be read only.
    %
    % Enumeration Values:
    %   READ_VOLUME
    %   WRITE_VOLUME

    % Copyright 2026 The MathWorks, Inc.

    enumeration
        READ_VOLUME  ("READ_VOLUME ")
        WRITE_VOLUME ("WRITE_VOLUME")
    end
end
