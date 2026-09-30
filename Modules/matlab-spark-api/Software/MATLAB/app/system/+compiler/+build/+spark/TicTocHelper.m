classdef TicTocHelper < handle
    % TicTocHelper Helper class for generating tic/toc measurements

    % Copyright 2023 The MathWorks, Inc.

    properties
        Msg (1,1) string
        VarIdx (1,1) string
        SW (1,1) matlab.sparkutils.StringWriter
    end
    properties
        Finalized (1,1) logical = false;
        VarName (1,1) string
    end

    methods
        function obj = TicTocHelper(msg, idx, sw)
            obj.Msg = msg;
            obj.VarIdx = idx;
            obj.SW = sw;
            obj.VarName = "t_" + obj.VarIdx;

            initMeasurement(obj);
        end

        function initMeasurement(obj)
            obj.SW.pf("%% Measure time for %s\n", obj.Msg);
            obj.SW.pf("%s = tic;\n\n", obj.VarName);
        end

        function endMeasurement(obj)
            obj.SW.pf("fprintf(2, '%s: Elapsed time: %%f\\n', toc(%s));\n\n", obj.Msg, obj.VarName)
            obj.Finalized = true;
        end

        function delete(obj)
            if ~obj.Finalized
                obj.endMeasurement();
            end
        end

    end


end


