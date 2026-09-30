function childValues = getChildValues(chunkedArray, getChildArrayFcn, childType, childConverter)
%GETCHILDVALUES Extracts the values of a child array from the chunkedArray.

% Copyright 2026 The MathWorks, Inc.
    
    numChunks = int64(chunkedArray.num_chunks);
    chunks = cell([1 numChunks]);
    for ii = 1:numChunks
        chunks{ii} = getChildArrayFcn(chunkedArray.chunk(ii - 1));
    end
    chunkedArray = py.pyarrow.chunked_array(chunks, pyargs("type", childType));
    childValues = childConverter.convert(chunkedArray, false);
end