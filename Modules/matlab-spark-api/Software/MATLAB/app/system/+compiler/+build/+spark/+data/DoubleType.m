classdef DoubleType < compiler.build.spark.data.FractionalType
    % DoubleType Implementation for types in Compiler workflow

    % Copyright 2024 The MathWorks, Inc.

     properties (Constant)
        BitWidth = 64;
     end
     
    methods
        function obj = DoubleType(varargin)
            obj@compiler.build.spark.data.FractionalType(varargin{:});
            obj.MATLABType = "double";
            obj.type = "double";
        end

        function val = val_MATLABTable(obj, val)
            % val_MATLABTable Convert column value to MATLAB value
            %
            % This is a helper function, that may be needed in case the normal
            % MATLAB conversion from Pandas Dataframe to a MATLAB table doesn't
            % convert everything from python values to MATLAB

            arguments
                obj (1,1) compiler.build.spark.data.DoubleType
                val
            end

            if isa(val, 'py.NoneType')
                val = nan;
            else
                val = double(val);
            end
        end
    end

end