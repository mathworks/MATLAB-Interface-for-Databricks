classdef (Abstract) ChunkedPrimitiveArrayConverter < matlab.internal.arrow.ChunkedArrayConverter
%CHUNKEDPRIMITIVEARRAYCONVERTER Base class for that defines the interface
%for converting chunked arrays of arrow primitive arrays to MATLAB arrays.

% Copyright 2026 The MathWorks, Inc.

    methods (Abstract, Access = protected)
        %allocateTypedVector    Allocates a column vector with numElements 
        % number of rows of the appropriate type
        matlabArray = allocateTypedVector(obj, numElements)

        %convertRawData     Convert arrow array to a MATLAB array.
        %   Converts an arrow array to a MATLAB array without taking the 
        %   null arrow aray elements into account. 
        matlabArray = convertRawData(obj, arrowArray)

        %setNullElements    Set the elements specified by nullIndices 
        % in matlabArray to a sentinel value representing null.
        matlabArray = setNullElements(obj, matlabArray, nullIndices)
    end

    methods (Access = protected)
        function matlabArray = convertImpl(obj, chunkedArray)            
            if int32(chunkedArray.num_chunks) == 1
                matlabArray = obj.doNonChunkedConversion(chunkedArray);
            else
                matlabArray = obj.doChunkedConversion(chunkedArray);
            end
        end
    end

    methods (Access = private)
        function matlabArray = doChunkedConversion(obj, chunkedArray)
            numChunks = int64(chunkedArray.num_chunks);
            numElements = int64(py.len(chunkedArray));
            matlabArray = obj.allocateTypedVector(numElements);

            dataIndexOffset = 0;
            for ii = 1:numChunks
                array = chunkedArray.chunk(ii - 1);
                arrayLength = int64(py.len(array));
                startIdx = 1 + dataIndexOffset;
                endIdx =  arrayLength + dataIndexOffset;
                matlabArray(startIdx:endIdx) = obj.convertRawData(array);
                dataIndexOffset = dataIndexOffset + arrayLength;
            end
            % Pass true because chunkedArray is a ChunkedArray.
            nullIndices = getNullIndices(chunkedArray, true);
            matlabArray = obj.setNullElements(matlabArray, nullIndices);
            matlabArray = reshape(matlabArray, [], 1);
        end

        function matlabArray = doNonChunkedConversion(obj, chunkedArray)
            % doNonChunkedConversion isinvoked  only if the chunkedArray
            % has exactly 1 chunk, so it's safe to extract the chunk at index 0.
            chunk = chunkedArray.chunk(0);
            matlabArray = obj.convertRawData(chunk);
            % Pass false because chunk not a ChunkedArray.
            nullMask = getNullIndices(chunk, false);
            matlabArray = obj.setNullElements(matlabArray, nullMask);
            matlabArray = reshape(matlabArray, [], 1);
        end
    end
end
