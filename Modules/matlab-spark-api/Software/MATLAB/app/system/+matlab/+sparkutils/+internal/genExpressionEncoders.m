function genExpressionEncoders(N)
    % genExpressionEncoders Generate expression encoders Scala code
    %
    % Shipping Spark only supports up to 5 return arguments for a tuple.
    % This function generates additional code, to be inserted into
    % SparkUtilityHelper.scala, that will have more versions.

    % Copyright 2022 The MathWorks, Inc.

    arguments
        N (1,1) double = 22
    end

    %     if matlab.sparkutils.isApacheSpark
    %         exprEncoder = "ExpressionEncoder";
    %     else
    %         exprEncoder = "BaseExpressionEncoder";
    %     end
    exprEncoder = "ExpressionEncoder";

    dstFolder = getSparkApiRoot(-1, 'Java', 'SparkUtility', 'src', 'main', 'scala', 'com', 'mathworks', 'spark', 'sql', 'encoders');
    if ~isfolder(dstFolder)
        mkdir(dstFolder);
    end
    dstFile = fullfile(dstFolder, 'MWEncoders.scala');
    SW = matlab.sparkutils.StringWriter(dstFile);

    SW.pf("/*\n");
    SW.pf(" * MWEncoders.scala\n");
    SW.pf(" * This file contains some utilities used by SparkBuilder, in order to create encoders more easily\n");
    SW.pf(" * in Java code.\n");
    SW.pf(" *\n");
    copyrightYear = datetime('now');
    SW.pf(" * Copyright 2022-%d The MathWorks, Inc. \n", copyrightYear.Year);
    SW.pf("*/\n\n");

    SW.pf('package com.mathworks.spark.sql.encoders\n');
    SW.pf('import org.apache.spark.sql.Encoder\n');
    SW.pf('import org.apache.spark.sql.catalyst.encoders.{encoderFor, %s => MWExprEncoder}\n\n', exprEncoder);

    SW.pf('object MWEncoders {\n\n');

    % SW.pf('def mwEncoderFor[A: Encoder]: ExprEncoder[A] =\n');
    % SW.pf('implicitly[Encoder[A]] match {\n');
    % SW.pf('case e: ExprEncoder[A] =>\n');
    % SW.pf('e.assertUnresolved()\n');
    % SW.pf('e\n');
    % SW.pf('case _ => throw new RuntimeException("Only expression encoders are supported for now.")\n');
    % SW.pf('}\n\n');


    for k=1:N
        idcs = 1:k;
        sIdcs = string(idcs);
        types = "T" + sIdcs;
        typeList = join(types, ", ");
        args = "e" + sIdcs;
        argTypes = args + ": Encoder[" + types + "]";
        eArgs = "x" + sIdcs;
        eArgsList = join(eArgs, ", ");
        argTypesList = argTypes.join("," + newline);
        SW.pf('\n/**\n * An encoder for %d-ary tuples.\n */\n', k);
        SW.pf('def tuple[%s](\n', typeList)
        SW.pf("%s): Encoder[(%s)] = {\n", argTypesList, typeList);
        for n=1:k
            SW.pf("val %s = encoderFor(%s)\n", ...
                eArgs(n), args(n));
            % SW.pf("val %s: MWExprEncoder[%s] = encoderFor(%s)\n", ...
            %     eArgs(n), types(n), args(n));
        end
        SW.pf("MWExprEncoder.tuple(Seq(%s))", eArgsList);
        SW.pf(".asInstanceOf[MWExprEncoder[(%s)]]\n", typeList)
        SW.pf("}\n\n")


        % def tuple[T1, T2, T3, T4, T5, T6](
        %     e1: Encoder[T1],
        %     e2: Encoder[T2],
        %     e3: Encoder[T3],
        %     e4: Encoder[T4],
        %     e5: Encoder[T5],
        %     e6: Encoder[T6]): Encoder[(T1, T2, T3, T4, T5, T6)] = {
        %     ExpressionEncoder.tuple(
        %       encoderFor(e1), encoderFor(e2), encoderFor(e3), encoderFor(e4), encoderFor(e5), encoderFor(e6))
        %   }
        %   def tupleEX[T1, T2, T3, T4, T5](
        %       e1: ExpressionEncoder[T1],
        %       e2: ExpressionEncoder[T2],
        %       e3: ExpressionEncoder[T3],
        %       e4: ExpressionEncoder[T4],
        %       e5: ExpressionEncoder[T5]): ExpressionEncoder[(T1, T2, T3, T4, T5)] =
        %     tuple(Seq(e1, e2, e3, e4, e5)).asInstanceOf[ExpressionEncoder[(T1, T2, T3, T4, T5)]]

    end

    SW.pf("}\n\n")
end