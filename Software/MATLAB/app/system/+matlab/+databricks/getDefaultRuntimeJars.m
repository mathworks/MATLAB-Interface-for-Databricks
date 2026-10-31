function [libObj] = getDefaultRuntimeJars()
    % GETDEFAULTRUNTIMEJARS Return a default jars for the Spark submission task
    %
    %   jars = getDefaultRuntimeJars();
    %
    % The return array of jars can be used for configuring a databricks.Job
    % object.

    %   (c) 2019-2023 MathWorks, Inc.

    MCRROOT = "/MATLAB_Runtime";
    % Define the usual set of jars
    % return them as a set of databricks.Libraries

    % TODO implement a non file: based approach

    jarList = [...
        ...['file:',MCRROOT,'/toolbox/mlhadoop/jar/a2.2.0/mwmapreduce.jar'],...
        "/toolbox/javabuilder/jar/javabuilder.jar",...
        "/toolbox/compiler/mlspark/jars/3.x/mlspark.jar",...
        "/toolbox/shared/bigdata/jar/hadoop.2.jar",...
        "/java/jar/toolbox/shared/bigdata.jar",...
        ];
    jarList = "file:" + MCRROOT + jarList;

    for jCount = 1:numel(jarList)
        libObj(jCount) = databricks.Library(); %#ok<AGROW>
        libObj(jCount).setType('jar');
        libObj(jCount).jar = jarList(jCount);  %#ok<AGROW>
    end
    
end %function
