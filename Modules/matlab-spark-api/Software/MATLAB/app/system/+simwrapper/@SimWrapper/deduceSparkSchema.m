function INFO = deduceSparkSchema(swo)
    % deduceSparkSchema Deduce Spark schema from I/O

    % Copyright 2015 MathWorks, Inc.

    arguments
        swo (1,1) simwrapper.SimWrapper
    end

    old = cd(swo.BaseFolder);
    goBack = onCleanup(@() cd(old));

    I = compiler.build.spark.schema.StructType();
    NI = numel(swo.Inports);
    for k=1:NI
        P = swo.Inports(k);
        % TODO: This will need to be changed if complex types are used
        tmpS = compiler.build.spark.schema.DataType.matlabClassToSchema(1.0, P.MLType);
        I.add(P.Name, tmpS);
    end

    O = compiler.build.spark.schema.StructType();
    NO = numel(swo.Outports);
    for k=1:NO
        P = swo.Outports(k);
        % TODO: This will need to be changed if complex types are used
        tmpS = compiler.build.spark.schema.DataType.matlabClassToSchema(1.0, P.MLType);
        O.add(P.Name, tmpS);
    end
    
    S = compiler.build.spark.schema.mathworks.CompilerType();
    S.addInput("I", I, true);
    S.addOutput("O", O, true);

    swo.Schema = S;

end