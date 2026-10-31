function nullMask = getNullIndices(array, isChunkedArray)
%GETNULLINDICES Returns a logical mask representing the location of the
% null elements in the array.
%
% If isChunkedArray is true, then array must be an Arrow ChunkedArray 
% instance. Otherwise, array must be an Arrow Array instance.

% Copyright 2026 The MathWorks, Inc.

    if int64(array.null_count) == 0
        nullMask = logical.empty(1, 0);
        return;
    end

    if isChunkedArray
        boolChunkedArray = array.is_valid();
        concatenatedBoolArray = boolChunkedArray.combine_chunks();
        arrayOffset = int64(concatenatedBoolArray.offset);
        validBuffer = getBuffer(concatenatedBoolArray, 1);
    else
        validBuffer = getBuffer(array, 0);
        arrayOffset = int64(array.offset);
    end
    arrayLength = int64(py.len(array));
    nullMask = ~unpackBitPackedBuffer(validBuffer, arrayOffset, arrayLength);
end
