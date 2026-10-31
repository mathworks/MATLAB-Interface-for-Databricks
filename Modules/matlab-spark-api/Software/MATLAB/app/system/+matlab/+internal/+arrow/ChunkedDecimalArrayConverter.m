classdef ChunkedDecimalArrayConverter < matlab.internal.arrow.ChunkedPrimitiveArrayConverter
%CHUNKEDDECIMALARRAYCONVERTER Class for converting ChunkedArrays or
% DecimalArrays to MATLAB double arrays.

% Copyright 2026 The MathWorks, Inc.

    properties (Constant)
        DoubleConverter = matlab.internal.arrow.ChunkedFloatingArrayConverter("double")
    end

    methods (Access = protected)
        function matlabArray = allocateTypedVector(~, numElements)
            matlabArray = zeros([numElements 1], "double");
        end

        function matlabArray = convertRawData(obj, arrowArray)
            % NOTE: Importing DecimalArrays as MATLAB double arrays will
            % cause precision loss in some cases. However, it's not clear
            % what other MATLAB type to which DecimalArrays should be 
            % converted.
            doubleArray = arrowArray.cast("double");
            matlabArray = obj.DoubleConverter.convertRawData(doubleArray);
        end

        function matlabArray = setNullElements(~, matlabArray, nullIndices)
            matlabArray(nullIndices) = NaN;
        end      
    end
end