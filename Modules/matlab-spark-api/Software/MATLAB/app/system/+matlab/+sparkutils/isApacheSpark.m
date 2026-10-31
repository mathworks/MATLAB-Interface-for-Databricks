function tf = isApacheSpark()
    % isApacheSpark Returns true if this is 'normal Spark'
    %
    % This function will return true for Apache Spark, and false otherwise.
    % The only other Spark supported currently is Databricks

    % Copyright 2022 The MathWorks, Inc.

    dbr = which('databricksRoot');
    tf = isempty(dbr);
end

