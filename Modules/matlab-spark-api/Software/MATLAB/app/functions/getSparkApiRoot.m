function rootStr = getSparkApiRoot(varargin)
    % getSparkApiRoot Return root of MATLAB Spark API project
    % getSparkApiRoot alone will return the root for the MATLAB code in the
    % project.
    %
    % getSparkApiRoot with additional arguments will add these to the path
    % 
    %  funDir = getSparkApiRoot('app', 'functions')
    %
    %  The special argument of a negative number will move up folders, e.g.
    %  the following call will move up two folders, and then into
    %  Documentation.
    %
    %  docDir = getSparkApiRoot(-2, 'Documentation')

    % Copyright MathWorks, 2020-2022

    here = fileparts(mfilename('fullpath'));

    rootStr = fileparts(fileparts(here));

    for k=1:nargin
        arg = varargin{k};
        if isstring(arg) || ischar(arg)
            rootStr = fullfile(rootStr, arg);
        elseif isnumeric(arg) && arg < 0
            for levels = 1:abs(arg)
                rootStr = fileparts(rootStr);
            end
        else
            error('SPARKAPI:getsparkapiroot_bad_argument', ...
                'Bad argument for getSparkApiRoot');
        end
    end

end

