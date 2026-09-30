classdef SimulinkTempFileManager < handle
    % SimulinkTempFileManager Helper class for compiled Simulink
    %
    % This class is intended for use with Simulink Compiler in the context of
    % running libraries on Databricks. When running a Simulink model, certain
    % data will be saved to the hard disk, and on a system like Databricks, 
    % where workers are running in parallel, and potentially a large number of
    % simulations are run, this can cause disk space issues. This class helps
    % manage these issues by:
    %
    %   Enabling temporary directory rewiring to redirect temp files to a local
    %   disk directory, in this case `"/local_disk0/tmp`
    %
    %   Changing the current working directory to a temporary directory which is
    %   deleted after the simulation completes.
    %
    %   Clearing the Simulink Data Inspector (SDI) after simulation. This doesn't
    %   delete the SDI data completely, but will reduce its size.
    %
    %   Rewiring the Simulink Data Dictionary Cache (SLDDC) cache path to a
    %   local disk directory.
    %
    %   Furthermore, an option can be used to show disk usage at different stages.
    %   This is more for debugging purposes, and the output can be found on the
    %   cluster logs.

    % Copyright 2025-2026, The MathWorks Inc.

    properties (SetAccess = private)
        RewireTempdir (1,1) logical
        ChangePwd (1,1) logical
        ClearSDI (1,1) logical
        RewireSLDDC (1,1) logical
        ShowDiskUsage (1,1) logical

        OldPwd (1,1) string
        TempPwd (1,1) string
    end

    methods
        function obj = SimulinkTempFileManager(options)
            
            arguments
                options.rewireTempdir (1,1) logical = true
                options.changePwd (1,1) logical = true
                options.clearSDI (1,1) logical = true
                options.rewireSLDDC (1,1) logical = false
                options.showDiskUsage (1,1) logical = false
            end

            obj.RewireTempdir = options.rewireTempdir;
            obj.ChangePwd = options.changePwd;
            obj.ClearSDI = options.clearSDI();
            obj.RewireSLDDC = options.rewireSLDDC;
            obj.ShowDiskUsage = options.showDiskUsage;
                            
            setup(obj);
        end

        function setup(obj)
            if isdeployed && databricks.internal.isOnDatabricks()
                obj.log('SimulinkTempFileManager object is being created.\n');
                obj.log('Settings: %s\n', formattedDisplayText(obj));

                if obj.ShowDiskUsage
                    [~, duStr] = system('du -sh /a /tmp /local_disk0/tmp 2> /dev/null');
                    obj.log('Disk usage before starting\n%s\n', strtrim(duStr));
                end

                if obj.RewireTempdir
                    tmpFileName = "/local_disk0/tmp";
                    obj.log('rewiring temporary directory, %s.\n', tmpFileName);
                    setenv('TMPDIR', tmpFileName)
                end

                if obj.ChangePwd
                    obj.TempPwd = tempname('/local_disk0/tmp');
                    obj.log('moving to new temporary directory, %s.\n', obj.TempPwd);
                    mkdir(obj.TempPwd);
                    obj.OldPwd = cd(obj.TempPwd);
                end

                if obj.RewireSLDDC
                    obj.log('Rewiring SLDDC path\n');
                    cachePath = string(Simulink.data.dictionary.getCachePath());
                    obj.log('Current cache path, %s.\n', cachePath);
                    if ~isempty(regexp(cachePath, "^/tmp/data_model.+\.slddc$", "once"))
                        % Perform additional actions if cache path matches
                        tmpFileName = [tempname('/local_disk0/tmp'), '.slddc'];
                        obj.log('Rewiring cache path to %s.\n', tmpFileName);
                        Simulink.data.dictionary.setCachePath(tmpFileName);
                    end
                end

            end

        end

        function delete(obj)
            % Clean up resources or perform necessary actions before deletion
            if isdeployed && databricks.internal.isOnDatabricks()
                obj.log('SimulinkTempFileManager object is being deleted.\n');

                if obj.ClearSDI
                    obj.log('clearing SDI.\n');
                    Simulink.sdi.clear();
                end

                if obj.ChangePwd
                    obj.log('move back to old directory, %s.\n', obj.OldPwd);                    
                    cd(obj.OldPwd);

                    obj.log('delete temp directory, %s.\n', obj.TempPwd);
                    rmdir(obj.TempPwd, 's');
                end

                if obj.ShowDiskUsage
                    [~, duStr] = system('du -sh /a /tmp /local_disk0/tmp 2> /dev/null');
                    obj.log('Disk usage after cleanup\n%s\n', strtrim(duStr));
                end

            end
        end

        function log(obj, varargin)
            ts = string(datetime('now'));
            fprintf(2, "### %s - SimulinkTempFileManager: %s\n", ts, sprintf(varargin{:}));
        end
    end

end