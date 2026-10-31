function offsets = getOffsetValues(chunkedArray, offsetConverter, getOffsetArrayFcn, getNumChildValuesFcn)
%GETOFFSETVALUES Extracts the offsets array from the chunkedArray of 
% containing variable-length arrow arrays (i.e. arrays whose elements
% may contain more than 1 value).

% Copyright 2026 The MathWorks, Inc.

    offsetType = getOutputOffsetType(chunkedArray, offsetConverter.Type, getNumChildValuesFcn);

    numArrayElements = int64(py.len(chunkedArray));
    offsets = ones([1 numArrayElements + 1], offsetType);

    currOffsetIndex = 1;
    lastIndexValue = cast(1, offsetType);
    numChunks = int64(chunkedArray.num_chunks);

    for ii = 0:numChunks - 1
        offsetArray = getOffsetArrayFcn(chunkedArray.chunk(ii));

        if py.len(offsetArray) > 0
            chunkedOffsetArray = py.pyarrow.chunked_array({offsetArray});
            chunkOffsets = cast(offsetConverter.convert(chunkedOffsetArray, false), offsetType);
            % Subtract the value of the first chunkOffsets value from the 
            % rest to ensure the chunkOffsets are zero-based.
            % Additionally, add the total number of offset values
            % processed so far.
            chunkOffsets = chunkOffsets(2:end) + lastIndexValue - chunkOffsets(1);

            startIdx = currOffsetIndex + 1;
            endIdx = numel(chunkOffsets) + currOffsetIndex;
            offsets(startIdx:endIdx) = chunkOffsets;
            lastIndexValue = offsets(endIdx);
            currOffsetIndex = endIdx;
        end
    end
    offsets = reshape(offsets, 1, []);
end

function offsetType = getOutputOffsetType(chunkedArray, inputOffsetType, getNumChildValuesFcn)
    if inputOffsetType == "int64"
        offsetType = "int64";
    elseif getTotalNumChildValues(chunkedArray, getNumChildValuesFcn) > int64(intmax("int32"))
        offsetType = "int64";
    else
        offsetType = "int32";
    end
end

function totalNumValues = getTotalNumChildValues(chunkedArray, getNumChildValuesFcn)
    numChunks = int64(chunkedArray.num_chunks);
    totalNumValues = int64(0);
    for ii = 0:numChunks-1
        totalNumValues = totalNumValues + getNumChildValuesFcn(chunkedArray.chunk(ii));
    end
end