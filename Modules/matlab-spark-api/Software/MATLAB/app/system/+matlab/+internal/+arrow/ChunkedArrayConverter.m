classdef (Abstract) ChunkedArrayConverter < matlab.mixin.Heterogeneous
%CHUNKEDARRAYCONVERTER Base class that defines the interface for converting
% chunked arrow arrays to MATLAB arrays.

% Copyright 2026 The MathWorks, Inc.

    methods (Abstract, Access = protected)
        data = convertImpl(obj, chunkedArray)
    end

    methods
        function data = convert(obj, chunkedArray, combineChunks)
            arguments
                obj
                chunkedArray
                % Pass true if convert() should attempt to combine the 
                % individual chunks in the ChunkedArray into a single 
                % array before converting the chunkedArray into a MATLAB
                % type.
                % 
                % NOTE: In general, it's much faster to convert a
                % single-chunked ChunkedArray than it is to convert a
                % multi-chunked ChunkedArray, so passing combineChunks is
                % advised.
                combineChunks(1, 1) logical = true
            end
            if combineChunks
                chunkedArray = tryCombineChunks(chunkedArray);
            end
            data = obj.convertImpl(chunkedArray);
        end
    end
end

function output = tryCombineChunks(chunkedArray)
    try
        % combine_chunks() may error if the chunks cannot be
        % combined into a single array. 
        % 
        % For example, combine_chunks() will error if the underlying array
        % type is string and total number of characters in the string 
        % array exceeds 2 GB. combine_chunks() errors in this case because
        % arrow string arrays uses 32-bit integer offsets.
        output = chunkedArray.combine_chunks();
        output = py.pyarrow.chunked_array({output}, pyargs("type", chunkedArray.type));
    catch
        output = chunkedArray;
    end
end
