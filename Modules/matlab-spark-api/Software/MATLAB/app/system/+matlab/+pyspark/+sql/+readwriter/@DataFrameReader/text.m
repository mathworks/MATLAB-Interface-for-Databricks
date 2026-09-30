function DF = text(obj, path)
    % text Read a dataframe from a text file.

    % Copyright 2024 MathWorks, Inc.
    arguments (Input)
        obj (1,1) matlab.pyspark.sql.readwriter.DataFrameReader
        path string
    end
    arguments (Output)
        DF (1,1) matlab.pyspark.sql.dataframe.Dataframe
    end

    % TODO: Add options according to this:
    % def text(
    %     self,
    %     paths: PathOrPaths,
    %     wholetext: bool = False,
    %     lineSep: Optional[str] = None,
    %     pathGlobFilter: Optional[Union[bool, str]] = None,
    %     recursiveFileLookup: Optional[Union[bool, str]] = None,
    %     modifiedBefore: Optional[Union[bool, str]] = None,
    %     modifiedAfter: Optional[Union[bool, str]] = None,
    % ) -> "DataFrame":
    DF = matlab.pyspark.sql.dataframe.Dataframe( ...
        obj.toPy.text(path)...
        );
end


