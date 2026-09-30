function buffer = getBuffer(array, bufferIndex)
%GETBUFFER Extracts an underlying array buffer specified by a 0-based index.

% Copyright 2026 The MathWorks, Inc.

    % Use pyrun because it's faster than array.buffers{bufferIndex + 1}!
    expr = compose("b = a.buffers()[%d]", bufferIndex);
    buffer = pyrun(expr, "b", "a", array);
end
