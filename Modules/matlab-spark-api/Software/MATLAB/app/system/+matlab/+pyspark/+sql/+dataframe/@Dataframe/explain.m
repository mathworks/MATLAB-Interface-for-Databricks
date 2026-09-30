function explain(obj, options)
    % EXPLAIN Prints the (logical and physical) plans to the console for debugging purposes.
    %
    %Parameters
    %  extended[optional] logical, default false. If false, prints only the physical plan.
    %       When this is a string without specifying the mode, it works as the mode is specified.
    %
    %  mode[optional] string, specifies the expected output format of plans.
    %      simple: Print only a physical plan.
    %    extended: Print both logical and physical plans.
    %     codegen: Print a physical plan and generated codes if they are available.
    %        cost: Print a logical plan and statistics if they are available.
    %   formatted: Split explain output into two sections: a physical plan outline and node details.
    %
    % Examples:
    %   % Print out the physical plan only (default).
    %   df = spark.createDataFrame(py.str('[(14, "Tom"), (23, "Alice"), (16, "Bob")]'), schema=["age", "name"]);
    %   df.explain()
    %     == Physical Plan ==
    %     LocalTableScan [age#11461L, name#11462]
    %
    %   == Photon Explanation ==
    %   Photon does not fully support the query because:
    %         Unsupported node: LocalTableScan [age#11461L, name#11462].
    %
    %   Reference node:
    %         LocalTableScan [age#11461L, name#11462]
    %
    %
    %   % Print out all parsed, analyzed, optimized, and physical plans.
    %   df.explain(extended=true)
    %
    %
    %   % Print out the plans with two sections: a physical plan outline and node details.
    %   df.explain(mode="formatted")
    %
    %
    %   % Print a logical plan and statistics if they are available.
    %   df.explain(mode="cost")

    % Copyright 2026 MathWorks, Inc.

    arguments
        obj (1,1) matlab.pyspark.sql.dataframe.Dataframe
        options.extended (1,1) logical
        options.mode string {mustBeTextScalar, mustBeNonzeroLengthText}
    end

    if isfield(options, 'mode') && isfield(options, 'extended')
        error("SPARKAPI:DATAFRAME:explain_arguments", ...
            "For explain, only one of the arguments 'mode' and 'extended' can be used at a time.")
    end

    if isfield(options, 'mode')
        mode = lower(options.mode);
        mustBeMember(mode, ["simple", "extended", "codegen", "cost", "formatted"]);
    end

    if isfield(options, 'extended')
        obj.toPy.explain(extended=options.extended);
    elseif isfield(options, 'mode')
        obj.toPy.explain(mode=mode);
    else
        obj.toPy.explain();
    end
end

